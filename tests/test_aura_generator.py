import pytest
import json
from pathlib import Path
from src.core.containers import MixedArray, WeakAurasExport
from scripts.aura_generator import AuraGenerator

def test_aura_visual_constraints():
    """
    This test demonstrates the core visual constraints of the aura system:
    - Auras must be positioned on a grid
    - Colors must be in RGBA format with values 0-1
    - Auras must not overlap
    """
    generator = AuraGenerator()
    
    # Create test auras based on actual WeakAuras.lua format
    test_auras = [
        {
            "id": "Combat",
            "sparkWidth": 10,
            "iconSource": -1,
            "authorOptions": {},
            "adjustedMax": "",
            "adjustedMin": "",
            "yOffset": 0,
            "anchorPoint": "CENTER",
            "sparkRotation": 0,
            "sparkRotationMode": "AUTO",
            "backgroundColor": {"1": 1, "2": 0, "3": 0, "4": 1},  # Dictionary format from Lua parser
            "triggers": [
                {
                    "trigger": {
                        "type": "unit",
                        "use_incombat": True,
                        "unit": "player",
                        "use_unit": True,
                        "debuffType": "HELPFUL",
                        "event": "Conditions",
                        "subeventPrefix": "SPELL",
                        "subeventSuffix": "_CAST_START",
                        "spellIds": {},
                        "names": {}
                    },
                    "untrigger": {}
                }
            ],
            "conditions": {},
            "load": {
                "use_never": False,
                "talent": {
                    "multi": {}
                },
                "spec": {
                    "multi": {}
                },
                "class": {
                    "multi": {
                        "DRUID": True
                    }
                },
                "size": {
                    "multi": {}
                }
            }
        },
        {
            "id": "Power",
            "sparkWidth": 10,
            "iconSource": -1,
            "authorOptions": {},
            "adjustedMax": "",
            "adjustedMin": "",
            "yOffset": -12,
            "anchorPoint": "CENTER",
            "sparkRotation": 0,
            "sparkRotationMode": "AUTO",
            "backgroundColor": {"1": 1, "2": 0, "3": 0, "4": 1},  # Dictionary format from Lua parser
            "triggers": [
                {
                    "trigger": {
                        "type": "unit",
                        "unit": "player",
                        "use_unit": True,
                        "debuffType": "HELPFUL",
                        "event": "Power",
                        "subeventPrefix": "SPELL",
                        "subeventSuffix": "_CAST_START",
                        "powertype": 3,
                        "use_powertype": True,
                        "use_percentpower": True,
                        "spellIds": {},
                        "names": {}
                    },
                    "untrigger": {}
                }
            ],
            "conditions": {
                "1": {
                    "check": {
                        "trigger": 1,
                        "variable": "percentpower",
                        "op": "<",
                        "value": "20"
                    },
                    "changes": {
                        "1": {
                            "value": {"1": 0, "2": 1, "3": 1, "4": 1},  # Dictionary format from Lua parser
                            "property": "backgroundColor"
                        }
                    }
                }
            },
            "load": {
                "use_never": False,
                "talent": {
                    "multi": {}
                },
                "spec": {
                    "multi": {}
                },
                "class": {
                    "multi": {
                        "ROGUE": True
                    }
                },
                "size": {
                    "multi": {}
                }
            }
        }
    ]
    
    transformed_auras = [
        generator._transform_aura_data(a["id"], a, i) 
        for i, a in enumerate(test_auras)
    ]
    
    # Verify grid positioning
    positions = [(a["xOffset"], a["yOffset"]) for a in transformed_auras]
    assert len(set(positions)) == len(positions), "Auras must not overlap"
    
    # Verify color format
    for aura in transformed_auras:
        # Colors should be dictionaries in our format
        assert isinstance(aura["backgroundColor"], dict), "Colors must be dictionaries"
        assert len(aura["backgroundColor"]) == 4, "Colors must have 4 components"
        for color_value in aura["backgroundColor"].values():
            assert 0 <= float(color_value) <= 1, "Color values must be between 0 and 1"
        
        # Also verify barColor if it exists
        if "barColor" in aura:
            assert isinstance(aura["barColor"], dict), "Bar colors must be dictionaries"
            assert len(aura["barColor"]) == 4, "Bar colors must have 4 components"
            for color_value in aura["barColor"].values():
                assert 0 <= float(color_value) <= 1, "Bar color values must be between 0 and 1"

