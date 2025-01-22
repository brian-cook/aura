
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["holy_power_2"] = {
    id = "Holy Power 2",
    uid = "pSy)EqoJTjt",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 116,
    yOffset = -12,
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
                event = "Power",
                names = {},
                spellIds = {},
                use_genericShowOn = true,
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                use_power = true,
                use_showCost = false,
                powertype = 9,
                use_powertype = true,
                use_percentpower = false,
                use_unit = true,
                percentpower_operator = {
                    ">=",
                },
                percentpower = {
                    "10",
                },
                use_runesCount = true,
                power = {
                    "2",
                },
                power_operator = {
                    ">=",
                },
                runesCount_operator = ">=",
                rune = 0,
                runesCount = "1",
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
