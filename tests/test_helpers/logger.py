from datetime import datetime
import time
import json
from pathlib import Path

class TestLogger:
    """Core logging functionality for tests"""
    def __init__(self):
        self.logs = []
        
    def log_state(self, state, label=None):
        """Track test state changes"""
        timestamp = datetime.now().isoformat()
        entry = {
            "timestamp": timestamp,
            "type": "state",
            "label": label,
            "state": state
        }
        self.logs.append(entry)
        
    def log_event(self, event_type, details):
        """Record test events"""
        timestamp = datetime.now().isoformat()
        entry = {
            "timestamp": timestamp,
            "type": "event",
            "event_type": event_type,
            "details": details
        }
        self.logs.append(entry)
        
    def log_error(self, message, error=None):
        """Handle error logging"""
        timestamp = datetime.now().isoformat()
        entry = {
            "timestamp": timestamp,
            "type": "error",
            "message": message,
            "error": str(error) if error else None
        }
        self.logs.append(entry)

class TestingLogger:
    """File-based logging functionality for tests"""
    def __init__(self, log_file):
        self.log_file = log_file
        self.file = None
        
    @classmethod
    def create(cls, log_path):
        """Create a new logger instance"""
        logger = cls(log_path)
        logger.file = open(log_path, 'w', encoding='utf-8')
        return logger
        
    def write_section(self, section_name, data):
        """Write a section to the log file"""
        if self.file:
            self.file.write(f"\n=== {section_name} ===\n")
            json.dump(data, self.file, indent=2)
            self.file.write("\n")
            self.file.flush()
            
    def log_event(self, event_type, details):
        """Log test events"""
        event_data = {
            "type": event_type,
            "timestamp": time.time(),
            "details": details
        }
        self.write_section("EVENT", event_data)
        
    def log_error(self, message, error=None):
        """Log error events"""
        error_data = {
            "message": message,
            "error": str(error) if error else None,
            "timestamp": time.time()
        }
        self.write_section("ERROR", error_data)
        
    def close(self):
        """Close the log file"""
        if self.file:
            self.file.close()
            self.file = None 