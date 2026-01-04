DRAGONFLIGHT()

DF:NewDefaults('gui-base', {
    version = {value = '1.0'},
    enabled = {value = true},
})

DF:NewModule('gui-base', 1, function()
    if DF.setups.guiBase then return end

    local setup = {
        basic = {width = 850, height = 600},

        panels = {},

        noScrollTabs = {home = true, info = true, modules = true, performance = true, trouble = true, profiles = true, development = true},

        tabConfig = {
            {name = 'Home', key = 'home'},
            {name = 'Info', key = 'info'},
            {name = 'Performance', key = 'performance'},
            {name = 'Modules', key = 'modules'},
            {name = 'Profiles', key = 'profiles'},
            {name = 'Development', key = 'development'},
            {name = 'SPACER'},
            {name = 'General', key = 'general'},
            {name = 'Actionbars', key = 'actionbars'},
            {name = 'Bags', key = 'bags'},
            {name = 'Buffs/Debuffs', key = 'buffs'},
            {name = 'Castbar', key = 'castbar', dependency = 'SuperWoW'},
            {name = 'Chat', key = 'chat'},
            {name = 'Extras', key = 'extras'},
            {name = 'Loot', key = 'loot'},
            {name = 'Micromenu', key = 'micromenu'},
            {name = 'Minimap', key = 'minimap'},
            {name = 'Nameplates', key = 'nameplates'},
            -- {name = 'Quests', key = 'quests'},
            {name = 'Tooltip', key = 'tooltip'},
            {name = 'Unitframes', key = 'unitframes'},
            {name = 'XP/RepBar', key = 'xpbar'},
        },
    }

    do
        local filtered = {}
        for _, tab in pairs(setup.tabConfig) do
            if not tab.dependency or dependencies[tab.dependency] then
                table.insert(filtered, tab)
            end
        end
        setup.tabConfig = filtered
    end

    setup.mainframe = DF.ui.CreatePaperDollFrame('DF_GUI', UIParent, setup.basic.width, setup.basic.height, 1)
    setup.mainframe:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    setup.mainframe:SetFrameStrata('HIGH')
    setup.mainframe:EnableMouse(true)
    setup.mainframe:SetMovable(true)
    setup.mainframe:RegisterForDrag('LeftButton')
    setup.mainframe:SetScript('OnDragStart', function() this:StartMoving() end)
    setup.mainframe:SetScript('OnDragStop', function() this:StopMovingOrSizing() end)

    local logo = setup.mainframe:CreateTexture(nil, 'ARTWORK')
    logo:SetTexture(media['tex:interface:logo.blp'])
    logo:SetSize(64, 64)
    logo:SetPoint('TOPLEFT', setup.mainframe, 'TOPLEFT', -7, 10)
    setup.skipHideCheck = false
    setup.mainframe:SetScript('OnShow', function()
        this:ClearAllPoints()
        this:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    end)
    setup.mainframe:SetScript('OnHide', function()
        if setup.skipHideCheck then
            setup.skipHideCheck = false
            return
        end
        if setup.checkModuleChanges and setup.checkModuleChanges() then
            DF.ui.StaticPopup_Show('Module changes detected. Reload UI?', 'Yes', function() ReloadUI() end, 'No')
        end
    end)
    -- debugframe(setup.mainframe)
    setup.mainframe:Hide()
    tinsert(UISpecialFrames, 'DF_GUI')

    setup.titleText = DF.ui.Font(setup.mainframe, 12, info.addonNameColor)
    setup.titleText:SetPoint('TOPLEFT', setup.mainframe, 'TOPLEFT', 60, -6)

    setup.closeBtn = DF.ui.CreateRedButton(setup.mainframe, 'close', function()
        setup.mainframe:Hide()
    end)
    setup.closeBtn:SetPoint('TOPRIGHT', setup.mainframe, 'TOPRIGHT', -3, -3)
    setup.closeBtn:SetFrameLevel(setup.mainframe:GetFrameLevel() + 1)

    -- setup.resizeBtn = DF.ui.CreateRedButton(setup.mainframe, 'maximize')
    -- setup.resizeBtn:SetPoint('RIGHT', setup.closeBtn, 'LEFT', -2, 0)
    -- setup.resizeBtn:SetFrameLevel(setup.mainframe:GetFrameLevel() + 1)
    -- setup.resizeBtn:SetScript('OnClick', function()
    --     local newType = setup.resizeBtn.currentType == 'maximize' and 'minimize' or 'maximize'
    --     -- setup.resizeBtn:SwitchType(newType)
    -- end)

    setup.headerframe = CreateFrame('Frame', nil, setup.mainframe)
    setup.headerframe:SetPoint('TOPLEFT', setup.mainframe, 'TOPLEFT', 0, -20)
    setup.headerframe:SetPoint('BOTTOMRIGHT', setup.mainframe, 'TOPRIGHT', 0, -60)

    setup.panelHeaderText = DF.ui.Font(setup.headerframe, 12, '')
    setup.panelHeaderText:SetPoint('BOTTOM', setup.headerframe, 'BOTTOM', 0, 5)

    -- local headerTex = setup.headerframe:CreateTexture(nil, 'BACKGROUND')
    -- headerTex:SetTexture('Interface\\Buttons\\WHITE8X8')
    -- headerTex:SetPoint("TOPLEFT", setup.headerframe, "TOPLEFT", 5, -5)
    -- headerTex:SetPoint("BOTTOMRIGHT", setup.headerframe, "BOTTOMRIGHT", -5, 0)
    -- headerTex:SetVertexColor(0,0,0,.4)
    -- debugframe(setup.headerframe)

    local tabframeHeight = setup.basic.height - 61
    setup.tabframe = DF.ui.TabFrame(setup.mainframe, 110, tabframeHeight, 20, 10, 'DF_GUITabs')
    setup.tabframe:SetPoint('TOPLEFT', setup.headerframe, 'BOTTOMLEFT', 4, 0)
    local tabTex = setup.tabframe:CreateTexture(nil, 'BACKGROUND')
    tabTex:SetTexture('Interface\\Buttons\\WHITE8X8')
    tabTex:SetPoint("TOPLEFT", setup.mainframe, "TOPLEFT", 2, -53)
    tabTex:SetPoint("BOTTOMRIGHT", setup.tabframe, "BOTTOMRIGHT", 5, 5)
    tabTex:SetVertexColor(0,0,0,.4)
    -- debugframe(setup.tabframe)

    setup.subframe = CreateFrame('Frame', nil, setup.mainframe)
    setup.subframe:SetPoint('TOPLEFT', setup.tabframe, 'BOTTOMRIGHT', 4, 20)
    setup.subframe:SetPoint('BOTTOMRIGHT', setup.mainframe, 'BOTTOMRIGHT', -3, 3)

    -- debugframe(setup.subframe)
    local subTex = setup.subframe:CreateTexture(nil, 'BACKGROUND')
    subTex:SetTexture('Interface\\Buttons\\WHITE8X8')
    subTex:SetAllPoints(setup.subframe)
    subTex:SetVertexColor(0,0,0,.4)

    local hoverbindBtn = DF.ui.Button(setup.subframe, 'Hoverbind', 80, 20, false, {1, 0, 0})
    hoverbindBtn:SetPoint('LEFT', setup.subframe, 'LEFT', 5, 0)
    hoverbindBtn:SetScript('OnClick', function()
        setup.mainframe:Hide()
        if DF.setups.hover.mainFrame:IsShown() then
            DF.setups.hover:Hide()
        else
            DF.setups.hover:Show()
        end
    end)

    setup.testBtn = DF.ui.Button(setup.subframe, 'Test', 80, 20, false, {1, 0, 0})
    setup.testBtn:SetPoint('CENTER', setup.subframe, 'CENTER', 0, 0)
    setup.testBtn.testRunning = false
    setup.testBtn:SetScript('OnClick', function()
        if this.testRunning then
            NoControlStopTest()
            this.testRunning = false
            this.text:SetTextColor(1, 0, 0)
            setup.mainframe.Bg:SetAlpha(DF.profile['gui-generator'].guibgalpha / 100)
        else
            NoControlStartTest()
            this.testRunning = true
            this.text:SetTextColor(0, 1, 0)
            setup.mainframe.Bg:SetAlpha(0.5)
        end
    end)
    setup.testBtn:Hide()

    local panelWidth = setup.basic.width - 170
    local panelHeight = setup.basic.height - 110
    setup.panelframe = DF.ui.Scrollframe(setup.mainframe, panelWidth, panelHeight, 'DF_GUIPanelScroll')
    setup.panelframe:SetPoint('TOPLEFT', setup.headerframe, 'BOTTOMLEFT', 150, -20)
    -- debugframe(setup.panelframe)

    setup.normalframe = CreateFrame('Frame', nil, setup.mainframe)
    setup.normalframe:SetPoint('TOPLEFT', setup.headerframe, 'BOTTOMLEFT', 150, -20)
    setup.normalframe:SetSize(panelWidth, panelHeight)
    setup.normalframe:Hide()
    -- debugframe(setup.normalframe)

    local subtabsLookup = {}
    for _, moduleData in pairs(DF.defaults) do
        if moduleData.gui then
            for _, guiEntry in pairs(moduleData.gui) do
                if guiEntry.tab and guiEntry.subtab then
                    if not subtabsLookup[guiEntry.tab] then
                        subtabsLookup[guiEntry.tab] = {}
                    end
                    local found = false
                    for _, existingSub in pairs(subtabsLookup[guiEntry.tab]) do
                        if existingSub == guiEntry.subtab then
                            found = true
                            break
                        end
                    end
                    if not found then
                        table.insert(subtabsLookup[guiEntry.tab], guiEntry.subtab)
                    end
                end
            end
        end
    end

    for _, tabData in pairs(setup.tabConfig) do
        if tabData.key and subtabsLookup[tabData.key] then
            tabData.subtabs = subtabsLookup[tabData.key]
        end
    end

    setup.tabIndexToKey = {}
    setup.activeTab = nil
    setup.activeSubtab = nil

    for i, tabData in pairs(setup.tabConfig) do
        if tabData.name == 'SPACER' then
            setup.tabframe:AddTab('SPACER')
        else
            setup.tabframe:AddTab(tabData.name, tabData.subtabs)
            table.insert(setup.tabIndexToKey, {key = tabData.key, name = tabData.name, subtabs = tabData.subtabs})
        end
    end

    for _, tabData in pairs(setup.tabConfig) do
        if tabData.key then
            local parentFrame = setup.noScrollTabs[tabData.key] and setup.normalframe or setup.panelframe.content
            local panel = CreateFrame('Frame', nil, parentFrame)
            panel:SetAllPoints(parentFrame)
            panel:Hide()
            setup.panels[tabData.key] = panel

            if tabData.subtabs then
                for _, subtabName in pairs(tabData.subtabs) do
                    local subpanel = CreateFrame('Frame', nil, parentFrame)
                    subpanel:SetAllPoints(parentFrame)
                    subpanel:Hide()
                    setup.panels[tabData.key .. '_' .. subtabName] = subpanel
                end
            end
        end
    end

    setup.tabframe.onTabClick = function(tabIndex, subtabIndex)
        local tabInfo = setup.tabIndexToKey[tabIndex]
        setup.activeTab = tabInfo.key

        if subtabIndex then
            setup.activeSubtab = tabInfo.subtabs[subtabIndex]
            setup.panelHeaderText:SetText(strupper(setup.activeSubtab))
            setup:ShowPanel(setup.activeTab, setup.activeSubtab)
        else
            setup.activeSubtab = nil
            setup.panelHeaderText:SetText(strupper(tabInfo.name))
            setup:ShowPanel(setup.activeTab, nil)
        end
    end

    function setup:ShowPanel(tabKey, subtabKey)
        for key, panel in pairs(self.panels) do
            panel:Hide()
        end

        local panelKey = tabKey
        if subtabKey then
            panelKey = tabKey .. '_' .. subtabKey
        end

        if self.noScrollTabs[tabKey] then
            self.panelframe:Hide()
            self.normalframe:Show()
        else
            self.normalframe:Hide()
            self.panelframe:Show()
        end

        if tabKey == 'home' then
            self.panelHeaderText:Hide()
        else
            self.panelHeaderText:Show()
        end

        local activePanel = self.panels[panelKey]
        activePanel:Show()
        local activePanelHeight = activePanel:GetHeight()
        if activePanelHeight and activePanelHeight > 0 then
            self.panelframe.content:SetHeight(activePanelHeight)
        end
        self.panelframe.updateScrollBar()

        self.panelframe:SetVerticalScroll(0)
        self.panelframe.scrollBar:SetValue(0)

        if tabKey == 'extras' and subtabKey == 'nocontrol' then
            self.testBtn:Show()
        else
            self.testBtn:Hide()
        end
    end

    setup.tabframe.tabs[1].button:Click()

    DF.setups.guiBase = setup

    function DRAGONFLIGHTToggleGUI() -- TODO SAFETY CHECK
        if DF.setups.guiBase and DF.setups.guiBase.mainframe then
            if DF.setups.guiBase.mainframe:IsShown() then DF.setups.guiBase.mainframe:Hide() else DF.setups.guiBase.mainframe:Show() end
        end
    end

    -- expose
    DF.setups.guiBase = setup

    -- debug
    setup.debug = false
    if setup.debug then
        setup.mainframe:Show()
    end
end)