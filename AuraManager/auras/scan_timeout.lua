
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["scan_timeout"] = {
    id = "Scan Timeout",
    uid = "w(vA4)2g1PK",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 208,
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
                debuffType = "HELPFUL",
                type = "custom",
                unit = "player",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                event = "Chat Message",
                names = {},
                custom_type = "stateupdate",
                spellIds = {},
                custom = [[function(allstates)
    -- Throttle the check for perf
    if not aura_env.last or GetTime() - aura_env.last > 0.1 then
        -- Set the last time
        aura_env.last = GetTime()
        local scanStart = aura_env.scanStart or 0
        local scanningGUID = GetCVar("WeakAurasScannerToggle")
        
        if scanningGUID ~= "NO_TARGET" and scanStart == 0 then
            print("setting scan start")
            aura_env.scanStart = GetTime()
        elseif scanningGUID ~= "NO_TARGET" and scanStart ~= 0 then
            if (GetTime() - scanStart) > 0.5 then
                print("turning off")
                print(scanningGUID)
                
                aura_env.scanStart = 0
                SetCVar("WeakAurasScannerToggle", "NO_TARGET")
            end
        end
        
        return true
    end
    return false
end]],
                use_unit = true,
                check = "update",
                custom_hide = "timed",
                events = "CVAR_UPDATE",
            },
            untrigger = {
                custom = "",
            },
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
        size = {
            multi = {},
        },
        spec = {
            multi = {},
        },
        zoneIds = "",
        role = {
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
