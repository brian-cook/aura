# Dynamic Action Selection Algorithm for WeakAuras Automation

## Table of Contents
1. [Project Overview](#project-overview)
2. [System Architecture](#system-architecture)
3. [Implementation Components](#implementation-components)
4. [Project Plan](#project-plan)
5. [Implementation Checklist](#implementation-checklist)
6. [Technical Requirements](#technical-requirements)
7. [Performance Considerations](#performance-considerations)
8. [Testing Strategy](#testing-strategy)
9. [Documentation](#documentation)

## Project Overview

### Current System Limitations
The current profile-based system uses a sequential list of actions with conditions, which has several limitations:
- Fixed priority system that can't adapt to changing combat situations
- Difficulty managing complex decision-making with multiple variables
- Limited ability to make context-aware choices
- Challenging to maintain and update for class changes

### Project Goals
This project aims to replace the sequential profile system with a dynamic decision engine that:
1. Intelligently selects the optimal action based on current game state
2. Adapts to changing combat situations in real-time
3. Makes contextually appropriate decisions based on multiple factors
4. Supports all classes and specializations with customized logic
5. Integrates with the existing WeakAuras and screen monitoring systems

### Benefits
- **Intelligent Decision-Making**: Context-aware action selection instead of fixed priority
- **Optimal Resource Usage**: More efficient management of player resources
- **Adaptability**: Better response to unexpected situations
- **Extensibility**: Easier to update for class changes or add new specializations
- **Maintainability**: Centralized decision logic in a structured framework

## System Architecture

The proposed system consists of four main components:

```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│ State Collection    │────▶│ Decision Engine     │────▶│ Action Execution    │
│ (WeakAuras & API)   │     │ (Python Algorithm)  │     │ (Key Press System)  │
└─────────────────────┘     └─────────────────────┘     └─────────────────────┘
          ▲                           │
          │                           │
          └───────────────────────────┘
                 Feedback Loop
```

1. **State Collection Module**: Enhanced screen_monitor.py that gathers comprehensive state information from visible WeakAuras
2. **Decision Engine**: Core algorithm that evaluates possible actions and selects the optimal one
3. **Class-Specific Evaluators**: Specialized modules containing class-specific action scoring logic
4. **Action Execution Interface**: Connection to the existing key press system

### Data Flow
1. WeakAuras display state information on screen
2. State Collection Module captures and processes this information
3. Decision Engine analyzes the state and evaluates possible actions
4. The highest-scored action is selected and executed
5. Screen is updated with new state information
6. Cycle repeats

## Implementation Components

### 1. Enhanced State Monitor

```python
class EnhancedStateMonitor:
    def __init__(self):
        self.unit_states = {}  # Detailed information about units
        self.player_state = {}  # Player resources, health, buffs
        self.party_states = {}  # Party member information
        self.combat_state = {}  # Overall combat situation assessment
        
    def update_all_states(self):
        """Collect all state information from visible WeakAuras"""
        self.update_unit_states()
        self.update_player_state()
        self.update_party_states()
        self.update_combat_state()
        
    def update_unit_states(self):
        """
        Collect information from unit-related auras
        - Target status (exists, health, casting)
        - Nameplate information (multiple targets)
        - Unit type information (humanoid, etc.)
        """
        # Implementation details...
        
    def get_nearest_range_aura(self, unit_id):
        """Find the smallest range at which the unit is visible"""
        # Implementation details...
```

### 2. Core Decision Engine

```python
class ActionDecisionEngine:
    def __init__(self, player_class, player_level, available_spells):
        self.player_class = player_class
        self.player_level = player_level
        self.available_spells = available_spells
        # Load class-specific decision algorithms
        self.action_evaluators = self._load_evaluators()
        
    def determine_best_action(self, state_monitor):
        """
        Determine the single best action based on current state
        Returns: (action_name, action_score, action_target)
        """
        scored_actions = []
        
        # Generate scored actions for different categories
        emergency_actions = self._evaluate_emergency_actions(state_monitor)
        offensive_actions = self._evaluate_offensive_actions(state_monitor)
        defensive_actions = self._evaluate_defensive_actions(state_monitor)
        utility_actions = self._evaluate_utility_actions(state_monitor)
        
        # Combine all action scores
        scored_actions.extend(emergency_actions)
        scored_actions.extend(offensive_actions)
        scored_actions.extend(defensive_actions)
        scored_actions.extend(utility_actions)
        
        # Get highest scored action
        if not scored_actions:
            return None, 0, None  # No valid actions
            
        # Sort by score (descending)
        scored_actions.sort(key=lambda x: x[1], reverse=True)
        return scored_actions[0]  # (action_name, score, target)
```

### 3. Class-Specific Evaluators

```python
class RogueActionEvaluators:
    def __init__(self, player_level):
        self.player_level = player_level
        self.action_weights = self._initialize_weights()
        
    def _initialize_weights(self):
        """Initialize base weights for all actions"""
        return {
            "sinister_strike": 70,
            "eviscerate": 80,
            "slice_and_dice": 85,
            "evasion": 90,
            # More actions...
        }
        
    def evaluate_combo_spenders(self, state_monitor):
        """Evaluate when to use combo point spenders"""
        scored_actions = []
        combo_points = state_monitor.player_state.get("combo_points", 0)
        target_health = state_monitor.unit_states.get("target", {}).get("health_percent", 100)
        
        # Decide between finishers based on context
        if combo_points >= 4:
            # Target about to die? Use Eviscerate
            if target_health < 20:
                scored_actions.append(("eviscerate", 90, "target"))
            # Slice and Dice not active? Prioritize it
            elif not state_monitor.player_state.get("slice_and_dice_buff", False):
                scored_actions.append(("slice_and_dice", 85, "self"))
            # Default to strong finisher
            else:
                scored_actions.append(("eviscerate", 80, "target"))
                
        return scored_actions
```

### 4. Action Execution Interface

```python
class ActionExecutor:
    def __init__(self, key_mapping):
        self.key_mapping = key_mapping  # Map action names to key presses
        
    def execute_action(self, action_name, target=None):
        """Execute the chosen action via key press"""
        if action_name in self.key_mapping:
            key_to_press = self.key_mapping[action_name]
            print(f"Executing action: {action_name} with key: {key_to_press}")
            # Use existing key press system
            press_key(key_to_press)
            return True
        return False
```

### 5. Required Additional WeakAuras

To implement this system effectively, additional WeakAuras will be needed for:

1. **Player Information Auras**
   - Detailed resource tracking (mana, energy, rage, etc.)
   - Buff/debuff duration tracking
   - Cooldown remaining information

2. **Party Member Auras**
   - Party member class detection
   - Party member health status
   - Party member buff status (for support decisions)

3. **Combat Analysis Auras**
   - Number of enemies in combat
   - Time-to-kill estimation
   - Incoming damage rate

## Project Plan

### Phase 1: Foundation and Research (2 weeks)
- Analyze existing auras in depth to understand available information
- Document class-specific action priorities and decision factors
- Design the core architecture for the decision engine
- Create detailed specifications for additional required WeakAuras
- Set up development and testing environment

### Phase 2: Core Implementation (3 weeks)
- Enhance screen_monitor.py to collect and process extended state information
- Implement the base ActionDecisionEngine class
- Develop the ActionExecutor interface to the existing key press system
- Create the first class-specific evaluator (e.g., Rogue) as a prototype
- Implement basic testing framework

### Phase 3: Expansion and Refinement (4 weeks)
- Create additional WeakAuras for extended state tracking
- Implement class-specific evaluators for all supported classes
- Develop specialized modules for different content types (solo, dungeons, raids)
- Enhance the decision engine with learning/adaptation capabilities
- Implement advanced performance optimization techniques

### Phase 4: Testing and Integration (2 weeks)
- Conduct thorough testing across different scenarios
- Performance profiling and optimization
- Integration with existing systems
- Documentation and user guide creation
- Final adjustments and refinements

### Phase 5: Deployment and Monitoring (1 week)
- Release the initial version
- Monitor performance and gather user feedback
- Address any issues or bugs
- Plan for future enhancements

## Implementation Checklist

### Phase 1: Foundation and Research
- [ ] Create comprehensive inventory of existing auras and their information
- [ ] Document available state information from screen_monitor.py
- [ ] Research optimal decision factors for each class/specialization
- [ ] Design class diagrams for the decision engine architecture
- [ ] Create specifications for new WeakAuras
- [ ] Set up development environment
- [ ] Create test scripts for system validation

### Phase 2: Core Implementation
- [ ] Enhance screen_monitor.py:
  - [ ] Add unit state collection
  - [ ] Add player state collection
  - [ ] Add party state collection
  - [ ] Add combat state analysis
- [ ] Implement ActionDecisionEngine:
  - [ ] Core action evaluation framework
  - [ ] Action scoring system
  - [ ] Action selection algorithm
- [ ] Implement ActionExecutor:
  - [ ] Key mapping system
  - [ ] Action execution interface
  - [ ] Feedback collection
- [ ] Create prototype for one class (e.g., Rogue):
  - [ ] Implement basic evaluators
  - [ ] Create test scenarios
  - [ ] Validate against existing profile system

### Phase 3: Expansion and Refinement
- [ ] Create additional WeakAuras:
  - [ ] Player information auras (resources, buffs, cooldowns)
  - [ ] Party member tracking auras
  - [ ] Combat analysis auras
- [ ] Implement class-specific evaluators:
  - [ ] Warrior evaluator
  - [ ] Paladin evaluator
  - [ ] Hunter evaluator
  - [ ] Rogue evaluator
  - [ ] Priest evaluator
  - [ ] Shaman evaluator
  - [ ] Mage evaluator
  - [ ] Warlock evaluator
  - [ ] Druid evaluator
- [ ] Enhance decision engine:
  - [ ] Add learning capabilities
  - [ ] Implement situational awareness
  - [ ] Create specialized content modules

### Phase 4: Testing and Integration
- [ ] Develop testing framework:
  - [ ] Unit tests for core components
  - [ ] Integration tests for system
  - [ ] Scenario-based tests for different content
- [ ] Performance optimization:
  - [ ] Profiling and bottleneck identification
  - [ ] Code optimization
  - [ ] Memory usage optimization
- [ ] Documentation:
  - [ ] System architecture documentation
  - [ ] User guide
  - [ ] Developer guide
  - [ ] API documentation

### Phase 5: Deployment and Monitoring
- [ ] Release preparation:
  - [ ] Final testing
  - [ ] Version control
  - [ ] Release notes
- [ ] Deployment:
  - [ ] Initial release
  - [ ] User training materials
- [ ] Monitoring:
  - [ ] Performance monitoring
  - [ ] Error tracking
  - [ ] User feedback collection

## Technical Requirements

### Development Environment
- Python 3.7+
- Testing framework (pytest)
- Simulation environment for WeakAuras state
- Profiling tools for performance analysis

### Dependencies
- OpenCV (for screen monitoring)
- NumPy (for computational efficiency)
- Pandas (for data analysis and state tracking)
- PyAutoGUI (for UI interaction)
- Logging framework

### Integration Points
- WeakAuras2 addon
- screen_monitor.py
- Key press system
- Configuration manager

## Performance Considerations

### Optimization Techniques
```python
def optimize_decision_cycle(self):
    """Optimize the decision cycle for performance"""
    # Use throttling to prevent excessive CPU usage
    if time.time() - self.last_decision < self.decision_interval:
        return
        
    # Cache expensive calculations
    if not self._should_recalculate_state():
        return self.last_decision_result
        
    # Use early termination for obvious decisions
    emergency_action = self._check_emergency_action()
    if emergency_action:
        return emergency_action
```

### Performance Requirements
- Decision cycle must complete in under 100ms
- State collection should be optimized to minimize CPU usage
- Memory usage should be kept under 200MB
- System should be able to run alongside WoW without causing performance issues

## Testing Strategy

### Unit Testing
- Test individual components (state collection, decision engine, action execution)
- Validate algorithm correctness with predefined scenarios
- Test boundary conditions and edge cases

### Integration Testing
- Test the complete system with simulated WeakAuras states
- Validate decision-making across different class scenarios
- Test compatibility with existing systems

### Performance Testing
- Measure decision cycle time under various conditions
- Profile memory usage and optimize as needed
- Test system under high load (many units, complex states)

### User Acceptance Testing
- Test with real gameplay scenarios
- Gather feedback on decision quality
- Compare to existing profile system

## Documentation

### System Architecture
- Detailed component diagrams
- Data flow documentation
- Integration points with existing systems

### User Guide
- Setup instructions
- Configuration options
- Troubleshooting guide

### Developer Guide
- Code structure overview
- How to add new class evaluators
- Extension points for future development

### API Documentation
- Interface specifications
- Function descriptions
- Class hierarchies

## Appendix

### Example Implementation: Rogue Combat Rotation

```python
class RogueCombatStrategy:
    def evaluate_actions(self, state):
        scored_actions = []
        
        # Get relevant state information
        combo_points = state.player_state.get("combo_points", 0)
        energy = state.player_state.get("energy", 0)
        target_health = state.unit_states.get("target", {}).get("health_percent", 100)
        slice_and_dice_active = state.player_state.get("slice_and_dice_buff", False)
        in_range = state.is_aura_visible("range_8")
        
        # First priority: Maintain Slice and Dice if we have combo points
        if combo_points >= 1 and not slice_and_dice_active:
            scored_actions.append(("slice_and_dice", 100, "self"))
            
        # Second priority: Sinister Strike to build combo points if we have energy
        if energy >= 45 and in_range and combo_points < 5:
            scored_actions.append(("sinister_strike", 80, "target"))
            
        # Third priority: Eviscerate to spend combo points
        if combo_points >= 4 and energy >= 35 and in_range:
            scored_actions.append(("eviscerate", 70, "target"))
            
        # Fourth priority: Use Blade Flurry if multiple targets
        if state.combat_state.get("nearby_enemies", 0) >= 2:
            scored_actions.append(("blade_flurry", 60, "self"))
        
        return scored_actions
```

### Adaptability Features

```python
class AdaptiveDecisionEngine(ActionDecisionEngine):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.action_history = []
        self.performance_metrics = {}
        
    def record_action_result(self, action, result_metrics):
        """Record the outcome of an action for learning"""
        self.action_history.append((action, result_metrics))
        self._update_action_weights(action, result_metrics)
        
    def _update_action_weights(self, action, metrics):
        """Adjust weights based on action performance"""
        # Simple reinforcement learning
        if metrics.get('was_successful', False):
            self.action_evaluators.boost_action_score(action, 0.05)
        else:
            self.action_evaluators.reduce_action_score(action, 0.05)
```

---

**Version**: 1.0.0  
**Last Updated**: 2023-04-15  
**Author**: System Development Team 