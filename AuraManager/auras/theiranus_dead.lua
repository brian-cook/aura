
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["theiranus_dead"] = {
    id = "Theiranus Dead",
    uid = "bT8YZEOPmLI",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 144,
    yOffset = 80,
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
        disjunctive = "all",
        activeTriggerMode = 1,
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
                custom = [[function(allstates)
    if not aura_env.last or GetTime() - aura_env.last > 0.5 then
        aura_env.last = GetTime()
        
        local targetName = "Theiranus"
        
        local exists = UnitExists(targetName)
        local isDead = exists and UnitIsDeadOrGhost(targetName)
        
        if (isDead) then
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
                spellIds = {},
                use_unit = true,
                check = "update",
                customVariables = "{}",
                subeventSuffix = "_CAST_START",
                custom_hide = "timed",
            },
            untrigger = {
                custom = [[function()
    return not aura_env.isTriggered
end]],
            },
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
                WARLOCK = true,
            },
            single = "WARLOCK",
        },
        use_spellknown = false,
        size = {
            multi = {},
        },
        spec = {
            multi = {},
        },
        level_operator = {
            "~=",
        },
        level = {
            "120",
        },
        use_level = false,
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
