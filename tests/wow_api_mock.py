from typing import Dict, Optional, Tuple, List, Any, Set, TYPE_CHECKING, Callable, Union
from dataclasses import dataclass, field
import random
import time
import math

if TYPE_CHECKING:
    from test_helpers import TestLogger

@dataclass
class UnitState:
    """Container for unit state information"""
    guid: str
    name: str
    level: int = 60
    health: int = 100
    health_max: int = 100
    power: Dict[str, int] = field(default_factory=lambda: {"mana": 100})
    power_max: Dict[str, int] = field(default_factory=lambda: {"mana": 100})
    is_player: bool = False
    is_enemy: bool = True
    is_visible: bool = True
    creature_type: str = "Humanoid"
    is_dead: bool = False
    phase: int = 0
    tap_denied: bool = False
    classification: str = "normal"  # normal, elite, rare, rareelite, worldboss
    in_combat: bool = False

@dataclass
class NamePlateInfo:
    """Container for nameplate information"""
    unit_id: str
    guid: str
    position: Tuple[float, float, float]
    is_visible: bool = True
    in_range: bool = True
    distance: float = 0.0

@dataclass
class CastInfo:
    """Container for casting information"""
    spell_name: str
    text: str = ""
    texture: str = ""
    start_time: float = field(default_factory=time.time)
    end_time: float = field(default_factory=lambda: time.time() + 1.5)
    is_trade_skill: bool = False
    cast_id: int = field(default_factory=lambda: random.randint(1, 1000))
    not_interruptible: bool = False
    is_channeling: bool = False

@dataclass
class MovementInfo:
    """Container for unit movement information"""
    speed: float = 0.0
    direction: Tuple[float, float, float] = (0.0, 0.0, 0.0)
    is_moving: bool = False
    last_update: float = field(default_factory=time.time)

@dataclass
class ThreatInfo:
    """Container for unit threat information"""
    isTanking: bool = False
    status: int = 0  # Classic: 0-3, Retail: 0-100
    threatPct: float = 0.0
    rawThreat: float = 0.0
    threatValue: float = 0.0

@dataclass
class TargetState:
    """Container for target state information"""
    guid: Optional[str] = None
    last_target_time: float = field(default_factory=time.time)
    target_attempts: int = 0
    target_changes: List[Tuple[str, float]] = field(default_factory=list)
    scan_lock: bool = False
    scan_cooldown: float = 0.0

@dataclass
class ScanState:
    """Container for target scanning state"""
    last_scan: float = field(default_factory=time.time)
    scan_lock: bool = False
    scan_cooldown: float = 0.0
    last_guid: Optional[str] = None
    seen_guids: Set[str] = field(default_factory=set)
    scan_attempts: int = 0

@dataclass
class MarkingState:
    """Container for raid target marking state"""
    last_mark_time: float = field(default_factory=time.time)
    mark_attempts: int = 0
    mark_failures: int = 0
    mark_history: List[Dict[str, Any]] = field(default_factory=list)

