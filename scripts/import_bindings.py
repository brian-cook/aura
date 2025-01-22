from pathlib import Path
import json
import re
import sys

# Add project root to path to import config
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.append(str(PROJECT_ROOT))

from config import WOW_PATH

class WowBindingsParser:
    def __init__(self, account="YABUCHI"):
        # Build bindings path using WOW_PATH from config
        self.bindings_path = WOW_PATH / "WTF" / "Account" / account / "bindings-cache.wtf"
        if not self.bindings_path.exists():
            raise FileNotFoundError(f"Bindings file not found: {self.bindings_path}")
        
        # Set output path to scripts directory
        self.output_path = PROJECT_ROOT / "scripts" / "bindings.json"
    
    def parse_bindings(self):
        """Parse WoW bindings file into a dictionary"""
        bindings_data = {
            "metadata": {
                "account": self.bindings_path.parts[-2],
                "path": str(self.bindings_path)
            },
            "bindings": {}
        }
        
        with open(self.bindings_path, 'r', encoding='utf-8') as f:
            for line in f:
                if not line.strip():
                    continue
                    
                # Match "bind KEY ACTION" format
                match = re.match(r'bind\s+(\S+)\s+(\S+)', line.strip())
                if match:
                    key, action = match.groups()
                    # Group bindings by modifier keys
                    if '-' in key:
                        modifier, base_key = key.split('-', 1)
                        if base_key not in bindings_data["bindings"]:
                            bindings_data["bindings"][base_key] = {}
                        bindings_data["bindings"][base_key][modifier] = action
                    else:
                        if key not in bindings_data["bindings"]:
                            bindings_data["bindings"][key] = {}
                        bindings_data["bindings"][key]["default"] = action
        
        return bindings_data
    
    def save_json(self, output_path=None):
        """Save parsed bindings to JSON file"""
        bindings_data = self.parse_bindings()
        
        output_path = Path(output_path) if output_path else self.output_path
        with output_path.open('w', encoding='utf-8') as f:
            json.dump(bindings_data, f, indent=4)
        
        print(f"Bindings saved to {output_path}")
        return bindings_data

def main():
    try:
        parser = WowBindingsParser()
        data = parser.save_json()
        print("\nExample bindings:")
        # Show first 5 bindings
        for key, bindings in list(data["bindings"].items())[:5]:
            print(f"{key}: {bindings}")
    except FileNotFoundError as e:
        print(f"Error: {e}")
        print("Please check your WoW installation path in config.py")

if __name__ == "__main__":
    main()