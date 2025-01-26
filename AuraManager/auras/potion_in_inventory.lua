
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["potion_in_inventory"] = {
    id = "Potion in Inventory",
    uid = "hPxWoC)vtyf",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 176,
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
                event = "Item Count",
                names = {},
                spellIds = {},
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                itemName = 118,
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
                count = "1",
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
                event = "Item Count",
                names = {},
                spellIds = {},
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
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
                count = "1",
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
                event = "Item Count",
                names = {},
                spellIds = {},
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
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
                count = "1",
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
                event = "Item Count",
                names = {},
                spellIds = {},
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                itemName = 3928,
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
                count = "1",
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
                event = "Item Count",
                names = {},
                spellIds = {},
                spellName = 355,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                itemName = 1710,
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
                count = "1",
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
