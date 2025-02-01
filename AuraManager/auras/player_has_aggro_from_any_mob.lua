
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["player_has_aggro_from_any_mob"] = {
    id = "Player has Aggro from Any Mob",
    uid = "9KEif8B2Wal",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 208,
    yOffset = 88,
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
                names = {},
                event = "Conditions",
                unit = "target",
                custom_type = "stateupdate",
                custom = [[function(allstates)
    if not aura_env.last or GetTime() - aura_env.last > 0.5 then
        aura_env.last = GetTime()
        
        local hasAggro = false
        
        -- Check all units in combat with player via nameplates
        for i = 1, 40 do
            local unitID = "nameplate" .. i
            if UnitExists(unitID) and UnitCanAttack("player", unitID) then
                local isTanking, status = UnitDetailedThreatSituation("player", unitID)
                if isTanking then
                    hasAggro = true
                    break
                end
            end
        end
        
        allstates[""] = allstates[""] or {show = false}
        allstates[""].show = hasAggro
        allstates[""].changed = true
        return true
    end
end]],
                spellIds = {},
                use_unit = true,
                check = "update",
                customVariables = "{}",
                subeventSuffix = "_CAST_START",
                use_inverse = false,
                realSpellName = "Wrath",
                use_spellName = true,
                use_genericShowOn = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                spellName = 5176,
                itemName = 0,
                use_itemName = true,
                use_messageType = false,
                use_ismoving = true,
                instance_size = {},
                use_moveSpeed = false,
                use_targetRequired = false,
                use_message = false,
                use_sourceName = false,
                use_spec = true,
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
        size = {
            multi = {},
        },
        spec = {
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
