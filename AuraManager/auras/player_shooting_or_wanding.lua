
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_shooting_or_wanding"] = {
    id = "Player Shooting or Wanding",
    uid = "oi8Gz(e80LT",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 204,
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
    aura_env.shooting = aura_env.shooting or false
    
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        
        -- Check both wand and ranged weapon status
        local isAutoShotOn = IsAutoRepeatSpell(GetSpellInfo(75))  -- 75 is Auto Shot
        local isWandShooting = IsAutoRepeatSpell(GetSpellInfo(5019))  -- 5019 is Shoot (Wand)
        local hasRangedWeapon = IsEquippedItemType("Bow") or IsEquippedItemType("Gun") or IsEquippedItemType("Crossbow")
        local hasWand = IsEquippedItemType("Wand")
        
        -- Update shooting state for either wand or ranged weapon
        aura_env.shooting = (isAutoShotOn and hasRangedWeapon) or (isWandShooting and hasWand)
        
        -- Update state display
        allstates[""] = allstates[""] or {show = false}
        allstates[""].show = aura_env.shooting
        allstates[""].changed = true
        
        return true
    end
    return false
end]],
                spellIds = {},
                events = "PLAYER_TARGET_CHANGED START_AUTOREPEAT_SPELL STOP_AUTOREPEAT_SPELL",
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
