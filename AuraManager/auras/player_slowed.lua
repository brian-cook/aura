
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_slowed"] = {
    id = "Player Slowed",
    uid = "AVBnASZJF6x",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 176,
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
        activeTriggerMode = -10,
        {
            trigger = {
                debuffType = "HARMFUL",
                type = "unit",
                names = {},
                unit = "player",
                event = "Crowd Controlled",
                subeventPrefix = "SPELL",
                spellIds = {},
                use_unit = true,
                subeventSuffix = "_CAST_START",
                use_absorbMode = true,
                use_absorbHealMode = true,
                auranames = {
                    "Chains of Ice",
                    "Concussive Shot",
                    "Frostbolt",
                    "Slow",
                    "Cone of Cold",
                    "Mind Flay",
                    "Crippling Poison",
                    "Frost Shock",
                    "Frostbrand Weapon",
                    "Curse of Exhaustion",
                    "Piercing Howl",
                    "Hamstring",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                useName = false,
                use_controlType = true,
                controlType = "ROOT",
                use_health = true,
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
                ROGUE = true,
            },
            single = "ROGUE",
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
