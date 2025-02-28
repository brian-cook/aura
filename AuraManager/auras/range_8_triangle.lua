
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["range_8_triangle"] = {
    id = "Range 8 Triangle",
    uid = "FfTcnNu7jHr",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 140,
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
                use_absorbMode = true,
                type = "custom",
                subeventSuffix = "_CAST_START",
                unevent = "auto",
                custom_type = "stateupdate",
                unit = "player",
                event = "Health",
                customStacks = [[function() return aura_env.count end]],
                custom = [[function(allstates, event, ...)
    -- Throttle checks
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        
        -- Function to check a unit
        local function checkUnit(unit)
            if UnitExists(unit) and UnitCanAttack("player", unit) and not UnitIsDeadOrGhost(unit) then
                -- Check if unit has circle mark (2) and is in range
                local mark = GetRaidTargetIndex(unit)
                local inRange = WeakAuras.CheckRange(unit, 8, "<=")
                
                if mark == 4 and inRange then
                    allstates[""] = {
                        show = true,
                        changed = true,
                        unit = unit
                    }
                    return true
                end
            end
            return false
        end
        
        -- Check nameplates (max 20)
        for i = 1, 20 do
            if checkUnit("nameplate" .. i) then
                return true
            end
        end
        
        -- Check direct targets
        if checkUnit("target") then
            return true
        end
        if checkUnit("pettarget") then
            return true
        end
        
        -- Check party members and their targets/pets
        for i = 1, 4 do
            if checkUnit("party" .. i .. "target") then
                return true
            end
            if checkUnit("partypet" .. i .. "target") then
                return true
            end
        end
        
        -- No valid target found, hide aura
        allstates[""] = {
            show = false,
            changed = true
        }
    end
    
    return true
end]],
                spellIds = {},
                use_unit = true,
                check = "update",
                debuffType = "HELPFUL",
                names = {},
                customVariables = "",
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
