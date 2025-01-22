
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_casting_heal"] = {
    id = "Player Casting Heal",
    uid = "bPlzyfDEWeZ",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 32,
    yOffset = -24,
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
                type = "unit",
                spellName = 0,
                subeventSuffix = "_CAST_START",
                unit = "player",
                event = "Cast",
                names = {},
                realSpellName = 0,
                use_spellName = true,
                spellIds = {},
                genericShowOn = "showOnCooldown",
                use_genericShowOn = true,
                subeventPrefix = "SPELL",
                use_track = true,
                debuffType = "HELPFUL",
                use_unit = true,
                use_castType = false,
                use_destUnit = false,
                use_spellNames = true,
                spellNames = {
                    "Healing Touch",
                },
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
