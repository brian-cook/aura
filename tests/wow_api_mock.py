from typing import Dict, Optional, Tuple, List, Any, Set, TYPE_CHECKING, Callable, Union
from dataclasses import dataclass, field
import random
import time
import math
import lupa
import logging

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
    in_range: bool = True
    position: Tuple[float, float, float] = field(default_factory=lambda: (0, 0, 0))  # Add position property
    raid_target_index: Optional[int] = None

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
    def __init__(self):
        """Initialize WoW API mock"""
        # Initialize basic attributes first
        self.current_time = 0
        self.units = {}
        self.marks = {}
        self.combat_log = []
        self.casting_info = {}  # Add casting info dictionary
        self.raid_targets = {}
        self.nameplates = {}
        self.visible_nameplates = set()
        self.current_target = None
        
        # Add version configuration
        self.wow_version = "classic"  # Default to classic
        self.version_config = {
            "has_focus": True,
            "has_warmode": False,
            "has_mythic_plus": False,
            "threat_api": "classic",  # classic or retail
            "max_nameplate_distance": 20  # Classic has 20 yard limit
        }
        
        # Create Lua runtime and initialize it immediately
        self.lua = lupa.LuaRuntime(unpack_returned_tuples=True)
        
        # Initialize global Lua state
        self.lua.execute("""
            -- Initialize global environment
            _G = _G or {}
            ns = ns or {}  -- Add ns initialization
            _G.ns = ns    -- Add ns to global environment
            -- Add has_focus function globally
            function has_focus()
                return true
            end
        """)
        
        # Initialize other required globals
        self.lua.globals()._G = self.lua.globals()
        self.lua.globals().raid_targets = {}

    def set_raid_target(self, unit, index):
        """Set raid target index for a unit"""
        self.lua.globals().raid_targets[unit] = index
        self.marks[unit] = index  # Update Python-side marks as well

    def get_raid_target(self, unit):
        """Get raid target index for a unit"""
        return self.lua.globals().raid_targets.get(unit, 0)

    def log_combat_event(self, event):
        """Add event to combat log"""
        self.combat_log.append(event)

    def initialize(self, scanner_test):
        """Initialize the mock with scanner test instance"""
        if not self.lua:
            raise RuntimeError("Cannot initialize - Lua runtime not available")
            
        self.scanner_test = scanner_test
        self.units = {}  # Reset units on initialization
        self.current_target = None
        self.raid_targets = {}
        self.nameplates = {}
        self.visible_nameplates = set()

        # Add WoW API functions to Lua environment
        self.lua.execute("""
            -- Initialize global environment and namespace
            _G = _G or {}
            ns = ns or {}
            _G.ns = ns
            
            -- Initialize global raid target storage
            _G.raid_targets = {}
            
            -- Initialize ns fields
            ns.marks = {}
            ns.seen_targets = {}
            ns.current_target = nil
            ns.skull_guid = nil
            ns.last_scan = nil
            
            -- Add raid target functions
            function GetRaidTargetIndex(unit)
                return _G.raid_targets[unit] or 0
            end
            
            function SetRaidTarget(unit, index)
                _G.raid_targets[unit] = index
            end
        """)
        
        # Initialize other required globals
        self.lua.globals()._G = self.lua.globals()
        self.lua.globals().raid_targets = {}

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
    def GetRaidTargetIndex(self, unit: str) -> int:
        """Get raid target mark (returns 0 instead of None for no mark)"""
        if unit in self.raid_targets:
            mark_info = self.raid_targets[unit]
            if not mark_info.get('expired', False):
                return mark_info['mark']
        return 0  # Return 0 for no mark instead of None
        
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

    def clear_raid_target(self, unit_id: str) -> None:
        """Clear raid target marker from a unit"""
        if not self.scanner_test:
            raise RuntimeError("WoWAPIMock not initialized - call initialize() first")
            
        if unit_id in self.raid_targets:
            del self.raid_targets[unit_id]
        self.scanner_test.lua.execute(f"""
            if GetRaidTargetIndex then
                SetRaidTarget('{unit_id}', 0)
            end
        """)

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
        self.current_time = 0.0

    # Unit Creation and Management
    def add_unit(self, unit_id: str, unit_data: dict) -> None:
        """Add a unit to the mock environment"""
        guid = unit_data.get('guid', f"guid-{unit_id}")
        name = unit_data.get('name', f"Unit_{unit_id}")
        self.units[unit_id] = UnitState(guid=guid, name=name)
        
    def set_unit_property(self, unit_id: str, property_name: str, value: Any) -> None:
        """Set a property on a unit"""
        if unit_id not in self.units:
            self.units[unit_id] = UnitState(guid=unit_id, name=f"Unit_{unit_id}")
        unit = self.units[unit_id]
        setattr(unit, property_name, value)
        
        # Handle special cases
        if property_name == 'in_range' and not value:
            # Clear mark when unit goes out of range
            if unit_id in self.raid_targets:
                self.raid_targets[unit_id] = {'mark': 0, 'expired': True}

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

    def advance_time(self, delta: float) -> None:
        """Advance the current time by delta seconds"""
        self.current_time += delta
        # Update mark expiration
        for unit_id, mark_info in self.raid_targets.items():
            if mark_info.get('timestamp', 0) + 5 < self.current_time:
                mark_info['expired'] = True

    def _update_time_based_state(self):
        """Update any state that depends on time"""
        # Clean up expired marks
        expired_marks = []
        for unit, mark_info in self.marks.items():
            if mark_info.get('timestamp', 0) + 30 < self.current_time:  # 30-second timeout
                expired_marks.append(unit)
        
        for unit in expired_marks:
            self.clear_raid_target(unit)

    def set_timing_constants(self, constants):
        """Set timing constants for the mock API"""
        self.timing_constants.update(constants)

    def GetTime(self) -> float:
        """Get current time"""
        return self.current_time

    def find_unit_by_mark(self, mark_id):
        """Find a unit by their raid target mark"""
        for unit_id, unit_mark in self.marks.items():
            if unit_mark == mark_id:
                return self.units.get(unit_id)
        return None

    def SetRaidTarget(self, unit_id, mark):
        """Set a raid target mark on a unit"""
        if mark == 0:
            self.marks.pop(unit_id, None)
        else:
            self.marks[unit_id] = mark

    def clear_target(self) -> None:
        """Clear the current target"""
        self.current_target = None

    def CheckInteractDistance(self, unit: str, distance_type: int) -> bool:
        """Check if unit is within interaction range"""
        if unit not in self.units:
            return False
        unit_state = self.units[unit]
        return unit_state.in_range

    def set_current_time(self, time_value: float) -> None:
        """Set the current time in the mock environment"""
        self.current_time = time_value
        
    def get_time(self):
        """Get the current time"""
        return self.current_time

    def advance_time(self, delta):
        """Advance the current time by delta seconds"""
        self.current_time += delta

    def setup_lua_functions(self, lua):
        """Set up WoW API functions in the Lua environment"""
        self.lua = lua
        
        # Time functions
        lua.globals()["GetTime"] = lambda: self.current_time
        
        # Unit functions
        lua.globals()["UnitGUID"] = self.unit_guid
        lua.globals()["GetRaidTargetIndex"] = self.get_raid_target_index
        lua.globals()["SetRaidTarget"] = self.set_raid_target
        
        # Initialize global tables
        lua.execute("""
            _G = _G or {}
            _G.raid_targets = _G.raid_targets or {}
        """)

        # Add has_focus function
        lua.globals()["has_focus"] = lambda: True  # Mock implementation

    def get_raid_target_index(self, unit_id: str) -> Optional[int]:
        """Get the raid target index for a unit"""
        if unit_id == "target" and self.current_target:
            unit = self.units.get(self.current_target)
            return unit.raid_target_index if unit else None
        unit = self.units.get(unit_id)
        return unit.raid_target_index if unit else None

    def set_raid_target(self, unit_id: str, index: int) -> None:
        """Set the raid target index for a unit"""
        if unit_id == "target" and self.current_target:
            unit = self.units.get(self.current_target)
            if unit:
                unit.raid_target_index = index
        elif unit_id in self.units:
            self.units[unit_id].raid_target_index = index

    def unit_guid(self, unit_id: str) -> Optional[str]:
        """Get the GUID for a unit"""
        if unit_id == "target" and self.current_target:
            unit = self.units.get(self.current_target)
            return unit.guid if unit else None
        unit = self.units.get(unit_id)
        return unit.guid if unit else None

    def set_target(self, unit_id):
        """Set the current target to the specified unit"""
        if unit_id in self.units:
            self.current_target = unit_id
            return True
        return False