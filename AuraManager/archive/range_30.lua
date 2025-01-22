
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["range_30"] = {
    id = "Range 30",
    uid = "bv)32Qh714h",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 40,
    yOffset = -16,
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
        activeTriggerMode = -10,
        {
            trigger = {
                type = "unit",
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                use_powertype = true,
                event = "Range Check",
                use_showCost = true,
                unit = "target",
                names = {},
                powertype = 3,
                spellIds = {},
                use_unit = true,
                subeventPrefix = "SPELL",
                use_percentpower = false,
                use_power = false,
                percenthealth = {
                    "20",
                },
                use_percenthealth = true,
                percenthealth_operator = {
                    "<",
                },
                use_absorbHealMode = true,
                range_operator = "<=",
                range = "30",
                use_absorbMode = true,
                use_range = true,
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
                ROGUE = true,
            },
            single = "ROGUE",
        },
        talent = {
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
