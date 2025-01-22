
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["combo_2"] = {
    id = "Combo 2",
    uid = "IeVJrdJlgNA",
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
                unit = "player",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                event = "Power",
                names = {},
                use_unit = true,
                spellIds = {},
                use_genericShowOn = true,
                use_power = true,
                use_showCost = false,
                powertype = 4,
                use_powertype = true,
                use_percentpower = false,
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
                use_health = false,
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
