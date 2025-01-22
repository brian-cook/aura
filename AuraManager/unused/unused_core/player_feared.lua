
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_feared"] = {
    id = "Player Feared",
    uid = "2FaLTaL4qjN",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 56,
    yOffset = -24,
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
                unit = "target",
                use_inverse = false,
                event = "Crowd Controlled",
                names = {},
                spellIds = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                auranames = {
                    "Quick Flame Ward",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                useName = true,
                useRem = false,
                use_unit = true,
                use_debuffClass = false,
                debuffClass = {
                    magic = true,
                },
                use_controlType = true,
                use_interruptSchool = true,
                interruptSchool = 16,
                controlType = "FEAR",
                auraspellids = {
                    "116",
                },
                useExactSpellId = false,
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
            single = "MAGE",
            multi = {
                MAGE = true,
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
