from typing import Optional
from .logger import TestingLogger
from wow_api_mock import WoWAPIMock

class BaseTest:
    """Core test functionality for all test cases"""
    def __init__(self, logger):
        self.logger = logger
        self.wow_api = None
        self.combat_mock = None
        self.unit_manager = None
        self.state = None

    def setup(self):
        """Initialize test environment"""
        from .mocks.combat import CombatMock
        from .mocks.units import UnitManagerMock
        
        self.combat_mock = CombatMock()
        self.unit_manager = UnitManagerMock()
        self.logger.log_event("setup", "Initializing test environment")
        
    def teardown(self):
        """Cleanup test environment"""
        if self.combat_mock:
            self.combat_mock.exit_combat()
        if self.unit_manager:
            self.unit_manager.units.clear()
        self.logger.log_event("teardown", "Cleaning up test environment")


class ScannerTest(BaseTest):
    """Scanner-specific test functionality"""
    def __init__(self, scanner_name: str, api: WoWAPIMock, logger: TestingLogger):
        super().__init__(logger)
        self.scanner_name = scanner_name
        self.api = api  # Note: using 'api' instead of 'wow_api'
        
    def setup(self):
        """Initialize scanner test environment"""
        super().setup()
        
        # Initialize WoW API with new mocks
        self.wow_api = WoWAPIMock(
            combat_mock=self.combat_mock,
            unit_manager=self.unit_manager
        )
        
        self.logger.log_event("scanner_setup", f"Initializing scanner: {self.scanner_name}") 