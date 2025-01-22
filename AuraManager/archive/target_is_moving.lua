
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["target_is_moving"] = {
    id = "Target Is Moving",
    uid = "fYzi6AJVp9U",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 36,
    yOffset = -20,
    width = 3,
    height = 3,
    frameStrata = 1,
    barColor = {
        1,
        0,
        0,
        1,
    },
    barColor2 = {
        1,
        0,
        0,
        1,
    },
    backgroundColor = {
        1,
        0,
        0,
        1,
    },
    texture = "Solid",
    textureSource = "LSM",
    triggers = {
        activeTriggerMode = 1,
        disjunctive = "all",
        {
            trigger = {
                type = "custom",
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                event = "Health",
                unit = "player",
                names = {},
                spellIds = {},
                use_unit = true,
                subeventPrefix = "SPELL",
                duration = "1",
                unevent = "auto",
                custom = [[function(allstates)
    if not aura_env.last or GetTime() - aura_env.last > 0.5 then
        aura_env.last = GetTime()
        
        local unitSpeed, _, _, _ = GetUnitSpeed("target")           
        if not unitSpeed then return end
        
        if unitSpeed > 0 then
            allstates[""] = allstates[""] or {show = true}
            allstates[""].changed = true
            return true
        else
            allstates[""] = allstates[""] or {show = false}
            allstates[""].show = false
            allstates[""].changed = true
            return true
        end
    end
end]],
                custom_type = "stateupdate",
                check = "update",
                customVariables = "{}",
                custom_hide = "timed",
            },
            untrigger = {},
        },
    },
    conditions = {},
    load = {
        size = {
            multi = {},
        },
        spec = {
            multi = {},
        },
        class = {
            multi = {
                WARLOCK = true,
            },
            single = "WARLOCK",
        },
        talent = {
            multi = {},
        },
        use_never = false,
        zoneIds = "",
        level_operator = {
            "~=",
        },
        use_level = false,
        level = {
            "120",
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
