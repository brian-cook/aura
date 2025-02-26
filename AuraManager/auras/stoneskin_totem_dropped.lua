
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["stoneskin_totem_dropped"] = {
    id = "Stoneskin Totem Dropped",
    uid = "rwiiWvrTv6V",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 148,
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
                names = {},
                subeventSuffix = "_CAST_START",
                debuffType = "HELPFUL",
                unit = "player",
                event = "Totem",
                spellIds = {},
                use_genericShowOn = true,
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 5730,
                auranames = {
                    "Demon Skin",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                use_itemName = true,
                useName = true,
                enchant = "Rockbiter",
                use_weapon = true,
                use_totemNamePattern = false,
                use_totemType = false,
                use_enchant = true,
                use_showOn = true,
                totemName = "8071",
                use_totemName = true,
                showOn = "showOnActive",
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
        size = {
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
