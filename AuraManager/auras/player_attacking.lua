
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_attacking"] = {
    id = "Player Attacking",
    uid = "6s63kxY6dhb",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 140,
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
        activeTriggerMode = 1,
        disjunctive = "all",
        {
            trigger = {
                duration = "1",
                subeventPrefix = "SPELL",
                custom_hide = "timed",
                type = "custom",
                subeventSuffix = "_CAST_START",
                unevent = "auto",
                custom_type = "stateupdate",
                unit = "player",
                event = "Health",
                custom = [[function(allstates)
    -- Initialize state if needed
    aura_env.last = aura_env.last or 0
    aura_env.attacking = aura_env.attacking or false
    
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        
        -- Check both auto attack spell and combat status
        local isAutoAttackOn = IsCurrentSpell(6603)  -- 6603 is Auto Attack
        local inMeleeRange = CheckInteractDistance("target", 3)  -- Range check (about 10 yards)
        local hasTarget = UnitExists("target")
        local canAttack = hasTarget and UnitCanAttack("player", "target")
        
        -- Update attacking state
        aura_env.attacking = isAutoAttackOn and (inMeleeRange or not hasTarget) and (canAttack or not hasTarget)
        
        -- Update state display
        allstates[""] = allstates[""] or {show = false}
        allstates[""].show = aura_env.attacking
        allstates[""].changed = true
        
        return true
    end
    return false
end]],
                spellIds = {},
                events = "PLAYER_TARGET_CHANGED PLAYER_ENTER_COMBAT PLAYER_LEAVE_COMBAT ATTACK_START ATTACK_STOP",
                use_unit = true,
                check = "update",
                debuffType = "HELPFUL",
                names = {},
                customVariables = "{}",
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
        zoneIds = "",
        class = {
            multi = {
                WARLOCK = true,
            },
            single = "WARLOCK",
        },
        spec = {
            multi = {},
        },
        size = {
            multi = {},
        },
        use_level = false,
        level = {
            "120",
        },
        level_operator = {
            "~=",
        },
        use_spellknown = false,
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
