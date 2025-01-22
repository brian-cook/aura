
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["skull_bash_cooldown"] = {
    id = "Skull Bash Cooldown",
    uid = "jewvp3HnpGG",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 100,
    yOffset = -16,
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
        disjunctive = "any",
        {
            trigger = {
                type = "spell",
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                event = "Cooldown Progress (Spell)",
                unit = "player",
                names = {},
                spellIds = {},
                subeventPrefix = "SPELL",
                use_exact_spellName = false,
                use_genericShowOn = true,
                realSpellName = "Skull Bash",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                spellName = 410176,
                use_track = true,
            },
            untrigger = {},
        },
        {
            trigger = {
                type = "spell",
                debuffType = "HELPFUL",
                event = "Action Usable",
                unit = "player",
                use_genericShowOn = true,
                realSpellName = "Skull Bash",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                spellName = 410176,
                use_track = true,
                use_inverse = true,
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
                ROGUE = true,
                DRUID = true,
                HUNTER = true,
            },
            single = "DRUID",
        },
        talent = {
            multi = {},
        },
        race = {
            multi = {
                Scourge = true,
            },
            single = "Scourge",
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
