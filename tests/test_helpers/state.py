from dataclasses import dataclass, field
from typing import List, Dict
from time import time

@dataclass
class TestState:
    """Test state container"""
    scanner_name: str
    start_time: float = field(default_factory=time)
    events: List[Dict] = field(default_factory=list)
    errors: List[Dict] = field(default_factory=list)
    
    def add_event(self, event_type: str, details: Dict):
        """Add event to history"""
        self.events.append({
            "timestamp": time(),
            "type": event_type,
            "details": details
        })
        
    def add_error(self, message: str, error: Exception = None):
        """Add error to history"""
        self.errors.append({
            "timestamp": time(),
            "message": message,
            "error": str(error) if error else None
        }) 