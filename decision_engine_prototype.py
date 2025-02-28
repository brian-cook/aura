"""
Dynamic Action Selection Engine for WeakAuras Automation

This module implements a prototype of the decision engine that selects
the optimal action based on the current game state information collected
from WeakAuras.

Version: 0.1.0
"""

import time
import logging
import json
from typing import Dict, List, Tuple, Optional, Any, Callable

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    filename='decision_engine.log'
)
logger = logging.getLogger('decision_engine')

class StateMonitor:
    """
    Enhanced state monitoring system that collects information from WeakAuras
    displayed on screen and processes it into a structured state representation.
    
    This is a prototype that will eventually replace or extend screen_monitor.py.
    """
    
    def __init__(self):
        """Initialize the state monitor."""
        # Main state containers
        self.unit_states: Dict[str, Dict[str, Any]] = {}
        self.player_state: Dict[str, Any] = {}
        self.party_states: Dict[str, Dict[str, Any]] = {}
        self.combat_state: Dict[str, Any] = {}
        
        # Tracking variables
        self.last_update = 0
        self.update_frequency = 0.1  # seconds
        
    def update_all_states(self) -> bool:
        """
        Update all state information from visible WeakAuras.
        
        Returns:
            bool: True if states were updated, False if skipped due to throttling
        """
        current_time = time.time()
        if current_time - self.last_update < self.update_frequency:
            return False
            
        self.last_update = current_time
        
        try:
            self.update_unit_states()
            self.update_player_state()
            self.update_party_states()
            self.update_combat_state()
            return True
        except Exception as e:
            logger.error(f"Error updating states: {e}")
            return False
    
    def update_unit_states(self):
        """Update information about all units from visible WeakAuras."""
        # In the prototype, we'll simulate this with placeholder logic
        # This would be replaced with actual screen detection logic
        
        # Clear previous states to prevent stale data
        self.unit_states = {}
        
        # Simulate checking for target existence
        if self._is_aura_visible("target"):
            self.unit_states["target"] = {
                "exists": True,
                "health_percent": self._get_health_percent("target"),
                "is_casting": self._is_aura_visible("target_casting"),
                "distance": self._get_nearest_range("target"),
                "is_elite": self._is_aura_visible("target_is_elite_boss_or_player"),
                "type": self._get_unit_type("target"),
                "debuffs": self._get_unit_debuffs("target"),
                "marker": self._get_unit_marker("target")
            }
        
        # Scan for nameplates (in the real implementation, this would check all possible nameplates)
        for i in range(1, 5):  # Simplified for prototype
            unit_id = f"nameplate{i}"
            if self._is_aura_visible(f"unit_exists_{unit_id}"):
                self.unit_states[unit_id] = {
                    "exists": True,
                    "health_percent": self._get_health_percent(unit_id),
                    "is_casting": self._is_aura_visible(f"target_casting_{unit_id}"),
                    "distance": self._get_nearest_range(unit_id),
                    "is_elite": self._is_aura_visible(f"target_is_elite_boss_or_player_{unit_id}"),
                    "type": self._get_unit_type(unit_id),
                    "debuffs": self._get_unit_debuffs(unit_id),
                    "marker": self._get_unit_marker(unit_id)
                }
    
    def update_player_state(self):
        """Update information about the player from visible WeakAuras."""
        # In the prototype, we'll simulate this with placeholder logic
        self.player_state = {
            "health_percent": 85,  # Simulated value
            "power_type": "energy",  # For a rogue
            "power_current": 70,  # Simulated value
            "power_max": 100,
            "combo_points": 3,  # Simulated value
            "in_combat": self._is_aura_visible("player_in_combat"),
            "buffs": self._get_player_buffs(),
            "debuffs": self._get_player_debuffs(),
            "cooldowns": self._get_cooldowns()
        }
    
    def update_party_states(self):
        """Update information about party members from visible WeakAuras."""
        # In the prototype, we'll simulate this with placeholder logic
        self.party_states = {}
        
        # Simulate having 2 party members
        self.party_states["party1"] = {
            "exists": True,
            "health_percent": 75,
            "class": "warrior",
            "distance": 15
        }
        
        self.party_states["party2"] = {
            "exists": True,
            "health_percent": 90,
            "class": "priest",
            "distance": 20
        }
    
    def update_combat_state(self):
        """Update overall combat situation information."""
        # Count enemies
        enemy_count = sum(1 for unit_id, state in self.unit_states.items() 
                         if unit_id != "target" and self._is_hostile(unit_id))
        
        # Analyze threat situation
        high_threat_count = sum(1 for unit_id, state in self.unit_states.items()
                              if self._is_aura_visible(f"target_aggro_{unit_id}"))
        
        # Check for emergency situations
        emergency = (self.player_state.get("health_percent", 100) < 30 or
                    high_threat_count > 2)
        
        self.combat_state = {
            "enemy_count": enemy_count,
            "high_threat_count": high_threat_count,
            "emergency": emergency,
            "aoe_opportunity": enemy_count >= 3,
            "cc_opportunity": any(self._is_aura_visible(f"target_casting_{unit_id}") 
                                for unit_id in self.unit_states)
        }
    
    # Helper methods to simulate WeakAura detection
    def _is_aura_visible(self, aura_name: str) -> bool:
        """
        Check if a WeakAura is visible on screen.
        
        In the real implementation, this would use computer vision techniques
        to detect the aura on screen.
        
        Args:
            aura_name: Name of the aura to check
            
        Returns:
            bool: True if the aura is visible, False otherwise
        """
        # This is just a placeholder that returns simulated values
        # based on common aura patterns
        if aura_name == "target":
            return True
        elif aura_name == "player_in_combat":
            return True
        elif aura_name.startswith("target_casting"):
            return False
        elif aura_name.startswith("target_is_elite"):
            return True
        elif aura_name.startswith("unit_exists_nameplate"):
            # Simulate having some nameplates visible
            unit_num = int(aura_name.split("nameplate")[1])
            return unit_num <= 3  # Only 3 nameplates visible
        elif aura_name.startswith("target_aggro"):
            # Simulate one unit having aggro
            unit_id = aura_name.split("target_aggro_")[1]
            return unit_id == "nameplate1"
        elif aura_name == "slice_and_dice_buff":
            return True
        elif aura_name.startswith("power_"):
            threshold = int(aura_name.split("_")[1])
            return self.player_state.get("power_current", 0) >= threshold
        elif aura_name.startswith("range_"):
            parts = aura_name.split("_")
            range_value = int(parts[1])
            return range_value >= 8  # Simulate being at least 8 yards from all units
            
        # Default to False for unknown auras
        return False
    
    def _get_health_percent(self, unit_id: str) -> int:
        """
        Get the health percentage of a unit.
        
        In the real implementation, this would use pattern matching on
        health threshold auras.
        
        Args:
            unit_id: ID of the unit to check
            
        Returns:
            int: Health percentage from 0 to 100
        """
        # Simulate health values for different units
        if unit_id == "target":
            return 65
        elif unit_id == "nameplate1":
            return 40
        elif unit_id == "nameplate2":
            return 80
        elif unit_id == "nameplate3":
            return 95
        return 100
    
    def _get_nearest_range(self, unit_id: str) -> int:
        """
        Find the closest range at which a unit is visible.
        
        Args:
            unit_id: ID of the unit to check
            
        Returns:
            int: Distance in yards
        """
        # Simulate distance values
        if unit_id == "target":
            return 5
        elif unit_id == "nameplate1":
            return 8
        elif unit_id == "nameplate2":
            return 15
        elif unit_id == "nameplate3":
            return 25
        return 40
    
    def _get_unit_type(self, unit_id: str) -> str:
        """Get the type of a unit (humanoid, beast, etc.)."""
        # Simulate unit types
        if unit_id == "target":
            return "humanoid"
        elif unit_id == "nameplate1":
            return "beast"
        elif unit_id == "nameplate2":
            return "undead"
        return "humanoid"
    
    def _get_unit_debuffs(self, unit_id: str) -> List[str]:
        """Get a list of debuffs on a unit."""
        # Simulate debuffs
        if unit_id == "target":
            return ["serpent_sting"]
        return []
    
    def _get_unit_marker(self, unit_id: str) -> Optional[str]:
        """Get the raid target marker on a unit, if any."""
        # Simulate markers
        if unit_id == "target":
            return "skull"
        elif unit_id == "nameplate1":
            return "cross"
        return None
    
    def _get_player_buffs(self) -> List[Dict[str, Any]]:
        """Get a list of buffs on the player."""
        # Simulate buffs
        return [
            {"name": "slice_and_dice", "duration": 15},
            {"name": "battle_shout", "duration": 120}
        ]
    
    def _get_player_debuffs(self) -> List[Dict[str, Any]]:
        """Get a list of debuffs on the player."""
        # Simulate debuffs
        return []
    
    def _get_cooldowns(self) -> Dict[str, float]:
        """Get the remaining cooldown time for various abilities."""
        # Simulate cooldowns
        return {
            "vanish": 0,
            "sprint": 30,
            "evasion": 0
        }
    
    def _is_hostile(self, unit_id: str) -> bool:
        """Check if a unit is hostile to the player."""
        # Simulate hostility
        return not unit_id.startswith("party")


