class TargetingMock:
    """Target handling mock"""
    def __init__(self):
        self.current_target = None
        
    def set_target(self, unit):
        """Set current target"""
        self.current_target = unit
        
    def clear_target(self):
        """Clear current target"""
        self.current_target = None
        
    def get_target(self):
        """Get current target"""
        return self.current_target 