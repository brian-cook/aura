
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["swing_timer_ranged"] = {
    id = "Swing Timer Ranged",
    uid = "gpO80VTBfU0",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 108,
    yOffset = 76,
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
                event = "Swing Timer",
                unit = "player",
                use_unit = true,
                spellIds = {},
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "BOTH",
                auranames = {
                    "Demon Skin",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                useName = true,
                useRem = false,
                use_inverse = false,
                ownOnly = true,
                use_incombat = true,
                remaining = ".5",
                use_hand = true,
                hand = "ranged",
                use_remaining = false,
                remaining_operator = "<=",
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
                DRUID = true,
            },
            single = "DRUID",
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
