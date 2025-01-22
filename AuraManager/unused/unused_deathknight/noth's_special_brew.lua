
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["noth's_special_brew"] = {
    id = "Noth's Special Brew",
    uid = "O4jhKkS)8l7",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 44,
    yOffset = -20,
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
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                names = {},
                use_inverse = false,
                event = "Cooldown Progress (Item)",
                unit = "player",
                realSpellName = "Arcane Blast",
                use_spellName = true,
                spellIds = {},
                subeventPrefix = "SPELL",
                use_genericShowOn = true,
                genericShowOn = "showOnReady",
                use_track = true,
                spellName = 56222,
                itemName = 39327,
                use_itemName = true,
            },
            untrigger = {},
        },
    },
    conditions = {},
    load = {
        race = {
            single = "Scourge",
            multi = {
                Scourge = true,
            },
        },
        talent = {
            multi = {},
        },
        class = {
            single = "MAGE",
            multi = {
                MAGE = true,
                ROGUE = true,
            },
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
