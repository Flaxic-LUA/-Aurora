DRAGONFLIGHT()

DF:NewDefaults('mailopen', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('mailopen', 1, function()
    local regions = {OpenMailFrame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' then
            local texture = region:GetTexture()
            if texture and (string.find(texture, 'UI%-ClassTrainer') or string.find(texture, 'UI%-OpenMail')) then
                region:Hide()
            end
        end
    end

    OpenMailCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_OpenMailCustomBg', OpenMailFrame, 384, 512, 1)
    customBg:SetPoint('TOPLEFT', OpenMailFrame, 'TOPLEFT', 12, -12)
    customBg:SetPoint('BOTTOMRIGHT', OpenMailFrame, 'BOTTOMRIGHT', -32, 75)
    customBg:SetFrameLevel(OpenMailFrame:GetFrameLevel())
    customBg.Bg:SetDrawLayer('BACKGROUND', -1)

    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' then
            local texture = region:GetTexture()
            if texture and string.find(texture, 'Mail%-Icon') then
                region:SetParent(customBg)
                region:SetDrawLayer('BORDER', 0)
                region:ClearAllPoints()
                region:SetPoint('TOPLEFT', customBg, 'TOPLEFT', -5, 7)
                break
            end
        end
    end

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(OpenMailFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    tinsert(UISpecialFrames, 'DF_OpenMailCustomBg')

    local callbacks = {}
    DF:NewCallbacks('mailopen', callbacks)
end)
