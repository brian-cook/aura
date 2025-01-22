
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["target_circle"] = {
    id = "Target Circle",
    uid = "sJ54N2kwQ1Z",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 180,
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
        disjunctive = "all",
        activeTriggerMode = 1,
        {
            trigger = {
                custom_hide = "timed",
                type = "unit",
                unevent = "auto",
                subeventSuffix = "_CAST_START",
                customVariables = "{}",
                duration = "1",
                event = "Unit Characteristics",
                subeventPrefix = "SPELL",
                custom_type = "stateupdate",
                use_unit = true,
                spellIds = {},
                check = "update",
                unit = "target",
                names = {},
                debuffType = "HELPFUL",
                use_unitisunit = false,
                use_character = false,
                use_class = false,
                character = "player",
                raidMarkIndex = 2,
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
