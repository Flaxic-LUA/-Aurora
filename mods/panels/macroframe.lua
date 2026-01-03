DRAGONFLIGHT()

DF:NewDefaults('macros', {
    version = {value = '1.0'},
    enabled = {value = true},
})

DF:NewModule('macros', 1, function()
    local skinned = false

    local function SkinMacroFrame()
        if skinned or not MacroFrame then return end
        skinned = true

        local regions = {MacroFrame:GetRegions()}
        for i = 1, table.getn(regions) do
            local region = regions[i]
            if region:GetObjectType() == 'Texture' then
                local texture = region:GetTexture()
                if texture and (string.find(texture, 'MacroFrame') or string.find(texture, 'UI-Character-') or string.find(texture, 'ClassTrainer') or string.find(texture, 'PaperDollInfoFrame')) then
                    region:Hide()
                end
            end
        end
        if MacroFrameCloseButton then MacroFrameCloseButton:Hide() end
        if MacroFrameTab then MacroFrameTab:Hide() end

        local customBg = DF.ui.CreatePaperDollFrame('DF_MacroCustomBg', MacroFrame, 384, 512, 2)
        customBg:SetPoint('TOPLEFT', MacroFrame, 'TOPLEFT', 12, -12)
        customBg:SetPoint('BOTTOMRIGHT', MacroFrame, 'BOTTOMRIGHT', -32, 75)
        customBg:SetFrameLevel(MacroFrame:GetFrameLevel() - 1)
        customBg.Bg:SetDrawLayer('BACKGROUND', -5)
        DF.setups.macroBg = customBg.Bg
        if DF.profile and DF.profile.UIParent and DF.profile.UIParent.macroBgAlpha then
            customBg.Bg:SetAlpha(DF.profile.UIParent.macroBgAlpha)
        end
        if DF.profile and DF.profile.UIParent and DF.profile.UIParent.macroScale then
            customBg:SetScale(DF.profile.UIParent.macroScale)
            MacroFrame:SetScale(DF.profile.UIParent.macroScale)
        end
        -- customBg.Bg:SetTexture(0, 0, 0, 1)
        MacroFramePortrait:SetParent(customBg)
        MacroFramePortrait:SetDrawLayer('OVERLAY', 0)

        local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(MacroFrame) end)
        closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
        closeButton:SetSize(20, 20)
        closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

        for i = 1, 18 do
            local button = getglobal('MacroButton' .. i)
            if button then
                local icon = getglobal('MacroButton' .. i .. 'Icon')
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

        local selectedButton = MacroFrameSelectedMacroButton
        if selectedButton then
            local icon = MacroFrameSelectedMacroButtonIcon
            if icon then
                local highlight = selectedButton:CreateTexture(nil, 'HIGHLIGHT')
                highlight:SetPoint('TOPLEFT', icon, 'TOPLEFT', -6, 6)
                highlight:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT', 6, -6)
                highlight:SetTexture(media['tex:actionbars:btn_highlight_strong.blp'])
                highlight:SetBlendMode('ADD')
                selectedButton:SetHighlightTexture(highlight)
            end
        end

        tinsert(UISpecialFrames, 'DF_MacroCustomBg')
    end

    local frame = CreateFrame('Frame')
    frame:RegisterEvent('ADDON_LOADED')
    frame:SetScript('OnEvent', function()
        if arg1 == 'Blizzard_MacroUI' then
            SkinMacroFrame()
        end
    end)

    if MacroFrame then
        SkinMacroFrame()
    end

    -- callbacks
    local helpers = {}
    local callbacks = {}

    DF:NewCallbacks('macros', callbacks)
end)
