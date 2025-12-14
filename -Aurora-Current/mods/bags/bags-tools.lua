---@diagnostic disable: duplicate-set-field
UNLOCKAURORA()

local setup = {
    TITLE_MAX_WIDTH = 95,
    buttonSize = 37,

    textures = {
        border = media['tex:actionbars:btn_border.blp'],
        highlight = media['tex:actionbars:btn_highlight_strong.blp'],
        bgTexture = media['tex:actionbars:HDActionBarBtn.tga']
    }
}

-- create
function setup:CreateSlotButton(parent, frameName, slotIndex, bagID, buttonSize, spacing, col, row)
    local btn = AU.ui.SlotButton(parent, frameName..'Item'..slotIndex, buttonSize)
    btn:SetID(slotIndex)
    btn.bagID = bagID
    btn.slotID = slotIndex
    btn:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', -10 - (col * (buttonSize + spacing)), 10 + (row * (buttonSize + spacing)))

    btn.border:SetBackdrop(nil)
    local borderTex = btn.border:CreateTexture(nil, 'BACKGROUND')
    borderTex:SetTexture(self.textures.border)
    borderTex:SetAllPoints(btn.border)

    btn.bg:SetTexture(self.textures.bgTexture)
    btn.bg:SetVertexColor(1, 1, 1, 1)

    btn.highlight:SetBackdrop(nil)
    btn.highlightTex = btn.highlight:CreateTexture(nil, 'OVERLAY')
    btn.highlightTex:SetTexture(self.textures.highlight)
    btn.highlightTex:SetPoint('TOPLEFT', btn.highlight, 'TOPLEFT', -4, 4)
    btn.highlightTex:SetPoint('BOTTOMRIGHT', btn.highlight, 'BOTTOMRIGHT', 4, -4)

    btn.unusableBorder = CreateFrame('Frame', nil, btn)
    btn.unusableBorder:SetAllPoints(btn)
    btn.unusableBorder:SetFrameLevel(btn:GetFrameLevel() + 8)
    btn.unusableBorderTex = btn.unusableBorder:CreateTexture(nil, 'OVERLAY')
    btn.unusableBorderTex:SetTexture(self.textures.highlight)
    btn.unusableBorderTex:SetPoint('TOPLEFT', btn.unusableBorder, 'TOPLEFT', -4, 4)
    btn.unusableBorderTex:SetPoint('BOTTOMRIGHT', btn.unusableBorder, 'BOTTOMRIGHT', 4, -4)
    btn.unusableBorder:Hide()

    btn.searchBorder = CreateFrame('Frame', nil, btn)
    btn.searchBorder:SetAllPoints(btn)
    btn.searchBorder:SetFrameLevel(btn:GetFrameLevel() + 9)
    btn.searchBorderTex = btn.searchBorder:CreateTexture(nil, 'OVERLAY')
    btn.searchBorderTex:SetTexture(self.textures.highlight)
    btn.searchBorderTex:SetPoint('TOPLEFT', btn.searchBorder, 'TOPLEFT', -4, 4)
    btn.searchBorderTex:SetPoint('BOTTOMRIGHT', btn.searchBorder, 'BOTTOMRIGHT', 4, -4)
    btn.searchBorderTex:SetVertexColor(1, 1, 1, 1)
    btn.searchBorder:Hide()

    btn.count = btn:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
    btn.count:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', -2, 2)
    btn.count:Hide()

    btn:SetScript('OnClick', function()
        if arg1 == 'LeftButton' then
            PickupContainerItem(btn.bagID, btn.slotID)
        elseif arg1 == 'RightButton' then
            UseContainerItem(btn.bagID, btn.slotID)
        end
    end)
    btn:SetScript('OnDragStart', function()
        btn.pushed:Hide()
        PickupContainerItem(btn.bagID, btn.slotID)
    end)
    btn:SetScript('OnReceiveDrag', function()
        PickupContainerItem(btn.bagID, btn.slotID)
    end)
    btn:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    btn:RegisterForDrag('LeftButton')

    return btn
end

