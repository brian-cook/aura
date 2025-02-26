
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["target_is_elite_boss_or_player"] = {
    id = "Target is Elite Boss or Player",
    uid = "F)BQoZrD48k",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 212,
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
        disjunctive = "any",
        activeTriggerMode = -10,
        {
            trigger = {
                type = "unit",
                subeventSuffix = "_CAST_START",
                event = "Unit Characteristics",
                unit = "target",
                use_unit = true,
                spellIds = {},
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                use_absorbMode = true,
                use_unitisunit = false,
                use_character = false,
                unitisunit = "Quinik",
                powertype = 3,
                use_powertype = true,
                use_absorbHealMode = true,
                percenthealth = {
                    "20",
                },
                use_percentpower = false,
                use_power = false,
                use_showCost = true,
                use_percenthealth = true,
                percenthealth_operator = {
                    "<",
                },
                classification = {
                    multi = {
                        elite = true,
                        worldboss = true,
                        rareelite = true,
                    },
                    single = "elite",
                },
                use_classification = false,
                use_specific_unitisunit = true,
                use_npcId = false,
                use_namerealm = false,
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
