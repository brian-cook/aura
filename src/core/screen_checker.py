import pyautogui
from dataclasses import dataclass
from typing import Tuple, Dict, List
import json
import platform
from PIL import Image, ImageDraw
import dxcam
import numpy as np
import os
from datetime import datetime
import time
import sys
from pathlib import Path

# Add project root to Python path
project_root = str(Path(__file__).resolve().parent.parent.parent)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from config import WEAKAURAS_BASE_WIDTH, WEAKAURAS_BASE_HEIGHT

@dataclass
class Condition:
    id: str
    name: str
    x: int
    y: int
    color: Tuple[int, int, int, int]

class ScreenChecker:
    def __init__(self, layout_path: str, test_image: Image.Image = None):
        # Base resolution that the offsets are designed for
        self.BASE_HEIGHT = WEAKAURAS_BASE_HEIGHT
        self.BASE_WIDTH = WEAKAURAS_BASE_WIDTH
        
        # Load the test image dimensions
        self.screen_width, self.screen_height = pyautogui.size()
        
        # Calculate WeakAuras scaling factor
        self.scale_factor = (self.screen_width / self.BASE_WIDTH)
        
        # For compatibility with tests
        self.scale_factor_x = self.scale_factor
        self.scale_factor_y = self.scale_factor
        
        # Load and parse layout file
        with open(layout_path, 'r') as f:
            layout = json.load(f)
            
        # Convert layout to conditions
        self.conditions = {}
        
        # Calculate reference point (screen center)
        reference_x = self.screen_width // 2
        reference_y = int(self.screen_height // 2)
        
        for item in layout:
            # Scale the offsets using single scale factor
            scaled_x_offset = item['xOffset'] * self.scale_factor
            scaled_y_offset = item['yOffset'] * self.scale_factor
            
            # Convert to absolute screen coordinates
            x = reference_x + scaled_x_offset
            y = reference_y - scaled_y_offset
            
            # Create condition object
            color = tuple(int(c * 255) for c in item['backgroundColor'].values())
            self.conditions[item['id']] = Condition(
                id=item['id'],
                name=item['name'],
                x=int(x),
                y=int(y),
                color=color
            )
        
        # For testing, use the provided test image
        self.test_image = test_image
        self.camera = None
        
        # Initialize DXCam for production use
        if test_image is None:
            self.init_camera()

    def init_camera(self):
        """Initialize the dxcam camera if not already initialized"""
        if self.camera is None and self.test_image is None:
            try:
                self.camera = dxcam.create()
            except Exception as e:
                print(f"Warning: Failed to initialize dxcam: {str(e)}")
                self.camera = None
        return self.camera

    def cleanup(self):
        """Clean up resources, especially dxcam"""
        if self.camera is not None:
            try:
                # First try to release the camera
                self.camera.release()
            except Exception as e:
                print(f"Warning: Failed to release dxcam: {str(e)}")
            finally:
                # Always set camera to None, even if release fails
                self.camera = None
                
    def __del__(self):
        """Ensure cleanup on deletion"""
        try:
            self.cleanup()
        except Exception:
            pass  # Ignore cleanup errors during garbage collection

    def save_debug_image(self, screen=None):
        """Save the raw screen capture without any overlays or color conversion"""
        if screen is None and self.test_image is None:
            # Try to grab the screen a few times in case of temporary failures
            for attempt in range(3):
                try:
                    if self.camera is None:
                        self.init_camera()
                    screen = self.camera.grab()
                    if screen is not None:
                        break
                except Exception as e:
                    if attempt < 2:  # Don't sleep on last attempt
                        time.sleep(0.1)  # Short delay between attempts
            
            if screen is None:
                return
        
        try:
            # Convert directly to PIL Image without any color conversion
            if screen is not None:
                image = Image.fromarray(screen)
            else:
                image = self.test_image
            
            # Save with timestamp
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            os.makedirs("debug_images", exist_ok=True)
            image.save(f"debug_images/screen_debug_{timestamp}.png")
            
        except Exception:
            pass

    def check_conditions(self) -> List[str]:
        """Return list of all currently true conditions"""
        if self.test_image is not None:
            screen = self.test_image
        else:
            if self.camera is None:
                self.init_camera()
            if self.camera is None:  # Still None after init attempt
                return []
            screen = self.camera.grab()  # Returns numpy array in RGB format
            if screen is None:
                return []
        
        active = []
        for condition_id, condition in self.conditions.items():
            try:
                if self.test_image is not None:
                    screen_color = screen.getpixel((condition.x, condition.y))
                else:
                    pixel = screen[condition.y, condition.x]
                    screen_color = tuple(int(x) for x in pixel)  # Convert to tuple of ints
                
                if self._colors_match(screen_color, condition.color):
                    active.append(condition_id)
                
            except (IndexError, Exception):
                continue
        
        return active

    def _colors_match(self, color1: Tuple[int, ...], color2: Tuple[int, ...], tolerance: int = 5) -> bool:
        """Compare colors with tolerance for slight variations"""
        # Special case for green detection
        def is_green(color):
            r, g, b = color[:3]  # Take first 3 values in case there's alpha
            return (0 <= r <= 20) and (235 <= g <= 255) and (0 <= b <= 20)
        
        # If either color is green, check if both are green
        if is_green(color1) or is_green(color2):
            return is_green(color1) and is_green(color2)
        
        # For non-green colors, use the standard tolerance check
        return all(abs(c1 - c2) <= tolerance for c1, c2 in zip(color1[:3], color2[:3]))

    def debug_coordinates(self, condition_id: str) -> None:
        """Print debug information for a specific condition's coordinates"""
        condition = self.conditions[condition_id]
        center_x = self.screen_width // 2
        center_y = self.screen_height // 2
        
        print(f"Condition: {condition.name}")
        print(f"Screen resolution: {self.screen_width}x{self.screen_height}")
        print(f"Scale factors (x, y): {self.scale_factor}, {self.scale_factor}")
        print(f"Center point: ({center_x}, {center_y})")
        print(f"Final coordinates: ({condition.x}, {condition.y})")
        print(f"Offset from center: ({condition.x - center_x}, {condition.y - center_y})")

    def get_all_coordinates(self) -> Dict[str, Tuple[int, int]]:
        """Return a dictionary of all condition coordinates"""
        return {cond_id: (cond.x, cond.y) for cond_id, cond in self.conditions.items()}