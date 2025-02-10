import json
from pathlib import Path
import time
import datetime
import os
from typing import Any
import sys

class TestingLogger:
    def __init__(self, log_path):
        """Initialize the logger with a path"""
        self.log_path = Path(log_path)
        self.error_count = 0
        self.log_file = None
        self._open_log_file()
        self.start_time = time.time()
        self.test_results = []
        self.sections = []

    def _open_log_file(self):
        """Open the log file for writing"""
        try:
            # Ensure directory exists
            self.log_path.parent.mkdir(parents=True, exist_ok=True)
            
            # Open file with UTF-8 encoding
            self.log_file = open(self.log_path, 'w', encoding='utf-8')
            
            # Write initial header
            timestamp = datetime.datetime.now().isoformat()
            self.write(f"=== TEST ENVIRONMENT ===")
            self.write(f"Python Version: {sys.version}")
            self.write(f"Platform: {sys.platform}")
            self.write(f"Working Directory: {os.getcwd()}")
            self.write(f"Log File: {self.log_path}")
            self.write(f"Timestamp: {timestamp}")
            
        except Exception as e:
            print(f"ERROR opening log file: {e}")
            raise

    @classmethod
    def create(cls, log_path):
        """Create a new logger instance"""
        logger = cls(log_path)
        return logger

    def write(self, message: str):
        """Write a message to the log"""
        try:
            if self.log_file and not self.log_file.closed:
                self.log_file.write(f"{message}\n")
                self.log_file.flush()
        except Exception as e:
            print(f"ERROR writing to log: {e}")
            raise

    def write_section(self, section_name: str, data: Any):
        """Write a section with formatted data"""
        try:
            self.write(f"=== {section_name} ===")
            if isinstance(data, (dict, list)):
                self.write(json.dumps(data, indent=2))
            else:
                self.write(str(data))
        except Exception as e:
            print(f"ERROR writing section: {e}")
            raise

    def log_state(self, state, label=None):
        """Log state snapshot with optional label"""
        try:
            section_name = label if label else "STATE"
            self.write_section(section_name, state)
            print(f"DEBUG: Logged state: {section_name}")
        except Exception as e:
            print(f"ERROR logging state: {e}")

    def log_debug(self, message):
        """Log debug message"""
        try:
            self.write_section("DEBUG", message)
            print(f"DEBUG: Logged debug message")
        except Exception as e:
            print(f"ERROR logging debug: {e}")

    def log_error(self, message: str, error=None, context=None):
        """Log an error with optional context"""
        try:
            error_data = {
                "message": message,
                "error": str(error) if error else None,
                "context": context,
                "timestamp": datetime.datetime.now().isoformat()
            }
            self.write_section("ERROR", error_data)
            self.error_count += 1
        except Exception as e:
            print(f"ERROR logging error: {e}")

    def log_result(self, result):
        """Log test result"""
        self.write_section("TEST RESULT", {
            "success": result.success,
            "message": result.message,
            "details": result.details,
            "error": str(result.error) if result.error else None
        })

    def close(self):
        """Close the logger properly"""
        if hasattr(self, 'log_file') and self.log_file and not self.log_file.closed:
            try:
                self.write("=== CLEANUP COMPLETE ===")
                self.log_file.close()
            except Exception as e:
                print(f"ERROR closing log file: {e}")
                raise

    def __del__(self):
        """Ensure logger is closed on deletion"""
        self.close()

    def log_scanner_state(self, scanner_test, event_name=None):
        """Log detailed scanner state for debugging"""
        try:
            state = {
                "timestamp": time.time(),
                "event": event_name,
                "marks": scanner_test.lua.eval("aura_env.marks"),
                "seen_targets": scanner_test.lua.eval("aura_env.seenTargets"),
                "skull_guid": scanner_test.lua.eval("aura_env.skullGUID"),
                "last_scan": scanner_test.lua.eval("aura_env.last"),
                "current_target": scanner_test.lua.eval("UnitGUID('target')"),
                "throttle_active": scanner_test.lua.eval("GetTime() - (aura_env.last or 0) <= 0.2"),
                "lua_globals": {
                    "ns": scanner_test.lua.eval("type(ns)"),
                    "aura_env": scanner_test.lua.eval("type(aura_env)"),
                    "WeakAuras": scanner_test.lua.eval("type(WeakAuras)")
                },
                "profile_state": {
                    "combat": scanner_test.lua.eval("InCombatLockdown()"),
                    "targeting": scanner_test.lua.eval("UnitExists('target')")
                }
            }
            
            self.write_section("SCANNER STATE", state)
            
        except Exception as e:
            self.log_error("Failed to log scanner state", error=e, context={
                "event": event_name,
                "lua_state": "Failed to evaluate"
            }) 