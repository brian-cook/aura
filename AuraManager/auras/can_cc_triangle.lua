
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["can_cc_triangle"] = {
    id = "Can CC Triangle",
    uid = "uDkhovDL9O6",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 164,
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
                debuffType = "HELPFUL",
                type = "custom",
                names = {},
                unevent = "auto",
                unit = "player",
                duration = "1",
                event = "Health",
                subeventPrefix = "SPELL",
                custom_type = "stateupdate",
                custom = [[function(allstates, event, ...)
    -- Throttle checks
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        
        -- Function to check if unit is CC'd
        local function isUnitCCd(unit)
            local i = 1
            while true do
                local name = UnitDebuff(unit, i)
                if not name then break end
                
                -- List of CC effects to check for
                if name == "Sap" or name == "Blind" or name == "Gouge" then
                    return true
                end
                i = i + 1
            end
            return false
        end
        
        -- Function to check a unit
        local function checkUnit(unit)
            if UnitExists(unit) and UnitCanAttack("player", unit) and not UnitIsDeadOrGhost(unit) then
                -- Check if unit has cross mark (7)
                if GetRaidTargetIndex(unit) == 4 and not isUnitCCd(unit) then
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
                customVariables = "",
                subeventSuffix = "_CAST_START",
                customStacks = [[function() return aura_env.count end]],
                use_absorbMode = true,
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
