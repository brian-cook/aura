# WeakAuras Scanner Test Plan

## Overview
This document outlines the testing strategy for WeakAuras scanner functionality, focusing on profile-driven testing, version-specific behavior, and comprehensive validation of mark management, state handling, and performance characteristics.

## Test Strategy

### 1. Profile-Based Testing
- Profile loading and validation
- Action group verification
- Condition evaluation
- Version-specific features

### 2. Core Functionality
- Scanner code loading and initialization
- Lua environment setup
- Basic API interaction
- State table management

### 3. Version-Specific Testing
#### Classic Era / Season of Discovery
- Threat levels (0-3)
- Debuff slot limitations
- Classic-specific abilities
- Hardcore mode features

#### Retail
- Percentage-based threat
- Modern targeting system
- Retail-specific mechanics
- Modern UI integration

### 4. Profile Components
#### Action Groups
- OOC Scanning
- Emergency Actions
- CC/Interrupt Management
- Combat Rotations
- Buff/Debuff Management

#### Condition Types
- Combat state
- Resource management
- Range requirements
- Target state
- Buff/debuff tracking

## Current Status

### Implemented Features
1. Basic scanner loading ✓
2. Profile integration ✓
3. Version detection ✓
4. Condition evaluation ✓
5. Action verification ✓

### In Progress
1. [ ] Hardcore mode validation
2. [ ] Complete condition coverage
3. [ ] Combat scenario simulation
4. [ ] Profile-specific test cases
5. [ ] Performance benchmarking

### Pending Implementation
1. [ ] Cross-version compatibility
2. [ ] Profile migration tools
3. [ ] Extended combat scenarios
4. [ ] State persistence validation
5. [ ] Memory optimization

## Test Categories

### 1. Unit Tests
- Individual condition evaluation
- Action validation
- State management
- API interaction

### 2. Integration Tests
- Profile execution
- Combat scenarios
- Multi-target handling
- State transitions

### 3. Performance Tests
- Resource usage
- State table size
- Update frequency
- Memory management

## Validation Requirements

### 1. Profile Validation
- JSON structure
- Action completeness
- Condition validity
- Group organization

### 2. Runtime Validation
- State consistency
- Combat behavior
- Target management
- Resource tracking

### 3. Version Compatibility
- API differences
- Feature availability
- Performance characteristics
- UI integration

## Success Criteria
1. Accurate profile execution
2. Consistent state management
3. Version-appropriate behavior
4. Performance within limits
5. Proper error handling

## Test Environment
1. Python 3.11+
2. Required packages:
   - pytest
   - lupa
   - typing
3. File structure:
   - AuraManager/auras/ (scanner code)
   - scripts/profiles/ (profile definitions)
   - tests/ (test suite)

## Future Improvements
1. Automated profile validation
2. Extended scenario coverage
3. Cross-version testing
4. Performance benchmarking
5. Profile migration support

## Known Limitations
1. Version-specific API differences
2. Combat simulation fidelity
3. UI interaction testing
4. Network latency simulation
5. Group coordination testing

## Documentation Requirements
1. Test coverage reports
2. Performance metrics
3. Version compatibility matrix
4. Profile validation guidelines
5. Debug logging standards

## Test Strategy

### 1. Core Functionality
- Scanner code loading and initialization
- Lua environment setup
- Basic API interaction
- State table management

### 2. Mark Management
- Priority-based mark assignment
- Mark persistence and updates
- Mark clearing and reassignment
- GUID tracking and validation

### 3. Target Handling
```python
# Key scenarios to test:
1. Initial target acquisition
2. Target switching behavior
3. Out-of-range handling
4. Dead target management
5. Multiple target priority
6. Dynamic target field changes
7. Nameplate range transitions
8. Combined target/nameplate tracking
```

### 4. Combat Integration
```python
# Test combat state transitions:
1. Pre-combat preparation
2. Combat initiation
3. Mid-combat updates
4. Combat exit cleanup
```

