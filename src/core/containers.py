from typing import Dict, List, Any, Union, OrderedDict
from dataclasses import dataclass, field
from collections import OrderedDict
from slpp import slpp
import json

@dataclass
class MixedArray:
    """
    Represents a Lua table that contains both array elements and key/value pairs
    array_items: List of items with no explicit key (implicit numeric keys in Lua)
    dict_items: Dictionary of explicitly keyed items
    """
    array_items: List[Any] = field(default_factory=list)
    dict_items: Dict[str, Any] = field(default_factory=dict)

    def to_lua(self) -> str:
        """Convert to Lua table format"""
        parts = []
        
        # Add array items first (no keys)
        for item in self.array_items:
            if isinstance(item, dict):
                parts.append(self._dict_to_lua(item))
            else:
                parts.append(str(item))
                
        # Add dictionary items
        for key, value in self.dict_items.items():
            if isinstance(value, (int, float)):
                parts.append(f'["{key}"] = {value}')
            elif isinstance(value, bool):
                parts.append(f'["{key}"] = {str(value).lower()}')
            elif isinstance(value, str):
                parts.append(f'["{key}"] = "{value}"')
            elif isinstance(value, dict):
                parts.append(f'["{key}"] = {self._dict_to_lua(value)}')
            elif value is None:
                parts.append(f'["{key}"] = nil')
                
        return "{\n" + ",\n".join(parts) + "\n}"

    def _dict_to_lua(self, d: Dict[str, Any]) -> str:
        """Helper to convert a dictionary to Lua table syntax"""
        parts = []
        for k, v in d.items():
            if isinstance(v, (int, float)):
                parts.append(f'["{k}"] = {v}')
            elif isinstance(v, bool):
                parts.append(f'["{k}"] = {str(v).lower()}')
            elif isinstance(v, str):
                parts.append(f'["{k}"] = "{v}"')
            elif isinstance(v, dict):
                parts.append(f'["{k}"] = {self._dict_to_lua(v)}')
            elif isinstance(v, list):
                parts.append(f'["{k}"] = {{\n{",".join(map(str, v))}\n}}')
        return "{\n" + ",\n".join(parts) + "\n}"

    @classmethod
    def from_lua_table(cls, table_data: Dict[str, Any]) -> 'MixedArray':
        """
        Create MixedArray from parsed Lua table data
        Assumes numeric keys indicate array items
        """
        array_items = []
        dict_items = {}
        
        # Sort keys to ensure numeric keys are processed in order
        for key in sorted(table_data.keys(), key=lambda k: (isinstance(k, str), k)):
            value = table_data[key]
            if isinstance(key, int):
                array_items.append(value)
            else:
                dict_items[key] = value
                
        return cls(array_items=array_items, dict_items=dict_items)

@dataclass
class WeakAurasExport:
    def __init__(self, addon_order: List[str], addons: Dict[str, Any]):
        self.addon_order = addon_order
        self.addons = addons
    
    def _serialize_value(self, value: Any, indent_level: int = 0) -> str:
        """Serialize a value to WeakAuras Lua format"""
        indent = "\t" * indent_level
        
        if isinstance(value, dict):
            # Check if this is an array-like dict (all keys are consecutive integers starting from 1)
            is_array = all(isinstance(k, int) for k in value.keys()) and \
                      set(value.keys()) == set(range(1, len(value) + 1))
            
            if not value:
                return "{}"
            
            lines = []
            for k, v in value.items():
                # Skip the key for array items
                if is_array:
                    lines.append(f"{indent}{self._serialize_value(v, indent_level + 1)}")
                else:
                    # Quote all keys
                    key = f'["{k}"]' if isinstance(k, str) else f"[{k}]"
                    lines.append(f"{indent}{key} = {self._serialize_value(v, indent_level + 1)}")
            
            join_char = "," if is_array else ","
            return "{\n" + f"{join_char}\n".join(lines) + f"\n{indent[:-1]}}}"
            
        elif isinstance(value, list):
            if not value:
                return "{}"
            lines = [f"{indent}{self._serialize_value(v, indent_level)}" for v in value]
            return "{\n" + ",\n".join(lines) + f"\n{indent[:-1]}}}"
            
        elif isinstance(value, str):
            # Handle multiline strings (like custom scripts)
            if "\n" in value:
                # Escape newlines and quotes
                escaped = value.replace('"', '\\"').replace("\n", "\\n")
                return f'"{escaped}"'
            return f'"{value}"'
            
        elif isinstance(value, bool):
            return "true" if value else "false"
            
        elif value is None:
            return "nil"
            
        return str(value)
    
    def to_lua(self) -> str:
        """Convert to WeakAuras Lua format"""
        output = []
        
        debug_info = {
            "addons": len(self.addons),
            "format_checks": {
                "has_arrays": False,
                "has_scripts": False,
                "key_types": set()
            }
        }
        
        for addon_name in self.addon_order:
            addon_data = self.addons[addon_name]
            lua_table = self._serialize_value(addon_data)
            output.append(f"{addon_name} = {lua_table}")
            
            # Collect debug info
            debug_info["format_checks"]["has_arrays"] = any(
                isinstance(v, list) for v in addon_data.values()
            )
            debug_info["format_checks"]["has_scripts"] = any(
                isinstance(v, str) and "\n" in v
                for v in addon_data.values()
            )
            debug_info["format_checks"]["key_types"].update(
                type(k).__name__ for k in addon_data.keys()
            )
        
        print("\nSERIALIZE_DEBUG:", json.dumps(debug_info, default=str))
        
        return "\n\n".join(output)

    @classmethod
    def from_lua_file(cls, content: str) -> 'WeakAurasExport':
        """Parse Lua file content maintaining addon order"""
        addon_order = []
        addons = OrderedDict()
        
        # Simple regex to find addon declarations
        # You'll need more robust parsing in practice
        import re
        pattern = r"(\w+)\s*=\s*{([^}]+)}"
        for match in re.finditer(pattern, content, re.DOTALL):
            addon_name = match.group(1)
            addon_data = match.group(2)  # You'll need to properly parse this
            addon_order.append(addon_name)
            addons[addon_name] = addon_data  # This would be parsed data in practice
            
        return cls(addon_order=addon_order, addons=addons)