
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["pvp_trinket"] = {
    id = "PVP Trinket",
    uid = "OpLmW01F0DE",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 212,
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
                type = "item",
                subeventSuffix = "_CAST_START",
                event = "Cooldown Progress (Item)",
                subeventPrefix = "SPELL",
                spellIds = {},
                unit = "player",
                names = {},
                debuffType = "HELPFUL",
                spellName = 56222,
                use_inverse = false,
                realSpellName = "Arcane Blast",
                use_spellName = true,
                genericShowOn = "showOnReady",
                use_genericShowOn = true,
                use_track = true,
                itemName = 122370,
                use_itemName = true,
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
                MAGE = true,
                ROGUE = true,
            },
            single = "MAGE",
        },
        spec = {
            multi = {},
        },
        size = {
            multi = {},
        },
        race = {
            multi = {
                Scourge = true,
            },
            single = "Scourge",
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
