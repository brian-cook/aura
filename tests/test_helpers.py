"""
Test helper classes and utilities for scanner testing.

This module provides the infrastructure for testing WoW addon scanners, including:
- Test logging and result tracking
- WoW API mocking
- Lua environment setup
- Test execution management
- State tracking and snapshots
"""

from lupa import LuaRuntime
import sys
import datetime
import os
from pathlib import Path
import lupa
import pytest
from typing import Dict, Set, Optional, Any, Union, List, Tuple, Callable
from dataclasses import dataclass, field
import random
from wow_api_mock import WoWAPIMock  # Import from wow_api_mock.py instead
import json

# Tell pytest to ignore this class for test collection
__test__ = False  # Add this at module level

@dataclass
class TestResult:
    """Container for test results"""
    success: bool
    message: str
    details: Optional[Dict[str, Any]] = None
    error: Optional[Exception] = None

@dataclass
class TestExecution:
    """Container for test execution details"""
    start_time: datetime.datetime
    scanner_name: str
    test_count: int = 0
    error_count: int = 0
    state_snapshots: List[Dict[str, Any]] = field(default_factory=list)

@dataclass
class LuaState:
    """Container for Lua environment state"""
    marks: Dict[str, int] = field(default_factory=dict)
    cast_end_times: Dict[str, float] = field(default_factory=dict)
    seen_targets: Dict[str, Any] = field(default_factory=dict)
    last_update: float = 0.0
    skull_guid: Optional[str] = None
    skull_timestamp: float = 0.0

class TestingLogger:
    """Logger class for test output and debugging. Not a test class."""
    __test__ = False  # Also add this at class level for extra clarity
    
    def __init__(self, log_file: str):
        """Initialize test logger with file output"""
        self.log_file = log_file
        self.file = open(log_file, 'w', encoding='utf-8')
        
    @classmethod
    def create(cls, log_path: Path) -> 'TestingLogger':
        """Create a new TestingLogger instance"""
        return cls(str(log_path))
        
    def write(self, message: str) -> None:
        """Write message to both terminal and log file"""
        self.file.write(message)
        self.file.flush()
        print(message, end='')  # Print to terminal without extra newline
        
    def write_section(self, section: str, data: Dict[str, Any]) -> None:
        """Write a section to the log file"""
        self.write(f"\n=== {section} ===\n\n")
        if isinstance(data, dict):
            for key, value in data.items():
                self.write(f"{key}: {value}\n")
        else:
            self.write(str(data) + "\n")
        
    def log_debug(self, message: str) -> None:
        """Log debug message"""
        self.write_section("DEBUG", message)
        
    def log_error(self, message: str, error: Optional[Exception] = None) -> None:
        """Log error message"""
        if error:
            self.write_section("ERROR", f"{message}: {str(error)}")
        else:
            self.write_section("ERROR", message)
            
    def log_state(self, state: Dict[str, Any], title: str = "STATE") -> None:
        """Log state information"""
        self.write_section(title, state)
        
    def log_result(self, result: Any) -> None:
        """Log test result"""
        self.write_section("RESULT", {
            "success": getattr(result, 'success', None),
            "message": getattr(result, 'message', None),
            "details": getattr(result, 'details', None),
            "error": getattr(result, 'error', None)
        })
        
    def close(self) -> None:
        """Close the log file"""
        if self.file:
            self.file.close()

    def write_section(self, section: str, content: Union[Dict[str, Any], str]) -> None:
        """Write a section to the log"""
        self.write(f"\n=== {section} ===\n")
        if isinstance(content, dict):
            for key, value in content.items():
                self.write(f"{key}: {value}")
        else:
            self.write(str(content))

    def get_summary(self) -> Dict[str, Any]:
        """Get test execution summary"""
        return {
            "duration": self._get_duration(),
            "error_count": self.error_count,
            "total_tests": len(self.test_results),
            "passed_tests": sum(1 for r in self.test_results if r.success)
        }

    def _get_duration(self) -> datetime.timedelta:
        """Calculate test duration"""
        return datetime.datetime.now() - self.start_time

