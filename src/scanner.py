import time
import lupa

class Scanner:
    def __init__(self, wow_api=None, auras_path="AuraManager/auras"):
        """Initialize the Scanner with WoW API and auras path.
        
        Args:
            wow_api: The WoW API interface object
            auras_path: Path to the auras directory
        """
        self.wow_api = wow_api
        self.auras_path = auras_path
        self.last_scan = 0
        self.throttle_interval = 0.2
        self.marks = {}
        
    def should_scan(self):
        current_time = time.time()
        if current_time - self.last_scan > self.throttle_interval:
            self.last_scan = current_time
            return True
        return False
        
    def get_spell_priority(self, unit):
        if not unit.is_casting:
            return 0
        if not unit.is_interruptible:
            return 0
        # Add priority logic based on spell name
        return 1
        
    def is_cc_target(self, unit, cc_type):
        return unit.has_debuff(cc_type)
        
    def process_marks(self, units):
        # Sort by priority
        sorted_units = sorted(units, key=lambda x: x.priority, reverse=True)
        marks = ["STAR", "CIRCLE", "DIAMOND", "TRIANGLE"]
        
        for unit, mark in zip(sorted_units, marks):
            self.marks[unit.guid] = mark
            
    def get_unit_mark(self, unit):
        return self.marks.get(unit.guid)

    def init_lua_env(self):
        """Initialize Lua environment with WoW API"""
        try:
            self.lua = lupa.LuaRuntime(unpack_returned_tuples=True)
            
            # Initialize global namespace and addon environment
            init_code = """
                -- Global WoW environment
                _G = _G or {}
                
                -- Initialize WeakAuras namespace
                WeakAuras = WeakAuras or {}
                local ns = WeakAuras
                
                -- Initialize required tables
                ns.auras = ns.auras or {}
                ns.regions = ns.regions or {}
                ns.regionTypes = ns.regionTypes or {}
                ns.regionPrototypes = ns.regionPrototypes or {}
                
                -- Create aura_env for scanner state
                aura_env = {
                    last = 0,
                    marks = {},
                    castEndTimes = {},
                    skullGUID = nil,
                    skullTimestamp = 0,
                    seenTargets = {}
                }
                _G.aura_env = aura_env
            """
            
            if self.logger:
                self.logger.log_debug("Initializing Lua environment...")
            
            self.lua.execute(init_code)
            
            # ... rest of the initialization code ...
        except Exception as e:
            if self.logger:
                self.logger.log_error("Failed to initialize Lua environment: " + str(e))
            self.lua = None

    def get_lua_env(self):
        return self.lua
        
    def get_lua_state(self):
        return self.lua.state
        
    def get_lua_globals(self):
        return self.lua.globals()
        
    def get_lua_auras(self):
        return self.lua.globals().auras
        
    def get_lua_regions(self):
        return self.lua.globals().regions
        
    def get_lua_region_types(self):
        return self.lua.globals().regionTypes
        
    def get_lua_region_prototypes(self):
        return self.lua.globals().regionPrototypes
        
    def get_lua_aura_env(self):
        return self.lua.globals().aura_env
        
    def get_lua_last_scan(self):
        return self.lua.globals().aura_env.last
        
    def get_lua_marks(self):
        return self.lua.globals().aura_env.marks
        
    def get_lua_cast_end_times(self):
        return self.lua.globals().aura_env.castEndTimes
        
    def get_lua_skull_guid(self):
        return self.lua.globals().aura_env.skullGUID
        
    def get_lua_skull_timestamp(self):
        return self.lua.globals().aura_env.skullTimestamp
        
    def get_lua_seen_targets(self):
        return self.lua.globals().aura_env.seenTargets 