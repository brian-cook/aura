
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["stealth_buff"] = {
    id = "Stealth Buff",
    uid = "Im7Iw)VB5Uv",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 128,
    yOffset = 72,
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
                type = "aura2",
                names = {},
                subeventSuffix = "_CAST_START",
                debuffType = "BOTH",
                unit = "player",
                event = "Health",
                spellIds = {},
                auranames = {
                    "Stealth",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                useName = true,
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
