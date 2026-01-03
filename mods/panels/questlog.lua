DRAGONFLIGHT()

DF:NewDefaults('questlog', {
    version = {value = '1.0'},
    enabled = {value = true},
})

DF:NewModule('questlog', 1, function()
    local regions = {QuestLogFrame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' then
            local texture = region:GetTexture()
            if texture and string.find(texture, 'QuestLog') and not string.find(texture, 'Highlight') and not string.find(texture, 'Check') then
                region:Hide()
            end
        end
    end
    QuestLogFrameCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_QuestLogCustomBg', QuestLogFrame, 384, 400, 1)
    customBg:SetPoint('TOPLEFT', QuestLogFrame, 'TOPLEFT', 12, -12)
    customBg:SetPoint('BOTTOMRIGHT', QuestLogFrame, 'BOTTOMRIGHT', -91, 50)
    customBg:SetFrameLevel(QuestLogFrame:GetFrameLevel() - 1)
    DF.setups.questlogBg = customBg.Bg

    tinsert(UISpecialFrames, 'DF_QuestLogCustomBg')

    local topWood = customBg:CreateTexture(nil, 'BORDER')
    topWood:SetTexture(media['tex:panels:spellbook_top_wood.blp'])
    topWood:SetPoint('TOPLEFT', customBg, 'TOPLEFT', 0, -10)
    topWood:SetPoint('RIGHT', customBg, 'RIGHT', 0, -60)
    topWood:SetSize(customBg:GetWidth()-10, 64)

    local bookIcon = customBg:CreateTexture(nil, 'ARTWORK')
    bookIcon:SetTexture('Interface\\QuestFrame\\UI-QuestLog-BookIcon')
    bookIcon:SetPoint('TOPLEFT', customBg, 'TOPLEFT', -3, 6)
    bookIcon:SetSize(56, 56)

    local leftBg = customBg:CreateTexture(nil, 'ARTWORK')
    leftBg:SetTexture(media['tex:panels:questlog_left_bg.blp'])
    leftBg:SetPoint('TOPLEFT', customBg, 'TOPLEFT', 1, -60)
    leftBg:SetPoint('BOTTOM', customBg, 'BOTTOM', 0, -310)
    leftBg:SetPoint('RIGHT', customBg, 'CENTER', -0, 0)

    local rightBg = customBg:CreateTexture(nil, 'ARTWORK')
    rightBg:SetTexture(media['tex:panels:questlog_right_bg.blp'])
    rightBg:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', -25, -60)
    rightBg:SetPoint('BOTTOM', customBg, 'BOTTOM', 0, -173)
    rightBg:SetPoint('LEFT', customBg, 'CENTER', 0, 0)

    local bookmark = customBg:CreateTexture(nil, 'OVERLAY')
    bookmark:SetTexture(media['tex:panels:spellbook_bookmark.blp'])
    bookmark:SetPoint('TOP', customBg, 'TOP', 7, -55)
    bookmark:SetSize(50, 400)

    DF.setups.questlogTopWood = topWood
    DF.setups.questlogLeftBg = leftBg
    DF.setups.questlogRightBg = rightBg
    DF.setups.questlogBookmark = bookmark

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(QuestLogFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    for i = 1, 10 do
        local item = getglobal('QuestLogItem' .. i)
        if item then
            local icon = getglobal('QuestLogItem' .. i .. 'IconTexture')
            if icon then
                local highlight = item:CreateTexture(nil, 'HIGHLIGHT')
                -- highlight:SetSize(39, 39)
                highlight:SetPoint('TOPLEFT', icon, 'TOPLEFT', -6, 6)
                highlight:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT', 6, -6)
                highlight:SetTexture(media['tex:actionbars:btn_highlight_strong.blp'])
                highlight:SetBlendMode('ADD')
                item:SetHighlightTexture(highlight)
            end
        end
    end

    -- callbacks
    local helpers = {}
    local callbacks = {}

    DF:NewCallbacks('questlog', callbacks)
end)
