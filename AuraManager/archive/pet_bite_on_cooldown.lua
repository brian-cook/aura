
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["pet_bite_on_cooldown"] = {
    id = "Pet Bite on Cooldown",
    uid = "TOfCRVOn7IM",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 4,
    yOffset = -12,
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
                type = "spell",
                debuffType = "HARMFUL",
                subeventSuffix = "",
                event = "Cooldown Progress (Spell)",
                unit = "target",
                names = {},
                spellIds = {},
                use_unit = true,
                subeventPrefix = "DAMAGE_SHIELD",
                matchesShowOn = "showOnActive",
                ownOnly = true,
                unitExists = false,
                useName = true,
                auranames = {
                    "Moonfire",
                },
                useRem = false,
                use_genericShowOn = true,
                realSpellName = "Bite",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                spellName = 17255,
                use_track = true,
                itemName = 7285,
                use_count = false,
                use_itemName = true,
                duration = "1",
                use_threatvalue = false,
                use_delay = true,
                use_alertType = true,
                eventtype = "PLAYER_REGEN_ENABLED",
                use_sourceUnit = false,
                threatpct = {
                    "100",
                },
                use_status = false,
                use_eventtype = true,
                use_aggro = true,
                status = 3,
                use_threatpct = false,
                threatpct_operator = {
                    ">=",
                },
                use_messageType = true,
                use_itemBonusId = true,
                use_itemSlot = false,
                use_itemSetId = true,
                itemBonusId = "15310",
                itemTypeName = {},
                use_itemTypeName = false,
                use_equipped = true,
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
            multi = {
                DRUID = true,
            },
            single = "DRUID",
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
