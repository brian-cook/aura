
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["pet_aggro_square"] = {
    id = "Pet Aggro Square",
    uid = "3yp6XBMyAHN",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 168,
    yOffset = 88,
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
                subeventSuffix = "_CAST_START",
                unevent = "auto",
                custom_type = "stateupdate",
                unit = "player",
                event = "Health",
                customStacks = [[function() return aura_env.count end]],
                custom = [[function(allstates)
    -- Throttle the check for perf?  What is config?
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        -- Set the last time
        aura_env.last = GetTime()
        local isTanking = false
        
        -- Iterate 40 times
        for i = 1, 40 do
            -- Concat string with index
            local unit = "nameplate"..i
            
            if UnitExists(unit) and GetRaidTargetIndex(unit) == 6 then
                isTanking = UnitDetailedThreatSituation("pet", unit)  
            end
        end
        
        if isTanking then
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
                debuffType = "HELPFUL",
                names = {},
                customVariables = [[{
  stacks = true,
}]],
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
        zoneIds = "",
        class = {
            multi = {
                WARRIOR = true,
            },
            single = "WARRIOR",
        },
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
