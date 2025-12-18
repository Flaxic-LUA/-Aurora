UNLOCKAURORA()

AU:NewDefaults('gui-profiles', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'template', subtab = 'mainbar', categories = 'General'},
    },

})

AU:NewModule('gui-profiles', 2, function()
    local setup = AU.setups.guiBase
    if not setup then return end

    local profilePanel = setup.panels['profiles']

    local leftFrame = CreateFrame('Frame', nil, profilePanel)
    leftFrame:SetPoint('TOPLEFT', profilePanel, 'TOPLEFT', 0, 0)
    leftFrame:SetPoint('BOTTOMRIGHT', profilePanel, 'BOTTOM', -2, -5)
    -- debugframe(leftFrame)
    local rightFrame = CreateFrame('Frame', nil, profilePanel)
    rightFrame:SetPoint('TOPRIGHT', profilePanel, 'TOPRIGHT', 0, 0)
    rightFrame:SetPoint('BOTTOMLEFT', profilePanel, 'BOTTOM', 2, 0)

    local leftHeader = AU.ui.Font(leftFrame, 12, 'Profile Management', {1, 0.82, 0})
    leftHeader:SetPoint('TOPLEFT', leftFrame, 'TOPLEFT', 10, -10)
    leftHeader:SetJustifyH('LEFT')

    local profileScroll = AU.ui.Scrollframe(leftFrame, leftFrame:GetWidth() - 20, leftFrame:GetHeight() - 182)
    profileScroll:SetPoint('TOPLEFT', leftHeader, 'BOTTOMLEFT', 0, -10)

    local profileUI = {selectedProfile = nil}

    local inputDialog = AU.ui.CreatePaperDollFrame('AuroraInputDialog', setup.mainframe, 300, 120, 2)
    inputDialog:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    inputDialog:SetFrameStrata('DIALOG')
    inputDialog:Hide()

    local inputTitle = AU.ui.Font(inputDialog, 12, '', {1, 1, 1})
    inputTitle:SetPoint('TOP', inputDialog, 'TOP', 0, -5)

    local inputLabel = AU.ui.Font(inputDialog, 12, 'Enter Profile Name:', {1, 0.82, 0})
    inputLabel:SetPoint('TOP', inputTitle, 'BOTTOM', 0, -10)

    local inputBox = AU.ui.Editbox(inputDialog, 260, 30, 50)
    inputBox:SetPoint('TOP', inputLabel, 'BOTTOM', 0, -10)
    inputBox:SetScript('OnEscapePressed', function()
        inputBox:SetText('')
        inputDialog:Hide()
    end)
    inputBox:SetScript('OnEnterPressed', function()
        inputOkBtn:Click()
    end)

    local inputOkBtn = AU.ui.Button(inputDialog, 'OK', 120, 28)
    inputOkBtn:SetPoint('BOTTOMLEFT', inputDialog, 'BOTTOMLEFT', 15, 10)
    inputOkBtn:SetScript('OnClick', function()
        if inputDialog.mode == 'delete' and inputDialog.deleteTarget then
            -- debugprint('DELETE: deleteTarget = ' .. inputDialog.deleteTarget)
            local ptr = tostring(AU_GlobalDB.profiles[inputDialog.deleteTarget])
            -- debugprint('DELETE: ptr before = ' .. ptr)
            profileUI:DeleteProfile(inputDialog.deleteTarget)
            -- debugprint('DELETE: ptr after = ' .. tostring(AU_GlobalDB.profiles[inputDialog.deleteTarget]))
            profileUI.activityLog:AddMessage('[DELETE] ' .. inputDialog.deleteTarget .. ' (' .. ptr .. ')', {1, 0.6, 0.6})
            profileUI.selectedProfile = nil
            inputDialog.deleteTarget = nil
            profileUI:RefreshProfileList()
            inputDialog:Hide()
            return
        end
        local text = inputBox:GetText()
        if text and text ~= '' then
            if inputDialog.mode == 'new' then
                if AU_GlobalDB.profiles[text] then return end
                profileUI:CreateProfile(text)
                profileUI.activityLog:AddMessage('[NEW] ' .. text .. ' (' .. tostring(AU_GlobalDB.profiles[text]) .. ')', {0.6, 1, 0.6})
            elseif inputDialog.mode == 'copy' and profileUI.selectedProfile then
                if AU_GlobalDB.profiles[text] then return end
                local sourcePtr = tostring(AU_GlobalDB.profiles[profileUI.selectedProfile])
                profileUI:CreateProfile(text)
                AU_GlobalDB.profiles[text] = AU.data.copy(AU_GlobalDB.profiles[profileUI.selectedProfile], true)
                profileUI.activityLog:AddMessage('[COPY] ' .. profileUI.selectedProfile .. ' (' .. sourcePtr .. ') -> ' .. text .. ' (' .. tostring(AU_GlobalDB.profiles[text]) .. ')', {0.6, 1, 0.6})
            elseif inputDialog.mode == 'rename' and profileUI.selectedProfile then
                if AU_GlobalDB.profiles[text] and text ~= profileUI.selectedProfile then return end
                local oldName = profileUI.selectedProfile
                AU_GlobalDB.profiles[text] = AU_GlobalDB.profiles[profileUI.selectedProfile]
                AU_GlobalDB.profiles[profileUI.selectedProfile] = nil
                AU_GlobalDB.meta.profileMeta = AU_GlobalDB.meta.profileMeta or {}
                if AU_GlobalDB.meta.profileMeta[oldName] then
                    AU_GlobalDB.meta.profileMeta[text] = {
                        created = AU_GlobalDB.meta.profileMeta[oldName].created,
                        modified = AU_GlobalDB.meta.profileMeta[oldName].modified,
                        description = AU_GlobalDB.meta.profileMeta[oldName].description
                    }
                    AU_GlobalDB.meta.profileMeta[oldName] = nil
                end
                if AU_GlobalDB.meta.activeProfile == profileUI.selectedProfile then
                    AU_GlobalDB.meta.activeProfile = text
                    AU.others.currentProfile = text
                end
                local charName = UnitName('player')
                local realmName = GetRealmName()
                local charKey = charName .. '-' .. realmName
                if AU_GlobalDB.meta.characterProfiles and AU_GlobalDB.meta.characterProfiles[charKey] == profileUI.selectedProfile then
                    AU_GlobalDB.meta.characterProfiles[charKey] = text
                end
                profileUI.selectedProfile = text
                profileUI.activityLog:AddMessage('[RENAME] ' .. oldName .. ' -> ' .. text, {0.6, 1, 0.6})
            end
            profileUI:RefreshProfileList()
            inputBox:SetText('')
            inputDialog:Hide()
        end
    end)

    local inputCancelBtn = AU.ui.Button(inputDialog, 'Cancel', 120, 28)
    inputCancelBtn:SetPoint('BOTTOMRIGHT', inputDialog, 'BOTTOMRIGHT', -15, 10)
    inputCancelBtn:SetScript('OnClick', function()
        inputBox:SetText('')
        inputBox:Show()
        inputDialog:Hide()
    end)

    local btnWidth = (leftFrame:GetWidth() - 30) / 2
    local activateBtn = AU.ui.Button(leftFrame, 'Activate', leftFrame:GetWidth() - 20, 28, false, {0.3, 1, 0.3})
    activateBtn:SetPoint('BOTTOMLEFT', leftFrame, 'BOTTOMLEFT', 10, 108)
    activateBtn:SetScript('OnClick', function()
        if not profileUI.selectedProfile then return end
        if profileUI.selectedProfile ~= AU_GlobalDB.meta.activeProfile then
            profileUI:SwitchProfile(profileUI.selectedProfile)
            profileUI:RefreshProfileList()
        end
    end)

    local newBtn = AU.ui.Button(leftFrame, 'New', btnWidth, 28)
    newBtn:SetPoint('BOTTOMLEFT', leftFrame, 'BOTTOMLEFT', 10, 76)
    newBtn:SetScript('OnClick', function()
        inputDialog.mode = 'new'
        inputDialog:SetHeight(150)
        inputTitle:SetText('New Profile')
        inputLabel:ClearAllPoints()
        inputLabel:SetPoint('TOP', inputTitle, 'BOTTOM', 0, -20)
        inputLabel:SetText('Enter Profile Name:')
        inputBox:Show()
        inputDialog:Show()
        inputBox:SetFocus()
    end)

    local copyBtn = AU.ui.Button(leftFrame, 'Copy', btnWidth, 28)
    copyBtn:SetPoint('BOTTOMRIGHT', leftFrame, 'BOTTOMRIGHT', -10, 76)
    copyBtn:SetScript('OnClick', function()
        -- debugprint('COPY CLICKED: selectedProfile = ' .. tostring(profileUI.selectedProfile))
        if not profileUI.selectedProfile then return end
        inputDialog.mode = 'copy'
        inputDialog:SetHeight(150)
        inputTitle:SetText('Copy Profile')
        inputLabel:ClearAllPoints()
        inputLabel:SetPoint('TOP', inputTitle, 'BOTTOM', 0, -20)
        inputLabel:SetText('Copy ' .. profileUI.selectedProfile .. ' to:')
        inputBox:Show()
        inputDialog:Show()
        inputBox:SetFocus()
    end)

    local renameBtn = AU.ui.Button(leftFrame, 'Rename', btnWidth, 28)
    renameBtn:SetPoint('BOTTOMLEFT', leftFrame, 'BOTTOMLEFT', 10, 44)
    renameBtn:SetScript('OnClick', function()
        if not profileUI.selectedProfile or profileUI.selectedProfile == 'default' then return end
        inputDialog.mode = 'rename'
        inputDialog:SetHeight(150)
        inputTitle:SetText('Rename Profile')
        inputLabel:ClearAllPoints()
        inputLabel:SetPoint('TOP', inputTitle, 'BOTTOM', 0, -20)
        inputLabel:SetText('Rename ' .. profileUI.selectedProfile .. ' to:')
        inputBox:SetText(profileUI.selectedProfile)
        inputBox:Show()
        inputDialog:Show()
        inputBox:SetFocus()
    end)

    local deleteBtn = AU.ui.Button(leftFrame, 'Delete', btnWidth, 28, false, {1, 0.3, 0.3})
    deleteBtn:SetPoint('BOTTOMRIGHT', leftFrame, 'BOTTOMRIGHT', -10, 44)
    deleteBtn:SetScript('OnClick', function()
        inputDialog.mode = 'delete'
        inputDialog.deleteTarget = profileUI.selectedProfile
        inputDialog:SetHeight(120)
        inputTitle:SetText('Delete Profile')
        inputLabel:ClearAllPoints()
        inputLabel:SetPoint('CENTER', inputDialog, 'CENTER', 0, 10)
        inputLabel:SetText('Delete profile: ' .. profileUI.selectedProfile .. '?')
        inputBox:Hide()
        inputDialog:Show()
    end)

    local resetEverythingBtn = AU.ui.Button(leftFrame, 'Reset Everything', leftFrame:GetWidth() - 20, 28, false, {1, 0.3, 0.3})
    resetEverythingBtn:SetPoint('BOTTOMLEFT', leftFrame, 'BOTTOMLEFT', 10, 8)
    resetEverythingBtn:SetScript('OnClick', function()
        inputDialog.mode = 'resetall'
        inputDialog:SetHeight(120)
        inputTitle:SetText('Reset Everything')
        inputLabel:ClearAllPoints()
        inputLabel:SetPoint('CENTER', inputDialog, 'CENTER', 0, 10)
        inputLabel:SetText('Wipe entire database and reload?')
        inputBox:Hide()
        inputOkBtn:SetScript('OnClick', function()
            _G.AU_GlobalDB = {}
            ReloadUI()
        end)
        inputDialog:Show()
    end)

    function profileUI:UpdateButtonStates()
        local count = 0
        for _ in pairs(AU_GlobalDB.profiles) do
            count = count + 1
        end
        if profileUI.selectedProfile == '.defaults' or profileUI.selectedProfile == 'default' or count <= 2 then
            renameBtn:Disable()
            deleteBtn:Disable()
        elseif profileUI.selectedProfile == AU_GlobalDB.meta.activeProfile then
            renameBtn:Enable()
            deleteBtn:Disable()
        else
            renameBtn:Enable()
            deleteBtn:Enable()
        end
    end

    function profileUI:RefreshProfileList()
        AU_GlobalDB.profiles = AU_GlobalDB.profiles or {}
        local profiles = {}
        for name, _ in pairs(AU_GlobalDB.profiles) do
            table.insert(profiles, name)
        end
        table.sort(profiles)

        for i = 1, table.getn(profileScroll.content.buttons or {}) do
            profileScroll.content.buttons[i]:Hide()
        end
        profileScroll.content.buttons = {}

        for i = 1, table.getn(profiles) do
            local profileName = profiles[i]
            local profileBtn = AU.ui.Button(profileScroll.content, profileName, profileScroll:GetWidth() - 10, 32)
            profileBtn:SetPoint('TOPLEFT', profileScroll.content, 'TOPLEFT', 5, -((i - 1) * 36))

            if AU.profile['gui-generator'] and AU.profile['gui-generator'].guifont then
                local fontPath = media[AU.profile['gui-generator'].guifont]
                if fontPath then
                    local _, size, flags = profileBtn.text:GetFont()
                    profileBtn.text:SetFont(fontPath, size, flags)
                end
            end

            profileBtn:SetScript('OnClick', function()
                -- debugprint('PROFILE CLICKED: ' .. profileName)
                profileUI.selectedProfile = profileName
                -- debugprint('selectedProfile SET TO: ' .. tostring(profileUI.selectedProfile))
                profileUI:UpdateRightPanel(profileName)
                profileUI:UpdateButtonStates()
                for j = 1, table.getn(profileScroll.content.buttons) do
                    local btn = profileScroll.content.buttons[j]
                    local btnName = profiles[j]
                    if btnName == AU_GlobalDB.meta.activeProfile and btnName == profileUI.selectedProfile then
                        btn:SetBackdropBorderColor(0, 0.8, 1, 1)
                    elseif btnName == AU_GlobalDB.meta.activeProfile then
                        btn:SetBackdropBorderColor(0, 0.8, 1, 1)
                    elseif btnName == profileUI.selectedProfile then
                        btn:SetBackdropBorderColor(1, 1, 1, 1)
                    else
                        btn:SetBackdropBorderColor(0, 0, 0, 0)
                    end
                end
            end)
            if profileName == AU_GlobalDB.meta.activeProfile then
                profileBtn:SetBackdropBorderColor(0, 0.8, 1, 1)
            elseif profileName == profileUI.selectedProfile then
                profileBtn:SetBackdropBorderColor(1, 1, 1, 1)
            end
            table.insert(profileScroll.content.buttons, profileBtn)
        end
        profileScroll.content:SetHeight(table.getn(profiles) * 36)
        profileScroll.updateScrollBar()
    end

    profileUI:RefreshProfileList()

    local rightHeader = AU.ui.Font(rightFrame, 12, 'Profile Details', {1, 0.82, 0})
    rightHeader:SetPoint('TOPLEFT', rightFrame, 'TOPLEFT', 10, -10)
    rightHeader:SetJustifyH('LEFT')

    local profileName = AU.ui.Font(rightFrame, 14, 'Default', {0, 0.8, 1})
    profileName:SetPoint('TOPLEFT', rightHeader, 'BOTTOMLEFT', 0, -15)
    profileName:SetJustifyH('LEFT')

    local divider1 = AU.ui.Frame(rightFrame, rightFrame:GetWidth() - 20, 1, 0.3)
    divider1:SetPoint('TOPLEFT', profileName, 'BOTTOMLEFT', 0, -8)

    local createdLabel = AU.ui.Font(rightFrame, 10, 'Created:', {0.6, 0.6, 0.6})
    createdLabel:SetPoint('TOPLEFT', divider1, 'BOTTOMLEFT', 0, -12)
    createdLabel:SetJustifyH('LEFT')

    local createdValue = AU.ui.Font(rightFrame, 11, '2024-01-15 14:30', {1, 1, 1})
    createdValue:SetPoint('TOPLEFT', createdLabel, 'BOTTOMLEFT', 0, -4)
    createdValue:SetJustifyH('LEFT')

    local modifiedLabel = AU.ui.Font(rightFrame, 10, 'Last Modified:', {0.6, 0.6, 0.6})
    modifiedLabel:SetPoint('TOPLEFT', createdValue, 'BOTTOMLEFT', 0, -10)
    modifiedLabel:SetJustifyH('LEFT')

    local modifiedValue = AU.ui.Font(rightFrame, 11, '2024-01-20 09:15', {1, 1, 1})
    modifiedValue:SetPoint('TOPLEFT', modifiedLabel, 'BOTTOMLEFT', 0, -4)
    modifiedValue:SetJustifyH('LEFT')

    local divider2 = AU.ui.Frame(rightFrame, rightFrame:GetWidth() - 20, 1, 0.3)
    divider2:SetPoint('TOPLEFT', modifiedValue, 'BOTTOMLEFT', 0, -12)

    local descLabel = AU.ui.Font(rightFrame, 10, 'Description:', {0.6, 0.6, 0.6})
    descLabel:SetPoint('TOPLEFT', divider2, 'BOTTOMLEFT', 0, -12)
    descLabel:SetJustifyH('LEFT')

    profileUI.descBox = AU.ui.Editbox(rightFrame, rightFrame:GetWidth() - 20, 60, 200)
    profileUI.descBox:SetPoint('TOPLEFT', descLabel, 'BOTTOMLEFT', 0, -6)
    profileUI.descBox:SetText('My default Aurora profile')
    profileUI.descBox:SetScript('OnEscapePressed', function()
        profileUI.descBox:ClearFocus()
    end)
    profileUI.descBox:SetScript('OnEnterPressed', function()
        profileUI.descBox:ClearFocus()
    end)
    profileUI.profileName = profileName
    profileUI.createdValue = createdValue
    profileUI.modifiedValue = modifiedValue

    function profileUI:UpdateRightPanel(name)
        AU_GlobalDB.meta.profileMeta = AU_GlobalDB.meta.profileMeta or {}
        local meta = AU_GlobalDB.meta.profileMeta[name] or {}

        self.profileName:SetText(name)
        self.createdValue:SetText(meta.created or 'Unknown')
        self.modifiedValue:SetText(meta.modified or 'Unknown')
        self.descBox:SetText(meta.description or '')

        if self.modulesText then
            local enabledCount = 0
            if AU_GlobalDB.profiles[name] then
                for module, data in pairs(AU_GlobalDB.profiles[name]) do
                    if data.enabled then
                        enabledCount = enabledCount + 1
                    end
                end
            end
            self.modulesText:SetText('Enabled Modules: ' .. enabledCount)
        end
    end

    profileUI.descBox:SetScript('OnTextChanged', function()
        if profileUI.selectedProfile then
            AU_GlobalDB.meta.profileMeta = AU_GlobalDB.meta.profileMeta or {}
            AU_GlobalDB.meta.profileMeta[profileUI.selectedProfile] = AU_GlobalDB.meta.profileMeta[profileUI.selectedProfile] or {}
            AU_GlobalDB.meta.profileMeta[profileUI.selectedProfile].description = profileUI.descBox:GetText()
            AU_GlobalDB.meta.profileMeta[profileUI.selectedProfile].modified = date('%Y-%m-%d %H:%M')
        end
    end)

    if AU_GlobalDB.meta.activeProfile then
        profileUI:UpdateRightPanel(AU_GlobalDB.meta.activeProfile)
    end

    local divider3 = AU.ui.Frame(rightFrame, rightFrame:GetWidth() - 20, 1, 0.3)
    divider3:SetPoint('TOPLEFT', profileUI.descBox, 'BOTTOMLEFT', 0, -12)

    local actionsLabel = AU.ui.Font(rightFrame, 10, 'Quick Actions:', {0.6, 0.6, 0.6})
    actionsLabel:SetPoint('TOPLEFT', divider3, 'BOTTOMLEFT', 0, -12)
    actionsLabel:SetJustifyH('LEFT')

    local importBtn = AU.ui.Button(rightFrame, 'Import Profile', rightFrame:GetWidth() - 20, 28)
    importBtn:SetPoint('TOPLEFT', actionsLabel, 'BOTTOMLEFT', 0, -8)

    local exportBtn = AU.ui.Button(rightFrame, 'Export Profile', rightFrame:GetWidth() - 20, 28)
    exportBtn:SetPoint('TOPLEFT', importBtn, 'BOTTOMLEFT', 0, -6)

    local resetBtn = AU.ui.Button(rightFrame, 'Reset to Defaults', rightFrame:GetWidth() - 20, 28)
    resetBtn:SetPoint('TOPLEFT', exportBtn, 'BOTTOMLEFT', 0, -6)
    resetBtn:SetScript('OnClick', function()
        if not profileUI.selectedProfile then return end
        inputDialog.mode = 'reset'
        inputTitle:SetText('Reset Profile')
        inputLabel:ClearAllPoints()
        inputLabel:SetPoint('CENTER', inputDialog, 'CENTER', 0, 10)
        inputLabel:SetText('Reset current profile to defaults?')
        inputBox:Hide()
        inputOkBtn:SetScript('OnClick', function()
            AU_GlobalDB.profiles[profileUI.selectedProfile] = {}
            for module, defaults in pairs(AU.defaults) do
                AU_GlobalDB.profiles[profileUI.selectedProfile][module] = {}
                for option, data in pairs(defaults) do
                    AU_GlobalDB.profiles[profileUI.selectedProfile][module][option] = data.value
                end
            end
            AU.profile = AU_GlobalDB.profiles[profileUI.selectedProfile]
            profileUI.activityLog:AddMessage('[RESET] ' .. profileUI.selectedProfile .. ' -> Defaults', {1, 0.6, 0.6})
            for callbackName, callback in pairs(AU.callbacks) do
                local mod, opt = AU.lua.match(callbackName, '(.*)%.(.*)')
                if AU.profile[mod] and AU.profile[mod][opt] ~= nil then
                    callback(AU.profile[mod][opt])
                end
            end
            inputBox:Show()
            inputDialog:Hide()
        end)
        inputDialog:Show()
    end)

    local divider4 = AU.ui.Frame(rightFrame, rightFrame:GetWidth() - 20, 1, 0.3)
    divider4:SetPoint('TOPLEFT', resetBtn, 'BOTTOMLEFT', 0, -12)

    local statsLabel = AU.ui.Font(rightFrame, 10, 'Statistics:', {0.6, 0.6, 0.6})
    statsLabel:SetPoint('TOPLEFT', divider4, 'BOTTOMLEFT', 0, -12)
    statsLabel:SetJustifyH('LEFT')

    profileUI.modulesText = AU.ui.Font(rightFrame, 11, 'Enabled Modules: 0', {1, 1, 1})
    profileUI.modulesText:SetPoint('TOPLEFT', statsLabel, 'BOTTOMLEFT', 0, -6)
    profileUI.modulesText:SetJustifyH('LEFT')

    local activityBg = AU.ui.Frame(rightFrame, rightFrame:GetWidth() - 20, 70, 0.3)
    activityBg:SetPoint('TOPLEFT', profileUI.modulesText, 'BOTTOMLEFT', 0, -10)

    profileUI.activityLog = AU.ui.PushFrame(activityBg, rightFrame:GetWidth() - 24, 65, 50)
    profileUI.activityLog:SetPoint('TOPLEFT', activityBg, 'TOPLEFT', 0, -5)
    profileUI.activityLog:AddMessage('[INIT] Profile system loaded', {0.5, 0.5, 0.5})

    local exportDialog = AU.ui.CreatePaperDollFrame('AuroraExportDialog', setup.mainframe, 580, 420, 2)
    exportDialog:Hide()
    exportDialog:SetPoint('CENTER', 0, 0)
    exportDialog:SetFrameStrata('DIALOG')
    tinsert(UISpecialFrames, 'AuroraExportDialog')

    local exportLabel = AU.ui.Font(exportDialog, 12, 'Export Profile', {1, 0.82, 0})
    exportLabel:SetPoint('TOP', exportDialog, 'TOP', 0, -5)

    local exportScroll = CreateFrame('ScrollFrame', 'AuroraExportScroll', exportDialog)
    exportScroll:SetPoint('TOPLEFT', exportDialog, 'TOPLEFT', 10, -30)
    exportScroll:SetPoint('BOTTOMRIGHT', exportDialog, 'BOTTOMRIGHT', -10, 50)
    exportScroll:SetWidth(560)
    exportScroll:SetHeight(340)

    local exportBox = CreateFrame('EditBox', 'AuroraExportEditBox', exportScroll)
    exportBox:SetMultiLine(true)
    exportBox:SetWidth(540)
    exportBox:SetHeight(340)
    exportBox:SetMaxLetters(0)
    exportBox:SetTextInsets(10, 10, 10, 10)
    exportBox:SetFontObject(GameFontHighlight)
    exportBox:SetAutoFocus(false)
    exportBox:SetJustifyH('LEFT')
    exportBox:SetScript('OnEscapePressed', function() exportBox:ClearFocus() exportDialog:Hide() end)
    exportBox:SetScript('OnTextChanged', function()
        exportScroll:UpdateScrollChildRect()
    end)
    exportScroll:SetScrollChild(exportBox)

    local exportCloseBtn = AU.ui.Button(exportDialog, 'Close', 560, 28)
    exportCloseBtn:SetPoint('BOTTOM', exportDialog, 'BOTTOM', 0, 10)
    exportCloseBtn:SetScript('OnClick', function()
        exportDialog:Hide()
    end)

    exportBtn:SetScript('OnClick', function()
        if not profileUI.selectedProfile then return end
        local str = profileUI:ExportProfile(profileUI.selectedProfile)
        if str then
            -- debugprint('Export string length: ' .. string.len(str))
            profileUI.activityLog:AddMessage('[EXPORT] ' .. profileUI.selectedProfile .. ' (size: ' .. string.len(str) .. ' chars)', {0.6, 1, 0.6})
            exportBox:SetText(str)
            exportBox:HighlightText()
            exportDialog:Show()
            exportBox:SetFocus()
        end
    end)

    local importDialog = AU.ui.CreatePaperDollFrame('AuroraImportDialog', setup.mainframe, 580, 480, 2)
    importDialog:Hide()
    importDialog:SetPoint('CENTER', 0, 0)
    importDialog:SetFrameStrata('DIALOG')
    tinsert(UISpecialFrames, 'AuroraImportDialog')

    local importLabel = AU.ui.Font(importDialog, 12, 'Import Profile', {1, 0.82, 0})
    importLabel:SetPoint('TOP', importDialog, 'TOP', 0, -5)

    local importScroll = CreateFrame('ScrollFrame', 'AuroraImportScroll', importDialog)
    importScroll:SetPoint('TOPLEFT', importDialog, 'TOPLEFT', 10, -30)
    importScroll:SetPoint('TOPRIGHT', importDialog, 'TOPRIGHT', -10, -30)
    importScroll:SetHeight(300)
    importScroll:SetWidth(560)

    local importBox = CreateFrame('EditBox', 'AuroraImportEditBox', importScroll)
    importBox:SetMultiLine(true)
    importBox:SetWidth(540)
    importBox:SetHeight(300)
    importBox:SetMaxLetters(0)
    importBox:SetTextInsets(10, 10, 10, 10)
    importBox:SetFontObject(GameFontHighlight)
    importBox:SetAutoFocus(false)
    importBox:SetJustifyH('LEFT')
    importBox:SetScript('OnEscapePressed', function() importBox:ClearFocus() end)
    importBox:SetScript('OnTextChanged', function()
        importScroll:UpdateScrollChildRect()
    end)
    importScroll:SetScrollChild(importBox)

    local importNameLabel = AU.ui.Font(importDialog, 11, 'Profile Name:', {0.6, 0.6, 0.6})
    importNameLabel:SetPoint('TOPLEFT', importScroll, 'BOTTOMLEFT', 0, -15)

    local importNameBox = AU.ui.Editbox(importDialog, 560, 30, 50)
    importNameBox:SetPoint('TOPLEFT', importNameLabel, 'BOTTOMLEFT', 0, -5)
    importNameBox:SetScript('OnEscapePressed', function()
        importDialog:Hide()
    end)

    local importOkBtn = AU.ui.Button(importDialog, 'Import', 270, 28)
    importOkBtn:SetPoint('BOTTOMLEFT', importDialog, 'BOTTOMLEFT', 10, 10)
    importOkBtn:SetScript('OnClick', function()
        local str = importBox:GetText()
        local name = importNameBox:GetText()
        if not str or str == '' then return end
        if not name or name == '' then return end
        local profile = profileUI:ImportProfile(str)
        if profile then
            profileUI:CreateProfile(name)
            AU_GlobalDB.profiles[name] = profile
            profileUI.activityLog:AddMessage('[IMPORT] ' .. name .. ' (' .. tostring(AU_GlobalDB.profiles[name]) .. ')', {0.6, 1, 0.6})
            profileUI:RefreshProfileList()
            importBox:SetText('')
            importNameBox:SetText('')
            importDialog:Hide()
        end
    end)

    local importCancelBtn = AU.ui.Button(importDialog, 'Cancel', 270, 28)
    importCancelBtn:SetPoint('BOTTOMRIGHT', importDialog, 'BOTTOMRIGHT', -10, 10)
    importCancelBtn:SetScript('OnClick', function()
        importBox:SetText('')
        importNameBox:SetText('')
        importDialog:Hide()
    end)

    importBtn:SetScript('OnClick', function()
        importDialog:Show()
        importBox:SetFocus()
    end)

    -- alright lets start this shit.... tryign to understand elvui/pfui here...
    function profileUI:Serialize(profile)
        local lines = {}
        for module, options in pairs(profile) do
            for key, value in pairs(options) do
                local valueStr
                if type(value) == 'table' then
                    -- serialize table (colors) as comma-separated: 1,1,1,1
                    local parts = {}
                    for i = 1, table.getn(value) do
                        tinsert(parts, tostring(value[i]))
                    end
                    valueStr = table.concat(parts, ',')
                else
                    valueStr = tostring(value)
                end
                tinsert(lines, module .. '|' .. key .. '|' .. valueStr)
            end
        end
        return table.concat(lines, '\n')
    end

    function profileUI:Deserialize(str)
        local profile = {}
        local i = 1
        while i <= string.len(str) do
            local lineEnd = string.find(str, '\n', i) or string.len(str) + 1
            local line = string.sub(str, i, lineEnd - 1)
            local pipe1 = string.find(line, '|')
            if pipe1 then
                local pipe2 = string.find(line, '|', pipe1 + 1)
                if pipe2 then
                    local module = string.sub(line, 1, pipe1 - 1)
                    local key = string.sub(line, pipe1 + 1, pipe2 - 1)
                    local value = string.sub(line, pipe2 + 1)
                    profile[module] = profile[module] or {}
                    -- check if value contains commas (table/color)
                    if string.find(value, ',') then
                        local tbl = {}
                        local pos = 1
                        while pos <= string.len(value) do
                            local commaPos = string.find(value, ',', pos) or string.len(value) + 1
                            local part = string.sub(value, pos, commaPos - 1)
                            tinsert(tbl, tonumber(part) or part)
                            pos = commaPos + 1
                        end
                        profile[module][key] = tbl
                    else
                        -- convert string to proper type: number, boolean, or string
                        if value == 'true' then
                            profile[module][key] = true
                        elseif value == 'false' then
                            profile[module][key] = false
                        else
                            profile[module][key] = tonumber(value) or value
                        end
                    end
                end
            end
            i = lineEnd + 1
        end
        return profile
    end

    -- lzw compression: reduces string size by finding repeated patterns
    function profileUI:Compress(input)
        if type(input) ~= 'string' then return nil end
        local len = strlen(input)
        if len <= 1 then return 'u' .. input end

        -- initialize dictionary with all single characters (0-255)
        local dict = {}
        for i = 0, 255 do
            local ic, iic = strchar(i), strchar(i, 0)
            dict[ic] = iic
        end

        -- compression variables
        local a, b = 0, 1
        local result = {'c'} -- 'c' = compressed
        local resultlen = 1
        local n = 2
        local word = ''

        -- process each character
        for i = 1, len do
            local c = strsub(input, i, i)
            local wc = word .. c

            -- if pattern not in dictionary, add it
            if not dict[wc] then
                local write = dict[word]
                if not write then return nil end
                result[n] = write
                resultlen = resultlen + strlen(write)
                n = n + 1

                -- if compressed is larger than original, return uncompressed
                if len <= resultlen then return 'u' .. input end

                -- add new pattern to dictionary
                if a >= 256 then
                    a, b = 0, b + 1
                    if b >= 256 then
                        dict = {}
                        b = 1
                    end
                end
                dict[wc] = strchar(a, b)
                a = a + 1
                word = c
            else
                word = wc
            end
        end

        -- write final word
        result[n] = dict[word]
        resultlen = resultlen + strlen(result[n])
        n = n + 1
        if len <= resultlen then return 'u' .. input end
        return table.concat(result)
    end

    -- lzw decompression: reverses compression to restore original string
    function profileUI:Decompress(input)
        if type(input) ~= 'string' or strlen(input) < 1 then return nil end

        -- check compression flag
        local control = strsub(input, 1, 1)
        if control == 'u' then return strsub(input, 2) end -- uncompressed
        if control ~= 'c' then return nil end -- invalid

        input = strsub(input, 2)
        local len = strlen(input)
        if len < 2 then return nil end

        -- rebuild dictionary
        local dict = {}
        for i = 0, 255 do
            local ic, iic = strchar(i), strchar(i, 0)
            dict[iic] = ic
        end

        -- decompression variables
        local a, b = 0, 1
        local result = {}
        local n = 1
        local last = strsub(input, 1, 2)
        result[n] = dict[last]
        n = n + 1

        -- process compressed data
        for i = 3, len, 2 do
            local code = strsub(input, i, i + 1)
            local lastStr = dict[last]
            if not lastStr then return nil end

            local toAdd = dict[code]
            if toAdd then
                -- code exists in dictionary
                result[n] = toAdd
                n = n + 1
                local str = lastStr .. strsub(toAdd, 1, 1)
                if a >= 256 then
                    a, b = 0, b + 1
                    if b >= 256 then
                        dict = {}
                        b = 1
                    end
                end
                dict[strchar(a, b)] = str
                a = a + 1
            else
                -- code not in dictionary, create it
                local str = lastStr .. strsub(lastStr, 1, 1)
                result[n] = str
                n = n + 1
                if a >= 256 then
                    a, b = 0, b + 1
                    if b >= 256 then
                        dict = {}
                        b = 1
                    end
                end
                dict[strchar(a, b)] = str
                a = a + 1
            end
            last = code
        end
        return table.concat(result)
    end

    -- base64 encode: converts binary data to text-safe ascii characters
    -- takes compressed binary data and makes it safe for copy/paste
    function profileUI:Encode(input)
        local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        local bitPattern = ''
        local encoded = ''
        local trailing = ''

        -- convert each byte to 8-bit binary pattern
        for i = 1, string.len(input) do
            local remaining = tonumber(string.byte(string.sub(input, i, i)))
            local binBits = ''
            -- convert byte to binary (8 bits)
            for j = 7, 0, -1 do
                local currentPower = math.pow(2, j)
                if remaining >= currentPower then
                    binBits = binBits .. '1'
                    remaining = remaining - currentPower
                else
                    binBits = binBits .. '0'
                end
            end
            bitPattern = bitPattern .. binBits
        end

        -- add padding if needed (base64 works in groups of 6 bits)
        if math.mod(string.len(bitPattern), 3) == 2 then
            trailing = '=='
            bitPattern = bitPattern .. '0000000000000000'
        elseif math.mod(string.len(bitPattern), 3) == 1 then
            trailing = '='
            bitPattern = bitPattern .. '00000000'
        end

        -- convert every 6 bits to a base64 character, add newline every 92 chars
        local count = 0
        for i = 1, string.len(bitPattern), 6 do
            local byte = string.sub(bitPattern, i, i + 5)
            local offset = tonumber(tonumber(byte, 2))
            encoded = encoded .. string.sub(b64, offset + 1, offset + 1)
            count = count + 1
            -- add newline every 92 characters for readability
            if count >= 92 then
                encoded = encoded .. '\n'
                count = 0
            end
        end

        return string.sub(encoded, 1, -1 - string.len(trailing)) .. trailing
    end

    -- base64 decode: converts text-safe ascii back to binary data
    -- reverses the encoding to restore compressed data
    function profileUI:Decode(input)
        local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        -- remove newlines and spaces
        input = gsub(input, '\n', '')
        input = gsub(input, ' ', '')
        local padded = gsub(input, '%s', '')
        local unpadded = gsub(padded, '=', '')
        local bitPattern = ''
        local decoded = ''

        -- convert each base64 character back to 6-bit binary
        for i = 1, string.len(unpadded) do
            local char = string.sub(input, i, i)
            local offset, _ = string.find(b64, char)
            if offset == nil then return nil end

            local remaining = tonumber(offset - 1)
            local binBits = ''
            -- convert to 8-bit binary (we only use last 6 bits)
            for j = 7, 0, -1 do
                local currentPower = math.pow(2, j)
                if remaining >= currentPower then
                    binBits = binBits .. '1'
                    remaining = remaining - currentPower
                else
                    binBits = binBits .. '0'
                end
            end
            -- take only last 6 bits
            bitPattern = bitPattern .. string.sub(binBits, 3)
        end

        -- convert every 8 bits back to a byte
        for i = 1, string.len(bitPattern), 8 do
            local byte = string.sub(bitPattern, i, i + 7)
            decoded = decoded .. strchar(tonumber(byte, 2))
        end

        -- remove padding bytes
        local paddingLength = string.len(padded) - string.len(unpadded)
        if paddingLength == 1 or paddingLength == 2 then
            decoded = string.sub(decoded, 1, -2)
        end

        return decoded
    end

    function profileUI:ExportProfile(name)
        if not AU_GlobalDB.profiles[name] then return nil end
        local serialized = self:Serialize(AU_GlobalDB.profiles[name])
        local compressed = self:Compress(serialized)
        return self:Encode(compressed)
    end

    function profileUI:ImportProfile(str)
        local decoded = self:Decode(str)
        if not decoded then return nil end
        local decompressed = self:Decompress(decoded)
        if not decompressed then return nil end
        return self:Deserialize(decompressed)
    end

    function profileUI:CreateProfile(name)
        AU_GlobalDB.profiles = AU_GlobalDB.profiles or {}
        AU_GlobalDB.profiles[name] = {}
        for module, defaults in pairs(AU.defaults) do
            AU_GlobalDB.profiles[name][module] = {}
            for option, data in pairs(defaults) do
                AU_GlobalDB.profiles[name][module][option] = data.value
            end
        end
        AU_GlobalDB.meta = AU_GlobalDB.meta or {}
        AU_GlobalDB.meta.profileMeta = AU_GlobalDB.meta.profileMeta or {}
        AU_GlobalDB.meta.profileMeta[name] = {
            created = date('%Y-%m-%d %H:%M'),
            modified = date('%Y-%m-%d %H:%M'),
            description = ''
        }
    end

    function profileUI:DeleteProfile(name)
        AU_GlobalDB.profiles = AU_GlobalDB.profiles or {}
        AU_GlobalDB.profiles[name] = nil
    end

    function profileUI:SwitchProfile(name)
        AU_GlobalDB.profiles = AU_GlobalDB.profiles or {}
        AU.profile = AU_GlobalDB.profiles[name]
        AU_GlobalDB.meta = AU_GlobalDB.meta or {}
        AU_GlobalDB.meta.activeProfile = name
        AU.others.currentProfile = name

        local charName = UnitName('player')
        local realmName = GetRealmName()
        local charKey = charName .. '-' .. realmName
        AU_GlobalDB.meta.characterProfiles = AU_GlobalDB.meta.characterProfiles or {}
        AU_GlobalDB.meta.characterProfiles[charKey] = name

        if self.activityLog then
            self.activityLog:AddMessage('[SWITCH] ' .. name .. ' (' .. tostring(AU.profile) .. ')', {0.6, 1, 0.6})
        end

        for callbackName, callback in pairs(AU.callbacks) do
            local mod, opt = AU.lua.match(callbackName, '(.*)%.(.*)')
            if AU.profile[mod] and AU.profile[mod][opt] ~= nil then
                callback(AU.profile[mod][opt])
            end
        end

        if AU.setups.RestoreFramePositions then
            AU.setups.RestoreFramePositions()
        end
    end

    local callbacks = {}

    AU:NewCallbacks('gui-profiles', callbacks)
end)
