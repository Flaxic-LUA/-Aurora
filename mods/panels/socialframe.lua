DRAGONFLIGHT()

DF:NewDefaults('socialframe', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('socialframe', 1, 'PLAYER_ENTERING_WORLD', function()
    FriendsFrameTopLeft:Hide()
    FriendsFrameTopRight:Hide()
    FriendsFrameBottomLeft:Hide()
    FriendsFrameBottomRight:Hide()

    FriendsFrameTab1:Hide()
    FriendsFrameTab2:Hide()
    FriendsFrameTab3:Hide()
    FriendsFrameTab4:Hide()
    FriendsFrameCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_FriendsCustomBg', FriendsFrame, 384, 512, 1)
    customBg:SetPoint('TOPLEFT', FriendsFrame, 'TOPLEFT', 12, -12)
    customBg:SetPoint('BOTTOMRIGHT', FriendsFrame, 'BOTTOMRIGHT', -32, 75)
    customBg:SetFrameLevel(FriendsFrame:GetFrameLevel() + 1)
    customBg.Bg:SetDrawLayer('BACKGROUND', -1)
    DF.setups.socialBg = customBg.Bg
    -- customBg.Bg:SetVertexColor(0, 0, 0, .5)

    local regions = {FriendsFrame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' then
            local texture = region:GetTexture()
            if texture and string.find(texture, 'FriendsFrameScrollIcon') then
                region:SetParent(customBg)
                region:SetDrawLayer('BORDER', 0)
                break
            end
        end
    end

    local friendsBg = customBg:CreateTexture(nil, 'BORDER')
    friendsBg:SetTexture('Interface\\Buttons\\WHITE8X8')
    friendsBg:SetPoint('TOPLEFT', customBg, 'TOPLEFT', 8, -60)
    friendsBg:SetPoint('BOTTOMRIGHT', customBg, 'BOTTOMRIGHT', -8, 55)
    friendsBg:SetVertexColor(0, 0, 0, .3)
    friendsBg:Hide()

    local whoBg = WhoFrameEditBox:CreateTexture(nil, 'BACKGROUND')
    whoBg:SetTexture('Interface\\Buttons\\WHITE8X8')
    whoBg:SetPoint('TOPLEFT', WhoFrameEditBox, 'TOPLEFT', -1, -7)
    whoBg:SetPoint('BOTTOMRIGHT', WhoFrameEditBox, 'BOTTOMRIGHT', 15, 5)
    whoBg:SetVertexColor(0, 0, 0, .5)
    whoBg:Hide()

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(FriendsFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(FriendsFrame:GetFrameLevel() + 3)

    local guildTab
    customBg:AddTab('Friends', function()
        friendsBg:Show()
        whoBg:Hide()
        FriendsFrame.selectedTab = 1
        FriendsFrame_ShowSubFrame('FriendsListFrame')
        PanelTemplates_SetTab(FriendsFrame, 1)
        FriendsFrame_Update()
    end, 70)

    customBg:AddTab('Who', function()
        friendsBg:Hide()
        whoBg:Show()
        FriendsFrame.selectedTab = 2
        FriendsFrame_ShowSubFrame('WhoFrame')
        PanelTemplates_SetTab(FriendsFrame, 2)
        FriendsFrame_Update()
    end, 60)

    guildTab = customBg:AddTab('Guild', function()
        friendsBg:Hide()
        whoBg:Hide()
        FriendsFrame.selectedTab = 3
        FriendsFrame_ShowSubFrame('GuildFrame')
        PanelTemplates_SetTab(FriendsFrame, 3)
        FriendsFrame_Update()
    end, 60)

    local function UpdateGuildTab()
        if IsInGuild() then
            guildTab:Enable()
        else
            guildTab:Disable()
        end
    end
    UpdateGuildTab()

    DF.hooks.HookScript(FriendsFrame, 'OnShow', function()
        UpdateGuildTab()
        local tabIndex = FriendsFrame.selectedTab or 1
        local selectedTab = customBg.Tabs[tabIndex]
        if selectedTab then
            selectedTab:GetScript('OnClick')()
        end
    end)

    customBg:AddTab('Raid', function()
        friendsBg:Hide()
        whoBg:Hide()
        FriendsFrame.selectedTab = 4
        FriendsFrame_ShowSubFrame('RaidFrame')
        PanelTemplates_SetTab(FriendsFrame, 4)
        FriendsFrame_Update()
    end, 60)

    tinsert(UISpecialFrames, 'DF_FriendsCustomBg')

    local originalToggleFriendsFrame = _G.ToggleFriendsFrame
    _G.ToggleFriendsFrame = function(tab)
        originalToggleFriendsFrame(tab)
        if FriendsFrame:IsVisible() and customBg.Tabs then
            local tabIndex = tab or 1
            local selectedTab = customBg.Tabs[tabIndex]
            if selectedTab then
                selectedTab:GetScript('OnClick')()
            end
        end
    end

    -- callbacks
    local callbacks = {}
    DF:NewCallbacks('socialframe', callbacks)
end)
