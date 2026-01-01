UNLOCKDRAGONFLIGHT()

function DF.mixins.pfQuestButtons(mainFrame)
    if not DF.others.pfQuest then return end

    local bg = mainFrame:CreateTexture(nil, 'BACKGROUND')
    bg:SetTexture(media['tex:generic:distance_bg.blp'])
    bg:SetPoint('BOTTOMLEFT', mainFrame, 'TOPRIGHT', -75, -3)
    bg:SetPoint('TOPRIGHT', mainFrame, 'TOPRIGHT', -5, 20)
    bg:SetVertexColor(0, 0, 0, 0.1)

    local textures = {'configbtn', 'sellbtn', 'searchbtn'}
    local pfButtons = {}
    for i = 1, 3 do
        local btn = CreateFrame('Button', nil, mainFrame)
        btn:SetSize(16, 16)
        btn:SetPoint('BOTTOMRIGHT', mainFrame, 'TOPRIGHT', -((i-1)*18)-15, 0)

        local tex = btn:CreateTexture(nil, 'ARTWORK')
        tex:SetPoint('TOPLEFT', btn, 'TOPLEFT', -5, 5)
        tex:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', 5, -5)
        tex:SetTexture(media['tex:bags:' .. textures[i] .. '.blp'])
        btn.tex = tex

        local highlight = btn:CreateTexture(nil, 'HIGHLIGHT')
        highlight:SetPoint('TOPLEFT', btn, 'TOPLEFT', -5, 5)
        highlight:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', 5, -5)
        highlight:SetTexture(media['tex:bags:' .. textures[i] .. '.blp'])
        highlight:SetBlendMode('ADD')

        pfButtons[i] = btn
    end

    pfButtons[1]:SetScript('OnClick', function()
        if pfQuestConfig then pfQuestConfig:Show() end
    end)
    pfButtons[1]:SetScript('OnEnter', function()
        GameTooltip:SetOwner(pfButtons[1], 'ANCHOR_LEFT')
        GameTooltip:SetText('Open pfConfig', 1, 1, 1)
        GameTooltip:Show()
    end)
    pfButtons[1]:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)

    pfButtons[2]:SetScript('OnClick', function()
        if pfMap then pfMap:DeleteNode('PFDB') pfMap:UpdateNodes() end
    end)
    pfButtons[2]:SetScript('OnEnter', function()
        GameTooltip:SetOwner(pfButtons[2], 'ANCHOR_LEFT')
        GameTooltip:SetText('Clear Waypoints', 1, 1, 1)
        GameTooltip:Show()
    end)
    pfButtons[2]:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)

    pfButtons[3]:SetScript('OnClick', function()
        if pfBrowser then pfBrowser:Show() end
    end)
    pfButtons[3]:SetScript('OnEnter', function()
        GameTooltip:SetOwner(pfButtons[3], 'ANCHOR_LEFT')
        GameTooltip:SetText('Open pfBrowser', 1, 1, 1)
        GameTooltip:Show()
    end)
    pfButtons[3]:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)
end