class WoWAPIMock:
    """Enhanced WoW API Mock with version-specific behavior"""
    def __init__(self, wow_version: str = "classic", class_type: str = "WARRIOR"):
        """Initialize WoW API Mock with version and class settings"""
        self.wow_version = wow_version
        self.class_type = class_type.upper()
        
        # Initialize combat state
        self.in_combat = False
        self.combat_time = 0.0
        self.combat_log = []
        
        # Initialize raid target marks
        self.raid_targets = {}
        
        # Version-specific configuration
        self.version_config = {
            "classic": {
                "has_focus": False,
                "max_nameplate_distance": float('inf'),
                "threat_levels": [0, 1, 2, 3],
                "has_warmode": False,
                "has_mythic_plus": False
            },
            "retail": {
                "has_focus": True,
                "max_nameplate_distance": 60,
                "threat_range": (0, 100),
                "has_warmode": True,
                "has_mythic_plus": True
            }
        }[wow_version]

        # Class-specific configuration
        self.class_config = {
            "HUNTER": {
                "power_type": "mana",
                "has_pet": True,
                "can_feign_death": True
            },
            "ROGUE": {
                "power_type": "energy",
                "has_stealth": True,
                "can_pick_pocket": True
            },
            "WARRIOR": {
                "power_type": "rage",
                "can_charge": True,
                "can_intercept": True
            }
        }.get(self.class_type, {})

        # Initialize state containers
        self.units = {}
        self.target_state = TargetState()
        self.frame_time = 0.0
        self.global_cooldown = 0.0
        self.movement = {}
        self.marks = {}
        self.current_target = None
        self.current_focus = None
        self.combat_state = False
        self.combat_units = set()
        self.nameplates = {}
        self.visible_nameplates = set()
        self.casting_info = {}
        self.logger = None
        
        # Version-specific API availability
        self.api_availability = {
            "classic": {
                "UnitPhaseReason": False,
                "UnitThreatSituation": True,
                "SetFocus": False,
                "GetFocus": False,
                "IsInPersonalLoot": False,
                "IsWarModeDesired": False,
                "IsMythicPlusActive": False
            },
            "retail": {
                "UnitPhaseReason": True,
                "UnitThreatSituation": True,
                "SetFocus": True,
                "GetFocus": True,
                "IsInPersonalLoot": True,
                "IsWarModeDesired": True,
                "IsMythicPlusActive": True
            }
        }

        # Core state
        self.current_time = 0.0
        self.last_update = time.time()
        self.current_time = time.time()
        
        # Nameplate specific state
        self.nameplate_distance: float = self.version_config["max_nameplate_distance"]
        self.player_position: Tuple[float, float, float] = (0.0, 0.0, 0.0)
        
        # Add to existing init
        self.last_action_time: float = 0.0

        # Add scan state tracking
        self.scan_state = ScanState()
        self.scan_history = []

        self.marking_state = MarkingState()

        self.timing_constants = {
            'NAMEPLATE_UPDATE_DELAY': 0.1,
            'TARGET_CHANGE_DELAY': 0.2,
            'MARK_APPLICATION_DELAY': 0.05
        }

    def _check_api_availability(self, api_name: str) -> bool:
        """Check if API is available for current version"""
        return self.api_availability.get(self.wow_version, {}).get(api_name, True)

    def get_functions(self) -> Dict[str, Callable]:
        """Get all available API functions for current version"""
        functions = {}
        for name in dir(self):
            if name.startswith('_'):
                continue
            func = getattr(self, name)
            if callable(func) and self._check_api_availability(name):
                functions[name] = func
        return functions

    def expose_api(self, lua):
        """Expose version-appropriate WoW API functions to Lua environment"""
        # Core unit functions (available in all versions)
        lua.globals().UnitExists = self.UnitExists
        lua.globals().UnitGUID = self.UnitGUID
        lua.globals().UnitName = self.UnitName
        lua.globals().UnitLevel = self.UnitLevel
        lua.globals().UnitHealth = self.UnitHealth
        lua.globals().UnitHealthMax = self.UnitHealthMax
        lua.globals().UnitPower = self.UnitPower
        lua.globals().UnitIsPlayer = self.UnitIsPlayer
        lua.globals().UnitIsEnemy = self.UnitIsEnemy
        
        # Version-specific functions
        if self.version_config["has_focus"]:
            lua.globals().GetFocus = self.GetFocus
            lua.globals().SetFocus = self.SetFocus
            
        # Expose threat functions appropriate to version
        if self.wow_version == "classic":
            lua.globals().UnitThreatSituation = self.UnitThreatSituationClassic
        else:
            lua.globals().UnitThreatSituation = self.UnitThreatSituationRetail
            
        # Additional version-specific APIs
        if self.version_config["has_warmode"]:
            lua.globals().IsWarModeDesired = self.IsWarModeDesired
        if self.version_config["has_mythic_plus"]:
            lua.globals().IsMythicPlusActive = self.IsMythicPlusActive
            
        # Common functions for all versions
        lua.globals().GetRaidTargetIndex = self.GetRaidTargetIndex
        lua.globals().SetRaidTarget = self.SetRaidTarget
        lua.globals().GetNamePlateForUnit = self.GetNamePlateForUnit
        lua.globals().GetNamePlates = self.GetNamePlates
        lua.globals().GetNumNamePlates = self.GetNumNamePlates

    def UnitThreatSituationClassic(self, unit: str) -> Optional[int]:
        """Classic version of threat situation (0-3)"""
        if unit in self.units:
            return random.randint(*self.version_config["threat_range"])
        return None

    def UnitThreatSituationRetail(self, unit: str) -> Optional[int]:
        """Retail version of threat situation (0-100)"""
        if unit in self.units:
            return random.randint(*self.version_config["threat_range"])
        return None

    def IsWarModeDesired(self) -> bool:
        """Check if war mode is enabled (retail only)"""
        if not self.version_config["has_warmode"]:
            return False
        return random.choice([True, False])

    def IsMythicPlusActive(self) -> bool:
        """Check if current instance is Mythic+ (retail only)"""
        if not self.version_config["has_mythic_plus"]:
            return False
        return random.choice([True, False])

    def GetFocus(self) -> Optional[str]:
        """Get focus target (retail only)"""
        if not self.version_config["has_focus"]:
            return None
        return self.current_focus

    def SetFocus(self, unit: str) -> bool:
        """Set focus target (retail only)"""
        if not self.version_config["has_focus"]:
            return False
        if unit in self.units:
            self.current_focus = unit
            return True
        return False

    # Unit Management
    def UnitExists(self, unit: str) -> bool:
        """Check if unit exists"""
        return unit in self.units
        
    def UnitGUID(self, unit: str) -> Optional[str]:
        """Get unit GUID"""
        if unit in self.units:
            return self.units[unit].guid
        return None
        
    def UnitName(self, unit: str) -> Optional[str]:
        """Get unit name"""
        if unit in self.units:
            return self.units[unit].name
        return None
        
    def UnitLevel(self, unit: str) -> Optional[int]:
        """Get unit level"""
        if unit in self.units:
            return self.units[unit].level
        return None
        
    def UnitHealth(self, unit: str) -> Optional[int]:
        """Get current unit health"""
        if unit in self.units:
            return self.units[unit].health
        return None
        
    def UnitHealthMax(self, unit: str) -> Optional[int]:
        """Get unit max health"""
        if unit in self.units:
            return self.units[unit].health_max
        return None
        
    def UnitPower(self, unit: str, power_type: str = "mana") -> Optional[int]:
        """Get unit power (mana, rage, energy, etc)"""
        if unit in self.units:
            return self.units[unit].power.get(power_type)
        return None
        
    def UnitIsPlayer(self, unit: str) -> bool:
        """Check if unit is a player"""
        if unit in self.units:
            return self.units[unit].is_player
        return False
        
    def UnitIsEnemy(self, unit: str) -> bool:
        """Check if unit is an enemy"""
        if unit in self.units:
            return self.units[unit].is_enemy
        return False

    # Target Management
    def GetTarget(self) -> Optional[str]:
        """Get current target"""
        return self.current_target
        
    def SetTarget(self, unit: str) -> bool:
        """Set current target"""
        if unit in self.units:
            self.current_target = unit
            return True
        return False
        
    def GetFocus(self) -> Optional[str]:
        """Get current focus target"""
        return self.current_focus
        
    def SetFocus(self, unit: str) -> bool:
        """Set focus target"""
        if unit in self.units:
            self.current_focus = unit
            return True
        return False
        
    def ClearTarget(self) -> None:
        """Clear current target"""
        self.current_target = None

    # Raid Target Management
    def GetRaidTargetIndex(self, unit: str) -> Optional[int]:
        """Get raid target mark for unit"""
        return self.marks.get(unit)
        
    def SetRaidTarget(self, unit: str, mark: int) -> bool:
        """Set raid target mark with realistic failure conditions"""
        current_time = time.time()
        
        # Record attempt
        self.marking_state.mark_attempts += 1
        
        # Simulate real-world marking failures
        if current_time - self.marking_state.last_mark_time < 0.1:
            self.marking_state.mark_failures += 1
            return False
            
        if unit in self.units:
            unit_state = self.units[unit]
            # Simulate marking failures due to unit state
            if not unit_state.is_visible or unit_state.is_dead:
                self.marking_state.mark_failures += 1
                return False
                
            self.marks[unit] = {
                'mark': mark,
                'timestamp': current_time,
                'guid': unit_state.guid
            }
            
            # Record successful mark
            self.marking_state.mark_history.append({
                'time': current_time,
                'unit': unit,
                'mark': mark,
                'guid': unit_state.guid,
                'attempt': self.marking_state.mark_attempts
            })
            
            self.marking_state.last_mark_time = current_time
            return True
            
        return False

    def set_raid_target(self, unit: str, mark: int) -> None:
        """Set raid target mark on a unit with timestamp"""
        if unit in self.units:
            self.raid_targets[unit] = {
                'mark': mark,
                'timestamp': self.current_time
            }

    def get_raid_target(self, unit: str) -> Optional[int]:
        """Get raid target mark for a unit"""
        if unit in self.raid_targets:
            mark_info = self.raid_targets[unit]
            if mark_info['timestamp'] + 30 >= self.current_time:  # 30-second timeout
                return mark_info['mark']
            else:
                del self.raid_targets[unit]
        return None

    def clear_raid_target(self, unit: str) -> None:
        """Clear raid target mark from a unit"""
        if unit in self.raid_targets:
            del self.raid_targets[unit]

    def has_raid_target(self, unit: str) -> bool:
        """Check if unit has any raid target mark"""
        return unit in self.raid_targets

    # Nameplate Management
    def GetNamePlateForUnit(self, unit: str) -> Optional[NamePlateInfo]:
        """Get nameplate info for unit"""
        if unit in self.units and unit in self.nameplates:
            return self.nameplates[unit]
        return None
        
    def GetNamePlates(self) -> List[NamePlateInfo]:
        """Get all visible nameplates"""
        return [plate for plate in self.nameplates.values() if plate.is_visible]
        
    def SetNamePlateDistance(self, distance: float) -> None:
        """Set maximum nameplate visibility distance"""
        self.nameplate_distance = distance
        self._update_nameplate_visibility()
        
    def GetNumNamePlates(self) -> int:
        """Get number of visible nameplates"""
        return len(self.visible_nameplates)

    # Position and Range
    def UnitPosition(self, unit: str) -> Optional[Tuple[float, float, float]]:
        """Get unit's position in 3D space"""
        if unit in self.nameplates:
            return self.nameplates[unit].position
        return None
        
    def UnitDistanceSquared(self, unit: str) -> Optional[float]:
        """Get squared distance to unit (WoW API uses squared distance for performance)"""
        if unit in self.nameplates:
            pos = self.nameplates[unit].position
            return sum((a - b) ** 2 for a, b in zip(self.player_position, pos))
        return None

    # Internal Methods
    def _calculate_distance(self, pos1: Tuple[float, float, float], 
                          pos2: Tuple[float, float, float]) -> float:
        """Calculate 3D distance between points"""
        x1, y1, z1 = pos1
        x2, y2, z2 = pos2
        return math.sqrt((x2-x1)**2 + (y2-y1)**2 + (z2-z1)**2)
        
    def _update_nameplate_visibility(self) -> None:
        """Update nameplate visibility based on distance"""
        self.visible_nameplates.clear()
        for unit_id, plate in self.nameplates.items():
            distance = self._calculate_distance(self.player_position, plate.position)
            plate.distance = distance
            plate.in_range = distance <= self.nameplate_distance
            plate.is_visible = plate.in_range and self.units[unit_id].is_visible
            if plate.is_visible:
                self.visible_nameplates.add(unit_id)

    # State Management
    def set_logger(self, logger) -> None:
        """Set the logger for this instance"""
        self.logger = logger

    def log_state(self) -> Dict[str, Any]:
        """Log current state"""
        state = {
            'units': {
                unit_id: {
                    'guid': unit.guid,
                    'name': unit.name,
                    'health': unit.health,
                    'is_visible': unit.is_visible,
                    'is_dead': unit.is_dead
                }
                for unit_id, unit in self.units.items()
            },
            'current_target': self.current_target,
            'current_focus': self.current_focus,
            'marks': self.marks,
            'combat_state': self.combat_state,
            'nameplate_state': {
                'visible_nameplates': list(self.visible_nameplates),
                'nameplate_distance': self.nameplate_distance,
                'player_position': self.player_position,
                'nameplates': {
                    unit: {
                        'position': plate.position,
                        'visible': plate.is_visible,
                        'in_range': plate.in_range,
                        'distance': plate.distance
                    }
                    for unit, plate in self.nameplates.items()
                }
            },
            'casting_info': self.casting_info
        }
        
        if self.logger:
            self.logger.log_state(state, "WOW API STATE")
        return state

    def reset_state(self) -> None:
        """Reset all state"""
        self.units.clear()
        self.current_target = None
        self.current_focus = None
        self.marks.clear()
        self.combat_state = False
        self.nameplates.clear()
        self.visible_nameplates.clear()
        self.player_position = (0.0, 0.0, 0.0)
        self.nameplate_distance = self.version_config["max_nameplate_distance"]
        self.casting_info.clear()

    # Unit Creation and Management
    def add_unit(self, unit_id: str, props: dict = None) -> None:
        """Add a unit with specified properties"""
        if props is None:
            props = {}
            
        unit_state = UnitState(
            guid=f"Unit-{random.randint(1, 1000000)}",
            name=unit_id,
            is_enemy=props.get("is_enemy", True),
            in_combat=props.get("in_combat", self.in_combat)
        )
        
        # Update unit with additional properties
        for key, value in props.items():
            if hasattr(unit_state, key):
                setattr(unit_state, key, value)
                
        self.units[unit_id] = unit_state
        
        # Create nameplate for unit
        position = props.get('position', (
            random.uniform(-20, 20),
            random.uniform(-20, 20),
            random.uniform(-5, 5)
        ))
        
        self.nameplates[unit_id] = NamePlateInfo(
            unit_id=unit_id,
            guid=self.units[unit_id].guid,
            position=position
        )
        self._update_nameplate_visibility()

    def remove_unit(self, unit_id: str) -> None:
        """Remove unit and its nameplate"""
        if unit_id in self.units:
            del self.units[unit_id]
            if self.current_target == unit_id:
                self.current_target = None
            if self.current_focus == unit_id:
                self.current_focus = None
            if unit_id in self.nameplates:
                del self.nameplates[unit_id]
                self.visible_nameplates.discard(unit_id)
        
    def set_player_position(self, x: float, y: float, z: float) -> None:
        """Update player position and recalculate nameplate visibility"""
        self.player_position = (x, y, z)
        self._update_nameplate_visibility()
        
    def move_unit(self, unit_id: str, x: float, y: float, z: float) -> None:
        """Move unit to new position and update nameplate visibility"""
        if unit_id in self.nameplates:
            self.nameplates[unit_id].position = (x, y, z)
            self._update_nameplate_visibility()

    def UnitPowerMax(self, unit: str, power_type: str = "mana") -> Optional[int]:
        """Get unit's maximum power"""
        if unit in self.units:
            return self.units[unit].power_max.get(power_type)
        return None

    def UnitIsFriend(self, unit: str) -> bool:
        """Check if unit is friendly"""
        if unit in self.units:
            return not self.units[unit].is_enemy
        return False

    def UnitCreatureType(self, unit: str) -> Optional[str]:
        """Get unit's creature type"""
        if unit in self.units:
            return self.units[unit].creature_type
        return None

    def UnitAffectingCombat(self, unit: str) -> bool:
        """Check if unit is in combat"""
        if unit in self.units:
            return self.combat_state
        return False

    def IsInCombat(self) -> bool:
        """Check if player is in combat"""
        return self.combat_state

    def UnitCastingInfo(self, unit: str) -> Optional[Tuple]:
        """Get unit's casting information"""
        if unit in self.units and unit in self.casting_info:
            info = self.casting_info[unit]
            return (
                info.get("spell_name"),
                info.get("text"),
                info.get("texture"),
                info.get("start_time"),
                info.get("end_time"),
                info.get("is_trade_skill"),
                info.get("cast_id"),
                info.get("not_interruptible")
            )
        return None

    def UnitChannelInfo(self, unit: str) -> Optional[Tuple]:
        """Get unit's channeling information"""
        if unit in self.units and unit in self.casting_info:
            info = self.casting_info[unit]
            if info.get("is_channeling"):
                return (
                    info.get("spell_name"),
                    info.get("text"),
                    info.get("texture"),
                    info.get("start_time"),
                    info.get("end_time"),
                    info.get("is_trade_skill"),
                    info.get("not_interruptible")
                )
        return None

    def start_casting(self, unit: str, spell_name: str, duration: float = 1.5, 
                     not_interruptible: bool = False, is_channeling: bool = False) -> None:
        """Start a cast on the specified unit"""
        if unit in self.units:
            self.casting_info[unit] = CastInfo(
                spell_name=spell_name,
                start_time=time.time(),
                end_time=time.time() + duration,
                not_interruptible=not_interruptible,
                is_channeling=is_channeling
            )

    def stop_casting(self, unit: str) -> None:
        """Stop casting on the specified unit"""
        if unit in self.casting_info:
            del self.casting_info[unit]

    def _update_casting_state(self) -> None:
        """Update casting state for all units"""
        current_time = time.time()
        completed_casts = []
        
        for unit, cast_info in self.casting_info.items():
            if current_time >= cast_info.end_time:
                completed_casts.append(unit)
                
        for unit in completed_casts:
            self.stop_casting(unit)

    def simulate_player_movement(self, duration: float, speed: float = 7.0) -> None:
        """Simulate player movement for testing"""
        start_time = time.time()
        while time.time() - start_time < duration:
            # Update player position based on movement
            dx = speed * 0.1  # 0.1 seconds of movement
            self.player_position = (
                self.player_position[0] + dx,
                self.player_position[1],
                self.player_position[2]
            )
            self._update_nameplate_visibility()
            time.sleep(0.1)

    def set_unit_movement(self, unit: str, speed: float, 
                         direction: Tuple[float, float, float]) -> None:
        """Set unit movement parameters"""
        if unit in self.units:
            self.movement[unit] = MovementInfo(
                speed=speed,
                direction=direction,
                is_moving=speed > 0,
                last_update=time.time()
            )

    def UnitPhaseReason(self, unit: str) -> Optional[int]:
        """Get unit's phase reason"""
        if unit in self.units:
            return self.units[unit].phase
        return None

    def set_unit_state(self, unit: str, **kwargs) -> None:
        """Set multiple unit states at once"""
        if unit in self.units:
            for key, value in kwargs.items():
                if hasattr(self.units[unit], key):
                    setattr(self.units[unit], key, value)

    def set_current_target(self, unit: str) -> bool:
        """Set current target with realistic limitations"""
        current_time = time.time()
        
        # Check if we're trying to target too quickly
        if current_time - self.target_state.last_target_time < 0.1:
            self.logger.log_debug(f"Target attempt too soon: {current_time - self.target_state.last_target_time}")
            return False
            
        # Check if target is actually targetable
        if unit in self.units:
            unit_state = self.units[unit]
            if not unit_state.is_visible or not unit_state.in_range:
                self.logger.log_debug(f"Target not valid: visible={unit_state.is_visible}, in_range={unit_state.in_range}")
                return False
                
        # Record targeting attempt
        self.target_state.target_attempts += 1
        self.target_state.last_target_time = current_time
        self.target_state.target_changes.append((unit, current_time))
        self.target_state.guid = self.units[unit].guid if unit in self.units else None
        
        return True

    def target_enemy(self) -> Optional[str]:
        """Simulate /targetenemy command with realistic behavior"""
        current_time = time.time()
        
        # Enforce scan lock and cooldown
        if self.scan_state.scan_lock:
            return None
            
        if current_time - self.scan_state.scan_cooldown < 0.2:  # 200ms cooldown
            return None
            
        # Track scan attempt
        self.scan_state.scan_attempts += 1
        self.scan_state.last_scan = current_time
        
        # Get valid targets excluding recently seen GUIDs
        valid_targets = [
            unit_id for unit_id, unit in self.units.items()
            if unit.is_enemy and unit.is_visible and not unit.is_dead
            and unit.guid not in self.scan_state.seen_guids
        ]
        
        if not valid_targets:
            # Reset seen GUIDs if we've cycled through all targets
            self.scan_state.seen_guids.clear()
            valid_targets = [
                unit_id for unit_id, unit in self.units.items()
                if unit.is_enemy and unit.is_visible and not unit.is_dead
            ]
            
        if not valid_targets:
            return None
            
        # Select next target
        target = valid_targets[0]
        target_guid = self.units[target].guid
        
        # Update scan state
        self.scan_state.last_guid = target_guid
        self.scan_state.seen_guids.add(target_guid)
        self.scan_state.scan_cooldown = current_time
        
        # Record scan history
        self.scan_history.append({
            'time': current_time,
            'target': target,
            'guid': target_guid,
            'attempt': self.scan_state.scan_attempts
        })
        
        return target

    def simulate_frame(self, delta_time: float = 0.016) -> None:
        """Simulate a game frame with timing"""
        self.frame_time += delta_time
        
        # Update GCD
        if self.global_cooldown > 0:
            self.global_cooldown = max(0, self.global_cooldown - delta_time)
            
        # Update scan lock
        if self.target_state.scan_lock:
            if self.frame_time - self.target_state.last_target_time > 0.5:
                self.target_state.scan_lock = False
                
        # Update unit states
        self._update_unit_states(delta_time)
        
    def _update_unit_states(self, delta_time: float) -> None:
        """Update all unit states"""
        for unit_id, unit in self.units.items():
            # Update positions
            if unit_id in self.movement:
                move_info = self.movement[unit_id]
                if move_info.is_moving:
                    # Update position based on movement
                    new_pos = (
                        unit.position[0] + move_info.direction[0] * move_info.speed * delta_time,
                        unit.position[1] + move_info.direction[1] * move_info.speed * delta_time,
                        unit.position[2] + move_info.direction[2] * move_info.speed * delta_time
                    )
                    unit.position = new_pos

    def is_unit_visible(self, unit: str) -> bool:
        """Check if unit is visible based on version rules"""
        if not hasattr(self, '_unit_positions'):
            return True
            
        if unit not in self._unit_positions:
            return False
            
        if self.wow_version == "classic":
            return True  # Always visible in classic if unit exists
            
        # Retail distance check
        distance = self._calculate_distance(unit)
        return distance <= self.version_config["max_nameplate_distance"]
        
    def set_focus(self, unit: str) -> bool:
        """Set focus target if supported by version"""
        if not self.version_config["has_focus"]:
            return False
        self._focus_target = unit
        return True
        
    def get_threat_situation(self, unit: str) -> Union[str, int]:
        """Get threat level based on version"""
        if self.wow_version == "classic":
            # Return classic threat levels
            return random.choice(self.version_config["threat_levels"])
        else:
            # Return retail threat percentage
            return random.randint(0, 100)

    def set_combat_state(self, in_combat: bool) -> None:
        """Set player combat state"""
        self.in_combat = in_combat
        if in_combat:
            self.combat_time = time.time()
            self.combat_log.append(("ENTER_COMBAT", self.combat_time))
        else:
            self.combat_log.append(("EXIT_COMBAT", time.time()))
            self.combat_time = 0.0

    def get_combat_state(self) -> bool:
        """Get current combat state"""
        return self.in_combat

    def get_combat_time(self) -> float:
        """Get time spent in current combat"""
        if not self.in_combat:
            return 0.0
        return time.time() - self.combat_time

    def advance_time(self, seconds: float):
        """Advance the mock time by specified seconds"""
        self.current_time += seconds
        # Update any time-based state
        self._update_time_based_state()

    def _update_time_based_state(self):
        """Update any state that depends on time"""
        # Clean up expired marks
        expired_marks = []
        for unit, mark_info in self.marks.items():
            if mark_info.get('timestamp', 0) + 30 < self.current_time:  # 30-second timeout
                expired_marks.append(unit)
        
        for unit in expired_marks:
            self.clear_raid_target(unit)

    def set_target(self, unit: str) -> bool:
        """Set current target with scan state update"""
        if unit in self.units:
            self.current_target = unit
            self.scan_state.scan_lock = True
            self.scan_state.scan_cooldown = time.time()
            return True
        return False

    def clear_target(self) -> None:
        """Clear current target and update scan state"""
        self.current_target = None
        self.scan_state.scan_lock = False
        
    def get_scan_history(self) -> List[Dict[str, Any]]:
        """Get target scanning history"""
        return self.scan_history

    def verify_scan_sequence(self, expected_sequence: List[str]) -> bool:
        """Verify target scanning followed expected sequence"""
        actual_sequence = [entry['target'] for entry in self.scan_history]
        return actual_sequence == expected_sequence
        
    def get_scan_metrics(self) -> Dict[str, Any]:
        """Get metrics about scanning behavior"""
        return {
            'total_scans': self.scan_state.scan_attempts,
            'unique_targets': len(set(entry['guid'] for entry in self.scan_history)),
            'average_time_between_scans': self._calculate_scan_timing(),
            'scan_locks': sum(1 for entry in self.scan_history if entry.get('locked', False))
        }
        
    def _calculate_scan_timing(self) -> float:
        """Calculate average time between scans"""
        if len(self.scan_history) < 2:
            return 0.0
            
        times = [entry['time'] for entry in self.scan_history]
        intervals = [times[i+1] - times[i] for i in range(len(times)-1)]
        return sum(intervals) / len(intervals)

    def get_marking_metrics(self) -> Dict[str, Any]:
        """Get detailed metrics about marking behavior"""
        return {
            'total_attempts': self.marking_state.mark_attempts,
            'failures': self.marking_state.mark_failures,
            'success_rate': 1 - (self.marking_state.mark_failures / max(1, self.marking_state.mark_attempts)),
            'average_time_between_marks': self._calculate_mark_timing(),
            'duplicate_marks': self._count_duplicate_marks()
        }
        
    def _calculate_mark_timing(self) -> float:
        """Calculate average time between marks"""
        if len(self.marking_state.mark_history) < 2:
            return 0.0
            
        times = [entry['time'] for entry in self.marking_state.mark_history]
        intervals = [times[i+1] - times[i] for i in range(len(times)-1)]
        return sum(intervals) / len(intervals)

    def _count_duplicate_marks(self) -> int:
        """Count instances of duplicate marks"""
        mark_counts = {}
        for unit, mark_info in self.marks.items():
            mark = mark_info['mark']
            mark_counts[mark] = mark_counts.get(mark, 0) + 1
        return sum(count - 1 for count in mark_counts.values() if count > 1)

    def set_timing_constants(self, constants):
        """Set timing constants for the mock API"""
        self.timing_constants.update(constants)

    def GetTime(self):
        """Get the current game time in seconds"""
        now = time.time()
        self.current_time += now - self.last_update
        self.last_update = now
        return self.current_time

    def find_unit_by_mark(self, mark_id):
        """Find a unit by their raid target mark"""
        for unit_id, unit_mark in self.marks.items():
            if unit_mark == mark_id:
                return self.units.get(unit_id)
        return None

    def GetRaidTargetIndex(self, unit_id):
        """Get the raid target mark for a unit"""
        return self.marks.get(unit_id, 0)

    def SetRaidTarget(self, unit_id, mark):
        """Set a raid target mark on a unit"""
        if mark == 0:
            self.marks.pop(unit_id, None)
        else:
            self.marks[unit_id] = mark