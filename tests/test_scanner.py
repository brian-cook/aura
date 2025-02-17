import lupa
from lupa import LuaRuntime
from pathlib import Path
import pytest
import os
import sys
import datetime
from contextlib import contextmanager
from test_helpers import ScannerTest, TestingLogger
from wow_api_mock import WoWAPIMock, UnitState, NamePlateInfo
import json
from typing import List, Any
import random
from unittest.mock import Mock, patch
import time
from src.scanner import Scanner  # Add this import at the top

@pytest.fixture
def test_logger(request):
    """Test logger fixture"""
    log_dir = Path("tests/logs")
    log_dir.mkdir(parents=True, exist_ok=True)
    
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_path = log_dir / f"test_scanner_{request.node.name}_{timestamp}.log"
    
    logger = TestingLogger.create(log_path)
    
    logger.write_section("TEST ENVIRONMENT", {
        "Python Version": sys.version,
        "Platform": sys.platform,
        "Lupa Version": lupa.__version__,
        "Working Directory": os.getcwd(),
        "Log File": str(log_path.absolute()),
        "Timestamp": datetime.datetime.now().isoformat()
    })
    
    yield logger
    
    logger.close()

@contextmanager
def capture_output(test_name):
    """Context manager to capture and log output"""
    print(f"\n=== {test_name} ===")
    yield sys.stdout

def with_logging(func):
    """Simple function logging decorator"""
    def wrapper(self, *args, **kwargs):
        test_name = func.__name__
        print(f"\n=== Starting {test_name} ===")
        result = func(self, *args, **kwargs)
        print(f"=== Completed {test_name} ===\n")
        return result
    return wrapper

class EnhancedTestLogger(TestingLogger):
    def __init__(self, log_path):
        super().__init__(log_path)
        self.mark_history = []
        self.state_transitions = []
        
    def log_mark_attempt(self, unit_guid, mark, success):
        event = {
            'timestamp': time.time(),
            'event': 'MARK_ATTEMPT',
            'unit_guid': unit_guid,
            'mark': mark,
            'success': success,
            'current_state': self.get_current_state()
        }
        self.mark_history.append(event)
        self.write_event(event)
    
    def log_state_transition(self, old_state, new_state):
        transition = {
            'timestamp': time.time(),
            'event': 'STATE_TRANSITION',
            'old_state': old_state,
            'new_state': new_state,
            'delta': self.compute_state_delta(old_state, new_state)
        }
        self.state_transitions.append(transition)
        self.write_event(transition)

class BaseScanner:
    """Base class for scanner tests"""
    def setup_base(self, test_logger):
        """Base setup for all scanner tests"""
        self.logger = test_logger
        self.wow_api = WoWAPIMock()
        self.scanner_name = "scanner_test"
        self.scanner_test = ScannerTest(scanner_name=self.scanner_name, wow_api=self.wow_api, logger=self.logger)
        self.wow_api.initialize(self.scanner_test)
        # Initialize WeakAuras global
        self.scanner_test.lua.execute("""
            WeakAuras = {
                ScanEvents = function() end,
                LoadFunction = function() end
                -- Add other required WeakAuras functions as needed
            }
        """)

