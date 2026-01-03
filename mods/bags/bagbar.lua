DRAGONFLIGHT()

DF:NewDefaults('bagbar', {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {
        {tab = 'bags', subtab = 'bagbar', 'Appearance', 'Sizes', 'Free Slots'},
    },

    showBags = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 1, description = 'Show or hide the bag bar'}},
    showToggle = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 2, description = 'Show or hide the expand button', dependency = {key = 'showBags', state = true}}},
    expandBags = {value = true, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 3, description = 'Show or hide individual bag slots', dependency = {key = 'showBags', state = true}}},
    fadeOutDelay = {value = 0, metadata = {element = 'slider', category = 'Appearance', indexInCategory = 4, description = 'Seconds before fading out after mouse leaves (0 = disabled)', min = 0, max = 10, stepSize = 0.5, dependency = {key = 'showBags', state = true}}},
    bigBagSize = {value = 30, metadata = {element = 'slider', category = 'Sizes', indexInCategory = 1, description = 'Size of the main bag button', min = 20, max = 80, stepSize = 1, dependency = {key = 'showBags', state = true}}},
    smallBagSize = {value = 23, metadata = {element = 'slider', category = 'Sizes', indexInCategory = 2, description = 'Size of the small bag buttons', min = 15, max = 60, stepSize = 1, dependency = {key = 'showBags', state = true}}},
    expandButtonSize = {value = 23, metadata = {element = 'slider', category = 'Sizes', indexInCategory = 3, description = 'Width of the expand button', min = 15, max = 50, stepSize = 1, dependency = {key = 'showBags', state = true}}},
    showFreeSlots = {value = true, metadata = {element = 'checkbox', category = 'Free Slots', indexInCategory = 1, description = 'Show free bag slots below main bag', dependency = {key = 'showBags', state = true}}},
    showBackground = {value = false, metadata = {element = 'checkbox', category = 'Free Slots', indexInCategory = 2, description = 'Show background behind free slots text', dependency = {key = 'showFreeSlots', state = true}}},
    colorizedFreeSlots = {value = false, metadata = {element = 'checkbox', category = 'Free Slots', indexInCategory = 3, description = 'Colorize free slots based on percentage (green/yellow/red)', dependency = {key = 'showFreeSlots', state = true}}},
    freeSlotsFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'Free Slots', indexInCategory = 4, description = 'Font for free slots text', options = media.fonts, dependency = {key = 'showFreeSlots', state = true}}},
    freeSlotsSize = {value = 10, metadata = {element = 'slider', category = 'Free Slots', indexInCategory = 5, description = 'Font size of free slots text', min = 6, max = 20, stepSize = 1, dependency = {key = 'showFreeSlots', state = true}}},
    freeSlotsColour = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Free Slots', indexInCategory = 6, description = 'Color of free slots text', dependency = {key = 'colorizedFreeSlots', state = false}}},
    freeSlotsX = {value = 0, metadata = {element = 'slider', category = 'Free Slots', indexInCategory = 7, description = 'Horizontal position offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'showFreeSlots', state = true}}},
    freeSlotsY = {value = 2, metadata = {element = 'slider', category = 'Free Slots', indexInCategory = 8, description = 'Vertical position offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'showFreeSlots', state = true}}},
    borderColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = 'Appearance', indexInCategory = 5, description = 'Color of bag frame borders', dependency = {key = 'showBags', state = true}}},
})

