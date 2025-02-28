# Dynamic Action Selection for WeakAuras Automation

This component enhances the Aura project by replacing the sequential profile system with a dynamic decision-making system. Instead of following a predefined sequence of actions, the system analyzes the current game state and selects the optimal action based on class-specific strategies, available resources, and combat conditions.

## Overview

The Dynamic Action Selection Engine:

1. Continuously monitors the game state via WeakAuras displayed on screen
2. Evaluates possible actions based on the current situation
3. Scores each action according to class-specific strategies
4. Selects and executes the highest-scoring action

This approach offers significant advantages over sequential profiles:

- **Adaptive**: Responds to changing combat conditions in real-time
- **Resource-Efficient**: Only performs actions when they're optimal
- **Context-Aware**: Makes decisions based on comprehensive game state information
- **Customizable**: Can be tuned for different playstyles and priorities

## System Architecture

The system consists of four main components:

1. **State Monitor**: Collects and organizes information from WeakAuras displayed on screen
2. **Action Evaluator**: Scores possible actions based on the current state
3. **Decision Engine**: Selects the optimal action based on scores
4. **Action Executor**: Implements the selected action via key presses

![Architecture Diagram](debug_images/weakauras_state_diagram.svg)

## Getting Started

### Prerequisites

- Python 3.6+
- The core Aura project setup
- WeakAuras configured to display necessary state information

### Installation

1. Copy the decision engine files to your Aura project directory:
   - `decision_engine_prototype.py`
   - `integration_example.py`
   - `config_template.json`

2. Create a configuration file by copying and modifying the template:
   ```bash
   cp config_template.json config.json
   ```

3. Edit `config.json` to match your character's class, level, and available spells

### Configuration

The `config.json` file allows you to customize various aspects of the decision engine:

```json
{
  "player": {
    "class": "rogue",
    "level": 60,
    "available_spells": ["sinister_strike", "eviscerate", ...]
  },
  "key_mapping": {
    "sinister_strike": "1",
    "eviscerate": "2",
    ...
  },
  ...
}
```

Key sections include:

- **player**: Character information and available abilities
- **key_mapping**: Maps action names to keyboard keys
- **detection**: Settings for WeakAura detection
- **decision_engine**: Core engine parameters
- **class_specific**: Class-specific action evaluation settings
- **advanced**: Performance and simulation settings

### Running the System

To run the system as a standalone application:

```bash
python decision_engine_prototype.py --config config.json
```

To run the integration with the existing screen monitor:

```bash
python integration_example.py --config config.json
```

Add the `--debug` flag for detailed logging:

```bash
python integration_example.py --config config.json --debug
```

## Creating Class-Specific Evaluators

The system can be extended with class-specific action evaluators. Currently, a `RogueActionEvaluator` is implemented, but you can create evaluators for other classes by following the pattern:

1. Create a new class that inherits from `ActionEvaluator`
2. Implement the `evaluate_actions` method
3. Add class-specific evaluation logic

Example skeleton for a new class evaluator:

```python
class WarriorActionEvaluator(ActionEvaluator):
    def __init__(self, player_level: int):
        super().__init__()
        self.player_level = player_level
        self.action_weights = {
            "charge": 80,
            "mortal_strike": 85,
            # Add more actions...
        }
    
    def evaluate_actions(self, state_monitor: StateMonitor) -> List[Tuple[str, float, Optional[str]]]:
        scored_actions = []
        
        # Add evaluation logic here...
        
        return scored_actions
```

## WeakAura Requirements

The dynamic action system requires specific information from WeakAuras to function optimally. You'll need auras that provide:

1. **Unit Information**: Target and nameplate data
2. **Player State**: Health, resources, combo points, etc.
3. **Combat State**: In-combat status, threat levels, etc.
4. **Buff/Debuff Tracking**: Active effects on player and targets
5. **Range Information**: Distance to various units

See the `aura_analysis.md` file for details on required WeakAuras and integration opportunities.

## Performance Considerations

The decision engine is designed to be lightweight and performant:

- State updates and decisions are throttled to prevent CPU overuse
- The system maintains performance metrics to identify bottlenecks
- Configuration options allow for performance tuning

For optimal performance:

- Prioritize essential WeakAuras for detection
- Adjust update frequencies as needed
- Consider the "low_performance_mode" option for weaker systems

## Troubleshooting

Common issues and solutions:

- **No actions being performed**: Check key mappings and available_spells in config
- **Incorrect decisions**: Review class-specific evaluator logic
- **Poor performance**: Adjust throttling settings and update frequencies
- **WeakAura detection issues**: Verify aura visibility and detection regions

Check the log files for detailed error information:
- `decision_engine.log`: Engine-specific logs
- `integration.log`: Integration-specific logs

## Contributing

To contribute to the dynamic action selection system:

1. Review the project plan in `dynamic_action_selection.md`
2. Identify areas for improvement or extension
3. Create new class evaluators or enhance existing ones
4. Test thoroughly with different classes and scenarios
5. Submit improvements with detailed documentation

## License

This component is part of the Aura project and shares its licensing.

## Acknowledgments

- The Aura project team for the foundation
- WeakAuras developers for the powerful addon
- Contributors to the dynamic action selection system 