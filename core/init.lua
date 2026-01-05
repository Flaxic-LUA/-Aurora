DRAGONFLIGHT()

local init = {
    eventGroups = {},
    pendingEvents = {},
    loadingBar = nil,
    loadingQueue = {}
}

DF.others.blacklist = {
    '-DragonflightReloaded', 'ShaguTweaks', 'ShaguTweaks-extras', 'ShaguTweaks-mods',
}

DF.others.blacklistFound = false

DF.others.dbversion = 1

function init:DetectServer()
    local buildInfo = GetBuildInfo()
    local realmName = GetRealmName()
    if buildInfo > '1.12' and buildInfo < '2.0' then
        if realmName == 'Nordanaar' or realmName == 'Ambershire' or realmName == "Tel'Abim" then
            return 'turtle'
        end
    end
    return 'vanilla'
end

function init:ApplyDefaults(profileName)
    -- create profile if first time, keep existing
    DF_Profiles.profiles[profileName] = DF_Profiles.profiles[profileName] or {}
    for module, defaults in pairs(DF.defaults) do
        -- create module table if new, preserve settings
        DF_Profiles.profiles[profileName][module] = DF_Profiles.profiles[profileName][module] or {}
        for option, data in pairs(defaults) do
            if DF_Profiles.profiles[profileName][module][option] == nil then
                DF_Profiles.profiles[profileName][module][option] = data.value
            end
        end
    end
    -- create profileMeta container if first time
    DF_Profiles.meta.profileMeta = DF_Profiles.meta.profileMeta or {}
    if not DF_Profiles.meta.profileMeta[profileName] then
        -- create metadata for auto assigned profiles to show data in gui
        DF_Profiles.meta.profileMeta[profileName] = {
            created = date('%Y-%m-%d %H:%M'),
            modified = date('%Y-%m-%d %H:%M'),
            description = ''
        }
    end
end

function init:CheckBlacklist()
    -- track which blacklisted addons are loaded
    DF.others.blacklistedAddonsFound = {}
    for _, addonName in pairs(DF.others.blacklist) do
        if IsAddOnLoaded(addonName) then
            table.insert(DF.others.blacklistedAddonsFound, addonName)
            DF.ui.StaticPopup_Show('Blacklisted addon detected: ' .. addonName .. '\n\nContinue loading Dragonflight?', 'Continue', function()
                init:SetupProfile()
                if not init:CheckModuleVersions() then
                    init:ExecModules(true)
                end
            end, 'Cancel', function() end, nil, nil, 140)
            return true
        end
    end
    return false
end

function init:CheckDBVersion()
    DF_Profiles.meta.dbversion = DF_Profiles.meta.dbversion or DF.others.dbversion
    if DF_Profiles.meta.dbversion ~= DF.others.dbversion then
        DF.ui.StaticPopup_Show('DB version mismatch.\n\nReset all settings?', 'Reset', function()
            _G.DF_Profiles = {}
            _G.DF_Profiles.meta = {}
            _G.DF_Profiles.meta.dbversion = DF.others.dbversion
            DF_Profiles.profiles = {}
            DF_Profiles.meta.characterProfiles = {}
            DF_Profiles.meta.autoAssigned = {}
            DF_Profiles.profiles['.defaults'] = {}
            init:ApplyDefaults('.defaults')
            init:SetupProfile()
            init:ExecModules(true)
        end, 'Cancel', function() end, nil, nil, 140)
        return true
    end
    return false
end

function init:SetupProfile()
    local charKey = UnitName('player') .. '-' .. GetRealmName()
    local profileName = DF_Profiles.meta.characterProfiles[charKey]
    if not profileName and not DF_Profiles.meta.autoAssigned[charKey] then
        profileName = charKey
        init:ApplyDefaults(profileName)
        DF_Profiles.meta.characterProfiles[charKey] = profileName
        DF_Profiles.meta.autoAssigned[charKey] = true
    end
    DF.profile = DF_Profiles.profiles[profileName]
    DF_Profiles.meta.activeProfile = profileName
    DF.others.currentProfile = profileName
end

function init:CheckModuleVersions()
    -- collect modules with version mismatches
    local mismatchModules = {}
    for module, defaults in pairs(DF.defaults) do
        if defaults.version then
            local expected = defaults.version.value
            if not DF.profile[module] or not DF.profile[module].version or DF.profile[module].version ~= expected then
                table.insert(mismatchModules, module)
            end
        end
    end
    if table.getn(mismatchModules) > 0 then
        local msg = 'Module version mismatch:\n'
        for _, mod in pairs(mismatchModules) do
            msg = msg .. '- ' .. mod .. '\n'
        end
        msg = msg .. '\nReset detected module(s)?'
        DF.ui.StaticPopup_Show(msg, 'Reset', function()
            for _, mod in pairs(mismatchModules) do
                DF.profile[mod] = {}
            end
            local charKey = UnitName('player') .. '-' .. GetRealmName()
            local profileName = DF_Profiles.meta.characterProfiles[charKey] or charKey
            init:ApplyDefaults(profileName)
            DF.profile = DF_Profiles.profiles[profileName]
            for name, callback in pairs(DF.callbacks) do
                local mod, opt = DF.lua.match(name, '(.*)%.(.*)')
                callback(DF.profile[mod][opt])
            end
            init:ExecModules(true)
        end, 'Cancel', function() end, nil, nil, 140)
        return true
    end
    return false
