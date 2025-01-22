from pathlib import Path
import shutil
import sys
from collections import defaultdict

# Add project root to path
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.append(str(PROJECT_ROOT))

from config import WOW_PATH, AURAS_DIR

def deploy_auras():
    """Copy auras and addon files from project to WoW addon directory"""
    # Setup paths
    source_dir = AURAS_DIR.parent  # AuraManager folder
    target_dir = WOW_PATH / "Interface" / "AddOns" / "AuraManager"
    
    try:
        # Create addon directory if it doesn't exist
        target_dir.mkdir(parents=True, exist_ok=True)
        
        # Track files by type
        stats = defaultdict(list)
        
        # Core addon files to copy
        core_files = [
            "AuraManager.lua",
            "AuraManager.toc",
            "aura_list.lua",
            "core.lua"
        ]
        
        # Copy core addon files
        for file_name in core_files:
            source_file = source_dir / file_name
            if source_file.exists():
                shutil.copy2(source_file, target_dir / file_name)
                stats["core"].append(file_name)
            else:
                print(f"Warning: Core file not found: {file_name}")
        
        # Copy all aura files
        for source_file in (source_dir / "auras").glob("*.lua"):
            target_file = target_dir / "auras" / source_file.name
            target_file.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source_file, target_file)
            stats["auras"].append(source_file.name)
            
        print(f"\nDeployment Summary:")
        
        # Show core files first
        if stats["core"]:
            print("\nCore Files:")
            for file in sorted(stats["core"]):
                print(f"- {file}")
        
        # Then show aura files
        if stats["auras"]:
            print(f"\nAura Files ({len(stats['auras'])}):")
            print(f"- {len(stats['auras'])} auras deployed to {target_dir / 'auras'}")
        
        total_files = sum(len(files) for files in stats.values())
        print(f"\nTotal files copied: {total_files}")
        print(f"Target directory: {target_dir}")
        
        # Verify deployment
        print("\nVerifying deployment...")
        source_files = set()
        # Add core files
        source_files.update(f.name for f in source_dir.glob("*.lua"))
        source_files.add("AuraManager.toc")
        # Add aura files
        source_files.update(f.name for f in (source_dir / "auras").glob("*.lua"))
        
        target_files = set()
        # Check core files
        target_files.update(f.name for f in target_dir.glob("*.lua"))
        target_files.add("AuraManager.toc")
        # Check aura files
        target_files.update(f.name for f in (target_dir / "auras").glob("*.lua"))
        
        if source_files != target_files:
            print("Warning: Deployment verification failed!")
            missing = source_files - target_files
            extra = target_files - source_files
            if missing:
                print("\nMissing files:")
                for f in sorted(missing):
                    print(f"- {f}")
            if extra:
                print("\nExtra files in target:")
                for f in sorted(extra):
                    print(f"- {f}")
        else:
            print("Deployment verified successfully!")
        
    except Exception as e:
        print(f"Error during deployment: {e}")
        raise

if __name__ == "__main__":
    deploy_auras()