
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["potion"] = {
    id = "Potion",
    uid = "B1REXj79mTh",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 200,
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
        disjunctive = "any",
        activeTriggerMode = -10,
        {
            trigger = {
                debuffType = "HELPFUL",
                type = "item",
                unit = "player",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                event = "Cooldown Progress (Item)",
                names = {},
                spellIds = {},
                useRem = false,
                unitExists = false,
                matchesShowOn = "showOnActive",
                useName = true,
                auranames = {
                    "Enrage",
                },
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnReady",
                use_track = true,
                itemName = 858,
                use_count = true,
                count_operator = ">=",
                use_debuffClass = false,
                use_itemName = true,
                useNamePattern = false,
            },
            untrigger = {},
        },
        {
            trigger = {
                debuffType = "HELPFUL",
                type = "item",
                unit = "player",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                event = "Cooldown Progress (Item)",
                names = {},
                spellIds = {},
                useRem = false,
                unitExists = false,
                matchesShowOn = "showOnActive",
                useName = true,
                auranames = {
                    "Enrage",
                },
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnReady",
                use_track = true,
                itemName = 929,
                use_count = true,
                count_operator = ">=",
                use_debuffClass = false,
                use_itemName = true,
                useNamePattern = false,
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
                WARRIOR = true,
            },
            single = "WARRIOR",
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