function setup:CreateBagFrame(bagID, numSlots)
    local cols = 4
    local rows = math.ceil(numSlots / cols)
    local buttonSize = 37
    local spacing = 4
    local frameWidth = 180
    local frameHeight

    if bagID == 0 then
        frameHeight = 100 + (rows * (buttonSize + spacing))
    else
        frameHeight = 70 + (rows * (buttonSize + spacing))
    end

    local frameName = 'AU_ContainerFrame'..(bagID + 1)
    local bag = AU.ui.CreatePaperDollFrame(frameName, UIParent, frameWidth, frameHeight, 1)
    bag:EnableMouse(true)
    bag:SetID(bagID)
    bag.slots = {}

    if bagID == 0 then
        local bigbag = bag:CreateTexture(nil, 'OVERLAY')
        bigbag:SetTexture(media['tex:bags:bigbag.blp'])
        bigbag:SetPoint('TOPLEFT', bag, 'TOPLEFT', -10, 15)
        bigbag:SetHeight(74)
        bigbag:SetWidth(74)
    else
        local portrait = bag:CreateTexture(nil, 'BORDER')
        portrait:SetWidth(55)
        portrait:SetHeight(55)
        portrait:SetPoint('TOPLEFT', bag, 'TOPLEFT', -3, 5)
        SetBagPortaitTexture(portrait, bagID)
        bag.portrait = portrait
    end

    local closeBtn = AU.ui.CreateRedButton(bag, 'close', function() bag:Hide() end)
    closeBtn:SetPoint('TOPRIGHT', bag, 'TOPRIGHT', -1, -1)

    local title = bag:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    title:SetPoint('RIGHT', closeBtn, 'LEFT', -5, 0)
    title:SetTextColor(1, 1, 1)
    if bagID == 0 then
        title:SetText('Backpack')
    else
        self:TruncateText(GetBagName(bagID), self.TITLE_MAX_WIDTH, title)
    end
    bag.title = title

    if bagID == 0 then
        bag.searchCache = {}
        bag.search = AU.ui.Editbox(bag, frameWidth - 60, 20, 50)
        bag.search:SetPoint('TOPRIGHT', bag, 'TOPRIGHT', -5, -25)
        bag.search:SetText('Search')
        bag.search:SetTextColor(0.5, 0.5, 0.5)

        bag.search:SetScript('OnEditFocusGained', function()
            local text = this:GetText()
            if text == 'Search' then
                this:SetText('')
                this:SetTextColor(1, 1, 1)
            else
                this:HighlightText()
            end
        end)

        bag.search:SetScript('OnEditFocusLost', function()
            local text = this:GetText()
            if text == '' then
                this:SetText('Search')
                this:SetTextColor(0.5, 0.5, 0.5)
                for i = 0, 4 do
                    local b = setup[i]
                    if b and b.slots then
                        for _, btn in pairs(b.slots) do
                            btn:SetAlpha(1)
                        end
                    end
                end
            end
        end)

        bag.search:SetScript('OnEscapePressed', function()
            local clearOnEscape = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['searchClearOnEscape']
            if clearOnEscape then
                this:SetText('')
                this:ClearFocus()
            else
                this:ClearFocus()
            end
        end)

        bag.moneyPanel = CreateFrame('Frame', nil, bag)
        bag.moneyPanel:SetSize(100, 17)
        bag.moneyPanel:SetPoint('TOPRIGHT', bag.search, 'BOTTOMRIGHT', -5, -2)
        local moneyBg = bag.moneyPanel:CreateTexture(nil, 'BACKGROUND')
        moneyBg:SetTexture('Interface\\Buttons\\WHITE8X8')
        moneyBg:SetAllPoints(bag.moneyPanel)
        moneyBg:SetVertexColor(0, 0, 0, 0.5)

        bag.moneyPanel.goldIcon = bag.moneyPanel:CreateTexture(nil, 'ARTWORK')
        bag.moneyPanel.goldIcon:SetTexture('Interface\\MoneyFrame\\UI-MoneyIcons')
        bag.moneyPanel.goldIcon:SetTexCoord(0, 0.25, 0, 1)
        bag.moneyPanel.goldIcon:SetSize(13, 13)
        bag.moneyPanel.goldIcon:SetPoint('LEFT', bag.moneyPanel, 'LEFT', 2, 0)
        bag.moneyPanel.gold = bag.moneyPanel:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
        bag.moneyPanel.gold:SetPoint('LEFT', bag.moneyPanel.goldIcon, 'RIGHT', 0, 0)

        bag.moneyPanel.silverIcon = bag.moneyPanel:CreateTexture(nil, 'ARTWORK')
        bag.moneyPanel.silverIcon:SetTexture('Interface\\MoneyFrame\\UI-MoneyIcons')
        bag.moneyPanel.silverIcon:SetTexCoord(0.25, 0.5, 0, 1)
        bag.moneyPanel.silverIcon:SetSize(13, 13)
        bag.moneyPanel.silverIcon:SetPoint('LEFT', bag.moneyPanel.gold, 'RIGHT', 2, 0)
        bag.moneyPanel.silver = bag.moneyPanel:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
        bag.moneyPanel.silver:SetPoint('LEFT', bag.moneyPanel.silverIcon, 'RIGHT', 0, 0)

        bag.moneyPanel.copperIcon = bag.moneyPanel:CreateTexture(nil, 'ARTWORK')
        bag.moneyPanel.copperIcon:SetTexture('Interface\\MoneyFrame\\UI-MoneyIcons')
        bag.moneyPanel.copperIcon:SetTexCoord(0.5, 0.75, 0, 1)
        bag.moneyPanel.copperIcon:SetSize(13, 13)
        bag.moneyPanel.copperIcon:SetPoint('LEFT', bag.moneyPanel.silver, 'RIGHT', 2, 0)
        bag.moneyPanel.copper = bag.moneyPanel:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
        bag.moneyPanel.copper:SetPoint('LEFT', bag.moneyPanel.copperIcon, 'RIGHT', 0, 0)

        bag.sellBtn = CreateFrame('Button', nil, bag)
        bag.sellBtn:SetSize(17, 17)
        bag.sellBtn:SetPoint('TOPRIGHT', bag.moneyPanel, 'BOTTOMRIGHT', 0, -4)
        local sellTex = bag.sellBtn:CreateTexture(nil, 'ARTWORK')
        sellTex:SetPoint('TOPLEFT', bag.sellBtn, 'TOPLEFT', -5, 5)
        sellTex:SetPoint('BOTTOMRIGHT', bag.sellBtn, 'BOTTOMRIGHT', 5, -5)
        sellTex:SetTexture(media['tex:bags:sellbtn.blp'])
        bag.sellBtn.tex = sellTex
        local sellHighlight = bag.sellBtn:CreateTexture(nil, 'HIGHLIGHT')
        sellHighlight:SetPoint('TOPLEFT', bag.sellBtn, 'TOPLEFT', -5, 5)
        sellHighlight:SetPoint('BOTTOMRIGHT', bag.sellBtn, 'BOTTOMRIGHT', 5, -5)
        sellHighlight:SetTexture(media['tex:bags:sellbtn.blp'])
        sellHighlight:SetBlendMode('ADD')
        bag.sellBtn:SetScript('OnClick', function() setup:SellGreyItems() end)

        bag.search:SetScript('OnTextChanged', function()
            local text = this:GetText()
            if text == 'Search' or text == '' then
                for i = 0, 4 do
                    local b = setup[i]
                    if b and b.slots then
                        for _, btn in pairs(b.slots) do
                            btn:SetAlpha(1)
                            if btn.searchBorder then btn.searchBorder:Hide() end
                        end
                    end
                end
                return
            end

            local scanner = AU.lib.libtipscan:GetScanner('search')
            text = string.lower(text)

            for i = 0, 4 do
                local b = setup[i]
                if b and b.slots then
                    for _, btn in pairs(b.slots) do
                        local link = GetContainerItemLink(btn.bagID, btn.slotID)
                        if link then
                            local name = GetItemInfo(link)
                            local match = name and string.find(string.lower(name), text, 1, true)

                            if not match then
                                if not bag.searchCache[link] then
                                    scanner:SetBagItem(btn.bagID, btn.slotID)
                                    local tipText = ''
                                    for line = 1, 30 do
                                        local left = scanner:GetLine(line)
                                        if left then
                                            tipText = tipText..string.lower(left)..' '
                                        end
                                    end
                                    bag.searchCache[link] = tipText
                                end
                                match = string.find(bag.searchCache[link], text, 1, true)
                            end

                            btn:SetAlpha(match and 1 or 0.25)
                            if btn.searchBorder then
                                if match then btn.searchBorder:Show() else btn.searchBorder:Hide() end
                            end
                        else
                            btn:SetAlpha(0.25)
                            if btn.searchBorder then btn.searchBorder:Hide() end
                        end
                    end
                end
            end
        end)
    end

    local slotIndex = numSlots

    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            if slotIndex > 0 then
                local btn = self:CreateSlotButton(bag, frameName, slotIndex, bagID, buttonSize, spacing, col, row)
                table.insert(bag.slots, btn)
                slotIndex = slotIndex - 1
            end
        end
    end

    self:UpdateBag(bag)

    bag:SetScript('OnShow', function()
        local btn = getglobal(bagID == 0 and 'AU_MainBag' or 'AU_Bag'..(bagID - 1))
        if btn then btn:SetChecked(1) end
        setup:UpdateBag(bag)
        setup:UpdateMoney(bag)
        setup:RepositionBags()
        PlaySound('igBackPackOpen')
    end)
    bag:SetScript('OnHide', function()
        local btn = getglobal(bagID == 0 and 'AU_MainBag' or 'AU_Bag'..(bagID - 1))
        if btn then btn:SetChecked(nil) end
        if bagID == 0 and bag.searchCache then
            bag.searchCache = {}
        end
        setup:RepositionBags()
        PlaySound('igBackPackClose')
    end)

    table.insert(UISpecialFrames, bag:GetName())

    self[bagID] = bag
    return bag
