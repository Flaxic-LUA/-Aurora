DRAGONFLIGHT()

DF:NewDefaults('gui-extrapanels', {
    version = {value = '1.0'},
    enabled = {value = true},
})

DF:NewModule('gui-extrapanels', 2, function()
    local setup = DF.setups.guiBase
    if not setup then return end

    local homePanel = setup.panels['home']
    homePanel:SetHeight(450)
    local homeText = DF.ui.Font(homePanel, 20, info.addonNameColor)
    homeText:SetPoint('CENTER', setup.mainframe, 'CENTER', 0, 100)

    local timeText = DF.ui.Font(homePanel, 25, '')
    timeText:SetPoint('TOP', homeText, 'BOTTOM', 0, -20)
    local dateText = DF.ui.Font(homePanel, 12, '')
    dateText:SetPoint('TOP', timeText, 'BOTTOM', 0, -10)

    local githubLabel = DF.ui.Font(homePanel, 9, 'Official Github:', {0.8, 0.8, 0.8})
    githubLabel:SetPoint('TOP', dateText, 'BOTTOM', 0, -55)
    local githubText = DF.ui.Font(homePanel, 10, info.github, {1, 1, 1})
    githubText:SetPoint('TOP', githubLabel, 'BOTTOM', 0, -6)

    DF.timers.every(1, function()
        timeText:SetText(DF.date.currentTimeWithSeconds)
        dateText:SetText(DF.date.currentDate)
    end)

    local infoPanel = setup.panels['info']
    infoPanel:SetHeight(450)

    local techFrame = CreateFrame('Frame', nil, infoPanel)
    techFrame:SetWidth(320)
    techFrame:SetHeight(250)
    techFrame:SetPoint('TOPLEFT', infoPanel, 'TOPLEFT', 10, -10)

    local techHeader = DF.ui.Font(techFrame, 12, 'System Information', {1, 0.82, 0})
    techHeader:SetPoint('TOPLEFT', techFrame, 'TOPLEFT', 10, -10)
    techHeader:SetJustifyH('LEFT')

    local resolution = GetCVar('gxResolution') or 'Unknown'
    local build, _, _, tocVersion = GetBuildInfo()
    local server = DF.others.server
    local dbversion = DF.others.dbversion

    local versionHeader = DF.ui.Font(techFrame, 10, 'Dragonflight:', {0.6, 0.6, 0.6})
    versionHeader:SetPoint('TOPLEFT', techFrame, 'TOPLEFT', 10, -35)
    versionHeader:SetJustifyH('LEFT')

    local currentLabel = DF.ui.Font(techFrame, 10, 'Version:')
    currentLabel:SetPoint('TOPLEFT', versionHeader, 'BOTTOMLEFT', 0, -5)
    currentLabel:SetJustifyH('LEFT')
    local currentValue = DF.ui.Font(techFrame, 10, '|cff80ff80' .. (info.version) .. '|r')
    currentValue:SetPoint('TOP', currentLabel, 'TOP', 0, 0)
    currentValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    currentValue:SetJustifyH('RIGHT')

    local currentPatchLabel = DF.ui.Font(techFrame, 10, 'Patchname:')
    currentPatchLabel:SetPoint('TOPLEFT', currentLabel, 'BOTTOMLEFT', 0, -3)
    currentPatchLabel:SetJustifyH('LEFT')
    local currentPatchValue = DF.ui.Font(techFrame, 10, info.patch)
    currentPatchValue:SetPoint('TOP', currentPatchLabel, 'TOP', 0, 0)
    currentPatchValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    currentPatchValue:SetJustifyH('RIGHT')

    local dbLabel = DF.ui.Font(techFrame, 10, 'DB Version:')
    dbLabel:SetPoint('TOPLEFT', currentPatchLabel, 'BOTTOMLEFT', 0, -3)
    dbLabel:SetJustifyH('LEFT')
    local dbValue = DF.ui.Font(techFrame, 10, '|cff80ff80' .. dbversion .. '|r')
    dbValue:SetPoint('TOP', dbLabel, 'TOP', 0, 0)
    dbValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    dbValue:SetJustifyH('RIGHT')

    local clientHeader = DF.ui.Font(techFrame, 10, 'Client:', {0.6, 0.6, 0.6})
    clientHeader:SetPoint('TOPLEFT', dbLabel, 'BOTTOMLEFT', 0, -10)
    clientHeader:SetJustifyH('LEFT')

    local serverLabel = DF.ui.Font(techFrame, 10, 'Server:')
    serverLabel:SetPoint('TOPLEFT', clientHeader, 'BOTTOMLEFT', 0, -5)
    serverLabel:SetJustifyH('LEFT')
    local serverValue = DF.ui.Font(techFrame, 10, server)
    serverValue:SetPoint('TOP', serverLabel, 'TOP', 0, 0)
    serverValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    serverValue:SetJustifyH('RIGHT')

    local versionLabel = DF.ui.Font(techFrame, 10, 'Version:')
    versionLabel:SetPoint('TOPLEFT', serverLabel, 'BOTTOMLEFT', 0, -3)
    versionLabel:SetJustifyH('LEFT')
    local versionValue = DF.ui.Font(techFrame, 10, '|cff80ff801|r.|cff80ff8012|r.|cff80ff801|r')
    versionValue:SetPoint('TOP', versionLabel, 'TOP', 0, 0)
    versionValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    versionValue:SetJustifyH('RIGHT')

    local buildLabel = DF.ui.Font(techFrame, 10, 'Build:')
    buildLabel:SetPoint('TOPLEFT', versionLabel, 'BOTTOMLEFT', 0, -3)
    buildLabel:SetJustifyH('LEFT')
    local buildValue = DF.ui.Font(techFrame, 10, '|cff80ff80' .. build .. '|r')
    buildValue:SetPoint('TOP', buildLabel, 'TOP', 0, 0)
    buildValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    buildValue:SetJustifyH('RIGHT')

    local displayHeader = DF.ui.Font(techFrame, 10, 'Display:', {0.6, 0.6, 0.6})
    displayHeader:SetPoint('TOPLEFT', buildLabel, 'BOTTOMLEFT', 0, -10)
    displayHeader:SetJustifyH('LEFT')

    local resolutionLabel = DF.ui.Font(techFrame, 10, 'Resolution:')
    resolutionLabel:SetPoint('TOPLEFT', displayHeader, 'BOTTOMLEFT', 0, -5)
    resolutionLabel:SetJustifyH('LEFT')
    local resolutionValue = DF.ui.Font(techFrame, 10, resolution)
    resolutionValue:SetPoint('TOP', resolutionLabel, 'TOP', 0, 0)
    resolutionValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    resolutionValue:SetJustifyH('RIGHT')

    local statsFrame = CreateFrame('Frame', nil, infoPanel)
    statsFrame:SetWidth(320)
    statsFrame:SetHeight(170)
    statsFrame:SetPoint('TOPRIGHT', infoPanel, 'TOPRIGHT', -10, -10)

    local statsHeader = DF.ui.Font(statsFrame, 12, 'Addon Information', {1, 0.82, 0})
    statsHeader:SetPoint('TOPLEFT', statsFrame, 'TOPLEFT', 10, -10)
    statsHeader:SetJustifyH('LEFT')

    local totalModules = 0
    local enabledModules = 0
    local disabledModules = 0
    for moduleName, moduleData in pairs(DF.profile) do
        if moduleData.version and moduleData.enabled ~= nil then
            totalModules = totalModules + 1
            if moduleData.enabled then
                enabledModules = enabledModules + 1
            else
                disabledModules = disabledModules + 1
            end
        end
    end

    local totalAddons = GetNumAddOns()
    local loadedAddons = 0
    local disabledAddons = 0
    for i = 1, totalAddons do
        if IsAddOnLoaded(i) then
            loadedAddons = loadedAddons + 1
        else
            disabledAddons = disabledAddons + 1
        end
    end

    local optionsCount = 0
    for module, defaults in pairs(DF.defaults) do
        for option, _ in pairs(defaults) do
            if option ~= 'version' and option ~= 'enabled' and option ~= 'gui' then
                optionsCount = optionsCount + 1
            end
        end
    end

    local modulesHeader = DF.ui.Font(statsFrame, 10, 'Dragonflight Modules:', {0.6, 0.6, 0.6})
    modulesHeader:SetPoint('TOPLEFT', statsFrame, 'TOPLEFT', 10, -35)
    modulesHeader:SetJustifyH('LEFT')

    local totalModulesLabel = DF.ui.Font(statsFrame, 10, 'Total modules:')
    totalModulesLabel:SetPoint('TOPLEFT', modulesHeader, 'BOTTOMLEFT', 0, -5)
    totalModulesLabel:SetJustifyH('LEFT')
    local totalModulesValue = DF.ui.Font(statsFrame, 10, '|cffffffff' .. totalModules .. '|r')
    totalModulesValue:SetPoint('TOP', totalModulesLabel, 'TOP', 0, 0)
    totalModulesValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    totalModulesValue:SetJustifyH('RIGHT')

    local totalOptionsLabel = DF.ui.Font(statsFrame, 10, 'Total options:')
    totalOptionsLabel:SetPoint('TOPLEFT', totalModulesLabel, 'BOTTOMLEFT', 0, -3)
    totalOptionsLabel:SetJustifyH('LEFT')
    local totalOptionsValue = DF.ui.Font(statsFrame, 10, '|cffffffff' .. optionsCount .. '|r')
    totalOptionsValue:SetPoint('TOP', totalOptionsLabel, 'TOP', 0, 0)
    totalOptionsValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    totalOptionsValue:SetJustifyH('RIGHT')

    local enabledLabel = DF.ui.Font(statsFrame, 10, 'Enabled:')
    enabledLabel:SetPoint('TOPLEFT', totalOptionsLabel, 'BOTTOMLEFT', 0, -10)
    enabledLabel:SetJustifyH('LEFT')
    local enabledValue = DF.ui.Font(statsFrame, 10, '|cff80ff80' .. enabledModules .. '|r')
    enabledValue:SetPoint('TOP', enabledLabel, 'TOP', 0, 0)
    enabledValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    enabledValue:SetJustifyH('RIGHT')

    local disabledByUserLabel = DF.ui.Font(statsFrame, 10, 'Disabled by user:')
    disabledByUserLabel:SetPoint('TOPLEFT', enabledLabel, 'BOTTOMLEFT', 0, -3)
    disabledByUserLabel:SetJustifyH('LEFT')
    local disabledByUserValue = DF.ui.Font(statsFrame, 10, '|cffff8080' .. disabledModules .. '|r')
    disabledByUserValue:SetPoint('TOP', disabledByUserLabel, 'TOP', 0, 0)
    disabledByUserValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    disabledByUserValue:SetJustifyH('RIGHT')

    local disabledBySystemLabel = DF.ui.Font(statsFrame, 10, 'Disabled by system:')
    disabledBySystemLabel:SetPoint('TOPLEFT', disabledByUserLabel, 'BOTTOMLEFT', 0, -3)
    disabledBySystemLabel:SetJustifyH('LEFT')
    local disabledBySystemValue = DF.ui.Font(statsFrame, 10, '|cffff8080' .. dependencies.skippedModules .. '|r')
    disabledBySystemValue:SetPoint('TOP', disabledBySystemLabel, 'TOP', 0, 0)
    disabledBySystemValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    disabledBySystemValue:SetJustifyH('RIGHT')

    local addonsHeader = DF.ui.Font(statsFrame, 10, 'WoW Addons:', {0.6, 0.6, 0.6})
    addonsHeader:SetPoint('TOPLEFT', disabledBySystemLabel, 'BOTTOMLEFT', 0, -10)
    addonsHeader:SetJustifyH('LEFT')

    local totalAddonsLabel = DF.ui.Font(statsFrame, 10, 'Total:')
    totalAddonsLabel:SetPoint('TOPLEFT', addonsHeader, 'BOTTOMLEFT', 0, -5)
    totalAddonsLabel:SetJustifyH('LEFT')
    local totalAddonsValue = DF.ui.Font(statsFrame, 10, '|cffffffff' .. totalAddons .. '|r')
    totalAddonsValue:SetPoint('TOP', totalAddonsLabel, 'TOP', 0, 0)
    totalAddonsValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    totalAddonsValue:SetJustifyH('RIGHT')

    local loadedLabel = DF.ui.Font(statsFrame, 10, 'Loaded:')
    loadedLabel:SetPoint('TOPLEFT', totalAddonsLabel, 'BOTTOMLEFT', 0, -3)
    loadedLabel:SetJustifyH('LEFT')
    local loadedValue = DF.ui.Font(statsFrame, 10, '|cff80ff80' .. loadedAddons .. '|r')
    loadedValue:SetPoint('TOP', loadedLabel, 'TOP', 0, 0)
    loadedValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    loadedValue:SetJustifyH('RIGHT')

    local disabledAddonsLabel = DF.ui.Font(statsFrame, 10, 'Disabled:')
    disabledAddonsLabel:SetPoint('TOPLEFT', loadedLabel, 'BOTTOMLEFT', 0, -3)
    disabledAddonsLabel:SetJustifyH('LEFT')
    local disabledAddonsValue = DF.ui.Font(statsFrame, 10, '|cffff8080' .. disabledAddons .. '|r')
    disabledAddonsValue:SetPoint('TOP', disabledAddonsLabel, 'TOP', 0, 0)
    disabledAddonsValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    disabledAddonsValue:SetJustifyH('RIGHT')

    local playerFrame = CreateFrame('Frame', nil, infoPanel)
    playerFrame:SetWidth(320)
    playerFrame:SetHeight(200)
    playerFrame:SetPoint('BOTTOMLEFT', infoPanel, 'BOTTOMLEFT', 10, 10)

    local playerHeader = DF.ui.Font(playerFrame, 12, 'Player Information', {1, 0.82, 0})
    playerHeader:SetPoint('TOPLEFT', playerFrame, 'TOPLEFT', 10, -10)
    playerHeader:SetJustifyH('LEFT')

    local playerName = UnitName('player')
    local playerLevel = UnitLevel('player')
    local _, playerClass = UnitClass('player')
    local playerRealm = GetRealmName()
    local factionGroup = UnitFactionGroup('player')

    local characterHeader = DF.ui.Font(playerFrame, 10, 'Character:', {0.6, 0.6, 0.6})
    characterHeader:SetPoint('TOPLEFT', playerFrame, 'TOPLEFT', 10, -35)
    characterHeader:SetJustifyH('LEFT')

    local nameLabel = DF.ui.Font(playerFrame, 10, 'Name:')
    nameLabel:SetPoint('TOPLEFT', characterHeader, 'BOTTOMLEFT', 0, -5)
    nameLabel:SetJustifyH('LEFT')
    local nameValue = DF.ui.Font(playerFrame, 10, playerName)
    nameValue:SetPoint('TOP', nameLabel, 'TOP', 0, 0)
    nameValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    nameValue:SetJustifyH('RIGHT')

    local realmLabel = DF.ui.Font(playerFrame, 10, 'Realm:')
    realmLabel:SetPoint('TOPLEFT', nameLabel, 'BOTTOMLEFT', 0, -3)
    realmLabel:SetJustifyH('LEFT')
    local realmValue = DF.ui.Font(playerFrame, 10, playerRealm)
    realmValue:SetPoint('TOP', realmLabel, 'TOP', 0, 0)
    realmValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    realmValue:SetJustifyH('RIGHT')

    local classLabel = DF.ui.Font(playerFrame, 10, 'Class:')
    classLabel:SetPoint('TOPLEFT', realmLabel, 'BOTTOMLEFT', 0, -3)
    classLabel:SetJustifyH('LEFT')
    local classColor = DF.tables.classcolors[playerClass]
    local formattedClass = string.sub(playerClass, 1, 1) .. string.lower(string.sub(playerClass, 2))
    local classValue = DF.ui.Font(playerFrame, 10, '|cff' .. string.format('%02x%02x%02x', classColor[1]*255, classColor[2]*255, classColor[3]*255) .. formattedClass .. '|r')
    classValue:SetPoint('TOP', classLabel, 'TOP', 0, 0)
    classValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    classValue:SetJustifyH('RIGHT')

    local levelLabel = DF.ui.Font(playerFrame, 10, 'Level:')
    levelLabel:SetPoint('TOPLEFT', classLabel, 'BOTTOMLEFT', 0, -3)
    levelLabel:SetJustifyH('LEFT')
    local levelValue = DF.ui.Font(playerFrame, 10, '|cff80ff80' .. playerLevel .. '|r')
    levelValue:SetPoint('TOP', levelLabel, 'TOP', 0, 0)
    levelValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    levelValue:SetJustifyH('RIGHT')

    local factionLabel = DF.ui.Font(playerFrame, 10, 'Faction:')
    factionLabel:SetPoint('TOPLEFT', levelLabel, 'BOTTOMLEFT', 0, -3)
    factionLabel:SetJustifyH('LEFT')
    local factionValue = DF.ui.Font(playerFrame, 10, factionGroup)
    factionValue:SetPoint('TOP', factionLabel, 'TOP', 0, 0)
    factionValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    factionValue:SetJustifyH('RIGHT')

    local playedHeader = DF.ui.Font(playerFrame, 10, 'Played Time:', {0.6, 0.6, 0.6})
    playedHeader:SetPoint('TOPLEFT', factionLabel, 'BOTTOMLEFT', 0, -10)
    playedHeader:SetJustifyH('LEFT')

    local totalPlayedLabel = DF.ui.Font(playerFrame, 10, 'Total:')
    totalPlayedLabel:SetPoint('TOPLEFT', playedHeader, 'BOTTOMLEFT', 0, -5)
    totalPlayedLabel:SetJustifyH('LEFT')
    local totalPlayedValue = DF.ui.Font(playerFrame, 10, 'Loading...')
    totalPlayedValue:SetPoint('TOP', totalPlayedLabel, 'TOP', 0, 0)
    totalPlayedValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    totalPlayedValue:SetJustifyH('RIGHT')

    local levelPlayedLabel = DF.ui.Font(playerFrame, 10, 'This Level:')
    levelPlayedLabel:SetPoint('TOPLEFT', totalPlayedLabel, 'BOTTOMLEFT', 0, -3)
    levelPlayedLabel:SetJustifyH('LEFT')
    local levelPlayedValue = DF.ui.Font(playerFrame, 10, 'Loading...')
    levelPlayedValue:SetPoint('TOP', levelPlayedLabel, 'TOP', 0, 0)
    levelPlayedValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    levelPlayedValue:SetJustifyH('RIGHT')

    local playedFrame = CreateFrame('Frame')
    playedFrame:RegisterEvent('TIME_PLAYED_MSG')
    playedFrame:SetScript('OnEvent', function()
        local totalTime = arg1 or 0
        local levelTime = arg2 or 0
        local totalHours = math.floor(totalTime / 3600)
        local totalMins = math.floor(math.mod(totalTime, 3600) / 60)
        local levelHours = math.floor(levelTime / 3600)
        local levelMins = math.floor(math.mod(levelTime, 3600) / 60)
        totalPlayedValue:SetText('|cff80ff80' .. totalHours .. '|rh |cff80ff80' .. totalMins .. '|rm')
        levelPlayedValue:SetText('|cff80ff80' .. levelHours .. '|rh |cff80ff80' .. levelMins .. '|rm')
        playedFrame:UnregisterEvent('TIME_PLAYED_MSG')
    end)
    RequestTimePlayed()

    local blacklistFrame = CreateFrame('Frame', nil, infoPanel)
    blacklistFrame:SetWidth(320)
    blacklistFrame:SetHeight(200)
    blacklistFrame:SetPoint('BOTTOMRIGHT', infoPanel, 'BOTTOMRIGHT', -10, 10)

    local blacklistHeader = DF.ui.Font(blacklistFrame, 12, 'Blacklisted Addons', {1, 0.82, 0})
    blacklistHeader:SetPoint('TOPLEFT', blacklistFrame, 'TOPLEFT', 10, -10)
    blacklistHeader:SetJustifyH('LEFT')

    local yPos = -35
    for _, addonName in pairs(DF.others.blacklist) do
        local addonLabel = DF.ui.Font(blacklistFrame, 10, addonName)
        addonLabel:SetPoint('TOPLEFT', blacklistFrame, 'TOPLEFT', 10, yPos)
        addonLabel:SetJustifyH('LEFT')

        local isActive = IsAddOnLoaded(addonName)
        local statusText = isActive and '|cffff8080Active|r' or '|cff808080Not Active|r'
        local addonStatus = DF.ui.Font(blacklistFrame, 10, statusText)
        addonStatus:SetPoint('TOP', addonLabel, 'TOP', 0, 0)
        addonStatus:SetPoint('RIGHT', blacklistFrame, 'RIGHT', -10, 0)
        addonStatus:SetJustifyH('RIGHT')

        yPos = yPos - 15
    end

    local modulesPanel = setup.panels['modules']
    modulesPanel:SetHeight(450)

    local modulesInfo = DF.ui.Font(modulesPanel, 10, 'Enable or disable modules. Changes require a reload.')
    modulesInfo:SetPoint('TOP', modulesPanel, 'TOP', -50, -30)

    local moduleHeaderName = DF.ui.Font(modulesPanel, 10, 'Module', {0.6, 0.6, 0.6})
    moduleHeaderName:SetPoint('TOPLEFT', modulesPanel, 'TOPLEFT', 40, -55)
    moduleHeaderName:SetJustifyH('LEFT')

    local moduleHeaderVersion = DF.ui.Font(modulesPanel, 10, 'Version', {0.6, 0.6, 0.6})
    moduleHeaderVersion:SetPoint('LEFT', moduleHeaderName, 'RIGHT', 120, 0)
    moduleHeaderVersion:SetJustifyH('LEFT')

    local moduleHeaderStatus = DF.ui.Font(modulesPanel, 10, 'State', {0.6, 0.6, 0.6})
    moduleHeaderStatus:SetPoint('LEFT', moduleHeaderVersion, 'RIGHT', 295, 0)
    moduleHeaderStatus:SetJustifyH('LEFT')

    local modulesScroll = DF.ui.Scrollframe(modulesPanel, 650, 350, 'DF_ModulesScroll')
    modulesScroll:SetPoint('TOP', modulesPanel, 'TOP', 0, -70)

    local moduleNames = {}
    local initialStates = {}
    for moduleName, moduleData in pairs(DF.profile) do
        if moduleData.version and moduleData.enabled ~= nil then
            local lowerName = string.lower(moduleName)
            if not (string.len(lowerName) >= 3 and string.sub(lowerName, 1, 3) == 'gui') then
                table.insert(moduleNames, moduleName)
                initialStates[moduleName] = moduleData.enabled
            end
        end
    end
    table.sort(moduleNames)

    local reloadBtn = DF.ui.Button(modulesPanel, 'Reload UI', 100, 25)
    reloadBtn:SetPoint('TOP', modulesScroll, 'BOTTOM', -50, -40)
    reloadBtn:SetScript('OnClick', function() ReloadUI() end)

    function setup:updateReloadButton()
        local hasChanges = false
        for modName, initialState in pairs(initialStates) do
            if DF.profile[modName] and DF.profile[modName].enabled ~= initialState then
                hasChanges = true
                break
            end
        end
        if hasChanges then
            reloadBtn.text:SetTextColor(1, 0.2, 0.2)
        else
            reloadBtn.text:SetTextColor(1, 1, 1)
        end
    end

    local yOffset = 0
    for _, moduleName in ipairs(moduleNames) do
        local moduleData = DF.profile[moduleName]
        local moduleFrame = CreateFrame('Frame', nil, modulesScroll.content)
        moduleFrame:SetWidth(530)
        moduleFrame:SetHeight(25)
        moduleFrame:SetPoint('TOPLEFT', modulesScroll.content, 'TOPLEFT', 10, -yOffset)

        local formattedName = string.upper(string.sub(moduleName, 1, 1)) .. string.sub(moduleName, 2)
        local nameText = moduleFrame:CreateFontString(nil, 'OVERLAY')
        nameText:SetFont('Fonts\\FRIZQT__.TTF', 11, 'OUTLINE')
        nameText:SetText(formattedName)
        nameText:SetPoint('LEFT', moduleFrame, 'LEFT', 15, 0)
        nameText:SetJustifyH('LEFT')

        local versionText = DF.ui.Font(moduleFrame, 10, 'v' .. moduleData.version, {0.7, 0.7, 0.7})
        versionText:SetPoint('LEFT', moduleFrame, 'LEFT', 180, 0)
        versionText:SetJustifyH('LEFT')

        local checkbox = DF.ui.Checkbox(moduleFrame, 'Enabled', 20, 20, 'RIGHT')
        checkbox:SetPoint('RIGHT', moduleFrame, 'RIGHT', 0, 0)
        checkbox:SetChecked(moduleData.enabled)
        checkbox.moduleName = moduleName
        checkbox.nameText = nameText
        checkbox:SetScript('OnClick', function()
            local isChecked = this:GetChecked() and true or false
            DF.profile[this.moduleName].enabled = isChecked
            if isChecked then
                this.nameText:SetTextColor(0.53, 0.81, 0.92)
                this.label:SetTextColor(0.9, 0.9, 0.9)
            else
                this.nameText:SetTextColor(0.5, 0.5, 0.5)
                this.label:SetTextColor(0.5, 0.5, 0.5)
            end
            setup.updateReloadButton()
        end)

        if moduleData.enabled then
            nameText:SetTextColor(0.53, 0.81, 0.92)
        else
            nameText:SetTextColor(0.5, 0.5, 0.5)
            checkbox.label:SetTextColor(0.5, 0.5, 0.5)
        end

        yOffset = yOffset + 30
    end
    modulesScroll.content:SetHeight(yOffset)
    modulesScroll.updateScrollBar()

    function setup:checkModuleChanges()
        for moduleName, initialState in pairs(initialStates) do
            if DF.profile[moduleName] and DF.profile[moduleName].enabled ~= initialState then
                return true
            end
        end
        return false
    end

    -- callbacks
    local helpers = {}
    local callbacks = {}

    DF:NewCallbacks('gui-extrapanels', callbacks)
end)
