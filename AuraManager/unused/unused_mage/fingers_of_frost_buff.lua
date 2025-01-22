
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["fingers_of_frost_buff"] = {
    id = "Fingers of Frost Buff",
    uid = "vzK(rDuvStu",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 116,
    yOffset = -8,
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
                type = "aura2",
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                names = {},
                event = "Health",
                unit = "player",
                spellIds = {},
                subeventPrefix = "SPELL",
                auranames = {
                    "Fingers of Frost",
                },
                ownOnly = true,
                unitExists = false,
                useName = true,
                matchesShowOn = "showOnActive",
                useRem = false,
                use_debuffClass = false,
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
            single = "MAGE",
            multi = {
                MAGE = true,
                ROGUE = true,
            },
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
