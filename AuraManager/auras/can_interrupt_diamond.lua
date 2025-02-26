
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["can_interrupt_diamond"] = {
    id = "Can Interrupt Diamond",
    uid = "9aDWKFa4sJD",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 168,
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
                type = "custom",
                subeventSuffix = "_CAST_START",
                unevent = "auto",
                customVariables = "",
                duration = "1",
                event = "Health",
                unit = "player",
                custom_type = "stateupdate",
                use_unit = true,
                custom = [[function(allstates, event, ...)
        -- Throttle checks
        if not aura_env.last or GetTime() - aura_env.last > 0.2 then
            aura_env.last = GetTime()
            
            -- Check all nameplates
            for i = 1, 40 do
                local unit = "nameplate"..i
                
                -- Check if unit exists and is attackable
                if UnitExists(unit) and UnitCanAttack("player", unit) then
                    -- Check if unit has diamond mark (3)
                    local mark = GetRaidTargetIndex(unit)
                    local inRange = CheckInteractDistance(unit, 3)  -- 8 yards for Kick
                    
                    if mark == 3 and inRange then
                        -- Check if unit is casting and can be interrupted
                        local spellName, _, _, _, endTime, _, _, notInterruptible = UnitCastingInfo(unit)
                        if not spellName then
                            spellName, _, _, _, endTime, _, notInterruptible = UnitChannelInfo(unit)
                        end
                        
                        if spellName and not notInterruptible then
                            allstates[""] = {
                                show = true,
                                changed = true,
                                unit = unit,
                                spellName = spellName,
                                endTime = endTime and (endTime/1000) or 0
                            }
                            return true
                        end
                    end
                end
            end
            
            -- No valid target found, hide aura
            allstates[""] = {
                show = false,
                changed = true
            }
            return true
        end
    end]],
                spellIds = {},
                check = "update",
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                use_absorbMode = true,
                customStacks = [[function() return aura_env.count end]],
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
        class = {
            multi = {
                WARRIOR = true,
            },
            single = "WARRIOR",
        },
        zoneIds = "",
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
