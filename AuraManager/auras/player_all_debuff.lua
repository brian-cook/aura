
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_all_debuff"] = {
    id = "Player All Debuff",
    uid = "XmhJkVBwX4W",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 136,
    yOffset = 84,
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
                subeventPrefix = "SPELL",
                type = "aura2",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Crowd Controlled",
                spellIds = {},
                use_unit = true,
                debuffType = "HARMFUL",
                names = {},
                use_inverse = false,
                auranames = {
                    "Quick Flame Ward",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = true,
                useName = false,
                useRem = false,
                debuffClass = {
                    disease = true,
                    bleed = true,
                    poison = true,
                    magic = true,
                    curse = true,
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
                ROGUE = true,
                MAGE = true,
            },
            single = "MAGE",
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
