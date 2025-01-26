
local ADDON_NAME, ns = ...
ns.auras = ns.auras or {}
ns.auras["serpent_sting_debuff_square"] = {
    id = "Serpent Sting Debuff Square",
    uid = "dgV8m9E99s9",
    internalVersion = 78,
    regionType = "aurabar",
    anchorPoint = "CENTER",
    selfPoint = "CENTER",
    xOffset = 120,
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
                debuffType = "HARMFUL",
                type = "custom",
                unit = "target",
                subeventSuffix = "_CAST_START",
                subeventPrefix = "SPELL",
                event = "Combat Log",
                names = {},
                custom_type = "stateupdate",
                spellIds = {},
                custom = [[function(allstates, event, ...)
    -- Throttle checks
    if not aura_env.last or GetTime() - aura_env.last > 0.2 then
        aura_env.last = GetTime()
        
        -- Check all nameplates
        for i = 1, 40 do
            local unit = "nameplate"..i
            
            -- Check if unit exists and is attackable
            if UnitExists(unit) and UnitCanAttack("player", unit) then
                -- Check if unit has cross mark (7)
                local mark = GetRaidTargetIndex(unit)
                
                if mark == 6 then
                    -- Check if unit is CC'd
                    local isCC = false
                    local i = 1
                    while true do
                        local name, a, b, c, d, e, f, unitCaster = UnitDebuff(unit, i)
                        if not name then break end
                        
                        -- List of CC effects to check for
                        if name == "Serpent Sting" and unitCaster == "player" then
                            isCC = true
                            break
                        end
                        i = i + 1
                    end
                    
                    -- If not CC'd, show aura
                    if not isCC then
                        allstates[""] = {
                            show = true,
                            changed = true,
                            unit = unit
                        }
                        return true
                    end
                end
            end
        end
        
        -- No valid target found, hide aura
        allstates[""] = {
            show = false,
            changed = true
        }
        return true
    end
end]],
                check = "update",
                auranames = {
                    "Serpent Sting",
                },
                unitExists = false,
                useRem = false,
                matchesShowOn = "showOnActive",
                useName = true,
                ownOnly = true,
            },
            untrigger = {},
        },
    },
    conditions = {},
    load = {
        talent = {
            multi = {},
        },
        class = {
            multi = {
                HUNTER = true,
            },
            single = "HUNTER",
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
