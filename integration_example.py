"""
Integration Example for Dynamic Action Selection Engine

This script demonstrates how to integrate the new decision engine with the
existing screen_monitor.py functionality.

Usage:
    python integration_example.py --config config.json
"""

import argparse
import json
import time
import sys
import os
import logging
from typing import Dict, Any, Optional

# Import the decision engine (assuming it's in the same directory)
from decision_engine_prototype import (
    StateMonitor, 
    ActionDecisionEngine, 
    ActionExecutor, 
    DecisionEngineManager
)

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler('integration.log')
    ]
)
logger = logging.getLogger('integration')

# Try to import screen_monitor from the current codebase
try:
    # This path may need adjustment depending on the actual codebase structure
    sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    from screen_monitor import ScreenMonitor
    SCREEN_MONITOR_AVAILABLE = True
    logger.info("Successfully imported ScreenMonitor from existing codebase")
except ImportError:
    SCREEN_MONITOR_AVAILABLE = False
    logger.warning("Could not import ScreenMonitor from existing codebase - using stub")
    
    # Create a stub class for ScreenMonitor for demonstration purposes
    class ScreenMonitor:
        """Stub class for ScreenMonitor to be used when the real one is not available."""
        
        def __init__(self, config=None):
            self.config = config or {}
            logger.info("Initialized ScreenMonitor stub")
            
        def get_screen_data(self):
            """Return simulated screen data."""
            return {
                "target_exists": True,
                "target_health": 75,
                "player_health": 90,
                "player_power": 80,
                "player_combo_points": 3,
                "player_in_combat": True,
                "nameplates": [
                    {"id": 1, "exists": True, "health": 50, "distance": 8, "type": "humanoid"},
                    {"id": 2, "exists": True, "health": 75, "distance": 12, "type": "beast"},
                    {"id": 3, "exists": True, "health": 100, "distance": 20, "type": "undead"}
                ]
            }
        
        def is_aura_visible(self, aura_name):
            """Check if an aura is visible (simulated)."""
            common_auras = {
                "target": True,
                "player_in_combat": True,
                "slice_and_dice": True,
                "energy_40": True,
                "energy_60": True,
                "range_5": True,
                "range_8": True,
                "range_20": True
            }
            return common_auras.get(aura_name, False)


class EnhancedStateMonitor(StateMonitor):
    """
    Extended StateMonitor that integrates with the existing ScreenMonitor.
    
    This class bridges the gap between the old and new systems, allowing
    for a gradual transition.
    """
    
    def __init__(self, screen_monitor: Optional[ScreenMonitor] = None):
        """
        Initialize the enhanced state monitor.
        
        Args:
            screen_monitor: Instance of the existing ScreenMonitor
        """
        super().__init__()
        self.screen_monitor = screen_monitor or ScreenMonitor()
        logger.info("Initialized EnhancedStateMonitor with ScreenMonitor integration")
    
    def update_unit_states(self):
        """Update unit states using data from ScreenMonitor."""
        # Clear previous states
        self.unit_states = {}
        
        # Get data from screen monitor
        screen_data = self.screen_monitor.get_screen_data()
        
        # Process target data
        if screen_data.get("target_exists", False):
            self.unit_states["target"] = {
                "exists": True,
                "health_percent": screen_data.get("target_health", 100),
                "is_casting": self.screen_monitor.is_aura_visible("target_casting"),
                "distance": self._get_nearest_range("target"),  # Will still use the simulation method
                "is_elite": self.screen_monitor.is_aura_visible("target_is_elite"),
                "type": self._get_unit_type("target"),  # Will still use the simulation method
                "debuffs": self._get_unit_debuffs("target"),  # Will still use the simulation method
                "marker": self._get_unit_marker("target")  # Will still use the simulation method
            }
        
        # Process nameplate data
        for nameplate in screen_data.get("nameplates", []):
            nameplate_id = f"nameplate{nameplate.get('id', 0)}"
            if nameplate.get("exists", False):
                self.unit_states[nameplate_id] = {
                    "exists": True,
                    "health_percent": nameplate.get("health", 100),
                    "is_casting": self.screen_monitor.is_aura_visible(f"casting_{nameplate_id}"),
                    "distance": nameplate.get("distance", 40),
                    "is_elite": self.screen_monitor.is_aura_visible(f"elite_{nameplate_id}"),
                    "type": nameplate.get("type", "humanoid"),
                    "debuffs": self._get_unit_debuffs(nameplate_id),  # Will still use the simulation method
                    "marker": self._get_unit_marker(nameplate_id)  # Will still use the simulation method
                }
    
    def update_player_state(self):
        """Update player state using data from ScreenMonitor."""
        # Get data from screen monitor
        screen_data = self.screen_monitor.get_screen_data()
        
        # Update player state
        self.player_state = {
            "health_percent": screen_data.get("player_health", 100),
            "power_type": "energy",  # For a rogue
            "power_current": screen_data.get("player_power", 100),
            "power_max": 100,
            "combo_points": screen_data.get("player_combo_points", 0),
            "in_combat": screen_data.get("player_in_combat", False),
            "buffs": self._get_player_buffs(),  # Will still use the simulation method
            "debuffs": self._get_player_debuffs(),  # Will still use the simulation method
            "cooldowns": self._get_cooldowns()  # Will still use the simulation method
        }


