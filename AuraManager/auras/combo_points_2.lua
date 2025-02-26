
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["combo_points_2"] = {
    id = "Combo Points 2",
    uid = "fK5DGiXssJb",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 184,
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
                type = "unit",
                subeventSuffix = "_CAST_START",
                event = "Power",
                unit = "player",
                use_unit = true,
                spellIds = {},
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                powertype = 4,
                use_powertype = true,
                use_percentpower = false,
                use_power = true,
                use_showCost = false,
                percentpower_operator = {
                    ">=",
                },
                percentpower = {
                    "5",
                },
                power_operator = {
                    ">=",
                },
                power = {
                    "2",
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
