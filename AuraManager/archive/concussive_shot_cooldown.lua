
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["concussive_shot_cooldown"] = {
    id = "Concussive Shot Cooldown",
    uid = "xEii5JGgDsX",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 72,
    yOffset = 0,
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
                type = "spell",
                debuffType = "HARMFUL",
                subeventSuffix = "_CAST_START",
                event = "Cooldown Progress (Spell)",
                unit = "target",
                names = {},
                spellIds = {},
                subeventPrefix = "SPELL",
                matchesShowOn = "showOnActive",
                ownOnly = true,
                unitExists = false,
                useName = true,
                auranames = {
                    "Concussive Shot",
                },
                useRem = false,
                use_genericShowOn = true,
                realSpellName = "Concussive Shot",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                spellName = 5116,
                use_track = true,
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
                HUNTER = true,
            },
            single = "HUNTER",
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
