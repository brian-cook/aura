
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["rune_2"] = {
    id = "Rune 2",
    uid = "zPeCaPE9JsM",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 76,
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
                event = "Death Knight Rune",
                use_showCost = false,
                unit = "player",
                names = {},
                powertype = 6,
                spellIds = {},
                use_unit = true,
                subeventPrefix = "SPELL",
                use_percentpower = false,
                percentpower = {
                    "10",
                },
                percentpower_operator = {
                    ">=",
                },
                use_genericShowOn = true,
                use_power = true,
                use_runesCount = true,
                rune = 0,
                power = {
                    "2",
                },
                power_operator = {
                    ">=",
                },
                runesCount_operator = ">=",
                runesCount = "2",
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