### 5. Cast Detection
```python
# Validate cast handling:
1. Cast start detection
2. Cast interruption
3. Priority casting
4. Multi-caster scenarios
```

### 6. Dynamic Scenarios
```python
# Test real gameplay conditions:
1. Player movement simulation
2. Rapid target switching
3. Units entering/leaving target field
4. Units entering/leaving nameplate range
5. Death during tracking
6. Combined state changes
```

## Performance Requirements

### 1. Execution Time
- Scanner execution < 100ms
- State updates < 50ms
- Mark assignments < 10ms

### 2. Memory Usage
- State table size < 1MB
- Garbage collection triggers < 1/minute
- Peak memory < 10MB

### 3. API Efficiency
- Max 10 API calls per update
- Throttling at 5 updates/second
- Cache hit rate > 90%

## Test Categories

### 1. Unit Tests
- Individual function validation
- State management verification
- Error handling coverage

### 2. Integration Tests
- Full scanner execution
- API interaction
- State persistence

### 3. Performance Tests
- Load testing (40 nameplates)
- Stress testing (rapid updates)
- Memory leak detection

### 4. Edge Cases
```python
# Critical scenarios:
1. Disconnection recovery
2. State corruption
3. API failures
4. Range limitations
5. Permission changes
```

## Validation Criteria

### 1. Functionality
- All mark assignments correct
- Priority system working
- State persistence maintained
- Error recovery successful

### 2. Performance
- Meets timing requirements
- Memory usage within limits
- API call efficiency
- No memory leaks

### 3. Reliability
- Consistent behavior
- Proper error handling
- State recovery
- Clean cleanup

## Test Implementation

### 1. Test Framework
```python
class ScannerTest:
    """Main test harness"""
    def __init__(self):
        self.wow_api = WoWAPIMock()
        self.lua = LuaRuntime()
        self.logger = TestLogger()

    def execute_test(self, scenario):
        """Run test scenario"""
        self.setup_environment()
        result = self.run_scenario(scenario)
        self.validate_results(result)
        self.cleanup()
```

### 2. Mock Components
```python
class WoWAPIMock:
    """WoW API simulation"""
    def __init__(self):
        self.units = {}
        self.marks = {}
        self.combat_state = False

    def simulate_combat(self):
        """Test combat transitions"""
        self.combat_state = True
        # Execute combat simulation
        self.combat_state = False
```

## Monitoring and Metrics

### 1. Performance Metrics
- Execution timing
- Memory usage
- API call counts
- State table sizes

### 2. Error Tracking
- Error types and frequency
- Recovery success rate
- State corruption incidents
- API failure handling

### 3. State Validation
- Mark consistency
- GUID tracking
- Priority maintenance
- Combat state accuracy

## Future Enhancements

### 1. Test Coverage
- Additional edge cases
- More complex scenarios
- Extended performance testing
- Network simulation

### 2. Automation
- Continuous integration
- Automated benchmarking
- Regression testing
- Performance trending

### 3. Documentation
- Test case documentation
- Performance baselines
- Troubleshooting guides
- Best practices

## Success Criteria
1. All tests passing
2. Performance within limits
3. No memory leaks
4. Proper error handling
5. Clean state management
6. Consistent behavior

## WoW API Mock Enhancement Plan

### 1. Unit Management
```python
# Core unit functions to implement:
1. UnitName(unit) -> str
2. UnitLevel(unit) -> int
3. UnitHealth(unit) -> int
4. UnitHealthMax(unit) -> int
5. UnitPower(unit, powerType) -> int
6. UnitPowerMax(unit, powerType) -> int
7. UnitIsPlayer(unit) -> bool
8. UnitIsEnemy(unit) -> bool
9. UnitIsFriend(unit) -> bool
10. UnitCreatureType(unit) -> str
```

### 2. Target and Focus Management
```python
# Target handling improvements:
1. GetTarget() -> str
2. SetTarget(unit) -> bool
3. GetFocus() -> str
4. SetFocus(unit) -> bool
5. TargetUnit(unit) -> bool
6. TargetNearestEnemy() -> bool
7. ClearTarget() -> None
```

