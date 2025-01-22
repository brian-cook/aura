# Aura - Screen-Based Action Automation

## Overview
Aura is a Python-based automation tool that monitors screen conditions and executes keyboard actions based on those conditions. It integrates with World of Warcraft through a custom addon (AuraManager) and [WeakAuras2](https://github.com/WeakAuras/WeakAuras2) to automate actions based on in-game state indicators.

## WeakAuras Integration
This project integrates with [WeakAuras2](https://github.com/WeakAuras/WeakAuras2), a powerful World of Warcraft addon framework for displaying customizable graphics. Our integration:
- Creates compatible WeakAura definitions programmatically
- Uses WeakAuras' trigger system to detect game states
- Follows WeakAuras' addon structure and API conventions
- Maintains compatibility with WeakAuras version 78
- Leverages WeakAuras' display regions and animation system

### Template System
The project uses a strict template-based approach for WeakAura generation:
1. All visual properties come from `templates/sample.lua`
2. Individual auras MUST NOT modify visual properties
3. Only triggers and conditions should be customized
4. This ensures consistent appearance and behavior across all auras

## Core Components

### ScreenChecker (`src/core/screen_checker.py`)
- Monitors specific pixel colors on the screen
- Compares colors against defined conditions from a layout file
- Handles screen coordinate scaling for different resolutions
- Returns list of active conditions based on current screen state

### ScreenMonitor (`scripts/screen_monitor.py`)
- Main automation controller
- Loads action profiles and layout configurations
- Monitors gamepad input (right trigger) or keyboard ('r' key) for activation
- Executes keyboard actions when conditions are met

### AuraManager Addon (`AuraManager/`)
- Custom WoW addon that manages WeakAuras integration
- Provides in-game commands for WeakAura management:
  - `/am export` - Export auras to WeakAuras
  - `/am delete` - Delete all AuraManager auras
- Handles version compatibility with WeakAuras
- Manages combat lockdown restrictions
- Located in WoW's addon directory: `World of Warcraft/_retail_/Interface/AddOns/AuraManager`

### WeakAura Generation Tools

#### aura_generator.py
- Generates WeakAura Lua files using a template-based approach:
  1. Loads visual properties from `templates/sample.lua` (THE source of truth)
  2. Applies these consistent visual properties to all generated auras
  3. Only copies condition-specific information from each aura definition:
     - Triggers (what activates the aura)
     - Load conditions (when the aura should be loaded)
     - Class/spec restrictions
  4. Ensures all auras have consistent:
     - Visual appearance (size, colors, textures)
     - Animation settings
     - Frame properties
     - Sub-regions
  5. Any modifications to visual properties MUST be made in the template
- Creates grid-based layout for visual indicators
- Transforms WeakAuras data into addon-compatible format
- Outputs files to `AuraManager/auras/` directory
- Updates addon TOC file automatically

For example, when creating a new aura:
```lua
-- From templates/sample.lua (THE source of truth for visual properties)
-- DO NOT MODIFY THESE IN INDIVIDUAL AURAS
{
    width = 5,
    height = 5,
    frameStrata = 1,
    barColor = { 1, 0, 0, 1 },
    texture = "Solid",
    -- ... other visual settings
}

-- Your aura should ONLY define:
{
    triggers = {
        -- What activates this aura
    },
    load = {
        -- When to load this aura
    }
}
```

#### deploy_auras.py
- Copies generated WeakAuras to WoW's addon directory
- Ensures proper installation in SavedVariables
- Handles backup of existing WeakAuras
- Updates AuraManager configuration

#### import_bindings.py
- Imports key bindings configuration
- Maps in-game actions to keyboard keys
- Ensures consistency between WoW bindings and automation profiles

## Configuration Files

### Layout File (`scripts/layout.json`)
Defines screen locations and expected colors for various conditions:
```json
{
    "id": "power_40",
    "name": "Power 40%",
    "xOffset": 0,
    "yOffset": 0,
    "backgroundColor": {
        "r": 1.0,
        "g": 0.0,
        "b": 0.0,
        "a": 1.0
    }
}
```
- `id`: Unique identifier for the condition
- `xOffset/yOffset`: Position relative to screen center
- `backgroundColor`: Expected RGB color values (0.0-1.0)

### Profile Files (`scripts/profiles/*.json`)
Define actions and their required conditions:
```json
{
    "name": "Example Profile",
    "actions": [
        {
            "key": "1",
            "conditions": ["power_40", "combat", "enemy_in_melee_range"]
        },
        {
            "key": "2",
            "conditions": ["power_35", "!enemy_in_melee_range"]
        }
    ]
}
```
- `key`: Keyboard key to press
- `conditions`: List of condition IDs that must be true for the action to trigger
  - Regular conditions must be true (e.g., "power_40")
  - Conditions prefixed with "!" must be false (e.g., "!enemy_in_melee_range")

### WeakAuras Files (`AuraManager/auras/*.lua`)
Generated WeakAura definitions that create visual indicators:
- Each file represents a different condition (power, health, combat status, etc.)
- Uses grid-based layout system for consistent positioning
- Includes triggers and conditions for state tracking
- Example conditions:
  - `power_*.lua`: Power level indicators (5%, 10%, 20%, etc.)
  - `health_below_*.lua`: Health threshold indicators
  - `combat.lua`: Combat state indicator
  - `enemy_*.lua`: Enemy-related conditions

## Usage

### Initial Setup
1. Run `aura_generator.py` to create WeakAura definitions
2. Run `deploy_auras.py` to install to WoW addon directory
3. Run `import_bindings.py` to configure key bindings
4. Start WoW and use `/am export` to load WeakAuras
5. Verify indicators are visible and positioned correctly

### Running the Monitor
```bash
python scripts/screen_monitor.py [options]

Options:
  --layout, -l    Path to layout JSON file (default: scripts/layout.json)
  --profile, -p   Path to profile JSON file (default: scripts/profiles/rogue.json)
  --debug, -d     Enable debug mode
```

### Controls
- Right Trigger (gamepad) or 'r' key: Hold to activate monitoring
- ESC: Exit the program

## Development

### Project Structure
```
aura/
├── src/
│   └── core/
│       ├── screen_checker.py   # Core screen monitoring
│       └── containers.py       # Data structures
├── scripts/
│   ├── screen_monitor.py      # Main automation script
│   ├── aura_generator.py      # WeakAura generation
│   ├── deploy_auras.py        # WeakAura deployment
│   ├── import_bindings.py     # Key binding setup
│   ├── layout.json            # Screen layout definition
│   └── profiles/              # Action profiles
├── AuraManager/               # WoW addon files
│   ├── AuraManager.toc       # Addon manifest
│   ├── AuraManager.lua       # Core addon functionality
│   ├── aura_list.lua         # Generated aura registry
│   └── auras/                # Generated WeakAura files
├── tests/
│   └── test_screen_monitor.py # Test suite
└── requirements.txt           # Dependencies
```

### Testing
The project includes a comprehensive test suite that validates:
- Condition detection from screenshots
- Trigger state behavior
- Condition state consistency
- Multiple condition handling
- Profile validation
- WeakAura generation and deployment
- Addon integration

Run tests with:
```bash
python -m pytest tests/test_screen_monitor.py -v
```

### Dependencies
- PIL (Pillow): Image processing
- pynput: Keyboard control
- inputs: Gamepad input
- pytest: Testing
- lupa: Lua script parsing and validation

## Key Features
1. Resolution Independence: Automatically scales to any screen resolution
2. Gamepad Support: Uses right trigger for activation
3. Debug Mode: Detailed logging of conditions and actions
4. Profile System: Easily create different action sets
5. Robust Error Handling: Graceful handling of input/output errors
6. WoW Integration: Direct integration with WeakAuras
7. Automated Setup: Tools for WeakAura generation and deployment
8. Grid-based Layout: Consistent positioning of visual indicators

## Common Use Cases
1. Automating repetitive actions in World of Warcraft
2. Creating conditional key press sequences based on game state
3. Monitoring UI state changes through WeakAuras
4. Testing game interfaces and WeakAura configurations

## Limitations
1. Color detection is sensitive to screen variations
2. Requires consistent UI element positions
3. Limited to keyboard output actions
4. Single trigger activation only
5. Requires WeakAuras addon
6. Specific to World of Warcraft integration
7. Must run WeakAura generation/deployment when conditions change

## Contributing
1. Use the test suite to validate changes
2. Follow existing code structure
3. Update layout.json for new conditions
4. Create profiles for testing
5. Test WeakAura generation and deployment
6. Verify addon functionality in-game
7. Update WeakAura templates as needed

### Game State Expression
WeakAuras allows us to create visual indicators for various game states. Each state is represented by a colored region on screen that our monitor can detect:

#### Available State Types
1. Resource Levels
   - Power (Energy, Rage, Mana): Thresholds like 20%, 40%, 60%
   - Health: Below certain percentages
   - Combo Points: Specific numbers (1-5)
   - Holy Power, Soul Shards, etc.

2. Combat Status
   - In Combat
   - Target Selected
   - Enemy in Range
   - Spell Casting

3. Buffs and Debuffs
   - Player Buffs (Adrenaline Rush, Slice and Dice)
   - Target Debuffs (Rupture, Garrote)
   - Proc Effects (Clear Casting, Opportunity)

4. Cooldowns
   - Ability Ready/Not Ready
   - Buff/Debuff Duration Remaining
   - Time Until Resource Regeneration

Each state is configured in a WeakAura Lua file that:
1. Defines triggers for when the state is active
2. Creates a colored region at a specific screen position
3. Shows/hides based on the state being true/false

Example WeakAura for Power Level:
```lua
-- power_40.lua
{
    triggers = {
        {
            trigger = {
                type = "unit",
                unit = "player",
                use_powertype = true,
                powertype = 3, -- Energy
                use_percentpower = true,
                percentpower = "40",
                percentpower_operator = ">=",
            },
        },
    },
    load = {
        class = { ["ROGUE"] = true },
        use_combat = false,
    }
}
```

This creates a visual indicator that:
- Appears when Rogue energy >= 40%
- Shows at a specific position on screen
- Uses a consistent color we can detect
- Works in or out of combat