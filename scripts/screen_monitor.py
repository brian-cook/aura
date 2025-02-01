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

from config import INPUT_SETTINGS, MOVEMENT_SETTINGS

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
        
        # Key holding state
        self.currently_held_key = None
        self.current_hold_action = None
        
        # Movement state tracking
        self.movement_states = {
            "is_moving_forward": False,
            "is_moving_backward": False,
            "is_moving_left": False,
            "is_moving_right": False
        }
        self.keyboard_movement_keys = {
            key: KeyCode.from_char(value) 
            for key, value in MOVEMENT_SETTINGS["keyboard"].items()
        }
        self.pressed_keys = set()
        
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
    
    def _release_held_key(self):
        """Release any currently held key"""
        if self.currently_held_key:
            if isinstance(self.currently_held_key, tuple):
                # Release modifier key combinations
                modifier_key, actual_key = self.currently_held_key
                self.keyboard.release(actual_key)
                self.keyboard.release(modifier_key)
            else:
                # Release single key
                self.keyboard.release(self.currently_held_key)
            self.currently_held_key = None
            self.current_hold_action = None
            if self.debug:
                print(f"Released held key")
    
    def _monitor_loop(self):
        """Main monitoring loop that runs in a separate thread"""
        while self.running:
            try:
                # Check conditions and execute actions if monitoring is active
                current_time = time.time()
                if self.is_monitoring_active() and (current_time - self.last_check) >= self.check_interval:
                    # Get current conditions
                    active_conditions = self.checker.check_conditions()
                    
                    # Add movement conditions to active conditions
                    active_conditions.extend([
                        condition for condition, is_active in self.movement_states.items()
                        if is_active
                    ])
                    
                    # Get next action
                    action = self.get_next_action(active_conditions)
                    
                    # If we have a held key but no action or a different action,
                    # release the held key
                    if self.currently_held_key:
                        if not action or action != self.current_hold_action:
                            self._release_held_key()
                    
                    # Execute the action if we have one
                    if action:
                        self.execute_action(action)
                    
                    self.last_check = current_time
                elif not self.is_monitoring_active() and self.currently_held_key:
                    # Release held key if monitoring becomes inactive
                    self._release_held_key()
                
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
        self._release_held_key()  # Release any held keys before stopping
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
        elif not self.gamepad_available and key in self.keyboard_movement_keys.values():
            self.pressed_keys.add(key)
            self._update_keyboard_movement_states()
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
                # Also print movement states when debugging
                print(f"Movement states: {self.movement_states}")
    
    def _on_key_release(self, key):
        """Handle keyboard release events"""
        if hasattr(key, 'char') and key.char == self.keyboard_trigger:
            if self.trigger_mode == "hold":
                self.monitoring_active = False
                print("Monitoring deactivated")
            self.trigger_held = False
        elif not self.gamepad_available and key in self.keyboard_movement_keys.values():
            self.pressed_keys.discard(key)
            self._update_keyboard_movement_states()
    
    def _update_keyboard_movement_states(self):
        """Update movement states based on currently pressed keys"""
        if not self.gamepad_available:
            self.movement_states = {
                "is_moving_forward": self.keyboard_movement_keys["forward"] in self.pressed_keys,
                "is_moving_backward": self.keyboard_movement_keys["backward"] in self.pressed_keys,
                "is_moving_left": self.keyboard_movement_keys["left"] in self.pressed_keys,
                "is_moving_right": self.keyboard_movement_keys["right"] in self.pressed_keys
            }
    
    def _monitor_gamepad(self):
        """Monitor gamepad input in separate thread"""
        try:
            while self.running:
                events = inputs.get_gamepad()
                for event in events:
                    if event.code == "ABS_RZ":  # Right trigger axis
                        self._monitor_gamepad_event(event)
                    elif event.code == "ABS_X":  # Left stick X-axis
                        self._update_gamepad_movement_states(event, "horizontal")
                    elif event.code == "ABS_Y":  # Left stick Y-axis
                        self._update_gamepad_movement_states(event, "vertical")
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
    
    def _update_gamepad_movement_states(self, event, axis):
        """Update movement states based on gamepad stick position"""
        deadzone = MOVEMENT_SETTINGS["gamepad"]["stick_deadzone"]
        # Convert stick position to -1 to 1 range
        value = event.state / 32768.0
        
        if axis == "horizontal":
            self.movement_states["is_moving_left"] = value < -deadzone
            self.movement_states["is_moving_right"] = value > deadzone
        else:  # vertical
            self.movement_states["is_moving_forward"] = value < -deadzone
            self.movement_states["is_moving_backward"] = value > deadzone
    
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
        
        # If this is a different action than the current hold action,
        # release any currently held key
        if action != self.current_hold_action:
            self._release_held_key()
        
        # Handle different key modifiers
        if key.startswith("SHIFT-"):
            actual_key = key[6:]  # Remove "SHIFT-" prefix
            if key.startswith("HOLD-"):
                # For HOLD modifier, only press if not already holding this combination
                if self.currently_held_key != (Key.shift, actual_key):
                    self.keyboard.press(Key.shift)
                    self.keyboard.press(actual_key)
                    self.currently_held_key = (Key.shift, actual_key)
                    self.current_hold_action = action
            else:
                # Normal SHIFT behavior
                self.keyboard.press(Key.shift)
                self.keyboard.press(actual_key)
                time.sleep(self.key_hold_duration)
                self.keyboard.release(actual_key)
                self.keyboard.release(Key.shift)
        elif key.startswith("CTRL-"):
            actual_key = key[5:]  # Remove "CTRL-" prefix
            if key.startswith("HOLD-"):
                # For HOLD modifier, only press if not already holding this combination
                if self.currently_held_key != (Key.ctrl, actual_key):
                    self.keyboard.press(Key.ctrl)
                    self.keyboard.press(actual_key)
                    self.currently_held_key = (Key.ctrl, actual_key)
                    self.current_hold_action = action
            else:
                # Normal CTRL behavior
                self.keyboard.press(Key.ctrl)
                self.keyboard.press(actual_key)
                time.sleep(self.key_hold_duration)
                self.keyboard.release(actual_key)
                self.keyboard.release(Key.ctrl)
        elif key.startswith("HOLD-"):
            actual_key = key[5:]  # Remove "HOLD-" prefix
            # Only press if not already holding this key
            if self.currently_held_key != actual_key:
                self.keyboard.press(actual_key)
                self.currently_held_key = actual_key
                self.current_hold_action = action
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