import keyboard  # For exit condition
import win32api
import win32con
from pynput import mouse
import time

def on_click(x, y, button, pressed):
    if pressed:
        print(f'pynput detected: {button}')

def main():
    # Start pynput listener
    listener = mouse.Listener(on_click=on_click)
    listener.start()
    
    print("Testing mouse buttons...")
    print("Click any mouse button to test")
    print("Press 'esc' to exit")
    
    while not keyboard.is_pressed('esc'):
        # Check win32api mouse buttons
        for button in range(32):  # Check first 32 virtual mouse buttons
            if win32api.GetAsyncKeyState(win32con.VK_LBUTTON + button) & 0x8000:
                print(f'win32api detected button {button}')
        time.sleep(0.1)
    
    listener.stop()

if __name__ == "__main__":
    main() 