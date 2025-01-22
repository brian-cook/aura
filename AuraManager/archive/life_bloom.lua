
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["life_bloom"] = {
    id = "LIfe Bloom",
    uid = "ipZ8RFOoCDb",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 4,
    yOffset = -8,
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
                type = "aura2",
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                event = "Health",
                unit = "player",
                names = {},
                spellIds = {},
                subeventPrefix = "SPELL",
                matchesShowOn = "showOnActive",
                ownOnly = true,
                unitExists = false,
                useName = true,
                auranames = {
                    "408124",
                },
                useRem = false,
                useExactSpellId = false,
                auraspellids = {
                    "408124",
                },
                stacks = "1",
                useStacks = true,
                stacksOperator = "==",
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
                DRUID = true,
            },
            single = "DRUID",
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
