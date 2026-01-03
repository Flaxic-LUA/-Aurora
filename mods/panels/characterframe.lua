DRAGONFLIGHT()

DF:NewDefaults('characterframe', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('characterframe', 1,'PLAYER_ENTERING_WORLD',function()
    local frames = {PaperDollFrame, PetPaperDollFrame, SkillFrame, ReputationFrame, HonorFrame}

    for _, frame in frames do
        if frame then
            local regions = {frame:GetRegions()}
            for i = 1, table.getn(regions) do
                local region = regions[i]
                if region:GetObjectType() == 'Texture' then
                    local texture = region:GetTexture()
                    if texture and (string.find(texture, 'UI-Character-') or string.find(texture, 'PaperDoll')) then
                        region:Hide()
                    end
                end
            end
        end
    end

    CharacterFrameTab1:Hide()
    CharacterFrameTab2:Hide()
    CharacterFrameTab3:Hide()
    CharacterFrameTab4:Hide()
    CharacterFrameTab5:Hide()
    CharacterFrameCloseButton:Hide()

    _G.PetTab_Update = function() end

    local customBg = DF.ui.CreatePaperDollFrame('DF_CharacterCustomBg', CharacterFrame, 384, 512, 1)
    customBg:SetPoint('TOPLEFT', CharacterFrame, 'TOPLEFT', 12, -12)
    customBg:SetPoint('BOTTOMRIGHT', CharacterFrame, 'BOTTOMRIGHT', -32, 75)
    customBg:SetFrameLevel(CharacterFrame:GetFrameLevel() + 1)
    customBg.Bg:SetDrawLayer('BACKGROUND', -1)
    CharacterFramePortrait:SetParent(customBg)
    CharacterFramePortrait:SetDrawLayer('BORDER', 0)

    DF.setups.characterBg = customBg.Bg

    local characterBg = customBg:CreateTexture(nil, 'OVERLAY')
    characterBg:SetTexture('Interface\\Buttons\\WHITE8X8')
    characterBg:SetPoint('TOPLEFT', customBg, 'TOPLEFT', 55, -60)
    characterBg:SetPoint('BOTTOMRIGHT', customBg, 'BOTTOMRIGHT', -55, 60)
    characterBg:SetVertexColor(0, 0, 0, .3)
    characterBg:Hide()
    DF.setups.characterBgTexture = characterBg
    DF.setups.characterModel = CharacterModelFrame

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(CharacterFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    customBg:AddTab('Character', function()
        characterBg:Show()
        CharacterFrame_ShowSubFrame('PaperDollFrame')
        PanelTemplates_SetTab(CharacterFrame, 1)
    end, 70)

    local petTab = customBg:AddTab('Pet', function()
        characterBg:Hide()
        CharacterFrame_ShowSubFrame('PetPaperDollFrame')
        PanelTemplates_SetTab(CharacterFrame, 2)
    end, 55)

    customBg:AddTab('Reputation', function()
        characterBg:Hide()
        CharacterFrame_ShowSubFrame('ReputationFrame')
        PanelTemplates_SetTab(CharacterFrame, 3)
    end, 75)

    function customBg:UpdatePetTab()
        if HasPetUI() then
            petTab:Show()
        else
            petTab:Hide()
            if customBg.Tabs[3] then
                customBg.Tabs[3]:ClearAllPoints()
                customBg.Tabs[3]:SetPoint('BOTTOMLEFT', customBg.Tabs[1], 'BOTTOMRIGHT', 2, 0)
            end
        end
        if HasPetUI() and customBg.Tabs[3] then
            customBg.Tabs[3]:ClearAllPoints()
            customBg.Tabs[3]:SetPoint('BOTTOMLEFT', petTab, 'BOTTOMRIGHT', 2, 0)
        end
    end

    customBg:AddTab('Skills', function()
        characterBg:Hide()
        CharacterFrame_ShowSubFrame('SkillFrame')
        PanelTemplates_SetTab(CharacterFrame, 4)
    end, 55)

    customBg:AddTab('Honor', function()
        characterBg:Hide()
        CharacterFrame_ShowSubFrame('HonorFrame')
        PanelTemplates_SetTab(CharacterFrame, 5)
    end, 55)

    customBg:RegisterEvent('PET_UI_UPDATE')
    customBg:RegisterEvent('PET_BAR_UPDATE')
    customBg:RegisterEvent('UNIT_PET')
    customBg:SetScript('OnEvent', function()
        if event == 'PET_UI_UPDATE' or event == 'PET_BAR_UPDATE' or (event == 'UNIT_PET' and arg1 == 'player') then
            customBg:UpdatePetTab()
        end
    end)

    customBg:UpdatePetTab()

    tinsert(UISpecialFrames, 'DF_CharacterCustomBg')

    local originalToggleCharacter = _G.ToggleCharacter
    _G.ToggleCharacter = function(tab)
        originalToggleCharacter(tab)
        if CharacterFrame:IsVisible() and customBg.Tabs then
            local tabIndex = nil
            local hasPet = HasPetUI()

            if tab == 'PaperDollFrame' then
                tabIndex = 1
            elseif tab == 'PetPaperDollFrame' and hasPet then
                tabIndex = 2
            elseif tab == 'ReputationFrame' then
                tabIndex = hasPet and 3 or 2
            elseif tab == 'SkillFrame' then
                tabIndex = hasPet and 4 or 3
            elseif tab == 'HonorFrame' then
                tabIndex = hasPet and 5 or 4
            end

            local selectedTab = customBg.Tabs[tabIndex]
            if selectedTab then
                selectedTab:GetScript('OnClick')()
            end
        end
    end

    local slots = {'Head', 'Neck', 'Shoulder', 'Shirt', 'Chest', 'Waist', 'Legs', 'Feet', 'Wrist', 'Hands', 'Finger0', 'Finger1', 'Trinket0', 'Trinket1', 'Back', 'MainHand', 'SecondaryHand', 'Ranged', 'Tabard', 'Ammo'}
    for _, slot in slots do
        local button = getglobal('Character' .. slot .. 'Slot')
        if button then
            local icon = getglobal('Character' .. slot .. 'SlotIconTexture')
            if icon then
                local highlight = button:CreateTexture(nil, 'HIGHLIGHT')
                highlight:SetPoint('TOPLEFT', icon, 'TOPLEFT', -6, 6)
                highlight:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT', 6, -6)
                highlight:SetTexture(media['tex:actionbars:btn_highlight_strong.blp'])
                highlight:SetBlendMode('ADD')
                button:SetHighlightTexture(highlight)
            end
        end
    end

    -- callbacks
    local callbacks = {}
    local callbackHelper = {definesomethinginheredirectly}

    DF:NewCallbacks('characterframe', callbacks)
end)
