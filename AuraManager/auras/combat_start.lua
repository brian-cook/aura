
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["combat_start"] = {
    id = "Combat Start",
    uid = "VUnGeBmQhCu",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 168,
    yOffset = 100,
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
                type = "event",
                subeventSuffix = "",
                duration = "2",
                event = "Combat Events",
                subeventPrefix = "DAMAGE_SHIELD",
                use_unit = true,
                spellIds = {},
                unit = "target",
                names = {},
                debuffType = "HARMFUL",
                genericShowOn = "showOnCooldown",
                use_genericShowOn = true,
                itemName = 0,
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
                eventtype = "PLAYER_REGEN_DISABLED",
                threatpct = {
                    "100",
                },
                use_sourceUnit = false,
                use_threatpct = false,
                use_alertType = true,
                use_status = false,
                use_delay = false,
                use_aggro = true,
                ownOnly = true,
                use_eventtype = true,
                use_messageType = true,
                delay = 2,
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
