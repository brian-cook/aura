
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_feared"] = {
    id = "Player Feared",
    uid = "2FaLTaL4qjN",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 196,
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
                unit = "target",
                subeventPrefix = "SPELL",
                event = "Crowd Controlled",
                names = {},
                spellIds = {},
                use_unit = true,
                subeventSuffix = "_CAST_START",
                use_inverse = false,
                auranames = {
                    "Quick Flame Ward",
                },
                unitExists = false,
                useRem = false,
                useName = true,
                use_debuffClass = false,
                matchesShowOn = "showOnActive",
                debuffClass = {
                    magic = true,
                },
                use_controlType = true,
                use_interruptSchool = true,
                useExactSpellId = false,
                controlType = "FEAR",
                auraspellids = {
                    "116",
                },
                interruptSchool = 16,
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
                MAGE = true,
                ROGUE = true,
            },
            single = "MAGE",
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
