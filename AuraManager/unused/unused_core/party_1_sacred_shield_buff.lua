
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["party_1_sacred_shield_buff"] = {
    id = "Party 1 Sacred Shield Buff",
    uid = "NnTHbYmtuA4",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 64,
    yOffset = -20,
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
                spellName = 5176,
                subeventSuffix = "_CAST_START",
                unit = "member",
                use_inverse = false,
                event = "Conditions",
                names = {},
                realSpellName = "Wrath",
                use_spellName = true,
                spellIds = {},
                genericShowOn = "showOnCooldown",
                use_genericShowOn = true,
                subeventPrefix = "SPELL",
                use_track = true,
                debuffType = "HELPFUL",
                auranames = {
                    "Sacred Shield",
                },
                ownOnly = true,
                useName = true,
                useRem = false,
                range_operator = "<=",
                range = "35",
                use_unit = true,
                use_range = true,
                use_hand = true,
                itemName = 0,
                use_itemName = true,
                use_messageType = false,
                instance_size = {},
                use_sourceName = false,
                use_moveSpeed = false,
                use_targetRequired = false,
                use_message = false,
                use_spellNames = true,
                use_specific_unit = true,
                specificUnit = "party1",
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
