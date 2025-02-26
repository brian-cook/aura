
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["scanner_test_no_load"] = {
    id = "Scanner Test No Load",
    uid = "udV)olhWRPM",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 196,
    yOffset = 76,
    width = 3,
    height = 3,
    frameStrata = 1,
    barColor = {
        0,
        1,
        0,
        1,
    },
    barColor2 = {
        0,
        1,
        0,
        1,
    },
    backgroundColor = {
        0,
        1,
        0,
        1,
    },
    texture = "Solid",
    textureSource = "LSM",
    triggers = {
        activeTriggerMode = -10,
        {
            trigger = {
                duration = "1",
                subeventPrefix = "SPELL",
                custom_hide = "timed",
                use_absorbMode = true,
                type = "custom",
                names = {},
                subeventSuffix = "_CAST_START",
                debuffType = "HELPFUL",
                unit = "player",
                event = "Health",
                customStacks = "",
                use_unit = true,
                events = "PLAYER_TARGET_CHANGED, UNIT_HEALTH, PLAYER_REGEN_DISABLED, PLAYER_REGEN_ENABLED PLAYER_TARGET_CHANGED, UNIT_HEALTH, UNIT_HEALTH_FREQUENT",
                custom = [[function(allstates, event, ...)
    -- Debug setup
    aura_env.debug = true
    local function debugPrint(...)
        if aura_env.debug then
            print(string.format("[TTD Debug] %s", string.format(...)))
        end
    end
    
    debugPrint("Function called with event: %s", event or "nil")
    
    -- Handle OPTIONS and STATUS states
    if event == "OPTIONS" or event == "STATUS" then
        debugPrint("Handling %s state", event)
        return {
            [""] = {
                show = true,
                changed = true,
                ttd = 2.5,
                totalDPS = 100,
                activeDots = {},
                attackSources = {},
                spellEfficiency = {}
            }
        }
    end
    
    -- Initialize state if it doesn't exist
    if not aura_env.state then
        aura_env.state = {}
    end
    
    -- Ensure lastUpdate exists
    if aura_env.state.lastUpdate == nil then
        aura_env.state.lastUpdate = 0
    end
    
    -- Initialize config if needed
    if not aura_env.state.config then
        aura_env.state.config = {
            TTD_THRESHOLD = 2,     -- Show when TTD < 2 seconds
            UPDATE_FREQUENCY = 0.1, -- 100ms for frame updates
            DOT_VALUES = {
                -- Use exact spell names from Classic
                ["Corruption"] = {dps = 10, name = "Corruption", duration = 12},    -- R1
                ["Immolate"] = {dps = 12, name = "Immolate", duration = 15},      -- R1
                ["Curse of Agony"] = {dps = 8,  name = "Curse of Agony", duration = 24} -- R1
            },
            PET_DPS_BY_TYPE = {
                ["Imp"] = {
                    base = 8,
                    per_level = 0.8
                },
                ["Voidwalker"] = {
                    base = 10,
                    per_level = 1.0
                },
                ["Succubus"] = {
                    base = 12,
                    per_level = 1.2
                },
                ["Felhunter"] = {
                    base = 11,
                    per_level = 1.1
                }
            },
            BASE_DPS = {
                WAND = 15,      -- Level 10 wand
            },
            SPELL_VALUES = {
                ["Shadow Bolt"] = {
                    minDamage = 23,
                    maxDamage = 30,
                    castTime = 2.2  -- With talents
                }
            },
            SPELL_EFFICIENCY = {
                ["Shadow Bolt"] = {
                    minDamage = 23,
                    maxDamage = 30,
                    castTime = 2.2,  -- With talents
                    manaCost = 65
                },
                ["Corruption"] = {
                    dps = 10,
                    duration = 12,
                    manaCost = 55
                },
                ["Immolate"] = {
                    dps = 12,
                    duration = 15,
                    manaCost = 50
                },
                ["Curse of Agony"] = {
                    dps = 8,
                    duration = 24,
                    manaCost = 45
                }
            }
        }
    end
    
    -- Initialize allstates
    allstates[""] = allstates[""] or {
        show = false,
        changed = true,
        ttd = 999,
        totalDPS = 0,
        activeDots = {},
        attackSources = {},
        spellEfficiency = {}
    }
    
    -- Target validation function
    local function validateTarget()
        if not UnitExists("target") then
            debugPrint("No target exists")
            return false
        end
        if UnitIsDeadOrGhost("target") then
            debugPrint("Target is dead or ghost")
            return false
        end
        return true
    end
    
    -- Handle target changes
    if event == "PLAYER_TARGET_CHANGED" then
        debugPrint("Target changed")
        if not validateTarget() then
            allstates[""].show = false
            allstates[""].changed = true
            return true
        end
    end
    
    -- Frame update throttling
    local currentTime = GetTime()
    if event == "FRAME_UPDATE" then
        if (currentTime - aura_env.state.lastUpdate) < aura_env.state.config.UPDATE_FREQUENCY then
            return false
        end
    end
    aura_env.state.lastUpdate = currentTime
    
    -- Validate current target
    if not validateTarget() then
        allstates[""].show = false
        allstates[""].changed = true
        return true
    end
    
    -- Calculate pet DPS based on type and level
    local function calculatePetDPS(petUnit)
        if not UnitExists(petUnit) then return 0 end
        
        local petFamily = UnitCreatureFamily(petUnit)
        local ownerUnit = petUnit == "pet" and "player" or "party1"
        local ownerLevel = UnitLevel(ownerUnit)
        
        debugPrint("Pet Family: %s (Owner: %s, Level: %d)", petFamily or "nil", ownerUnit, ownerLevel)
        
        -- Map creature family to pet type
        local petTypeMap = {
            ["Imp"] = "Imp",
            ["Voidwalker"] = "Voidwalker",
            ["Succubus"] = "Succubus",
            ["Felhunter"] = "Felhunter"
        }
        
        local petType = petTypeMap[petFamily]
        if not petType or not aura_env.state.config.PET_DPS_BY_TYPE[petType] then 
            debugPrint("Unknown pet family: %s", petFamily or "nil")
            return 0 
        end
        
        local petConfig = aura_env.state.config.PET_DPS_BY_TYPE[petType]
        local calculatedDPS = petConfig.base + (petConfig.per_level * ownerLevel)
        debugPrint("Pet DPS calculation: %.1f base + (%.1f * %d) = %.1f", 
        petConfig.base, petConfig.per_level, ownerLevel, calculatedDPS)
        
        return calculatedDPS
    end
    
    -- Get active DoTs on target
    local function getActiveDots(unit)
        local dots = {}
        debugPrint("Checking DoTs on %s", unit or "nil")
        
        -- Validate unit
        if not unit or not UnitExists(unit) then
            debugPrint("Invalid unit or unit doesn't exist")
            return dots
        end
        
        -- Check all party members (including player)
        local units = {"player"}
        if IsInGroup() then
            for i = 1, GetNumGroupMembers() do
                table.insert(units, "party"..i)
            end
        end
        
        for spellName, spellData in pairs(aura_env.state.config.DOT_VALUES) do
            local i = 1
            while true do
                local name, icon, count, debuffType, duration, expirationTime, unitCaster = UnitDebuff(unit, i)
                if not name then 
                    debugPrint("No more debuffs at index %d", i)
                    break 
                end
                
                debugPrint("Checking debuff %d: %s (looking for %s)", i, name, spellName)
                
                -- Check if the caster is any party member
                if name == spellName and unitCaster then  -- Add nil check for unitCaster and name match
                    local isCasterPartyMember = false
                    for _, partyUnit in ipairs(units) do
                        if UnitExists(partyUnit) and UnitIsUnit(unitCaster, partyUnit) then
                            isCasterPartyMember = true
                            local source = UnitIsUnit(unitCaster, "player") and "PLAYER" or "PARTY"..partyUnit:match("%d+")
                            
                            dots[spellName] = dots[spellName] or {}
                            dots[spellName][source] = {
                                timeLeft = expirationTime - GetTime(),
                                duration = duration,
                                stacks = count or 1
                            }
                            debugPrint("Found DoT: %s from %s", spellName, source)
                            break
                        end
                    end
                end
                i = i + 1
            end
        end
        return dots
    end
    
    -- Update getCastingInfo to be more explicit about party member tracking
    local function getCastingInfo()
        local casters = {}
        
        -- Check all party members (including player)
        local units = {"player"}
        if IsInGroup() then
            for i = 1, GetNumGroupMembers() do
                table.insert(units, "party"..i)
            end
        end
        
        for _, unit in ipairs(units) do
            -- First check if the unit exists and has our target targeted
            if UnitExists(unit) and UnitExists("target") then
                local isTargetingOurTarget = UnitIsUnit(unit.."target", "target")
                debugPrint("Unit %s targeting our target: %s", unit, tostring(isTargetingOurTarget))
                
                if isTargetingOurTarget then
                    local name, _, _, _, endTime = UnitCastingInfo(unit)
                    if name == "Shadow Bolt" then
                        local remainingCast = (endTime/1000) - GetTime()
                        debugPrint("Unit %s casting Shadow Bolt, %.1fs remaining", unit, remainingCast)
                        casters[unit] = {
                            spell = name,
                            timeLeft = remainingCast
                        }
                    end
                end
            end
        end
        return casters
    end
    
    -- Update getAttackSources to include casting info
    local function getAttackSources()
        local sources = {
            wanding = {},
            pets = {},
            casting = getCastingInfo()  -- Add casting info
        }
        
        -- Check all party members (including player)
        local units = {"player"}
        if IsInGroup() then
            for i = 1, GetNumGroupMembers() do
                table.insert(units, "party"..i)
            end
        end
        
        for _, unit in ipairs(units) do
            -- First check if the unit exists and has our target targeted
            if UnitExists(unit) and UnitExists("target") then
                local isTargetingOurTarget = UnitIsUnit(unit.."target", "target")
                debugPrint("Unit %s targeting our target: %s", unit, tostring(isTargetingOurTarget))
                
                if isTargetingOurTarget then
                    -- Check if wanding
                    local isWanding = IsAutoRepeatSpell(GetSpellInfo("Shoot"))
                    sources.wanding[unit] = isWanding
                    debugPrint("Unit %s wanding: %s", unit, tostring(isWanding))
                    
                    -- Check pets
                    local petUnit = unit == "player" and "pet" or unit.."pet"
                    if UnitExists(petUnit) then
                        local isPetTargetingOurTarget = UnitIsUnit(petUnit.."target", "target")
                        debugPrint("Pet %s targeting our target: %s", petUnit, tostring(isPetTargetingOurTarget))
                        
                        if isPetTargetingOurTarget then
                            sources.pets[petUnit] = true
                            debugPrint("Adding pet %s to DPS calculation", petUnit)
                        end
                    end
                end
            end
        end
        return sources
    end
    
    -- Add function to calculate remaining TTD after Shadow Bolt impact
    local function calculatePostCastTTD(currentHealth, currentDPS, castInfo)
        local spellConfig = aura_env.state.config.SPELL_VALUES[castInfo.spell]
        local avgDamage = (spellConfig.minDamage + spellConfig.maxDamage) / 2
        local timeToImpact = castInfo.timeLeft
        
        -- Calculate health after regular DPS during cast
        local healthAfterDPS = currentHealth - (currentDPS * timeToImpact)
        -- Calculate final health after Shadow Bolt hits
        local healthAfterBolt = healthAfterDPS - avgDamage
        
        debugPrint("TTD Adjustment: Current Health: %d, After DPS: %d, After Bolt: %d", 
        currentHealth, healthAfterDPS, healthAfterBolt)
        
        -- Calculate new TTD based on remaining health
        return healthAfterBolt > 0 and (healthAfterBolt / currentDPS) or 0
    end
    
    -- Update calculateTotalDPS function to handle Shadow Bolt correctly
    local function calculateTotalDPS(sources, dots)
        local dps = 0
        local pendingBolts = {}
        
        -- Add casting DPS
        for unit, castInfo in pairs(sources.casting) do
            if castInfo.spell == "Shadow Bolt" then
                local spellConfig = aura_env.state.config.SPELL_VALUES[castInfo.spell]
                -- Calculate DPS from damage values instead of using dps field
                local avgDamage = (spellConfig.minDamage + spellConfig.maxDamage) / 2
                local castDPS = avgDamage / spellConfig.castTime
                dps = dps + castDPS
                
                pendingBolts[unit] = {
                    timeLeft = castInfo.timeLeft,
                    damage = avgDamage
                }
                
                debugPrint("Adding Shadow Bolt DPS for %s: %.1f (Avg Damage: %.1f)", 
                unit, castDPS, avgDamage)
            end
        end
        
        -- Add wand DPS
        for unit, isWanding in pairs(sources.wanding) do
            if isWanding then
                dps = dps + aura_env.state.config.BASE_DPS.WAND
                debugPrint("Adding wand DPS for %s: %d", unit, aura_env.state.config.BASE_DPS.WAND)
            end
        end
        
        -- Add pet DPS
        for petUnit in pairs(sources.pets) do
            local petDPS = calculatePetDPS(petUnit)
            dps = dps + petDPS
            debugPrint("Adding pet DPS for %s: %.1f", petUnit, petDPS)
        end
        
        -- Add DoT DPS
        for spellName, sources in pairs(dots) do
            for source, dotInfo in pairs(sources) do
                if dotInfo.timeLeft > 1.5 then
                    local baseDPS = aura_env.state.config.DOT_VALUES[spellName].dps
                    local dotDPS = baseDPS * dotInfo.stacks
                    dps = dps + dotDPS
                    debugPrint("Adding %s DoT DPS from %s: %.1f", spellName, source, dotDPS)
                end
            end
        end
        
        return dps, pendingBolts
    end
    
    -- Get target info
    local targetInfo = {
        guid = UnitGUID("target"),
        health = UnitHealth("target"),
        maxHealth = UnitHealthMax("target"),
        level = UnitLevel("target")
    }
    debugPrint("Target: %s (%d/%d)", 
        UnitName("target") or "nil", 
        targetInfo.health, 
    targetInfo.maxHealth)
    
    -- Get damage sources and calculate TTD
    local sources = getAttackSources()
    local dots = getActiveDots("target")
    local totalDPS, pendingBolts = calculateTotalDPS(sources, dots)
    local baseTTD = totalDPS > 0 and (targetInfo.health / totalDPS) or 999
    
    -- Adjust TTD for pending Shadow Bolts
    local adjustedTTD = baseTTD
    for unit, boltInfo in pairs(pendingBolts) do
        adjustedTTD = calculatePostCastTTD(targetInfo.health, totalDPS, {
                spell = "Shadow Bolt",
                timeLeft = boltInfo.timeLeft
        })
    end
    
    debugPrint("Base TTD: %.1fs, Adjusted for Bolts: %.1fs", baseTTD, adjustedTTD)
    
    -- Add function to calculate spell efficiency
    local function calculateSpellEfficiency(targetInfo, totalDPS, dots)
        local spellEfficiency = {}
        local targetTTD = targetInfo.health / (totalDPS > 0 and totalDPS or 1)
        
        -- Helper to check if DoT is already active
        local function isDoTActive(spellName)
            return dots[spellName] and next(dots[spellName]) ~= nil
        end
        
        -- Calculate efficiency for each spell
        for spellName, spellData in pairs(aura_env.state.config.SPELL_EFFICIENCY) do
            local efficiency = {
                shouldCast = false,
                reason = "default"
            }
            
            if spellName == "Shadow Bolt" then
                local avgDamage = (spellData.minDamage + spellData.maxDamage) / 2
                local dps = avgDamage / spellData.castTime
                efficiency.shouldCast = targetTTD > spellData.castTime
                efficiency.dps = dps
                efficiency.reason = efficiency.shouldCast and "time_available" or "dies_too_soon"
                
            else -- DoTs
                local remainingTime = targetTTD
                local dotActive = isDoTActive(spellName)
                
                if dotActive then
                    -- Find the shortest remaining time on this DoT
                    local shortestTime = 999
                    for _, dotInfo in pairs(dots[spellName]) do
                        shortestTime = min(shortestTime, dotInfo.timeLeft)
                    end
                    remainingTime = shortestTime
                end
                
                -- Calculate if DoT should be cast
                local fullDuration = spellData.duration
                local breakEvenTime = (spellData.manaCost / spellData.dps)
                
                efficiency.shouldCast = not dotActive and remainingTime > breakEvenTime
                efficiency.timeLeft = dotActive and remainingTime or 0
                efficiency.dps = spellData.dps
                efficiency.reason = dotActive and "already_active" or 
                (remainingTime <= breakEvenTime and "dies_too_soon" or "time_available")
            end
            
            spellEfficiency[spellName] = efficiency
        end
        
        return spellEfficiency
    end
    
    -- Update state with spell efficiency data
    local spellEfficiency = calculateSpellEfficiency(targetInfo, totalDPS, dots)
    allstates[""].spellEfficiency = spellEfficiency
    
    debugPrint("Spell efficiency calculated:")
    for spell, data in pairs(spellEfficiency) do
        debugPrint("  %s: should cast = %s, reason = %s", 
            spell, 
            tostring(data.shouldCast), 
        data.reason)
    end
    
    -- After calculating spell efficiency
    for spellName, efficiency in pairs(spellEfficiency) do
        -- Format event name consistently
        local eventName = string.format(
            "WARLOCK_SPELL_UPDATE_%s",
            spellName:upper():gsub(" ", "_")
        )
        
        debugPrint("Broadcasting event: %s (shouldCast=%s, reason=%s)", 
            eventName,
            tostring(efficiency.shouldCast),
            efficiency.reason
        )
        
        -- Broadcast the event
        WeakAuras.ScanEvents(eventName, efficiency.shouldCast, efficiency.reason)
    end
    
    -- Update state
    local shouldShow = adjustedTTD < aura_env.state.config.TTD_THRESHOLD
    debugPrint("TTD: %.1fs (Threshold: %.1fs) - Should show: %s", 
        adjustedTTD, 
        aura_env.state.config.TTD_THRESHOLD,
        tostring(shouldShow))
    
    allstates[""].show = shouldShow
    allstates[""].changed = true
    allstates[""].ttd = adjustedTTD
    allstates[""].totalDPS = totalDPS
    allstates[""].activeDots = dots
    allstates[""].attackSources = sources
    
    return true
end]],
                spellIds = {},
                check = "update",
                custom_type = "stateupdate",
                unevent = "auto",
                customVariables = "",
            },
            untrigger = {
                custom = "",
            },
        },
    },
    conditions = {},
    load = {
        use_never = true,
        talent = {
            multi = {},
        },
        size = {
            multi = {},
        },
        class = {
            multi = {
                WARRIOR = true,
            },
            single = "WARRIOR",
        },
        spec = {
            multi = {},
        },
        zoneIds = "",
        group_leader = {
            multi = {
                LEADER = true,
            },
            single = "LEADER",
        },
    },
    animation = {
        start = {
            type = "none",
            easeStrength = 3,
            duration_type = "seconds",
            easeType = "none",
        },
        main = {
            type = "none",
            easeStrength = 3,
            duration_type = "seconds",
            easeType = "none",
        },
        finish = {
            type = "none",
            easeStrength = 3,
            duration_type = "seconds",
            easeType = "none",
        },
    },
    subRegions = {
        {
            type = "subbackground",
        },
        {
            type = "subforeground",
        },
    },
    information = {},
}
