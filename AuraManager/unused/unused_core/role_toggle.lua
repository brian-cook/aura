
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["role_toggle"] = {
    id = "Role Toggle",
    uid = "kZsY(XvrsI5",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 32,
    yOffset = -32,
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
                unit = "player",
                event = "Health",
                names = {},
                spellIds = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                custom = [[function(event,glStr,value)
    local cvar="WeakaurasCustomToggle1"
    if glStr and value and glStr==cvar then
        return tonumber(value)==1
    elseif not glStr and not value then
        RegisterCVar(cvar,0)
    end
end]],
                check = "event",
                custom_type = "status",
                events = "CVAR_UPDATE",
            },
            untrigger = {
                custom = [[function(event,glStr,value)
    local cvar="WeakaurasCustomToggle1"
    if glStr and value and glStr==cvar then
        return tonumber(value)==0
    end
end]],
            },
        },
    },
    conditions = {},
    load = {
        talent = {
            multi = {},
        },
        class = {
            multi = {},
        },
        spec = {
            multi = {},
        },
        size = {
            multi = {},
        },
        use_never = false,
        zoneIds = "",
        role = {
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
