
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["a_test_combat_log"] = {
    id = "A test combat log",
    uid = "xsXUqTEAqZJ",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 104,
    yOffset = 100,
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
                debuffType = "BOTH",
                type = "custom",
                unit = "player",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                event = "Health",
                names = {},
                custom_type = "event",
                spellIds = {},
                custom = [[function(event, ...)
    -- Check if the player is in combat
    local inCombat = UnitAffectingCombat("player")
    
    -- Check if the player is auto-attacking
    local isAutoAttacking = false
    for i = 1, 120 do -- Check all action slots for auto-attack
        if IsAutoRepeatAction(i) then
            isAutoAttacking = true
            break
        end
    end
    
    -- Display the aura if in combat and auto-attacking
    if inCombat and isAutoAttacking then
        return true
    end
    return false
end]],
                check = "update",
                custom_hide = "custom",
                auranames = {
                    "Amplify Magic",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                useName = true,
                ownOnly = true,
                events = "PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED",
            },
            untrigger = {
                custom = "",
            },
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
                DRUID = true,
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