class ActionEvaluator:
    """Base class for action evaluators."""
    
    def __init__(self):
        """Initialize the action evaluator."""
        pass
    
    def evaluate_actions(self, state_monitor: StateMonitor) -> List[Tuple[str, float, Optional[str]]]:
        """
        Evaluate possible actions and return scored actions.
        
        Args:
            state_monitor: The state monitor with current game state
            
        Returns:
            List of tuples (action_name, score, target)
        """
        # This is an abstract base class
        raise NotImplementedError("Subclasses must implement evaluate_actions")


class RogueActionEvaluator(ActionEvaluator):
    """Action evaluator for rogues."""
    
    def __init__(self, player_level: int):
        """
        Initialize the rogue action evaluator.
        
        Args:
            player_level: The player's level, which affects available abilities
        """
        super().__init__()
        self.player_level = player_level
        
        # Initialize base weights for actions
        self.action_weights = {
            # Damage abilities
            "sinister_strike": 70,
            "eviscerate": 80,
            
            # Utility abilities
            "slice_and_dice": 85,
            "kick": 90,
            
            # Defensive abilities
            "evasion": 95,
            "sprint": 60,
            "vanish": 98,
            
            # Crowd control
            "sap": 88,
            "blind": 87,
            "gouge": 85
        }
    
    def evaluate_actions(self, state_monitor: StateMonitor) -> List[Tuple[str, float, Optional[str]]]:
        """
        Evaluate possible actions for a rogue.
        
        Args:
            state_monitor: The state monitor with current game state
            
        Returns:
            List of tuples (action_name, score, target)
        """
        scored_actions = []
        
        # Add actions from different categories
        scored_actions.extend(self._evaluate_emergency_actions(state_monitor))
        scored_actions.extend(self._evaluate_interrupts(state_monitor))
        scored_actions.extend(self._evaluate_buffs(state_monitor))
        scored_actions.extend(self._evaluate_finishers(state_monitor))
        scored_actions.extend(self._evaluate_builders(state_monitor))
        
        return scored_actions
    
    def _evaluate_emergency_actions(self, state_monitor: StateMonitor) -> List[Tuple[str, float, Optional[str]]]:
        """Evaluate emergency defensive actions."""
        scored_actions = []
        player_health = state_monitor.player_state.get("health_percent", 100)
        
        # Vanish if very low health and ability is available
        if player_health < 20 and state_monitor.player_state["cooldowns"].get("vanish", 0) == 0:
            scored_actions.append(("vanish", 1000, "self"))
        
        # Evasion if low health, multiple enemies, and ability is available
        if (player_health < 40 and 
            state_monitor.combat_state.get("enemy_count", 0) >= 2 and
            state_monitor.player_state["cooldowns"].get("evasion", 0) == 0):
            scored_actions.append(("evasion", 950, "self"))
        
        # Sprint to escape if low health
        if (player_health < 25 and 
            state_monitor.player_state["cooldowns"].get("sprint", 0) == 0):
            scored_actions.append(("sprint", 900, "self"))
        
        return scored_actions
    
    def _evaluate_interrupts(self, state_monitor: StateMonitor) -> List[Tuple[str, float, Optional[str]]]:
        """Evaluate interrupt actions."""
        scored_actions = []
        
        # Check for casting targets within range
        for unit_id, state in state_monitor.unit_states.items():
            if state.get("is_casting", False) and state.get("distance", 100) <= 8:
                # High priority for interrupting casts
                scored_actions.append(("kick", 900, unit_id))
        
        return scored_actions
    
    def _evaluate_buffs(self, state_monitor: StateMonitor) -> List[Tuple[str, float, Optional[str]]]:
        """Evaluate buff maintenance actions."""
        scored_actions = []
        
        # Check if Slice and Dice is active
        slice_and_dice_active = any(buff["name"] == "slice_and_dice" 
                                  for buff in state_monitor.player_state.get("buffs", []))
        
        # If we have combo points and Slice and Dice is not active, prioritize it
        combo_points = state_monitor.player_state.get("combo_points", 0)
        if combo_points >= 1 and not slice_and_dice_active:
            # Score is higher with more combo points, but we want to refresh rather than wait too long
            score = 800 + (combo_points * 20)
            scored_actions.append(("slice_and_dice", score, "self"))
        
        return scored_actions
    
    def _evaluate_finishers(self, state_monitor: StateMonitor) -> List[Tuple[str, float, Optional[str]]]:
        """Evaluate combo point finishers."""
        scored_actions = []
        
        combo_points = state_monitor.player_state.get("combo_points", 0)
        
        # Only consider finishers if we have enough combo points
        if combo_points >= 4:
            # Check if we have a target in range
            target_in_range = any(state.get("distance", 100) <= 8 
                                for unit_id, state in state_monitor.unit_states.items()
                                if unit_id != "player")
            
            if target_in_range:
                # Target's health influences decision
                target_health = state_monitor.unit_states.get("target", {}).get("health_percent", 100)
                
                # Prioritize according to situation
                if target_health < 20:
                    # Target about to die - use Eviscerate
                    scored_actions.append(("eviscerate", 850, "target"))
                else:
                    # Normal rotation - use Eviscerate for damage
                    scored_actions.append(("eviscerate", 800, "target"))
        
        return scored_actions
    
    def _evaluate_builders(self, state_monitor: StateMonitor) -> List[Tuple[str, float, Optional[str]]]:
        """Evaluate combo point building actions."""
        scored_actions = []
        
        # Check if we have a target in melee range
        target_in_range = any(state.get("distance", 100) <= 8 
                            for unit_id, state in state_monitor.unit_states.items()
                            if unit_id != "player")
        
        # Check if we have energy for Sinister Strike
        energy = state_monitor.player_state.get("power_current", 0)
        combo_points = state_monitor.player_state.get("combo_points", 0)
        
        if target_in_range and energy >= 45 and combo_points < 5:
            # Basic builder
            scored_actions.append(("sinister_strike", 700, "target"))
        
        return scored_actions


