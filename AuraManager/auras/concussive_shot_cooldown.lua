
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["concussive_shot_cooldown"] = {
    id = "Concussive Shot Cooldown",
    uid = "xEii5JGgDsX",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 200,
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
                unit = "target",
                spellIds = {},
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HARMFUL",
                spellName = 5116,
                use_genericShowOn = true,
                realSpellName = "Concussive Shot",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                auranames = {
                    "Concussive Shot",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                useName = true,
                useRem = false,
                ownOnly = true,
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
