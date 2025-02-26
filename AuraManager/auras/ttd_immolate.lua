
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["ttd_immolate"] = {
    id = "TTD Immolate",
    uid = "u53cO(ZxV(I",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 120,
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
                custom_hide = "timed",
                type = "custom",
                subeventSuffix = "_CAST_START",
                unevent = "auto",
                customVariables = "",
                duration = "1",
                event = "Health",
                unit = "player",
                custom_type = "event",
                use_unit = true,
                custom = [[function(allstates, event, ...)
    -- Debug setup
    aura_env.debug = true
    local function debugPrint(message, ...)
        if aura_env.debug then
            print(string.format("[TTD Immolate] " .. message, ...))
        end
    end
    
    -- Handle string input cases (OPTIONS/STATUS or event name)
    if type(allstates) == "string" then
        -- Handle OPTIONS/STATUS
        if allstates == "OPTIONS" or allstates == "STATUS" then
            debugPrint("Handling %s event", allstates)
            return {
                [""] = {
                    show = false,
                    changed = true,
                    icon = 348,
                    spellName = "Immolate",
                    progressType = "static",
                    autoHide = true,
                    duration = 0.1
                }
            }
        end
        
        -- Handle event name in allstates parameter
        if allstates == "WARLOCK_SPELL_UPDATE_IMMOLATE" then
            debugPrint("Update received via allstates - shouldCast: %s", tostring(event))
            local show = event == true
            return {
                [""] = {
                    show = show,
                    changed = true,
                    icon = 348,
                    spellName = "Immolate",
                    progressType = "static",
                    autoHide = true,
                    duration = 0.1,
                    reason = select(1, ...) or ""
                }
            }
        end
    end
    
    -- Handle normal event case
    if type(allstates) == "table" then
        -- Initialize with hidden state
        if not allstates[""] then
            allstates[""] = {
                show = false,
                changed = true,
                icon = 348,
                spellName = "Immolate",
                progressType = "static",
                autoHide = true,
                duration = 0.1
            }
            return true
        end
        
        if event == "WARLOCK_SPELL_UPDATE_IMMOLATE" then
            local shouldCast, reason = ...
            debugPrint("Update received - shouldCast: %s, reason: %s", 
                tostring(shouldCast), tostring(reason))
            
            shouldCast = shouldCast == true
            
            if allstates[""].show ~= shouldCast then
                allstates[""].show = shouldCast
                allstates[""].changed = true
                allstates[""].reason = reason or ""
                return true
            end
        end
    end
    
    return false
end]],
                spellIds = {},
                check = "update",
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                use_absorbMode = true,
                customStacks = "",
                events = "WARLOCK_SPELL_UPDATE_IMMOLATE",
                dynamicDuration = true,
            },
            untrigger = {
                custom = "",
            },
        },
    },
    conditions = {},
    load = {
        use_never = true,
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
        group_leader = {
            multi = {
                LEADER = true,
            },
            single = "LEADER",
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
