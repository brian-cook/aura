
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_is_healing"] = {
    id = "Player is Healing",
    uid = "bPlzyfDEWeZ",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 56,
    yOffset = -12,
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
                type = "unit",
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                event = "Cast",
                unit = "player",
                names = {},
                spellIds = {},
                use_unit = true,
                subeventPrefix = "SPELL",
                use_genericShowOn = true,
                realSpellName = 0,
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                spellName = 0,
                use_track = true,
                use_castType = false,
                use_destUnit = false,
                use_spellNames = true,
                spellNames = {
                    "healing touch",
                },
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
            multi = {},
        },
        talent = {
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