end

function init:ExecModules(forceImmediate)
    local sorted = {}
    for name, module in pairs(DF.modules) do
        if DF.profile[name].enabled then
            table.insert(sorted, {name=name, module=module})
        end
    end
    table.sort(sorted, function(a, b) return a.module.priority < b.module.priority end)

    if forceImmediate then
        local bar = DF.animations.CreateStatusBar(UIParent, 300, 20, {barAnim = false, pulse = false, cutout = false})
        bar:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
        bar:SetFillColor(0.2, 0.6, 1, 1)
        bar:SetBgColor(0.1, 0.1, 0.1, 0.8)
        bar:SetFrameStrata('TOOLTIP')
        bar.max = table.getn(sorted)
        bar:SetValue(0, true)
        bar.text = DF.ui.Font(bar, 12, 'Loading ' .. info.addonNameColor .. ' ...', {1, 1, 1}, 'CENTER')
        bar.text:SetPoint('CENTER', bar, 'CENTER', 0, 0)
        init.loadingBar = bar
        init.loadingQueue = sorted
        init.loadingIndex = 0
        init.loadingTotal = table.getn(sorted)
        init.loadingBar:SetScript('OnUpdate', function()
            init.loadingIndex = init.loadingIndex + 1
            if init.loadingIndex <= init.loadingTotal then
                local entry = init.loadingQueue[init.loadingIndex]
                entry.module.func()
                init.loadingBar:SetValue(init.loadingIndex, true)
            else
                init.loadingBar:SetScript('OnUpdate', nil)
                init.loadingBar:Hide()
                init.loadingBar = nil
                init:Finalize()
            end
        end)
        return
    end

    for _, entry in pairs(sorted) do
        local module = entry.module
        if module.event then
            -- create event group, multiple modules share events
            init.eventGroups[module.event] = init.eventGroups[module.event] or {}
            table.insert(init.eventGroups[module.event], {name=entry.name, func=module.func})
            init.pendingEvents[module.event] = true
        else
            module.func()
        end
    end

    for event, _ in pairs(init.eventGroups) do
        DF:RegisterEvent(event)
    end

    if not next(init.pendingEvents) then
        init:Finalize()
    end
end

function init:Finalize()
    DF:UnregisterAllEvents()
    DF:SetScript('OnEvent', nil)
    -- clear pending events
    init.pendingEvents = {}
end

function init:InitDF()
    if not DF.others.syncActive then return end

    DF.others.server = init:DetectServer()

    -- initialize saved variable structure if first time
    DF_Profiles.meta = DF_Profiles.meta or {}
    DF_Profiles.profiles = DF_Profiles.profiles or {}
    DF_Profiles.meta.characterProfiles = DF_Profiles.meta.characterProfiles or {}
    DF_Profiles.meta.autoAssigned = DF_Profiles.meta.autoAssigned or {}

    -- always create fresh defaults profile
    DF_Profiles.profiles['.defaults'] = {}
    init:ApplyDefaults('.defaults')

    if init:CheckBlacklist() then return end
    if init:CheckDBVersion() then return end
    init:SetupProfile()
    if init:CheckModuleVersions() then return end
    init:ExecModules(false)
end

-- public
function DF:NewDefaults(module, defaults)
    DF.defaults[module] = defaults
end

function DF:NewModule(module, priority, event, func)
    if func then
        DF.modules[module] = {priority=priority, event=event, func=func}
    else
        DF.modules[module] = {priority=priority, func=event}
    end
end

function DF:NewCallbacks(module, callbacks)
    for option, callback in pairs(callbacks) do
        DF.callbacks[module .. '.' .. option] = callback
        if DF.profile[module] and DF.profile[module][option] ~= nil then
            callback(DF.profile[module][option])
        end
    end
end

function DF:SetConfig(module, option, value)
    DF.profile[module][option] = value
    DF.callbacks[module .. '.' .. option](value)
end

-- updates/events
DF:RegisterEvent'VARIABLES_LOADED'
DF:SetScript('OnEvent', function()
    if event == 'VARIABLES_LOADED' then
        init:InitDF()
        print('loaded. Use [ /|cffff0000df help|r ] for usage info.')
        return
    end

    local modules = init.eventGroups[event]
    if modules then
        for _, module in pairs(modules) do
            module.func()
        end
        DF:UnregisterEvent(event)
        init.pendingEvents[event] = nil
        if not next(init.pendingEvents) then
            init:Finalize()
        end
    end
end)
