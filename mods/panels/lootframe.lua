DRAGONFLIGHT()

DF:NewDefaults('lootframe', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'loot', 'General'},
    },
    positionAtMouse = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Position loot frame at mouse cursor'}},
    lootBgAlpha = {value = 1, metadata = {element = 'slider', category = 'General', indexInCategory = 2, description = 'Loot frame background transparency', min = 0, max = 1, stepSize = 0.1}},
    lootScale = {value = 1, metadata = {element = 'slider', category = 'General', indexInCategory = 3, description = 'Loot frame scale', min = 0.5, max = 1.5, stepSize = 0.05}},
})

DF:NewModule('lootframe', 1, function()
    local regions = {LootFrame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' and region ~= LootFramePortraitOverlay then
            region:Hide()
        end
    end

    LootCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_LootCustomBg', LootFrame, 256, 256, 1)
    customBg:SetPoint('TOPLEFT', LootFrame, 'TOPLEFT', 10, 0)
    customBg:SetPoint('BOTTOMRIGHT', LootFrame, 'BOTTOMRIGHT', -70, 0)
    customBg:SetFrameLevel(LootFrame:GetFrameLevel() + 1)
    DF.setups.lootBg = customBg.Bg

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(LootFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    local lootBg = customBg:CreateTexture(nil, 'BORDER')
    lootBg:SetTexture('Interface\\Buttons\\WHITE8X8')
    lootBg:SetPoint('TOPLEFT', customBg, 'TOPLEFT', 6, -50)
    lootBg:SetPoint('BOTTOMRIGHT', customBg, 'BOTTOMRIGHT', -6, 6)
    lootBg:SetVertexColor(0, 0, 0, .3)
    local header = customBg:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    header:SetPoint('TOP', customBg, 'TOP', 5, -5)
    header:SetText('Items')

    LootFramePortraitOverlay:SetParent(customBg)
    LootFramePortraitOverlay:SetDrawLayer('BORDER', 1)
    LootFramePortraitOverlay:ClearAllPoints()
    LootFramePortraitOverlay:SetPoint('TOPLEFT', customBg, 'TOPLEFT', -4, 6)

    local topBg = CreateFrame('Frame', nil, customBg)
    topBg:SetFrameLevel(customBg:GetFrameLevel()+1)
    topBg:SetPoint('TOPLEFT', customBg, 'TOP', -32, -25)
    topBg:SetPoint('RIGHT', customBg, 'RIGHT', -6, 0)
    topBg:SetHeight(24)
    topBg:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8X8',
        insets = {left = 0, right = 0, top = 0, bottom = 0}
    })
    topBg:SetBackdropColor(0, 0, 0, 0.5)

    tinsert(UISpecialFrames, 'DF_LootCustomBg')

    DF.hooks.HookScript(LootFrame, 'OnShow', function()
        LootFrame:ClearAllPoints()
        if DF.profile.lootframe.positionAtMouse then
            local x, y = GetCursorPosition()
            local uiScale = UIParent:GetEffectiveScale()
            local lootScale = LootFrame:GetScale()
            LootFrame:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', x / uiScale / lootScale, y / uiScale / lootScale)
        else
            LootFrame:SetPoint('LEFT', UIParent, 'LEFT', 5, 33)
        end
    end)

    local callbacks = {}
    callbacks.positionAtMouse = function(value)
    end

    callbacks.lootBgAlpha = function(value)
        if DF.setups and DF.setups.lootBg then
            DF.setups.lootBg:SetAlpha(value)
        end
    end

    callbacks.lootScale = function(value)
        if customBg then customBg:SetScale(value) end
        if LootFrame then LootFrame:SetScale(value) end
    end

    DF:NewCallbacks('lootframe', callbacks)
end)
