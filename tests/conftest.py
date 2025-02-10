import pytest
import sys
import os
from pathlib import Path

from test_helpers import TestingLogger

def pytest_addoption(parser):
    parser.addoption("--scanner", action="store", default="scanner",
                    help="Scanner name to test")
    parser.addoption("--wow-version", action="store", default="classic",
                    choices=["retail", "classic"],
                    help="WoW version to test against")

@pytest.fixture(scope="session")
def scanner_name(request):
    return request.config.getoption("--scanner")

@pytest.fixture(scope="session")
def wow_version(request):
    """Get WoW version from command line or default to retail"""
    return request.config.getoption("--wow-version")

@pytest.fixture(scope="session")
def test_logger(request):
    """Session-wide test logger"""
    log_dir = Path("tests/logs")
    log_dir.mkdir(parents=True, exist_ok=True)
    
    timestamp = request.node.start.strftime("%Y%m%d_%H%M%S")
    log_path = log_dir / f"test_session_{timestamp}.log"
    
    logger = TestingLogger.create(log_path)
    
    yield logger
    
    logger.close()

@pytest.fixture(autouse=True)
def setup_test_environment(request, wow_version):
    """Setup test environment for each test"""
    # Create test logs directory
    log_dir = Path("tests/logs")
    log_dir.mkdir(parents=True, exist_ok=True)
    
    # Setup version-specific configuration
    version_config = {
        "classic": {
            "has_focus": False,
            "max_nameplate_distance": float('inf'),
            "threat_levels": [0, 1, 2, 3],
            "has_warmode": False,
            "has_mythic_plus": False
        },
        "retail": {
            "has_focus": True,
            "max_nameplate_distance": 60,
            "threat_range": (0, 100),
            "has_warmode": True,
            "has_mythic_plus": True
        }
    }
    
    # Set version configuration
    request.config.version_config = version_config.get(wow_version, version_config["classic"])
    
    # Setup test marker
    if request.node.get_closest_marker('scanner'):
        print("\nDEBUG: Running scanner function test")

def pytest_configure(config):
    """Configure test environment"""
    config.addinivalue_line(
        "markers", "scanner: mark test as scanner function test"
    ) 