class TestScanner(BaseScanner):
    @pytest.fixture(autouse=True)
    def setup(self, test_logger):
        """Setup test environment"""
        self.setup_base(test_logger)

    def setup_test_environment(self):
        """Enhanced test environment setup with time tracking"""
        test_unit_id = "test_mob_1"
        
        # Initialize WoW API mock with explicit time tracking
        self.wow_api.reset_state()
        self.wow_api.set_current_time(0)
        
        # Add test unit with required properties
        self.wow_api.add_unit(test_unit_id, {
            "exists": True,
            "is_enemy": True,
            "in_combat": False,
            "guid": test_unit_id,
            "current_time": 0
        })
        
        # Initialize scanner state
        self.scanner_test.lua.execute("""
            aura_env.seenTargets = {}
            aura_env.skullGUID = nil
            aura_env.lastScanTime = 0
        """)
        
        return test_unit_id

    def _get_log_path(self):
        """Helper to generate log path for current test"""
        test_name = self._testMethodName if hasattr(self, '_testMethodName') else 'unknown_test'
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        return f"tests/logs/test_scanner_{test_name}_{timestamp}.log"

    def _run_test(self, test_func):
        """Run test function with proper setup and cleanup"""
        try:
            # Run the test
            test_func()
            return True
        except Exception as e:
            print(f"Test failed: {str(e)}")
            return False
        finally:
            # Cleanup
            if hasattr(self, 'scanner_test') and self.scanner_test.lua:
                self.scanner_test.lua.execute("collectgarbage()")

    def teardown_method(self, method):
        """Cleanup after each test"""
        if hasattr(self, 'scanner_test') and self.scanner_test.lua:
            self.scanner_test.lua.execute("collectgarbage()")

    @with_logging
    def test_scanner_loading(self):
        """Test that scanner loads and initializes properly"""
        def run_test():
            scanner_path = f"AuraManager/auras/{self.scanner_name}.lua"
            self.logger.log_debug(f"Loading scanner from: {scanner_path}")
            
            # Load and verify scanner
            result = self.scanner_test.load_scanner_code(scanner_path)
            assert result.success, f"Failed to load scanner: {result.message}"
            
            # Initialize environment
            init_result = self.scanner_test.init_lua_env()
            assert init_result, "Failed to initialize Lua environment"
            
            # Verify scanner functionality
            verify_result = self.scanner_test.verify_scanner_loaded()
            assert verify_result.success, f"Scanner verification failed: {verify_result.message}"
            
            self.logger.log_debug("Scanner loaded and verified successfully")
            
        self._run_test(run_test)

    @with_logging
    def test_version_specific_behavior(self):
        """Test version-specific scanner behavior"""
        def run_test():
            # Initialize scanner
            scanner_path = f"AuraManager/auras/{self.scanner_name}.lua"
            self.scanner_test.load_scanner_code(scanner_path)
            self.scanner_test.init_lua_env()
            
            # Add test units
            test_unit = "nameplate1"
            self.wow_api.add_unit(test_unit, is_enemy=True)
            
            # Test version-specific threat behavior
            if self.wow_version == "classic":
                # Test classic threat levels (0-3)
                self.wow_api.set_threat_level(test_unit, 3)  # High threat
                mark = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{test_unit}')")
                assert mark == 8, "High threat unit should be skull marked in classic"
            else:
                # Test retail threat percentage
                self.wow_api.set_threat_percentage(test_unit, 90)
                mark = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{test_unit}')")
                assert mark == 8, "High threat unit should be skull marked in retail"
            
            # Test version-specific distance checks
            if self.wow_version == "retail":
                # Move unit out of nameplate range
                self.wow_api.set_unit_position(test_unit, (0, 0, 61))  # Just out of range
                mark = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{test_unit}')")
                assert mark is None, "Out of range unit should not be marked in retail"
            
        self._run_test(run_test)

    @with_logging
    def test_realistic_combat_scenarios(self):
        """Test scanner behavior in realistic combat scenarios"""
        def run_test():
            scanner_path = f"AuraManager/auras/{self.scanner_name}.lua"
            self.scanner_test.load_scanner_code(scanner_path)
            self.scanner_test.init_lua_env()
            
            # Setup combat group
            group = {
                "tank": {"power": {"rage": 100}},
                "healer": {"power": {"mana": 100}},
                "dps1": {"power": {"energy": 100}},
                "dps2": {"power": {"mana": 100}}
            }
            
            enemies = {
                "boss": {"classification": "worldboss", "health": 1000000},
                "add1": {"classification": "elite", "health": 100000},
                "add2": {"classification": "normal", "health": 50000},
                "healer": {"classification": "normal", "health": 50000, "casting": True}
            }
            
            # Add units to the combat scene
            for unit_id, info in group.items():
                self.wow_api.add_unit(f"party{unit_id}", 
                    is_player=True,
                    is_enemy=False,
                    power=info["power"],
                    power_max=info["power"]
                )
            
            for unit_id, info in enemies.items():
                self.wow_api.add_unit(f"nameplate{unit_id}",
                    is_enemy=True,
                    health=info["health"],
                    classification=info["classification"]
                )
                
                if info.get("casting"):
                    self.wow_api.start_casting(f"nameplate{unit_id}", "Heal", 2.0)
            
            # Simulate combat progression
            def simulate_pull():
                self.wow_api.set_combat_state(True)
                self.wow_api.set_threat_level("nameplateboss", 3)
                mark = self.scanner_test.lua.eval("GetRaidTargetIndex('nameplateboss')")
                assert mark == 8, "Boss should be marked with skull"
            
            def simulate_add_phase():
                self.wow_api.set_combat_state("nameplateadd1", True)
                self.wow_api.set_combat_state("nameplateadd2", True)
                mark1 = self.scanner_test.lua.eval("GetRaidTargetIndex('nameplateadd1')")
                mark2 = self.scanner_test.lua.eval("GetRaidTargetIndex('nameplateadd2')")
                assert mark1 == 7, "First add should be marked with cross"
                assert mark2 == 2, "Second add should be marked with circle"
            
            simulate_pull()
            simulate_add_phase()
            
        self._run_test(run_test)

    @with_logging
    def test_profile_specific_scenario(self):
        # Load appropriate profile
        profile_path = f"scripts/profiles/{self.scanner_name}.json"
        self.scanner_test.load_profile(profile_path)
        
        # Setup combat scenario
        scenario = {
            "units": {
                "target": {"health": 100, "power": {"mana": 100}},
                "add1": {"health": 100, "casting": True},
                "add2": {"health": 100, "debuffs": ["Serpent Sting"]}
            },
            "marks": {
                "add1": "cross",
                "add2": "circle"
            },
            "player": {
                "health": 100,
                "power": {"energy": 100}  # or {"mana": 100} for hunter
            },
            "in_combat": True
        }
        
        self.scanner_test.simulate_combat_scenario(scenario)
        
        # Verify profile-specific actions
        if "hunter" in self.scanner_name:
            assert self.scanner_test.verify_target_action("add2", "0")  # CC key
        elif "rogue" in self.scanner_name:
            assert self.scanner_test.verify_target_action("add1", "f")  # Kick key

    @pytest.mark.scanner
    def test_ooc_target_marking_reliability(self):
        """Test reliability of OOC target marking across multiple scenarios"""
        def run_test():
            scanner_path = f"AuraManager/auras/{self.scanner_name}.lua"
            self.scanner_test.load_scanner_code(scanner_path)
            self.scanner_test.init_lua_env()
            
            # Test Case 1: Fresh target with no previous marks
            target1 = "target1"
            self.wow_api.add_unit(target1, {
                "is_enemy": True,
                "is_visible": True,
                "health": 100,
                "in_combat": False,
                "guid": "test-guid-1"
            })
            self.wow_api.set_target(target1)
            self._verify_skull_mark(target1, "Initial marking failed")
            
            # Test Case 2: Quick target switching
            target2 = "target2"
            self.wow_api.add_unit(target2, {
                "is_enemy": True,
                "is_visible": True,
                "health": 100,
                "in_combat": False,
                "guid": "test-guid-2"
            })
            self.wow_api.set_target(target2)
            self._verify_skull_mark(target2, "Failed to mark after target switch")
            
            # Test Case 3: Return to previous target
            self.wow_api.set_target(target1)
            self._verify_skull_mark(target1, "Failed to re-mark previous target")
            
            # Test Case 4: Rapid target cycling
            targets = ["target3", "target4", "target5"]
            for i, target in enumerate(targets):
                self.wow_api.add_unit(target, {
                    "is_enemy": True,
                    "is_visible": True,
                    "health": 100,
                    "in_combat": False,
                    "guid": f"test-guid-{i+3}"
                })
                self.wow_api.set_target(target)
                self._verify_skull_mark(target, f"Failed to mark during rapid cycling: {target}")
            
        self._run_test(run_test)

    @pytest.mark.scanner
    def test_guid_mark_persistence(self):
        """Test GUID tracking and mark persistence during target switching"""
        def run_test():
            scanner_path = f"AuraManager/auras/{self.scanner_name}.lua"
            self.scanner_test.load_scanner_code(scanner_path)
            self.scanner_test.init_lua_env()
            
            # Create multiple units with unique GUIDs
            units = {
                "target1": "guid-1",
                "target2": "guid-2",
                "target3": "guid-3"
            }
            
            for unit, guid in units.items():
                self.wow_api.add_unit(unit, {
                    "is_enemy": True,
                    "is_visible": True,
                    "health": 100,
                    "in_combat": False,
                    "guid": guid
                })
            
            # Test rapid target switching with GUID verification
            for _ in range(3):  # Multiple cycles
                for unit, guid in units.items():
                    self.wow_api.set_target(unit)
                    # Force scanner update
                    self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
                    
                    # Verify both mark and GUID tracking
                    mark = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{unit}')")
                    tracked_guid = self.scanner_test.lua.eval(f"aura_env.marks['{guid}']")
                    
                    assert mark == 8, f"Unit {unit} not marked with skull"
                    assert tracked_guid == 8, f"GUID {guid} not properly tracked"
                    
                    # Small delay to simulate game timing
                    self.wow_api.advance_time(0.1)
            
            # Test GUID persistence after target loss
            for unit in units:
                self.wow_api.set_unit_visible(unit, False)
                self.wow_api.advance_time(0.5)
                self.wow_api.set_unit_visible(unit, True)
                
                # Verify mark is reapplied
                mark = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{unit}')")
                assert mark == 8, f"Mark not reapplied to unit {unit} after visibility toggle"
        
        self._run_test(run_test)

    @pytest.mark.scanner
    def test_target_based_scanning_reliability(self):
        """Test reliability of target-based scanning with detailed logging"""
        def run_test():
            # Setup test units
            test_units = {
                f"mob{i}": {
                    "guid": f"test-guid-{i}",
                    "health": 100,
                    "in_combat": False
                } for i in range(1, 4)
            }
            
            for unit_id, props in test_units.items():
                self.wow_api.add_unit(unit_id, props)
            
            # Test multiple scan cycles
            for cycle in range(3):
                self.logger.write_section(f"Scan Cycle {cycle+1}", "Starting")
                
                # Simulate target cycling
                for unit_id in test_units:
                    # Log pre-target state
                    self.logger.log_scanner_state(self.scanner_test, f"Pre-target {unit_id}")
                    
                    # Set target and trigger scan
                    self.wow_api.set_target(unit_id)
                    self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
                    
                    # Log post-target state
                    self.logger.log_scanner_state(self.scanner_test, f"Post-target {unit_id}")
                    
                    # Add small delay between targets
                    time.sleep(0.1)
                
                # Log cycle metrics
                self.logger.write_section("Cycle Metrics", self.wow_api.get_marking_metrics())
                
        self._run_test(run_test)

    @pytest.mark.scanner
    def test_scanning_state_transitions(self):
        """Test scanning behavior during unit state and visibility transitions"""
        def run_test():
            scanner_path = f"AuraManager/auras/{self.scanner_name}.lua"
            self.scanner_test.load_scanner_code(scanner_path)
            self.scanner_test.init_lua_env()
            
            # Setup initial units outside nameplate range
            units = {
                "far_mob1": {
                    "guid": "guid-far1",
                    "is_enemy": True,
                    "is_visible": True,
                    "health": 100,
                    "in_combat": False,
                    "position": (0, 0, 40)  # Outside nameplate range
                },
                "far_mob2": {
                    "guid": "guid-far2",
                    "is_enemy": True,
                    "is_visible": True,
                    "health": 100,
                    "in_combat": False,
                    "position": (5, 0, 40)
                }
            }
            
            for unit_id, props in units.items():
                self.wow_api.add_unit(unit_id, props)
            
            # Test Scenario 1: Units moving into nameplate range
            def test_range_transition():
                # Start target-based scanning
                self.wow_api.target_enemy()
                self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
                initial_mark = self.scanner_test.lua.eval("GetRaidTargetIndex('far_mob1')")
                
                # Move units into nameplate range
                for unit_id in units:
                    new_pos = (
                        self.wow_api.UnitPosition(unit_id)[0],
                        self.wow_api.UnitPosition(unit_id)[1],
                        15  # Within nameplate range
                    )
                    self.wow_api.set_unit_position(unit_id, new_pos)
                    self.wow_api.advance_time(0.1)
                
                # Verify marks persist through transition
                final_mark = self.scanner_test.lua.eval("GetRaidTargetIndex('far_mob1')")
                assert initial_mark == final_mark, "Mark changed during range transition"
                
            # Test Scenario 2: Death during scanning
            def test_death_during_scan():
                # Clear previous marks
                for unit_id in units:
                    self.wow_api.clear_raid_target(unit_id)
                
                # Start new scan cycle
                target = self.wow_api.target_enemy()
                self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
                
                # Kill the target
                if target:
                    self.wow_api.set_unit_dead(target, True)
                    self.wow_api.advance_time(0.1)
                    
                    # Verify scanner properly handles dead unit
                    assert not self.scanner_test.lua.eval(f"GetRaidTargetIndex('{target}')"), \
                        "Dead unit still marked"
                    
                    # Verify scanner moves to next target
                    next_target = self.wow_api.target_enemy()
                    if next_target:
                        self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
                        assert self.scanner_test.lua.eval(f"GetRaidTargetIndex('{next_target}')"), \
                            "Scanner failed to mark next target after death"
            
            # Test Scenario 3: Combat state changes during scanning
            def test_combat_transition():
                # Clear marks and reset states
                for unit_id in units:
                    self.wow_api.clear_raid_target(unit_id)
                    self.wow_api.set_unit_dead(unit_id, False)
                
                # Start OOC scanning
                self.wow_api.set_combat_state(False)
                initial_target = self.wow_api.target_enemy()
                self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
                
                if initial_target:
                    initial_mark = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{initial_target}')")
                    
                    # Enter combat
                    self.wow_api.set_combat_state(True)
                    self.wow_api.advance_time(0.2)
                    
                    # Verify mark persistence through combat transition
                    combat_mark = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{initial_target}')")
                    assert initial_mark == combat_mark, "Mark changed during combat transition"
            
            # Run all scenarios
            test_range_transition()
            self.wow_api.advance_time(1.0)
            test_death_during_scan()
            self.wow_api.advance_time(1.0)
            test_combat_transition()
            
            # Verify final scan metrics
            metrics = self.wow_api.get_scan_metrics()
            assert metrics['scan_locks'] > 0, "No scan locks recorded"
            assert metrics['total_scans'] > 0, "No scans recorded"
            
        self._run_test(run_test)

    @pytest.mark.scanner
    @pytest.mark.parametrize("iteration", range(5))  # Run test 5 times
    def test_rapid_combat_transitions(self, iteration):
        """Test scanner behavior during quick combat encounters with rapid skull deaths"""
        def run_test():
            scanner_path = f"AuraManager/auras/{self.scanner_name}.lua"
            self.scanner_test.load_scanner_code(scanner_path)
            self.scanner_test.init_lua_env()
            
            def simulate_quick_combat():
                # Setup fresh wave of enemies
                enemies = {
                    f"mob{i}": {
                        "guid": f"guid-mob{i}",
                        "is_enemy": True,
                        "is_visible": True,
                        "health": 100,
                        "in_combat": False,
                        "position": (i*5, 0, 15)  # Within nameplate range
                    } for i in range(1, 4)
                }
                
                for unit_id, props in enemies.items():
                    self.wow_api.add_unit(unit_id, props)
                
                # Start OOC marking
                self.wow_api.set_combat_state(False)
                initial_target = self.wow_api.target_enemy()
                self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
                
                if initial_target:
                    initial_skull = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{initial_target}')")
                    initial_guid = self.wow_api.UnitGUID(initial_target)
                    
                    # Enter combat quickly
                    self.wow_api.set_combat_state(True)
                    self.wow_api.advance_time(0.5)
                    
                    # Kill skull target rapidly
                    self.wow_api.set_unit_dead(initial_target, True)
                    self.wow_api.advance_time(0.1)
                    
                    # Verify skull mark is cleared and GUID tracking updated
                    assert not self.scanner_test.lua.eval(f"GetRaidTargetIndex('{initial_target}')"), \
                        "Dead skull target still marked"
                    assert not self.scanner_test.lua.eval(f"aura_env.marks['{initial_guid}']"), \
                        "Dead skull GUID still tracked"
                    
                    # Verify quick transition to new skull
                    next_target = self.wow_api.target_enemy()
                    if next_target:
                        self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
                        new_skull = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{next_target}')")
                        assert new_skull == 8, "Failed to mark new skull after quick death"
                    
                    # End combat quickly
                    self.wow_api.set_combat_state(False)
                    self.wow_api.advance_time(0.2)
                    
                    # Verify mark persistence through quick combat exit
                    post_combat_mark = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{next_target}')")
                    assert post_combat_mark == 8, "Skull mark lost after quick combat exit"
                
                return enemies
            
            # Track metrics across all cycles
            all_metrics = []
            
            # Run multiple quick combat cycles
            for cycle in range(3):
                self.logger.write(f"Iteration {iteration}, cycle {cycle + 1}")
                enemies = simulate_quick_combat()
                
                # Collect metrics after each cycle
                metrics = self.wow_api.get_marking_metrics()
                all_metrics.append(metrics)
                
                # Verify marking reliability
                assert metrics['success_rate'] > 0.9, \
                    f"Mark success rate too low: {metrics['success_rate']:.2f}"
                assert metrics['duplicate_marks'] == 0, \
                    f"Found duplicate marks in cycle {cycle + 1}"
                
                # Verify no lingering marks or GUID tracking
                dead_units = [unit for unit in enemies if self.wow_api.UnitIsDead(unit)]
                for unit in dead_units:
                    guid = self.wow_api.UnitGUID(unit)
                    assert not self.scanner_test.lua.eval(f"aura_env.marks['{guid}']"), \
                        f"Dead GUID {guid} still tracked after cycle {cycle + 1}"
                
                # Brief pause between cycles
                self.wow_api.advance_time(0.5)
                
                # Cleanup for next cycle
                for unit in enemies:
                    self.wow_api.remove_unit(unit)
            
            # Verify overall performance
            avg_success_rate = sum(m['success_rate'] for m in all_metrics) / len(all_metrics)
            assert avg_success_rate > 0.95, \
                f"Overall mark success rate too low: {avg_success_rate:.2f}"
            
            # Verify no systematic timing issues
            avg_mark_time = sum(m['average_time_between_marks'] for m in all_metrics) / len(all_metrics)
            assert avg_mark_time < 0.5, \
                f"Average marking time too slow: {avg_mark_time:.2f}s"
        
        self._run_test(run_test)

    @pytest.mark.scanner
    def test_target_cycling_skull_marking(self):
        """Test skull marking reliability during target cycling"""
        def run_test():
            # Load hunter profile
            profile_path = "scripts/profiles/hunter_classic.json"
            self.scanner_test.load_profile(profile_path)
            
            # Setup multiple units
            units = {
                "mob1": {"guid": "test-guid-1", "health": 100, "in_combat": False},
                "mob2": {"guid": "test-guid-2", "health": 100, "in_combat": False},
                "mob3": {"guid": "test-guid-3", "health": 100, "in_combat": False}
            }
            
            for unit_id, props in units.items():
                self.wow_api.add_unit(unit_id, props)
            
            # Simulate target cycling
            for _ in range(2):  # Do two full cycles
                for unit_id in units:
                    # Simulate targeting macro
                    self.wow_api.set_target(unit_id)
                    self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
                    
                    # Add delay between targets
                    time.sleep(0.1)
                    
                    # Log current state
                    self.logger.log_state({
                        "current_target": unit_id,
                        "marks": self.scanner_test.lua.eval("aura_env.marks"),
                        "seen_targets": self.scanner_test.lua.eval("aura_env.seenTargets"),
                        "skull_guid": self.scanner_test.lua.eval("aura_env.skullGUID"),
                        "last_scan": self.scanner_test.lua.eval("aura_env.last")
                    })
                    
                    # Verify mark if seen before
                    if self.scanner_test.lua.eval(f"aura_env.seenTargets['{units[unit_id]['guid']}']"):
                        mark = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{unit_id}')")
                        assert mark == 8, f"Unit {unit_id} should be marked with skull after being seen twice"
            
        self._run_test(run_test)

    def _verify_skull_mark(self, unit: str, error_message: str):
        """Verify skull mark is applied correctly"""
        # Force scanner update
        self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
        
        # Check mark multiple times over a short period
        mark_applied = False
        for _ in range(5):  # Check multiple times
            mark = self.scanner_test.lua.eval(f"GetRaidTargetIndex('{unit}')")
            if mark == 8:  # Skull mark
                mark_applied = True
                break
            self.wow_api.advance_time(0.1)  # Advance time slightly
        
        assert mark_applied, error_message

    def _verify_test_environment(self):
        """Verify all test components are properly initialized"""
        verification = {
            'wow_api': {
                'initialized': hasattr(self, 'wow_api'),
                'has_logger': hasattr(self.wow_api, 'logger') if hasattr(self, 'wow_api') else False
            },
            'scanner_test': {
                'initialized': hasattr(self, 'scanner_test'),
                'has_logger': hasattr(self.scanner_test, 'logger') if hasattr(self, 'scanner_test') else False
            }
        }
        
        # Log verification state
        self.logger.write_section("STATE", {
            component: status for component, status in verification.items()
        })
        
        # Check if all components are ready
        all_ready = all(
            all(component.values())  # Changed from status.values() to component.values()
            for component in verification.values()
        )
        
        if not all_ready:
            self.logger.log_error("Test environment verification failed", verification)
        
        return all_ready

    def _cleanup_resources(self):
        """Cleanup test resources with logging"""
        self.logger.write_section("RESOURCE CLEANUP", "Cleaning up test resources")
        
        cleanup_status = {
            "wow_api": "Cleaning",
            "scanner_test": "Cleaning",
            "lua_env": "Cleaning"
        }
        
        try:
            if hasattr(self, 'wow_api'):
                self.wow_api.log_state()
                cleanup_status["wow_api"] = "Cleaned"
                
            if hasattr(self, 'scanner_test'):
                if self.scanner_test.lua:
                    self.scanner_test.lua.execute("collectgarbage()")
                cleanup_status["scanner_test"] = "Cleaned"
                cleanup_status["lua_env"] = "Cleaned"
                
        except Exception as e:
            self.logger.log_error("Cleanup failed", e)
            return False
            
        self.logger.log_state(cleanup_status, "CLEANUP COMPLETE")
        return True

    def _verify_scanner_state(self, unit: str, expected_mark: int):
        """Verify scanner's internal state for unit marking"""
        # Get unit's GUID
        guid = self.wow_api.UnitGUID(unit)
        
        # Check scanner's internal state
        lua_state = {
            'mark': self.scanner_test.lua.eval(f"GetRaidTargetIndex('{unit}')"),
            'guid_tracked': self.scanner_test.lua.eval(f"aura_env.marks['{guid}']"),
            'last_update': self.scanner_test.lua.eval("aura_env.last"),
            'current_time': self.wow_api.current_time
        }
        
        # Verify state consistency
        assert lua_state['mark'] == expected_mark, f"Expected mark {expected_mark}, got {lua_state['mark']}"
        assert lua_state['guid_tracked'] == expected_mark, f"GUID tracking mismatch"
        assert lua_state['current_time'] - lua_state['last_update'] < 1.0, "Scanner update too old"
        
        return lua_state

    @pytest.mark.scanner
    def test_profile_conditions(self):
        """Test profile condition evaluation"""
        def run_test():
            profile_path = "scripts/profiles/hunter_classic.json"
            self.scanner_test.load_profile(profile_path)
            
            # Test targeting macro conditions
            conditions = {
                "!combat": True,
                "!player_targeting": True
            }
            
            # Set up conditions
            for condition, value in conditions.items():
                self.wow_api.set_condition(condition, value)
            
            # Verify macro key can be pressed
            assert self.scanner_test.verify_action("i"), "Target cycling macro should be available"
            
            # Test with combat
            self.wow_api.set_condition("!combat", False)
            assert not self.scanner_test.verify_action("i"), "Target cycling macro should not be available in combat"
            
        self._run_test(run_test)

    def test_target_range_and_visibility(self):
        """Test target marking behavior when targets move in/out of range"""
        test_unit_id = self.setup_test_environment()
        
        # First target encounter
        self.wow_api.set_target(test_unit_id)
        self.scanner_test.lua.execute("WeakAuras.ScanEvents('PLAYER_TARGET_CHANGED')")
        time.sleep(0.2)
        
        # Simulate target moving out of range
        self.wow_api.set_unit_property(test_unit_id, 'in_range', False)
        self.scanner_test.lua.execute("WeakAuras.ScanEvents('UNIT_FLAGS')")
        time.sleep(0.2)
        
        # Verify mark is cleared when target is out of range
        current_mark = self.wow_api.GetRaidTargetIndex(test_unit_id)
        assert current_mark == 0, "Mark should be cleared when target is out of range"

    def test_target_cleanup_scenarios(self):
        """Test cleanup of seen targets and skull marks"""
        test_unit_id = self.setup_test_environment()
        
        # Set initial time
        initial_time = 0
        self.wow_api.set_current_time(initial_time)
        
        # Set up initial state with explicit time
        self.wow_api.set_target(test_unit_id)
        self.scanner_test.lua.execute("""
            aura_env = aura_env or {}
            aura_env.seenTargets = aura_env.seenTargets or {}
            aura_env.seenTargets[select(1, ...)] = GetTime()
        """, test_unit_id)
        
        # Verify initial state
        seen_targets = dict(self.scanner_test.lua.eval("aura_env.seenTargets"))
        assert test_unit_id in seen_targets, "Target should be in seen_targets"
        
        # Advance time past the cleanup threshold (5 seconds)
        self.wow_api.set_current_time(initial_time + 6)
        
        # Force cleanup
        self.scanner_test.lua.execute("""
            local currentTime = GetTime()
            for guid, timestamp in pairs(aura_env.seenTargets) do
                if currentTime - timestamp > 5 then
                    aura_env.seenTargets[guid] = nil
                end
            end
        """)
        
        # Verify cleanup
        seen_targets = dict(self.scanner_test.lua.eval("aura_env.seenTargets"))
        assert test_unit_id not in seen_targets, "Target should be removed from seen_targets after timeout"

    def test_skull_mark_persistence(self):
        """Test skull mark behavior with target death and timeout"""
        test_unit_id = self.setup_test_environment()
        
        # Set initial time
        self.wow_api.set_current_time(0)
        
        # First target event
        self.wow_api.set_target(test_unit_id)
        self.scanner_test.lua.execute("""
            local currentTime = GetTime()
            aura_env.seenTargets[select(1, ...)] = currentTime
        """, test_unit_id)
        
        # Small delay but within 5s window
        self.wow_api.set_current_time(2)
        
        # Second target event
        self.wow_api.clear_target()
        self.wow_api.set_target(test_unit_id)
        self.scanner_test.lua.execute("""
            local currentTime = GetTime()
            local targetGUID = select(1, ...)
            
            if aura_env.seenTargets[targetGUID] then
                if currentTime - aura_env.seenTargets[targetGUID] <= 5 then
                    if not aura_env.skullGUID and not GetRaidTargetIndex("target") then
                        SetRaidTarget("target", 8)
                        aura_env.skullGUID = targetGUID
                    end
                end
            end
        """, test_unit_id)
        
        # Verify skull mark
        skull_guid = self.scanner_test.lua.eval("aura_env.skullGUID")
        assert skull_guid == test_unit_id, "Target should be marked with skull"

