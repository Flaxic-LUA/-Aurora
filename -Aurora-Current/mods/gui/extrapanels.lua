UNLOCKAURORA()

AU:NewDefaults('gui-extrapanels', {
    version = {value = '1.0'},
    enabled = {value = true},
})

AU:NewModule('gui-extrapanels', 2, function()
    local setup = AU.setups.guiBase
    if not setup then return end

    local homePanel = setup.panels['home']
    homePanel:SetHeight(450)
    local homeText = AU.ui.Font(homePanel, 20, info.addonNameColor)
    homeText:SetPoint('CENTER', setup.mainframe, 'CENTER', 50, 100)

    local timeText = AU.ui.Font(homePanel, 25, '')
    timeText:SetPoint('TOP', homeText, 'BOTTOM', 0, -20)
    local dateText = AU.ui.Font(homePanel, 12, '')
    dateText:SetPoint('TOP', timeText, 'BOTTOM', 0, -10)

    AU.timers.every(1, function()
        timeText:SetText(AU.date.currentTime)
        dateText:SetText(AU.date.currentDate)
    end)

    local infoPanel = setup.panels['info']
    infoPanel:SetHeight(450)

    local techFrame = CreateFrame('Frame', nil, infoPanel)
    techFrame:SetWidth(320)
    techFrame:SetHeight(250)
    techFrame:SetPoint('TOPLEFT', infoPanel, 'TOPLEFT', 10, -10)

    local techHeader = AU.ui.Font(techFrame, 12, 'System Information', {1, 0.82, 0})
    techHeader:SetPoint('TOPLEFT', techFrame, 'TOPLEFT', 10, -10)
    techHeader:SetJustifyH('LEFT')

    local resolution = GetCVar('gxResolution') or 'Unknown'
    local build, _, _, tocVersion = GetBuildInfo()
    local server = AU.others.server or 'vanilla'
    local dbversion = AU.others.dbversion or 'N/A'

    local versionHeader = AU.ui.Font(techFrame, 10, 'Aurora:', {0.6, 0.6, 0.6})
    versionHeader:SetPoint('TOPLEFT', techFrame, 'TOPLEFT', 10, -35)
    versionHeader:SetJustifyH('LEFT')

    local biosLabel = AU.ui.Font(techFrame, 10, 'BIOS Version:')
    biosLabel:SetPoint('TOPLEFT', versionHeader, 'BOTTOMLEFT', 0, -5)
    biosLabel:SetJustifyH('LEFT')
    local biosValue = AU.ui.Font(techFrame, 10, '|cff80ff80' .. info.VersionBIOS .. '|r')
    biosValue:SetPoint('TOP', biosLabel, 'TOP', 0, 0)
    biosValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    biosValue:SetJustifyH('RIGHT')

    local currentLabel = AU.ui.Font(techFrame, 10, 'Current Version:')
    currentLabel:SetPoint('TOPLEFT', biosLabel, 'BOTTOMLEFT', 0, -3)
    currentLabel:SetJustifyH('LEFT')
    local currentValue = AU.ui.Font(techFrame, 10, '|cff80ff80' .. info.VersionCurrent .. '|r')
    currentValue:SetPoint('TOP', currentLabel, 'TOP', 0, 0)
    currentValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    currentValue:SetJustifyH('RIGHT')

    local currentPatchLabel = AU.ui.Font(techFrame, 10, 'Current Patch:')
    currentPatchLabel:SetPoint('TOPLEFT', currentLabel, 'BOTTOMLEFT', 0, -3)
    currentPatchLabel:SetJustifyH('LEFT')
    local currentPatchValue = AU.ui.Font(techFrame, 10, info.CurrentPatch)
    currentPatchValue:SetPoint('TOP', currentPatchLabel, 'TOP', 0, 0)
    currentPatchValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    currentPatchValue:SetJustifyH('RIGHT')

    local ltsLabel = AU.ui.Font(techFrame, 10, 'LTS Version:')
    ltsLabel:SetPoint('TOPLEFT', currentPatchLabel, 'BOTTOMLEFT', 0, -3)
    ltsLabel:SetJustifyH('LEFT')
    local ltsValue = AU.ui.Font(techFrame, 10, '|cff80ff80' .. info.VersionLTS .. '|r')
    ltsValue:SetPoint('TOP', ltsLabel, 'TOP', 0, 0)
    ltsValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    ltsValue:SetJustifyH('RIGHT')

    local ltsPatchLabel = AU.ui.Font(techFrame, 10, 'LTS Patch:')
    ltsPatchLabel:SetPoint('TOPLEFT', ltsLabel, 'BOTTOMLEFT', 0, -3)
    ltsPatchLabel:SetJustifyH('LEFT')
    local ltsPatchValue = AU.ui.Font(techFrame, 10, info.LTSPatch)
    ltsPatchValue:SetPoint('TOP', ltsPatchLabel, 'TOP', 0, 0)
    ltsPatchValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    ltsPatchValue:SetJustifyH('RIGHT')

    local dbLabel = AU.ui.Font(techFrame, 10, 'Loaded DB Version:')
    dbLabel:SetPoint('TOPLEFT', ltsPatchLabel, 'BOTTOMLEFT', 0, -3)
    dbLabel:SetJustifyH('LEFT')
    local dbValue = AU.ui.Font(techFrame, 10, '|cff80ff80' .. dbversion .. '|r')
    dbValue:SetPoint('TOP', dbLabel, 'TOP', 0, 0)
    dbValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    dbValue:SetJustifyH('RIGHT')

    local clientHeader = AU.ui.Font(techFrame, 10, 'Client:', {0.6, 0.6, 0.6})
    clientHeader:SetPoint('TOPLEFT', dbLabel, 'BOTTOMLEFT', 0, -10)
    clientHeader:SetJustifyH('LEFT')

    local serverLabel = AU.ui.Font(techFrame, 10, 'Server:')
    serverLabel:SetPoint('TOPLEFT', clientHeader, 'BOTTOMLEFT', 0, -5)
    serverLabel:SetJustifyH('LEFT')
    local serverValue = AU.ui.Font(techFrame, 10, server)
    serverValue:SetPoint('TOP', serverLabel, 'TOP', 0, 0)
    serverValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    serverValue:SetJustifyH('RIGHT')

    local versionLabel = AU.ui.Font(techFrame, 10, 'Version:')
    versionLabel:SetPoint('TOPLEFT', serverLabel, 'BOTTOMLEFT', 0, -3)
    versionLabel:SetJustifyH('LEFT')
    local versionValue = AU.ui.Font(techFrame, 10, '|cff80ff801|r.|cff80ff8012|r.|cff80ff801|r')
    versionValue:SetPoint('TOP', versionLabel, 'TOP', 0, 0)
    versionValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    versionValue:SetJustifyH('RIGHT')

    local buildLabel = AU.ui.Font(techFrame, 10, 'Build:')
    buildLabel:SetPoint('TOPLEFT', versionLabel, 'BOTTOMLEFT', 0, -3)
    buildLabel:SetJustifyH('LEFT')
    local buildValue = AU.ui.Font(techFrame, 10, '|cff80ff80' .. build .. '|r')
    buildValue:SetPoint('TOP', buildLabel, 'TOP', 0, 0)
    buildValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    buildValue:SetJustifyH('RIGHT')

    local displayHeader = AU.ui.Font(techFrame, 10, 'Display:', {0.6, 0.6, 0.6})
    displayHeader:SetPoint('TOPLEFT', buildLabel, 'BOTTOMLEFT', 0, -10)
    displayHeader:SetJustifyH('LEFT')

    local resolutionLabel = AU.ui.Font(techFrame, 10, 'Resolution:')
    resolutionLabel:SetPoint('TOPLEFT', displayHeader, 'BOTTOMLEFT', 0, -5)
    resolutionLabel:SetJustifyH('LEFT')
    local resolutionValue = AU.ui.Font(techFrame, 10, resolution)
    resolutionValue:SetPoint('TOP', resolutionLabel, 'TOP', 0, 0)
    resolutionValue:SetPoint('RIGHT', techFrame, 'RIGHT', -10, 0)
    resolutionValue:SetJustifyH('RIGHT')

    local statsFrame = CreateFrame('Frame', nil, infoPanel)
    statsFrame:SetWidth(320)
    statsFrame:SetHeight(170)
    statsFrame:SetPoint('TOPRIGHT', infoPanel, 'TOPRIGHT', -10, -10)

    local statsHeader = AU.ui.Font(statsFrame, 12, 'Addon Information', {1, 0.82, 0})
    statsHeader:SetPoint('TOPLEFT', statsFrame, 'TOPLEFT', 10, -10)
    statsHeader:SetJustifyH('LEFT')

    local totalModules = 0
    local enabledModules = 0
    local disabledModules = 0
    for moduleName, moduleData in pairs(AU.profile) do
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

    local optionsHeader = AU.ui.Font(statsFrame, 10, 'Aurora Options:', {0.6, 0.6, 0.6})
    optionsHeader:SetPoint('TOPLEFT', statsFrame, 'TOPLEFT', 10, -35)
    optionsHeader:SetJustifyH('LEFT')

    local optionsCount = 0
    for module, defaults in pairs(AU.defaults) do
        for option, _ in pairs(defaults) do
            if option ~= 'version' and option ~= 'enabled' and option ~= 'gui' then
                optionsCount = optionsCount + 1
            end
        end
    end

    local totalAmountLabel = AU.ui.Font(statsFrame, 10, 'Total amount:')
    totalAmountLabel:SetPoint('TOPLEFT', optionsHeader, 'BOTTOMLEFT', 0, -5)
    totalAmountLabel:SetJustifyH('LEFT')
    local totalAmountValue = AU.ui.Font(statsFrame, 10, '|cffffffff' .. optionsCount .. '|r')
    totalAmountValue:SetPoint('TOP', totalAmountLabel, 'TOP', 0, 0)
    totalAmountValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    totalAmountValue:SetJustifyH('RIGHT')

    local disabledOptionsLabel = AU.ui.Font(statsFrame, 10, 'Currently disabled:')
    disabledOptionsLabel:SetPoint('TOPLEFT', totalAmountLabel, 'BOTTOMLEFT', 0, -3)
    disabledOptionsLabel:SetJustifyH('LEFT')
    local disabledOptionsValue = AU.ui.Font(statsFrame, 10, 'N/A')
    disabledOptionsValue:SetPoint('TOP', disabledOptionsLabel, 'TOP', 0, 0)
    disabledOptionsValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    disabledOptionsValue:SetJustifyH('RIGHT')

    local modulesHeader = AU.ui.Font(statsFrame, 10, 'Aurora Modules:', {0.6, 0.6, 0.6})
    modulesHeader:SetPoint('TOPLEFT', disabledOptionsLabel, 'BOTTOMLEFT', 0, -10)
    modulesHeader:SetJustifyH('LEFT')

    local totalLabel = AU.ui.Font(statsFrame, 10, 'Total:')
    totalLabel:SetPoint('TOPLEFT', modulesHeader, 'BOTTOMLEFT', 0, -5)
    totalLabel:SetJustifyH('LEFT')
    local totalValue = AU.ui.Font(statsFrame, 10, '|cffffffff' .. totalModules .. '|r')
    totalValue:SetPoint('TOP', totalLabel, 'TOP', 0, 0)
    totalValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    totalValue:SetJustifyH('RIGHT')

    local enabledLabel = AU.ui.Font(statsFrame, 10, 'Enabled:')
    enabledLabel:SetPoint('TOPLEFT', totalLabel, 'BOTTOMLEFT', 0, -3)
    enabledLabel:SetJustifyH('LEFT')
    local enabledValue = AU.ui.Font(statsFrame, 10, '|cff80ff80' .. enabledModules .. '|r')
    enabledValue:SetPoint('TOP', enabledLabel, 'TOP', 0, 0)
    enabledValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    enabledValue:SetJustifyH('RIGHT')

    local disabledLabel = AU.ui.Font(statsFrame, 10, 'Disabled:')
    disabledLabel:SetPoint('TOPLEFT', enabledLabel, 'BOTTOMLEFT', 0, -3)
    disabledLabel:SetJustifyH('LEFT')
    local disabledValue = AU.ui.Font(statsFrame, 10, '|cffff8080' .. disabledModules .. '|r')
    disabledValue:SetPoint('TOP', disabledLabel, 'TOP', 0, 0)
    disabledValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    disabledValue:SetJustifyH('RIGHT')

    local addonsHeader = AU.ui.Font(statsFrame, 10, 'WoW Addons:', {0.6, 0.6, 0.6})
    addonsHeader:SetPoint('TOPLEFT', disabledLabel, 'BOTTOMLEFT', 0, -10)
    addonsHeader:SetJustifyH('LEFT')

    local totalAddonsLabel = AU.ui.Font(statsFrame, 10, 'Total:')
    totalAddonsLabel:SetPoint('TOPLEFT', addonsHeader, 'BOTTOMLEFT', 0, -5)
    totalAddonsLabel:SetJustifyH('LEFT')
    local totalAddonsValue = AU.ui.Font(statsFrame, 10, '|cffffffff' .. totalAddons .. '|r')
    totalAddonsValue:SetPoint('TOP', totalAddonsLabel, 'TOP', 0, 0)
    totalAddonsValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    totalAddonsValue:SetJustifyH('RIGHT')

    local loadedLabel = AU.ui.Font(statsFrame, 10, 'Loaded:')
    loadedLabel:SetPoint('TOPLEFT', totalAddonsLabel, 'BOTTOMLEFT', 0, -3)
    loadedLabel:SetJustifyH('LEFT')
    local loadedValue = AU.ui.Font(statsFrame, 10, '|cff80ff80' .. loadedAddons .. '|r')
    loadedValue:SetPoint('TOP', loadedLabel, 'TOP', 0, 0)
    loadedValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    loadedValue:SetJustifyH('RIGHT')

    local disabledAddonsLabel = AU.ui.Font(statsFrame, 10, 'Disabled:')
    disabledAddonsLabel:SetPoint('TOPLEFT', loadedLabel, 'BOTTOMLEFT', 0, -3)
    disabledAddonsLabel:SetJustifyH('LEFT')
    local disabledAddonsValue = AU.ui.Font(statsFrame, 10, '|cffff8080' .. disabledAddons .. '|r')
    disabledAddonsValue:SetPoint('TOP', disabledAddonsLabel, 'TOP', 0, 0)
    disabledAddonsValue:SetPoint('RIGHT', statsFrame, 'RIGHT', -10, 0)
    disabledAddonsValue:SetJustifyH('RIGHT')

    local playerFrame = CreateFrame('Frame', nil, infoPanel)
    playerFrame:SetWidth(320)
    playerFrame:SetHeight(200)
    playerFrame:SetPoint('BOTTOMLEFT', infoPanel, 'BOTTOMLEFT', 10, 10)

    local playerHeader = AU.ui.Font(playerFrame, 12, 'Player Information', {1, 0.82, 0})
    playerHeader:SetPoint('TOPLEFT', playerFrame, 'TOPLEFT', 10, -10)
    playerHeader:SetJustifyH('LEFT')

    local playerName = UnitName('player')
    local playerLevel = UnitLevel('player')
    local _, playerClass = UnitClass('player')
    local playerRealm = GetRealmName()
    local factionGroup = UnitFactionGroup('player')

    local characterHeader = AU.ui.Font(playerFrame, 10, 'Character:', {0.6, 0.6, 0.6})
    characterHeader:SetPoint('TOPLEFT', playerFrame, 'TOPLEFT', 10, -35)
    characterHeader:SetJustifyH('LEFT')

    local nameLabel = AU.ui.Font(playerFrame, 10, 'Name:')
    nameLabel:SetPoint('TOPLEFT', characterHeader, 'BOTTOMLEFT', 0, -5)
    nameLabel:SetJustifyH('LEFT')
    local nameValue = AU.ui.Font(playerFrame, 10, playerName)
    nameValue:SetPoint('TOP', nameLabel, 'TOP', 0, 0)
    nameValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    nameValue:SetJustifyH('RIGHT')

    local realmLabel = AU.ui.Font(playerFrame, 10, 'Realm:')
    realmLabel:SetPoint('TOPLEFT', nameLabel, 'BOTTOMLEFT', 0, -3)
    realmLabel:SetJustifyH('LEFT')
    local realmValue = AU.ui.Font(playerFrame, 10, playerRealm)
    realmValue:SetPoint('TOP', realmLabel, 'TOP', 0, 0)
    realmValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    realmValue:SetJustifyH('RIGHT')

    local classLabel = AU.ui.Font(playerFrame, 10, 'Class:')
    classLabel:SetPoint('TOPLEFT', realmLabel, 'BOTTOMLEFT', 0, -3)
    classLabel:SetJustifyH('LEFT')
    local classColor = AU.tables.classcolors[playerClass]
    local formattedClass = string.sub(playerClass, 1, 1) .. string.lower(string.sub(playerClass, 2))
    local classValue = AU.ui.Font(playerFrame, 10, '|cff' .. string.format('%02x%02x%02x', classColor[1]*255, classColor[2]*255, classColor[3]*255) .. formattedClass .. '|r')
    classValue:SetPoint('TOP', classLabel, 'TOP', 0, 0)
    classValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    classValue:SetJustifyH('RIGHT')

    local levelLabel = AU.ui.Font(playerFrame, 10, 'Level:')
    levelLabel:SetPoint('TOPLEFT', classLabel, 'BOTTOMLEFT', 0, -3)
    levelLabel:SetJustifyH('LEFT')
    local levelValue = AU.ui.Font(playerFrame, 10, '|cff80ff80' .. playerLevel .. '|r')
    levelValue:SetPoint('TOP', levelLabel, 'TOP', 0, 0)
    levelValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    levelValue:SetJustifyH('RIGHT')

    local factionLabel = AU.ui.Font(playerFrame, 10, 'Faction:')
    factionLabel:SetPoint('TOPLEFT', levelLabel, 'BOTTOMLEFT', 0, -3)
    factionLabel:SetJustifyH('LEFT')
    local factionValue = AU.ui.Font(playerFrame, 10, factionGroup)
    factionValue:SetPoint('TOP', factionLabel, 'TOP', 0, 0)
    factionValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    factionValue:SetJustifyH('RIGHT')

    local playedHeader = AU.ui.Font(playerFrame, 10, 'Played Time:', {0.6, 0.6, 0.6})
    playedHeader:SetPoint('TOPLEFT', factionLabel, 'BOTTOMLEFT', 0, -10)
    playedHeader:SetJustifyH('LEFT')

    local totalPlayedLabel = AU.ui.Font(playerFrame, 10, 'Total:')
    totalPlayedLabel:SetPoint('TOPLEFT', playedHeader, 'BOTTOMLEFT', 0, -5)
    totalPlayedLabel:SetJustifyH('LEFT')
    local totalPlayedValue = AU.ui.Font(playerFrame, 10, 'Loading...')
    totalPlayedValue:SetPoint('TOP', totalPlayedLabel, 'TOP', 0, 0)
    totalPlayedValue:SetPoint('RIGHT', playerFrame, 'RIGHT', -10, 0)
    totalPlayedValue:SetJustifyH('RIGHT')

    local levelPlayedLabel = AU.ui.Font(playerFrame, 10, 'This Level:')
    levelPlayedLabel:SetPoint('TOPLEFT', totalPlayedLabel, 'BOTTOMLEFT', 0, -3)
    levelPlayedLabel:SetJustifyH('LEFT')
    local levelPlayedValue = AU.ui.Font(playerFrame, 10, 'Loading...')
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

    local blacklistHeader = AU.ui.Font(blacklistFrame, 12, 'Blacklisted Addons', {1, 0.82, 0})
    blacklistHeader:SetPoint('TOPLEFT', blacklistFrame, 'TOPLEFT', 10, -10)
    blacklistHeader:SetJustifyH('LEFT')

    local yPos = -35
    for _, addonName in pairs(AU.others.blacklist) do
        local addonLabel = AU.ui.Font(blacklistFrame, 10, addonName)
        addonLabel:SetPoint('TOPLEFT', blacklistFrame, 'TOPLEFT', 10, yPos)
        addonLabel:SetJustifyH('LEFT')

        local isActive = IsAddOnLoaded(addonName)
        local statusText = isActive and '|cffff8080Active|r' or '|cff808080Not Active|r'
        local addonStatus = AU.ui.Font(blacklistFrame, 10, statusText)
        addonStatus:SetPoint('TOP', addonLabel, 'TOP', 0, 0)
        addonStatus:SetPoint('RIGHT', blacklistFrame, 'RIGHT', -10, 0)
        addonStatus:SetJustifyH('RIGHT')

        yPos = yPos - 15
    end

    local modulesPanel = setup.panels['modules']
    modulesPanel:SetHeight(450)

    local modulesInfo = AU.ui.Font(modulesPanel, 10, 'Enable or disable modules. Changes require a reload.')
    modulesInfo:SetPoint('TOP', modulesPanel, 'TOP', -50, -30)

    local moduleHeaderName = AU.ui.Font(modulesPanel, 10, 'Module', {0.6, 0.6, 0.6})
    moduleHeaderName:SetPoint('TOPLEFT', modulesPanel, 'TOPLEFT', 40, -55)
    moduleHeaderName:SetJustifyH('LEFT')

    local moduleHeaderVersion = AU.ui.Font(modulesPanel, 10, 'Version', {0.6, 0.6, 0.6})
    moduleHeaderVersion:SetPoint('LEFT', moduleHeaderName, 'RIGHT', 120, 0)
    moduleHeaderVersion:SetJustifyH('LEFT')

    local moduleHeaderStatus = AU.ui.Font(modulesPanel, 10, 'State', {0.6, 0.6, 0.6})
    moduleHeaderStatus:SetPoint('LEFT', moduleHeaderVersion, 'RIGHT', 295, 0)
    moduleHeaderStatus:SetJustifyH('LEFT')

    local modulesScroll = AU.ui.Scrollframe(modulesPanel, 650, 350, 'AU_ModulesScroll')
    modulesScroll:SetPoint('TOP', modulesPanel, 'TOP', 0, -70)

    local moduleNames = {}
    local initialStates = {}
    for moduleName, moduleData in pairs(AU.profile) do
        if moduleData.version and moduleData.enabled ~= nil then
            local lowerName = string.lower(moduleName)
            if not (string.len(lowerName) >= 3 and string.sub(lowerName, 1, 3) == 'gui') then
                table.insert(moduleNames, moduleName)
                initialStates[moduleName] = moduleData.enabled
            end
        end
    end
    table.sort(moduleNames)

    local reloadBtn = AU.ui.Button(modulesPanel, 'Reload UI', 100, 25)
    reloadBtn:SetPoint('TOP', modulesScroll, 'BOTTOM', -50, -40)
    reloadBtn:SetScript('OnClick', function() ReloadUI() end)

    function setup:updateReloadButton()
        local hasChanges = false
        for modName, initialState in pairs(initialStates) do
            if AU.profile[modName] and AU.profile[modName].enabled ~= initialState then
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
        local moduleData = AU.profile[moduleName]
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

        local versionText = AU.ui.Font(moduleFrame, 10, 'v' .. moduleData.version, {0.7, 0.7, 0.7})
        versionText:SetPoint('LEFT', moduleFrame, 'LEFT', 180, 0)
        versionText:SetJustifyH('LEFT')

        local checkbox = AU.ui.Checkbox(moduleFrame, 'Enabled', 20, 20, 'RIGHT')
        checkbox:SetPoint('RIGHT', moduleFrame, 'RIGHT', 0, 0)
        checkbox:SetChecked(moduleData.enabled)
        checkbox.moduleName = moduleName
        checkbox.nameText = nameText
        checkbox:SetScript('OnClick', function()
            local isChecked = this:GetChecked() and true or false
            AU.profile[this.moduleName].enabled = isChecked
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
            if AU.profile[moduleName] and AU.profile[moduleName].enabled ~= initialState then
                return true
            end
        end
        return false
    end

    -- callbacks
    local helpers = {}
    local callbacks = {}

    AU:NewCallbacks('gui-extrapanels', callbacks)
end)
