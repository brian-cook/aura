
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["potion_in_inventory"] = {
    id = "Potion in Inventory",
    uid = "hPxWoC)vtyf",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 120,
    yOffset = 80,
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
                type = "item",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Item Count",
                spellIds = {},
                debuffType = "HELPFUL",
                names = {},
                realSpellName = "Taunt",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 355,
                itemName = 118,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                count_operator = ">=",
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                count = "1",
                use_itemName = true,
                useName = true,
                useNamePattern = false,
                useRem = false,
            },
            untrigger = {},
        },
        {
            trigger = {
                subeventPrefix = "SPELL",
                type = "item",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Item Count",
                spellIds = {},
                debuffType = "HELPFUL",
                names = {},
                realSpellName = "Taunt",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 355,
                itemName = 858,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                count_operator = ">=",
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                count = "1",
                use_itemName = true,
                useName = true,
                useNamePattern = false,
                useRem = false,
            },
            untrigger = {},
        },
        {
            trigger = {
                subeventPrefix = "SPELL",
                type = "item",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Item Count",
                spellIds = {},
                debuffType = "HELPFUL",
                names = {},
                realSpellName = "Taunt",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 355,
                itemName = 929,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                count_operator = ">=",
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                count = "1",
                use_itemName = true,
                useName = true,
                useNamePattern = false,
                useRem = false,
            },
            untrigger = {},
        },
        {
            trigger = {
                subeventPrefix = "SPELL",
                type = "item",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Item Count",
                spellIds = {},
                debuffType = "HELPFUL",
                names = {},
                realSpellName = "Taunt",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 355,
                itemName = 3928,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                count_operator = ">=",
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                count = "1",
                use_itemName = true,
                useName = true,
                useNamePattern = false,
                useRem = false,
            },
            untrigger = {},
        },
        {
            trigger = {
                subeventPrefix = "SPELL",
                type = "item",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Item Count",
                spellIds = {},
                debuffType = "HELPFUL",
                names = {},
                realSpellName = "Taunt",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 355,
                itemName = 1710,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                count_operator = ">=",
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                count = "1",
                use_itemName = true,
                useName = true,
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
