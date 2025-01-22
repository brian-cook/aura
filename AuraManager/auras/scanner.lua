
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["scanner"] = {
    id = "Scanner",
    uid = "Gf8InAovkXp",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 132,
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
        -- Available marks in priority order
        local MARKS = {8, 7, 2, 3, 6, 4, 1, 5}  -- Skull, Cross, Circle, Diamond, Square, Moon, Star, Triangle
        -- Track current enemies and marks
        local currentEnemies = {}
        local markedEnemies = {}    -- Tracks which enemies have which marks
        local unmarkedEnemies = {}
        -- First pass: Identify all targets and their current marks
        for i = 1, 40 do
            local unit = "nameplate"..i
            if UnitExists(unit) and UnitCanAttack("player", unit) then
                local guid = UnitGUID(unit)
                if guid then
                    local currentMark = GetRaidTargetIndex(unit)
                    currentEnemies[guid] = unit
                    if currentMark then
                        markedEnemies[currentMark] = {guid = guid, unit = unit}
                    else
                        table.insert(unmarkedEnemies, {guid = guid, unit = unit})
                    end
                end
            end
        end
        -- Clean up our mark tracking
        for guid in pairs(aura_env.marks) do
            if not currentEnemies[guid] then
                aura_env.marks[guid] = nil
            end
        end
        -- Promote existing marks if higher priority marks are missing
        for i, highMark in ipairs(MARKS) do
            if not markedEnemies[highMark] then
                -- Look for the next existing lower priority mark
                for j = i + 1, #MARKS do
                    local lowerMark = MARKS[j]
                    if markedEnemies[lowerMark] then
                        -- Promote this mark
                        local target = markedEnemies[lowerMark]
                        SetRaidTarget(target.unit, highMark)
                        aura_env.marks[target.guid] = highMark
                        markedEnemies[highMark] = target
                        markedEnemies[lowerMark] = nil
                        break
                    end
                end
            end
        end
        -- Fill in any remaining marks for unmarked enemies
        for _, mark in ipairs(MARKS) do
            if not markedEnemies[mark] and #unmarkedEnemies > 0 then
                local target = table.remove(unmarkedEnemies, 1)
                SetRaidTarget(target.unit, mark)
                aura_env.marks[target.guid] = mark
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
        use_never = true,
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
