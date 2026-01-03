DRAGONFLIGHT()

DF:NewDefaults('collector', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'minimap', subtab = 'extras', 'Collector'},
    },
    buttonsPerRow = {value = 5, metadata = {element = 'slider', category = 'Collector', indexInCategory = 1, description = 'Buttons per row', min = 1, max = 20, stepSize = 1}},
    spacing = {value = 3, metadata = {element = 'slider', category = 'Collector', indexInCategory = 2, description = 'Spacing between buttons', min = 0, max = 10, stepSize = 1}},
    buttonScale = {value = 80, metadata = {element = 'slider', category = 'Collector', indexInCategory = 3, description = 'Button scale', min = 50, max = 150, stepSize = 5}},
    anchorPoint = {value = 'RIGHT', metadata = {element = 'dropdown', category = 'Collector', indexInCategory = 4, description = 'Anchor position', options = {'RIGHT', 'TOPRIGHT', 'BOTTOMRIGHT'}}},
    backgroundAlpha = {value = 30, metadata = {element = 'slider', category = 'Collector', indexInCategory = 5, description = 'Background transparency', min = 0, max = 100, stepSize = 5}},
    autoHide = {value = true, metadata = {element = 'checkbox', category = 'Collector', indexInCategory = 6, description = 'Auto-hide when no buttons found'}},
    autoClose = {value = true, metadata = {element = 'checkbox', category = 'Collector', indexInCategory = 7, description = 'Auto-close after clicking button'}},
})

DF:NewModule('collector', 1, 'PLAYER_ENTERING_WORLD', function()
    local buttonsFound = DF.lib.CreateButtonSkinner()

    local collectorFrame
    local expandButton = DF.ui.ExpandButton(UIParent, 28, 17, nil, function(isChecked)
        if isChecked then
            collectorFrame:Show()
        else
            collectorFrame:Hide()
        end
    end, 'DF_CollectorExpandButton', false)
    expandButton:SetPoint('RIGHT', Minimap, 'LEFT', -15, 0)
    expandButton:SetChecked(false)
    expandButton:GetNormalTexture():SetTexCoord(1, 0, 0, 1)
    expandButton:GetHighlightTexture():SetTexCoord(1, 0, 0, 1)

    collectorFrame = CreateFrame('Frame', nil, UIParent)
    collectorFrame:SetSize(35, 35)
    collectorFrame:SetPoint('RIGHT', expandButton, 'LEFT', -5, 0)
    local bg = collectorFrame:CreateTexture(nil, 'BACKGROUND')
    bg:SetTexture('Interface\\Buttons\\WHITE8X8')
    bg:SetAllPoints(collectorFrame)

    local corner = collectorFrame:CreateTexture(nil, 'OVERLAY')
    corner:SetTexture(media['tex:interface:golden_corner.blp'])
    corner:SetPoint('CENTER', collectorFrame, 'TOPLEFT', 2, -2)
    corner:SetSize(20, 20)

    local cornerBL = collectorFrame:CreateTexture(nil, 'OVERLAY')
    cornerBL:SetTexture(media['tex:interface:golden_corner.blp'])
    cornerBL:SetPoint('CENTER', collectorFrame, 'BOTTOMLEFT', 2, 2)
    cornerBL:SetSize(20, 20)
    cornerBL:SetTexCoord(0, 1, 1, 0)

    local cornerTR = collectorFrame:CreateTexture(nil, 'OVERLAY')
    cornerTR:SetTexture(media['tex:interface:golden_corner.blp'])
    cornerTR:SetPoint('CENTER', collectorFrame, 'TOPRIGHT', -2, -2)
    cornerTR:SetSize(20, 20)
    cornerTR:SetTexCoord(1, 0, 0, 1)

    local cornerBR = collectorFrame:CreateTexture(nil, 'OVERLAY')
    cornerBR:SetTexture(media['tex:interface:golden_corner.blp'])
    cornerBR:SetPoint('CENTER', collectorFrame, 'BOTTOMRIGHT', -2, 2)
    cornerBR:SetSize(20, 20)
    cornerBR:SetTexCoord(1, 0, 1, 0)

    collectorFrame:Hide()

    local function LayoutButtons(buttons)
        local buttonsPerRow = DF.profile['collector']['buttonsPerRow']
        local spacing = DF.profile['collector']['spacing']
        local buttonScale = DF.profile['collector']['buttonScale'] / 100
        local cellSize = 35
        local padding = 5
        local buttonList = {}

        for name, btn in pairs(buttons) do
            table.insert(buttonList, btn)
        end

        local buttonCount = table.getn(buttonList)

        if DF.profile['collector']['autoHide'] then
            if buttonCount == 0 then
                collectorFrame:Hide()
                expandButton:Hide()
                return
            else
                expandButton:Show()
            end
        end

        if buttonCount == 0 then return end

        local rows = math.ceil(buttonCount / buttonsPerRow)
        local cols = math.min(buttonCount, buttonsPerRow)
        local scaledCellSize = cellSize * buttonScale
        local frameWidth = (cols * scaledCellSize) + ((cols - 1) * spacing) + (padding * 2)
        local frameHeight = (rows * scaledCellSize) + ((rows - 1) * spacing) + (padding * 2)

        collectorFrame:SetSize(frameWidth, frameHeight)

        for i = 1, buttonCount do
            local btn = buttonList[i]
            local row = math.floor((i - 1) / buttonsPerRow)
            local col = math.mod(i - 1, buttonsPerRow)
            local xOffset = padding + (col * (cellSize + spacing))
            local yOffset = -padding - (row * (cellSize + spacing))

            btn:SetParent(collectorFrame)
            btn:ClearAllPoints()
            btn:SetPoint('TOPLEFT', collectorFrame, 'TOPLEFT', xOffset, yOffset)
            btn:SetScale(buttonScale)

            if not btn.collectorHooked then
                local btnName = btn:GetName()
                DF.hooks.HookScript(btn, 'OnClick', function()
                    if DF.profile['collector']['autoClose'] and not DF.mixins.IsCollectorException(btnName) then
                        expandButton:Click()
                    end
                end, true)
                btn.collectorHooked = true
            end
        end
    end

    DF.timers.delay(.1, function()
        LayoutButtons(buttonsFound)
    end)

    -- callbacks
    local callbacks = {}

    callbacks.buttonsPerRow = function(value)
        LayoutButtons(buttonsFound)
    end

    callbacks.spacing = function(value)
        LayoutButtons(buttonsFound)
    end

    callbacks.buttonScale = function(value)
        local scale = value / 100
        corner:SetSize(20 * scale, 20 * scale)
        cornerBL:SetSize(20 * scale, 20 * scale)
        cornerTR:SetSize(20 * scale, 20 * scale)
        cornerBR:SetSize(20 * scale, 20 * scale)
        LayoutButtons(buttonsFound)
    end

    callbacks.anchorPoint = function(value)
        collectorFrame:ClearAllPoints()
        collectorFrame:SetPoint(value, expandButton, 'LEFT', -5, 0)
    end

    callbacks.backgroundAlpha = function(value)
        bg:SetVertexColor(0, 0, 0, value / 100)
    end

    callbacks.autoHide = function(value)
        LayoutButtons(buttonsFound)
    end

    callbacks.autoClose = function(value)
    end

    DF:NewCallbacks('collector', callbacks)
end)
