
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["combo_points_3"] = {
    id = "Combo Points 3",
    uid = "XbSBHgvtBvk",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 192,
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
                debuffType = "HELPFUL",
                type = "unit",
                subeventPrefix = "SPELL",
                names = {},
                event = "Power",
                unit = "player",
                spellIds = {},
                use_unit = true,
                subeventSuffix = "_CAST_START",
                use_power = true,
                use_showCost = false,
                powertype = 4,
                use_powertype = true,
                use_percentpower = false,
                percentpower = {
                    "5",
                },
                percentpower_operator = {
                    ">=",
                },
                power_operator = {
                    ">=",
                },
                power = {
                    "3",
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
        size = {
            multi = {},
        },
        spec = {
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
