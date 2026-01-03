DRAGONFLIGHT()

DF:NewDefaults('dressup', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('dressup', 1, function()
    local regions = {DressUpFrame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' then
            local texture = region:GetTexture()
            if texture and (string.find(texture, 'UI%-Character') or string.find(texture, 'SkillFrame')) then
                region:Hide()
            end
        end
    end

    DressUpFrameCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_DressUpCustomBg', DressUpFrame, 384, 512, 1)
    customBg:SetPoint('TOPLEFT', DressUpFrame, 'TOPLEFT', 12, -12)
    customBg:SetPoint('BOTTOMRIGHT', DressUpFrame, 'BOTTOMRIGHT', -32, 75)
    customBg:SetFrameLevel(DressUpFrame:GetFrameLevel() -1)
    customBg.Bg:SetDrawLayer('BACKGROUND', -1)
    -- customBg.Bg:SetAlpha(0.8)

    DressUpFramePortrait:SetParent(customBg)
    DressUpFramePortrait:SetDrawLayer('BORDER', 0)

    DressUpFrameDescriptionText:SetParent(customBg)
    DressUpFrameDescriptionText:SetDrawLayer('OVERLAY', 0)

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(DressUpFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    tinsert(UISpecialFrames, 'DF_DressUpCustomBg')

    local callbacks = {}
    DF:NewCallbacks('dressup', callbacks)
end)
