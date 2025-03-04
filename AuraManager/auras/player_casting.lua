
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_casting"] = {
    id = "Player Casting",
    uid = "8SCgjIGMY5D",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 144,
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
        activeTriggerMode = -10,
        disjunctive = "any",
        {
            trigger = {
                subeventPrefix = "SPELL",
                type = "custom",
                subeventSuffix = "_CAST_START",
                custom_type = "stateupdate",
                unit = "player",
                event = "Cast",
                custom = [[function(allstates, event, ...)
    -- Throttle updates for performance
    if not aura_env.lastUpdate or GetTime() - aura_env.lastUpdate > 0.05 then
        aura_env.lastUpdate = GetTime()
        
        -- Get casting info
        local name, _, _, _, endTime = UnitCastingInfo("player")
        
        -- Store end time with buffer for comparison
        if name then
            aura_env.bufferedEndTime = (endTime / 1000) + 0.05
        end
        
        -- Show if casting or within buffer period
        if name or (aura_env.bufferedEndTime and GetTime() < aura_env.bufferedEndTime) then
            allstates[""] = {
                show = true,
                changed = true
            }
        else
            allstates[""] = {
                show = false,
                changed = true
            }
            aura_env.bufferedEndTime = nil
        end
    end
    
    return true
end]],
                spellIds = {},
                use_unit = true,
                check = "update",
                debuffType = "HELPFUL",
                names = {},
                realSpellName = 0,
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 0,
                use_remaining = false,
                use_castType = true,
                use_showLatency = false,
                castType = "cast",
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
            multi = {},
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
