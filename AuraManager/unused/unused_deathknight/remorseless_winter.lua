
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["remorseless_winter"] = {
    id = "Remorseless Winter",
    uid = "QmFEiiwri3r",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 16,
    yOffset = -32,
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
                realSpellName = "Arcane Shot",
                use_spellName = true,
                spellIds = {},
                subeventPrefix = "SPELL",
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 196770,
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
            single = "HUNTER",
            multi = {
                ROGUE = true,
                HUNTER = true,
            },
        },
        spec = {
            multi = {},
        },
        size = {
            multi = {},
        },
        use_class = false,
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
