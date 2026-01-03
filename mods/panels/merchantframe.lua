DRAGONFLIGHT()

DF:NewDefaults('merchantframe', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('merchantframe', 1, function()
    local regions = {MerchantFrame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' then
            local texture = region:GetTexture()
            if texture and string.find(texture, 'Merchant') then
                region:Hide()
            end
        end
    end

    MerchantFrameTab1:Hide()
    MerchantFrameTab2:Hide()
    MerchantFrameCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_MerchantCustomBg', MerchantFrame, 384, 512, 1)
    customBg:SetPoint('TOPLEFT', MerchantFrame, 'TOPLEFT', 12, -12)
    customBg:SetPoint('BOTTOMRIGHT', MerchantFrame, 'BOTTOMRIGHT', -32, 55)
    customBg:SetFrameLevel(MerchantFrame:GetFrameLevel() - 1)
    DF.setups.merchantBg = customBg.Bg

    MerchantFramePortrait:SetParent(customBg)
    MerchantFramePortrait:SetDrawLayer('BORDER', 0)
    MerchantFramePortrait:ClearAllPoints()
    MerchantFramePortrait:SetPoint('TOPLEFT', customBg, 'TOPLEFT', -4, 8)

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(MerchantFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    customBg:AddTab('Merchant', function()
        PanelTemplates_SetTab(MerchantFrame, 1)
        MerchantFrame_Update()
    end, 70)

    customBg:AddTab('Buyback', function()
        PanelTemplates_SetTab(MerchantFrame, 2)
        MerchantFrame_Update()
    end, 70)

    tinsert(UISpecialFrames, 'DF_MerchantCustomBg')

    local merchantCloseFrame = CreateFrame('Frame')
    merchantCloseFrame:RegisterEvent('MERCHANT_CLOSED')
    merchantCloseFrame:SetScript('OnEvent', function()
        if event == 'MERCHANT_CLOSED' then
            local setup = DF.setups.bags
            if setup then
                local oneBagMode = DF_Profiles and DF.profile['bags'] and DF.profile['bags']['oneBagMode']
                if oneBagMode then
                    if setup.unified and setup.unified:IsShown() then
                        setup.unified:Hide()
                    end
                else
                    for i = 0, 4 do
                        if setup[i] and setup[i]:IsShown() then
                            setup[i]:Hide()
                        end
                    end
                end
            end
        end
    end)

    local callbacks = {}
    DF:NewCallbacks('merchantframe', callbacks)
end)
