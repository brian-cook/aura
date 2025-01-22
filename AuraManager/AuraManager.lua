local ADDON_NAME, ns = ...
local WEAKAURAS_VERSION = 78  -- Match WeakAuras internal version

-- Create a frame to handle events
local frame = CreateFrame("Frame")
local isWeakAurasLoaded = false
local pendingExport = false
local pendingDelete = false

-- Enhanced WeakAuras readiness check
local function IsWeakAurasReady()
    return WeakAuras and WeakAuras.Add and WeakAuras.IsLoginFinished() and true or false
end

-- Version compatibility check
local function IsVersionCompatible()
    if not WeakAuras.InternalVersion then return false end
    local version = WeakAuras.InternalVersion()
    if version ~= WEAKAURAS_VERSION then
        print(string.format("ERROR: Version mismatch. Expected %d, got %d", 
            WEAKAURAS_VERSION, version))
        return false
    end
    return true
end

-- Function to load an aura definition from a file
local function LoadAuraDefinition(filename)
    local auraDefinition = ns.auras[filename]
    if not auraDefinition then
        print("ERROR: Failed to load aura definition from " .. filename)
        return nil
    end
    
    -- Ensure basic data structure
    auraDefinition.load = auraDefinition.load or {}
    auraDefinition.load.class = auraDefinition.load.class or { multi = {} }
    auraDefinition.load.spec = auraDefinition.load.spec or { multi = {} }
    
    -- Add any missing required fields
    auraDefinition.parent = nil  -- Ensure no parent reference
    auraDefinition.authorOptions = auraDefinition.authorOptions or {}
    auraDefinition.information = auraDefinition.information or {}
    
    return auraDefinition
end

-- Helper function to delete existing auras
local function DeleteExistingAuras()
    local stats = {
        deleted = 0,
        notFound = 0,
        errors = 0
    }
    
    for _, filename in ipairs(ns.aura_list) do
        local aura = LoadAuraDefinition(filename)
        if aura and aura.id then
            local existingAura = WeakAuras.GetData(aura.id)
            if existingAura then
                WeakAuras.Delete(existingAura)
                stats.deleted = stats.deleted + 1
            else
                stats.notFound = stats.notFound + 1
            end
        else
            stats.errors = stats.errors + 1
        end
    end
    
    return stats
end

-- Function to export our auras to WeakAuras
local function ExportToWeakAuras()
    -- Check WeakAuras readiness
    if not IsWeakAurasReady() then
        print("ERROR: WeakAuras is not fully loaded yet. Please try again in a moment.")
        return
    end
    
    -- Check version compatibility
    if not IsVersionCompatible() then
        return
    end
    
    -- Handle combat lockdown
    if InCombatLockdown() then
        print("Export queued for after combat")
        pendingExport = true
        frame:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
    
    -- Verify ns.aura_list exists
    if not ns.aura_list then
        print("ERROR: No auras found in ns.aura_list!")
        return
    end
    
    -- Delete existing auras first
    local deleteStats = DeleteExistingAuras()
    
    -- Setup tracking for export
    local stats = {
        total = #ns.aura_list,
        success = 0,
        errors = 0,
        deleted = deleteStats.deleted
    }
    
    -- Load and export each aura
    for _, filename in ipairs(ns.aura_list) do
        local aura = LoadAuraDefinition(filename)
        if aura then
            local success, err = pcall(function()
                -- Add the new aura
                WeakAuras.Add(aura)
                stats.success = stats.success + 1
            end)
            
            if not success then
                stats.errors = stats.errors + 1
                print(string.format("ERROR exporting '%s': %s", aura.id, tostring(err)))
            end
        else
            stats.errors = stats.errors + 1
        end
    end
    
    -- Update WeakAuras display
    if WeakAuras.ScanForLoads then
        WeakAuras.ScanForLoads()
    end
    
    -- Print summary
    print(string.format("\nExport Summary:"))
    print(string.format("Total auras: %d", stats.total))
    if stats.deleted > 0 then
        print(string.format("Deleted: %d", stats.deleted))
    end
    print(string.format("Exported: %d", stats.success))
    if stats.errors > 0 then
        print(string.format("Errors: %d", stats.errors))
    end
end

-- Function to delete our auras from WeakAuras
local function DeleteFromWeakAuras()
    -- Check WeakAuras readiness
    if not IsWeakAurasReady() then
        print("ERROR: WeakAuras is not fully loaded yet. Please try again in a moment.")
        return
    end
    
    -- Handle combat lockdown
    if InCombatLockdown() then
        print("Delete queued for after combat")
        pendingDelete = true
        frame:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
    
    -- Verify ns.aura_list exists
    if not ns.aura_list then
        print("ERROR: No auras found in ns.aura_list!")
        return
    end
    
    -- Delete existing auras first
    local deleteStats = DeleteExistingAuras()
    
    -- Setup tracking for delete
    local stats = {
        total = #ns.aura_list,
        deleted = deleteStats.deleted,
        notFound = deleteStats.notFound,
        errors = deleteStats.errors
    }
    
    -- Update WeakAuras display
    if WeakAuras.ScanForLoads then
        WeakAuras.ScanForLoads()
    end
    
    -- Print summary
    print(string.format("\nDelete Summary:"))
    print(string.format("Total auras: %d", stats.total))
    print(string.format("Deleted: %d", stats.deleted))
    if stats.notFound > 0 then
        print(string.format("Not found: %d", stats.notFound))
    end
    if stats.errors > 0 then
        print(string.format("Errors: %d", stats.errors))
    end
end

-- Event handling
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        C_Timer.After(2, function()
            isWeakAurasLoaded = IsWeakAurasReady()
        end)
    elseif event == "PLAYER_REGEN_ENABLED" and pendingExport then
        pendingExport = false
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        ExportToWeakAuras()
    elseif event == "PLAYER_REGEN_ENABLED" and pendingDelete then
        pendingDelete = false
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        DeleteFromWeakAuras()
    end
end)

-- Register slash commands
SLASH_AURAMANAGER1 = "/am"
SLASH_AURAMANAGER2 = "/auramanager"
SlashCmdList["AURAMANAGER"] = function(msg)
    if msg == "export" then
        ExportToWeakAuras()
    elseif msg == "delete" then
        DeleteFromWeakAuras()
    else
        print("AuraManager commands:")
        print("  /am export - Export auras to WeakAuras")
        print("  /am delete - Delete all AuraManager auras from WeakAuras")
    end
end