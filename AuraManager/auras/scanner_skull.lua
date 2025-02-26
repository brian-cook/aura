
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["scanner_skull"] = {
    id = "Scanner Skull",
    uid = "(aOmUt8ICVz",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 160,
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
                custom_hide = "timed",
                type = "custom",
                subeventSuffix = "_CAST_START",
                unevent = "auto",
                customVariables = [[{
  stacks = true,
}]],
                duration = "1",
                event = "Health",
                unit = "player",
                custom_type = "stateupdate",
                use_unit = true,
                custom = [[function(allstates)
    -- Throttle updates for performance
    if not aura_env.lastUpdate or GetTime() - aura_env.lastUpdate > 0.1 then
        aura_env.lastUpdate = GetTime()
        
        -- Scan all possible targets
        local bestTarget = nil
        local bestHealth = 2000000000
        local bestRange = 200
        
        -- Function to check a unit
        local function checkUnit(unit)
            if UnitExists(unit) and not UnitIsDeadOrGhost(unit) and UnitCanAttack("player", unit) then
                local health = UnitHealth(unit)
                
                -- Get range
                local range = 200
                if CheckInteractDistance(unit, 2) then -- 9 yards
                    range = 10
                elseif CheckInteractDistance(unit, 4) then -- 28 yards
                    range = 30
                end
                
                -- Update best target if better
                if health < bestHealth or (health == bestHealth and range < bestRange) then
                    bestTarget = unit
                    bestHealth = health
                    bestRange = range
                end
            end
        end
        
        -- Check nameplates (max 20)
        for i = 1, 20 do
            checkUnit("nameplate" .. i)
        end
        
        -- Check direct targets
        checkUnit("target")
        checkUnit("pettarget")
        
        -- Check party members and their targets/pets
        for i = 1, 4 do
            local partyUnit = "party" .. i
            checkUnit(partyUnit .. "target")
            checkUnit("partypet" .. i .. "target")
        end
        
        -- Mark best target with skull if not already marked
        if bestTarget and GetRaidTargetIndex(bestTarget) ~= 8 then
            SetRaidTarget(bestTarget, 8)
        end
    end
    
    return true
end]],
                spellIds = {},
                check = "update",
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                use_absorbMode = true,
                customStacks = [[function() return aura_env.count end]],
                events = "PLAYER_TARGET_CHANGED",
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
