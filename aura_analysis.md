# Aura Analysis: Available Information for Decision Engine

## Table of Contents
1. [Overview](#overview)
2. [Aura Categories](#aura-categories)
3. [Information Available](#information-available)
4. [Missing Information](#missing-information)
5. [Integration Opportunities](#integration-opportunities)

## Overview

This document analyzes the existing auras in the codebase to identify what information is currently available for the decision engine. Understanding the existing information landscape is crucial for designing an effective dynamic action selection algorithm.

## Aura Categories

Based on the analysis of the auras folder, the following categories of auras exist:

### 1. Unit Status Auras
These auras provide information about specific units:
- `target_aggro.lua`: Indicates if a unit has aggro on the player
- `target_casting.lua`: Indicates if a unit is casting a spell
- `target_is_humanoid.lua`: Indicates if a target is of humanoid type
- `target_is_player.lua`: Indicates if a target is a player
- `target_is_elite_boss_or_player.lua`: Indicates if a target is an elite, boss, or player
- `target_moving.lua`: Indicates if a target is moving
- `target_is_ooc.lua`: Indicates if a target is out of combat

### 2. Health and Power Auras
These auras track health and power resources:
- `target_health_under_20.lua`, `target_health_under_35.lua`, `target_health_under_50.lua`, etc.: Various health thresholds
- `power_5.lua`, `power_35.lua`, `power_50.lua`, etc.: Various power thresholds

### 3. Range Auras
These auras indicate if units are within specific ranges:
- `range_8.lua`, `range_10.lua`, `range_15.lua`, etc.: Various range checks
- `range_8_1+.lua`, `range_8_2+.lua`, `range_8_3+.lua`: Range checks with additional conditions
- `range_8_circle.lua`, `range_8_cross.lua`: Range checks with marker conditions

### 4. Buff and Debuff Auras
These auras track the presence of buffs and debuffs:
- `slice_and_dice_buff.lua`: Slice and Dice buff
- `stealth_buff.lua`: Stealth buff
- `thorns_buff.lua`: Thorns buff
- `recently_bandaged_debuff.lua`: Recently Bandaged debuff
- `serpent_sting_debuff.lua`: Serpent Sting debuff
- `rip_debuff.lua`: Rip debuff

### 5. Ability Auras
These auras track ability availability and usage:
- `sinister_strike.lua`: Sinister Strike ability
- `throw.lua`: Throw ability
- `sap.lua`: Sap ability
- `skull_bash.lua`: Skull Bash ability
- `sprint.lua`: Sprint ability
- `vanish.lua`: Vanish ability

### 6. Totem and Summon Auras
These auras track the presence and status of totems and other summons:
- `searing_totem_dropped.lua`: Indicates if Searing Totem has been dropped
- `stoneclaw_totem.lua`: Stoneclaw Totem
- `stoneskin_totem_exists.lua`: Indicates if Stoneskin Totem exists
- `tremor_totem.lua`: Tremor Totem

### 7. Marker Auras
These auras track raid target markers:
- `target_skull.lua`, `target_cross.lua`, `target_circle.lua`, etc.: Various raid target markers

### 8. Scanner Auras
These auras scan for specific conditions or units:
- `scanner_all_in_one_v1.lua`: Comprehensive scanner
- `scanner_cross.lua`, `scanner_skull.lua`, `scanner_triangle.lua`: Scanners for specific markers
- `scanner_test_no_load.lua`: Testing scanner

## Information Available

Based on the aura analysis, the following information is currently available to the decision engine:

### Player Information
- **Power Resources**: Current power levels (mana, rage, energy)
- **Buffs**: Self-buffs like Slice and Dice, Stealth, etc.
- **Abilities**: Availability of various abilities (implicitly through the existence of ability auras)

### Target Information
- **Existence**: Whether targets exist (implicit in other target auras)
- **Health**: Various health thresholds of targets
- **Type**: Target types (humanoid, undead, mechanical, etc.)
- **Status**: Target states (casting, moving, in combat)
- **Relation**: Target relation to player (player, friendly, hostile)
- **Markers**: Raid target markers assigned to targets

### Spatial Information
- **Range**: Distance between player and targets at various thresholds
- **Positioning**: Implicit positioning based on the number of units at different ranges

### Combat Information
- **Buffs and Debuffs**: Presence of combat-relevant buffs and debuffs
- **Aggro**: Information about which units have aggro on the player
- **Casting**: Information about which units are casting spells

## Missing Information

Despite the wealth of information available, several critical pieces are missing for an optimal decision engine:

1. **Detailed Resource Tracking**:
   - Precise power values (not just thresholds)
   - Secondary resources (combo points, holy power, etc.)
   - Resource regeneration rates

2. **Cooldown Information**:
   - Remaining cooldown on abilities
   - Global cooldown status
   - Category cooldowns

3. **Buff/Debuff Details**:
   - Remaining duration on buffs and debuffs
   - Stack counts on stackable effects
   - Detailed effect values (e.g., the amount of a damage increase)

4. **Advanced Combat Metrics**:
   - DPS/HPS calculations
   - Time-to-kill estimates
   - Incoming damage predictions

5. **Party/Raid Information**:
   - Party member status and resources
   - Party member positioning
   - Party member roles and capabilities

6. **Environmental Information**:
   - Overall combat state
   - Dungeon/raid-specific mechanics
   - PvP-specific information

## Integration Opportunities

To build an effective decision engine, the following integration opportunities should be explored:

### 1. Enhanced WeakAuras
Create additional WeakAuras to provide the missing information:
- **Resource Trackers**: Precise tracking of all resources
- **Cooldown Trackers**: Detailed cooldown information for all abilities
- **Buff/Debuff Trackers**: Enhanced tracking with durations and stacks
- **Combat Analysis Auras**: Advanced metrics for combat situations
- **Party Tracking Auras**: Comprehensive party member information

### 2. Screen Monitor Enhancements
Enhance screen_monitor.py to:
- Track more detailed state information
- Process and analyze multiple auras simultaneously
- Derive higher-level information from combinations of auras

### 3. Decision Engine Design
Design the decision engine to:
- Use available information efficiently
- Make intelligent decisions despite missing information
- Prioritize gathering missing information when critical

### 4. Feedback Mechanisms
Implement feedback loops to:
- Learn from the results of actions
- Adapt to changing game conditions
- Improve decision-making over time

## Next Steps

1. **Information Inventory**: Create a detailed inventory of all information currently available
2. **Gap Analysis**: Identify the most critical missing information
3. **WeakAura Development**: Design and implement additional WeakAuras
4. **Screen Monitor Enhancement**: Update screen_monitor.py to capture and process new information
5. **Decision Algorithm Design**: Design algorithms that make optimal use of available information

---

**Version**: 1.0.0  
**Last Updated**: 2023-04-15  
**Author**: System Development Team 