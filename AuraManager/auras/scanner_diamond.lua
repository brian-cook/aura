
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["scanner_diamond"] = {
    id = "Scanner Diamond",
    uid = "erNvZYrAHDX",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 204,
    yOffset = 76,
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
                custom_hide = "timed",
                use_absorbMode = true,
                type = "custom",
                subeventSuffix = "_CAST_START",
                unevent = "auto",
                custom_type = "stateupdate",
                unit = "player",
                event = "Health",
                customStacks = [[function() return aura_env.count end]],
                custom = [[function(allstates)
    -- Throttle updates for performance
    if not aura_env.lastUpdate or GetTime() - aura_env.lastUpdate > 0.1 then
        aura_env.lastUpdate = GetTime()
        
        -- Function to check if unit has an interruptible cast
        local function hasInterruptibleCast(unit)
            if UnitExists(unit) and UnitCanAttack("player", unit) and not UnitIsDeadOrGhost(unit) then
                -- Skip if unit has skull mark
                local currentMark = GetRaidTargetIndex(unit)
                if currentMark == 8 then return false end
                
                local name, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
                -- Also check channeled spells
                if not name then
                    name, _, _, _, _, _, notInterruptible = UnitChannelInfo(unit)
                end
                
                -- Return true if casting and can be interrupted
                if name and not notInterruptible then
                    -- Set diamond mark (3) if not already marked
                    if currentMark ~= 3 then
                        SetRaidTarget(unit, 3)
                    end
                    return true
                else
                    -- Clear diamond if no longer casting
                    if currentMark == 3 then
                        SetRaidTarget(unit, 0)
                    end
                end
            end
            return false
        end
        
        -- Check all units
        for i = 1, 20 do
            if hasInterruptibleCast("nameplate" .. i) then
                allstates[""] = {
                    show = true,
                    changed = true
                }
                return true
            end
        end
        
        -- Check target and other common unit IDs
        local unitsToCheck = {
            "target", "pettarget",
            "party1target", "party2target", "party3target", "party4target",
            "partypet1target", "partypet2target", "partypet3target", "partypet4target"
        }
        
        for _, unit in ipairs(unitsToCheck) do
            if hasInterruptibleCast(unit) then
                allstates[""] = {
                    show = true,
                    changed = true
                }
                return true
            end
        end
        
        -- No interruptible cast found
        allstates[""] = {
            show = false,
            changed = true
        }
    end
    
    return true
end]],
                spellIds = {},
                events = "PLAYER_TARGET_CHANGED",
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
        use_never = false,
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