class ActionDecisionEngine:
    """
    Core decision engine that selects the optimal action based on
    current game state.
    """
    
    def __init__(self, player_class: str, player_level: int, available_spells: List[str]):
        """
        Initialize the decision engine.
        
        Args:
            player_class: The player's class (lowercase)
            player_level: The player's level
            available_spells: List of spells the player has learned
        """
        self.player_class = player_class
        self.player_level = player_level
        self.available_spells = available_spells
        
        # Initialize state monitor
        self.state_monitor = StateMonitor()
        
        # Load appropriate action evaluator based on class
        self.action_evaluator = self._load_action_evaluator()
        
        # Tracking variables
        self.last_decision_time = 0
        self.last_decision = None
        self.decision_interval = 0.1  # seconds
        
        # Performance tracking
        self.performance_metrics = {
            "decision_time_ms": [],
            "state_update_time_ms": [],
            "decisions_per_second": 0
        }
        
        logger.info(f"Decision Engine initialized for {player_class} (level {player_level})")
    
    def _load_action_evaluator(self) -> ActionEvaluator:
        """
        Load the appropriate action evaluator for the player's class.
        
        Returns:
            An ActionEvaluator instance
        """
        if self.player_class == "rogue":
            return RogueActionEvaluator(self.player_level)
        # Add more evaluators for other classes
        else:
            logger.warning(f"No specific evaluator for class {self.player_class}, using generic")
            return ActionEvaluator()
    
    def determine_best_action(self) -> Tuple[Optional[str], float, Optional[str]]:
        """
        Determine the best action based on current state.
        
        Returns:
            Tuple of (action_name, score, target) or (None, 0, None) if no action
        """
        current_time = time.time()
        
        # Throttle decision-making for performance
        if current_time - self.last_decision_time < self.decision_interval:
            return self.last_decision or (None, 0, None)
        
        # Start timing for performance metrics
        start_time = time.time()
        
        # Update state information
        state_updated = self.state_monitor.update_all_states()
        state_update_time = time.time() - start_time
        self.performance_metrics["state_update_time_ms"].append(state_update_time * 1000)
        
        # If state update failed, return last decision
        if not state_updated:
            return self.last_decision or (None, 0, None)
        
        # Start timing the decision process
        decision_start_time = time.time()
        
        try:
            # Get scored actions from the evaluator
            scored_actions = self.action_evaluator.evaluate_actions(self.state_monitor)
            
            # Filter out actions that are not available
            scored_actions = [
                (action, score, target) for action, score, target in scored_actions
                if action in self.available_spells
            ]
            
            # Sort by score (descending)
            scored_actions.sort(key=lambda x: x[1], reverse=True)
            
            # Record the decision
            self.last_decision = scored_actions[0] if scored_actions else (None, 0, None)
            self.last_decision_time = current_time
            
            # Calculate decision time for metrics
            decision_time = time.time() - decision_start_time
            self.performance_metrics["decision_time_ms"].append(decision_time * 1000)
            
            # Update decisions per second metric
            self._update_performance_metrics()
            
            return self.last_decision
            
        except Exception as e:
            logger.error(f"Error determining best action: {e}")
            return (None, 0, None)
    
    def _update_performance_metrics(self):
        """Update performance metrics."""
        # Calculate decisions per second over the last 100 decisions
        if len(self.performance_metrics["decision_time_ms"]) > 1:
            avg_decision_time = sum(self.performance_metrics["decision_time_ms"][-100:]) / min(100, len(self.performance_metrics["decision_time_ms"]))
            self.performance_metrics["decisions_per_second"] = 1000 / avg_decision_time if avg_decision_time > 0 else 0
        
        # Trim metrics lists to keep only recent entries
        max_entries = 1000
        if len(self.performance_metrics["decision_time_ms"]) > max_entries:
            self.performance_metrics["decision_time_ms"] = self.performance_metrics["decision_time_ms"][-max_entries:]
        if len(self.performance_metrics["state_update_time_ms"]) > max_entries:
            self.performance_metrics["state_update_time_ms"] = self.performance_metrics["state_update_time_ms"][-max_entries:]
    
    def get_performance_report(self) -> Dict[str, Any]:
        """
        Get a performance report.
        
        Returns:
            Dictionary with performance metrics
        """
        return {
            "avg_decision_time_ms": sum(self.performance_metrics["decision_time_ms"][-100:]) / max(1, min(100, len(self.performance_metrics["decision_time_ms"]))),
            "avg_state_update_time_ms": sum(self.performance_metrics["state_update_time_ms"][-100:]) / max(1, min(100, len(self.performance_metrics["state_update_time_ms"]))),
            "decisions_per_second": self.performance_metrics["decisions_per_second"],
            "total_decisions": len(self.performance_metrics["decision_time_ms"])
        }


