
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["target_is_elite_boss_or_player"] = {
    id = "Target is Elite Boss or Player",
    uid = "F)BQoZrD48k",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 168,
    yOffset = 68,
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
        disjunctive = "any",
        {
            trigger = {
                subeventPrefix = "SPELL",
                use_absorbMode = true,
                type = "unit",
                subeventSuffix = "_CAST_START",
                unit = "target",
                event = "Unit Characteristics",
                spellIds = {},
                use_unit = true,
                debuffType = "HELPFUL",
                names = {},
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
                use_showCost = true,
                use_power = false,
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
