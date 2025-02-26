
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["range_20_1+"] = {
    id = "Range 20 1+",
    uid = "AvDh7R5YFSX",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 172,
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
                subeventSuffix = "_CAST_START",
                unevent = "auto",
                customVariables = [[{
  stacks = true,
}]],
                duration = "1",
                event = "Health",
                unit = "player",
                custom_type = "stateupdate",
                use_unit = true,
                custom = [[function(allstates)
    -- Throttle the check for perf?  What is config?
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        -- Set the last time
        aura_env.last = GetTime()
        
        -- Start a count
        local enemyIndex = 0
        
        -- Iterate 40 times
        for i = 1, 40 do
            -- Concat string with index
            local unit = "nameplate"..i
            local unitCanAttack = UnitCanAttack("player", unit) 
            local inRange = WeakAuras.CheckRange(unit, 20, "<=")
            
            if unitCanAttack and inRange then
                enemyIndex = enemyIndex + 1
            end
        end
        
        if enemyIndex >= 1 then
            allstates[""] = allstates[""] or {show = true}
            allstates[""].show = true
            allstates[""].changed = true
        else
            allstates[""] = allstates[""] or {show = false}
            allstates[""].show = false
            --allstates[""].stacks = aura_env.config.enemy_count
            allstates[""].changed = true
        end
        
        return true
    end
end]],
                spellIds = {},
                check = "update",
                names = {},
                subeventPrefix = "SPELL",
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
