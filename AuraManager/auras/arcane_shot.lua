
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["arcane_shot"] = {
    id = "Arcane Shot",
    uid = "l5Rtr9shIoX",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 104,
    yOffset = 100,
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
                event = "Action Usable",
                spellIds = {},
                use_genericShowOn = true,
                realSpellName = "Arcane Shot",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 14281,
                use_exact_spellName = false,
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
            multi = {},
            single = "HUNTER",
        },
        spec = {
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
