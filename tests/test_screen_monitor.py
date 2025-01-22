import pytest
from PIL import Image, ImageDraw
import os
from datetime import datetime
from src.core.screen_checker import ScreenChecker
from scripts.screen_monitor import ScreenMonitor
from typing import Dict, Tuple, List
import sys
import json
import time
from unittest.mock import Mock, patch
from pynput.keyboard import Key, KeyCode

@pytest.fixture(scope="function")
def monitor_cleanup():
    """Fixture to ensure monitor is properly cleaned up after each test"""
    monitors = []
    def _register(monitor):
        monitors.append(monitor)
        return monitor
    yield _register
    for monitor in monitors:
        monitor.stop()

@pytest.fixture(scope="function")
def checker_cleanup():
    """Fixture to ensure screen checkers are properly cleaned up"""
    checkers = []
    def _register(checker):
        checkers.append(checker)
        return checker
    yield _register
    for checker in checkers:
        checker.cleanup()

class TestScreenMonitor:
    @pytest.fixture
    def screenshot_path(self):
        return os.path.join('tests', 'fixtures', 'screenshot4k.jpg')

    @pytest.fixture
    def layout_path(self):
        return 'scripts/layout.json'
        
    @pytest.fixture
    def profile_path(self):
        return 'scripts/profiles/rogue.json'

    @pytest.fixture
    def mock_image(self):
        # Create a test image with known conditions
        img = Image.new('RGB', (1920, 1080), color='black')
        return img

    @pytest.fixture
    def checker(self, mock_image):
        # Initialize checker with test layout and image
        checker = ScreenChecker("scripts/layout.json", test_image=mock_image)
        return checker

    def test_condition_detection(self, screenshot_path, layout_path):
        """Test that conditions are properly detected from the test image"""
        # Setup
        test_image = Image.open(screenshot_path)
        checker = ScreenChecker(layout_path, test_image=test_image)
        
        # Get initial conditions
        conditions = checker.check_conditions()
        
        # Save diagnostic images for each condition check
        os.makedirs("tests/outputs", exist_ok=True)
        for condition_id, condition in checker.conditions.items():
            # Create a copy of the region around this condition
            region_size = 50  # Size of region to capture around point
            region = test_image.crop((
                max(0, condition.x - region_size),
                max(0, condition.y - region_size),
                min(test_image.width, condition.x + region_size),
                min(test_image.height, condition.y + region_size)
            ))
            
            # Draw crosshair on the region
            draw = ImageDraw.Draw(region)
            relative_x = min(region_size, condition.x if condition.x < region_size else region_size)
            relative_y = min(region_size, condition.y if condition.y < region_size else region_size)
            
            # Draw yellow crosshair
            draw.line((relative_x - 10, relative_y, relative_x + 10, relative_y), fill='yellow', width=2)
            draw.line((relative_x, relative_y - 10, relative_x, relative_y + 10), fill='yellow', width=2)
            
            # Save with condition name and whether it was found
            found = condition_id in conditions
            filename = f"{condition_id}_{'found' if found else 'not_found'}.png"
            region.save(os.path.join("tests/outputs", filename))
        
        # Verify we detected at least one condition
        assert len(conditions) > 0, "No conditions detected in test image"
        
        # Print detected conditions for debugging
        print(f"\nDetected conditions: {conditions}")

    @pytest.mark.skip(reason="DXCam initialization is unstable in test environments")
    def test_dxcam_handling(self, layout_path):
        """Test that ScreenChecker handles dxcam initialization and cleanup gracefully"""
        # Create checker with test image first (should not initialize dxcam)
        test_image = Image.new('RGB', (100, 100), color='white')
        checker_with_image = ScreenChecker(layout_path, test_image=test_image)
        assert checker_with_image.camera is None, "DXCam should not be initialized when test image is provided"
        
        # Create checker without test image (should initialize dxcam)
        checker_no_image = ScreenChecker(layout_path)
        assert checker_no_image.camera is not None, "DXCam should be initialized when no test image is provided"
        
        # Test cleanup
        checker_no_image.cleanup()
        assert checker_no_image.camera is None, "DXCam camera should be None after cleanup"
        
        # Test that we can still use the checker with test image after cleanup
        conditions = checker_with_image.check_conditions()
        assert isinstance(conditions, list), "Should be able to check conditions with test image after cleanup"

    def test_trigger_state_behavior(self, screenshot_path, layout_path, monitor_cleanup):
        """Test that actions only occur when trigger is held"""
        # Setup
        test_image = Image.open(screenshot_path)
        checker = ScreenChecker(layout_path, test_image=test_image)
        
        # Get available conditions from test image
        available_conditions = checker.check_conditions()
        if not available_conditions:
            pytest.skip("No conditions detected in test image")
        
        test_condition = list(available_conditions)[0]
        
        # Create test profile with a condition we know exists
        test_profile = {
            "name": "Test Profile",
            "check_interval": 0.1,
            "actions": [
                {
                    "key": "3",
                    "conditions": [test_condition]
                }
            ]
        }
        
        # Write test profile to a temporary file
        test_profile_path = "tests/fixtures/test_profile.json"
        os.makedirs(os.path.dirname(test_profile_path), exist_ok=True)
        with open(test_profile_path, "w") as f:
            json.dump(test_profile, f)
        
        try:
            monitor = monitor_cleanup(ScreenMonitor(checker, test_profile_path, debug=True, test_mode=True))
            
            # Track executed actions
            executed_actions = []
            def mock_execute_action(action):
                executed_actions.append(action)
            monitor.execute_action = mock_execute_action
            
            # Test: No actions when monitoring inactive
            monitor.monitoring_active = False
            active_conditions = checker.check_conditions()
            action = monitor.get_next_action(active_conditions)
            if action:
                monitor.execute_action(action)
            assert len(executed_actions) == 0, "Actions executed while monitoring inactive"
            
            # Test: Actions occur when monitoring active
            monitor.monitoring_active = True
            active_conditions = checker.check_conditions()
            action = monitor.get_next_action(active_conditions)
            if action:
                monitor.execute_action(action)
            assert len(executed_actions) > 0, "No actions executed while monitoring active"
        
        finally:
            # Clean up
            if os.path.exists(test_profile_path):
                os.remove(test_profile_path)

    def test_multiple_conditions(self, screenshot_path, layout_path, monitor_cleanup):
        """Test that actions properly handle multiple required conditions"""
        # Setup
        test_image = Image.open(screenshot_path)
        checker = ScreenChecker(layout_path, test_image=test_image)
        
        # Get available conditions from test image
        available_conditions = list(checker.check_conditions())
        if len(available_conditions) < 2:
            pytest.skip("Not enough conditions detected in test image")
        
        condition1, condition2 = available_conditions[:2]
        
        # Create test profile with multiple conditions
        test_profile = {
            "name": "Multiple Conditions Test",
            "check_interval": 0.1,
            "actions": [
                {
                    "key": "1",
                    "conditions": [condition1, condition2]
                }
            ]
        }
        
        test_profile_path = "tests/fixtures/conditions_test.json"
        os.makedirs(os.path.dirname(test_profile_path), exist_ok=True)
        with open(test_profile_path, "w") as f:
            json.dump(test_profile, f)
            
        try:
            monitor = monitor_cleanup(ScreenMonitor(checker, test_profile_path, debug=True, test_mode=True))
            monitor.monitoring_active = True
            
            # Track executed actions
            executed_actions = []
            def mock_execute_action(action):
                executed_actions.append(action)
            monitor.execute_action = mock_execute_action
            
            # Test: Primary condition only
            active_conditions = [condition1]
            action = monitor.get_next_action(active_conditions)
            assert action is None, "Action executed with only primary condition"
            
            # Test: All conditions met
            active_conditions = [condition1, condition2]
            action = monitor.get_next_action(active_conditions)
            assert action is not None, "Action not executed with all conditions met"
            
        finally:
            # Clean up
            if os.path.exists(test_profile_path):
                os.remove(test_profile_path)

    def test_negated_conditions(self, screenshot_path, layout_path, monitor_cleanup):
        """Test that negated conditions (prefixed with !) work correctly"""
        # Setup
        test_image = Image.open(screenshot_path)
        checker = ScreenChecker(layout_path, test_image=test_image)
        
        # Get available conditions from test image
        available_conditions = list(checker.check_conditions())
        if len(available_conditions) < 2:
            pytest.skip("Not enough conditions detected in test image")
        
        condition1, condition2 = available_conditions[:2]
        
        # Create test profile with negated conditions
        test_profile = {
            "name": "Negated Conditions Test",
            "check_interval": 0.1,
            "actions": [
                {
                    "key": "1",
                    "conditions": [condition1, f"!{condition2}"]
                }
            ]
        }
        
        test_profile_path = "tests/fixtures/negated_conditions_test.json"
        os.makedirs(os.path.dirname(test_profile_path), exist_ok=True)
        with open(test_profile_path, "w") as f:
            json.dump(test_profile, f)
            
        try:
            monitor = monitor_cleanup(ScreenMonitor(checker, test_profile_path, debug=True, test_mode=True))
            monitor.monitoring_active = True
            
            # Track executed actions
            executed_actions = []
            def mock_execute_action(action):
                executed_actions.append(action)
            monitor.execute_action = mock_execute_action
            
            # Test: Condition met but negated condition also met (should not execute)
            active_conditions = [condition1, condition2]
            action = monitor.get_next_action(active_conditions)
            assert action is None, "Action executed when negated condition was met"
            
            # Test: Condition met and negated condition not met (should execute)
            active_conditions = [condition1]  # condition2 is not in the list
            action = monitor.get_next_action(active_conditions)
            assert action is not None, "Action not executed when conditions were correct"
            
        finally:
            # Clean up
            if os.path.exists(test_profile_path):
                os.remove(test_profile_path)

    def test_profile_validation(self, layout_path, screenshot_path, monitor_cleanup):
        """Test that invalid profiles are handled properly"""
        # Use test image to avoid dxcam initialization
        test_image = Image.open(screenshot_path)
        checker = ScreenChecker(layout_path, test_image=test_image)
        
        # Test: Missing required fields
        invalid_profile = {
            "name": "Invalid Profile"
            # Missing actions
        }
        
        test_profile_path = "tests/fixtures/invalid_profile.json"
        os.makedirs(os.path.dirname(test_profile_path), exist_ok=True)
        with open(test_profile_path, "w") as f:
            json.dump(invalid_profile, f)
            
        try:
            with pytest.raises(KeyError):
                monitor = monitor_cleanup(ScreenMonitor(checker, test_profile_path, debug=True, test_mode=True))
        finally:
            if os.path.exists(test_profile_path):
                os.remove(test_profile_path)

    def test_keyboard_toggle_behavior(self, checker):
        """Test keyboard toggle mode behavior"""
        # Initialize monitor in toggle mode
        monitor = ScreenMonitor(checker, "scripts/profiles/hunter.json", test_mode=True)
        monitor.trigger_mode = "toggle"
        
        # Initial state
        assert monitor.is_monitoring_active() == False, "Monitoring should start inactive"
        assert monitor.trigger_held == False, "Trigger should start not held"
        
        # First press
        monitor._on_key_press(KeyCode.from_char(monitor.keyboard_trigger))
        assert monitor.trigger_held == True, "Trigger should be held after press"
        assert monitor.is_monitoring_active() == True, "Monitoring should be active after first press"
        
        # First release
        monitor._on_key_release(KeyCode.from_char(monitor.keyboard_trigger))
        assert monitor.trigger_held == False, "Trigger should not be held after release"
        assert monitor.is_monitoring_active() == True, "Monitoring should stay active after release"
        
        # Press and hold (should not toggle while held)
        monitor._on_key_press(KeyCode.from_char(monitor.keyboard_trigger))
        assert monitor.trigger_held == True, "Trigger should be held"
        assert monitor.is_monitoring_active() == False, "Monitoring should toggle off on second press"
        
        # Multiple key events while held (should not affect state)
        monitor._on_key_press(KeyCode.from_char(monitor.keyboard_trigger))
        assert monitor.is_monitoring_active() == False, "Monitoring should not change while key is held"
        
        # Release
        monitor._on_key_release(KeyCode.from_char(monitor.keyboard_trigger))
        assert monitor.trigger_held == False, "Trigger should not be held after release"
        assert monitor.is_monitoring_active() == False, "Monitoring should stay inactive after release"

    def test_keyboard_hold_behavior(self, checker):
        """Test keyboard hold mode behavior"""
        # Initialize monitor in hold mode
        monitor = ScreenMonitor(checker, "scripts/profiles/hunter.json", test_mode=True)
        monitor.trigger_mode = "hold"
        
        # Simulate key press
        monitor._on_key_press(KeyCode.from_char(monitor.keyboard_trigger))
        assert monitor.is_monitoring_active() == True, "Monitoring should be active while key is held"
        
        # Simulate key release
        monitor._on_key_release(KeyCode.from_char(monitor.keyboard_trigger))
        assert monitor.is_monitoring_active() == False, "Monitoring should be inactive after release"

    def test_gamepad_toggle_behavior(self, checker):
        """Test gamepad toggle mode behavior"""
        # Initialize monitor in toggle mode
        monitor = ScreenMonitor(checker, "scripts/profiles/hunter.json", test_mode=True)
        monitor.trigger_mode = "toggle"
        monitor.gamepad_available = True
        
        # Simulate trigger press (value > 128)
        event = Mock()
        event.code = "ABS_RZ"
        event.state = 200
        monitor._monitor_gamepad_event(event)
        assert monitor.is_monitoring_active() == True, "Monitoring should be active after first trigger press"
        
        # Simulate trigger release
        event.state = 0
        monitor._monitor_gamepad_event(event)
        assert monitor.is_monitoring_active() == True, "Monitoring should stay active after release"
        
        # Simulate second trigger press
        event.state = 200
        monitor._monitor_gamepad_event(event)
        assert monitor.is_monitoring_active() == False, "Monitoring should be inactive after second press"
        
        # Simulate second trigger release
        event.state = 0
        monitor._monitor_gamepad_event(event)
        assert monitor.is_monitoring_active() == False, "Monitoring should stay inactive after release"

    def test_gamepad_hold_behavior(self, checker):
        """Test gamepad hold mode behavior"""
        # Initialize monitor in hold mode
        monitor = ScreenMonitor(checker, "scripts/profiles/hunter.json", test_mode=True)
        monitor.trigger_mode = "hold"
        monitor.gamepad_available = True
        
        # Simulate trigger press
        event = Mock()
        event.code = "ABS_RZ"
        event.state = 200
        monitor._monitor_gamepad_event(event)
        assert monitor.is_monitoring_active() == True, "Monitoring should be active while trigger is held"
        
        # Simulate trigger release
        event.state = 0
        monitor._monitor_gamepad_event(event)
        assert monitor.is_monitoring_active() == False, "Monitoring should be inactive after release"

if __name__ == "__main__":
    pytest.main([__file__, "-s"])