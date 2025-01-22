
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_silenced"] = {
    id = "Player Silenced",
    uid = "kkr98SL4nFr",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 100,
    yOffset = 88,
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
        disjunctive = "any",
        activeTriggerMode = -10,
        {
            trigger = {
                debuffType = "HELPFUL",
                type = "unit",
                unit = "player",
                subeventPrefix = "SPELL",
                event = "Crowd Controlled",
                names = {},
                spellIds = {},
                use_unit = true,
                subeventSuffix = "_CAST_START",
                use_inverse = false,
                realSpellName = "Wrath",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 5176,
                itemName = 0,
                use_itemName = true,
                use_messageType = false,
                use_controlType = true,
                controlType = "SILENCE",
                use_ismoving = true,
                instance_size = {},
                use_sourceName = false,
                use_targetRequired = false,
                use_moveSpeed = false,
                use_message = false,
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
