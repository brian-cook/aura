
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["lightning_shield_buff"] = {
    id = "Lightning Shield Buff",
    uid = "HoQcVo2rHtJ",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 172,
    yOffset = 92,
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
                event = "Weapon Enchant",
                spellIds = {},
                debuffType = "HELPFUL",
                names = {},
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                auranames = {
                    "324",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                use_itemName = true,
                useName = true,
                useRem = false,
                enchant = "Rockbiter",
                use_weapon = true,
                use_enchant = true,
                use_showOn = true,
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
