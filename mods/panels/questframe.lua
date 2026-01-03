DRAGONFLIGHT()

DF:NewDefaults('questframe', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('questframe', 1, function()
    local frames = {QuestFrameDetailPanel, QuestFrameProgressPanel, QuestFrameRewardPanel, QuestFrameGreetingPanel, QuestFrame}
    for _, frame in frames do
        if frame then
            local regions = {frame:GetRegions()}
            for i = 1, table.getn(regions) do
                local region = regions[i]
                if region:GetObjectType() == 'Texture' then
                    local texture = region:GetTexture()
                    if texture and (string.find(texture, 'Quest') or string.find(texture, 'UI-DialogBox')) then
                        region:Hide()
                    end
                end
            end
        end
    end

    QuestFrameCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_QuestCustomBg', QuestFrame, 384, 512, 1)
    customBg:SetPoint('TOPLEFT', QuestFrame, 'TOPLEFT', 12, -12)
    customBg:SetPoint('BOTTOMRIGHT', QuestFrame, 'BOTTOMRIGHT', -32, 70)
    customBg:SetFrameLevel(QuestFrame:GetFrameLevel() - 1)

    local topWood = customBg:CreateTexture(nil, 'BORDER')
    topWood:SetTexture(media['tex:panels:spellbook_top_wood.blp'])
    topWood:SetPoint('TOPLEFT', customBg, 'TOPLEFT', 0, -10)
    topWood:SetPoint('RIGHT', customBg, 'RIGHT', 0, -60)
    topWood:SetSize(customBg:GetWidth()-10, 64)

    QuestFramePortrait:SetParent(customBg)
    QuestFramePortrait:SetDrawLayer('ARTWORK', 0)
    QuestFramePortrait:ClearAllPoints()
    QuestFramePortrait:SetPoint('TOPLEFT', customBg, 'TOPLEFT', -4, 7)

    local rightBg = customBg:CreateTexture(nil, 'ARTWORK')
    rightBg:SetTexture(media['tex:panels:questlog_right_bg.blp'])
    rightBg:SetPoint('TOPLEFT', customBg, 'TOPLEFT', 5, -70)
    rightBg:SetPoint('BOTTOMRIGHT', customBg, 'BOTTOMRIGHT', -24, -130)

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(QuestFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    if QuestFrameNpcNameText then
        QuestFrameNpcNameText:ClearAllPoints()
        QuestFrameNpcNameText:SetPoint('TOP', customBg, 'TOP', 0, -2)
        QuestFrameCompleteButton:ClearAllPoints()
        QuestFrameCompleteButton:SetPoint('BOTTOMLEFT', customBg, 'BOTTOMLEFT', 4, 3)
        QuestFrameCompleteQuestButton:ClearAllPoints()
        QuestFrameCompleteQuestButton:SetPoint('BOTTOMLEFT', customBg, 'BOTTOMLEFT', 4, 3)
    end

    tinsert(UISpecialFrames, 'DF_QuestCustomBg')

    local callbacks = {}
    DF:NewCallbacks('questframe', callbacks)
end)
