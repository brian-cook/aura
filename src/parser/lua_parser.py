import json
from pathlib import Path
from typing import Dict, Any, OrderedDict
from collections import OrderedDict
from lupa import LuaRuntime
from ..core.containers import WeakAurasExport
import re

class LuaParser:
    def __init__(self, file_path: str):
        self.file_path = Path(file_path)
        self.lua = LuaRuntime(unpack_returned_tuples=True)
    
    def _lua_to_python(self, lua_obj) -> Any:
        """Convert Lua object to Python maintaining key order"""
        if lua_obj is None:
            return None
            
        try:
            # Check if it's a Lua table
            items = list(lua_obj.items())
            result = OrderedDict()  # Use OrderedDict instead of dict
            
            # Sort items based on their original order in the file
            original_order = self._get_key_order()
            if original_order:
                items.sort(key=lambda x: original_order.get(str(x[0]), float('inf')))
            
            for k, v in items:
                # Convert key and value recursively
                key = str(k)  # Convert key to string
                value = self._lua_to_python(v)
                result[key] = value
            return result
        except (AttributeError, TypeError):
            # Not a table, return the value directly
            return lua_obj
    
    def _get_key_order(self) -> Dict[str, int]:
        """Extract key order from original file"""
        with open(self.file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        order = {}
        index = 0
        # Match both ["key"] and key patterns
        for match in re.finditer(r'\["([^"]+)"\]|(\w+)\s*=', content):
            key = match.group(1) or match.group(2)
            if key and key not in order:
                order[key] = index
                index += 1
        return order
    
    def parse(self) -> WeakAurasExport:
        debug_info = {
            "parse_stats": {
                "file_size": len(self.file_path.read_bytes()),
                "addon_count": 0,
                "displays_found": 0
            },
            "structure": {
                "top_level_keys": [],
                "display_names": []
            }
        }
        
        try:
            with open(self.file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                self.lua.execute(content)
            
            result = self.lua.eval('WeakAurasSaved')
            python_data = self._lua_to_python(result)
            
            # Collect debug info
            debug_info["structure"]["top_level_keys"] = list(python_data.keys())
            if "displays" in python_data:
                displays = python_data["displays"]
                debug_info["parse_stats"]["displays_found"] = len(displays)
                debug_info["structure"]["display_names"] = list(displays.keys())
            
            addon_order = ["WeakAurasSaved"]
            addons = OrderedDict([("WeakAurasSaved", python_data)])
            debug_info["parse_stats"]["addon_count"] = len(addon_order)
            
        except Exception as e:
            debug_info["error"] = {
                "type": type(e).__name__,
                "message": str(e)
            }
            raise
        finally:
            print("\nPARSER_DEBUG:", json.dumps(debug_info, indent=2))
        
        return WeakAurasExport(addon_order=addon_order, addons=addons)