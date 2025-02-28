"""
Test Suite for Dynamic Action Selection Engine

This script provides test cases for the decision engine, simulating different
in-game scenarios to verify behavior without requiring the actual game.

Usage:
    python test_decision_engine.py
"""

import json
import time
import logging
from typing import Dict, Any, List, Tuple

# Import the decision engine (assuming it's in the same directory)
from decision_engine_prototype import (
    StateMonitor, 
    ActionDecisionEngine, 
    ActionExecutor,
    RogueActionEvaluator
)

# Configure logging to console only for tests
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger('test_decision_engine')

class TestStateMonitor(StateMonitor):
    """
    State monitor that can be manually configured with test scenarios.
    """
    
    def __init__(self):
        """Initialize the test state monitor."""
        super().__init__()
        self.scenario_name = "default"
        
    def set_scenario(self, scenario_name: str, scenario_data: Dict[str, Any]):
        """
        Set a test scenario to simulate.
        
        Args:
            scenario_name: Name of the scenario
            scenario_data: Dictionary with state data for the scenario
        """
        self.scenario_name = scenario_name
        
        # Load scenario data
        self.unit_states = scenario_data.get("unit_states", {})
        self.player_state = scenario_data.get("player_state", {})
        self.party_states = scenario_data.get("party_states", {})
        self.combat_state = scenario_data.get("combat_state", {})
        
        logger.info(f"Loaded scenario: {scenario_name}")
    
    def update_all_states(self) -> bool:
        """
        Override the update method to do nothing - we're manually setting states.
        
        Returns:
            bool: Always returns True
        """
        # We're not actually updating anything, just return True
        return True


