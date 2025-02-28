
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["strength_of_earth_totem_dropped"] = {
    id = "Strength of Earth Totem Dropped",
    uid = "BkEBAf9zkFG",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 164,
    yOffset = 72,
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
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                auranames = {
                    "Demon Skin",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                use_itemName = true,
                useName = true,
                useRem = false,
                enchant = "Rockbiter",
                use_weapon = true,
                use_totemName = true,
                use_totemType = false,
                use_enchant = true,
                use_showOn = true,
                totemName = "Strength of Earth Totem",
                showOn = "showOnActive",
                use_totemNamePattern = false,
                weapon = "main",
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
