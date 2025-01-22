
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["eviscerate"] = {
    id = "Eviscerate",
    uid = "zdBthOvY(Y2",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 204,
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
                type = "spell",
                subeventSuffix = "_CAST_START",
                event = "Action Usable",
                subeventPrefix = "SPELL",
                spellIds = {},
                unit = "player",
                names = {},
                debuffType = "HELPFUL",
                spellName = 2098,
                realSpellName = "Arcane Shot",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_genericShowOn = true,
                use_track = true,
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
        class = {
            multi = {
                ROGUE = true,
                HUNTER = true,
            },
            single = "HUNTER",
        },
        spec = {
            multi = {},
        },
        size = {
            multi = {},
        },
        use_class = false,
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