end

function setup:CreateOneBag()
    local totalSlots = 0
    local bagSlots = {}

    for i = 0, 4 do
        local slots = i == 0 and 16 or (GetContainerNumSlots(i) or 0)
        if slots > 0 then
            bagSlots[i] = slots
            totalSlots = totalSlots + slots
        end
    end

    local cols = 8
    local rows = math.ceil(totalSlots / cols)
    local buttonSize = 37
    local spacing = 4
    local frameWidth = 20 + (cols * (buttonSize + spacing))
    local frameHeight = 100 + (rows * (buttonSize + spacing))

    local frameName = 'AU_OneBag'
    local bag = AU.ui.CreatePaperDollFrame(frameName, UIParent, frameWidth, frameHeight, 1)
    bag:EnableMouse(true)
    bag:SetID(999)
    bag.slots = {}
    bag.isUnified = true

    local bigbag = bag:CreateTexture(nil, 'OVERLAY')
    bigbag:SetTexture(media['tex:bags:bigbag.blp'])
    bigbag:SetPoint('TOPLEFT', bag, 'TOPLEFT', -10, 15)
    bigbag:SetHeight(74)
    bigbag:SetWidth(74)

    local closeBtn = AU.ui.CreateRedButton(bag, 'close', function() bag:Hide() end)
    closeBtn:SetPoint('TOPRIGHT', bag, 'TOPRIGHT', -1, -1)

    local title = bag:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    title:SetPoint('TOP', bag, 'TOP', 0, -5)
    title:SetTextColor(1, 1, 1)
    title:SetText(UnitName('player')..'\'s Backpack')

    bag.searchCache = {}
    bag.search = AU.ui.Editbox(bag, 170, 20, 50)
    bag.search:SetPoint('TOPRIGHT', bag, 'TOPRIGHT', -5, -25)
    bag.search:SetText('Search')
    bag.search:SetTextColor(0.5, 0.5, 0.5)

    bag.search:SetScript('OnEditFocusGained', function()
        local text = this:GetText()
        if text == 'Search' then
            this:SetText('')
            this:SetTextColor(1, 1, 1)
        else
            this:HighlightText()
        end
    end)

    bag.search:SetScript('OnEditFocusLost', function()
        local text = this:GetText()
        if text == '' then
            this:SetText('Search')
            this:SetTextColor(0.5, 0.5, 0.5)
            if setup.unified and setup.unified.slots then
                for _, btn in pairs(setup.unified.slots) do
                    btn:SetAlpha(1)
                end
            end
        end
    end)

    bag.search:SetScript('OnEscapePressed', function()
        local clearOnEscape = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['searchClearOnEscape']
        if clearOnEscape then
            this:SetText('')
            this:ClearFocus()
        else
            this:ClearFocus()
        end
    end)

    bag.moneyPanel = CreateFrame('Frame', nil, bag)
    bag.moneyPanel:SetSize(100, 17)
    bag.moneyPanel:SetPoint('TOPRIGHT', bag.search, 'BOTTOMRIGHT', -5, -2)
    local moneyBg = bag.moneyPanel:CreateTexture(nil, 'BACKGROUND')
    moneyBg:SetTexture('Interface\\Buttons\\WHITE8X8')
    moneyBg:SetAllPoints(bag.moneyPanel)
    moneyBg:SetVertexColor(0, 0, 0, 0.5)

    bag.moneyPanel.goldIcon = bag.moneyPanel:CreateTexture(nil, 'ARTWORK')
    bag.moneyPanel.goldIcon:SetTexture('Interface\\MoneyFrame\\UI-MoneyIcons')
    bag.moneyPanel.goldIcon:SetTexCoord(0, 0.25, 0, 1)
    bag.moneyPanel.goldIcon:SetSize(13, 13)
    bag.moneyPanel.goldIcon:SetPoint('LEFT', bag.moneyPanel, 'LEFT', 2, 0)
    bag.moneyPanel.gold = bag.moneyPanel:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
    bag.moneyPanel.gold:SetPoint('LEFT', bag.moneyPanel.goldIcon, 'RIGHT', 0, 0)

    bag.moneyPanel.silverIcon = bag.moneyPanel:CreateTexture(nil, 'ARTWORK')
    bag.moneyPanel.silverIcon:SetTexture('Interface\\MoneyFrame\\UI-MoneyIcons')
    bag.moneyPanel.silverIcon:SetTexCoord(0.25, 0.5, 0, 1)
    bag.moneyPanel.silverIcon:SetSize(13, 13)
    bag.moneyPanel.silverIcon:SetPoint('LEFT', bag.moneyPanel.gold, 'RIGHT', 2, 0)
    bag.moneyPanel.silver = bag.moneyPanel:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
    bag.moneyPanel.silver:SetPoint('LEFT', bag.moneyPanel.silverIcon, 'RIGHT', 0, 0)

    bag.moneyPanel.copperIcon = bag.moneyPanel:CreateTexture(nil, 'ARTWORK')
    bag.moneyPanel.copperIcon:SetTexture('Interface\\MoneyFrame\\UI-MoneyIcons')
    bag.moneyPanel.copperIcon:SetTexCoord(0.5, 0.75, 0, 1)
    bag.moneyPanel.copperIcon:SetSize(13, 13)
    bag.moneyPanel.copperIcon:SetPoint('LEFT', bag.moneyPanel.silver, 'RIGHT', 2, 0)
    bag.moneyPanel.copper = bag.moneyPanel:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
    bag.moneyPanel.copper:SetPoint('LEFT', bag.moneyPanel.copperIcon, 'RIGHT', 0, 0)

    bag.sellBtn = CreateFrame('Button', nil, bag)
    bag.sellBtn:SetSize(17, 17)
    bag.sellBtn:SetPoint('TOPRIGHT', bag.moneyPanel, 'BOTTOMRIGHT', -0, -4)
    local sellTex = bag.sellBtn:CreateTexture(nil, 'ARTWORK')
    sellTex:SetPoint('TOPLEFT', bag.sellBtn, 'TOPLEFT', -5, 5)
    sellTex:SetPoint('BOTTOMRIGHT', bag.sellBtn, 'BOTTOMRIGHT', 5, -5)
    sellTex:SetTexture(media['tex:bags:sellbtn.blp'])
    bag.sellBtn.tex = sellTex
    local sellHighlight = bag.sellBtn:CreateTexture(nil, 'HIGHLIGHT')
    sellHighlight:SetPoint('TOPLEFT', bag.sellBtn, 'TOPLEFT', -5, 5)
    sellHighlight:SetPoint('BOTTOMRIGHT', bag.sellBtn, 'BOTTOMRIGHT', 5, -5)
    sellHighlight:SetTexture(media['tex:bags:sellbtn.blp'])
    sellHighlight:SetBlendMode('ADD')
    bag.sellBtn:SetScript('OnClick', function() setup:SellGreyItems() end)

    bag.search:SetScript('OnTextChanged', function()
        local text = this:GetText()
        if text == 'Search' or text == '' then
            if setup.unified and setup.unified.slots then
                for _, btn in pairs(setup.unified.slots) do
                    btn:SetAlpha(1)
                    if btn.searchBorder then btn.searchBorder:Hide() end
                end
            end
            return
        end

        local scanner = AU.lib.libtipscan:GetScanner('search')
        text = string.lower(text)

        if setup.unified and setup.unified.slots then
            for _, btn in pairs(setup.unified.slots) do
                local link = GetContainerItemLink(btn.bagID, btn.slotID)
                if link then
                    local name = GetItemInfo(link)
                    local match = name and string.find(string.lower(name), text, 1, true)

                    if not match then
                        if not bag.searchCache[link] then
                            scanner:SetBagItem(btn.bagID, btn.slotID)
                            local tipText = ''
                            for line = 1, 30 do
                                local left = scanner:GetLine(line)
                                if left then
                                    tipText = tipText..string.lower(left)..' '
                                end
                            end
                            bag.searchCache[link] = tipText
                        end
                        match = string.find(bag.searchCache[link], text, 1, true)
                    end

                    btn:SetAlpha(match and 1 or 0.25)
                    if btn.searchBorder then
                        if match then btn.searchBorder:Show() else btn.searchBorder:Hide() end
                    end
                else
                    btn:SetAlpha(0.25)
                    if btn.searchBorder then btn.searchBorder:Hide() end
                end
            end
        end
    end)

    local slotIndex = 1
    local row = 0
    local col = 0

    for bagID = 0, 4 do
        if bagSlots[bagID] then
            for slot = 1, bagSlots[bagID] do
                local btn = self:CreateSlotButton(bag, frameName, slotIndex, bagID, buttonSize, spacing, col, row)
                btn.slotID = slot
                table.insert(bag.slots, btn)

                col = col + 1
                if col >= cols then
                    col = 0
                    row = row + 1
                end
                slotIndex = slotIndex + 1
            end
        end
    end

    self:UpdateBag(bag)

    bag:SetScript('OnShow', function()
        local btn = getglobal('AU_MainBag')
        if btn then btn:SetChecked(1) end
        setup:UpdateBag(bag)
        setup:UpdateMoney(bag)
        PlaySound('igBackPackOpen')
    end)
    bag:SetScript('OnHide', function()
        local btn = getglobal('AU_MainBag')
        if btn then btn:SetChecked(nil) end
        if bag.searchCache then
            bag.searchCache = {}
        end
        PlaySound('igBackPackClose')
    end)

    table.insert(UISpecialFrames, bag:GetName())

    self.unified = bag
    return bag
