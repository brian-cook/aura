
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["scanner_all_in_one_v2_triangle"] = {
    id = "Scanner All In One V2 Triangle",
    uid = "Gf8InAovkXp",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 184,
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
                use_absorbMode = true,
                type = "custom",
                names = {},
                subeventSuffix = "_CAST_START",
                debuffType = "HELPFUL",
                unit = "player",
                event = "Health",
                customStacks = [[function() return aura_env.count end]],
                use_unit = true,
                events = "PLAYER_TARGET_CHANGED UNIT_TARGET NAME_PLATE_UNIT_ADDED NAME_PLATE_UNIT_REMOVED PLAYER_TARGET_CHANGED UNIT_TARGET PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED",
                custom = [[function(allstates)
    -- Initialize aura environment variables if not exists
    aura_env.last = aura_env.last or 0
    aura_env.marks = aura_env.marks or {}
    aura_env.castEndTimes = aura_env.castEndTimes or {}
    aura_env.skullGUID = aura_env.skullGUID or nil
    aura_env.skullTimestamp = aura_env.skullTimestamp or GetTime()
    aura_env.seenTargets = aura_env.seenTargets or {}
    aura_env.aggroUnits = aura_env.aggroUnits or {}
    aura_env.previousMarks = aura_env.previousMarks or {}
    
    -- Constants
    local MARKS = {8, 7, 2, 6, 5, 1, 4}  -- Skull, Cross, Circle, Square, moon, Star, triangle
    local DIAMOND = 3  -- Reserved for interruptible casts
    local TRIANGLE = 4 -- Reserved for player aggro
    
    -- Initialize spell categories if not exists
    if not aura_env.SPELL_CATEGORIES then
        aura_env.SPELL_CATEGORIES = {
            HEALING_SPELLS = {
                [2050] = true, [2052] = true, [2053] = true,  -- Lesser Heal Series
                [2054] = true, [2055] = true, [6063] = true, [6064] = true,  -- Heal Series
                [2060] = true, [10963] = true,  -- Greater Heal Series
            },
            CC_SPELLS = {
                [118] = true, [12824] = true, [12825] = true,  -- Polymorph Series
                [9484] = true, [9485] = true,  -- Shackle Undead Series
            },
            DAMAGE_SPELLS = {
                [686] = true, [695] = true, [705] = true,  -- Shadowbolt Series
                [421] = true, [930] = true,  -- Chain Lightning Series
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
    
    -- Performance throttling (0.2s)
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        local currentTime = GetTime()
        
        -- Check if player can mark (including solo players)
        if IsInGroup() and not (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
            return false
        end
        
        -- Tracking tables
        local currentEnemies = {}
        local markedEnemies = {}
        local unmarkedEnemies = {}
        local castingEnemies = {}
        local castingUnits = {}
        local aggroUnits = {}
        
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
        
        local function HasPlayerAggro(unit)
            if not UnitExists(unit) then return false end
            
            local targetUnit = unit.."target"
            if not UnitExists(targetUnit) then return false end
            
            -- First check if any pet has aggro
            if IsInGroup() then
                for i = 1, GetNumGroupMembers() do
                    local memberPet = "partypet"..i
                    if UnitExists(memberPet) and UnitIsUnit(targetUnit, memberPet) then
                        return false -- Pet has aggro, so don't mark with triangle
                    end
                end
            end
            
            -- Check player's pet
            if UnitExists("pet") and UnitIsUnit(targetUnit, "pet") then
                return false -- Player's pet has aggro, so don't mark with triangle
            end
            
            -- Check if in group
            if IsInGroup() then
                for i = 1, GetNumGroupMembers() do
                    local memberUnit = "party"..i
                    if UnitExists(memberUnit) and UnitIsPlayer(memberUnit) and 
                    UnitIsUnit(targetUnit, memberUnit) then
                        return true
                    end
                end
            end
            
            -- Check player
            return UnitIsUnit(targetUnit, "player")
        end
        
        local function getSpellPriority(unit)
            local spellName, _, _, _, endTime, _, _, notInterruptible = UnitCastingInfo(unit)
            local isChanneling = false
            
            if not spellName then
                spellName, _, _, _, endTime, _, notInterruptible = UnitChannelInfo(unit)
                isChanneling = spellName ~= nil
            end
            
            if not spellName or notInterruptible then return 0, nil, nil end
            if not CheckInteractDistance(unit, 3) then return 0, nil, nil end
            
            local spellID = select(7, GetSpellInfo(spellName))
            if not spellID then return SPELL_PRIORITY.UNCATEGORIZED, spellName, endTime/1000 end
            
            if aura_env.SPELL_CATEGORIES.HEALING_SPELLS[spellID] then
                return SPELL_PRIORITY.HEALING_SPELLS, spellName, endTime/1000
            elseif aura_env.SPELL_CATEGORIES.CC_SPELLS[spellID] then
                return SPELL_PRIORITY.CC_SPELLS, spellName, endTime/1000
            elseif aura_env.SPELL_CATEGORIES.DAMAGE_SPELLS[spellID] then
                return SPELL_PRIORITY.DAMAGE_SPELLS, spellName, endTime/1000
            end
            
            return SPELL_PRIORITY.UNCATEGORIZED, spellName, endTime/1000
        end
        
        -- SECTION 1: TARGET-BASED SKULL MARKING AND MAINTENANCE
        local targetGUID = UnitGUID("target")
        
        -- Record target if it's attackable
        if targetGUID and UnitCanAttack("player", "target") then
            if aura_env.seenTargets[targetGUID] then
                local currentMark = GetRaidTargetIndex("target")
                if not aura_env.skullGUID and (not currentMark or currentMark ~= 8) then
                    SetRaidTarget("target", 8)
                    aura_env.skullGUID = targetGUID
                    aura_env.marks[targetGUID] = 8
                    aura_env.skullTimestamp = currentTime
                end
            else
                aura_env.seenTargets[targetGUID] = currentTime
            end
        end
        
        -- Clean up old seen targets (after 5 seconds)
        for guid, timestamp in pairs(aura_env.seenTargets) do
            if currentTime - timestamp > 5 then
                aura_env.seenTargets[guid] = nil
            end
        end
        
        -- Clear skull GUID if timeout exceeded (5 seconds)
        if aura_env.skullGUID and (currentTime - aura_env.skullTimestamp > 5) then
            local oldGUID = aura_env.skullGUID
            aura_env.skullGUID = nil
            aura_env.marks[oldGUID] = nil
        end
        
        -- Clear skull GUID if current target is dead or doesn't exist
        if aura_env.skullGUID and targetGUID == aura_env.skullGUID then
            if not UnitExists("target") or UnitIsDeadOrGhost("target") then
                local oldGUID = aura_env.skullGUID
                aura_env.skullGUID = nil
                aura_env.marks[oldGUID] = nil
            else
                aura_env.skullTimestamp = currentTime
            end
        end
        
        -- Clean up expired casts
        for guid, endTime in pairs(aura_env.castEndTimes) do
            if currentTime > endTime then
                aura_env.castEndTimes[guid] = nil
            end
        end
        
        -- SECTION 2: NAMEPLATE SCANNING AND PROCESSING
        for i = 1, 40 do
            local unit = "nameplate"..i
            if UnitExists(unit) and UnitCanAttack("player", unit) and UnitAffectingCombat(unit) then
                local guid = UnitGUID(unit)
                if guid then
                    local currentMark = GetRaidTargetIndex(unit)
                    currentEnemies[guid] = unit
                    
                    -- Check for player aggro
                    local hasAggro = HasPlayerAggro(unit)
                    
                    -- Handle aggro state changes
                    if hasAggro then
                        -- Unit has player aggro
                        if not aggroUnits[guid] then
                            -- New aggro, store previous mark
                            if currentMark and currentMark ~= TRIANGLE then
                                aura_env.previousMarks[guid] = currentMark
                            end
                        end
                        aggroUnits[guid] = true
                        
                        -- Apply triangle mark if not skull
                        if currentMark ~= 8 then
                            SetRaidTarget(unit, TRIANGLE)
                            markedEnemies[TRIANGLE] = {guid = guid, unit = unit}
                        end
                    else
                        -- Unit does not have player aggro
                        if aggroUnits[guid] or currentMark == TRIANGLE then
                            -- Lost aggro or pet gained aggro, restore previous mark
                            if aura_env.previousMarks[guid] then
                                SetRaidTarget(unit, aura_env.previousMarks[guid])
                                aura_env.previousMarks[guid] = nil
                            else
                                SetRaidTarget(unit, 0)
                            end
                            aggroUnits[guid] = nil
                        end
                        
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
                        elseif currentMark == DIAMOND then
                            -- Remove diamond from units that are no longer casting
                            SetRaidTarget(unit, 0)
                            table.insert(unmarkedEnemies, {guid = guid, unit = unit})
                        elseif IsRogueCCd(unit) then
                            if currentMark then
                                SetRaidTarget(unit, 0)
                                for mark, data in pairs(markedEnemies) do
                                    if data.guid == guid then
                                        markedEnemies[mark] = nil
                                        break
                                    end
                                end
                            end
                        elseif currentMark then
                            markedEnemies[currentMark] = {guid = guid, unit = unit}
                        else
                            table.insert(unmarkedEnemies, {guid = guid, unit = unit})
                        end
                    end
                end
            end
        end
        
        -- SECTION 3: DIAMOND MARK MANAGEMENT
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
        
        -- SECTION 4: MARK PROMOTION AND FILLING
        -- First promote existing marks if needed
        for i, highMark in ipairs(MARKS) do
            if not markedEnemies[highMark] and highMark ~= TRIANGLE then
                -- Look for lower priority marks to promote
                for j = i + 1, #MARKS do
                    local lowerMark = MARKS[j]
                    if markedEnemies[lowerMark] and lowerMark ~= TRIANGLE then
                        local target = markedEnemies[lowerMark]
                        if not castingEnemies[target.guid] and not aggroUnits[target.guid] then
                            local currentMark = GetRaidTargetIndex(target.unit)
                            if currentMark == lowerMark then  -- Only promote if mark hasn't changed
                                SetRaidTarget(target.unit, highMark)
                                markedEnemies[highMark] = target
                                markedEnemies[lowerMark] = nil
                                aura_env.marks[target.guid] = highMark
                            end
                        end
                        break
                    end
                end
            end
        end
        
        -- Then fill remaining empty marks with unmarked enemies
        for _, mark in ipairs(MARKS) do
            if not markedEnemies[mark] and mark ~= TRIANGLE and #unmarkedEnemies > 0 then
                local target = table.remove(unmarkedEnemies, 1)
                if not castingEnemies[target.guid] and not aggroUnits[target.guid] then
                    local currentMark = GetRaidTargetIndex(target.unit)
                    if not currentMark then  -- Only mark if unit is unmarked
                        SetRaidTarget(target.unit, mark)
                        aura_env.marks[target.guid] = mark
                    end
                end
            end
        end
        
        -- Update state for visualization
        allstates[""] = {
            changed = true,
            show = true,
            activeMarks = aura_env.marks,
            skullGUID = aura_env.skullGUID,
            aggroUnits = aggroUnits
        }
        
        -- Clean up any expired aggro states
        for guid in pairs(aura_env.aggroUnits) do
            if not aggroUnits[guid] then
                aura_env.aggroUnits[guid] = nil
                aura_env.previousMarks[guid] = nil
            end
        end
        
        -- Update persistent aggro state
        aura_env.aggroUnits = aggroUnits
        
        return true
    end
    return false
end]],
                spellIds = {},
                check = "update",
                custom_type = "stateupdate",
                unevent = "auto",
                customVariables = [[{
    stacks = true,
}]],
            },
            untrigger = {},
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
