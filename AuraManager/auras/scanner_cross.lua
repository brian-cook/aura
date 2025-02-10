
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["scanner_cross"] = {
    id = "Scanner Cross",
    uid = "LKgdk6Ib9Kc",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 136,
    yOffset = 80,
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
                custom = [[function(allstates)
    -- Throttle updates for performance
    if not aura_env.lastUpdate or GetTime() - aura_env.lastUpdate > 0.1 then
        aura_env.lastUpdate = GetTime()
        
        -- Scan all possible targets
        local bestTarget = nil
        local bestRange = 200
        
        -- Function to check if unit can be gouged
        local function canBeGouged(unit)
            -- Check for immunities or existing CCs
            local i = 1
            while true do
                local name = UnitDebuff(unit, i)
                if not name then break end
                -- Skip if already CC'd
                if name == "Sap" or name == "Blind" or name == "Gouge" then
                    return false
                end
                i = i + 1
            end
            
            return true
        end
        
        -- Function to check a unit
        local function checkUnit(unit)
            if UnitExists(unit) and UnitCanAttack("player", unit) and not UnitIsDeadOrGhost(unit) then
                -- Clear triangle if unit can't be gouged
                if GetRaidTargetIndex(unit) == 7 and not canBeGouged(unit) then
                    SetRaidTarget(unit, 0)
                    return
                end
                
                -- Skip if unit has skull or already has triangle
                local currentMark = GetRaidTargetIndex(unit)
                if currentMark == 8 or currentMark == 7 then return end
                
                -- Check if unit is attacking a friendly player and can be gouged
                local targetUnit = unit .. "target"
                if UnitExists(targetUnit) and UnitIsPlayer(targetUnit) and 
                not UnitCanAttack("player", targetUnit) and canBeGouged(unit) then
                    -- Get range
                    local range = 200
                    if CheckInteractDistance(unit, 2) then -- 9 yards
                        range = 10
                    elseif CheckInteractDistance(unit, 4) then -- 28 yards
                        range = 30
                    end
                    
                    -- Update best target if closer
                    if range < bestRange then
                        bestTarget = unit
                        bestRange = range
                    end
                end
            end
        end
        
        -- Check all units
        for i = 1, 20 do
            checkUnit("nameplate" .. i)
        end
        checkUnit("target")
        checkUnit("pettarget")
        for i = 1, 4 do
            local partyUnit = "party" .. i
            checkUnit(partyUnit .. "target")
            checkUnit("partypet" .. i .. "target")
        end
        
        -- Mark best target with triangle if not already marked
        if bestTarget and GetRaidTargetIndex(bestTarget) ~= 7 then
            SetRaidTarget(bestTarget, 7)
        end
    end
    
    return true
end]],
                spellIds = {},
                use_unit = true,
                check = "update",
                customVariables = [[{
  stacks = true,
}]],
                subeventSuffix = "_CAST_START",
                custom_hide = "timed",
                customStacks = [[function() return aura_env.count end]],
                events = "PLAYER_TARGET_CHANGED",
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