DF:NewModule('bagbar', 1, 'PLAYER_LOGIN', function()
    local setup = DF.setups.bagbar
    setup:CreateBagBar()
    setup:OnEvent()

    local container = setup.container
    local mainBag = setup.mainBag
    local smallBags = setup.smallBags
    local keyRing = setup.keyRing
    local expandButton = setup.expandButton

    container:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -10, 40)
    container:SetFrameStrata('BACKGROUND')

    mainBag:SetPoint('RIGHT', container, 'RIGHT', 0, 0)
    expandButton:SetPoint('RIGHT', mainBag, 'LEFT', 2, 0)
    smallBags[0]:SetPoint('RIGHT', expandButton, 'LEFT', -0, 0)
    for i = 1, 3 do
        smallBags[i]:SetPoint('RIGHT', smallBags[i-1], 'LEFT', 0, 0)
    end
    keyRing:SetPoint('RIGHT', smallBags[3], 'LEFT', 0, 0)

    for i = 0, 3 do
        setup:UpdateBagIcon(smallBags[i], i + 1)
    end

    local helpers = {}

    helpers.GetBagFreeAndTotal = function()
        local free = 0
        local total = 0
        for bag = 0, NUM_BAG_SLOTS do
            local numSlots = GetContainerNumSlots(bag)
            total = total + numSlots
            for slot = 1, numSlots do
                local texture = GetContainerItemInfo(bag, slot)
                if not texture then
                    free = free + 1
                end
            end
        end
        return free, total
    end

    helpers.UpdateFreeSlotsColor = function()
        if mainBag.FreeSlotsText then
            local free, total = helpers.GetBagFreeAndTotal()
            local used = total - free
            local percent = (used / total) * 100
            if DF.profile['bagbar']['colorizedFreeSlots'] then
                if percent <= 50 then
                    mainBag.FreeSlotsText:SetTextColor(0, 1, 0)
                elseif percent <= 79 then
                    mainBag.FreeSlotsText:SetTextColor(1, 1, 0)
                else
                    mainBag.FreeSlotsText:SetTextColor(1, 0, 0)
                end
            else
                local color = DF.profile['bagbar']['freeSlotsColour']
                mainBag.FreeSlotsText:SetTextColor(color[1], color[2], color[3])
            end
        end
    end

    helpers.ShowMainBagTooltip = function()
        GameTooltip:SetOwner(mainBag, 'ANCHOR_LEFT')
        GameTooltip:SetText(TEXT(BACKPACK_TOOLTIP), 1.0, 1.0, 1.0)
        local keyBinding = GetBindingKey('TOGGLEBACKPACK')
        if keyBinding then
            GameTooltip:AppendText(' '..NORMAL_FONT_COLOR_CODE..'('..keyBinding..')'..FONT_COLOR_CODE_CLOSE)
        end
    end

    helpers.ShowSmallBagTooltip = function(bagButton)
        GameTooltip:SetOwner(bagButton, 'ANCHOR_LEFT')
        if GameTooltip:SetInventoryItem('player', ContainerIDToInventoryID(bagButton:GetID() + 1)) then
            local binding = GetBindingKey('TOGGLEBAG'..(4 - bagButton:GetID()))
            if binding then
                GameTooltip:AppendText(' '..NORMAL_FONT_COLOR_CODE..'('..binding..')'..FONT_COLOR_CODE_CLOSE)
            end
        else
            GameTooltip:SetText(TEXT(EQUIP_CONTAINER), 1.0, 1.0, 1.0)
        end
    end

    helpers.ShowKeyRingTooltip = function()
        GameTooltip:SetOwner(keyRing, 'ANCHOR_LEFT')
        GameTooltip:SetText(KEYRING, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
        GameTooltip:AddLine()
    end

    helpers.HideTooltip = function()
        GameTooltip:Hide()
    end

    helpers.SetupBarFade = function()
        local delay = DF.profile['bagbar']['fadeOutDelay']
        local wasEnabled = container.fadeEnabled
        if delay > 0 then
            local fadeIn = function()
                if container.fadeTimer then
                    container.fadeTimer = nil
                end
                UIFrameFadeIn(container, 0.2, container:GetAlpha(), 1)
            end
            local fadeOut = function()
                container.fadeTimer = delay
                container:SetScript('OnUpdate', function()
                    if container.fadeTimer then
                        container.fadeTimer = container.fadeTimer - arg1
                        if container.fadeTimer <= 0 then
                            container.fadeTimer = nil
                            container:SetScript('OnUpdate', nil)
                            UIFrameFadeOut(container, 0.5, 1, 0)
                        end
                    end
                end)
            end
            container:SetScript('OnEnter', fadeIn)
            container:SetScript('OnLeave', fadeOut)
            mainBag:SetScript('OnEnter', function()
                fadeIn()
                helpers.ShowMainBagTooltip()
            end)
            mainBag:SetScript('OnLeave', function()
                helpers.HideTooltip()
                fadeOut()
            end)
            expandButton:SetScript('OnEnter', function()
                fadeIn()
                local text = expandButton:GetChecked() and 'Collapse' or 'Expand'
                -- DF.lib.ShowSimpleTooltip(expandButton, text)
            end)
            expandButton:SetScript('OnLeave', function()
                -- DF.lib.HideActionTooltip()
                fadeOut()
            end)
            for i = 0, 3 do
                smallBags[i]:SetScript('OnEnter', function()
                    fadeIn()
                    helpers.ShowSmallBagTooltip(this)
                end)
                smallBags[i]:SetScript('OnLeave', function()
                    helpers.HideTooltip()
                    fadeOut()
                end)
            end
            keyRing:SetScript('OnEnter', function()
                fadeIn()
                helpers.ShowKeyRingTooltip()
            end)
            keyRing:SetScript('OnLeave', function()
                helpers.HideTooltip()
                fadeOut()
            end)
            container.fadeEnabled = true
            if not wasEnabled then
                UIFrameFadeOut(container, 0.5, 1, 0)
            end
        else
            container:SetScript('OnEnter', nil)
            container:SetScript('OnLeave', nil)
            container:SetScript('OnUpdate', nil)
            mainBag:SetScript('OnEnter', function()
                helpers.ShowMainBagTooltip()
            end)
            mainBag:SetScript('OnLeave', function()
                helpers.HideTooltip()
            end)
            expandButton:SetScript('OnEnter', function()
                local text = expandButton:GetChecked() and 'Collapse' or 'Expand'
                -- DF.lib.ShowSimpleTooltip(expandButton, text)
            end)
            expandButton:SetScript('OnLeave', function()
                -- DF.lib.HideActionTooltip()
            end)
            for i = 0, 3 do
                smallBags[i]:SetScript('OnEnter', function()
                    helpers.ShowSmallBagTooltip(this)
                end)
                smallBags[i]:SetScript('OnLeave', function()
                    helpers.HideTooltip()
                end)
            end
            keyRing:SetScript('OnEnter', function()
                helpers.ShowKeyRingTooltip()
            end)
            keyRing:SetScript('OnLeave', function()
                helpers.HideTooltip()
            end)
            container.fadeTimer = nil
            container.fadeEnabled = nil
            container:SetAlpha(1)
        end
    end

    -- callbacks
    local callbacks = {}

    callbacks.showBags = function(value)
        if value then
            container:Show()
        else
            container:Hide()
        end
    end

    callbacks.showToggle = function(value)
        if value then
            expandButton:Show()
            smallBags[0]:ClearAllPoints()
            smallBags[0]:SetPoint('RIGHT', expandButton, 'LEFT', -0, 0)
        else
            expandButton:Hide()
            smallBags[0]:ClearAllPoints()
            smallBags[0]:SetPoint('RIGHT', mainBag, 'LEFT', 0, 0)
        end
    end

    callbacks.expandBags = function(value)
        expandButton:SetChecked(value)
        if value then
            expandButton:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
            expandButton:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
        else
            expandButton:GetNormalTexture():SetTexCoord(1, 0, 0, 1)
            expandButton:GetHighlightTexture():SetTexCoord(1, 0, 0, 1)
        end
        for i = 0, 3 do
            if value then
                smallBags[i]:Show()
            else
                smallBags[i]:Hide()
            end
        end
        if value then
            keyRing:Show()
        else
            keyRing:Hide()
        end
    end

    callbacks.bigBagSize = function(value)
        mainBag:SetWidth(value)
        mainBag:SetHeight(value)
    end

    callbacks.smallBagSize = function(value)
        for i = 0, 3 do
            smallBags[i]:SetWidth(value)
            smallBags[i]:SetHeight(value)
            smallBags[i].border:SetWidth(value + 1)
            smallBags[i].border:SetHeight(value + 1)
            smallBags[i].icon:SetWidth(value * 0.6)
            smallBags[i].icon:SetHeight(value * 0.6)
        end
        keyRing:SetWidth(value)
        keyRing:SetHeight(value)
        keyRing.border:SetWidth(value + 1)
        keyRing.border:SetHeight(value + 1)
        keyRing.icon:SetWidth(value * 0.6)
        keyRing.icon:SetHeight(value * 0.6)
    end

    callbacks.expandButtonSize = function(value)
        expandButton:SetWidth(value)
        expandButton:SetHeight(value * 0.6)
    end

    callbacks.showFreeSlots = function(value)
        if value then
            if not mainBag.FreeSlotsText then
                local bg = mainBag:CreateTexture(nil, 'BACKGROUND')
                bg:SetTexture('Interface\\Buttons\\WHITE8X8')
                bg:SetVertexColor(0, 0, 0, 0.5)
                bg:SetPoint('TOP', mainBag, 'BOTTOM', 0, 2)
                bg:SetWidth(40)
                bg:SetHeight(12)
                bg:Hide()
                mainBag.FreeSlotsBg = bg

                local text = mainBag:CreateFontString(nil, 'OVERLAY')
                text:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
                text:SetPoint('TOP', mainBag, 'BOTTOM', 0, 2)
                text:SetTextColor(1, 1, 1)
                mainBag.FreeSlotsText = text
            end
            mainBag.FreeSlotsText:Show()
            if DF.profile['bagbar']['showBackground'] then
                mainBag.FreeSlotsBg:Show()
            end

            local free, total = helpers.GetBagFreeAndTotal()
            mainBag.FreeSlotsText:SetText(free .. ' / ' .. total)

            if not mainBag.FreeSlotsUpdater then
                local updater = CreateFrame('Frame')
                updater:RegisterEvent('BAG_UPDATE')
                updater:SetScript('OnEvent', function()
                    local freeSlots, totalSlots = helpers.GetBagFreeAndTotal()
                    mainBag.FreeSlotsText:SetText(freeSlots .. ' / ' .. totalSlots)
                    helpers.UpdateFreeSlotsColor()
                end)
                mainBag.FreeSlotsUpdater = updater
            end
        else
            if mainBag.FreeSlotsText then
                mainBag.FreeSlotsText:Hide()
            end
            if mainBag.FreeSlotsBg then
                mainBag.FreeSlotsBg:Hide()
            end
        end
    end

    callbacks.showBackground = function(value)
        if mainBag.FreeSlotsBg then
            if value then
                mainBag.FreeSlotsBg:Show()
            else
                mainBag.FreeSlotsBg:Hide()
            end
        end
    end

    callbacks.freeSlotsFont = function(value)
        if mainBag.FreeSlotsText then
            local fontPath = value
            if string.find(value, 'font:') then
                fontPath = media[value]
            end
            mainBag.FreeSlotsText:SetFont(fontPath, DF.profile['bagbar']['freeSlotsSize'], 'OUTLINE')
        end
    end

    callbacks.freeSlotsSize = function(value)
        if mainBag.FreeSlotsText then
            local fontPath = DF.profile['bagbar']['freeSlotsFont']
            if string.find(fontPath, 'font:') then
                fontPath = media[fontPath]
            end
            mainBag.FreeSlotsText:SetFont(fontPath, value, 'OUTLINE')
        end
        if mainBag.FreeSlotsBg then
            mainBag.FreeSlotsBg:SetWidth(value * 4)
            mainBag.FreeSlotsBg:SetHeight(value + 2)
        end
    end

    callbacks.colorizedFreeSlots = function()
        helpers.UpdateFreeSlotsColor()
    end

    callbacks.freeSlotsColour = function(value)
        if not DF.profile['bagbar']['colorizedFreeSlots'] then
            if mainBag.FreeSlotsText then
                mainBag.FreeSlotsText:SetTextColor(value[1], value[2], value[3])
            end
        end
    end

    callbacks.freeSlotsX = function(value)
        if mainBag.FreeSlotsText then
            mainBag.FreeSlotsText:ClearAllPoints()
            mainBag.FreeSlotsText:SetPoint('TOP', mainBag, 'BOTTOM', value, DF.profile['bagbar']['freeSlotsY'])
        end
        if mainBag.FreeSlotsBg then
            mainBag.FreeSlotsBg:ClearAllPoints()
            mainBag.FreeSlotsBg:SetPoint('TOP', mainBag, 'BOTTOM', value, DF.profile['bagbar']['freeSlotsY'])
        end
    end

    callbacks.freeSlotsY = function(value)
        if mainBag.FreeSlotsText then
            mainBag.FreeSlotsText:ClearAllPoints()
            mainBag.FreeSlotsText:SetPoint('TOP', mainBag, 'BOTTOM', DF.profile['bagbar']['freeSlotsX'], value)
        end
        if mainBag.FreeSlotsBg then
            mainBag.FreeSlotsBg:ClearAllPoints()
            mainBag.FreeSlotsBg:SetPoint('TOP', mainBag, 'BOTTOM', DF.profile['bagbar']['freeSlotsX'], value)
        end
    end

    callbacks.fadeOutDelay = function()
        helpers.SetupBarFade()
    end

    callbacks.borderColour = function(value)
        mainBag.border:SetVertexColor(value[1], value[2], value[3], value[4])
        for i = 0, 3 do
            smallBags[i].border:SetVertexColor(value[1], value[2], value[3], value[4])
        end
        keyRing.border:SetVertexColor(value[1], value[2], value[3], value[4])
    end

    setup.callbacks = callbacks
    DF:NewCallbacks('bagbar', callbacks)
end)