end

-- updates
function setup:UpdateBag(bagFrame)
    local slots = bagFrame.slots

    for i = 1, table.getn(slots) do
        local btn = slots[i]
        local bagID = btn.bagID or bagFrame:GetID()
        local slotID = btn.slotID or btn:GetID()

        local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bagID, slotID)

        if texture then
            btn.icon:SetTexture(texture)
            btn.icon:Show()

            if itemCount and itemCount > 1 then
                btn.count:SetText(itemCount)
                btn.count:Show()
            else
                btn.count:Hide()
            end

            ContainerFrame_UpdateCooldown(bagID, btn)
        else
            btn.icon:Hide()
            btn.count:Hide()
            if btn.cooldown then
                btn.cooldown:Hide()
                if btn.cooldown.text then
                    btn.cooldown.text:SetText('')
                end
            end
        end
    end
    self:UpdateMoney(bagFrame)
end

function setup:UpdateLocks(bagFrame)
    local slots = bagFrame.slots
    local scanner = AU.lib.libtipscan:GetScanner('unusable')
    local durability = string.gsub(DURABILITY_TEMPLATE, '%%[^%s]+', '(.+)')
    local color = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['unusableColour'] or {1, 0, 0, 1}
    local mode = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['showUnusableItems'] or 'both'

    for i = 1, table.getn(slots) do
        local btn = slots[i]
        local bagID = btn.bagID or bagFrame:GetID()
        local slotID = btn.slotID or btn:GetID()
        local texture, itemCount, locked = GetContainerItemInfo(bagID, slotID)

        if locked then
            btn.icon:SetDesaturated(1)
            btn.icon:SetVertexColor(0.5, 0.5, 0.5)
        else
            btn.icon:SetDesaturated(nil)
            if texture and mode ~= 'none' and (mode == 'icon' or mode == 'both') then
                scanner:SetBagItem(bagID, slotID)
                local red = scanner:FindColor(RED_FONT_COLOR)
                if red then
                    local left = scanner:GetLine(red)
                    local _, _, broken = string.find(left or '', durability)
                    if not broken then
                        btn.icon:SetVertexColor(color[1], color[2], color[3])
                    else
                        btn.icon:SetVertexColor(1, 1, 1)
                    end
                else
                    btn.icon:SetVertexColor(1, 1, 1)
                end
            else
                btn.icon:SetVertexColor(1, 1, 1)
            end
        end
    end
