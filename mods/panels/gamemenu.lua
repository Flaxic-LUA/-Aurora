DRAGONFLIGHT()

DF:NewDefaults('gamemenu', {
    version = {value = '1.0'},
    enabled = {value = true},
})

DF:NewModule('gamemenu', 1, function()
    DF.common.KillFrame(GameMenuFrame)

    local frame = DF.ui.CreatePaperDollFrame('DF_GameMenuFrame', UIParent, 225, 480, 3)
    frame:SetPoint('CENTER', 0, 0)
    frame:Hide()
    frame:SetScale(.9)
    frame:EnableMouse(true)
    frame:SetFrameStrata('DIALOG')
    DF.setups.gamemenuBg = frame.Bg

    local yOffset = -50
    local buttonHeight = 22
    local buttonSpacing = 5
    local emptySpacing = 5

    local dfBtn = DF.ui.Button(frame, info.addonNameColor, 160, buttonHeight)
    dfBtn:SetPoint('TOP', frame, 'TOP', 0, yOffset)
    dfBtn:SetScript('OnClick', function()
        frame:Hide()
        DRAGONFLIGHTToggleGUI()
    end)
    yOffset = yOffset - buttonHeight - buttonSpacing * emptySpacing

    local editBtn = DF.ui.Button(frame, 'Edit Mode', 160, buttonHeight)
    editBtn:SetPoint('TOP', frame, 'TOP', 0, yOffset)
    editBtn:SetScript('OnClick', function()
        frame:Hide()
        local editFrame = getglobal('DF_EditModeFrame')
        if editFrame then
            editFrame:Show()
        end
    end)
    yOffset = yOffset - buttonHeight - buttonSpacing

    local addonsBtn = DF.ui.Button(frame, 'Addons', 160, buttonHeight)
    addonsBtn:SetPoint('TOP', frame, 'TOP', 0, yOffset)
    addonsBtn:SetScript('OnClick', function()
        frame:Hide()
        local addonsFrame = getglobal('DF_AddonsFrame')
        if addonsFrame then
            addonsFrame:Show()
        end
    end)
    yOffset = yOffset - buttonHeight - buttonSpacing * emptySpacing

    local soundBtn = DF.ui.Button(frame, 'Sound', 79, buttonHeight)
    soundBtn:SetPoint('TOP', frame, 'TOP', -40.5, yOffset)
    soundBtn:SetScript('OnClick', function()
        frame:Hide()
        ShowUIPanel(SoundOptionsFrame)
    end)

    local videoBtn = DF.ui.Button(frame, 'Video', 79, buttonHeight)
    videoBtn:SetPoint('LEFT', soundBtn, 'RIGHT', -2, 0)
    videoBtn:SetScript('OnClick', function()
        frame:Hide()
        ShowUIPanel(OptionsFrame)
    end)
    yOffset = yOffset - buttonHeight - buttonSpacing

    local uiBtn = DF.ui.Button(frame, 'Interface', 160, buttonHeight)
    uiBtn:SetPoint('TOP', frame, 'TOP', 0, yOffset)
    uiBtn:SetScript('OnClick', function()
        frame:Hide()
        ShowUIPanel(UIOptionsFrame)
    end)
    yOffset = yOffset - buttonHeight - buttonSpacing * emptySpacing

    local keybindsBtn = DF.ui.Button(frame, 'Keybinds', 140, buttonHeight)
    keybindsBtn:SetPoint('TOP', frame, 'TOP', - 10, yOffset)
    keybindsBtn:SetScript('OnClick', function()
        frame:Hide()
        KeyBindingFrame_LoadUI()
        ShowUIPanel(KeyBindingFrame)
    end)

    local hmBtn = DF.ui.Button(frame, '+', 21, buttonHeight, nil, {.9, 0, 0})
    hmBtn:SetPoint('LEFT', keybindsBtn, 'RIGHT', -2, 0)
    hmBtn:SetScript('OnClick', function()
        frame:Hide()
        if DF.setups.hover then
            DF.setups.hover:Show()
        end
    end)
    yOffset = yOffset - buttonHeight - buttonSpacing

    local macrosBtn = DF.ui.Button(frame, 'Macros', 140, buttonHeight)
    macrosBtn:SetPoint('TOP', frame, 'TOP', - 10, yOffset)
    macrosBtn:SetScript('OnClick', function()
        frame:Hide()
        MacroFrame_LoadUI()
        ShowUIPanel(MacroFrame)
    end)

    local macroBtn = DF.ui.Button(frame, '+', 21, buttonHeight, nil, {.9, 0, 0})
    macroBtn:SetPoint('LEFT', macrosBtn, 'RIGHT', -2, 0)
    macroBtn:SetScript('OnClick', function()
        frame:Hide()
        ToggleStackPanel()
    end)
    yOffset = yOffset - buttonHeight - buttonSpacing * emptySpacing

    local rlBtn = DF.ui.Button(frame, 'Reload', 160, buttonHeight)
    rlBtn:SetPoint('TOP', frame, 'TOP', 0, yOffset)
    rlBtn:SetScript('OnClick', function()
        frame:Hide()
        DF.ui.StaticPopup_Show(
            'Reload UI?',
            'Reload',
            function()
                ReloadUI()
            end,
            'Cancel'
        )
    end)
    yOffset = yOffset - buttonHeight - buttonSpacing

    local logoutTimer = 0
    local logoutText = nil
    local exitTimer = 0
    local exitText = nil
    local logoutBtn = DF.ui.Button(frame, 'Logout', 160, buttonHeight, nil, {.9, 0, 0})
    logoutBtn:SetPoint('TOP', frame, 'TOP', 0, yOffset)
    logoutBtn:SetScript('OnClick', function()
        frame:Hide()
        Logout()
        logoutTimer = 20
        DF.ui.StaticPopup_Show('Logging out in 20 seconds...', 'Cancel', function()
            CancelLogout()
            logoutTimer = 0
        end)
        logoutText = DF.ui.staticPopup.bodyText
        DF.ui.staticPopup.frame:SetPoint('TOP', UIParent, 'TOP', 0, -100)
        DF.ui.staticPopup.frame:SetScript('OnHide', function()
            CancelLogout()
            logoutTimer = 0
        end)
    end)
    yOffset = yOffset - buttonHeight - buttonSpacing

    local exitBtn = DF.ui.Button(frame, 'Exit Game', 160, buttonHeight, nil, {.9, 0, 0})
    exitBtn:SetPoint('TOP', frame, 'TOP', 0, yOffset)
    exitBtn:SetScript('OnClick', function()
        frame:Hide()
        exitTimer = 20
        DF.ui.StaticPopup_Show('Exiting in 20 seconds...', 'Exit Now', function()
            ForceQuit()
        end, 'Cancel', function()
            CancelLogout()
            exitTimer = 0
        end)
        exitText = DF.ui.staticPopup.bodyText
        DF.ui.staticPopup.frame:SetPoint('TOP', UIParent, 'TOP', 0, -100)
        DF.ui.staticPopup.frame:SetScript('OnHide', function()
            CancelLogout()
            exitTimer = 0
        end)
        Quit()
    end)
    yOffset = yOffset - buttonHeight - buttonSpacing * emptySpacing

    local returnBtn = DF.ui.Button(frame, 'Return to Game', 160, buttonHeight, nil, {.8, .8, .8})
    returnBtn:SetPoint('TOP', frame, 'TOP', 0, yOffset)
    returnBtn:SetScript('OnClick', function()
        PlaySound('igMainMenuQuit')
        frame:Hide()
    end)

    local creditText = DF.ui.Font(frame, 7, 'made by ' .. info.author, {.7, .7, .7}, 'CENTER')
    creditText:SetPoint('BOTTOM', frame, 'BOTTOM', 33, 5)

    frame:SetScript('OnShow', function()
        local btn = getglobal('DF_MicroButton_MainMenu')
        if btn then btn:SetButtonState('PUSHED', 1) end
        local buttonNames = {'Character', 'Spellbook', 'Talents', 'QuestLog', 'Socials', 'WorldMap', 'Help'}
        for _, name in ipairs(buttonNames) do
            local microBtn = getglobal('DF_MicroButton_' .. name)
            if microBtn then
                microBtn:EnableMouse(nil)
                local normalTex = microBtn:GetNormalTexture()
                if normalTex then normalTex:SetDesaturated(1) end
            end
        end
        local mainBag = getglobal('DF_MainBag')
        if mainBag then
            mainBag:Disable()
            local normalTex = mainBag:GetNormalTexture()
            if normalTex then normalTex:SetDesaturated(1) end
        end
        for i = 0, 3 do
            local smallBag = getglobal('DF_Bag' .. i)
            if smallBag then
                smallBag:Disable()
                if smallBag.icon then
                    smallBag.icon:SetDesaturated(1)
                    smallBag.icon:SetVertexColor(0.5, 0.5, 0.5)
                end
            end
        end
        local keyRing = getglobal('DF_KeyRing')
        if keyRing then keyRing:Disable() end
    end)
    frame:SetScript('OnHide', function()
        local btn = getglobal('DF_MicroButton_MainMenu')
        if btn then btn:SetButtonState('NORMAL') end
        local buttonNames = {'Character', 'Spellbook', 'Talents', 'QuestLog', 'Socials', 'WorldMap', 'Help'}
        for _, name in ipairs(buttonNames) do
            local microBtn = getglobal('DF_MicroButton_' .. name)
            if microBtn then
                microBtn:EnableMouse(1)
                local normalTex = microBtn:GetNormalTexture()
                if normalTex then normalTex:SetDesaturated(nil) end
            end
        end
        local mainBag = getglobal('DF_MainBag')
        if mainBag then
            mainBag:Enable()
            local normalTex = mainBag:GetNormalTexture()
            if normalTex then normalTex:SetDesaturated(nil) end
        end
        for i = 0, 3 do
            local smallBag = getglobal('DF_Bag' .. i)
            if smallBag then
                smallBag:Enable()
                if smallBag.icon then
                    smallBag.icon:SetDesaturated(nil)
                    smallBag.icon:SetVertexColor(1, 1, 1)
                end
            end
        end
        local keyRing = getglobal('DF_KeyRing')
        if keyRing then keyRing:Enable() end
    end)

    _G.ToggleGameMenu = function()
        if StaticPopup_EscapePressed() then
            return
        elseif frame:IsVisible() then
            PlaySound('igMainMenuQuit')
            frame:Hide()
        else
            local closedMenus = CloseMenus()
            local closedWindows = CloseAllWindows()
            if not (closedMenus or closedWindows) then
                if UnitExists('target') then
                    ClearTarget()
                else
                    PlaySound('igMainMenuOpen')
                    frame:Show()
                end
            end
        end
    end

    UIPanelWindows['DF_GameMenuFrame'] = {area = 'center', pushable = 0, whileDead = 1}

    local origShowUIPanel = ShowUIPanel
    _G.ShowUIPanel = function(frm, force)
        if frame:IsVisible() and not force then
            return
        end
        if frm == GameMenuFrame then
            return
        end
        return origShowUIPanel(frm, force)
    end

    local origStaticPopup_Show = StaticPopup_Show
    _G.StaticPopup_Show = function(which, a1, a2, a3, a4, a5)
        if which == 'CAMP' or which == 'QUIT' then
            return
        end
        return origStaticPopup_Show(which, a1, a2, a3, a4, a5)
    end

    local lastUpdate = 0
    local updateFrame = CreateFrame('Frame')
    updateFrame:SetScript('OnUpdate', function()
        if logoutTimer > 0 then
            logoutTimer = logoutTimer - arg1
            lastUpdate = lastUpdate + arg1
            if logoutTimer <= 0 then
                logoutTimer = 0
                DF.ui.StaticPopup_Hide()
            elseif lastUpdate >= 0.1 and logoutText then
                lastUpdate = 0
                logoutText:SetText('Logging out in ' .. math.ceil(logoutTimer) .. ' seconds...')
            end
        end
        if exitTimer > 0 then
            exitTimer = exitTimer - arg1
            lastUpdate = lastUpdate + arg1
            if exitTimer <= 0 then
                exitTimer = 0
                DF.ui.StaticPopup_Hide()
            elseif lastUpdate >= 0.1 and exitText then
                lastUpdate = 0
                exitText:SetText('Exiting in ' .. math.ceil(exitTimer) .. ' seconds...')
            end
        end
    end)

    -- callbacks
    local helpers = {}
    local callbacks = {}


    DF:NewCallbacks('gamemenu', callbacks)
end)
