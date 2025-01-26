
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["pet_focus_50"] = {
    id = "Pet Focus 50",
    uid = "NJrMQ22Mq6q",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 168,
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
                debuffType = "HARMFUL",
                type = "unit",
                unit = "pet",
                subeventSuffix = "",
                subeventPrefix = "DAMAGE_SHIELD",
                duration = "1",
                event = "Power",
                names = {},
                spellIds = {},
                use_unit = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_percentpower = true,
                itemName = 4253,
                use_count = false,
                auranames = {
                    "Moonfire",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                useName = true,
                use_itemName = true,
                percentpower_operator = {
                    ">=",
                },
                percentpower = {
                    "50",
                },
                use_threatvalue = false,
                threatpct_operator = {
                    ">=",
                },
                status = 3,
                eventtype = "PLAYER_REGEN_ENABLED",
                threatpct = {
                    "100",
                },
                ownOnly = true,
                use_sourceUnit = false,
                use_delay = true,
                use_aggro = true,
                use_status = false,
                use_alertType = true,
                use_eventtype = true,
                use_threatpct = false,
                use_messageType = true,
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