class LuaMock:
    """Mock Lua runtime for testing"""
    def __init__(self) -> None:
        self.functions: Dict[str, Callable] = {}
        self.globals: Dict[str, Any] = {}
        self.state = LuaState()
    
    def table(self) -> Dict:
        return {}
    
    def eval(self, lua_code: str) -> Any:
        if not lua_code:
            raise ValueError("No Lua code provided")
        return self._mock_eval(lua_code)
    
    def _mock_eval(self, code: str) -> Any:
        """Internal evaluation logic"""
        # Add mock evaluation logic here
        return True

class ScannerTest:
    """Test helper for loading and testing scanner code"""
    def __init__(self, scanner_name: str, wow_api: WoWAPIMock, logger: TestingLogger, profile: dict = None):
        """Initialize scanner test environment"""
        self.scanner_name = scanner_name
        self.wow_api = wow_api
        self.logger = logger
        self.profile = profile
        
        # Initialize Lua runtime
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        
        # Track test state
        self.scanner_loaded = False
        self.env_initialized = False
        self.current_test = None
        
        # Initialize results tracking
        self.results = []
        self.action_history = []
        self.target_actions = []  # Track target-specific actions
        self.mark_history = {}
        self.target_history = []
        
        # Initialize test functions in Lua environment
        self._init_test_functions()
        
        # Initialize scanner
        self._initialize_scanner()

    def _init_test_functions(self):
        """Initialize test recording functions in Lua environment"""
        if not self.lua:
            return
            
        # Add test recording functions to Lua globals
        globals = self.lua.globals()
        
        def test_record_action(action_name):
            self._record_action(action_name)
        globals.TestRecordAction = test_record_action
        
        def test_record_target_action(target, action):
            self._record_target_action(target, action)
        globals.TestRecordTargetAction = test_record_target_action
        
        def test_record_mark(unit, mark):
            self._record_mark(unit, mark)
        globals.TestRecordMark = test_record_mark
        
        def test_record_target(unit):
            self._record_target(unit)
        globals.TestRecordTarget = test_record_target

    def _initialize_scanner(self):
        """Initialize scanner test environment"""
        try:
            # Initialize global namespace first
            self.lua.execute("""
                -- Initialize global namespace and addon environment
                _G = _G or {}
                local ADDON_NAME = "WeakAuras"
                _G.ADDON_NAME = ADDON_NAME
                
                -- Set up the ns table that scanners expect
                _G.ns = {
                    auras = {},
                    regions = {},
                    regionTypes = {},
                    regionPrototypes = {},
                    animations = {},
                    triggers = {}
                }
                
                -- Initialize aura environment
                _G.aura_env = {
                    conditions = {},
                    state = {},
                    config = {}
                }
                
                -- Set up basic WoW API functions
                _G.GetTime = function() return 0 end
                _G.UnitExists = function(unit) return true end
                _G.UnitGUID = function(unit) return "test-guid" end
            """)
            
            if self.logger:
                self.logger.log_debug("Scanner environment initialized")
                
            return True
            
        except Exception as e:
            if self.logger:
                self.logger.log_error(f"Failed to initialize Lua environment: {str(e)}")
            return False

    def _record_action(self, action_name: str):
        """Record an action being taken"""
        self.action_history.append(action_name)

    def _record_target_action(self, target: str, action: str):
        """Record an action being taken on a specific target"""
        self.target_actions.append((target, action))

    def _record_mark(self, unit: str, mark: str):
        """Record a mark being applied"""
        self.mark_history[unit] = mark

    def _record_target(self, unit: str):
        """Record a targeting action"""
        self.target_history.append(unit)

    def verify_action(self, action_name: str) -> bool:
        """Verify if an action was executed"""
        return action_name in self.action_history

    def verify_target_action(self, target: str, action: str) -> bool:
        """Verify if an action was executed on a specific target"""
        return (target, action) in self.target_actions

    def verify_mark(self, unit: str, mark: str) -> bool:
        """Verify if a unit has a specific mark"""
        return self.mark_history.get(unit) == mark

    def verify_target_sequence(self, sequence: list) -> bool:
        """Verify targeting sequence matches expected order"""
        return self.target_history == sequence

    def cleanup(self):
        """Cleanup test resources"""
        if hasattr(self, 'lua'):
            self.lua.execute("collectgarbage()")
        self.action_history.clear()
        self.target_actions.clear()
        self.mark_history.clear()
        self.target_history.clear()

    def load_profile(self, profile_path: str) -> TestResult:
        """Load profile configuration from JSON"""
        try:
            with open(profile_path, 'r', encoding='utf-8') as f:
                self.profile = json.load(f)
            
            if self.logger:
                self.logger.log_debug(f"Loaded profile from {profile_path}")
                
            return TestResult(
                success=True,
                message="Profile loaded successfully",
                details={"profile_name": self.profile.get("name")}
            )
        except Exception as e:
            return TestResult(
                success=False,
                message="Failed to load profile",
                error=e
            )

    def simulate_combat_scenario(self, scenario: Dict[str, Any]) -> TestResult:
        """Simulate a combat scenario with given parameters"""
        try:
            # Setup units
            for unit_id, unit_data in scenario.get("units", {}).items():
                self.wow_api.add_unit(unit_id, unit_data)

            # Setup marks
            for unit_id, mark in scenario.get("marks", {}).items():
                self.wow_api.set_mark(unit_id, mark)

            # Setup combat state
            if scenario.get("in_combat"):
                self.wow_api.set_combat_state(True)

            # Setup player state
            player_state = scenario.get("player", {})
            if "health" in player_state:
                self.wow_api.set_health_percentage(player_state["health"])
            if "power" in player_state:
                for power_type, value in player_state["power"].items():
                    self.wow_api.set_power(power_type, value)

            # Take state snapshot
            if self.logger:
                self.logger.log_state(self.wow_api.get_state(), "Combat Scenario Setup")

            return TestResult(
                success=True,
                message="Combat scenario simulated successfully",
                details=scenario
            )

        except Exception as e:
            return TestResult(
                success=False,
                message="Failed to simulate combat scenario",
                error=e
            )

    def load_scanner_code(self, scanner_path: str) -> TestResult:
        """Load scanner code from file"""
        try:
            if not os.path.exists(scanner_path):
                return TestResult(
                    success=False,
                    message=f"Scanner file not found: {scanner_path}"
                )

            with open(scanner_path, 'r', encoding='utf-8') as f:
                self.lua_code = f.read()

            if self.logger:
                self.logger.log_debug(f"Loaded scanner code from {scanner_path}")

            return TestResult(
                success=True,
                message="Scanner code loaded successfully"
            )

        except Exception as e:
            return TestResult(
                success=False,
                message="Failed to load scanner code",
                error=e
            )

    def init_lua_env(self) -> bool:
        """Initialize Lua environment with WoW API functions"""
        try:
            self.lua = LuaRuntime(unpack_returned_tuples=True)
            
            # Expose WoW API functions
            self.wow_api.expose_api(self.lua)
            
            # Initialize global namespace and aura environment
            self.lua.execute("""
                -- Global namespace setup
                ns = {
                    auras = {}
                }
                
                -- Initialize aura environment
                aura_env = {
                    marks = {},
                    castEndTimes = {},
                    seenTargets = {},
                    last = 0,
                    skullGUID = nil,
                    skullTimestamp = 0,
                    config = {
                        enabled = true,
                        debug = false
                    }
                }
            """)
            
            # Load scanner code if available
            if self.lua_code:
                self.lua.execute(self.lua_code)
            
            if self.logger:
                self.logger.write("Lua environment initialized")
            return True
            
        except Exception as e:
            if self.logger:
                self.logger.log_error("Failed to initialize Lua environment", e)
            return False

    def verify_environment(self) -> TestResult:
        """Verify test environment is properly set up"""
        try:
            verification = {
                'wow_api': self.wow_api is not None,
                'lua_runtime': self.lua is not None,
                'scanner_code': self.lua_code is not None,
                'logger': self.logger is not None
            }
            
            success = all(verification.values())
            result = TestResult(
                success=success,
                message="Environment verification " + ("passed" if success else "failed"),
                details=verification
            )
            
            self.results.append(result)
            if self.logger:
                self.logger.log_result(result)
            
            return result
            
        except Exception as e:
            result = TestResult(
                success=False,
                message="Environment verification failed with error",
                error=e
            )
            self.results.append(result)
            if self.logger:
                self.logger.log_result(result)
            return result

    def get_test_summary(self) -> Dict[str, Any]:
        """Get summary of all test results"""
        return {
            "total_tests": len(self.results),
            "passed_tests": sum(1 for r in self.results if r.success),
            "failed_tests": sum(1 for r in self.results if not r.success),
            "errors": [r for r in self.results if r.error is not None]
        }

    def take_state_snapshot(self) -> None:
        """Take a snapshot of current test state"""
        if self.wow_api:
            state = self.wow_api.log_state()
            self.execution.state_snapshots.append(state)
            if self.logger:
                self.logger.log_state(state, f"State Snapshot {len(self.execution.state_snapshots)}")

    def run_test(self, test_func: callable) -> TestResult:
        """Run a test function with proper setup and teardown"""
        self.execution.test_count += 1
        try:
            # Take pre-test snapshot
            self.take_state_snapshot()
            
            # Run test
            result = test_func()
            
            # Take post-test snapshot
            self.take_state_snapshot()
            
            test_result = TestResult(
                success=True,
                message=f"Test {test_func.__name__} completed successfully",
                details={"result": result}
            )
            
        except Exception as e:
            self.execution.error_count += 1
            test_result = TestResult(
                success=False,
                message=f"Test {test_func.__name__} failed",
                error=e
            )
            
        self.results.append(test_result)
        if self.logger:
            self.logger.log_result(test_result)
        
        return test_result

    def get_execution_summary(self) -> Dict[str, Any]:
        """Get summary of test execution"""
        duration = datetime.datetime.now() - self.execution.start_time
        return {
            "scanner_name": self.execution.scanner_name,
            "duration": duration,
            "total_tests": self.execution.test_count,
            "error_count": self.execution.error_count,
            "state_snapshots": len(self.execution.state_snapshots),
            "test_results": [
                {
                    "success": r.success,
                    "message": r.message,
                    "has_error": r.error is not None
                }
                for r in self.results
            ]
        }

    def verify_scanner_loaded(self) -> TestResult:
        """Verify scanner code is properly loaded and functional"""
        try:
            # Check if scanner table exists
            scanner_exists = self.lua.eval(f"type({self.scanner_name}) == 'table'")
            if not scanner_exists:
                return TestResult(
                    success=False,
                    message=f"Scanner table '{self.scanner_name}' not found"
                )
            
            # Check required functions
            required_functions = [
                "Initialize",
                "ProcessUnit",
                "OnUpdate"
            ]
            
            missing_functions = []
            for func in required_functions:
                if not self.lua.eval(f"type({self.scanner_name}.{func}) == 'function'"):
                    missing_functions.append(func)
            
            if missing_functions:
                return TestResult(
                    success=False,
                    message=f"Missing required functions: {', '.join(missing_functions)}"
                )
            
            # Initialize scanner
            init_result = self.lua.eval(f"{self.scanner_name}.Initialize()")
            if not init_result:
                return TestResult(
                    success=False,
                    message="Scanner initialization failed"
                )
            
            return TestResult(
                success=True,
                message="Scanner verification passed",
                details={
                    "functions_found": required_functions,
                    "initialization": "success"
                }
            )
            
        except Exception as e:
            return TestResult(
                success=False,
                message="Scanner verification failed with error",
                error=e
            )

    def test_hunter_cc_management(self):
        # Test Cross marking and CC
        self.wow_api.add_unit("add1", {"debuffs": ["Serpent Sting"]})
        self.wow_api.set_mark("add1", "cross")
        assert self.verify_target_action("add1", "0")  # CC key

        # Test range conditions
        self.wow_api.set_unit_range("add1", 5)  # Too close
        assert not self.verify_target_action("add1", "0")
        
        self.wow_api.set_unit_range("add1", 40)  # Too far
        assert not self.verify_target_action("add1", "0")

    def test_rogue_combo_point_logic(self):
        # Test Eviscerate usage based on combo points and target health
        self.wow_api.set_combo_points(5)
        self.wow_api.set_target_health_percentage(80)
        assert self.verify_action("y")  # Eviscerate key
        
        self.wow_api.set_combo_points(3)
        self.wow_api.set_target_health_percentage(40)
        assert self.verify_action("y")  # Should still Eviscerate

    def test_emergency_actions(self):
        # Test potion usage
        self.wow_api.set_health_percentage(40)
        self.wow_api.set_combat_state(True)
        assert self.verify_action("n")  # Potion key

        # Test bandage usage
        self.wow_api.set_target_aggro(False)
        self.wow_api.set_player_moving(False)
        assert self.verify_action("b")  # Bandage key

    def verify_scanner_conditions(self) -> TestResult:
        """Verify that scanner conditions are properly loaded and evaluating"""
        try:
            # Check if conditions table exists
            conditions_exist = self.lua.eval("type(aura_env.conditions) == 'table'")
            if not conditions_exist:
                return TestResult(
                    success=False,
                    message="Scanner conditions table not found"
                )

            # Test basic conditions from profile
            test_conditions = [
                "combat",
                "target_exists",
                "player_health",
                "power_type",
                "range_check"
            ]

            results = {}
            for condition in test_conditions:
                condition_func = self.lua.eval(f"aura_env.conditions['{condition}']")
                results[condition] = {
                    "exists": condition_func is not None,
                    "type": self.lua.eval(f"type(aura_env.conditions['{condition}'])")
                }

            # Log condition verification
            if self.logger:
                self.logger.write_section("SCANNER CONDITIONS", results)

            return TestResult(
                success=all(r["exists"] and r["type"] == "function" for r in results.values()),
                message="Scanner conditions verification complete",
                details=results
            )

        except Exception as e:
            return TestResult(
                success=False,
                message="Failed to verify scanner conditions",
                error=e
            )

