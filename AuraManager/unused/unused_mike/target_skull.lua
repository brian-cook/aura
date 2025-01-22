
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["target_skull"] = {
    id = "Target Skull",
    uid = "HCCC8tDvWT3",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 216,
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
                debuffType = "HELPFUL",
                type = "unit",
                unit = "target",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                duration = "1",
                event = "Unit Characteristics",
                names = {},
                use_unit = true,
                custom_type = "stateupdate",
                spellIds = {},
                check = "update",
                unevent = "auto",
                custom_hide = "timed",
                customVariables = "{}",
                use_class = false,
                use_unitisunit = false,
                use_character = false,
                character = "player",
                use_raidMarkIndex = true,
                raidMarkIndex = 8,
                unitisunit = "player",
            },
            untrigger = {},
        },
    },
    conditions = {},
    load = {
        use_level = false,
        talent = {
            multi = {},
        },
        class = {
            multi = {
                WARLOCK = true,
            },
            single = "WARLOCK",
        },
        size = {
            multi = {},
        },
        spec = {
            multi = {},
        },
        use_never = false,
        level = {
            "120",
        },
        level_operator = {
            "~=",
        },
        zoneIds = "",
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
