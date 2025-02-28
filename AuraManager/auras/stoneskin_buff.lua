
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["stoneskin_buff"] = {
    id = "Stoneskin Buff",
    uid = "n3WJCzfJCJA",
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
                type = "aura2",
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
                    "8072",
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
                totemName = "8071",
                showOn = "showOnActive",
                weapon = "main",
                totemType = 1,
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
