
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["party_1_range_35"] = {
    id = "Party 1 Range 35",
    uid = "gCHQsouemnj",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 104,
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
                names = {},
                unit = "party1",
                event = "Range Check",
                subeventPrefix = "SPELL",
                spellIds = {},
                use_unit = true,
                subeventSuffix = "_CAST_START",
                range = "35",
                use_genericShowOn = true,
                realSpellName = "Wrath",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 5176,
                use_range = true,
                range_operator = "<=",
                itemName = 0,
                use_itemName = true,
                use_inverse = false,
                use_messageType = false,
                use_hand = true,
                instance_size = {},
                use_moveSpeed = false,
                use_targetRequired = false,
                use_message = false,
                use_sourceName = false,
                use_spellNames = true,
                use_specific_unit = true,
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
