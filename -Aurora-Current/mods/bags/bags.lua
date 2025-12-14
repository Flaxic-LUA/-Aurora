---@diagnostic disable: duplicate-set-field
UNLOCKAURORA()

local defaults = {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {},
}

local catGeneral = 'General'
local catDisplay = 'Display'
local catBehavior = 'Behavior'
local catAppearance = 'Appearance'
local catColors = 'Colors'
table.insert(defaults.gui, {tab = 'bags', subtab = 'bags', catGeneral, catDisplay, catBehavior, catAppearance, catColors})

defaults.oneBagMode = {value = false, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 1, description = 'Use unified bag instead of separate bags'}}
defaults.oneBagButtonsPerRow = {value = 6, metadata = {element = 'slider', category = catGeneral, indexInCategory = 2, description = 'Buttons per row in unified bag', min = 5, max = 16, stepSize = 1, dependency = {key = 'oneBagMode', state = true}}}
defaults.bagScale = {value = 0.75, metadata = {element = 'slider', category = catGeneral, indexInCategory = 3, description = 'Bag scale', min = 0.5, max = 1.5, stepSize = 0.05}}

defaults.showItemRarity = {value = false, metadata = {element = 'checkbox', category = catDisplay, indexInCategory = 1, description = 'Show colored borders around items by quality'}}
defaults.showQuestItems = {value = false, metadata = {element = 'checkbox', category = catDisplay, indexInCategory = 2, description = 'Show icon on quest items'}}
defaults.questIconSize = {value = 22, metadata = {element = 'slider', category = catDisplay, indexInCategory = 3, description = 'Quest icon size', min = 10, max = 40, stepSize = 1, dependency = {key = 'showQuestItems', state = true}}}
defaults.showUnusableItems = {value = 'none', metadata = {element = 'dropdown', category = catDisplay, indexInCategory = 4, description = 'Highlight items you cannot use', options = {'none', 'border', 'icon', 'both'}}}

defaults.searchMode = {value = false, metadata = {element = 'checkbox', category = catBehavior, indexInCategory = 1, description = 'Show search box'}}
defaults.searchClearOnEscape = {value = true, metadata = {element = 'checkbox', category = catBehavior, indexInCategory = 2, description = 'Clear search text on escape', dependency = {key = 'searchMode', state = true}}}
defaults.repairButton = {value = false, metadata = {element = 'checkbox', category = catBehavior, indexInCategory = 3, description = 'Show repair button in bag'}}
defaults.autoSellGrey = {value = false, metadata = {element = 'checkbox', category = catBehavior, indexInCategory = 4, description = 'Auto-sell grey items at merchant'}}

defaults.backgroundAlpha = {value = 1, metadata = {element = 'slider', category = catAppearance, indexInCategory = 1, description = 'Background transparency', min = 0, max = 1, stepSize = 0.05}}
defaults.slotAlpha = {value = 1, metadata = {element = 'slider', category = catAppearance, indexInCategory = 2, description = 'Slot button transparency', min = 0, max = 1, stepSize = 0.05}}
defaults.overlayAlpha = {value = 1, metadata = {element = 'slider', category = catAppearance, indexInCategory = 3, description = 'Overlay border transparency', min = 0, max = 1, stepSize = 0.05}}

defaults.highlightColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 1, description = 'Highlight color'}}
defaults.borderColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 2, description = 'Button border color'}}
defaults.unusableColour = {value = {1, 0, 0, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 3, description = 'Unusable item color'}}
defaults.backgroundColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 4, description = 'Background color'}}
defaults.frameColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 5, description = 'Frame color'}}

AU:NewDefaults('bags', defaults)