end

function setup:UpdateUnusableItems(bagFrame)
    local slots = bagFrame.slots
    local scanner = AU.lib.libtipscan:GetScanner('unusable')
    local durability = string.gsub(DURABILITY_TEMPLATE, '%%[^%s]+', '(.+)')
    local color = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['unusableColour'] or {1, 0, 0, 1}
    local mode = AU_GlobalDB and AU.profile['bags'] and AU.profile['bags']['showUnusableItems'] or 'both'

    for i = 1, table.getn(slots) do
        local btn = slots[i]
        local bagID = btn.bagID or bagFrame:GetID()
        local slotID = btn.slotID or btn:GetID()
        local texture = GetContainerItemInfo(bagID, slotID)

        if texture then
            scanner:SetBagItem(bagID, slotID)
            local red = scanner:FindColor(RED_FONT_COLOR)

            if red then
                local left = scanner:GetLine(red)
                local _, _, broken = string.find(left or '', durability)

                if not broken then
                    if mode == 'border' or mode == 'both' then
                        btn.unusableBorderTex:SetVertexColor(color[1], color[2], color[3], 1)
                        btn.unusableBorder:Show()
                    else
                        btn.unusableBorder:Hide()
                    end
                    if mode == 'icon' or mode == 'both' then
                        btn.icon:SetVertexColor(color[1], color[2], color[3])
                    else
                        btn.icon:SetVertexColor(1, 1, 1)
                    end
                else
                    btn.unusableBorder:Hide()
                    btn.icon:SetVertexColor(1, 1, 1)
                end
            else
                btn.unusableBorder:Hide()
                btn.icon:SetVertexColor(1, 1, 1)
            end
        else
            btn.unusableBorder:Hide()
        end
    end