class IntegrationManager:
    """
    High-level manager for the integration between existing code and the new decision engine.
    """
    
    def __init__(self, config_file: str):
        """
        Initialize the integration manager.
        
        Args:
            config_file: Path to the configuration file
        """
        # Load configuration
        self.config = self._load_config(config_file)
        
        # Initialize screen monitor
        self.screen_monitor = ScreenMonitor(self.config)
        
        # Initialize enhanced state monitor
        self.state_monitor = EnhancedStateMonitor(self.screen_monitor)
        
        # Initialize decision engine components
        player_config = self.config.get("player", {})
        self.decision_engine = ActionDecisionEngine(
            player_class=player_config.get("class", "rogue"),
            player_level=player_config.get("level", 60),
            available_spells=player_config.get("available_spells", [])
        )
        
        # Override the state monitor in the decision engine
        self.decision_engine.state_monitor = self.state_monitor
        
        # Initialize action executor
        self.action_executor = ActionExecutor(
            key_mapping=self.config.get("key_mapping", {})
        )
        
        # Control variables
        self.running = False
        self.loop_interval = self.config.get("decision_engine", {}).get("decision_interval", 0.1)
        
        logger.info(f"IntegrationManager initialized with config from {config_file}")
    
    def _load_config(self, config_file: str) -> Dict[str, Any]:
        """
        Load configuration from a JSON file.
        
        Args:
            config_file: Path to the configuration file
            
        Returns:
            Dict with configuration values
        """
        try:
            with open(config_file, 'r') as f:
                config = json.load(f)
            logger.info(f"Configuration loaded from {config_file}")
            return config
        except Exception as e:
            logger.error(f"Error loading configuration from {config_file}: {e}")
            # Return an empty configuration
            return {}
    
    def start(self):
        """Start the integration manager."""
        if self.running:
            logger.warning("Integration manager already running")
            return
        
        self.running = True
        logger.info("Integration manager started")
        
        try:
            # Main loop
            while self.running:
                # Determine best action
                action, score, target = self.decision_engine.determine_best_action()
                
                # Execute the action if one was selected
                if action and score > 0:
                    self.action_executor.execute_action(action, target)
                
                # Sleep to control loop speed
                time.sleep(self.loop_interval)
        except KeyboardInterrupt:
            logger.info("Integration manager stopped by user")
        except Exception as e:
            logger.error(f"Error in integration manager loop: {e}", exc_info=True)
        finally:
            self.running = False
    
    def stop(self):
        """Stop the integration manager."""
        self.running = False
        logger.info("Integration manager stopped")
    
    def get_status(self) -> Dict[str, Any]:
        """
        Get the current status of the integration.
        
        Returns:
            Dict with status information
        """
        # Get performance metrics from the decision engine
        performance = self.decision_engine.get_performance_report()
        
        # Get the last decision
        last_decision = self.decision_engine.last_decision or (None, 0, None)
        
        return {
            "running": self.running,
            "performance": performance,
            "last_decision": {
                "action": last_decision[0],
                "score": last_decision[1],
                "target": last_decision[2]
            }
        }


def main():
    """Main entry point for the integration example."""
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Integration Example for Dynamic Action Selection")
    parser.add_argument("--config", default="config.json", help="Path to configuration file")
    parser.add_argument("--debug", action="store_true", help="Enable debug logging")
    args = parser.parse_args()
    
    # Set logging level
    if args.debug:
        logger.setLevel(logging.DEBUG)
    
    # Print status
    logger.info(f"Starting integration with configuration from {args.config}")
    logger.info(f"ScreenMonitor integration available: {SCREEN_MONITOR_AVAILABLE}")
    
    # Initialize the integration manager
    manager = IntegrationManager(args.config)
    
    try:
        # Start the integration manager
        manager.start()
    except KeyboardInterrupt:
        logger.info("Integration example stopped by user")
    finally:
        manager.stop()
    
    logger.info("Integration example completed")


if __name__ == "__main__":
    main() 