def test_state_change_behavior():
    """
    This test demonstrates how aura states work:
    - Auras can have multiple visual states
    - Each state must have valid colors
    - States must be preserved in layout.json
    """
    # Create a temporary layout file path
    test_layout_path = Path("tests/fixtures/test_layout.json")
    test_layout_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Initialize generator with test layout path
    generator = AuraGenerator(layout_path=test_layout_path)
    
    test_aura = {
        "id": "StateTest",
        "xOffset": 0,
        "yOffset": 0,
        "backgroundColor": {"1": 1, "2": 0, "3": 0, "4": 1},
        "conditions": {
            "1": {
                "changes": {
                    "1": {
                        "property": "backgroundColor",
                        "value": {"1": 0, "2": 1, "3": 0, "4": 1}
                    }
                }
            }
        }
    }
    
    try:
        # Generate layout data
        generator._write_layout_json([test_aura])
        
        # Read generated layout
        with test_layout_path.open() as f:
            layout_data = json.load(f)
        
        # Verify state preservation
        aura_data = layout_data[0]
        assert "states" in aura_data, "State changes must be preserved"
        assert len(aura_data["states"]) > 1, "Multiple states must be preserved"
        
        # Verify color values
        assert aura_data["states"][0]["r"] == 1, "First state should be red"
        assert aura_data["states"][1]["g"] == 1, "Second state should be green"
    
    finally:
        # Clean up temporary file
        if test_layout_path.exists():
            test_layout_path.unlink()

def test_lua_structure_requirements():
    """
    This test demonstrates the required structure for generated Lua files:
    - Must be valid Lua syntax
    - Must follow addon namespace conventions
    - Must include required fields
    """
    generator = AuraGenerator()
    
    test_aura = {
        "id": "LuaTest",
        "triggers": {"1": {"trigger": {"type": "aura"}}},
        "load": {"class": {"ROGUE": True}}
    }
    
    transformed = generator._transform_aura_data("lua_test", test_aura, 0)
    
    # Generate Lua code
    lua_code = f"""
    local ADDON_NAME, ns = ...
    ns.auras = ns.auras or {{}}
    ns.auras["lua_test"] = {generator._format_lua_value(transformed)}
    """
    
    # Verify Lua validation
    assert generator._validate_lua(lua_code), "Generated Lua must be valid"
    
    # Verify required fields
    assert "id" in transformed, "Auras must have an id"
    assert "triggers" in transformed, "Auras must have triggers"
    assert "load" in transformed, "Auras must have load conditions"

def test_grid_layout_system():
    """
    This test demonstrates the grid-based layout system:
    - Auras are positioned based on their index
    - Grid uses configurable spacing
    - Positions are calculated from top-left
    """
    generator = AuraGenerator()
    
    # Create multiple auras to test grid positioning
    test_auras = [
        {"id": f"Grid{i}", "data": {}} for i in range(4)
    ]
    
    transformed = [
        generator._transform_aura_data(a["id"], a["data"], i)
        for i, a in enumerate(test_auras)
    ]
    
    # Verify grid properties
    positions = [(a["xOffset"], a["yOffset"]) for a in transformed]
    
    # Grid should flow left-to-right, top-to-bottom
    x_positions = [p[0] for p in positions]
    y_positions = [p[1] for p in positions]
    
    assert sorted(x_positions) == x_positions, "X positions should increase left to right"
    assert sorted(y_positions, reverse=True) == y_positions, "Y positions should increase top to bottom"

def test_lua_value_formatting():
    """
    This test demonstrates the Lua value formatting requirements:
    - Tables must be properly nested
    - Strings must be properly escaped
    - Numbers must be formatted correctly
    - Functions must use [[ ]] syntax
    """
    generator = AuraGenerator()
    
    # Test basic types
    assert generator._format_lua_value(True) == "true"
    assert generator._format_lua_value(42) == "42"
    assert generator._format_lua_value("test") == '"test"'
    
    # Test nested tables
    test_table = {
        "outer": {
            "inner": "value",
            "number": 42
        }
    }
    formatted = generator._format_lua_value(test_table)
    assert "outer" in formatted
    assert "inner" in formatted
    assert '"value"' in formatted
    assert "42" in formatted
    
    # Test function formatting
    func_str = "function() return true end"
    formatted_func = generator._format_lua_value(func_str)
    assert formatted_func.startswith("[[")
    assert formatted_func.endswith("]]")

def test_toc_file_structure():
    """
    This test demonstrates the required TOC file structure:
    - Must list all core files
    - Must list all generated aura files
    - Must maintain proper load order
    """
    # Create temporary test directory
    test_dir = Path("tests/fixtures/test_addon")
    test_auras_dir = test_dir / "auras"
    test_auras_dir.mkdir(parents=True, exist_ok=True)
    
    try:
        # Initialize generator with test directory
        generator = AuraGenerator()
        generator.output_path = test_auras_dir
        
        # Create test aura files in test directory
        (test_auras_dir / "test1.lua").touch()
        (test_auras_dir / "test2.lua").touch()
        
        generator._update_toc_file()
        
        toc_path = test_dir / "AuraManager.toc"
        assert toc_path.exists()
        
        content = toc_path.read_text()
        
        # Verify core files are listed first
        assert "AuraManager.lua" in content
        assert "aura_list.lua" in content
        assert content.index("AuraManager.lua") < content.index("auras/")
        
        # Verify aura files are listed
        assert "auras/test1.lua" in content
        assert "auras/test2.lua" in content
    
    finally:
        # Clean up test files
        import shutil
        if test_dir.exists():
            shutil.rmtree(test_dir) 