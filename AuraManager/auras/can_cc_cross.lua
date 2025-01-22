
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["can_cc_cross"] = {
    id = "Can CC Cross",
    uid = "VvC)(w2AXrf",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 140,
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
                unevent = "auto",
                subeventSuffix = "_CAST_START",
                customVariables = "",
                duration = "1",
                event = "Health",
                subeventPrefix = "SPELL",
                custom_type = "stateupdate",
                use_unit = true,
                spellIds = {},
                custom = [[function(allstates, event, ...)
    -- Throttle checks
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        
        -- Check all nameplates
        for i = 1, 40 do
            local unit = "nameplate"..i
            
            -- Check if unit exists and is attackable
            if UnitExists(unit) and UnitCanAttack("player", unit) then
                -- Check if unit has cross mark (7)
                local mark = GetRaidTargetIndex(unit)
                local inRange = WeakAuras.CheckRange(unit, 8, "<=")
                
                if mark == 7 and inRange then
                    -- Check if unit is CC'd
                    local isCC = false
                    local i = 1
                    while true do
                        local name = UnitDebuff(unit, i)
                        if not name then break end
                        
                        -- List of CC effects to check for
                        if name == "Sap" or name == "Blind" or name == "Gouge" then
                            isCC = true
                            break
                        end
                        i = i + 1
                    end
                    
                    -- If not CC'd, show aura
                    if not isCC then
                        allstates[""] = {
                            show = true,
                            changed = true,
                            unit = unit
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
                check = "update",
                unit = "player",
                names = {},
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
