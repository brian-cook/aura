
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
                debuffType = "HELPFUL",
                type = "custom",
                unit = "player",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                duration = "1",
                event = "Health",
                names = {},
                use_unit = true,
                custom_type = "stateupdate",
                custom = [[function(allstates, event)
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        -- Initialize our mark storage if it doesn't exist
        aura_env.marks = aura_env.marks or {}
        
        -- Available marks in priority order
        local MARKS = {8, 7, 2, 3, 6, 4, 1, 5}  -- Skull, Cross, Circle, Diamond, Square, Moon, Star, Triangle
        
        -- Track current enemies and their GUIDs
        local currentEnemies = {}
        local enemyList = {}  -- Ordered list for consistent assignment
        
        -- First pass: Identify all valid targets
        for i = 1, 40 do
            local unit = "nameplate"..i
            if UnitExists(unit) and UnitAffectingCombat(unit) and UnitCanAttack("player", unit) then
                local guid = UnitGUID(unit)
                if guid then
                    currentEnemies[guid] = unit
                    table.insert(enemyList, guid)
                end
            end
        end
        
        -- Clear all existing marks first
        for guid, unit in pairs(currentEnemies) do
            SetRaidTarget(unit, 0)
            aura_env.marks[guid] = nil
        end
        
        -- Reassign marks in priority order
        for i, guid in ipairs(enemyList) do
            if i <= #MARKS then
                local unit = currentEnemies[guid]
                local mark = MARKS[i]
                aura_env.marks[guid] = mark
                SetRaidTarget(unit, mark)
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
                check = "update",
                unevent = "auto",
                customVariables = [[{
  stacks = true,
}]],
                use_absorbMode = true,
                customStacks = [[function() return aura_env.count end]],
            },
            untrigger = {},
        },
    },
    conditions = {},
    load = {
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
        use_never = false,
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
