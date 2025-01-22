
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["pet_focus_40"] = {
    id = "Pet Focus 40",
    uid = "U8z2O5XO)iE",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 100,
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
                type = "unit",
                debuffType = "HARMFUL",
                subeventSuffix = "",
                names = {},
                event = "Power",
                unit = "pet",
                spellIds = {},
                subeventPrefix = "DAMAGE_SHIELD",
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                auranames = {
                    "Moonfire",
                },
                ownOnly = true,
                unitExists = false,
                useName = true,
                matchesShowOn = "showOnActive",
                useRem = false,
                use_percentpower = true,
                use_unit = true,
                percentpower_operator = {
                    ">=",
                },
                percentpower = {
                    "40",
                },
                itemName = 4253,
                use_itemName = true,
                use_threatvalue = false,
                threatpct_operator = {
                    ">=",
                },
                status = 3,
                eventtype = "PLAYER_REGEN_ENABLED",
                use_sourceUnit = false,
                duration = "1",
                use_count = false,
                use_threatpct = false,
                threatpct = {
                    "100",
                },
                use_status = false,
                use_aggro = true,
                use_eventtype = true,
                use_delay = true,
                use_alertType = true,
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
            single = "DRUID",
            multi = {
                DRUID = true,
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