class ActionExecutor:
    """
    Executes actions by sending key presses to the game.
    """
    
    def __init__(self, key_mapping: Dict[str, str]):
        """
        Initialize the action executor.
        
        Args:
            key_mapping: Mapping from action names to key bindings
        """
        self.key_mapping = key_mapping
        self.last_execution_time = 0
        self.execution_interval = 0.1  # seconds - global cooldown-like throttling
        
        logger.info(f"Action Executor initialized with {len(key_mapping)} key bindings")
    
    def execute_action(self, action_name: str, target: Optional[str] = None) -> bool:
        """
        Execute an action by pressing the corresponding key.
        
        Args:
            action_name: Name of the action to execute
            target: Optional target for the action
            
        Returns:
            bool: True if action was executed, False otherwise
        """
        current_time = time.time()
        
        # Throttle action execution
        if current_time - self.last_execution_time < self.execution_interval:
            return False
        
        # Check if the action has a key binding
        if action_name not in self.key_mapping:
            logger.warning(f"No key binding for action {action_name}")
            return False
        
        try:
            key_to_press = self.key_mapping[action_name]
            
            # Log the action
            logger.info(f"Executing action: {action_name} with key: {key_to_press} (target: {target})")
            
            # In a real implementation, this would press the key
            # Here we just simulate it
            print(f"[ACTION] Pressing key {key_to_press} for action {action_name} (target: {target})")
            
            # Update last execution time
            self.last_execution_time = current_time
            
            return True
        except Exception as e:
            logger.error(f"Error executing action {action_name}: {e}")
            return False


