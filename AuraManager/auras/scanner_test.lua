
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
                debuffType = "HELPFUL",
                type = "custom",
                unit = "player",
                unevent = "auto",
                subeventPrefix = "SPELL",
                duration = "1",
                event = "Health",
                names = {},
                custom_type = "stateupdate",
                custom = [[function(allstates, event)
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        aura_env.marks = aura_env.marks or {}
        aura_env.castEndTimes = aura_env.castEndTimes or {} -- Track cast end times
        
        -- Available marks in priority order (removed diamond(3) from normal rotation)
        local MARKS = {8, 7, 2, 6, 4, 1, 5}  -- Skull, Cross, Circle, Square, Moon, Star, Triangle
        local DIAMOND = 3  -- Reserved for interruptible casts
        
        -- Track current enemies and marks
        local currentEnemies = {}
        local markedEnemies = {}    
        local unmarkedEnemies = {}
        local castingEnemies = {}   
        
        -- Function to check if unit is CC'd by rogue abilities
        local function IsRogueCCd(unit)
            local ROGUE_CC = {"Sap", "Blind", "Gouge"}
            for _, ccType in ipairs(ROGUE_CC) do
                if AuraUtil.FindAuraByName(ccType, unit, "HARMFUL") then
                    return true
                end
            end
            return false
        end
        
        -- Function to check if unit is casting and interruptible within 15 yards
        local function IsInterruptibleInRange(unit)
            local name, _, _, _, endTime, _, _, notInterruptible = UnitCastingInfo(unit)
            if name and not notInterruptible then
                -- Check if within 15 yards (index 3 is approximately 15 yards)
                if CheckInteractDistance(unit, 3) then
                    return true, endTime/1000 -- Convert to seconds
                end
            end
            return false, nil
        end
        
        -- Clean up expired casts
        local currentTime = GetTime()
        for guid, endTime in pairs(aura_env.castEndTimes) do
            if currentTime > endTime then
                aura_env.castEndTimes[guid] = nil
            end
        end
        
        -- First pass: Identify all targets and their current marks
        for i = 1, 40 do
            local unit = "nameplate"..i
            if UnitExists(unit) and UnitCanAttack("player", unit) then
                local guid = UnitGUID(unit)
                if guid then
                    local currentMark = GetRaidTargetIndex(unit)
                    currentEnemies[guid] = unit
                    
                    -- Check for interruptible cast
                    local isCasting, castEndTime = IsInterruptibleInRange(unit)
                    if isCasting then
                        castingEnemies[guid] = true
                        aura_env.castEndTimes[guid] = castEndTime
                        -- Only set diamond if not already marked as diamond
                        if currentMark ~= DIAMOND then
                            SetRaidTarget(unit, DIAMOND)
                        end
                        markedEnemies[DIAMOND] = {guid = guid, unit = unit}
                        -- Handle non-casting units
                    elseif not IsRogueCCd(unit) then
                        -- If unit was casting but stopped, remove diamond
                        if currentMark == DIAMOND and not aura_env.castEndTimes[guid] then
                            SetRaidTarget(unit, 0)
                            table.insert(unmarkedEnemies, {guid = guid, unit = unit})
                        elseif currentMark and currentMark ~= DIAMOND then
                            markedEnemies[currentMark] = {guid = guid, unit = unit}
                        else
                            table.insert(unmarkedEnemies, {guid = guid, unit = unit})
                        end
                    else
                        -- Remove mark if CC'd
                        if currentMark then
                            SetRaidTarget(unit, 0)
                        end
                    end
                end
            end
        end
        
        -- Clean up our mark tracking
        for guid in pairs(aura_env.marks) do
            if not currentEnemies[guid] then
                aura_env.marks[guid] = nil
                aura_env.castEndTimes[guid] = nil
            end
        end
        
        -- Only promote/assign marks for non-casting enemies
        for i, highMark in ipairs(MARKS) do
            if not markedEnemies[highMark] then
                for j = i + 1, #MARKS do
                    local lowerMark = MARKS[j]
                    if markedEnemies[lowerMark] then
                        local target = markedEnemies[lowerMark]
                        -- Don't promote if unit is casting
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
        
        -- Fill in remaining marks for unmarked enemies
        for _, mark in ipairs(MARKS) do
            if not markedEnemies[mark] and #unmarkedEnemies > 0 then
                local target = table.remove(unmarkedEnemies, 1)
                -- Don't mark if unit is casting
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
end]],
                spellIds = {},
                use_unit = true,
                check = "update",
                customVariables = [[{
  stacks = true,
}]],
                subeventSuffix = "_CAST_START",
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
        size = {
            multi = {},
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
