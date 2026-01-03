DRAGONFLIGHT()

DF:NewDefaults('bank', {
    version = {value = '1.0'},
    enabled = {value = true},
})

DF:NewModule('bank', 1, 'PLAYER_ENTERING_WORLD', function()
    local regions = {BankFrame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' and region ~= BankPortraitTexture then
            region:Hide()
        end
    end

    BankCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_BankCustomBg', BankFrame, 370, 435, 1)
    customBg:SetPoint('TOPLEFT', BankFrame, 'TOPLEFT', 5, 0)
    customBg:SetFrameLevel(BankFrame:GetFrameLevel() - 1)
    customBg.Bg:SetDrawLayer('BACKGROUND', -1)

    BankPortraitTexture:SetParent(customBg)
    BankPortraitTexture:ClearAllPoints()
    BankPortraitTexture:SetPoint('TOPLEFT', customBg, 'TOPLEFT', -5, 7)
    BankPortraitTexture:SetDrawLayer('BORDER', 0)

    BankFrameTitleText:ClearAllPoints()
    BankFrameTitleText:SetPoint('CENTER', customBg, 'TOP', 0, -10)

    local textures = {
        border = media['tex:actionbars:btn_border.blp'],
        highlight = media['tex:actionbars:btn_highlight_strong.blp'],
        bgTexture = media['tex:actionbars:HDActionBarBtn.tga']
    }

    for i = 1, 24 do
        local btn = getglobal('BankFrameItem'..i)
        if btn then
            local icon = getglobal('BankFrameItem'..i..'IconTexture')
            if icon then
                btn.bg = btn:CreateTexture(nil, 'BACKGROUND')
                btn.bg:SetTexture(textures.bgTexture)
                btn.bg:SetAllPoints(btn)
                btn.bg:SetVertexColor(1, 1, 1, 1)
                icon:SetDrawLayer('BORDER')

                local border = btn:CreateTexture(nil, 'ARTWORK')
                border:SetTexture(textures.border)
                border:SetAllPoints(btn)

                local highlight = btn:CreateTexture(nil, 'HIGHLIGHT')
                highlight:SetTexture(textures.highlight)
                highlight:SetPoint('TOPLEFT', btn, 'TOPLEFT', -4, 4)
                highlight:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', 4, -4)
            end
        end
    end

    for i = 1, 6 do
        local btn = getglobal('BankFrameBag'..i)
        if btn then
            local icon = getglobal('BankFrameBag'..i..'IconTexture')
            if icon then
                icon:SetDrawLayer('BORDER')

                local border = btn:CreateTexture(nil, 'ARTWORK')
                border:SetTexture(textures.border)
                border:SetAllPoints(btn)

                local highlight = btn:CreateTexture(nil, 'HIGHLIGHT')
                highlight:SetTexture(textures.highlight)
                highlight:SetPoint('TOPLEFT', btn, 'TOPLEFT', -4, 4)
                highlight:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', 4, -4)
            end
        end
    end

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() CloseBankFrame() end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    local callbacks = {}
    DF:NewCallbacks('bank', callbacks)
end)
