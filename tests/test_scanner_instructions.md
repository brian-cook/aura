# Test Scanner Instructions

## Overview
This document provides instructions for running and developing tests for the WeakAuras scanner functionality, with specific focus on Classic Era vs Retail version differences.

## Running Tests

### Basic Usage
```bash
# Run with default classic version
python -m pytest tests/test_scanner.py --scanner scanner_test_2

# Run with retail version
python -m pytest tests/test_scanner.py --scanner scanner_test_2 --wow-version retail
```

### Test Environment Setup
1. Ensure Python 3.11+ is installed
2. Install required packages: `pytest`, `lupa`
3. Place scanner files in `AuraManager/auras/`
4. Available scanner files:
   - `scanner.lua`
   - `scanner_test.lua`
   - `scanner_test_2.lua`

## Version-Specific Features

### Classic Era (Default)
- Threat system: 0-3 levels
- No nameplate distance limit
- No focus frame functionality
- Basic targeting system
- Limited debuff slots
- No personal loot
- No warmode
- No mythic+

### Retail
- Percentage-based threat (0-100%)
- 60-yard nameplate distance limit
- Focus frame support
- Modern targeting system
- Unlimited debuff slots
- Personal loot system
- Warmode functionality
- Mythic+ support

## Test Categories

### 1. Core Functionality
- Scanner loading and initialization
- Lua environment setup
- Basic API interaction
- State table management

### 2. Version-Specific Testing
- Threat system behavior
- Nameplate visibility and range
- Target and focus management
- Combat mechanics

### 3. Profile-Based Testing
- Profile loading and validation
- Action condition verification
- Group-specific behavior testing
- Version-specific condition checks

## Debugging
- Test logs are stored in `tests/logs/`
- Each test run creates a timestamped log file
- Logs include environment details, test results, and error messages

## Test Categories

### 1. Profile-Based Testing
- Profile loading and validation
- Action condition verification
- Group-specific behavior testing
- Version-specific condition checks

### 2. Version-Specific Features
```python
def test_version_specific_behavior():
    """Test version-specific mechanics"""
    # Classic-specific tests
    if wow_version == "classic":
        test_threat_levels()  # 0-3 threat system
        test_classic_debuff_limits()
        
    # Retail-specific tests
    elif wow_version == "retail":
        test_threat_percentage()  # 0-100% threat
        test_modern_targeting()
```

### 3. Hardcore Mode Testing
```python
def test_hardcore_behavior():
    """Test hardcore-specific features"""
    if hardcore_mode:
        test_emergency_actions()  # Health potions, bandages
        test_defensive_abilities()  # Class-specific survival
```

### 4. Profile Action Groups
- OOC Scanning
- Emergency Actions
- CC Management
- Combat Rotations
- Buff/Debuff Management

## Profile Validation

### 1. Action Verification
- Condition evaluation
- Key binding validation
- Group organization
- Priority ordering

### 2. Condition Testing
```python
def verify_conditions():
    """Test condition evaluation"""
    test_conditions = [
        "combat",
        "target_exists",
        "health_under_50",
        "power_15",
        "range_8"
    ]
```

## Current Testing Goals

### 1. Version Compatibility
- [ ] Classic Era support
- [ ] Season of Discovery support
- [ ] Retail support
- [ ] Hardcore mode validation

### 2. Profile Features
- [ ] Complete condition coverage
- [ ] Action group validation
- [ ] Emergency action verification
- [ ] CC/Interrupt logic

### 3. Performance Testing
- [ ] Combat scenario simulation
- [ ] Multi-target handling
- [ ] State management efficiency
- [ ] Memory usage optimization

## Future Improvements
1. Automated profile validation
2. Extended combat scenarios
3. Cross-version compatibility checks
4. Profile migration tools
5. Performance benchmarking

## Debugging

### Logging
```python
# Enable detailed logging
logger = TestLogger.create("test_output.log")
scanner_test.set_logger(logger)

# Log state snapshots
scanner_test.take_state_snapshot()
```

### Common Issues
1. Version-specific API differences
2. Profile condition mismatches
3. State initialization failures
4. Combat state transitions
5. Range/positioning issues

## Adding New Tests

### Test Structure Template
```python
def test_new_feature(self):
    """Test description"""
    # Setup
    self.scanner_test.load_scanner_code(scanner_path)
    self.scanner_test.init_lua_env()
    
    # Test execution
    self.wow_api.add_unit("target")
    result = self.scanner_test.execute_scanner()
    
    # Verification
    assert result.success
    assert self.wow_api.get_raid_target_index("target") == expected_mark
```

### Best Practices
1. Clear test names and descriptions
2. Proper setup and teardown
3. Specific assertions
4. Comprehensive error messages
5. State cleanup after tests

## Performance Testing

### Metrics to Monitor
1. Execution time
2. Memory usage
3. State table sizes
4. API call frequency

### Load Testing
```python
def test_performance():
    """Test scanner performance"""
    for i in range(40):  # Max nameplate count
        wow_api.add_unit(f"nameplate{i}")
    
    start_time = time.time()
    scanner_test.execute_scanner()
    duration = time.time() - start_time
    
    assert duration < 0.1  # 100ms threshold
```

## Error Handling

### Test Cases
1. Invalid unit references
2. Missing state tables
3. API failures
4. Combat state transitions
5. Range limitations

### Example
```python
def test_error_handling():
    """Test error recovery"""
    # Corrupt state
    scanner_test.lua.execute("aura_env.marks = nil")
    
    # Execute scanner
    result = scanner_test.execute_scanner()
    
    # Verify recovery
    assert result.success
    assert scanner_test.verify_state()
``` 