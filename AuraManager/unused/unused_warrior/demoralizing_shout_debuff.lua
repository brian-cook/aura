
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["demoralizing_shout_debuff"] = {
    id = "Demoralizing Shout Debuff",
    uid = "rOCdB9WMGAS",
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
        disjunctive = "any",
        {
            trigger = {
                type = "aura2",
                debuffType = "HARMFUL",
                subeventSuffix = "_CAST_START",
                names = {},
                event = "Health",
                unit = "target",
                spellIds = {},
                subeventPrefix = "SPELL",
                auranames = {
                    "Demoralizing Shout",
                },
                useName = true,
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
            single = "DRUID",
            multi = {
                DRUID = true,
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
