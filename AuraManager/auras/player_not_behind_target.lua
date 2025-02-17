
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_not_behind_target"] = {
    id = "Player not behind target",
    uid = "VpGXA06c4Qk",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 192,
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
                debuffType = "HELPFUL",
                type = "custom",
                names = {},
                unit = "target",
                duration = ".5",
                event = "Crowd Controlled",
                subeventPrefix = "SPELL",
                custom_type = "event",
                custom = [[function(event, arg1, arg2)
    if event == "UI_ERROR_MESSAGE" and string.find(arg2, "be behind your") then
        return true
    end
    return false
end]],
                spellIds = {},
                use_unit = true,
                subeventSuffix = "_CAST_START",
                custom_hide = "timed",
                events = "UI_ERROR_MESSAGE",
                auranames = {
                    "Quick Flame Ward",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                use_debuffClass = false,
                useName = true,
                use_inverse = false,
                debuffClass = {
                    magic = true,
                },
                use_controlType = true,
                use_interruptSchool = true,
                useExactSpellId = false,
                controlType = "ROOT",
                interruptSchool = 16,
                auraspellids = {
                    "116",
                },
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
                MAGE = true,
                ROGUE = true,
            },
            single = "MAGE",
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
