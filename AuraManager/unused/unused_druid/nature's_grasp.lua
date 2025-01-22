
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["nature's_grasp"] = {
    id = "Nature's Grasp",
    uid = "x5ArMn0P5nW",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 40,
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
                type = "spell",
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                names = {},
                event = "Action Usable",
                unit = "player",
                realSpellName = "Nature's Grasp",
                use_spellName = true,
                spellIds = {},
                subeventPrefix = "SPELL",
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 16689,
                use_exact_spellName = false,
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
            single = "DRUID",
            multi = {
                ROGUE = true,
                DRUID = true,
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
