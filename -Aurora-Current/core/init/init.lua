UNLOCKAURORA()

local init = {eventGroups = {}, pendingEvents = {}, loadingBar = nil, loadingQueue = {}}

AU.others.blacklist = {
    'DragonflightReloaded',
    '--Debugger',
}

AU.others.blacklistFound = false

AU.others.dbversion = 2

-- private
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
    AU_GlobalDB.profiles[profileName] = AU_GlobalDB.profiles[profileName] or {}
    for module, defaults in pairs(AU.defaults) do
        AU_GlobalDB.profiles[profileName][module] = AU_GlobalDB.profiles[profileName][module] or {}
        for option, data in pairs(defaults) do
            if AU_GlobalDB.profiles[profileName][module][option] == nil then
                AU_GlobalDB.profiles[profileName][module][option] = data.value
            end
        end
    end
    AU_GlobalDB.meta.profileMeta = AU_GlobalDB.meta.profileMeta or {}
    if not AU_GlobalDB.meta.profileMeta[profileName] then
        AU_GlobalDB.meta.profileMeta[profileName] = {
            created = date('%Y-%m-%d %H:%M'),
            modified = date('%Y-%m-%d %H:%M'),
            description = ''
        }
    end
end

function init:SetupProfile()
    local charName = UnitName('player')
    local realmName = GetRealmName()
    local charKey = charName .. '-' .. realmName
    local profileName = AU_GlobalDB.meta.characterProfiles[charKey]
    if not profileName and not AU_GlobalDB.meta.autoAssigned[charKey] then
        profileName = charKey
        init:ApplyDefaults(profileName)
        AU_GlobalDB.meta.characterProfiles[charKey] = profileName
        AU_GlobalDB.meta.autoAssigned[charKey] = true
    end
    AU.profile = AU_GlobalDB.profiles[profileName]
    AU_GlobalDB.meta.activeProfile = profileName
    AU.others.currentProfile = profileName
end

function init:CheckBlacklist()
    AU.others.blacklistedAddonsFound = {}
    for _, addonName in pairs(AU.others.blacklist) do
        if IsAddOnLoaded(addonName) then
            table.insert(AU.others.blacklistedAddonsFound, addonName)
            AU.ui.StaticPopup_Show(
                'Blacklisted addon detected: ' .. addonName .. '\n\nContinue loading Aurora?',
                'Continue',
                function()
                    init:SetupProfile()
                    if not init:CheckModuleVersions() then
                        init:ExecModules(true)
                    end
                end,
                'Cancel',
                function()
                end
            )
            return true
        end
    end
    return false
end

function init:CheckDBVersion()
    AU_GlobalDB.meta = AU_GlobalDB.meta or {}
    AU_GlobalDB.meta.dbversion = AU_GlobalDB.meta.dbversion or AU.others.dbversion

    if AU_GlobalDB.meta.dbversion ~= AU.others.dbversion then
        AU.ui.StaticPopup_Show(
            'DB version mismatch.\n\nReset all settings?',
            'Reset',
            function()
                _G.AU_GlobalDB = {}
                _G.AU_GlobalDB.meta = {}
                _G.AU_GlobalDB.meta.dbversion = AU.others.dbversion
                ReloadUI()
            end,
            'Cancel',
            function()
            end
        )
        return true
    end
    return false
end

function init:CheckModuleVersions()
    local mismatchModules = {}
    for module, defaults in pairs(AU.defaults) do
        if defaults.version then
            local expected = defaults.version.value
            if not AU.profile[module] or not AU.profile[module].version or AU.profile[module].version ~= expected then
                table.insert(mismatchModules, module)
            end
        end
    end

    if table.getn(mismatchModules) > 0 then
        local msg = 'Module version mismatch:\n'
        for _, mod in pairs(mismatchModules) do
            msg = msg .. '- ' .. mod .. '\n'
        end
        msg = msg .. '\nReset all?'

        AU.ui.StaticPopup_Show(msg,
            'Reset',
            function()
                for _, mod in pairs(mismatchModules) do
                    AU.profile[mod] = {}
                end
                local charName = UnitName('player')
                local realmName = GetRealmName()
                local charKey = charName .. '-' .. realmName
                local profileName = AU_GlobalDB.meta.characterProfiles[charKey] or charKey
                init:ApplyDefaults(profileName)
                AU.profile = AU_GlobalDB.profiles[profileName]
                for name, callback in pairs(AU.callbacks) do
                    local mod, opt = AU.lua.match(name, '(.*)%.(.*)')
                    callback(AU.profile[mod][opt])
                end
                init:ExecModules(true)
            end,
            'Cancel',
            function()
            end
        )
        return true
    end

    return false
