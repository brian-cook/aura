
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["pet_health_under_20"] = {
    id = "Pet Health Under 20",
    uid = "GaFzGxxrojL",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 136,
    yOffset = 92,
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
                unit = "pet",
                subeventPrefix = "SPELL",
                event = "Health",
                names = {},
                spellIds = {},
                use_unit = true,
                subeventSuffix = "_CAST_START",
                use_power = false,
                use_showCost = true,
                powertype = 3,
                use_powertype = true,
                use_absorbHealMode = true,
                percenthealth = {
                    "20",
                },
                use_percentpower = false,
                use_absorbMode = true,
                use_percenthealth = true,
                percenthealth_operator = {
                    "<",
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
