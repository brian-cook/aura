
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["travel_form"] = {
    id = "Travel Form",
    uid = "gsQJxhbq3Dw",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 8,
    yOffset = -40,
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
                debuffType = "BOTH",
                subeventSuffix = "_CAST_START",
                names = {},
                event = "Stance/Form/Aura",
                unit = "player",
                spellIds = {},
                subeventPrefix = "SPELL",
                auranames = {
                    "Cat Form",
                },
                ownOnly = true,
                unitExists = false,
                useName = true,
                matchesShowOn = "showOnActive",
                useRem = false,
                use_unit = true,
                use_debuffClass = false,
                useNamePattern = false,
                use_form = true,
                form = {
                    single = 3,
                },
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
