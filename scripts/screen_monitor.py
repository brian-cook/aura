import json
import time
import os
import sys
import argparse
from pathlib import Path
from typing import Dict, List, Optional, Any
import threading
import inputs
from pynput import keyboard
from pynput.keyboard import Key, Controller, Listener, KeyCode
from src.core.screen_checker import ScreenChecker

# Add project root to Python path
project_root = str(Path(__file__).resolve().parent.parent)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from config import INPUT_SETTINGS

class ScreenMonitor:
    def __init__(self, checker: ScreenChecker, profile_path: str, debug: bool = False, test_mode: bool = False):
        """Initialize the screen monitor with a checker and profile"""
        self.checker = checker
        self.keyboard = Controller()
        self.debug = debug
        self.running = True
        self.monitoring_active = False
        self.last_check = 0
        self.test_mode = test_mode
        
        # Load profile
        with open(profile_path, 'r') as f:
            self.profile = json.load(f)
            
        # Validate profile
        if "actions" not in self.profile:
            raise KeyError("Profile must contain 'actions' list")
            
        for action in self.profile["actions"]:
            if "key" not in action:
                raise KeyError("Each action must contain a 'key' field")
            if "conditions" not in action:
                raise KeyError("Each action must contain a 'conditions' list")
                
        # Load settings from config
        self.key_hold_duration = INPUT_SETTINGS["key_hold_duration"]
        self.check_interval = INPUT_SETTINGS["check_interval"]
        self.keyboard_trigger = INPUT_SETTINGS["keyboard_trigger"]
        self.trigger_mode = INPUT_SETTINGS.get("trigger_mode", "hold")  # Default to hold mode
        self.exit_key = INPUT_SETTINGS.get("exit_key", Key.esc)  # Default to escape key
        self.debug_key = INPUT_SETTINGS.get("debug_key", "u")  # Default to 'u' key
        
        # Initialize state
        self.trigger_held = False
        self.keyboard_listener = None
        self.gamepad_thread = None
        self.monitor_thread = None
        self.gamepad_available = False
        
        # In test mode, don't start monitoring
        if not test_mode:
            self.start()
    
    def _monitor_loop(self):
        """Main monitoring loop that runs in a separate thread"""
        while self.running:
            try:
                # Check conditions and execute actions if monitoring is active
                current_time = time.time()
                if self.is_monitoring_active() and (current_time - self.last_check) >= self.check_interval:
                    # Get current conditions
                    active_conditions = self.checker.check_conditions()
                    
                    # Get and execute next action if any
                    action = self.get_next_action(active_conditions)
                    if action:
                        self.execute_action(action)
                    self.last_check = current_time
                
                # Small sleep to prevent CPU hogging
                time.sleep(0.01)
                    
            except Exception as e:
                print(f"\nError in monitor loop: {str(e)}")
    
    def start(self):
        """Start monitoring (initialize keyboard, gamepad, and monitoring loop)"""
        # Initialize keyboard listener
        self.keyboard_listener = Listener(on_press=self._on_key_press, on_release=self._on_key_release)
        self.keyboard_listener.start()
        
        # Start the monitoring loop in a separate thread
        self.monitor_thread = threading.Thread(target=self._monitor_loop)
        self.monitor_thread.daemon = True
        self.monitor_thread.start()
        
        # Try to initialize gamepad
        try:
            inputs.get_gamepad()
            self.gamepad_available = True
            self.gamepad_thread = threading.Thread(target=self._monitor_gamepad)
            self.gamepad_thread.daemon = True
            self.gamepad_thread.start()
            print("Gamepad detected and monitoring started")
        except Exception as e:
            print("No gamepad detected, using keyboard controls only")
    
    def stop(self):
        """Stop monitoring and clean up resources"""
        self.running = False
        if self.keyboard_listener:
            self.keyboard_listener.stop()
        if self.gamepad_thread and self.gamepad_thread.is_alive():
            self.gamepad_thread.join(timeout=1.0)
        if self.monitor_thread and self.monitor_thread.is_alive():
            self.monitor_thread.join(timeout=1.0)
    
    def _on_key_press(self, key):
        """Handle keyboard press events"""
        if key == self.exit_key:
            self.running = False
            return False  # Stop listener
        elif hasattr(key, 'char') and key.char == self.keyboard_trigger:
            if not self.trigger_held:
                if self.trigger_mode == "toggle":
                    self.monitoring_active = not self.monitoring_active
                    print(f"Monitoring {'activated' if self.monitoring_active else 'deactivated'}")
                else:  # hold mode
                    self.monitoring_active = True
                    print("Monitoring activated")
            self.trigger_held = True
        elif self.debug and hasattr(key, 'char'):
            if key.char == 'p':
                print("Saving screen image...")
                self.checker.save_debug_image()
            elif key.char == self.debug_key:
                conditions = self.checker.check_conditions()
                if conditions:
                    print(f"Current conditions: {conditions}")
                else:
                    print("No conditions detected")
    
    def _on_key_release(self, key):
        """Handle keyboard release events"""
        if hasattr(key, 'char') and key.char == self.keyboard_trigger:
            if self.trigger_mode == "hold":
                self.monitoring_active = False
                print("Monitoring deactivated")
            self.trigger_held = False
    
    def _monitor_gamepad(self):
        """Monitor gamepad input in separate thread"""
        try:
            while self.running:
                events = inputs.get_gamepad()
                for event in events:
                    if event.code == "ABS_RZ":  # Right trigger axis
                        self._monitor_gamepad_event(event)
        except Exception as e:
            if self.gamepad_available:
                print(f"Gamepad error: {str(e)}")
                self.gamepad_available = False

    def _monitor_gamepad_event(self, event):
        """Handle a single gamepad event"""
        if event.code == "ABS_RZ":  # Right trigger axis
            new_state = event.state > 128
            if self.trigger_mode == "toggle":
                if new_state and not self.trigger_held:
                    self.monitoring_active = not self.monitoring_active
                    print(f"Monitoring {'activated' if self.monitoring_active else 'deactivated'}")
            else:  # hold mode
                self.monitoring_active = new_state
            self.trigger_held = new_state
    
    def is_monitoring_active(self):
        """Check if monitoring should be active"""
        return self.monitoring_active
    
    def get_next_action(self, active_conditions):
        """Get the next action to execute based on active conditions"""
        if not self.is_monitoring_active():
            return None

        for action in self.profile["actions"]:
            all_conditions_met = True
            for condition in action["conditions"]:
                if condition.startswith("!"):
                    condition_name = condition[1:]
                    if condition_name in active_conditions:
                        all_conditions_met = False
                        break
                else:
                    if condition not in active_conditions:
                        all_conditions_met = False
                        break
            
            if all_conditions_met:
                return action
        return None
    
    def execute_action(self, action: Dict[str, Any]):
        """Execute a keyboard action"""
        action_name = action.get('name', 'Name Missing')
        key = action['key']
        
        # Build condition status string
        active_conditions = self.checker.check_conditions()
        condition_status = []
        for condition in action['conditions']:
            if condition.startswith('!'):
                condition_name = condition[1:]
                is_met = condition_name not in active_conditions
                status = "FALSE" if is_met else "TRUE"
            else:
                is_met = condition in active_conditions
                status = "TRUE" if is_met else "FALSE"
            condition_status.append(f"{condition}: {status}")
        
        print(f"Executing: {action_name} [key: {key}]")
        print(f"Conditions: {', '.join(condition_status)}")
        
        # Handle modifier key combinations
        if key.startswith("SHIFT-"):
            actual_key = key[6:]  # Remove "SHIFT-" prefix
            self.keyboard.press(Key.shift)
            self.keyboard.press(actual_key)
            time.sleep(self.key_hold_duration)
            self.keyboard.release(actual_key)
            self.keyboard.release(Key.shift)
        elif key.startswith("CTRL-"):
            actual_key = key[5:]  # Remove "CTRL-" prefix
            self.keyboard.press(Key.ctrl)
            self.keyboard.press(actual_key)
            time.sleep(self.key_hold_duration)
            self.keyboard.release(actual_key)
            self.keyboard.release(Key.ctrl)
        else:
            self.keyboard.press(key)
            time.sleep(self.key_hold_duration)
            self.keyboard.release(key)
    
    def run(self):
        """Keep the program running until exit"""
        print("Starting monitor...")
        if self.gamepad_available:
            print(f"Using gamepad (right trigger) or keyboard ('{self.keyboard_trigger}' key)")
        else:
            print(f"Using keyboard controls ('{self.keyboard_trigger}' key)")
        print(f"Trigger mode: {self.trigger_mode}")
        exit_key_name = self.exit_key.name if hasattr(self.exit_key, 'name') else self.exit_key
        print(f"Press '{exit_key_name}' to exit")
        if self.debug:
            print(f"Press '{self.debug_key}' to show current conditions")
            print("Press 'p' to save a debug image")
        
        try:
            while self.running:
                time.sleep(0.1)
        except KeyboardInterrupt:
            print("\nStopping monitor.")
        finally:
            self.stop()

def main():
    parser = argparse.ArgumentParser(description='Screen condition monitor')
    parser.add_argument('--layout', '-l',
                      default='scripts/layout.json',
                      help='Path to layout JSON file')
    parser.add_argument('--profile', '-p',
                      default='scripts/profiles/hunter_classic_test.json',
                      help='Path to profile JSON file')
    parser.add_argument('--debug', '-d',
                      action='store_true',
                      help='Enable debug mode')
    args = parser.parse_args()

    try:
        checker = ScreenChecker(args.layout)
        monitor = ScreenMonitor(checker, args.profile, args.debug)
        monitor.run()
    except Exception as e:
        print(f"Error: {str(e)}")
        return 1
    return 0

if __name__ == "__main__":
    sys.exit(main())