
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["omen_of_clarity_buff"] = {
    id = "Omen of Clarity Buff",
    uid = "HLZneWlFxUo",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 132,
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
        disjunctive = "any",
        {
            trigger = {
                subeventPrefix = "SPELL",
                type = "aura2",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Health",
                spellIds = {},
                debuffType = "HELPFUL",
                names = {},
                auranames = {
                    "Omen of Clarity",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                useName = true,
                useNamePattern = false,
                useRem = false,
                ownOnly = true,
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