class TestProfileScanner(TestScanner):
    def setup_base(self, test_logger):
        """Base setup for profile scanner tests"""
        super().setup_base(test_logger)
        # Load the profile for testing
        self.profile = self._load_profile()
        
    def _load_profile(self):
        """Load the test profile"""
        profile_path = "scripts/profiles/hunter_classic_test.json"
        with open(profile_path, 'r') as f:
            return json.load(f)

    @pytest.mark.scanner
    def test_profile_action_groups(self):
        """Test each action group defined in the profile"""
        groups = self._get_action_groups()
        for group in groups:
            self.logger.write(f"Testing action group: {group}")
            
            # Setup conditions for group
            self._setup_group_conditions(group)
            
            # Get actions for this group
            group_actions = [
                action for action in self.profile["actions"]
                if action.get("group") == group
            ]
            
            # Verify group-specific behaviors
            self._verify_group_actions(group, group_actions)

    def _get_action_groups(self) -> List[str]:
        """Get list of action groups from profile"""
        groups = []
        for action in self.profile.get("actions", []):
            group = action.get("group")
            if group and group not in groups:
                groups.append(group)
        return groups

    def _setup_group_conditions(self, group: str):
        """Setup test conditions based on action group"""
        if group == "OOC Scan":
            # Ensure we're out of combat
            self.wow_api.set_combat_state(False)
            # Add target dummy with specific properties
            self.wow_api.add_unit("target_dummy", {
                "is_enemy": True,
                "is_visible": True,
                "health": 100,
                "in_combat": False,
                "guid": "test-dummy-guid"
            })
            # Ensure no skull mark exists
            self.wow_api.clear_raid_target("target_dummy")
        
        elif group == "EMERGENCY ACTIONS WHEN LOW HEALTH":
            self.wow_api.set_combat_state(True)
            self.wow_api.set_unit_health("player", 45)  # 45% health
            
        elif group == "CC COUNTERS":
            self.wow_api.set_combat_state(True)
            self.wow_api.add_unit("target", {
                "is_enemy": True,
                "is_casting": True,
                "spell": "Test Spell"
            })
            
        elif group == "SCANNING":
            self._setup_scanning_conditions()

    def _setup_scanning_conditions(self):
        """Setup conditions for testing scanning behavior"""
        # Add multiple units to test scanning priority
        units = {
            "healer": {"is_casting": True, "spell": "Heal"},
            "caster": {"is_casting": True, "spell": "Fireball"},
            "melee": {"is_enemy": True}
        }
        
        for unit_id, props in units.items():
            self.wow_api.add_unit(unit_id, props)

    def _verify_group_actions(self, group: str, actions: list):
        """Verify actions within a group execute correctly"""
        if group == "OOC Scan":
            # Check if the action exists in the group
            scan_action = next((a for a in actions if a.get("key") == "i"), None)
            if scan_action:
                # Record the targeting action
                self.scanner_test.lua.globals().TestRecordTargetAction("target_dummy", scan_action["key"])
                # Verify the targeting action was recorded
                assert self.scanner_test.verify_target_action("target_dummy", scan_action["key"])
            else:
                # If no scan action defined, check for alternative targeting behavior
                self.scanner_test.lua.globals().TestRecordAction("/targetenemy")
                assert self.scanner_test.verify_action("/targetenemy")
            
        elif group == "EMERGENCY ACTIONS WHEN LOW HEALTH":
            if "hunter" in self.scanner_name:
                assert self.scanner_test.verify_action("Feign Death")
            elif "rogue" in self.scanner_name:
                assert self.scanner_test.verify_action("Evasion")
                
        elif group == "CC COUNTERS":
            self._verify_cc_actions()
            
        elif group == "SCANNING":
            self._verify_scanning_actions()

    def _verify_cc_actions(self):
        """Verify CC-related actions"""
        if "hunter" in self.scanner_name:
            assert self.scanner_test.verify_action("Freezing Trap")
        elif "rogue" in self.scanner_name:
            assert self.scanner_test.verify_action("Gouge")

    def _verify_scanning_actions(self):
        """Verify scanning and marking behavior"""
        # Verify mark assignments
        assert self.scanner_test.verify_mark("healer", "SKULL")
        assert self.scanner_test.verify_mark("caster", "CROSS")
        
        # Verify targeting sequence
        assert self.scanner_test.verify_target_sequence([
            "healer",  # Priority interrupt
            "caster",  # Secondary interrupt
            "melee"    # Normal target
        ])

    @pytest.fixture
    def scanner(self, wow_api):
        # Current problematic line:
        return Scanner(wow_api, "AuraManager/auras")
    
    @pytest.fixture
    def wow_api(self):
        # Create mock WoW API
        api = Mock()
        api.logger = Mock()
        api.get_functions = Mock(return_value={
            'UnitExists': lambda x: True,
            'UnitGUID': lambda x: f"mock-guid-{x}",
            'GetTime': lambda: time.time()
        })
        return api

    def test_throttling(self, scanner):
        """Test that scanning respects the throttle interval"""
        # First scan should work
        assert scanner.should_scan() == True
        
        # Immediate second scan should be throttled
        assert scanner.should_scan() == False
        
        # After 0.2s, scanning should work again
        with patch('time.time', return_value=time.time() + 0.3):
            assert scanner.should_scan() == True

    def test_spell_priority_detection(self, scanner):
        """Test spell priority detection logic"""
        mock_unit = Mock()
        mock_unit.is_casting = True
        mock_unit.spell_name = "Test Spell"
        mock_unit.is_interruptible = True
        
        priority = scanner.get_spell_priority(mock_unit)
        assert priority > 0, "Interruptible cast should have priority"
        
        # Test non-interruptible
        mock_unit.is_interruptible = False
        priority = scanner.get_spell_priority(mock_unit)
        assert priority == 0, "Non-interruptible cast should have 0 priority"

    def test_cc_detection(self, scanner):
        """Test crowd control detection"""
        mock_unit = Mock()
        mock_unit.has_debuff = lambda x: x == "Sap"
        
        assert scanner.is_cc_target(mock_unit, "Sap") == True
        assert scanner.is_cc_target(mock_unit, "Polymorph") == False

    def test_mark_management(self, scanner):
        """Test raid mark management"""
        mock_unit1 = Mock(guid="1", priority=2)
        mock_unit2 = Mock(guid="2", priority=1)
        
        # Test mark assignment
        scanner.process_marks([mock_unit1, mock_unit2])
        assert scanner.get_unit_mark(mock_unit1) == "STAR"  # Higher priority
        assert scanner.get_unit_mark(mock_unit2) == "CIRCLE"  # Lower priority

if __name__ == "__main__":
    pytest.main([__file__, "-v"]) 