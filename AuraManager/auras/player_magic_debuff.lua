
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_magic_debuff"] = {
    id = "Player Magic Debuff",
    uid = "YRz7RcFT72d",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 172,
    yOffset = 88,
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
                debuffType = "HARMFUL",
                type = "aura2",
                subeventPrefix = "SPELL",
                names = {},
                event = "Crowd Controlled",
                unit = "player",
                spellIds = {},
                use_unit = true,
                subeventSuffix = "_CAST_START",
                use_inverse = false,
                auranames = {
                    "Quick Flame Ward",
                },
                unitExists = false,
                useRem = false,
                useName = false,
                use_debuffClass = true,
                matchesShowOn = "showOnActive",
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