end

function init:ExecModules(forceImmediate)
    local sorted = {}
    for name, module in pairs(AU.modules) do
        if AU.profile[name].enabled then
            table.insert(sorted, {name=name, module=module})
        end
    end
    table.sort(sorted, function(a, b) return a.module.priority < b.module.priority end)

    if forceImmediate then
        local bar = AU.animations.CreateStatusBar(UIParent, 300, 20, {barAnim = false, pulse = false, cutout = false})
        bar:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
        bar:SetFillColor(0.2, 0.6, 1, 1)
        bar:SetBgColor(0.1, 0.1, 0.1, 0.8)
        bar.max = table.getn(sorted)
        bar:SetValue(0, true)

        bar.text = AU.ui.Font(bar, 12, 'Loading ' .. info.addonNameColor .. ' ...', {1, 1, 1}, 'CENTER')
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
            init.eventGroups[module.event] = init.eventGroups[module.event] or {}
            table.insert(init.eventGroups[module.event], {name=entry.name, func=module.func})
            init.pendingEvents[module.event] = true
        else
            module.func()
        end
    end

    for event, _ in pairs(init.eventGroups) do
        AU:RegisterEvent(event)
    end

    if not next(init.pendingEvents) then
        init:Finalize()
    end
end

function init:Finalize()
    AU:UnregisterAllEvents()
    init.pendingEvents = {}
end

function init:InitAU()
    AU.others.server = init:DetectServer()

    AU_GlobalDB.meta = AU_GlobalDB.meta or {}
    AU_GlobalDB.profiles = AU_GlobalDB.profiles or {}
    AU_GlobalDB.meta.characterProfiles = AU_GlobalDB.meta.characterProfiles or {}
    AU_GlobalDB.meta.autoAssigned = AU_GlobalDB.meta.autoAssigned or {}

    if not AU_GlobalDB.profiles['.defaults'] then
        init:ApplyDefaults('.defaults')
    end

    if init:CheckBlacklist() then return end
    if init:CheckDBVersion() then return end
    init:SetupProfile()
    if init:CheckModuleVersions() then return end
    init:ExecModules(false)
end

-- public
function AU:NewDefaults(module, defaults)
    AU.defaults[module] = defaults
end

function AU:NewModule(module, priority, event, func)
    if func then
        AU.modules[module] = {priority=priority, event=event, func=func}
    else
        AU.modules[module] = {priority=priority, func=event}
    end
end

function AU:NewCallbacks(module, callbacks)
    for option, callback in pairs(callbacks) do
        AU.callbacks[module .. '.' .. option] = callback
        if AU.profile[module] and AU.profile[module][option] ~= nil then
            callback(AU.profile[module][option])
        end
    end
end

function AU:SetConfig(module, option, value)
    AU.profile[module][option] = value
    AU.callbacks[module .. '.' .. option](value)
end

-- updates/events
AU:RegisterEvent'VARIABLES_LOADED'
AU:SetScript('OnEvent', function()
    if event == 'VARIABLES_LOADED' then
        init:InitAU()
        print('Welcome to '.. info.addonNameColor .. ', use /au help for more.')
        return
    end

    local modules = init.eventGroups[event]
    if modules then
        for _, module in pairs(modules) do
            module.func()
        end
        AU:UnregisterEvent(event)
        init.pendingEvents[event] = nil
        if not next(init.pendingEvents) then
            init:Finalize()
        end
    end
end)
