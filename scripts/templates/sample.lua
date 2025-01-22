local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["sample"] = {
    id = "Sample",
    uid = "qE)HwzrHToA",
    regionType = "aurabar",
    internalVersion = 78,
    iconSource = -1,
    color = {
        1,
        1,
        1,
        1,
    },
    yOffset = 0,
    anchorPoint = "CENTER",
    cooldown = false,
    cooldownSwipe = false,
    cooldownEdge = false,
    cooldownTextDisabled = true,
    icon = false,
    triggers = {
        activeTriggerMode = -10,
        {
            trigger = {
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                event = "Health",
                names = {},
                spellIds = {},
                type = "aura2",
                unit = "player",
                subeventPrefix = "SPELL",
            },
            untrigger = {},
        },
    },
    load = {
        talent = {
            multi = {},
        },
        spec = {
            multi = {},
        },
        class = {
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
    conditions = {},
    config = {},
    displayIcon = nil,
    information = {},
    width = 5,
    height = 5,
    frameStrata = 1,
    selfPoint = "CENTER",
    xOffset = 0,
    zoom = 0,
    subRegions = {
        {
            type = "subbackground",
        },
        {
            type = "subforeground",
        },
    },
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
}