### 3. Nameplate System
```python
# Nameplate functionality:
1. GetNamePlateForUnit(unit) -> table
2. GetNamePlates() -> table[]
3. SetNamePlateDistance(distance) -> None
4. NamePlateInRange(unit) -> bool
5. GetNumNamePlates() -> int
```

### 4. Combat State Management
```python
# Combat related functions:
1. IsInCombat() -> bool
2. UnitAffectingCombat(unit) -> bool
3. UnitThreatSituation(unit) -> int
4. UnitDetailedThreatSituation(unit) -> tuple
5. UnitIsTapDenied(unit) -> bool
```

### 5. Spell and Cast Management
```python
# Casting system improvements:
1. UnitCastingInfo(unit) -> tuple
2. UnitChannelInfo(unit) -> tuple
3. IsSpellInRange(spellName, unit) -> bool
4. SpellIsTargeting() -> bool
5. GetSpellCooldown(spellID) -> tuple
```

### 6. Unit State and Position
```python
# Position and state tracking:
1. UnitPosition(unit) -> tuple
2. UnitDistanceSquared(unit) -> float
3. UnitIsVisible(unit) -> bool
4. UnitIsConnected(unit) -> bool
5. UnitPhaseReason(unit) -> int
```

### 7. Group and Raid Management
```python
# Group functionality:
1. IsInRaid() -> bool
2. IsInGroup() -> bool
3. GetNumGroupMembers() -> int
4. GetRaidRosterInfo(index) -> tuple
5. UnitInRaid(unit) -> bool
```

### 8. Event System
```python
# Event handling:
1. RegisterEvent(event) -> None
2. UnregisterEvent(event) -> None
3. RegisterUnitEvent(event, unit) -> None
4. TriggerEvent(event, ...) -> None
```

### 9. World State
```python
# World state simulation:
1. GetInstanceInfo() -> tuple
2. IsOutdoors() -> bool
3. IsPVPActive() -> bool
4. GetZoneText() -> str
5. GetCurrentMapAreaID() -> int
```

### Implementation Priority:
1. Core unit and target functions
2. Nameplate system
3. Combat state management
4. Spell and cast handling
5. Position and range calculation
6. Event system
7. Group management
8. World state

### Success Criteria:
1. Accurate simulation of in-game behavior
2. Consistent state management
3. Proper event propagation
4. Realistic range and position handling
5. Performance within acceptable limits
```

## Priority Test Areas

### 1. GUID Management
- GUID tracking persistence across:
  - Target changes
  - Nameplate updates
  - Unit death/respawn
  - Combat transitions
  - Mark reassignment

### 2. Mark Management
```python
# Key marking scenarios to validate:
1. Initial mark assignment based on priority
2. Mark promotion/demotion based on state changes
3. Mark removal conditions:
   - Unit death
   - Combat end
   - Range limitations
   - State transitions
4. Mark reassignment during:
   - CC application
   - Interrupt requirements
   - Priority target changes
```

### 3. Combat Scenarios
```python
# Critical combat transitions to test:
1. Pull phase:
   - Initial target marking
   - Priority target identification
2. Add management:
   - Dynamic mark assignment
   - CC priority system
3. Emergency situations:
   - Health-based actions
   - Defensive cooldowns
4. State-based mark updates:
   - Casting unit promotion
   - CC target management
   - Interrupt priority
```

### 4. Profile-Specific Tests
- Hunter-specific scenarios:
  - Range-based CC conditions
  - Serpent Sting requirements
  - Multi-target CC management
- Rogue-specific scenarios:
  - Melee range requirements
  - Combo point conditions
  - Interrupt priority system

## Test Environment Requirements
1. WoW API Mock supporting:
   - Classic vs Retail differences
   - Unit state management
   - Combat simulation
   - Range calculations
   - State transitions

## Success Metrics
1. 100% GUID tracking accuracy
2. Zero orphaned marks
3. Consistent state transitions
4. Profile compliance
5. Error recovery

## Test Implementation

### 1. Core Unit Tests
```python
def test_guid_tracking():
    # Test GUID persistence
    unit = "nameplate1"
    guid = wow_api.UnitGUID(unit)
    assert scanner.GetTrackedGUID(unit) == guid
    
    # Test GUID cleanup
    wow_api.remove_unit(unit)
    assert scanner.GetTrackedGUID(unit) is None

