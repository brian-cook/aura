
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["icon_triangle_exists"] = {
    id = "Icon Triangle Exists",
    uid = "kSiMqGPEHco",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 156,
    yOffset = 92,
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
                custom = [[function(allstates)
    -- Throttle updates for performance
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        
        -- Function to check a unit for triangle mark
        local function checkUnit(unit)
            if UnitExists(unit) and GetRaidTargetIndex(unit) == 4 then
                -- Found a triangle, set state and return true
                allstates[""] = allstates[""] or {show = true}
                allstates[""].show = true
                allstates[""].changed = true
                return true
            end
            return false
        end
        
        -- Check nameplates (max 20)
        for i = 1, 20 do
            if checkUnit("nameplate" .. i) then return true end
        end
        
        -- Check direct targets
        if checkUnit("target") then return true end
        if checkUnit("pettarget") then return true end
        
        -- Check party members and their targets/pets
        for i = 1, 4 do
            if checkUnit("party" .. i .. "target") then return true end
            if checkUnit("partypet" .. i .. "target") then return true end
        end
        
        -- No triangle found, set state to false
        allstates[""] = allstates[""] or {show = false}
        allstates[""].show = false
        allstates[""].changed = true
    end
    
    return true
end]],
                spellIds = {},
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
