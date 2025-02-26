
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["mp5"] = {
    id = "MP5",
    uid = "Harm2njdCzn",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 216,
    yOffset = 96,
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
                type = "custom",
                subeventSuffix = "_CAST_START",
                customVariables = "{}",
                event = "Conditions",
                unit = "target",
                custom_type = "status",
                use_unit = true,
                custom = [[function(allstates, event)
    -- Guard against OPTIONS string during setup
    if type(allstates) == "string" then
        return true
    end
    
    -- Get current states
    local currentMana = UnitPower("player", 0)
    local maxMana = UnitPowerMax("player", 0)
    local manaPercent = (currentMana / maxMana) * 100
    local isInCombat = UnitAffectingCombat("player")
    
    -- Track if we're waiting for regen
    aura_env.waitingForRegen = aura_env.waitingForRegen or false
    
    -- Initialize state
    allstates[""] = allstates[""] or {
        show = true,
        changed = true
    }
    
    -- Simple logic:
    -- 1. Show by default
    -- 2. Hide in combat below 50% and start waiting
    -- 3. Keep hidden until 100% while waiting
    -- 4. Reset to show when leaving combat
    
    if isInCombat then
        if manaPercent <= 50 then
            -- Below threshold in combat - hide and wait
            aura_env.waitingForRegen = true
            allstates[""].show = false
        elseif aura_env.waitingForRegen then
            -- Still waiting - only show at 100%
            allstates[""].show = (manaPercent >= 100)
            if manaPercent >= 100 then
                aura_env.waitingForRegen = false
            end
        end
    else
        -- Out of combat - reset and show
        aura_env.waitingForRegen = false
        allstates[""].show = true
    end
    
    allstates[""].changed = true
    return true
end]],
                spellIds = {},
                check = "update",
                names = {},
                subeventPrefix = "SPELL",
                debuffType = "HELPFUL",
                spellName = 5176,
                use_genericShowOn = true,
                realSpellName = "Wrath",
                use_spellName = true,
                genericShowOn = "showOnCooldown",
                use_track = true,
                itemName = 0,
                use_itemName = true,
                use_inverse = false,
                use_messageType = false,
                use_message = false,
                use_ismoving = true,
                use_spec = true,
                instance_size = {},
                use_sourceName = false,
                use_targetRequired = false,
                use_moveSpeed = false,
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
