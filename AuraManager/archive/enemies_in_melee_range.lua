
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["enemies_in_melee_range"] = {
    id = "Enemies in Melee Range",
    uid = "K7)gS1WI5Su",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 8,
    yOffset = -4,
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
                event = "Health",
                unit = "player",
                names = {},
                spellIds = {},
                use_unit = true,
                subeventPrefix = "SPELL",
                use_absorbMode = true,
                duration = "1",
                customStacks = [[function() return aura_env.count end]],
                unevent = "auto",
                custom = [[function(allstates)
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        
        local count = 0
        if aura_env.config.type == 2 then
            for i = 1, 40 do
                local unit = "nameplate"..i
                if UnitCanAttack("player", unit) 
                and (not aura_env.config.combat or UnitAffectingCombat(unit))
                and WeakAuras.CheckRange(unit, 8, "<=")  
                then
                    count = count + 1
                end
            end 
        else
            for unit in WA_IterateGroupMembers() do
                if not UnitIsUnit(unit, "player") 
                and not UnitIsDeadOrGhost(unit)
                and (not aura_env.config.combat or UnitAffectingCombat(unit))
                and WeakAuras.CheckRange(unit, 8, "<=")  
                then
                    count = count + 1
                end
            end
        end
        if count >= 2 then
            allstates[""] = allstates[""] or {show = true}
            allstates[""].stacks = count
            allstates[""].changed = true
            return true
        elseif allstates[""] then
            allstates[""].show = false
            allstates[""].changed = true
            return true
        end
    end
end]],
                custom_type = "stateupdate",
                check = "update",
                customVariables = [[{
  stacks = true,
}]],
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
