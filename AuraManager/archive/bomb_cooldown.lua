
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["bomb_cooldown"] = {
    id = "Bomb Cooldown",
    uid = "UcUpvXGoicg",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 44,
    yOffset = 0,
    width = 3,
    height = 3,
    frameStrata = 1,
    barColor = {
        1,
        0,
        0,
        1,
    },
    barColor2 = {
        1,
        0,
        0,
        1,
    },
    backgroundColor = {
        1,
        0,
        0,
        1,
    },
    texture = "Solid",
    textureSource = "LSM",
    triggers = {
        activeTriggerMode = -10,
        {
            trigger = {
                type = "item",
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                event = "Cooldown Progress (Item)",
                unit = "player",
                names = {},
                spellIds = {},
                subeventPrefix = "SPELL",
                matchesShowOn = "showOnActive",
                unitExists = false,
                useName = true,
                auranames = {
                    "Enrage",
                },
                useRem = false,
                use_debuffClass = false,
                useNamePattern = false,
                use_genericShowOn = true,
                realSpellName = "Taunt",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                spellName = 355,
                use_track = true,
                itemName = 4360,
                use_itemName = true,
            },
            untrigger = {},
        },
    },
    conditions = {},
    load = {
        size = {
            multi = {},
        },
        spec = {
            multi = {},
        },
        class = {
            multi = {
                DRUID = true,
                WARRIOR = true,
            },
            single = "WARRIOR",
        },
        talent = {
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
