
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["bomb_in_inventory"] = {
    id = "Bomb in Inventory",
    uid = "No7qKs3GBoJ",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 140,
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
                debuffType = "HELPFUL",
                type = "item",
                unit = "player",
                subeventPrefix = "SPELL",
                event = "Item Count",
                names = {},
                spellIds = {},
                subeventSuffix = "_CAST_START",
                realSpellName = "Taunt",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 355,
                itemName = 4360,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                count = "1",
                use_itemName = true,
                useName = true,
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
                subeventPrefix = "SPELL",
                event = "Item Count",
                names = {},
                spellIds = {},
                subeventSuffix = "_CAST_START",
                realSpellName = "Taunt",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 355,
                itemName = 4358,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                count = "1",
                use_itemName = true,
                useName = true,
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
                subeventPrefix = "SPELL",
                event = "Item Count",
                names = {},
                spellIds = {},
                subeventSuffix = "_CAST_START",
                realSpellName = "Taunt",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 355,
                itemName = 4365,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                count = "1",
                use_itemName = true,
                useName = true,
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
                subeventPrefix = "SPELL",
                event = "Item Count",
                names = {},
                spellIds = {},
                subeventSuffix = "_CAST_START",
                realSpellName = "Taunt",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 355,
                itemName = 4378,
                use_count = true,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                count = "1",
                use_itemName = true,
                useName = true,
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
                WARRIOR = true,
                DRUID = true,
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