class DecisionEngineManager:
    """
    High-level manager that coordinates the decision engine and action executor.
    
    This is the main class that should be used by external code.
    """
    
    def __init__(self, config_file: str):
        """
        Initialize the decision engine manager.
        
        Args:
            config_file: Path to the configuration file
        """
        self.config = self._load_config(config_file)
        
        # Initialize components
        self.decision_engine = ActionDecisionEngine(
            player_class=self.config["player"]["class"],
            player_level=self.config["player"]["level"],
            available_spells=self.config["player"]["available_spells"]
        )
        
        self.action_executor = ActionExecutor(
            key_mapping=self.config["key_mapping"]
        )
        
        # Tracking variables
        self.running = False
        self.loop_interval = 0.05  # seconds
        
        logger.info("Decision Engine Manager initialized")
    
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
            # Return default configuration
            return {
                "player": {
                    "class": "rogue",
                    "level": 60,
                    "available_spells": [
                        "sinister_strike", "eviscerate", "slice_and_dice",
                        "kick", "evasion", "sprint", "vanish"
                    ]
                },
                "key_mapping": {
                    "sinister_strike": "1",
                    "eviscerate": "2",
                    "slice_and_dice": "3",
                    "kick": "4",
                    "evasion": "5",
                    "sprint": "6",
                    "vanish": "7"
                }
            }
    
    def start(self):
        """Start the decision engine loop."""
        if self.running:
            logger.warning("Decision engine already running")
            return
        
        self.running = True
        logger.info("Decision engine started")
        
        try:
            # Main loop
            while self.running:
                self._process_one_cycle()
                time.sleep(self.loop_interval)
        except KeyboardInterrupt:
            logger.info("Decision engine stopped by user")
            self.running = False
        except Exception as e:
            logger.error(f"Error in decision engine loop: {e}")
            self.running = False
    
    def stop(self):
        """Stop the decision engine loop."""
        self.running = False
        logger.info("Decision engine stopped")
    
    def _process_one_cycle(self):
        """Process one cycle of the decision loop."""
        # Determine best action
        action, score, target = self.decision_engine.determine_best_action()
        
        # Execute the action if one was selected
        if action and score > 0:
            self.action_executor.execute_action(action, target)
    
    def get_status(self) -> Dict[str, Any]:
        """
        Get the current status of the decision engine.
        
        Returns:
            Dict with status information
        """
        # Get performance metrics
        performance = self.decision_engine.get_performance_report()
        
        # Get current state summary
        state_monitor = self.decision_engine.state_monitor
        
        # Prepare a summary of the current state
        state_summary = {
            "player": {
                "health": state_monitor.player_state.get("health_percent", 0),
                "power": state_monitor.player_state.get("power_current", 0),
                "combo_points": state_monitor.player_state.get("combo_points", 0),
                "in_combat": state_monitor.player_state.get("in_combat", False)
            },
            "target": {
                "exists": "target" in state_monitor.unit_states,
                "health": state_monitor.unit_states.get("target", {}).get("health_percent", 0),
                "distance": state_monitor.unit_states.get("target", {}).get("distance", 0)
            },
            "combat": {
                "enemy_count": state_monitor.combat_state.get("enemy_count", 0),
                "emergency": state_monitor.combat_state.get("emergency", False)
            }
        }
        
        # Get the last decision
        last_decision = self.decision_engine.last_decision or (None, 0, None)
        
        return {
            "running": self.running,
            "performance": performance,
            "state": state_summary,
            "last_decision": {
                "action": last_decision[0],
                "score": last_decision[1],
                "target": last_decision[2]
            }
        }


def main():
    """Main entry point when run as a script."""
    import argparse
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Dynamic Action Selection Engine")
    parser.add_argument("--config", default="config.json", help="Path to configuration file")
    parser.add_argument("--debug", action="store_true", help="Enable debug logging")
    args = parser.parse_args()
    
    # Set logging level
    if args.debug:
        logger.setLevel(logging.DEBUG)
    
    # Initialize and start the decision engine
    manager = DecisionEngineManager(args.config)
    
    try:
        manager.start()
    except KeyboardInterrupt:
        print("\nStopping decision engine...")
    finally:
        manager.stop()


if __name__ == "__main__":
    main() 