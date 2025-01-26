import lupa
import os
from pathlib import Path
import re

class Scanner:
    def __init__(self, wow_api, aura_path):
        self.wow_api = wow_api
        self.aura_path = aura_path
        self.lua = None
        self.logger = wow_api.logger if hasattr(wow_api, 'logger') else None

    def init_lua_env(self):
        """Initialize Lua environment with WoW API"""
        try:
            self.lua = lupa.LuaRuntime(unpack_returned_tuples=True)
            
            # Initialize global namespace and addon environment
            init_code = """
                -- Global WoW environment
                _G = _G or {}
                
                -- Mock the addon loading environment
                local addon_name, ns = "WeakAuras", {}
                _G.WeakAuras = ns
                
                -- Initialize required tables
                ns.auras = {}
                ns.regions = {}
                ns.regionTypes = {}
                ns.regionPrototypes = {}
                
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
                self.logger.log_debug("Setting up global namespace and addon tables")
            
            self.lua.execute(init_code)
            
            # Expose WoW API functions
            api_functions = self.wow_api.get_functions()
            for name, func in api_functions.items():
                self.lua.globals()[name] = func
                if self.logger:
                    self.logger.log_debug(f"Registered WoW API function: {name}")
            
            # Verify environment setup
            if self.logger:
                self.lua.execute("""
                    if _G.WeakAuras and _G.WeakAuras.auras then
                        print("WeakAuras environment verified")
                    else
                        error("Failed to verify WeakAuras environment")
                    end
                """)
                self.logger.log_debug("Lua environment initialization complete")
            
            return True
            
        except Exception as e:
            if self.logger:
                self.logger.log_error(f"Failed to initialize Lua environment: {str(e)}")
                # Add stack trace logging
                self.logger.log_debug("Lua environment state at failure:")
                try:
                    env_state = self.lua.eval("""
                        return {
                            has_ns = _G.WeakAuras ~= nil,
                            has_auras = _G.WeakAuras and _G.WeakAuras.auras ~= nil,
                            has_aura_env = _G.aura_env ~= nil
                        }
                    """)
                    self.logger.log_debug(f"Environment state: {env_state}")
                except:
                    self.logger.log_debug("Could not retrieve environment state")
            return False

    def extract_scanner_function(self, content):
        """Extract the scanner function from WeakAuras format"""
        try:
            # Find the custom function definition
            match = re.search(r'custom\s*=\s*\[\[(function\(.*?end)\]\]', content, re.DOTALL)
            if not match:
                if self.logger:
                    self.logger.log_error("Could not find scanner function in file")
                return None
            
            scanner_code = match.group(1)
            
            # Initialize Lua environment if needed
            if self.lua is None:
                if not self.init_lua_env():
                    return None
            
            # Wrap the WeakAuras function to make it callable
            wrapped_code = f"""
                -- Ensure namespace exists
                if not _G.ns then
                    _G.ns = {{
                        auras = {{}}
                    }}
                elseif not _G.ns.auras then
                    _G.ns.auras = {{}}
                end
                
                -- Setup scanner in namespace
                _G.ns.auras["scanner_test"] = {{
                    ScanUnits = function()
                        local allstates = {{}}
                        local result = {scanner_code}
                        return result
                    end
                }}
            """
            return wrapped_code

        except Exception as e:
            if self.logger:
                self.logger.log_error(f"Failed to extract scanner function: {str(e)}")
            return None

    def load_scanner_code(self, scanner_path):
        """Load scanner code from file"""
        try:
            if self.logger:
                self.logger.log_debug(f"Loading scanner from: {scanner_path}")

            if not os.path.exists(scanner_path):
                if self.logger:
                    self.logger.log_error(f"Scanner file not found: {scanner_path}")
                return False

            with open(scanner_path, 'r', encoding='utf-8') as f:
                content = f.read()

            # Extract and modify the scanner function
            scanner_code = self.extract_scanner_function(content)
            if not scanner_code:
                return False

            # Initialize Lua environment if not already done
            if self.lua is None:
                self.init_lua_env()

            # Load the scanner code
            try:
                self.lua.execute(scanner_code)
                if self.logger:
                    self.logger.log_debug("Successfully loaded scanner code")
                return True
            except Exception as e:
                if self.logger:
                    self.logger.log_error(f"Failed to execute scanner code: {str(e)}")
                return False

        except Exception as e:
            if self.logger:
                self.logger.log_error(f"Failed to load scanner code: {str(e)}")
            return False

    def load_scanner(self, scanner_name):
        """Load scanner code from file"""
        path = Path(self.aura_path) / "auras" / f"{scanner_name}.lua"
        
        if not os.path.exists(path):
            if self.logger:
                self.logger.log_error(f"Scanner file not found: {path}")
            raise FileNotFoundError(f"Scanner file not found: {path}") 