DRAGONFLIGHT()

DF:NewDefaults('mail', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('mail', 1, function()
    local regions = {MailFrame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' then
            local texture = region:GetTexture()
            if texture and (string.find(texture, 'UI%-ItemText') or string.find(texture, 'UI%-Spellbook') or string.find(texture, 'UI%-ClassTrainer')) then
                region:Hide()
            end
        end
    end

    MailFrameTab1:Hide()
    MailFrameTab2:Hide()
    InboxCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_MailCustomBg', MailFrame, 384, 512, 1)
    customBg:SetPoint('TOPLEFT', MailFrame, 'TOPLEFT', 12, -12)
    customBg:SetPoint('BOTTOMRIGHT', MailFrame, 'BOTTOMRIGHT', -32, 75)
    customBg.Bg:SetDrawLayer('BACKGROUND', -1)

    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' then
            local texture = region:GetTexture()
            if texture and string.find(texture, 'Mail%-Icon') then
                region:SetParent(customBg)
                region:SetDrawLayer('BORDER', 0)
                break
            end
        end
    end

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(MailFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    customBg:AddTab('Inbox', function()
        MailFrameTab_OnClick(1)
    end, 60)

    customBg:AddTab('Send Mail', function()
        MailFrameTab_OnClick(2)
    end, 75)

    tinsert(UISpecialFrames, 'DF_MailCustomBg')

    local callbacks = {}
    DF:NewCallbacks('mail', callbacks)
end)
