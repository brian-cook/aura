
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["combo_points_1"] = {
    id = "Combo Points 1",
    uid = "P4BYL)1(hlb",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 16,
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
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                names = {},
                event = "Power",
                unit = "player",
                spellIds = {},
                subeventPrefix = "SPELL",
                use_power = true,
                use_showCost = false,
                powertype = 4,
                use_powertype = true,
                use_percentpower = false,
                use_unit = true,
                percentpower = {
                    "5",
                },
                percentpower_operator = {
                    ">=",
                },
                power = {
                    "1",
                },
                power_operator = {
                    ">=",
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
            single = "ROGUE",
            multi = {
                ROGUE = true,
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
