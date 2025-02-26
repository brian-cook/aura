
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["rock_biter_weapon_buff"] = {
    id = "Rock Biter Weapon Buff",
    uid = "0dlD21pRU)9",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 128,
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
        {
            trigger = {
                type = "item",
                subeventSuffix = "_CAST_START",
                event = "Weapon Enchant",
                unit = "player",
                spellIds = {},
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                auranames = {
                    "687",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                useName = true,
                use_itemName = true,
                useRem = false,
                ownOnly = true,
                enchant = "Rockbiter",
                use_enchant = true,
                use_weapon = true,
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
