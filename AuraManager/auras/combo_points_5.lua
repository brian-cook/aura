
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["combo_points_5"] = {
    id = "Combo Points 5",
    uid = "4WpVzhtgSlV",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 212,
    yOffset = 100,
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
                subeventPrefix = "SPELL",
                type = "unit",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Power",
                spellIds = {},
                use_unit = true,
                debuffType = "HELPFUL",
                names = {},
                powertype = 4,
                use_powertype = true,
                use_percentpower = false,
                use_showCost = false,
                use_power = true,
                percentpower = {
                    "5",
                },
                percentpower_operator = {
                    ">=",
                },
                power_operator = {
                    "==",
                },
                power = {
                    "5",
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
            multi = {
                ROGUE = true,
            },
            single = "ROGUE",
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
