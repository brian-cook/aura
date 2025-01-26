
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["potion"] = {
    id = "Potion",
    uid = "B1REXj79mTh",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 168,
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
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnReady",
                use_track = true,
                itemName = 858,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                useName = true,
                use_itemName = true,
                useNamePattern = false,
                count_operator = ">=",
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
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnReady",
                use_track = true,
                itemName = 929,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                useName = true,
                use_itemName = true,
                useNamePattern = false,
                count_operator = ">=",
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
