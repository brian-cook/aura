
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["target_aggro"] = {
    id = "Target Aggro",
    uid = "nDm(m3oP2SZ",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 16,
    yOffset = -20,
    width = 3,
    height = 3,
    frameStrata = 1,
    barColor = {
        1,
        0,
        0,
        1,
    },
    barColor2 = {
        1,
        0,
        0,
        1,
    },
    backgroundColor = {
        1,
        0,
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
                debuffType = "HELPFUL",
                subeventSuffix = "_CAST_START",
                event = "Conditions",
                unit = "target",
                names = {},
                spellIds = {},
                use_unit = true,
                subeventPrefix = "SPELL",
                use_genericShowOn = true,
                realSpellName = "Wrath",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                spellName = 5176,
                use_track = true,
                itemName = 0,
                use_itemName = true,
                custom = [[function(allstates)
    if not UnitAffectingCombat("player") then
        allstates[""] = allstates[""] or {show = false}
        allstates[""].show = false
        allstates[""].changed = true
        
        return true
    end
    
    local unit = "target"
    
    local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", unit)
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
                custom_type = "stateupdate",
                check = "update",
                customVariables = "{}",
                use_inverse = false,
                use_messageType = false,
                use_ismoving = true,
                use_sourceName = false,
                use_targetRequired = false,
                use_moveSpeed = false,
                use_spec = true,
                use_message = false,
                instance_size = {},
            },
            untrigger = {},
        },
    },
    conditions = {},
    load = {
        size = {
            multi = {},
        },
        spec = {
            multi = {},
        },
        class = {
            multi = {},
        },
        talent = {
            multi = {},
        },
        use_never = false,
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