@pytest.fixture
def test_logger(request):
    """Fixture to provide test logging functionality"""
    logger = TestingLogger.create(f"test_{request.node.name}.log")
    yield logger
    if logger.error_count > 0:
        print(f"[{logger.test_name}] Test completed with {logger.error_count} errors")

@dataclass
class ProfileAction:
    """Container for profile action details"""
    group: str
    name: str
    key: str
    conditions: List[str]

class ProfileTest:
    """Helper class for testing profile-specific scenarios"""
    def __init__(self, scanner_test: ScannerTest):
        self.scanner_test = scanner_test
        self.wow_api = scanner_test.wow_api
        self.logger = scanner_test.logger
        self.actions: Dict[str, ProfileAction] = {}
        self.current_scenario: Optional[Dict[str, Any]] = None

    def load_actions(self) -> TestResult:
        """Load and categorize actions from profile"""
        try:
            if not self.scanner_test.profile:
                return TestResult(
                    success=False,
                    message="No profile loaded"
                )

            # Group actions by their group
            action_groups: Dict[str, List[ProfileAction]] = {}
            for action in self.scanner_test.profile["actions"]:
                group = action.get("group", "Ungrouped")
                action_groups.setdefault(group, []).append(
                    ProfileAction(
                        group=group,
                        name=action["name"],
                        key=action["key"],
                        conditions=action["conditions"]
                    )
                )

            if self.logger:
                self.logger.write_section("PROFILE ACTIONS", {
                    group: len(actions) for group, actions in action_groups.items()
                })

            return TestResult(
                success=True,
                message="Actions loaded successfully",
                details={"group_count": len(action_groups)}
            )

        except Exception as e:
            return TestResult(
                success=False,
                message="Failed to load actions",
                error=e
            )

    def verify_marking_behavior(self) -> TestResult:
        """Verify marking behavior based on profile configuration"""
        try:
            # Setup test units
            test_units = {
                "boss": {"classification": "worldboss", "health": 1000000},
                "add1": {"classification": "elite", "health": 100000},
                "add2": {"classification": "normal", "health": 50000},
                "healer": {"classification": "normal", "health": 50000, "casting": True}
            }

            # Add units to combat scene
            for unit_id, info in test_units.items():
                self.scanner_test.wow_api.add_unit(f"nameplate{unit_id}", 
                    is_enemy=True,
                    health=info["health"],
                    classification=info["classification"]
                )
                if info.get("casting"):
                    self.scanner_test.wow_api.start_casting(f"nameplate{unit_id}", "Heal", 2.0)

            # Verify marking priority
            verification_steps = [
                ("boss", 8, "Skull mark on boss"),
                ("add1", 7, "Cross mark on first add"),
                ("add2", 2, "Circle mark on second add"),
                ("healer", 3, "Diamond mark on healer")
            ]

            results = []
            for unit_id, expected_mark, description in verification_steps:
                actual_mark = self.scanner_test.lua.eval(
                    f"GetRaidTargetIndex('nameplate{unit_id}')"
                )
                results.append({
                    "unit": unit_id,
                    "expected": expected_mark,
                    "actual": actual_mark,
                    "passed": actual_mark == expected_mark,
                    "description": description
                })

            success = all(r["passed"] for r in results)
            return TestResult(
                success=success,
                message="Marking behavior verification complete",
                details={"steps": results}
            )

        except Exception as e:
            return TestResult(
                success=False,
                message="Marking behavior verification failed",
                error=e
            )

    def verify_cc_behavior(self) -> TestResult:
        """Verify CC behavior based on profile configuration"""
        try:
            # Setup test scenarios for different CC types
            cc_scenarios = {
                "hunter": {
                    "cc_key": "0",  # Freezing Trap
                    "requirements": {
                        "debuffs": ["Serpent Sting"],
                        "range": (8, 35),  # min, max range
                        "power": {"mana": 15}
                    }
                },
                "rogue": {
                    "cc_key": "0",  # Gouge
                    "requirements": {
                        "range": (0, 8),
                        "power": {"energy": 45},
                        "facing": True
                    }
                }
            }

            # Determine class from profile name
            class_type = next((c for c in cc_scenarios if c in self.scanner_test.scanner_name), None)
            if not class_type:
                return TestResult(
                    success=False,
                    message="Unsupported class type for CC verification"
                )

            scenario = cc_scenarios[class_type]
            results = []

            # Test CC conditions
            test_unit = "target"
            self.scanner_test.wow_api.add_unit(test_unit, {
                "health": 100,
                "is_enemy": True
            })

            # Test range requirements
            for range_val in [scenario["requirements"]["range"][0] - 1,  # Too close
                            sum(scenario["requirements"]["range"]) / 2,  # Perfect range
                            scenario["requirements"]["range"][1] + 1]:  # Too far
                self.scanner_test.wow_api.set_unit_range(test_unit, range_val)
                should_cc = (scenario["requirements"]["range"][0] <= range_val <= 
                           scenario["requirements"]["range"][1])
                
                results.append({
                    "test": f"Range test at {range_val} yards",
                    "expected": should_cc,
                    "actual": self.scanner_test.verify_target_action(test_unit, scenario["cc_key"]),
                    "details": {"range": range_val}
                })

            success = all(r["expected"] == r["actual"] for r in results)
            return TestResult(
                success=success,
                message="CC behavior verification complete",
                details={"steps": results}
            )

        except Exception as e:
            return TestResult(
                success=False,
                message="CC behavior verification failed",
                error=e
            ) 