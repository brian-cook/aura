
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["combat"] = {
    id = "Combat",
    uid = "CrtyJoBAnr7",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 188,
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
        disjunctive = "any",
        customTriggerLogic = "",
        {
            trigger = {
                subeventPrefix = "SPELL",
                custom_hide = "timed",
                type = "unit",
                names = {},
                subeventSuffix = "_CAST_START",
                debuffType = "BOTH",
                unit = "player",
                event = "Conditions",
                use_unit = true,
                events = "PLAYER_REGEN_ENABLED PLAYER_REGEN_DISABLED",
                custom = [[function(event)
    return UnitAffectingCombat("player")
end]],
                spellIds = {},
                check = "update",
                custom_type = "event",
                auranames = {
                    "Demon Skin",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                useName = true,
                ownOnly = true,
                use_incombat = true,
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
            multi = {
                DRUID = true,
            },
            single = "DRUID",
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
