
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["pet_focus_50"] = {
    id = "Pet Focus 50",
    uid = "NJrMQ22Mq6q",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 100,
    yOffset = 84,
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
                duration = "1",
                subeventPrefix = "DAMAGE_SHIELD",
                type = "unit",
                subeventSuffix = "",
                unit = "pet",
                event = "Power",
                spellIds = {},
                use_unit = true,
                debuffType = "HARMFUL",
                names = {},
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_percentpower = true,
                itemName = 4253,
                use_count = false,
                auranames = {
                    "Moonfire",
                },
                unitExists = false,
                matchesShowOn = "showOnActive",
                use_itemName = true,
                useName = true,
                useRem = false,
                percentpower = {
                    "50",
                },
                percentpower_operator = {
                    ">=",
                },
                use_threatvalue = false,
                threatpct_operator = {
                    ">=",
                },
                status = 3,
                eventtype = "PLAYER_REGEN_ENABLED",
                use_sourceUnit = false,
                threatpct = {
                    "100",
                },
                use_delay = true,
                ownOnly = true,
                use_eventtype = true,
                use_status = false,
                use_aggro = true,
                use_alertType = true,
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
