
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_casting"] = {
    id = "Player Casting",
    uid = "8SCgjIGMY5D",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 208,
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
                debuffType = "HELPFUL",
                type = "unit",
                unit = "player",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                event = "Cast",
                names = {},
                spellIds = {},
                use_unit = true,
                spellName = 0,
                use_genericShowOn = true,
                realSpellName = 0,
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                use_castType = true,
                castType = "channel",
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
            multi = {},
        },
        size = {
            multi = {},
        },
        spec = {
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