end

function setup:UpdateMoney(bagFrame)
    if bagFrame.moneyPanel then
        local money = GetMoney()
        local g = math.floor(money / 10000)
        local s = math.floor(math.mod(money, 10000) / 100)
        local c = math.mod(money, 100)
        bagFrame.moneyPanel.gold:SetText(g)
        bagFrame.moneyPanel.silver:SetText(s)
        bagFrame.moneyPanel.copper:SetText(c)
        local width = bagFrame.moneyPanel.goldIcon:GetWidth() + bagFrame.moneyPanel.gold:GetStringWidth() + bagFrame.moneyPanel.silverIcon:GetWidth() + bagFrame.moneyPanel.silver:GetStringWidth() + bagFrame.moneyPanel.copperIcon:GetWidth() + bagFrame.moneyPanel.copper:GetStringWidth() + 12
        bagFrame.moneyPanel:SetWidth(width)
    end
end

function setup:RepositionBags()
    local visibleBags = {}
    for i = 0, 4 do
        if self[i] and self[i]:IsShown() then
            table.insert(visibleBags, self[i])
        end
    end

    if table.getn(visibleBags) == 0 then return end

    local anchor = getglobal('AU_BagAnchor')
    if not anchor then return end

    local screenHeight = UIParent:GetHeight()
    local anchorY = anchor:GetBottom() or 20
    local maxColumnHeight = screenHeight - anchorY - 20
    local spacing = 20
    local columnOffset = 0
    local currentHeight = 0

    -- debugprint('RepositionBags: screenHeight='..screenHeight..' anchorY='..anchorY..' maxColumnHeight='..maxColumnHeight)

    for i = 1, table.getn(visibleBags) do
        local bag = visibleBags[i]
        local bagHeight = bag:GetHeight() * bag:GetScale()

        if i == 1 then
            bag:ClearAllPoints()
            bag:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 0 - columnOffset, 0)
            currentHeight = bagHeight
        else
            if currentHeight + bagHeight + spacing > maxColumnHeight then
                -- debugprint('Bag'..bag:GetID()..' would exceed max ('..currentHeight..'+'..bagHeight..'>'..maxColumnHeight..'), starting new column at offset='..columnOffset + 200)
                columnOffset = columnOffset + 200
                bag:ClearAllPoints()
                bag:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 0 - columnOffset, 0)
                currentHeight = bagHeight
            else
                bag:ClearAllPoints()
                bag:SetPoint('BOTTOMLEFT', visibleBags[i-1], 'TOPLEFT', 0, spacing)
                currentHeight = currentHeight + bagHeight + spacing
                -- debugprint('Bag'..bag:GetID()..' stacked, currentHeight='..currentHeight..' (still under '..maxColumnHeight..')')
            end
        end
    end
