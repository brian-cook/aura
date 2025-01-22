
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["party1_in_range"] = {
    id = "Party1 in range",
    uid = "gCHQsouemnj",
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
                event = "Range Check",
                unit = "party1",
                names = {},
                spellIds = {},
                use_unit = true,
                subeventPrefix = "SPELL",
                use_genericShowOn = true,
                realSpellName = "Wrath",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                spellName = 5176,
                use_track = true,
                range_operator = "<=",
                range = "35",
                use_range = true,
                itemName = 0,
                use_itemName = true,
                use_hand = true,
                use_inverse = false,
                use_messageType = false,
                use_sourceName = false,
                use_targetRequired = false,
                use_moveSpeed = false,
                use_message = false,
                instance_size = {},
                use_spellNames = true,
                use_specific_unit = true,
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
