
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["lacerate_usable"] = {
    id = "Lacerate Usable",
    uid = "txp28mC1JUP",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 12,
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
        disjunctive = "any",
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
                realSpellName = "Lacerate",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                spellName = 414644,
                use_track = true,
                use_inverse = false,
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
                DRUID = true,
                HUNTER = true,
            },
            single = "DRUID",
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
