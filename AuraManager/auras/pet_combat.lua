
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["pet_combat"] = {
    id = "Pet Combat",
    uid = "H5yuWk(O57I",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 188,
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
                type = "unit",
                subeventSuffix = "",
                duration = "1",
                event = "Unit Characteristics",
                unit = "pet",
                use_unit = true,
                spellIds = {},
                names = {},
                subeventPrefix = "DAMAGE_SHIELD",
                debuffType = "HARMFUL",
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                itemName = 5317,
                use_count = false,
                auranames = {
                    "Moonfire",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                useName = true,
                use_itemName = true,
                useRem = false,
                use_threatvalue = false,
                threatpct_operator = {
                    ">=",
                },
                status = 3,
                eventtype = "PLAYER_REGEN_ENABLED",
                threatpct = {
                    "100",
                },
                use_sourceUnit = false,
                use_eventtype = true,
                use_alertType = true,
                use_aggro = true,
                use_status = false,
                use_delay = true,
                use_threatpct = false,
                ownOnly = true,
                use_messageType = true,
                use_behavior = false,
                use_inCombat = true,
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
                DRUID = true,
            },
            single = "DRUID",
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
