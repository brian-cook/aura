
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["bandage_in_inventory"] = {
    id = "Bandage in Inventory",
    uid = "CB2BR5EGUIN",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 116,
    yOffset = 100,
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
                type = "item",
                subeventSuffix = "_CAST_START",
                event = "Item Count",
                unit = "player",
                spellIds = {},
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                itemName = 1251,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                count_operator = ">=",
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                useName = true,
                use_itemName = true,
                count = "1",
                useNamePattern = false,
                useRem = false,
            },
            untrigger = {},
        },
        {
            trigger = {
                type = "item",
                subeventSuffix = "_CAST_START",
                event = "Item Count",
                unit = "player",
                spellIds = {},
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                itemName = 2581,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                count_operator = ">=",
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                useName = true,
                use_itemName = true,
                count = "1",
                useNamePattern = false,
                useRem = false,
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
                WARRIOR = true,
                DRUID = true,
            },
            single = "WARRIOR",
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
