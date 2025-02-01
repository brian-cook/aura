class CombatMock:
    """Combat simulation mock"""
    def __init__(self):
        self.in_combat = False
        self.combat_time = 0
        self.last_combat = 0
        
    def enter_combat(self):
        """Enter combat state"""
        self.in_combat = True
        self.combat_time = 0
        
    def exit_combat(self):
        """Exit combat state"""
        self.in_combat = False
        self.last_combat = self.combat_time
        
    def is_in_combat(self):
        """Check if in combat"""
        return self.in_combat
        
    def update_combat_time(self, elapsed):
        """Update combat duration"""
        if self.in_combat:
            self.combat_time += elapsed 