end

function setup:TruncateText(text, maxWidth, fontString)
    fontString:SetText(text)
    if fontString:GetStringWidth() <= maxWidth then
        return
    end

    local truncated = text
    while fontString:GetStringWidth() > maxWidth and string.len(truncated) > 0 do
        truncated = string.sub(truncated, 1, string.len(truncated) - 1)
        fontString:SetText(truncated..'..')
    end
end

function setup:SellGreyItems()
    if not MerchantFrame:IsVisible() then return end
    if not self.autoSellEnabled then return end

    if not self.sellFrame then
        self.sellFrame = CreateFrame('Frame')
        self.sellFrame.tick = 0
        self.sellFrame.count = 0
        self.sellFrame.startGold = 0
        self.sellFrame.processed = {}

        self.sellFrame:SetScript('OnShow', function()
            this.processed = {}
            this.count = 0
            this.startGold = GetMoney()
            this.tick = 0
        end)

        self.sellFrame:SetScript('OnUpdate', function()
            local now = GetTime()
            if this.tick > now then return end
            this.tick = now + 0.1

            if not MerchantFrame:IsVisible() then
                this:Hide()
                return
            end

            local bag, slot, link
            for b = 0, 4 do
                for s = 1, GetContainerNumSlots(b) do
                    local l = GetContainerItemLink(b, s)
                    if l and string.find(l, 'ff9d9d9d') and not this.processed[b..'x'..s] then
                        this.processed[b..'x'..s] = true
                        bag, slot, link = b, s, l
                        break
                    end
                end
                if bag then break end
            end

            if not bag or not slot then
                this:Hide()
                return
            end

            if not link or not string.find(link, 'ff9d9d9d') then return end

            ClearCursor()
            UseContainerItem(bag, slot)
            this.count = this.count + 1
        end)

        self.sellFrame:SetScript('OnHide', function()
            if this.count > 0 then
                local income = GetMoney() - this.startGold
                local g = math.floor(income / 10000)
                local s = math.floor(math.mod(income, 10000) / 100)
                local c = math.mod(income, 100)
                DEFAULT_CHAT_FRAME:AddMessage('Sold ' .. this.count .. ' grey items for ' .. g .. 'g ' .. s .. 's ' .. c .. 'c')
            else
                DEFAULT_CHAT_FRAME:AddMessage('No grey items to sell')
            end
        end)
    end

    self.sellFrame:Show()
