
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["bomb"] = {
    id = "Bomb",
    uid = "UcUpvXGoicg",
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
        activeTriggerMode = -10,
        {
            trigger = {
                subeventPrefix = "SPELL",
                type = "item",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Cooldown Progress (Item)",
                spellIds = {},
                debuffType = "HELPFUL",
                names = {},
                realSpellName = "Taunt",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnReady",
                use_track = true,
                spellName = 355,
                itemName = 4360,
                auranames = {
                    "Enrage",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
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
