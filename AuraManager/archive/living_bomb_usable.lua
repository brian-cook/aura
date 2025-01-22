
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["living_bomb_usable"] = {
    id = "Living Bomb Usable",
    uid = "pPc7Kv8LCsq",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 24,
    yOffset = -8,
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
                type = "spell",
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                event = "Action Usable",
                unit = "player",
                names = {},
                spellIds = {},
                subeventPrefix = "SPELL",
                use_genericShowOn = true,
                realSpellName = "Living Bomb",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                spellName = 400613,
                use_track = true,
                use_inverse = true,
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
                ROGUE = true,
                MAGE = true,
            },
            single = "MAGE",
        },
        talent = {
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
