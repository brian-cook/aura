
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["combat"] = {
    id = "Combat",
    uid = "CrtyJoBAnr7",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 8,
    yOffset = -4,
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
                type = "unit",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Conditions",
                names = {},
                spellIds = {},
                subeventPrefix = "SPELL",
                debuffType = "BOTH",
                auranames = {
                    "Demon Skin",
                },
                ownOnly = true,
                unitExists = false,
                matchesShowOn = "showOnActive",
                useName = true,
                useRem = false,
                use_unit = true,
                use_incombat = true,
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
            single = "DRUID",
            multi = {
                DRUID = true,
            },
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
