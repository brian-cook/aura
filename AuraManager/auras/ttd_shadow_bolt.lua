
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["ttd_shadow_bolt"] = {
    id = "TTD Shadow Bolt",
    uid = "u(H7WJ3q4gA",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 212,
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
                custom_type = "event",
                custom = [[function(allstates, event, ...)
    -- Debug setup
    aura_env.debug = true
    local function debugPrint(...)
        if aura_env.debug then
            print(string.format("[Shadow Bolt Alert] %s", string.format(...)))
        end
    end
    
    -- Handle OPTIONS and STATUS events
    if event == "OPTIONS" or event == "STATUS" then
        return {
            [""] = {
                show = true,
                changed = true,
                progressType = "timed",
                autoHide = false,
                value = 0,
                total = 100,
                reason = "Options mode"
            }
        }
    end
    
    -- For all other events, ensure allstates is a table
    if type(allstates) ~= "table" then
        allstates = {}
    end
    
    -- Initialize state
    allstates[""] = allstates[""] or {
        show = false,
        changed = true,
        progressType = "timed",
        autoHide = false,
        value = 0,
        total = 100,
        reason = ""
    }
    
    if event == "WARLOCK_SPELL_UPDATE_SHADOW_BOLT" then
        local shouldCast, reason = ...
        if shouldCast ~= nil then
            debugPrint("Shadow Bolt update: shouldCast=%s, reason=%s", 
                tostring(shouldCast), reason or "nil")
            allstates[""].show = shouldCast
            allstates[""].changed = true
            allstates[""].reason = reason or ""
        end
        return true
    end
    
    return false
end]],
                spellIds = {},
                use_unit = true,
                check = "update",
                customVariables = "",
                subeventSuffix = "_CAST_START",
                custom_hide = "timed",
                customStacks = "",
                events = [[WARLOCK_SPELL_UPDATE_SHADOW_BOLT 
]],
                use_absorbMode = true,
            },
            untrigger = {
                custom = "",
            },
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
