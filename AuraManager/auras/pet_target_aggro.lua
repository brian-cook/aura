
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["pet_target_aggro"] = {
    id = "Pet Target Aggro",
    uid = "tnFNUBRKMS1",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 132,
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
                subeventPrefix = "SPELL",
                type = "custom",
                subeventSuffix = "_CAST_START",
                custom_type = "stateupdate",
                unit = "target",
                event = "Conditions",
                custom = [[function(allstates)
    if not UnitAffectingCombat("pet") then
        allstates[""] = allstates[""] or {show = false}
        allstates[""].show = false
        allstates[""].changed = true
        
        return true
    end
    
    local unit = "target"
    
    local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("pet", unit)
    local unitAffectingCombat = UnitAffectingCombat(unit)
    
    if isTanking or not unitAffectingCombat then
        allstates[""] = allstates[""] or {show = true}
        allstates[""].show = true
        allstates[""].changed = true
    else
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
                customVariables = "{}",
                spellName = 5176,
                use_genericShowOn = true,
                realSpellName = "Wrath",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_inverse = false,
                use_track = true,
                itemName = 0,
                use_itemName = true,
                use_messageType = false,
                use_message = false,
                use_ismoving = true,
                use_spec = true,
                use_sourceName = false,
                use_targetRequired = false,
                instance_size = {},
                use_moveSpeed = false,
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
            multi = {},
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