AU:NewModule('bags', 1, 'PLAYER_ENTERING_WORLD', function()
    local setup = AU.setups.bags
    local bag0, bag1, bag2, bag3, bag4 = setup:InitializeBags()
    local oneBag = setup:InitializeOneBag()

    local helpers = {
        CreateQualityBorders = function()
            for i = 0, 4 do
                local bag = AU.setups.bags[i]
                if bag and bag.slots then
                    for _, btn in pairs(bag.slots) do
                        if not btn.qualityBorder then
                            btn.qualityBorder = CreateFrame('Frame', nil, btn)
                            btn.qualityBorder:SetAllPoints(btn)
                            btn.qualityBorder:SetFrameLevel(btn:GetFrameLevel() + 7)
                            btn.qualityBorderTex = btn.qualityBorder:CreateTexture(nil, 'OVERLAY')
                            btn.qualityBorderTex:SetTexture(media['tex:actionbars:btn_highlight_strong.blp'])
                            btn.qualityBorderTex:SetPoint('TOPLEFT', btn.qualityBorder, 'TOPLEFT', -4, 4)
                            btn.qualityBorderTex:SetPoint('BOTTOMRIGHT', btn.qualityBorder, 'BOTTOMRIGHT', 4, -4)
                            btn.qualityBorder:Hide()
                        end
                    end
                end
            end
            if AU.setups.bags.unified and AU.setups.bags.unified.slots then
                for _, btn in pairs(AU.setups.bags.unified.slots) do
                    if not btn.qualityBorder then
                        btn.qualityBorder = CreateFrame('Frame', nil, btn)
                        btn.qualityBorder:SetAllPoints(btn)
                        btn.qualityBorder:SetFrameLevel(btn:GetFrameLevel() + 7)
                        btn.qualityBorderTex = btn.qualityBorder:CreateTexture(nil, 'OVERLAY')
                        btn.qualityBorderTex:SetTexture(media['tex:actionbars:btn_highlight_strong.blp'])
                        btn.qualityBorderTex:SetPoint('TOPLEFT', btn.qualityBorder, 'TOPLEFT', -4, 4)
                        btn.qualityBorderTex:SetPoint('BOTTOMRIGHT', btn.qualityBorder, 'BOTTOMRIGHT', 4, -4)
                        btn.qualityBorder:Hide()
                    end
                end
            end
        end,
        UpdateQualityBorders = function(enabled)
            local colors = {{0.62,0.62,0.62},{1,1,1},{0,1,0},{0,0.44,0.87},{0.64,0.21,0.93},{1,0.5,0}}
            for i = 0, 4 do
                local bag = AU.setups.bags[i]
                if bag and bag.slots then
                    for _, btn in pairs(bag.slots) do
                        if btn.qualityBorder then
                            if enabled then
                                local _, _, _, quality = GetContainerItemInfo(btn.bagID, btn.slotID)
                                if quality and quality > 1 then
                                    local c = colors[quality + 1] or {1,1,1}
                                    btn.qualityBorderTex:SetVertexColor(c[1], c[2], c[3], 1)
                                    btn.qualityBorder:Show()
                                else
                                    btn.qualityBorder:Hide()
                                end
                            else
                                btn.qualityBorder:Hide()
                            end
                        end
                    end
                end
            end
            if AU.setups.bags.unified and AU.setups.bags.unified.slots then
                for _, btn in pairs(AU.setups.bags.unified.slots) do
                    if btn.qualityBorder then
                        if enabled then
                            local _, _, _, quality = GetContainerItemInfo(btn.bagID, btn.slotID)
                            if quality and quality > 1 then
                                local c = colors[quality + 1] or {1,1,1}
                                btn.qualityBorderTex:SetVertexColor(c[1], c[2], c[3], 1)
                                btn.qualityBorder:Show()
                            else
                                btn.qualityBorder:Hide()
                            end
                        else
                            btn.qualityBorder:Hide()
                        end
                    end
                end
            end
        end,
        ProcessQuestIcons = function(slots, value)
            local size = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['questIconSize'] or 22
            for _, btn in pairs(slots) do
                if not btn.questIcon then
                    btn.questIcon = btn:CreateTexture(nil, 'OVERLAY')
                    btn.questIcon:SetTexture(media['tex:bags:questicon.blp'])
                    btn.questIcon:SetPoint('TOPLEFT', btn, 'TOPLEFT', 0, 0)
                end
                btn.questIcon:SetSize(size, size)
                if value then
                    local texture = GetContainerItemInfo(btn.bagID, btn.slotID)
                    if texture then
                        local scanner = AU.lib.libtipscan:GetScanner('questcheck')
                        scanner:SetBagItem(btn.bagID, btn.slotID)
                        if scanner:FindText('Quest Item', true) then
                            btn.questIcon:Show()
                        else
                            btn.questIcon:Hide()
                        end
                    else
                        btn.questIcon:Hide()
                    end
                else
                    btn.questIcon:Hide()
                end
            end
        end,
        ForEachBag = function(func)
            for i = 0, 4 do
                local bag = AU.setups.bags[i]
                if bag then func(bag) end
            end
            if AU.setups.bags.unified then func(AU.setups.bags.unified) end
        end,
        ForEachSlot = function(func)
            setup.helpers.ForEachBag(function(bag)
                if bag.slots then
                    for _, btn in pairs(bag.slots) do
                        func(btn)
                    end
                end
            end)
        end
    }

    setup.helpers = helpers
    helpers.CreateQualityBorders()

    local moneyFrame = CreateFrame('Frame')
    moneyFrame:RegisterEvent('PLAYER_MONEY')
    moneyFrame:SetScript('OnEvent', function()
        if event == 'PLAYER_MONEY' then
            for i = 0, 4 do
                if setup[i] and setup[i]:IsShown() then
                    setup:UpdateMoney(setup[i])
                end
            end
            if setup.unified and setup.unified:IsShown() then
                setup:UpdateMoney(setup.unified)
            end
        end
    end)

    setup.bagEventHandler = function()
        if event == 'BAG_UPDATE' and arg1 == this:GetID() then
            setup:UpdateBag(this)
            if this.portrait then
                SetBagPortaitTexture(this.portrait, this:GetID())
            end
            if this.title and this:GetID() > 0 then
                setup:TruncateText(GetBagName(this:GetID()), setup.TITLE_MAX_WIDTH, this.title)
            end
            if AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['showItemRarity'] then
                helpers.UpdateQualityBorders(true)
            end
            if AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['showQuestItems'] then
                helpers.ProcessQuestIcons(this.slots, true)
            end
            if AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['showUnusableItems'] and AU.profile['bags']['showUnusableItems'] ~= 'none' then
                setup:UpdateUnusableItems(this)
            end
        elseif event == 'BAG_UPDATE_COOLDOWN' then
            setup:UpdateBag(this)
        elseif event == 'ITEM_LOCK_CHANGED' then
            setup:UpdateLocks(this)
        end
    end

    local initFrame = CreateFrame('Frame')
    initFrame:RegisterEvent('BAG_UPDATE')
    initFrame:SetScript('OnEvent', function()
        if event == 'BAG_UPDATE' and arg1 >= 1 and arg1 <= 4 and not setup[arg1] then
            local slots = GetContainerNumSlots(arg1)
            if slots and slots > 0 then
                setup:CreateBagFrame(arg1, slots)
                setup[arg1]:SetFrameStrata('HIGH')
                setup[arg1]:Hide()
                setup[arg1]:RegisterEvent('BAG_UPDATE')
                setup[arg1]:RegisterEvent('BAG_UPDATE_COOLDOWN')
                setup[arg1]:RegisterEvent('ITEM_LOCK_CHANGED')
                setup[arg1]:SetScript('OnEvent', setup.bagEventHandler)
                helpers.CreateQualityBorders()
            end
        end
    end)

    for i = 0, 4 do
        local bag = AU.setups.bags[i]
        if bag then
            bag:RegisterEvent('BAG_UPDATE')
            bag:RegisterEvent('BAG_UPDATE_COOLDOWN')
            bag:RegisterEvent('ITEM_LOCK_CHANGED')
            bag:SetScript('OnEvent', setup.bagEventHandler)
        end
    end
    if AU.setups.bags.unified then
        AU.setups.bags.unified:RegisterEvent('BAG_UPDATE')
        AU.setups.bags.unified:RegisterEvent('BAG_UPDATE_COOLDOWN')
        AU.setups.bags.unified:RegisterEvent('ITEM_LOCK_CHANGED')
        AU.setups.bags.unified:SetScript('OnEvent', function()
            if event == 'BAG_UPDATE' then
                setup:UpdateBag(this)
                if AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['showItemRarity'] then
                    helpers.UpdateQualityBorders(true)
                end
                if AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['showQuestItems'] then
                    helpers.ProcessQuestIcons(this.slots, true)
                end
                if AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['showUnusableItems'] and AU.profile['bags']['showUnusableItems'] ~= 'none' then
                    setup:UpdateUnusableItems(this)
                end
            elseif event == 'BAG_UPDATE_COOLDOWN' then
                setup:UpdateBag(this)
            elseif event == 'ITEM_LOCK_CHANGED' then
                setup:UpdateLocks(this)
            end
        end)
    end

    local callbacks = {}

    callbacks.oneBagMode = function(value)
        local scale = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['bagScale'] or 0.85
        if value then
            for i = 0, 4 do
                local bag = AU.setups.bags[i]
                if bag then bag:Hide() end
            end
            if oneBag then oneBag:SetScale(scale) end
            _G.ToggleBackpack = function()
                local gameMenu = getglobal('AU_GameMenuFrame')
                if gameMenu and gameMenu:IsVisible() then
                    return
                end
                if oneBag:IsShown() then
                    oneBag:Hide()
                else
                    oneBag:Show()
                end
            end
            _G.OpenAllBags = function()
                local gameMenu = getglobal('AU_GameMenuFrame')
                if gameMenu and gameMenu:IsVisible() then
                    return
                end
                if oneBag:IsShown() then
                    oneBag:Hide()
                else
                    oneBag:Show()
                end
            end
        else
            if oneBag then oneBag:Hide() end
            for i = 0, 4 do
                local bag = AU.setups.bags[i]
                if bag then bag:SetScale(scale) end
            end
            _G.ToggleBackpack = function()
                local gameMenu = getglobal('AU_GameMenuFrame')
                if gameMenu and gameMenu:IsVisible() then
                    return
                end
                if bag0:IsShown() then
                    for i = 0, 4 do
                        local bag = AU.setups.bags[i]
                        if bag then bag:Hide() end
                    end
                else
                    bag0:Show()
                end
            end
            _G.OpenAllBags = function()
                local gameMenu = getglobal('AU_GameMenuFrame')
                if gameMenu and gameMenu:IsVisible() then
                    return
                end
                local allShown = true
                for i = 0, 4 do
                    local hasBag = i == 0 or GetInventoryItemTexture('player', ContainerIDToInventoryID(i))
                    local bag = AU.setups.bags[i]
                    if hasBag and bag and not bag:IsShown() then
                        allShown = false
                        break
                    end
                end
                for i = 0, 4 do
                    local hasBag = i == 0 or GetInventoryItemTexture('player', ContainerIDToInventoryID(i))
                    local bag = AU.setups.bags[i]
                    if bag and hasBag then
                        if allShown then
                            bag:Hide()
                        else
                            bag:Show()
                        end
                    end
                end
            end
        end
    end

    callbacks.showItemRarity = function(value)
        helpers.UpdateQualityBorders(value)
    end

    callbacks.showQuestItems = function(value)
        for i = 0, 4 do
            local bag = AU.setups.bags[i]
            if bag and bag.slots then
                helpers.ProcessQuestIcons(bag.slots, value)
            end
        end
        if AU.setups.bags.unified and AU.setups.bags.unified.slots then
            helpers.ProcessQuestIcons(AU.setups.bags.unified.slots, value)
        end
    end

    callbacks.questIconSize = function(value)
        local showQuestItems = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['showQuestItems']
        for i = 0, 4 do
            local bag = AU.setups.bags[i]
            if bag and bag.slots then
                helpers.ProcessQuestIcons(bag.slots, showQuestItems)
            end
        end
        if AU.setups.bags.unified and AU.setups.bags.unified.slots then
            helpers.ProcessQuestIcons(AU.setups.bags.unified.slots, showQuestItems)
        end
    end

    callbacks.oneBagButtonsPerRow = function(value)
        local bag = AU.setups.bags.unified
        if not bag or not bag.slots then return end
        local btnSize = 37
        local spacing = 4
        local cols = value
        local totalSlots = table.getn(bag.slots)
        local rows = math.ceil(totalSlots / cols)
        local slotIndex = 1
        for row = 0, rows - 1 do
            for col = 0, cols - 1 do
                if slotIndex <= totalSlots then
                    local btn = bag.slots[slotIndex]
                    btn:ClearAllPoints()
                    btn:SetPoint('BOTTOMRIGHT', bag, 'BOTTOMRIGHT', -10 - (col * (btnSize + spacing)), 10 + (row * (btnSize + spacing)))
                    slotIndex = slotIndex + 1
                end
            end
        end
        bag:SetWidth(20 + (cols * (btnSize + spacing)))
        bag:SetHeight(100 + (rows * (btnSize + spacing)))
    end

    callbacks.backgroundAlpha = function(value)
        helpers.ForEachBag(function(bag)
            if bag.Bg then bag.Bg:SetAlpha(value) end
        end)
    end

    callbacks.slotAlpha = function(value)
        helpers.ForEachSlot(function(btn) btn:SetAlpha(value) end)
    end

    callbacks.overlayAlpha = function(value)
        helpers.ForEachSlot(function(btn)
            if btn.unusableBorder then btn.unusableBorder:SetAlpha(value) end
            if btn.qualityBorder then btn.qualityBorder:SetAlpha(value) end
            if btn.checked then btn.checked:SetAlpha(value) end
        end)
    end

    callbacks.highlightColour = function(value)
        helpers.ForEachSlot(function(btn)
            if btn.highlightTex then
                btn.highlightTex:SetVertexColor(value[1], value[2], value[3], value[4])
            end
        end)
    end

    callbacks.borderColour = function(value)
        helpers.ForEachSlot(function(btn)
            if btn.border then
                local borderTex = btn.border:GetRegions()
                if borderTex then
                    borderTex:SetVertexColor(value[1], value[2], value[3], value[4])
                end
            end
        end)
    end

    callbacks.showUnusableItems = function(value)
        if value ~= 'none' then
            helpers.ForEachBag(function(bag) setup:UpdateUnusableItems(bag) end)
        else
            helpers.ForEachSlot(function(btn)
                btn.unusableBorder:Hide()
                btn.icon:SetVertexColor(1, 1, 1)
            end)
        end
    end

    callbacks.unusableColour = function(value)
        local mode = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['showUnusableItems'] or 'both'
        if mode ~= 'none' then
            helpers.ForEachBag(function(bag) setup:UpdateUnusableItems(bag) end)
        end
    end

    callbacks.backgroundColour = function(value)
        helpers.ForEachBag(function(bag)
            if bag.Bg then bag.Bg:SetVertexColor(value[1], value[2], value[3], value[4]) end
        end)
    end

    callbacks.frameColour = function(value)
        helpers.ForEachBag(function(bag)
            if bag.edges then
                for _, edge in pairs(bag.edges) do
                    edge:SetVertexColor(value[1], value[2], value[3], value[4])
                end
            end
        end)
    end

    callbacks.searchMode = function(value)
        if bag0 and bag0.search then
            if value then
                bag0.search:Show()
                if bag0.moneyPanel then
                    bag0.moneyPanel:ClearAllPoints()
                    bag0.moneyPanel:SetPoint('TOPRIGHT', bag0.search, 'BOTTOMRIGHT', -5, -2)
                end
            else
                bag0.search:Hide()
                if bag0.moneyPanel then
                    bag0.moneyPanel:ClearAllPoints()
                    bag0.moneyPanel:SetPoint('TOPRIGHT', bag0, 'TOPRIGHT', -5, -25)
                end
            end
        end
        if oneBag and oneBag.search then
            if value then
                oneBag.search:Show()
                if oneBag.moneyPanel then
                    oneBag.moneyPanel:ClearAllPoints()
                    oneBag.moneyPanel:SetPoint('TOPRIGHT', oneBag.search, 'BOTTOMRIGHT', -5, -2)
                end
            else
                oneBag.search:Hide()
                if oneBag.moneyPanel then
                    oneBag.moneyPanel:ClearAllPoints()
                    oneBag.moneyPanel:SetPoint('TOPRIGHT', oneBag, 'TOPRIGHT', -5, -25)
                end
            end
        end
    end

    callbacks.searchClearOnEscape = function(value)
    end

    callbacks.repairButton = function(value)
    end

    callbacks.autoSellGrey = function(value)
        setup.autoSellEnabled = value
        if bag0 and bag0.sellBtn then
            if value then bag0.sellBtn:Show() else bag0.sellBtn:Hide() end
        end
        if oneBag and oneBag.sellBtn then
            if value then oneBag.sellBtn:Show() else oneBag.sellBtn:Hide() end
        end
    end

    callbacks.bagScale = function(value)
        local oneBagMode = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['oneBagMode']
        if oneBagMode then
            if oneBag then oneBag:SetScale(value) end
        else
            for i = 0, 4 do
                local bag = AU.setups.bags[i]
                if bag then bag:SetScale(value) end
            end
        end
    end

    local merchantFrame = CreateFrame('Frame')
    merchantFrame:RegisterEvent('MERCHANT_SHOW')
    merchantFrame:SetScript('OnEvent', function()
        if event == 'MERCHANT_SHOW' then
            local oneBagMode = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['oneBagMode']
            local anyBagOpen = false

            if oneBagMode then
                anyBagOpen = oneBag:IsShown()
            else
                for i = 0, 4 do
                    if setup[i] and setup[i]:IsShown() then
                        anyBagOpen = true
                        break
                    end
                end
            end

            if not anyBagOpen then
                if oneBagMode then
                    oneBag:Show()
                else
                    bag0:Show()
                end
            end

            if AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['repairButton'] then
                setup:RepairItems()
            end
            if AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['autoSellGrey'] then
                setup:SellGreyItems()
            end
        end
    end)

    local delayFrame = CreateFrame('Frame') -- TODO
    delayFrame.elapsed = 0
    delayFrame:SetScript('OnUpdate', function()
        this.elapsed = this.elapsed + arg1
        if this.elapsed > 0.5 then
            AU:NewCallbacks('bags', callbacks)
            this:SetScript('OnUpdate', nil)
        end
    end)
end)