def test_mark_management():
    # Test mark assignment
    wow_api.add_unit("boss", classification="worldboss")
    assert scanner.GetRaidTargetIndex("boss") == 8  # Skull
    
    # Test mark updates
    wow_api.set_unit_casting("boss", True)
    assert scanner.GetRaidTargetIndex("boss") == 8  # Maintain skull
```

### 2. Integration Tests
```python
def test_target_nameplate_sync():
    # Add test units
    wow_api.add_unit("nameplate1", is_casting=True)
    wow_api.add_unit("nameplate2", has_cc=True)
    
    # Test targeting
    wow_api.SetTarget("nameplate1")
    assert scanner.verify_target_action("interrupt")
    
    # Test nameplate tracking
    wow_api.set_nameplate_visible("nameplate2", True)
    assert scanner.GetRaidTargetIndex("nameplate2") == 2  # Circle
```

## Success Criteria

### 1. GUID Management
- Accurate GUID tracking across unit changes
- Proper GUID cleanup
- No orphaned GUIDs
- Correct GUID-unit mapping

### 2. Mark Management
- Consistent mark assignments
- Proper mark priorities
- Timely mark updates
- Clean mark removal

### 3. State Handling
- Accurate combat state tracking
- Proper CC management
- Cast detection and response
- Death state handling

### 4. Integration
- Seamless target/nameplate sync
- Consistent unit information
- Proper priority handling
- State consistency

## Test Environment

### WoW API Mock Requirements
```python
class WoWAPIMock:
    def __init__(self):
        self.units = {}
        self.guids = {}
        self.marks = {}
        self.combat_state = False
        self.casting_units = set()
        self.cc_units = set()
```

### Scanner Test Requirements
```python
class ScannerTest:
    def verify_guid_tracking(self):
        """Verify GUID tracking accuracy"""
        pass
        
    def verify_mark_management(self):
        """Verify mark assignment and updates"""
        pass
        
    def verify_state_handling(self):
        """Verify unit state management"""
        pass
```

## Implementation Priority
1. GUID tracking system
2. Mark management
3. State transitions
4. Target/nameplate integration
5. Action verification

## Metrics for Success
1. 100% GUID tracking accuracy
2. Zero orphaned marks
3. Consistent state handling
4. Clean integration
5. Proper error handling

## Test Profiles
- All test profiles must end with `_test` (e.g., `hunter_classic_test.json`, `rogue_classic_test.json`)
- Profiles define class-specific behaviors and priorities
- Each profile contains action groups for:
  - Combat state management
  - CC and interrupt priorities
  - Emergency actions
  - Buff/debuff management
  - Target scanning and marking


  Logging plan:
  
1. Add basic event logging for critical operations:
   - Target changes
   - Mark attempts (success/failure)
   - Combat state changes
   - Unit state changes (death, visibility)

2. Test format:
   ```
   [timestamp] EVENT_TYPE: {
     "details": {...},
     "state": {...relevant_state_snapshot...}
   }
   ```

3. Initial events to track:
   - MARK_ATTEMPT
   - MARK_SUCCESS
   - MARK_FAILURE
   - TARGET_CHANGE
   - COMBAT_CHANGE
   - UNIT_DEATH
```

1. Add state snapshots at key points:
   - Current target info
   - Active marks
   - Visible units
   - Scanner internal state

2. Focus on minimal, relevant data:
   - Only log changed state
   - Track GUID relationships
   - Record timing information
```

1. Add log analysis helpers:
   - Mark timing analysis
   - Target switching patterns
   - Failure pattern detection
   - State transition analysis

2. Create visualization tools:
   - Timeline of events
   - Mark/target correlation
   - Failure clusters