end

function setup:RepairItems()
    if not MerchantFrame:IsVisible() then
        DEFAULT_CHAT_FRAME:AddMessage('RepairItems: Merchant not visible')
        return
    end
    if not CanMerchantRepair() then
        DEFAULT_CHAT_FRAME:AddMessage('RepairItems: Merchant cannot repair')
        return
    end

    local cost, possible = GetRepairAllCost()
    if cost > 0 and possible then
        RepairAllItems()
        local g = math.floor(cost / 10000)
        local s = math.floor(math.mod(cost, 10000) / 100)
        local c = math.mod(cost, 100)
        DEFAULT_CHAT_FRAME:AddMessage('Repaired items for ' .. g .. 'g ' .. s .. 's ' .. c .. 'c')
    else
        DEFAULT_CHAT_FRAME:AddMessage('RepairItems: No repair needed or not possible')
    end
end

-- init
function setup:InitializeBags()
    self:CreateBagFrame(0, 16)
    self[0]:SetFrameStrata('HIGH')
    self[0]:Hide()
    self[0]:SetScale(.85)

    local containerFrame = getglobal('AU_ContainerFrame1')
    local anchor = CreateFrame('Frame', 'AU_BagAnchor', UIParent)
    anchor:SetWidth(containerFrame:GetWidth())
    anchor:SetHeight(containerFrame:GetHeight())
    anchor:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -40, 70)

    for i = 1, 4 do
        local slots = GetContainerNumSlots(i) or 0
        if slots > 0 then
            self:CreateBagFrame(i, slots)
            self[i]:SetFrameStrata('HIGH')
            self[i]:Hide()
            self[i]:SetScale(.85)
        end
    end

    return self[0], self[1], self[2], self[3], self[4]
end

function setup:InitializeOneBag()
    self:CreateOneBag()
    local anchor = getglobal('AU_BagAnchor')
    self.unified:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 0, 0)
    self.unified:SetFrameStrata('MEDIUM')
    self.unified:Hide()

    return self.unified
end

-- expose
AU.setups.bags = setup
