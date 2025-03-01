
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["earthbind_totem_dropped"] = {
    id = "Earthbind Totem Dropped",
    uid = "oVg5lUr18Z4",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 136,
    yOffset = 96,
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
                type = "spell",
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Totem",
                spellIds = {},
                debuffType = "HELPFUL",
                names = {},
                use_genericShowOn = true,
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                auranames = {
                    "Demon Skin",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                useName = true,
                use_itemName = true,
                useRem = false,
                enchant = "Rockbiter",
                weapon = "main",
                use_weapon = true,
                use_totemType = false,
                use_totemName = true,
                use_totemNamePattern = false,
                use_showOn = true,
                totemName = "Earthbind Totem",
                showOn = "showOnActive",
                use_enchant = true,
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
                ROGUE = true,
            },
            single = "ROGUE",
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
