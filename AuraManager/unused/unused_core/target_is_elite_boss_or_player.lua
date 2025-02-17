
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["target_is_elite_boss_or_player"] = {
    id = "Target is Elite Boss or Player",
    uid = "F)BQoZrD48k",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 100,
    yOffset = -36,
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
                type = "unit",
                subeventSuffix = "_CAST_START",
                unit = "target",
                event = "Unit Characteristics",
                names = {},
                spellIds = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                use_power = false,
                use_showCost = true,
                powertype = 3,
                use_powertype = true,
                use_absorbHealMode = true,
                percenthealth = {
                    "20",
                },
                use_percentpower = false,
                use_unit = true,
                use_absorbMode = true,
                use_percenthealth = true,
                percenthealth_operator = {
                    "<",
                },
                use_unitisunit = false,
                use_character = false,
                classification = {
                    single = "elite",
                    multi = {
                        elite = true,
                        worldboss = true,
                        rareelite = true,
                    },
                },
                unitisunit = "Quinik",
                use_classification = false,
                use_namerealm = false,
                use_npcId = false,
                use_specific_unitisunit = true,
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
            single = "ROGUE",
            multi = {
                ROGUE = true,
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
