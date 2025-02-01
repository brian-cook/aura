
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["potion_cooldown"] = {
    id = "Potion Cooldown",
    uid = "Cx5I4dKLLoo",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 100,
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
                subeventPrefix = "SPELL",
                names = {},
                event = "Cooldown Progress (Item)",
                unit = "player",
                spellIds = {},
                subeventSuffix = "_CAST_START",
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
                useRem = false,
                useName = true,
                use_debuffClass = false,
                use_itemName = true,
                matchesShowOn = "showOnActive",
                useNamePattern = false,
                count_operator = ">=",
            },
            untrigger = {},
        },
        {
            trigger = {
                debuffType = "HELPFUL",
                type = "item",
                subeventPrefix = "SPELL",
                names = {},
                event = "Cooldown Progress (Item)",
                unit = "player",
                spellIds = {},
                subeventSuffix = "_CAST_START",
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
                useRem = false,
                useName = true,
                use_debuffClass = false,
                use_itemName = true,
                matchesShowOn = "showOnActive",
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
