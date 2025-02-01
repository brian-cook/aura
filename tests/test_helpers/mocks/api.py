class WoWAPIMock:
    """Base API mock functionality"""
    def __init__(self, version_config=None):
        self.units = {}
        self.target = None
        self.combat_state = False
        self.version_config = version_config or {}
        
    def reset(self):
        """Reset mock state"""
        self.units.clear()
        self.target = None
        self.combat_state = False 