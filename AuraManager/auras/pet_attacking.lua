
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["pet_attacking"] = {
    id = "Pet Attacking",
    uid = "mF0PhXl1Q5o",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 140,
    yOffset = 92,
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
                type = "custom",
                names = {},
                unevent = "auto",
                unit = "player",
                duration = "1",
                event = "Health",
                subeventPrefix = "SPELL",
                custom_type = "stateupdate",
                custom = [[function(allstates)
    -- Initialize state if needed
    aura_env.last = aura_env.last or 0
    aura_env.petAttacking = aura_env.petAttacking or false
    
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        
        -- Check pet existence and attack status
        local hasPet = UnitExists("pet")
        local petTarget = UnitExists("pettarget")
        local isPetAttacking = hasPet and (UnitGUID("pettarget") ~= nil) and (IsPetAttackActive())
        
        -- Update pet attacking state
        aura_env.petAttacking = isPetAttacking
        
        -- Update state display
        allstates[""] = allstates[""] or {show = false}
        allstates[""].show = aura_env.petAttacking
        allstates[""].changed = true
        
        return true
    end
    return false
end]],
                spellIds = {},
                use_unit = true,
                check = "update",
                customVariables = "{}",
                subeventSuffix = "_CAST_START",
                custom_hide = "timed",
                events = "UNIT_PET PET_ATTACK_START PET_ATTACK_STOP PLAYER_TARGET_CHANGED",
            },
            untrigger = {
                custom = [[function()
    return not aura_env.isTriggered
end]],
            },
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
        use_spellknown = false,
        size = {
            multi = {},
        },
        spec = {
            multi = {},
        },
        level_operator = {
            "~=",
        },
        level = {
            "120",
        },
        use_level = false,
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