class TestRunner:
    """
    Test runner for the decision engine.
    """
    
    def __init__(self):
        """Initialize the test runner."""
        # Set up a test state monitor
        self.state_monitor = TestStateMonitor()
        
        # Create a rogue evaluator for testing
        self.evaluator = RogueActionEvaluator(player_level=60)
        
        # Set up the decision engine with the test state monitor
        self.decision_engine = ActionDecisionEngine(
            player_class="rogue",
            player_level=60,
            available_spells=[
                "sinister_strike", "eviscerate", "slice_and_dice",
                "kick", "evasion", "sprint", "vanish",
                "gouge", "blind", "sap"
            ]
        )
        
        # Override the state monitor
        self.decision_engine.state_monitor = self.state_monitor
        
        # Create an action executor with a test key mapping
        self.key_mapping = {
            "sinister_strike": "1",
            "eviscerate": "2",
            "slice_and_dice": "3",
            "kick": "4",
            "evasion": "5",
            "sprint": "6",
            "vanish": "7",
            "gouge": "8",
            "blind": "9",
            "sap": "0"
        }
        self.action_executor = ActionExecutor(key_mapping=self.key_mapping)
        
        # Define test scenarios
        self.scenarios = self._define_scenarios()
        
        # Test results
        self.results = {}
    
    def _define_scenarios(self) -> Dict[str, Dict[str, Any]]:
        """
        Define test scenarios.
        
        Returns:
            Dictionary with scenario definitions
        """
        return {
            "normal_combat": {
                "description": "Normal combat scenario with a single target",
                "unit_states": {
                    "target": {
                        "exists": True,
                        "health_percent": 70,
                        "is_casting": False,
                        "distance": 5,
                        "is_elite": False,
                        "type": "humanoid",
                        "debuffs": [],
                        "marker": None
                    }
                },
                "player_state": {
                    "health_percent": 90,
                    "power_type": "energy",
                    "power_current": 80,
                    "power_max": 100,
                    "combo_points": 3,
                    "in_combat": True,
                    "buffs": [],
                    "debuffs": [],
                    "cooldowns": {
                        "vanish": 0,
                        "sprint": 0,
                        "evasion": 0
                    }
                },
                "party_states": {},
                "combat_state": {
                    "enemy_count": 1,
                    "high_threat_count": 0,
                    "emergency": False,
                    "aoe_opportunity": False,
                    "cc_opportunity": False
                }
            },
            "low_health_emergency": {
                "description": "Emergency scenario with low health",
                "unit_states": {
                    "target": {
                        "exists": True,
                        "health_percent": 90,
                        "is_casting": False,
                        "distance": 5,
                        "is_elite": True,
                        "type": "humanoid",
                        "debuffs": [],
                        "marker": None
                    },
                    "nameplate1": {
                        "exists": True,
                        "health_percent": 100,
                        "is_casting": False,
                        "distance": 8,
                        "is_elite": False,
                        "type": "humanoid",
                        "debuffs": [],
                        "marker": None
                    }
                },
                "player_state": {
                    "health_percent": 15,
                    "power_type": "energy",
                    "power_current": 50,
                    "power_max": 100,
                    "combo_points": 2,
                    "in_combat": True,
                    "buffs": [],
                    "debuffs": [],
                    "cooldowns": {
                        "vanish": 0,
                        "sprint": 0,
                        "evasion": 0
                    }
                },
                "party_states": {},
                "combat_state": {
                    "enemy_count": 2,
                    "high_threat_count": 2,
                    "emergency": True,
                    "aoe_opportunity": False,
                    "cc_opportunity": False
                }
            },
            "target_casting": {
                "description": "Target is casting a spell that should be interrupted",
                "unit_states": {
                    "target": {
                        "exists": True,
                        "health_percent": 80,
                        "is_casting": True,
                        "distance": 5,
                        "is_elite": False,
                        "type": "humanoid",
                        "debuffs": [],
                        "marker": None
                    }
                },
                "player_state": {
                    "health_percent": 85,
                    "power_type": "energy",
                    "power_current": 60,
                    "power_max": 100,
                    "combo_points": 1,
                    "in_combat": True,
                    "buffs": [],
                    "debuffs": [],
                    "cooldowns": {
                        "vanish": 0,
                        "sprint": 0,
                        "evasion": 0
                    }
                },
                "party_states": {},
                "combat_state": {
                    "enemy_count": 1,
                    "high_threat_count": 0,
                    "emergency": False,
                    "aoe_opportunity": False,
                    "cc_opportunity": True
                }
            },
            "finishing_low_health_target": {
                "description": "Target is at low health, ready for a finisher",
                "unit_states": {
                    "target": {
                        "exists": True,
                        "health_percent": 15,
                        "is_casting": False,
                        "distance": 5,
                        "is_elite": False,
                        "type": "humanoid",
                        "debuffs": [],
                        "marker": None
                    }
                },
                "player_state": {
                    "health_percent": 75,
                    "power_type": "energy",
                    "power_current": 90,
                    "power_max": 100,
                    "combo_points": 5,
                    "in_combat": True,
                    "buffs": [{"name": "slice_and_dice", "duration": 10}],
                    "debuffs": [],
                    "cooldowns": {
                        "vanish": 0,
                        "sprint": 0,
                        "evasion": 0
                    }
                },
                "party_states": {},
                "combat_state": {
                    "enemy_count": 1,
                    "high_threat_count": 0,
                    "emergency": False,
                    "aoe_opportunity": False,
                    "cc_opportunity": False
                }
            },
            "buff_maintenance": {
                "description": "Slice and Dice needs to be refreshed",
                "unit_states": {
                    "target": {
                        "exists": True,
                        "health_percent": 85,
                        "is_casting": False,
                        "distance": 5,
                        "is_elite": False,
                        "type": "humanoid",
                        "debuffs": [],
                        "marker": None
                    }
                },
                "player_state": {
                    "health_percent": 90,
                    "power_type": "energy",
                    "power_current": 70,
                    "power_max": 100,
                    "combo_points": 4,
                    "in_combat": True,
                    "buffs": [],  # No Slice and Dice
                    "debuffs": [],
                    "cooldowns": {
                        "vanish": 0,
                        "sprint": 0,
                        "evasion": 0
                    }
                },
                "party_states": {},
                "combat_state": {
                    "enemy_count": 1,
                    "high_threat_count": 0,
                    "emergency": False,
                    "aoe_opportunity": False,
                    "cc_opportunity": False
                }
            },
            "multiple_enemies": {
                "description": "Multiple enemies, potential AoE situation",
                "unit_states": {
                    "target": {
                        "exists": True,
                        "health_percent": 90,
                        "is_casting": False,
                        "distance": 5,
                        "is_elite": False,
                        "type": "humanoid",
                        "debuffs": [],
                        "marker": None
                    },
                    "nameplate1": {
                        "exists": True,
                        "health_percent": 100,
                        "is_casting": False,
                        "distance": 8,
                        "is_elite": False,
                        "type": "humanoid",
                        "debuffs": [],
                        "marker": None
                    },
                    "nameplate2": {
                        "exists": True,
                        "health_percent": 100,
                        "is_casting": False,
                        "distance": 6,
                        "is_elite": False,
                        "type": "humanoid",
                        "debuffs": [],
                        "marker": None
                    },
                    "nameplate3": {
                        "exists": True,
                        "health_percent": 100,
                        "is_casting": False,
                        "distance": 7,
                        "is_elite": False,
                        "type": "humanoid",
                        "debuffs": [],
                        "marker": None
                    }
                },
                "player_state": {
                    "health_percent": 75,
                    "power_type": "energy",
                    "power_current": 60,
                    "power_max": 100,
                    "combo_points": 2,
                    "in_combat": True,
                    "buffs": [{"name": "slice_and_dice", "duration": 10}],
                    "debuffs": [],
                    "cooldowns": {
                        "vanish": 0,
                        "sprint": 0,
                        "evasion": 0
                    }
                },
                "party_states": {},
                "combat_state": {
                    "enemy_count": 4,
                    "high_threat_count": 1,
                    "emergency": False,
                    "aoe_opportunity": True,
                    "cc_opportunity": False
                }
            }
        }
    
    def run_tests(self) -> Dict[str, Dict[str, Any]]:
        """
        Run all test scenarios.
        
        Returns:
            Dictionary with test results
        """
        for scenario_name, scenario_data in self.scenarios.items():
            logger.info(f"Running scenario: {scenario_name} - {scenario_data['description']}")
            
            # Load the scenario
            self.state_monitor.set_scenario(scenario_name, scenario_data)
            
            # Determine the best action
            action, score, target = self.decision_engine.determine_best_action()
            
            # Store the result
            self.results[scenario_name] = {
                "description": scenario_data["description"],
                "action": action,
                "score": score,
                "target": target
            }
            
            # Display the result
            logger.info(f"Result: {action} (score {score:.2f}) targeting {target}")
            logger.info("-" * 50)
            
            # Simulate a delay between scenarios
            time.sleep(0.5)
        
        return self.results
    
    def print_summary(self):
        """Print a summary of all test results."""
        print("\n" + "=" * 80)
        print("TEST RESULTS SUMMARY")
        print("=" * 80)
        
        for scenario_name, result in self.results.items():
            print(f"Scenario: {scenario_name}")
            print(f"Description: {result['description']}")
            print(f"Decision: {result['action']} (score {result['score']:.2f}) targeting {result['target']}")
            print("-" * 80)
        
        print("\nTest suite completed.")


