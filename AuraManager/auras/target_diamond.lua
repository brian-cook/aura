
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["target_diamond"] = {
    id = "Target Diamond",
    uid = "Dku5i0(ijgG",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 144,
    yOffset = 76,
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
        disjunctive = "all",
        activeTriggerMode = 1,
        {
            trigger = {
                custom_hide = "timed",
                type = "unit",
                subeventSuffix = "_CAST_START",
                unevent = "auto",
                customVariables = "{}",
                duration = "1",
                event = "Unit Characteristics",
                unit = "target",
                custom_type = "stateupdate",
                use_unit = true,
                spellIds = {},
                check = "update",
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                use_unitisunit = false,
                use_character = false,
                use_class = false,
                character = "player",
                raidMarkIndex = 3,
                use_raidMarkIndex = true,
                unitisunit = "player",
            },
            untrigger = {},
        },
    },
    conditions = {},
    load = {
        use_never = false,
        talent = {
            multi = {},
        },
        class = {
            multi = {
                WARLOCK = true,
            },
            single = "WARLOCK",
        },
        zoneIds = "",
        use_level = false,
        level_operator = {
            "~=",
        },
        level = {
            "120",
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
