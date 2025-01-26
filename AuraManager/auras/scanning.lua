
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["scanning"] = {
    id = "Scanning",
    uid = "OOxT7UpjMVd",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 104,
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
        activeTriggerMode = -10,
        {
            trigger = {
                debuffType = "HELPFUL",
                type = "custom",
                unit = "player",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                event = "Health",
                names = {},
                custom_type = "status",
                spellIds = {},
                custom = [[function(event, glStr, value)
    local cvar = "WeakAurasScannerToggle"
    if glStr and value and glStr == cvar then
        -- Return true if the CVar exists and has any value
        return value ~= "NO_TARGET" and value ~= ""
    elseif not glStr and not value then
        -- Register the CVar if it doesn't exist
        RegisterCVar(cvar, "NO_TARGET")
    end
end]],
                check = "event",
                events = "CVAR_UPDATE",
            },
            untrigger = {
                custom = "",
            },
        },
    },
    conditions = {},
    load = {
        use_never = true,
        talent = {
            multi = {},
        },
        class = {
            multi = {},
        },
        size = {
            multi = {},
        },
        spec = {
            multi = {},
        },
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