def manually_test_evaluator():
    """Run manual tests of the evaluator with different states."""
    # Set up a test state monitor
    state_monitor = TestStateMonitor()
    
    # Create a rogue evaluator for testing
    evaluator = RogueActionEvaluator(player_level=60)
    
    # Set up a simple scenario
    scenario_data = {
        "unit_states": {
            "target": {
                "exists": True,
                "health_percent": 70,
                "is_casting": False,
                "distance": 5,
                "is_elite": False,
                "type": "humanoid",
                "debuffs": [],
                "marker": None
            }
        },
        "player_state": {
            "health_percent": 90,
            "power_type": "energy",
            "power_current": 80,
            "power_max": 100,
            "combo_points": 3,
            "in_combat": True,
            "buffs": [],
            "debuffs": [],
            "cooldowns": {
                "vanish": 0,
                "sprint": 0,
                "evasion": 0
            }
        },
        "party_states": {},
        "combat_state": {
            "enemy_count": 1,
            "high_threat_count": 0,
            "emergency": False,
            "aoe_opportunity": False,
            "cc_opportunity": False
        }
    }
    
    # Load the scenario
    state_monitor.set_scenario("manual_test", scenario_data)
    
    # Get scored actions
    scored_actions = evaluator.evaluate_actions(state_monitor)
    
    # Display all scored actions
    print("\n" + "=" * 80)
    print("EVALUATOR TEST: All Scored Actions")
    print("=" * 80)
    
    for action, score, target in sorted(scored_actions, key=lambda x: x[1], reverse=True):
        print(f"Action: {action:<20} Score: {score:<10.2f} Target: {target}")
    
    print("\nEvaluator test completed.")


def main():
    """Main entry point for the test script."""
    # Run automated tests
    test_runner = TestRunner()
    test_runner.run_tests()
    test_runner.print_summary()
    
    # Run manual evaluator test
    manually_test_evaluator()


if __name__ == "__main__":
    main() 