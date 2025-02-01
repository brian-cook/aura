
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["scanner_test_no_load"] = {
    id = "Scanner Test No Load",
    uid = "udV)olhWRPM",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 152,
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
                subeventPrefix = "SPELL",
                unevent = "auto",
                names = {},
                duration = "1",
                event = "Health",
                unit = "player",
                custom_type = "stateupdate",
                custom = [[function(allstates, event, ...)
    -- Debug Tools
    local DebugTools = {
        enabled = false,
        log = function(self, ...)
            if not self.enabled then return end
            print(string.format("[Scanner Pet] %s", string.format(...)))
        end
    }
    
    -- Initialize state variables
    aura_env.states = aura_env.states or {
        marks = {},          -- Current mark assignments
        aggroUnits = {},     -- Units with player/group aggro
        previousMarks = {},  -- Stored marks for restoration
        castingUnits = {},   -- Currently casting units
        seenTargets = {},    -- Target history for skull marking
        lastUpdate = 0,      -- Throttle timer
        currentUnits = {}    -- Currently visible units
    }
    
    -- Constants
    local MARKS = {
        SKULL = 8,
        DIAMOND = 3,
        TRIANGLE = 4
    }
    
    -- Helper Functions
    local function validateUnit(unit)
        if not unit then return false end
        if not UnitExists(unit) then return false end
        if not UnitIsVisible(unit) then return false end
        if UnitIsDeadOrGhost(unit) then return false end
        return true
    end
    
    local function hasPlayerAggro(unit)
        if not validateUnit(unit) then return false end
        
        local targetUnit = unit.."target"
        if not UnitExists(targetUnit) then return false end
        
        return UnitIsUnit(targetUnit, "player")
    end
    
    local function checkGroupAggro(unit)
        if not IsInGroup() then
            return hasPlayerAggro(unit)
        end
        
        -- Check all group members
        local numMembers = GetNumGroupMembers()
        for i = 1, numMembers do
            local groupUnit = IsInRaid() and "raid"..i or "party"..i
            if UnitExists(groupUnit) and UnitIsUnit(unit.."target", groupUnit) then
                return true
            end
        end
        return false
    end
    
    local function checkPetAggro(unit)
        -- Check player's pet
        if UnitExists("pet") and UnitIsUnit(unit.."target", "pet") then
            return true
        end
        
        -- Check group pets if in group
        if IsInGroup() then
            local numMembers = GetNumGroupMembers()
            for i = 1, numMembers do
                local petUnit = (IsInRaid() and "raidpet" or "partypet")..i
                if UnitExists(petUnit) and UnitIsUnit(unit.."target", petUnit) then
                    return true
                end
            end
        end
        return false
    end
    
    local function setMarkWithVerification(unit, mark)
        if not validateUnit(unit) then return false end
        
        local currentMark = GetRaidTargetIndex(unit)
        if currentMark == mark then return true end
        
        SetRaidTarget(unit, mark)
        -- Verify mark was set
        local newMark = GetRaidTargetIndex(unit)
        DebugTools:log("Mark set: %s -> %s (Verified: %s)", 
            tostring(currentMark), tostring(mark), tostring(newMark == mark))
        return newMark == mark
    end
    
    local function restoreMarkWithVerification(guid, unit)
        if not guid or not unit then return false end
        
        local previousMark = aura_env.states.previousMarks[guid]
        if not previousMark then return false end
        
        local success = setMarkWithVerification(unit, previousMark)
        if success then
            aura_env.states.previousMarks[guid] = nil
        end
        return success
    end
    
    -- Throttle updates
    if GetTime() - aura_env.states.lastUpdate < 0.2 then
        return false
    end
    aura_env.states.lastUpdate = GetTime()
    
    -- Clear current units for this scan
    wipe(aura_env.states.currentUnits)
    
    -- Main scanning logic
    for i = 1, 40 do
        local unit = "nameplate"..i
        if validateUnit(unit) then
            local guid = UnitGUID(unit)
            if guid then
                aura_env.states.currentUnits[guid] = unit
                
                -- Handle target-based skull marking
                if UnitIsUnit(unit, "target") then
                    if not aura_env.states.seenTargets[guid] then
                        aura_env.states.seenTargets[guid] = GetTime()
                    elseif not aura_env.states.marks.skull then
                        aura_env.states.marks.skull = guid
                        setMarkWithVerification(unit, MARKS.SKULL)
                    end
                end
                
                -- Handle casting units (diamond mark)
                local name, _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
                if name and not notInterruptible and guid ~= aura_env.states.marks.skull then
                    if not aura_env.states.castingUnits[guid] then
                        aura_env.states.previousMarks[guid] = GetRaidTargetIndex(unit)
                        setMarkWithVerification(unit, MARKS.DIAMOND)
                        aura_env.states.castingUnits[guid] = true
                    end
                elseif aura_env.states.castingUnits[guid] then
                    restoreMarkWithVerification(guid, unit)
                    aura_env.states.castingUnits[guid] = nil
                end
                
                -- Handle aggro-based triangle marking
                local hasGroupAggro = checkGroupAggro(unit)
                local hasPetAggro = checkPetAggro(unit)
                
                if hasGroupAggro and not hasPetAggro and 
                guid ~= aura_env.states.marks.skull and 
                not aura_env.states.castingUnits[guid] then
                    if not aura_env.states.aggroUnits[guid] then
                        aura_env.states.previousMarks[guid] = GetRaidTargetIndex(unit)
                        setMarkWithVerification(unit, MARKS.TRIANGLE)
                        aura_env.states.aggroUnits[guid] = true
                    end
                elseif aura_env.states.aggroUnits[guid] then
                    restoreMarkWithVerification(guid, unit)
                    aura_env.states.aggroUnits[guid] = nil
                end
                
                -- Update WeakAura states
                allstates[guid] = allstates[guid] or {
                    show = true,
                    changed = true,
                    unit = unit,
                    mark = GetRaidTargetIndex(unit),
                    hasAggro = aura_env.states.aggroUnits[guid],
                    isCasting = aura_env.states.castingUnits[guid]
                }
            end
        end
    end
    
    -- Cleanup non-existent units
    for guid in pairs(allstates) do
        if not aura_env.states.currentUnits[guid] then
            allstates[guid].show = false
            allstates[guid].changed = true
        end
    end
    
    -- Combat end cleanup
    if event == "PLAYER_REGEN_ENABLED" then
        wipe(aura_env.states.marks)
        wipe(aura_env.states.aggroUnits)
        wipe(aura_env.states.previousMarks)
        wipe(aura_env.states.castingUnits)
        wipe(aura_env.states.seenTargets)
        DebugTools:log("Combat ended - states cleared")
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
                use_absorbMode = true,
                customStacks = [[function() return aura_env.count end]],
                events = [[PLAYER_TARGET_CHANGED
UNIT_TARGET
COMBAT_LOG_EVENT_UNFILTERED
PLAYER_REGEN_ENABLED
NAME_PLATE_UNIT_ADDED
NAME_PLATE_UNIT_REMOVED
GROUP_ROSTER_UPDATE
UNIT_PET]],
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
        size = {
            multi = {},
        },
        spec = {
            multi = {},
        },
        zoneIds = "",
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
