
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["range_35_circle"] = {
    id = "Range 35 Circle",
    uid = "nDNoryCML7y",
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
        activeTriggerMode = -10,
        {
            trigger = {
                debuffType = "HELPFUL",
                type = "custom",
                unit = "player",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                duration = "1",
                event = "Health",
                names = {},
                custom_type = "stateupdate",
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
                local inRange = WeakAuras.CheckRange(unit, 35, "<=")
                
                if mark == 2 and inRange then
                    allstates[""] = {
                        show = true,
                        changed = true,
                        unit = unit
                    }
                    return true
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
                use_unit = true,
                check = "update",
                customVariables = "",
                unevent = "auto",
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
        size = {
            multi = {},
        },
        spec = {
            multi = {},
        },
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
