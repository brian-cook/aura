
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["target_dies_30"] = {
    id = "Target Dies 30",
    uid = "Rsc1OJGRxPL",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 212,
    yOffset = 72,
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
                duration = "1",
                subeventPrefix = "SPELL",
                custom_hide = "custom",
                use_absorbMode = true,
                type = "custom",
                subeventSuffix = "_CAST_START",
                unevent = "auto",
                custom_type = "event",
                unit = "player",
                event = "Health",
                customStacks = [[function() return aura_env.count end]],
                custom = [[function(event, ...)
    -- Initialize on first load
    if not aura_env.damageTracker then
        aura_env.damageTracker = {}
        aura_env.sampleWindow = 5     -- Seconds of damage data to track
        aura_env.lastUpdate = 0
    end
    
    -- If target changed, reset tracking
    if event == "PLAYER_TARGET_CHANGED" then
        aura_env.damageTracker = {}
    end
    
    -- Track damage from combat log
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID = CombatLogGetCurrentEventInfo()
        
        -- Only track damage to our current target
        if UnitExists("target") and destGUID == UnitGUID("target") then
            -- Record damage events
            if subEvent:match("_DAMAGE") then
                local amount = select(subEvent == "SWING_DAMAGE" and 12 or 15, CombatLogGetCurrentEventInfo())
                
                -- Store damage entry with timestamp
                table.insert(aura_env.damageTracker, {
                        timestamp = GetTime(),
                        amount = amount
                })
            end
        end
    end
    
    -- Only update calculation every 0.5 seconds for performance
    local now = GetTime()
    if now - aura_env.lastUpdate > 0.5 then
        aura_env.lastUpdate = now
        
        -- Skip if no target or target is friendly
        if not UnitExists("target") or not UnitCanAttack("player", "target") then     
            return false
        end
        
        -- Get current target health
        local currentHealth = UnitHealth("target")
        
        -- Remove old damage entries
        local cutoffTime = now - aura_env.sampleWindow
        local i = 1
        while i <= #aura_env.damageTracker do
            if aura_env.damageTracker[i].timestamp < cutoffTime then
                table.remove(aura_env.damageTracker, i)
            else
                i = i + 1
            end
        end  
        
        -- Calculate total damage in window
        local totalDamage = 0
        for _, entry in ipairs(aura_env.damageTracker) do
            totalDamage = totalDamage + entry.amount
        end
        
        -- Calculate DPS (handle edge cases)
        local elapsed = #aura_env.damageTracker > 0 
        and (now - aura_env.damageTracker[1].timestamp)
        or aura_env.sampleWindow
        
        elapsed = math.max(elapsed, 1) -- Ensure at least 1 second for initial estimate
        local dps = totalDamage / elapsed
        
        -- Calculate time to death
        local timeToDeathSeconds = dps > 0 and currentHealth / dps or 999
        
        return timeToDeathSeconds <= 30
    end
    
    return false
end]],
                spellIds = {},
                events = "PLAYER_TARGET_CHANGED COMBAT_LOG_EVENT_UNFILTERED",
                use_unit = true,
                check = "update",
                debuffType = "HELPFUL",
                names = {},
                customVariables = [[{
  stacks = true,
}]],
            },
            untrigger = {},
        },
    },
    conditions = {},
    load = {
        use_never = true,
        talent = {
            multi = {},
        },
        zoneIds = "",
        class = {
            multi = {
                WARRIOR = true,
            },
            single = "WARRIOR",
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
