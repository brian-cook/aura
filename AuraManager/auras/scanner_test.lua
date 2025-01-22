
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["scanner_test"] = {
    id = "Scanner Test",
    uid = "03lSKgqSZek",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 136,
    yOffset = 84,
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
                type = "custom",
                unevent = "auto",
                subeventSuffix = "_CAST_START",
                customVariables = [[{
  stacks = true,
}]],
                duration = "1",
                event = "Health",
                subeventPrefix = "SPELL",
                custom_type = "stateupdate",
                use_unit = true,
                spellIds = {},
                custom = [[function(allstates, event)
    -- Initialize aura environment variables if not exists
    aura_env.last = aura_env.last or 0
    aura_env.marks = aura_env.marks or {}
    aura_env.castEndTimes = aura_env.castEndTimes or {}
    
    -- Performance throttling (0.2s)
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        
        -- Constants
        local MARKS = {8, 7, 2, 6, 4, 1, 5}  -- Skull, Cross, Circle, Square, Moon, Star, Triangle
        local DIAMOND = 3  -- Reserved for interruptible casts
        
        -- Initialize spell categories if not exists
        if not aura_env.SPELL_CATEGORIES then
            aura_env.SPELL_CATEGORIES = {
                HEALING_SPELLS = {
                    [2050] = true, [2052] = true, [2053] = true,  -- Lesser Heal Series
                    [2054] = true, [2055] = true, [6063] = true, [6064] = true,  -- Heal Series
                    [2060] = true, [10963] = true,  -- Greater Heal Series
                    [547] = true, [913] = true, [939] = true,  -- Healing Wave Series
                    [17843] = true, [17844] = true,  -- Flash Heal Series
                    [22883] = true, [23954] = true,  -- Raid Healing Spells
                    [8362] = true, [11642] = true,  -- RFC Specific
                    [5187] = true, [5188] = true, [23381] = true, [23382] = true,  -- WC Specific
                    [12039] = true, [7106] = true, [12380] = true  -- SFK Specific
                },
                CC_SPELLS = {
                    [118] = true, [12824] = true, [12825] = true,  -- Polymorph Series
                    [9484] = true, [9485] = true,  -- Shackle Undead Series
                    [2637] = true, [18657] = true,  -- Hibernate Series
                    [605] = true,  -- Mind Control
                    [710] = true, [18647] = true,  -- Banish Series
                    [7645] = true, [15859] = true  -- Special Mob CC Abilities
                },
                DAMAGE_SPELLS = {
                    [686] = true, [695] = true, [705] = true,  -- Shadowbolt Series
                    [421] = true, [930] = true,  -- Chain Lightning Series
                    [15407] = true, [17165] = true,  -- Mind Flay Series
                    [5143] = true, [8417] = true,  -- Arcane Missiles Series
                    [2912] = true  -- Starfire
                }
            }
        end
        
        -- Spell priority definitions
        local SPELL_PRIORITY = {
            HEALING_SPELLS = 4,  -- Highest priority
            CC_SPELLS = 3,
            DAMAGE_SPELLS = 2,
            UNCATEGORIZED = 1    -- Lowest priority
        }
        
        -- Tracking tables
        local currentEnemies = {}
        local markedEnemies = {}    
        local unmarkedEnemies = {}
        local castingEnemies = {}
        local castingUnits = {}
        
        -- Helper Functions
        local function IsRogueCCd(unit)
            local ROGUE_CC = {"Sap", "Blind", "Gouge"}
            for _, ccType in ipairs(ROGUE_CC) do
                if AuraUtil.FindAuraByName(ccType, unit, "HARMFUL") then
                    return true
                end
            end
            return false
        end
        
        local function getSpellPriority(unit)
            -- Check both casting and channeling
            local spellName, _, _, _, endTime, _, _, notInterruptible = UnitCastingInfo(unit)
            local isChanneling = false
            
            if not spellName then
                spellName, _, _, _, endTime, _, notInterruptible = UnitChannelInfo(unit)
                isChanneling = spellName ~= nil
            end
            
            if not spellName or notInterruptible then 
                return 0, nil, nil 
            end
            
            -- Check if within interrupt range (15 yards)
            if not CheckInteractDistance(unit, 3) then 
                return 0, nil, nil 
            end
            
            -- Get spell ID
            local spellID = select(7, GetSpellInfo(spellName))
            if not spellID then 
                return SPELL_PRIORITY.UNCATEGORIZED, spellName, endTime/1000 
            end
            
            -- Check spell categories
            if aura_env.SPELL_CATEGORIES.HEALING_SPELLS[spellID] then
                return SPELL_PRIORITY.HEALING_SPELLS, spellName, endTime/1000
            elseif aura_env.SPELL_CATEGORIES.CC_SPELLS[spellID] then
                return SPELL_PRIORITY.CC_SPELLS, spellName, endTime/1000
            elseif aura_env.SPELL_CATEGORIES.DAMAGE_SPELLS[spellID] then
                return SPELL_PRIORITY.DAMAGE_SPELLS, spellName, endTime/1000
            end
            
            return SPELL_PRIORITY.UNCATEGORIZED, spellName, endTime/1000
        end
        
        -- Clean up expired casts
        local currentTime = GetTime()
        for guid, endTime in pairs(aura_env.castEndTimes) do
            if currentTime > endTime then
                aura_env.castEndTimes[guid] = nil
            end
        end
        
        -- First pass: Scan all units
        for i = 1, 40 do
            local unit = "nameplate"..i
            if UnitExists(unit) and UnitCanAttack("player", unit) then
                local guid = UnitGUID(unit)
                if guid then
                    local currentMark = GetRaidTargetIndex(unit)
                    currentEnemies[guid] = unit
                    
                    -- Get spell priority and info
                    local priority, spellName, endTime = getSpellPriority(unit)
                    if priority > 0 then
                        castingUnits[guid] = {
                            unit = unit,
                            guid = guid,
                            priority = priority,
                            spellName = spellName,
                            endTime = endTime,
                            distance = CheckInteractDistance(unit, 3) and 1 or 2,
                            currentMark = currentMark
                        }
                        castingEnemies[guid] = true
                        aura_env.castEndTimes[guid] = endTime
                    elseif not IsRogueCCd(unit) then
                        if currentMark == DIAMOND then
                            SetRaidTarget(unit, 0)
                            table.insert(unmarkedEnemies, {guid = guid, unit = unit})
                        elseif currentMark and currentMark ~= DIAMOND then
                            markedEnemies[currentMark] = {guid = guid, unit = unit}
                        else
                            table.insert(unmarkedEnemies, {guid = guid, unit = unit})
                        end
                    elseif currentMark then
                        SetRaidTarget(unit, 0)
                    end
                end
            end
        end
        
        -- Select highest priority casting unit for diamond mark
        local selectedUnit = nil
        local highestPriority = 0
        local closestDistance = 3
        
        for guid, data in pairs(castingUnits) do
            if data.priority > highestPriority or 
            (data.priority == highestPriority and data.distance < closestDistance) then
                highestPriority = data.priority
                closestDistance = data.distance
                selectedUnit = data
            end
        end
        
        -- Apply diamond mark to highest priority target
        if selectedUnit then
            if selectedUnit.currentMark ~= DIAMOND then
                SetRaidTarget(selectedUnit.unit, DIAMOND)
            end
            markedEnemies[DIAMOND] = {guid = selectedUnit.guid, unit = selectedUnit.unit}
            
            -- Remove diamond from other casting units
            for guid, data in pairs(castingUnits) do
                if data.unit ~= selectedUnit.unit and data.currentMark == DIAMOND then
                    SetRaidTarget(data.unit, 0)
                    table.insert(unmarkedEnemies, {guid = guid, unit = data.unit})
                end
            end
        end
        
        -- Clean up mark tracking
        for guid in pairs(aura_env.marks) do
            if not currentEnemies[guid] then
                aura_env.marks[guid] = nil
                aura_env.castEndTimes[guid] = nil
            end
        end
        
        -- Handle mark promotion for non-casting units
        for i, highMark in ipairs(MARKS) do
            if not markedEnemies[highMark] then
                for j = i + 1, #MARKS do
                    local lowerMark = MARKS[j]
                    if markedEnemies[lowerMark] then
                        local target = markedEnemies[lowerMark]
                        if not castingEnemies[target.guid] then
                            SetRaidTarget(target.unit, highMark)
                            aura_env.marks[target.guid] = highMark
                            markedEnemies[highMark] = target
                            markedEnemies[lowerMark] = nil
                        end
                        break
                    end
                end
            end
        end
        
        -- Fill remaining marks
        for _, mark in ipairs(MARKS) do
            if not markedEnemies[mark] and #unmarkedEnemies > 0 then
                local target = table.remove(unmarkedEnemies, 1)
                if not castingEnemies[target.guid] then
                    SetRaidTarget(target.unit, mark)
                    aura_env.marks[target.guid] = mark
                end
            end
        end
        
        -- Update state for visualization
        allstates[""] = {
            changed = true,
            show = true,
            activeMarks = aura_env.marks
        }
        return true
    end
    return false
end]],
                check = "update",
                unit = "player",
                names = {},
                debuffType = "HELPFUL",
                use_absorbMode = true,
                customStacks = [[function() return aura_env.count end]],
            },
            untrigger = {},
        },
    },
    conditions = {},
    load = {
        use_never = false,
        talent = {
            multi = {},
        },
        class = {
            multi = {
                WARRIOR = true,
            },
            single = "WARRIOR",
        },
        zoneIds = "",
        spec = {
            multi = {},
        },
        size = {
            multi = {},
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
