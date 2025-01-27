# Test Infrastructure Plan

## Directory Structure

tests/
├── conftest.py           # Test configuration and fixtures
├── test_helpers/         # Core test helper modules
│   ├── base.py          # Base test classes and utilities
│   ├── logger.py        # Test logging functionality
│   ├── state.py         # State tracking containers
│   └── mocks/           # WoW API mocking
│       ├── api.py       # Core API mock
│       ├── combat.py    # Combat simulation
│       ├── targeting.py # Target handling
│       └── units.py     # Unit management

## Phase 1: Core Components Separation

### 1. Split Current Files
- Move `TestingLogger` from test_helpers.py to `test_helpers/logger.py`
- Move state containers to `test_helpers/state.py`
- Split WoWAPIMock into focused mock modules

### 2. Simplified Base Classes
Create base test classes in `test_helpers/base.py`:
- BaseTest: Core test functionality
- ScannerTest: Scanner-specific test functionality

## Phase 2: Logging Enhancement

### 1. Focused Logger Interface
Create TestLogger class with core methods:
- log_state(): Track test state changes
- log_event(): Record test events
- log_error(): Handle error logging

### 2. State Management
Implement TestState dataclass for tracking:
- Test timing
- Scanner information
- Event history
- Error tracking

## Phase 3: Mock API Simplification

### 1. Core API Mock
Create base WoWAPIMock with essential functionality:
- Unit management
- Target handling
- Combat state tracking

### 2. Specialized Mocks
Split into focused mock modules:
- Targeting
- Combat
- Unit Management

## Implementation Priority
1. Core structure separation
2. Logger simplification
3. State management
4. Mock API modularization

## Success Criteria
1. Reduced file sizes (<500 lines)
2. Clear component separation
3. Simplified interfaces
4. Improved maintainability

## Next Steps
1. Create new directory structure
2. Move existing code to new locations
3. Update imports and dependencies
4. Verify test functionality