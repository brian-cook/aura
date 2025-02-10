
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["target_interruptible_range_30"] = {
    id = "Target interruptible Range 30",
    uid = "Kk67WHgoR6G",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 176,
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
                names = {},
                unevent = "auto",
                unit = "player",
                duration = "1",
                event = "Health",
                subeventPrefix = "SPELL",
                custom_type = "stateupdate",
                custom = [[function(allstates)
    -- Throttle the check for perf?  What is config?
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        -- Set the last time
        aura_env.last = GetTime()
        
        -- Get player's GUID for comparison
        local playerGUID = UnitGUID("player")
        
        -- Start a count
        local enemyIndex = 0
        
        -- Iterate 40 times
        for i = 1, 40 do
            -- Concat string with index
            local unit = "nameplate"..i
            
            local isEnemy = UnitIsEnemy("player", unit)
            local inRange = WeakAuras.CheckRange(targetName, 30, "<=")
            local spell, rank, displayName, icon, startTime, endTime, isTradeSkill, castID, interruptible = UnitCastingInfo(unit)
            local targetGUID = UnitGUID(unit.."target")
            
            local isCastingAtPlayer = isEnemy and spell and interruptible and (targetGUID == playerGUID)
            
            if isCastingAtPlayer and inRange then
                enemyIndex = enemyIndex + 1
            end
        end
        
        if enemyIndex > 0 then
            allstates[""] = allstates[""] or {show = true}
            allstates[""].show = true
            allstates[""].changed = true
        else
            allstates[""] = allstates[""] or {show = false}
            allstates[""].show = false
            allstates[""].changed = true
        end
        
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
                customStacks = [[function() return aura_env.count end]],
                use_absorbMode = true,
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
