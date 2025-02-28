# Project File Index

This document serves as a central directory for all documentation files in the Aura project. Use this index to navigate to specific documentation based on your needs.

## Core Documentation

| File | Description | Last Updated |
|------|-------------|--------------|
| [building_auras.txt](building_auras.txt) | Comprehensive guide for implementing WeakAuras, including architecture, patterns, and advanced techniques | 2023-04-14 |
| [how_profiles_work.txt](how_profiles_work.txt) | Guide for profile creation, structure, loading, and management in World of Warcraft | 2023-04-14 |
| [README.md](README.md) | Project overview, setup instructions, and basic usage information | 2023-01-19 |

## Visual Documentation

| File | Description | Purpose |
|------|-------------|---------|
| [debug_images/profile_testing_workflow.svg](debug_images/profile_testing_workflow.svg) | Profile testing workflow diagram | Visual representation of the profile testing pipeline from development to deployment |
| [debug_images/weakauras_state_diagram.svg](debug_images/weakauras_state_diagram.svg) | WeakAuras state management flow | Illustrates how events trigger WeakAuras and how states are managed |

## Configuration Files

| File | Description |
|------|-------------|
| [config_template.py](config_template.py) | Template for configuration with documented options |
| [config.py](config.py) | Active configuration file (not tracked in git) |

## Implementation Resources

| Directory | Purpose |
|-----------|---------|
| [src/](src/) | Core source code for the Aura project |
| [tests/](tests/) | Test suite for validating functionality |
| [scripts/](scripts/) | Utility scripts for development and maintenance |
| [debug_images/](debug_images/) | Diagrams and visual aids for documentation |

## Cross-Reference Guide

### WeakAuras Development

1. Start with [building_auras.txt](building_auras.txt) for core concepts
2. Reference the [weakauras_state_diagram.svg](debug_images/weakauras_state_diagram.svg) for understanding state management
3. For Classic WoW specific information, see section 5.9 in [building_auras.txt](building_auras.txt)

### Profile Development

1. Start with [how_profiles_work.txt](how_profiles_work.txt) for profile structure
2. Reference the [profile_testing_workflow.svg](debug_images/profile_testing_workflow.svg) for testing methodology
3. For validation procedures, see section 5 in [how_profiles_work.txt](how_profiles_work.txt)

## Version History

| Date | File | Version | Changes |
|------|------|---------|---------|
| 2023-04-14 | building_auras.txt | 1.2.0 | Added Classic WoW nameplate unit data section (5.9) and advanced troubleshooting (4.5) |
| 2023-04-14 | how_profiles_work.txt | 1.1.0 | Added Testing & Validation (Section 5) and Troubleshooting (Section 6) |
| 2023-04-14 | ProjectFileIndex.md | 1.0.0 | Initial creation of centralized documentation index |
| 2023-01-19 | building_auras.txt | 1.0.0 | Initial comprehensive documentation |
| 2023-01-19 | how_profiles_work.txt | 1.0.0 | Initial comprehensive documentation |
| 2023-01-19 | README.md | 1.0.0 | Initial project documentation | 