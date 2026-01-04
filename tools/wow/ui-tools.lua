DRAGONFLIGHT()

local CAL_DATA = DF.date.CalendarData()

local BUTTON_TEXCOORDS = {
    close = {
        normal = {0.152344, 0.292969, 0.0078125, 0.304688},
        pushed = {0.152344, 0.292969, 0.320312, 0.617188}
    },
    minimize = {
        normal = {0.00390625, 0.144531, 0.0078125, 0.304688},
        pushed = {0.00390625, 0.144531, 0.320312, 0.617188}
    },
    maximize = {
        normal = {0.300781, 0.441406, 0.0078125, 0.304688},
        pushed = {0.300781, 0.441406, 0.320312, 0.617188}
    },
    minicondense = {
        normal = {0.449219, 0.589844, 0.320312, 0.617188},
        pushed = {0.597656, 0.738281, 0.0078125, 0.304688}
    },
    highlight = {0.449219, 0.589844, 0.0078125, 0.304688}
}

DF.ui.staticPopup = nil

-- public
-- basic elements
function DF.ui.SlotButton(parent, name, size)
    local button = CreateFrame('CheckButton', name, parent)
    button:SetSize(size or 36, size or 36)

    button.icon = button:CreateTexture(nil, 'BORDER')
    button.icon:SetAllPoints(button)

    button.bg = button:CreateTexture(nil, 'BACKGROUND')
    button.bg:SetTexture('Interface\\Buttons\\White8x8')
    button.bg:SetVertexColor(1, 1, 1, .5)
    button.bg:SetAllPoints(button)

    button.border = CreateFrame('Frame', nil, button)
    button.border:SetAllPoints(button)
    button.border:SetFrameLevel(button:GetFrameLevel() + 1)
    button.border:SetBackdrop({
        edgeFile = 'Interface\\Buttons\\White8x8',
        edgeSize = 3
    })
    button.border:SetBackdropBorderColor(1, 1, 1, 1)

    button.cooldown = CreateFrame('Model', name..'Cooldown', button, 'CooldownFrameTemplate')
    button.cooldown:SetAllPoints(button)
    button.cooldown:SetFrameLevel(button:GetFrameLevel() + 2)

    button.checked = CreateFrame('Frame', nil, button)
    button.checked:SetAllPoints(button)
    button.checked:SetFrameLevel(button:GetFrameLevel() + 3)
    button.checked:SetBackdrop({
        edgeFile = 'Interface\\Buttons\\White8x8',
        edgeSize = 1
    })
    button.checked:SetBackdropBorderColor(1, 1, 0, 1)
    button.checked:Hide()

    button.pushed = CreateFrame('Frame', nil, button)
    button.pushed:SetAllPoints(button)
    button.pushed:SetFrameLevel(button:GetFrameLevel() + 5)
    button.pushed:SetBackdrop({
        edgeFile = 'Interface\\Buttons\\White8x8',
        edgeSize = 2
    })
    button.pushed:SetBackdropBorderColor(0, .5, .6, 1)
    button.pushed:Hide()

    button.highlight = CreateFrame('Frame', nil, button)
    button.highlight:SetAllPoints(button)
    button.highlight:SetFrameLevel(button:GetFrameLevel() + 6)
    button.highlight:SetBackdrop({
        edgeFile = 'Interface\\Buttons\\White8x8',
        edgeSize = 3
    })
    button.highlight:SetBackdropBorderColor(1, 1, 0, 1)
    button.highlight:Hide()

    button:SetScript('OnEnter', function()
        this.highlight:Show()
    end)

    button:SetScript('OnLeave', function()
        this.highlight:Hide()
    end)

    button:SetScript('OnMouseDown', function()
        this.pushed:Show()
    end)

    button:SetScript('OnMouseUp', function()
        this.pushed:Hide()
    end)

    return button
end

function DF.ui.CreateTabs(parent, name, flipVertical)
    parent = parent or UIParent
    local container = CreateFrame('Frame', name, parent)
    container:SetSize(1, 1)
    container.tabs = {}
    container.selectedTab = nil

    function container:AddTab(text, onClick, tabWidth)
        local tab = CreateFrame('Button', nil, container)
        tab:SetSize(tabWidth or 70, 32)

        local tex = media['tex:interface:uiframetabs']

        local left = tab:CreateTexture(nil, 'BACKGROUND')
        left:SetTexture(tex)
        left:SetSize(35, 36)
        left:SetPoint('TOPLEFT', tab, 'TOPLEFT', -3, 0)
        if flipVertical then
            left:SetTexCoord(0.015625, 0.5625, 0.957031, 0.816406)
        else
            left:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)
        end

        local right = tab:CreateTexture(nil, 'BACKGROUND')
        right:SetTexture(tex)
        right:SetSize(37, 36)
        right:SetPoint('TOPRIGHT', tab, 'TOPRIGHT', 7, 0)
        if flipVertical then
            right:SetTexCoord(0.015625, 0.59375, 0.808594, 0.667969)
        else
            right:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)
        end

        local middle = tab:CreateTexture(nil, 'BACKGROUND')
        middle:SetTexture(tex)
        middle:SetSize(1, 36)
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)
        if flipVertical then
            middle:SetTexCoord(0, 0.015625, 0.316406, 0.175781)
        else
            middle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
        end

        local leftSel = tab:CreateTexture(nil, 'BACKGROUND')
        leftSel:SetTexture(tex)
        leftSel:SetSize(35, 45)
        leftSel:SetPoint('BOTTOMLEFT', tab, 'BOTTOMLEFT', -1, 0)
        if flipVertical then
            leftSel:SetTexCoord(0.015625, 0.5625, 0.660156, 0.496094)
        else
            leftSel:SetTexCoord(0.015625, 0.5625, 0.496094, 0.660156)
        end
        leftSel:Hide()

        local rightSel = tab:CreateTexture(nil, 'BACKGROUND')
        rightSel:SetTexture(tex)
        rightSel:SetSize(37, 45)
        rightSel:SetPoint('BOTTOMRIGHT', tab, 'BOTTOMRIGHT', 8, 0)
        if flipVertical then
            rightSel:SetTexCoord(0.015625, 0.59375, 0.488281, 0.324219)
        else
            rightSel:SetTexCoord(0.015625, 0.59375, 0.324219, 0.488281)
        end
        rightSel:Hide()

        local middleSel = tab:CreateTexture(nil, 'BACKGROUND')
        middleSel:SetTexture(tex)
        middleSel:SetSize(1, 45)
        middleSel:SetPoint('BOTTOMLEFT', leftSel, 'BOTTOMRIGHT', 0, 0)
        middleSel:SetPoint('BOTTOMRIGHT', rightSel, 'BOTTOMLEFT', 0, 0)
        if flipVertical then
            middleSel:SetTexCoord(0, 0.015625, 0.167969, 0.00390625)
        else
            middleSel:SetTexCoord(0, 0.015625, 0.00390625, 0.167969)
        end
        middleSel:Hide()

        local hlLeft = tab:CreateTexture(nil, 'HIGHLIGHT')
        hlLeft:SetTexture(tex)
        hlLeft:SetSize(35, 36)
        hlLeft:SetPoint('TOPLEFT', tab, 'TOPLEFT', -3, 0)
        if flipVertical then
            hlLeft:SetTexCoord(0.015625, 0.5625, 0.957031, 0.816406)
        else
            hlLeft:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)
        end
        hlLeft:SetBlendMode('ADD')
        hlLeft:SetAlpha(0.4)

        local hlRight = tab:CreateTexture(nil, 'HIGHLIGHT')
        hlRight:SetTexture(tex)
        hlRight:SetSize(37, 36)
        hlRight:SetPoint('TOPRIGHT', tab, 'TOPRIGHT', 7, 0)
        if flipVertical then
            hlRight:SetTexCoord(0.015625, 0.59375, 0.808594, 0.667969)
        else
            hlRight:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)
        end
        hlRight:SetBlendMode('ADD')
        hlRight:SetAlpha(0.4)

        local hlMiddle = tab:CreateTexture(nil, 'HIGHLIGHT')
        hlMiddle:SetTexture(tex)
        hlMiddle:SetSize(1, 36)
        hlMiddle:SetPoint('TOPLEFT', hlLeft, 'TOPRIGHT', 0, 0)
        hlMiddle:SetPoint('TOPRIGHT', hlRight, 'TOPLEFT', 0, 0)
        if flipVertical then
            hlMiddle:SetTexCoord(0, 0.015625, 0.316406, 0.175781)
        else
            hlMiddle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
        end
        hlMiddle:SetBlendMode('ADD')
        hlMiddle:SetAlpha(0.4)

        local label = tab:CreateFontString(nil, 'BORDER', 'GameFontNormalSmall')
        if flipVertical then
            label:SetPoint('CENTER', tab, 'CENTER', 0, -4)
        else
            label:SetPoint('CENTER', tab, 'CENTER', 0, 2)
        end
        label:SetText(text)

        function tab:SetSelected(selected)
            if selected then
                left:Hide()
                right:Hide()
                middle:Hide()
                leftSel:Show()
                rightSel:Show()
                middleSel:Show()
                hlLeft:SetHeight(45)
                hlRight:SetHeight(45)
                hlMiddle:SetHeight(45)
                label:SetTextColor(1, 1, 1)
            else
                left:Show()
                right:Show()
                middle:Show()
                leftSel:Hide()
                rightSel:Hide()
                middleSel:Hide()
                hlLeft:SetHeight(36)
                hlRight:SetHeight(36)
                hlMiddle:SetHeight(36)
                label:SetTextColor(1, 0.82, 0)
            end
        end

        local numTabs = table.getn(container.tabs)
        if numTabs == 0 then
            tab:SetPoint('LEFT', container, 'LEFT', 0, 0)
        else
            tab:SetPoint('LEFT', container.tabs[numTabs], 'RIGHT', 2, 0)
        end

        tab:SetScript('OnClick', function()
            PlaySound('igCharacterInfoTab')
            if container.selectedTab then
                container.selectedTab:SetSelected(false)
            end
            tab:SetSelected(true)
            container.selectedTab = tab
            if onClick then onClick() end
        end)

        table.insert(container.tabs, tab)

        if numTabs == 0 then
            tab:SetSelected(true)
            container.selectedTab = tab
        end

        return tab
    end

    return container
end

function DF.ui.PageButton(parent, width, height, name, direction, iconOffset)
    parent = parent or UIParent
    name = name or ('DF_Button')
    width = width or 36
    height = height or 36
    direction = direction or 'west'
    iconOffset = iconOffset or 13
    local normalPath = media['tex:bags:expand.tga']
    local bgPath = media['tex:interface:chat_btn_bg.blp']

    local coords = {
        north = {0, 0, 1, 0, 0, 1, 1, 1},
        east = {1, 0, 1, 1, 0, 0, 0, 1},
        south = {1, 1, 0, 1, 1, 0, 0, 0},
        west = {0, 1, 0, 0, 1, 1, 1, 0}
    }

    local btn = CreateFrame('Button', name, parent)
    btn:SetSize(width, height)

    local bg = btn:CreateTexture(nil, 'BACKGROUND')
    bg:SetAllPoints(btn)
    bg:SetTexture(bgPath)
    bg:SetVertexColor(0, 0, 0, 0.5)

    local icon = btn:CreateTexture(nil, 'ARTWORK')
    icon:SetPoint('CENTER', btn)
    icon:SetSize(width - iconOffset, height - iconOffset)
    icon:SetTexture(normalPath)
    icon:SetTexCoord(unpack(coords[direction]))

    local highlight = btn:CreateTexture(nil, 'HIGHLIGHT')
    highlight:SetTexture(normalPath)
    highlight:SetPoint('CENTER', btn)
    highlight:SetSize(width - iconOffset, height - iconOffset)
    highlight:SetTexCoord(unpack(coords[direction]))
    highlight:SetBlendMode('ADD')
    highlight:SetAlpha(0)

    btn:SetScript('OnEnter', function()
        highlight:SetAlpha(1)
    end)
    btn:SetScript('OnLeave', function()
        highlight:SetAlpha(0)
    end)

    return btn
end

function DF.ui.Frame(parent, width, height, alpha, mouse, name)
    parent = parent or UIParent
    local f = CreateFrame('Frame', name, parent)
    f:SetSize(width or 100, height or 100)
    f:EnableMouse(mouse or false)
    f:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8X8'})
    f:SetBackdropColor(0, 0, 0, alpha or 0.5)
    return f
end

function DF.ui.Scrollframe(parent, width, height, name)
    local scroll = CreateFrame('ScrollFrame', name, parent or UIParent)
    scroll:SetSize(width or 200, height or 300)

    local contentName = name and (name .. '_Content') or nil
    local content = CreateFrame('Frame', contentName, scroll)
    content:SetSize(width or 200, 1)
    scroll:SetScrollChild(content)

    local scrollBarName = name and (name .. '_ScrollBar') or nil
    local scrollBar = CreateFrame('Slider', scrollBarName, scroll)
    scrollBar:SetSize(2, height or 300)
    scrollBar:SetPoint('TOPRIGHT', scroll, 'TOPRIGHT', 0, 0)
    scrollBar:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8X8'})
    scrollBar:SetBackdropColor(0.2, 0.2, 0.2, 0.8)
    scrollBar:SetOrientation('VERTICAL')
    scrollBar:Hide()

    local thumb = scrollBar:CreateTexture(nil, 'OVERLAY')
    thumb:SetTexture('Interface\\Buttons\\WHITE8X8')
    thumb:SetSize(4, 20)
    scrollBar:SetThumbTexture(thumb)

    scrollBar:SetScript('OnValueChanged', function()
        local value = this:GetValue()
        scroll:SetVerticalScroll(value)
    end)

    -- physics-based momentum calculation
    local velocity = 0
    scroll:EnableMouseWheel(true)
    scroll:SetScript('OnMouseWheel', function()
        velocity = velocity + (arg1 * - 6)
        if not scroll:GetScript('OnUpdate') then
            scroll:SetScript('OnUpdate', function()
                if math.abs(velocity) > 0.5 and scroll:IsVisible() then
                    local current = scroll:GetVerticalScroll()
                    local maxScroll = math.max(0, content:GetHeight() - scroll:GetHeight())
                    local newScroll = math.max(0, math.min(maxScroll, current + velocity))
                    scroll:SetVerticalScroll(newScroll)
                    scrollBar:SetMinMaxValues(0, maxScroll)
                    scrollBar:SetValue(newScroll)
                    velocity = velocity * 0.85
                else
                    velocity = 0
                    scroll:SetScript('OnUpdate', nil)
                end
            end)
        end
    end)

    scroll.updateScrollBar = function()
        local maxScroll = math.max(0, content:GetHeight() - scroll:GetHeight())
        if maxScroll <= 0 then
            scrollBar:Hide()
        else
            scrollBar:Show()
            scrollBar:SetMinMaxValues(0, maxScroll)
            local currentScroll = scroll:GetVerticalScroll()
            scrollBar:SetValue(math.min(currentScroll, maxScroll))
        end
    end

    scroll.content = content
    scroll.scrollBar = scrollBar
    return scroll
end

function DF.ui.Button(parent, text, width, height, noBackdrop, textColor, noHighlight, name)
    local btn = CreateFrame('Button', name, parent or UIParent)
    btn:SetSize(width or 140, height or 30)
    if not noBackdrop then
        -- local bg = btn:CreateTexture(nil, 'BACKGROUND')
        -- bg:SetTexture('Interface\\AddOns\\Dragonflight3-BIOS\\media\\tex\\interface\\testbtn')
        -- bg:SetWidth(btn:GetWidth())
        -- bg:SetHeight(36)
        -- bg:SetPoint('CENTER', btn, 'CENTER', 0, -10)
        -- bg:SetVertexColor(.4,.4,.4)
        -- btn.bg = bg
        btn:SetBackdrop({
            bgFile = 'Interface\\Buttons\\WHITE8X8',
            edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        btn:SetBackdropColor(0, 0, 0, .5)
        btn:SetBackdropBorderColor(0.2, 0.2, 0.2, .5)
    end

    local btnTxt = btn:CreateFontString(nil, 'OVERLAY')
    btnTxt:SetFont('Fonts\\FRIZQT__.TTF', 12, 'OUTLINE')
    btnTxt:SetPoint('CENTER', btn, 'CENTER', 0, 0)
    btnTxt:SetText(text)

    if textColor then
        btnTxt:SetTextColor(textColor[1], textColor[2], textColor[3])
    else
        btnTxt:SetTextColor(1, 1, 1)
    end

    btn.text = btnTxt

    local origEnable = btn.Enable
    local origDisable = btn.Disable

    btn.Enable = function(self)
        origEnable(self)
        if textColor then
            btnTxt:SetTextColor(textColor[1], textColor[2], textColor[3])
        else
            btnTxt:SetTextColor(1, 1, 1)
        end
    end

    btn.Disable = function(self)
        origDisable(self)
        btnTxt:SetTextColor(0.5, 0.5, 0.5)
    end

    if not noHighlight then
        local highlight = btn:CreateTexture(nil, 'HIGHLIGHT')
        highlight:SetTexture('Interface\\QuestFrame\\UI-QuestTitleHighlight')
        highlight:SetPoint('TOPLEFT', btn, 'TOPLEFT', 2, -4)
        highlight:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', -2, 4)
        highlight:SetBlendMode('ADD')
    end

    return btn
end

function DF.ui.Font(parent, size, text, colour, align, outline)
    local font = parent:CreateFontString(nil, 'OVERLAY')
    font:SetFont('Fonts\\FRIZQT__.TTF', size or 14, outline or 'OUTLINE')
    colour = colour or {1, 1, 1}
    font:SetTextColor(colour[1], colour[2], colour[3])
    font:SetText(text)
    font.align = align or 'CENTER'
    font:SetJustifyH(font.align)
    return font
end

function DF.ui.Editbox(parent, width, height, max)
    local box = CreateFrame('EditBox', nil, parent or UIParent)
    box:SetSize(width or 100, height or 20)
    box:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8X8',
        edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    box:SetBackdropColor(0, 0, 0, 0.8)
    box:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    box:SetFont('Fonts\\FRIZQT__.TTF', 14, 'OUTLINE')
    box:SetTextColor(1, 1, 1)
    box:SetTextInsets(5, 5, 5, 5)
    box:SetAutoFocus(false)
    box:SetMaxLetters(max or 33)
    return box
end

function DF.ui.Checkbox(parent, text, width, height, labelSide)
    local checkbox = CreateFrame('CheckButton', nil, parent or UIParent, 'UICheckButtonTemplate')
    checkbox:SetSize(width or 20, height or 20)

    local label = checkbox:CreateFontString(nil, 'BACKGROUND')
    label:SetFont('Fonts\\FRIZQT__.TTF', 12, 'OUTLINE')
    if labelSide == 'RIGHT' then
        label:SetPoint('LEFT', checkbox, 'RIGHT', 5, 0)
    else
        label:SetPoint('RIGHT', checkbox, 'LEFT', -5, 0)
    end
    label:SetText(text or 'Checkbox')
    label:SetTextColor(.9,.9,.9)
    checkbox.label = label

    checkbox:SetChecked(false)

    local origEnable = checkbox.Enable
    local origDisable = checkbox.Disable

    checkbox.Enable = function(self)
        if origEnable then origEnable(self) end
        self:EnableMouse(true)
        self.label:SetTextColor(.9,.9,.9)
    end

    checkbox.Disable = function(self)
        if origDisable then origDisable(self) end
        self:EnableMouse(false)
        self.label:SetTextColor(0.5, 0.5, 0.5)
    end

    return checkbox
end

function DF.ui.Dropdown(parent, text, width, height)
    local btn = DF.ui.Button(parent, text or 'Dropdown', width or 120, height or 25)

    local popup = CreateFrame('Frame', nil, UIParent)
    popup:SetSize(btn:GetWidth(), 50)
    popup:SetPoint('TOP', btn, 'BOTTOM', 0, -2)
    popup:SetFrameLevel(btn:GetFrameLevel() + 1)
    popup:SetFrameStrata('DIALOG')
    popup:EnableMouse(true)
    popup:Hide()

    local bg = popup:CreateTexture(nil, 'BACKGROUND')
    bg:SetTexture('Interface\\Buttons\\WHITE8X8')
    bg:SetAllPoints(popup)
    bg:SetVertexColor(0, 0, 0, 0.8)

    btn.popup = popup
    btn.selectedValue = nil
    btn.items = {}

    btn.Clear = function(self)
        for i = 1, table.getn(self.items) do
            self.items[i]:Hide()
        end
        self.items = {}
        popup:SetHeight(10)
        popup:SetWidth(btn:GetWidth())
    end

    btn.AddItem = function(self, itemText, callback)
        local count = table.getn(self.items)
        local col = math.floor(count / 15)
        local row = math.mod(count, 15)
        local itemWidth = btn:GetWidth() - 4

        local itemBtn = DF.ui.Button(popup, itemText, itemWidth, 20, true)
        itemBtn:SetPoint('TOPLEFT', popup, 'TOPLEFT', col * btn:GetWidth() + 2, -row * 22 - 5)
        itemBtn:SetScript('OnClick', callback or function()
            btn.text:SetText(itemText)
            btn.selectedValue = itemText
            popup:Hide()
        end)
        table.insert(self.items, itemBtn)

        local numCols = math.floor(count / 15) + 1
        local numRows = math.min(count + 1, 15)
        popup:SetWidth(numCols * btn:GetWidth())
        popup:SetHeight(numRows * 22 + 10)
    end

    btn:SetScript('OnClick', function()
        if popup:IsVisible() then
            popup:Hide()
        else
            popup:Show()
        end
    end)

    return btn
end

function DF.ui.Slider(parent, name, text, minVal, maxVal, step, format, width, height)
    local slider = CreateFrame('Slider', name, parent)
    slider:SetSize(width or 136, height or 24)
    slider:SetOrientation('HORIZONTAL')
    slider:SetThumbTexture('Interface\\Buttons\\UI-SliderBar-Button-Horizontal')
    slider:SetBackdrop({
        bgFile = 'Interface\\Buttons\\UI-SliderBar-Background',
        edgeFile = 'Interface\\Buttons\\UI-SliderBar-Border',
        tile = true, tileSize = 8, edgeSize = 8,
        insets = { left = 3, right = 3, top = 6, bottom = 6 }
    })

    slider:SetMinMaxValues(minVal or 0, maxVal or 5)
    slider:SetValueStep(step or 0.1)

    local label = slider:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    label:SetPoint('BOTTOMRIGHT', slider, 'TOPRIGHT', 0, -0)
    label:SetText(text or 'Slider')
    label:SetFont('Fonts\\FRIZQT__.TTF', 12, 'OUTLINE')
    label:SetTextColor(.9,.9,.9)
    slider.label = label

    local leftBtn = DF.ui.Button(parent, '<', 25, height or 24)
    leftBtn:SetPoint('RIGHT', slider, 'LEFT', -5, 0)
    slider.leftBtn = leftBtn

    local rightBtn = DF.ui.Button(parent, '>', 25, height or 24)
    rightBtn:SetPoint('LEFT', slider, 'RIGHT', 5, 0)
    slider.rightBtn = rightBtn

    local valueText = slider:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    valueText:SetPoint('RIGHT', leftBtn, 'LEFT', -5, 0)
    valueText:SetTextColor(1, 1, 1)
    valueText:SetFont('Fonts\\FRIZQT__.TTF', 12, 'OUTLINE')
    slider.valueText = valueText

    local fmt = format or '%.1f'
    local stepVal = step or 0.1

    slider:SetValue(minVal or 0)
    valueText:SetText(string.format(fmt, minVal or 0))

    local function updateValueText()
        local newValue = slider:GetValue()
        local roundedValue = math.floor(newValue * 10 + 0.5) / 10
        valueText:SetText(string.format(fmt, roundedValue))
    end

    slider.updateValueText = updateValueText

    leftBtn:SetScript('OnClick', function()
        local val = slider:GetValue() - stepVal
        if val < (minVal or 0) then val = minVal or 0 end
        slider:SetValue(val)
    end)

    rightBtn:SetScript('OnClick', function()
        local val = slider:GetValue() + stepVal
        if val > (maxVal or 5) then val = maxVal or 5 end
        slider:SetValue(val)
    end)

    local originalSetScript = slider.SetScript
    slider.SetScript = function(self, handler, func)
        if handler == 'OnValueChanged' then
            originalSetScript(self, handler, function()
                updateValueText()
                if func then func() end
            end)
        else
            originalSetScript(self, handler, func)
        end
    end

    slider:SetScript('OnValueChanged', updateValueText)

    local origEnable = slider.Enable
    local origDisable = slider.Disable

    slider.Enable = function(self)
        if origEnable then origEnable(self) end
        self:EnableMouse(true)
        self.label:SetTextColor(.9,.9,.9)
        self.valueText:SetTextColor(1, 1, 1)
        self.leftBtn:Enable()
        self.rightBtn:Enable()
    end

    slider.Disable = function(self)
        if origDisable then origDisable(self) end
        self:EnableMouse(false)
        self.label:SetTextColor(0.5, 0.5, 0.5)
        self.valueText:SetTextColor(0.5, 0.5, 0.5)
        self.leftBtn:Disable()
        self.rightBtn:Disable()
    end

    return slider
end

function DF.ui.ColorPicker(parent, initialColor, callback)
    local btn = DF.ui.Button(parent, '', 30, 25, false)
    btn.selectedColor = initialColor or {1, 1, 1, 1}

    local swatch = btn:CreateTexture(nil, 'OVERLAY')
    swatch:SetTexture('Interface\\Buttons\\WHITE8X8')
    swatch:SetPoint('CENTER', btn, 'CENTER', 0, 0)
    swatch:SetSize(20, 15)
    swatch:SetVertexColor(btn.selectedColor[1], btn.selectedColor[2], btn.selectedColor[3])
    btn.swatch = swatch

    local COLS = 18
    local ROWS = 14
    local SWATCH_SIZE = 16

    local popup = CreateFrame('Frame', nil, UIParent)
    popup:SetSize(COLS * SWATCH_SIZE + 10, ROWS * SWATCH_SIZE + 10)
    popup:SetPoint('TOPRIGHT', btn, 'TOPLEFT', -2, 0)
    popup:SetFrameLevel(btn:GetFrameLevel() + 1)
    popup:SetFrameStrata('DIALOG')
    popup:EnableMouse(true)
    popup:Hide()
    popup:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8X8'})
    popup:SetBackdropColor(0, 0, 0, 0.9)

    local function HSVtoRGB(h, s, v)
        if s == 0 then return v, v, v end
        local i = math.floor(h * 6)
        local f = h * 6 - i
        local p = v * (1 - s)
        local q = v * (1 - f * s)
        local t = v * (1 - (1 - f) * s)
        i = math.mod(i, 6)
        if i == 0 then return v, t, p
        elseif i == 1 then return q, v, p
        elseif i == 2 then return p, v, t
        elseif i == 3 then return p, q, v
        elseif i == 4 then return t, p, v
        else return v, p, q end
    end

    for row = 0, ROWS - 1 do
        for col = 0, COLS - 1 do
            local colorBtn = CreateFrame('Button', nil, popup)
            colorBtn:SetSize(SWATCH_SIZE, SWATCH_SIZE)
            colorBtn:SetPoint('TOPLEFT', popup, 'TOPLEFT', col * SWATCH_SIZE + 5, -row * SWATCH_SIZE - 5)

            local r, g, b
            if row == ROWS - 1 then
                local gray = col / (COLS - 1)
                r, g, b = gray, gray, gray
            else
                local hue = col / COLS
                local sat = 0.95
                local val = 1 - (row / (ROWS - 2)) * 0.75
                r, g, b = HSVtoRGB(hue, sat, val)
            end

            local colorTex = colorBtn:CreateTexture(nil, 'BACKGROUND')
            colorTex:SetTexture('Interface\\Buttons\\WHITE8X8')
            colorTex:SetAllPoints(colorBtn)
            colorTex:SetVertexColor(r, g, b)

            local highlight = colorBtn:CreateTexture(nil, 'HIGHLIGHT')
            highlight:SetTexture('Interface\\Buttons\\WHITE8X8')
            highlight:SetPoint('TOPLEFT', colorBtn, 'TOPLEFT', 0, 0)
            highlight:SetPoint('BOTTOMRIGHT', colorBtn, 'BOTTOMRIGHT', 0, 0)
            highlight:SetVertexColor(1, 1, 1, 0.6)

            colorBtn:SetScript('OnClick', function()
                local currentAlpha = btn.selectedColor[4] or 1
                btn.selectedColor = {r, g, b, currentAlpha}
                swatch:SetVertexColor(r, g, b)
                popup:Hide()
                if callback then
                    callback(btn.selectedColor)
                end
            end)
        end
    end

    btn:SetScript('OnClick', function()
        if popup:IsVisible() then
            popup:Hide()
        else
            popup:Show()
        end
    end)

    btn.popup = popup
    return btn
end

function DF.ui.ToggleButton(parent, text, width, height, initialState)
    local btn = DF.ui.Button(parent, text or 'Toggle', width or 100, height or 25, false)
    btn.isToggled = initialState or false

    local function updateAppearance()
        if btn.isToggled then
            btn:SetBackdropColor(0.3, 0.6, 0.3, 0.8)
            btn.text:SetTextColor(1, 1, 1)
        else
            btn:SetBackdropColor(0.2, 0.2, 0.2, 0.8)
            btn.text:SetTextColor(0.9, 0.9, 0.9)
        end
    end

    btn:SetScript('OnClick', function()
        btn.isToggled = not btn.isToggled
        updateAppearance()
        if btn.onToggle then
            btn.onToggle(btn.isToggled)
        end
    end)

    btn.SetToggled = function(self, state)
        self.isToggled = state
        updateAppearance()
    end

    btn.IsToggled = function(self)
        return self.isToggled
    end

    updateAppearance()
    return btn
end

function DF.ui.ExpandButton(parent, width, height, texture, onToggle, name, reversed)
    texture = texture or media['tex:bags:expand.tga']
    local frame = CreateFrame('CheckButton', name, parent or UIParent)
    frame:SetSize(width or 28, height or 17)
    frame:SetNormalTexture(texture)
    frame:SetHighlightTexture(texture)
    frame.reversed = reversed or false

    frame:SetScript('OnClick', function()
        local isChecked = frame:GetChecked()

        if frame.reversed then
            if isChecked then
                frame:GetNormalTexture():SetTexCoord(1, 0, 0, 1)
                frame:GetHighlightTexture():SetTexCoord(1, 0, 0, 1)
            else
                frame:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
                frame:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
            end
        else
            if isChecked then
                frame:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
                frame:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
            else
                frame:GetNormalTexture():SetTexCoord(1, 0, 0, 1)
                frame:GetHighlightTexture():SetTexCoord(1, 0, 0, 1)
            end
        end

        if onToggle then
            onToggle(isChecked)
        end

        if DF_ActionTooltip and DF_ActionTooltip:IsVisible() then
            DF.lib.RefreshTooltip()
        end
    end)

    frame:SetScript('OnEnter', function()
        local text = frame:GetChecked() and 'Collapse' or 'Expand'
        -- DF.lib.ShowSimpleTooltip(frame, text)
    end)
    frame:SetScript('OnLeave', function()
        -- DF.lib.HideActionTooltip()
    end)

    frame:SetChecked(true)
    if frame.reversed then
        frame:GetNormalTexture():SetTexCoord(1, 0, 0, 1)
        frame:GetHighlightTexture():SetTexCoord(1, 0, 0, 1)
    else
        frame:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
        frame:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
    end

    return frame
end

function DF.ui.Confirmbox(message, onAccept, onDecline)
    if activeConfirm then return end
    local frame = DF.ui.Frame(UIParent, 200, 100, 0.9, true)
    frame:SetPoint('CENTER', 0, 0)
    frame:SetFrameStrata('DIALOG')
    activeConfirm = frame

    local text = Font(frame, 11, message or 'Confirm?', {1, 1, 1}, 'CENTER')
    text:SetPoint('TOP', frame, 'TOP', 0, -15)
    text:SetWidth(180)

    local acceptBtn = Button(frame, 'Accept', 70, 25)
    acceptBtn:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 15, 10)
    acceptBtn:SetScript('OnClick', function()
        frame:Hide()
        activeConfirm = nil
        if onAccept then onAccept() end
    end)

    local declineBtn = Button(frame, 'Decline', 70, 25)
    declineBtn:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -15, 10)
    declineBtn:SetScript('OnClick', function()
        frame:Hide()
        activeConfirm = nil
        if onDecline then onDecline() end
    end)

    return frame
end

function DF.ui.PushFrame(parent, width, height, maxLines, font)
    local LINE_HEIGHT = 16
    local PADDING = 5

    local pushFrame = DF.ui.Scrollframe(parent, width or 300, height or 200)
    pushFrame.messages = {}
    pushFrame.maxLines = maxLines or 100
    pushFrame.font = font or 'Fonts\\FRIZQT__.TTF'

    local function updateLayout()
        local currentScroll = pushFrame:GetVerticalScroll()
        local yOffset = 0
        for i = 1, table.getn(pushFrame.messages) do
            local msg = pushFrame.messages[i]
            msg.fontString:SetPoint('TOPLEFT', pushFrame.content, 'TOPLEFT', PADDING, -yOffset - PADDING)
            yOffset = yOffset + msg.fontString:GetHeight()
        end
        pushFrame.content:SetHeight(yOffset + PADDING)
        pushFrame.updateScrollBar()

        local maxScroll = math.max(0, pushFrame.content:GetHeight() - pushFrame:GetHeight())
        local validScroll = math.max(0, math.min(currentScroll, maxScroll))
        pushFrame:SetVerticalScroll(validScroll)
        pushFrame.scrollBar:SetValue(validScroll)
    end

    pushFrame.ScrollToBottom = function(self)
        local maxScroll = math.max(0, pushFrame.content:GetHeight() - pushFrame:GetHeight())
        if maxScroll > 0 then
            pushFrame:SetVerticalScroll(maxScroll)
            pushFrame.scrollBar:SetValue(maxScroll)
        end
    end

    pushFrame.AddMessage = function(self, text, color, position)
        color = color or {1, 1, 1}
        position = position or 'bottom'

        local fontString = pushFrame.content:CreateFontString(nil, 'OVERLAY')
        local currentFont = pushFrame.font
        if AU and DF.profile and DF.profile['gui-generator'] and DF.profile['gui-generator'].guifont then
            currentFont = media[DF.profile['gui-generator'].guifont] or currentFont
        end
        fontString:SetFont(currentFont, 12, 'OUTLINE')
        fontString:SetTextColor(color[1], color[2], color[3])
        fontString:SetText(text)
        fontString:SetWidth(pushFrame:GetWidth() - PADDING * 2)
        fontString:SetJustifyH('LEFT')

        local message = {
            text = text,
            fontString = fontString,
            color = color
        }

        if position == 'top' then
            table.insert(self.messages, 1, message)
        else
            table.insert(self.messages, message)
        end

        while table.getn(self.messages) > self.maxLines do
            local oldMsg = table.remove(self.messages, 1)
            oldMsg.fontString:Hide()
        end

        updateLayout()
        pushFrame:ScrollToBottom()
    end

    pushFrame.Clear = function(self)
        for i = 1, table.getn(self.messages) do
            self.messages[i].fontString:Hide()
        end
        self.messages = {}
        updateLayout()
    end

    return pushFrame
end

function DF.ui.Highlight(buttons, texture, color)
    if not buttons then return end

    if buttons.SetScript then
        buttons = {buttons}
    end

    texture = texture or 'Interface\\QuestFrame\\UI-QuestTitleHighlight'
    color = color or {1, 1, 1, 0.5}

    for i = 1, table.getn(buttons) do
        local btn = buttons[i]
        if btn and btn.SetScript then
            local highlight = btn:CreateTexture(nil, 'OVERLAY')
            highlight:SetTexture(texture)
            highlight:SetPoint('TOPLEFT', btn, 'TOPLEFT', 2, -4)
            highlight:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', -2, 4)
            highlight:SetBlendMode('ADD')
            highlight:SetAlpha(0)

            if texture == 'Interface\\Buttons\\WHITE8X8' then
                highlight:SetVertexColor(color[1], color[2], color[3], color[4] or 0.5)
            end

            btn:SetScript('OnEnter', function()
                UIFrameFadeRemoveFrame(highlight)
                highlight:SetAlpha(1)
            end)

            btn:SetScript('OnLeave', function()
                UIFrameFadeOut(highlight, 0.3, 1, 0)
            end)
        end
    end
end

function DF.ui.CreateRedButton(parent, buttonType, onClick)
    local coords = BUTTON_TEXCOORDS[buttonType]
    if not coords then return nil end

    local button = CreateFrame("Button", nil, parent)
    button:SetSize(21, 21)
    button.currentType = buttonType

    local normal = button:CreateTexture(nil, "BORDER")
    normal:SetTexture(media['tex:interface:redbutton2x'])
    normal:SetAllPoints(button)
    normal:SetTexCoord(coords.normal[1], coords.normal[2], coords.normal[3], coords.normal[4])
    button:SetNormalTexture(normal)
    button.normalTex = normal

    local pushed = button:CreateTexture(nil, "BORDER")
    pushed:SetTexture(media['tex:interface:redbutton2x'])
    pushed:SetAllPoints(button)
    pushed:SetTexCoord(coords.pushed[1], coords.pushed[2], coords.pushed[3], coords.pushed[4])
    button:SetPushedTexture(pushed)
    button.pushedTex = pushed

    local highlight = button:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetTexture(media['tex:interface:redbutton2x'])
    highlight:SetAllPoints(button)
    highlight:SetTexCoord(BUTTON_TEXCOORDS.highlight[1], BUTTON_TEXCOORDS.highlight[2], BUTTON_TEXCOORDS.highlight[3], BUTTON_TEXCOORDS.highlight[4])
    highlight:SetBlendMode("ADD")
    button:SetHighlightTexture(highlight)

    function button:SwitchType(newType)
        local newCoords = BUTTON_TEXCOORDS[newType]
        if newCoords then
            self.currentType = newType
            self.normalTex:SetTexCoord(newCoords.normal[1], newCoords.normal[2], newCoords.normal[3], newCoords.normal[4])
            self.pushedTex:SetTexCoord(newCoords.pushed[1], newCoords.pushed[2], newCoords.pushed[3], newCoords.pushed[4])
        end
    end

    if onClick then
        button:SetScript("OnClick", onClick)
    end

    local tooltipText = buttonType == 'close' and 'Close' or buttonType
    button:SetScript('OnEnter', function()
        -- DF.lib.ShowSimpleTooltip(this, tooltipText)
    end)
    button:SetScript('OnLeave', function()
        -- DF.lib.HideActionTooltip()
    end)

    return button
end

function DF.ui.UpdateFrameFonts(frame, newFont)
    local regions = {frame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region and region.SetFont then
            local _, size, flags = region:GetFont()
            region:SetFont(newFont, size, flags)
        end
    end

    local children = {frame:GetChildren()}
    for i = 1, table.getn(children) do
        local child = children[i]
        if child then
            DF.ui.UpdateFrameFonts(child, newFont)
        end
    end
end

function DF.ui.MinimalScrollFrame(parent, startAtBottom)
    -- TODO : NEEDS RETHINKING
    local scroll = CreateFrame('ScrollFrame', nil, parent)
    scroll:SetPoint('TOPLEFT', 10, -10)
    scroll:SetPoint('BOTTOMRIGHT', -10, 10)

    local content = CreateFrame('Frame', nil, scroll)
    content:SetSize(parent:GetWidth() - 30, 1)
    scroll:SetScrollChild(content)

    local scrollbar = CreateFrame('Slider', nil, parent)
    scrollbar:SetPoint('TOPRIGHT', -5, -10)
    scrollbar:SetPoint('BOTTOMRIGHT', -5, 10)
    scrollbar:SetWidth(1)
    scrollbar:SetMinMaxValues(0, 0)
    scrollbar:SetScript('OnValueChanged', function() scroll:SetVerticalScroll(this:GetValue()) end)
    scroll:EnableMouseWheel(true)

    scroll:SetScript('OnMouseWheel', function()
        local maxScroll = math.max(0, content:GetHeight() - scroll:GetHeight())
        if maxScroll <= 0 then return end
        local target = scrollbar:GetValue() + (arg1 > 0 and -20 or 20)
        local current = scrollbar:GetValue()
        local step = (target - current) / 5
        local count = 0
        scroll:SetScript('OnUpdate', function()
            count = count + 1
            scrollbar:SetValue(current + step * count)
            if count >= 5 then
                scroll:SetScript('OnUpdate', nil)
            end
        end)
    end)

    scrollbar:SetThumbTexture 'Interface\\Buttons\\WHITE8x8'
    scrollbar:SetValue(startAtBottom and (content:GetHeight() - scroll:GetHeight()) or 0)
    scrollbar:GetThumbTexture():SetWidth(2)

    scroll.updateContentHeight = function()
        local totalHeight = 0
        local children = {content:GetChildren()}
        for i = 1, table.getn(children) do
            totalHeight = totalHeight + children[i]:GetHeight() + 5
        end
        content:SetHeight(totalHeight)
        scrollbar:SetMinMaxValues(0, math.max(0, content:GetHeight() - scroll:GetHeight()))
    end

    return scroll, content, scrollbar
end

function DF.ui.CreateSelectiveBorder(frame, edges, size, r, g, b, a, layer)
    size = size or 2
    r, g, b, a = r or 1, g or 1, b or 1, a or 1
    layer = layer or 'BORDER'

    local leftInset = edges.left and size or 0
    local rightInset = edges.right and size or 0
    local textures = {}

    if edges.top then
        local t = frame:CreateTexture(nil, layer)
        t:SetTexture('Interface\\Buttons\\WHITE8x8')
        t:SetPoint('TOPLEFT', frame, 'TOPLEFT', leftInset, 0)
        t:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', -rightInset, 0)
        t:SetHeight(size)
        t:SetVertexColor(r, g, b, a)
        textures.top = t
    end

    if edges.bottom then
        local t = frame:CreateTexture(nil, layer)
        t:SetTexture('Interface\\Buttons\\WHITE8x8')
        t:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', leftInset, 0)
        t:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -rightInset, 0)
        t:SetHeight(size)
        t:SetVertexColor(r, g, b, a)
        textures.bottom = t
    end

    if edges.left then
        local t = frame:CreateTexture(nil, layer)
        t:SetTexture('Interface\\Buttons\\WHITE8x8')
        t:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, 0)
        t:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 0, 0)
        t:SetWidth(size)
        t:SetVertexColor(r, g, b, a)
        textures.left = t
    end

    if edges.right then
        local t = frame:CreateTexture(nil, layer)
        t:SetTexture('Interface\\Buttons\\WHITE8x8')
        t:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 0, 0)
        t:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', 0, 0)
        t:SetWidth(size)
        t:SetVertexColor(r, g, b, a)
        textures.right = t
    end

    return textures
end

-- advanced elements -- TODO v1
function DF.ui.CreatePaperDollFrame(name, parent, width, height, frameStyle)
    local frame = CreateFrame("Frame", name, parent)
    frame:SetSize(width, height)

    local metalTex = frameStyle == 3 and "UIFrameMetal2x2" or "UIFrameMetal2x"
    local metalHorizTex = frameStyle == 3 and "UIFrameMetalHorizontal2x2" or "UIFrameMetalHorizontal2x"

    local bgTexture = frame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetDrawLayer("BACKGROUND", -2)
    bgTexture:SetTexture(media['tex:interface:UI-Background-Rock'])
    bgTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -21)
    bgTexture:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
    frame.Bg = bgTexture

    local topLeft = frame:CreateTexture(nil, "OVERLAY")
    topLeft:SetTexture(media['tex:interface:'..metalTex])
    topLeft:SetSize(75, 75)
    topLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", -13, 16)

    if frameStyle == 1 then
        topLeft:SetTexCoord(0.00195312, 0.294922, 0.298828, 0.591797)
        local portrait = frame:CreateTexture(nil, "OVERLAY")
        portrait:SetSize(54, 54)
        portrait:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 4)
        frame.portrait = portrait
    else
        topLeft:SetTexCoord(0.00195312, 0.294922, 0.00195312, 0.294922)
    end

    local topRight = frame:CreateTexture(nil, "ARTWORK")
    topRight:SetTexture(media['tex:interface:'..metalTex])
    topRight:SetSize(75, 75)
    topRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 4, 16)
    topRight:SetTexCoord(0.298828, 0.591797, 0.00195312, 0.294922)

    local bottomLeft = frame:CreateTexture(nil, "ARTWORK")
    bottomLeft:SetTexture(media['tex:interface:'..metalTex])
    bottomLeft:SetSize(32, 32)
    bottomLeft:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -13, -3)
    bottomLeft:SetTexCoord(0.298828, 0.423828, 0.298828, 0.423828)

    local bottomRight = frame:CreateTexture(nil, "ARTWORK")
    bottomRight:SetTexture(media['tex:interface:'..metalTex])
    bottomRight:SetSize(32, 32)
    bottomRight:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -3)
    bottomRight:SetTexCoord(0.427734, 0.552734, 0.298828, 0.423828)

    local topEdge = frame:CreateTexture(nil, "ARTWORK")
    topEdge:SetTexture(media['tex:interface:'..metalHorizTex])
    topEdge:SetSize(32, 75)
    topEdge:SetPoint("TOPLEFT", topLeft, "TOPRIGHT", 0, 0)
    topEdge:SetPoint("TOPRIGHT", topRight, "TOPLEFT", 0, 0)
    topEdge:SetTexCoord(0.0, 1.0, 0.00390625, 0.589844)

    local bottomEdge = frame:CreateTexture(nil, "ARTWORK")
    bottomEdge:SetTexture(media['tex:interface:'..metalHorizTex])
    bottomEdge:SetSize(32, 32)
    bottomEdge:SetPoint("BOTTOMLEFT", bottomLeft, "BOTTOMRIGHT", 0, 0)
    bottomEdge:SetPoint("BOTTOMRIGHT", bottomRight, "BOTTOMLEFT", 0, 0)
    bottomEdge:SetTexCoord(0.0, 0.5, 0.597656, 0.847656)

    local leftEdge = frame:CreateTexture(nil, "ARTWORK")
    leftEdge:SetTexture(media['tex:interface:UIFrameMetalVertical2x'])
    leftEdge:SetSize(75, 8)
    leftEdge:SetPoint("TOPLEFT", topLeft, "BOTTOMLEFT", 0, 0)
    leftEdge:SetPoint("BOTTOMLEFT", bottomLeft, "TOPLEFT", 0, 0)
    leftEdge:SetTexCoord(0.00195312, 0.294922, 0.0, 1.0)

    local rightEdge = frame:CreateTexture(nil, "ARTWORK")
    rightEdge:SetTexture(media['tex:interface:UIFrameMetalVertical2x'])
    rightEdge:SetSize(75, 8)
    rightEdge:SetPoint("TOPLEFT", topRight, "BOTTOMLEFT", 0, 0)
    rightEdge:SetPoint("BOTTOMLEFT", bottomRight, "TOPLEFT", 0, 0)
    rightEdge:SetTexCoord(0.298828, 0.591797, 0.0, 1.0)

    frame.edges = {topLeft, topRight, bottomLeft, bottomRight, topEdge, bottomEdge, leftEdge, rightEdge}

    -- tab system
    frame.Tabs = {}
    frame.selectedTab = nil

    function frame:AddTab(text, onClick, tabWidth, spacing)
        local tab = CreateFrame("Button", nil, frame)
        tab:SetSize(tabWidth or 70, 32)

        local tex = media['tex:interface:uiframetabs']

        -- Normal state (inactive, 36px tall)
        local left = tab:CreateTexture(nil, "BACKGROUND")
        left:SetTexture(tex)
        left:SetSize(35, 36)
        left:SetPoint("TOPLEFT", tab, "TOPLEFT", -3, 0)
        left:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)
        tab.Left = left

        local right = tab:CreateTexture(nil, "BACKGROUND")
        right:SetTexture(tex)
        right:SetSize(37, 36)
        right:SetPoint("TOPRIGHT", tab, "TOPRIGHT", 7, 0)
        right:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)
        tab.Right = right

        local middle = tab:CreateTexture(nil, "BACKGROUND")
        middle:SetTexture(tex)
        middle:SetSize(1, 36)
        middle:SetPoint("TOPLEFT", left, "TOPRIGHT", 0, 0)
        middle:SetPoint("TOPRIGHT", right, "TOPLEFT", 0, 0)
        middle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
        tab.Middle = middle

        -- Selected state (active, 42px tall)
        local leftSel = tab:CreateTexture(nil, "BACKGROUND")
        leftSel:SetTexture(tex)
        leftSel:SetSize(35, 45)
        leftSel:SetPoint("TOPLEFT", tab, "TOPLEFT", -1, 0)
        leftSel:SetTexCoord(0.015625, 0.5625, 0.496094, 0.660156)
        leftSel:Hide()
        tab.LeftSel = leftSel

        local rightSel = tab:CreateTexture(nil, "BACKGROUND")
        rightSel:SetTexture(tex)
        rightSel:SetSize(37, 45)
        rightSel:SetPoint("TOPRIGHT", tab, "TOPRIGHT", 8, 0)
        rightSel:SetTexCoord(0.015625, 0.59375, 0.324219, 0.488281)
        rightSel:Hide()
        tab.RightSel = rightSel

        local middleSel = tab:CreateTexture(nil, "BACKGROUND")
        middleSel:SetTexture(tex)
        middleSel:SetSize(1, 45)
        middleSel:SetPoint("TOPLEFT", leftSel, "TOPRIGHT", 0, 0)
        middleSel:SetPoint("TOPRIGHT", rightSel, "TOPLEFT", 0, 0)
        middleSel:SetTexCoord(0, 0.015625, 0.00390625, 0.167969)
        middleSel:Hide()
        tab.MiddleSel = middleSel

        -- Highlight
        local hlLeft = tab:CreateTexture(nil, "HIGHLIGHT")
        hlLeft:SetTexture(tex)
        hlLeft:SetSize(35, 36)
        hlLeft:SetPoint("TOPLEFT", tab, "TOPLEFT", -3, 0)
        hlLeft:SetTexCoord(0.015625, 0.5625, 0.816406, 0.957031)
        hlLeft:SetBlendMode("ADD")
        hlLeft:SetAlpha(0.4)

        local hlRight = tab:CreateTexture(nil, "HIGHLIGHT")
        hlRight:SetTexture(tex)
        hlRight:SetSize(37, 36)
        hlRight:SetPoint("TOPRIGHT", tab, "TOPRIGHT", 7, 0)
        hlRight:SetTexCoord(0.015625, 0.59375, 0.667969, 0.808594)
        hlRight:SetBlendMode("ADD")
        hlRight:SetAlpha(0.4)

        local hlMiddle = tab:CreateTexture(nil, "HIGHLIGHT")
        hlMiddle:SetTexture(tex)
        hlMiddle:SetSize(1, 36)
        hlMiddle:SetPoint("TOPLEFT", hlLeft, "TOPRIGHT", 0, 0)
        hlMiddle:SetPoint("TOPRIGHT", hlRight, "TOPLEFT", 0, 0)
        hlMiddle:SetTexCoord(0, 0.015625, 0.175781, 0.316406)
        hlMiddle:SetBlendMode("ADD")
        hlMiddle:SetAlpha(0.4)

        -- Text
        local label = tab:CreateFontString(nil, "BORDER", "GameFontNormalSmall")
        label:SetPoint("CENTER", tab, "CENTER", 0, 2)
        label:SetText(text)
        tab.Text = label

        if tabWidth then
            tab:SetSize(tabWidth, 32)
        else
            local textWidth = label:GetStringWidth()
            local finalTabWidth = textWidth + 50
            tab:SetSize(finalTabWidth, 32)
        end

        -- State functions
        function tab:SetSelected(selected)
            if selected then
                left:Hide()
                right:Hide()
                middle:Hide()
                leftSel:Show()
                rightSel:Show()
                middleSel:Show()
                hlLeft:SetHeight(45)
                hlRight:SetHeight(45)
                hlMiddle:SetHeight(45)
                label:SetTextColor(1, 1, 1)
            else
                left:Show()
                right:Show()
                middle:Show()
                leftSel:Hide()
                rightSel:Hide()
                middleSel:Hide()
                hlLeft:SetHeight(36)
                hlRight:SetHeight(36)
                hlMiddle:SetHeight(36)
                label:SetTextColor(1, 0.82, 0)
            end
        end

        function tab:Enable()
            left:SetVertexColor(1, 1, 1)
            right:SetVertexColor(1, 1, 1)
            middle:SetVertexColor(1, 1, 1)
            leftSel:SetVertexColor(1, 1, 1)
            rightSel:SetVertexColor(1, 1, 1)
            middleSel:SetVertexColor(1, 1, 1)
            label:SetTextColor(1, 0.82, 0)
            tab:EnableMouse(1)
        end

        function tab:Disable()
            left:SetVertexColor(0.5, 0.5, 0.5)
            right:SetVertexColor(0.5, 0.5, 0.5)
            middle:SetVertexColor(0.5, 0.5, 0.5)
            leftSel:SetVertexColor(0.5, 0.5, 0.5)
            rightSel:SetVertexColor(0.5, 0.5, 0.5)
            middleSel:SetVertexColor(0.5, 0.5, 0.5)
            label:SetTextColor(0.5, 0.5, 0.5)
            tab:EnableMouse(0)
        end

        local numTabs = table.getn(frame.Tabs)

        if numTabs == 0 then
            tab:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 8, -30)
        else
            tab:SetPoint("BOTTOMLEFT", frame.Tabs[numTabs], "BOTTOMRIGHT", spacing or 2, 0)
        end

        tab:SetScript("OnClick", function()
            PlaySound("igCharacterInfoTab")
            if frame.selectedTab then
                frame.selectedTab:SetSelected(false)
            end
            tab:SetSelected(true)
            frame.selectedTab = tab
            if onClick then onClick() end
        end)

        table.insert(frame.Tabs, tab)

        if numTabs == 0 then
            tab:SetSelected(true)
            frame.selectedTab = tab
        end

        return tab
    end

    return frame
end

function DF.ui.Calendar(parent, side, width, height, onDateSelected)
    local todayDate = date('%d/%m/%y')
    local btn = DF.ui.Button(parent or UIParent, todayDate, width or 60, height or 25)
    local frame = DF.ui.Frame(UIParent, 300, 225, 0.8, true)
    frame:Hide()

    local btnStrata = btn:GetFrameStrata()
    local strataLevels = {'BACKGROUND', 'LOW', 'MEDIUM', 'HIGH', 'DIALOG', 'FULLSCREEN', 'FULLSCREEN_DIALOG', 'TOOLTIP'}
    local btnStrataIndex = 1
    for i = 1, table.getn(strataLevels) do
        if strataLevels[i] == btnStrata then
            btnStrataIndex = i
            break
        end
    end
    local frameStrataIndex = math.min(btnStrataIndex + 1, table.getn(strataLevels))
    frame:SetFrameStrata(strataLevels[frameStrataIndex])

    local selectedDate = todayDate

    local prevBtn = Button(frame, '<', 30, 25)
    prevBtn:SetPoint('TOPLEFT', frame, 'TOPLEFT', 10, -10)

    local monthLabel = Font(frame, 12, CAL_DATA.months[CAL_DATA.currentIndex].monthName, {1, 1, 1}, 'CENTER')
    monthLabel:SetPoint('TOP', frame, 'TOP', 0, -20)

    local nextBtn = Button(frame, '>', 30, 25)
    nextBtn:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', -10, -10)

    prevBtn:SetScript('OnClick', function()
        if CAL_DATA.currentIndex > CAL_DATA.minIndex then
            CAL_DATA.currentIndex = CAL_DATA.currentIndex - 1
            monthLabel:SetText(CAL_DATA.months[CAL_DATA.currentIndex].monthName)
        end
    end)

    nextBtn:SetScript('OnClick', function()
        if CAL_DATA.currentIndex < CAL_DATA.maxIndex then
            CAL_DATA.currentIndex = CAL_DATA.currentIndex + 1
            monthLabel:SetText(CAL_DATA.months[CAL_DATA.currentIndex].monthName)
        end
    end)

    local dayButtons = {}
    local function refreshGrid()
        local current = CAL_DATA.months[CAL_DATA.currentIndex]

        for i = 1, table.getn(dayButtons) do
            dayButtons[i]:Hide()
        end

        local buttonIndex = 1
        for week = 0, 5 do
            for day = 0, 6 do
                local gridPos = week * 7 + day + 1
                local dayNum = gridPos - current.firstDay

                if dayNum >= 1 and dayNum <= current.days then
                    if not dayButtons[buttonIndex] then
                        dayButtons[buttonIndex] = Button(frame, '', 35, 25)
                        dayButtons[buttonIndex]:SetScript('OnClick', function()
                            local monthData = CAL_DATA.months[CAL_DATA.currentIndex]
                            local dateStr = string.format('%02d/%02d/%02d', dayNum, monthData.month, math.mod(monthData.year, 100))
                            local dateRaw = string.format('%02d%02d%02d', math.mod(monthData.year, 100), monthData.month, dayNum)

                            selectedDate = dateStr
                            btn.text:SetText(dateStr)
                            frame:Hide()

                            if onDateSelected then
                                onDateSelected(selectedDate, dateRaw)
                            end
                        end)
                    end

                    local dayBtn = dayButtons[buttonIndex]
                    dayBtn.text:SetText(dayNum)
                    dayBtn:SetPoint('TOPLEFT', frame, 'TOPLEFT', 10 + day * 40, -50 - week * 30)
                    dayBtn:Show()
                    buttonIndex = buttonIndex + 1
                end
            end
        end
    end

    refreshGrid()

    local origPrevClick = prevBtn:GetScript('OnClick')
    prevBtn:SetScript('OnClick', function()
        origPrevClick()
        refreshGrid()
    end)

    local origNextClick = nextBtn:GetScript('OnClick')
    nextBtn:SetScript('OnClick', function()
        origNextClick()
        refreshGrid()
    end)

    if side == 'top' then
        frame:SetPoint('BOTTOM', btn, 'TOP', 0, 5)
    else
        frame:SetPoint('TOP', btn, 'BOTTOM', 0, -5)
    end

    btn:SetScript('OnClick', function()
        if frame:IsVisible() then
            frame:Hide()
        else
            frame:Show()
        end
    end)

    return btn
end

function DF.ui.TabFrame(parent, width, height, tabHeight, subtabIndent, name)
    local TAB_HEIGHT = tabHeight or 25
    local SUBTAB_INDENT = subtabIndent or 15
    local TAB_WIDTH = width or 120

    local tabScroll = DF.ui.Scrollframe(parent, TAB_WIDTH, height or 300, name)

    tabScroll.tabs = {}
    tabScroll.expandedTab = nil
    tabScroll.animating = false
    tabScroll.onTabClick = nil
    tabScroll.selectedTab = nil
    tabScroll.selectedSubtab = nil

    local function updateLayout()
        local yOffset = 0
        local totalHeight = 0
        local needsAnimation = false

        for i = 1, table.getn(tabScroll.tabs) do
            local tab = tabScroll.tabs[i]
            tab.targetY = -yOffset

            if not tab.currentY then
                tab.currentY = tab.targetY
            end

            if math.abs(tab.targetY - tab.currentY) > 0.5 then
                needsAnimation = true
            end

            yOffset = yOffset + TAB_HEIGHT
            totalHeight = totalHeight + TAB_HEIGHT

            if tabScroll.expandedTab == i and tab.subtabs then
                for j = 1, table.getn(tab.subtabs) do
                    local subtab = tab.subtabs[j]
                    subtab.targetY = -yOffset

                    if not subtab.currentY then
                        subtab.currentY = subtab.targetY
                    end

                    if math.abs(subtab.targetY - subtab.currentY) > 0.5 then
                        needsAnimation = true
                    end

                    yOffset = yOffset + TAB_HEIGHT
                    totalHeight = totalHeight + TAB_HEIGHT
                end
            end
        end

        tabScroll.content:SetHeight(totalHeight)
        tabScroll.updateScrollBar()

        if needsAnimation and not tabScroll.animating then
            tabScroll.animating = true
            tabScroll:SetScript('OnUpdate', function()
                local stillAnimating = false

                for i = 1, table.getn(tabScroll.tabs) do
                    local tab = tabScroll.tabs[i]
                    if math.abs(tab.targetY - tab.currentY) > 0.5 then
                        tab.currentY = tab.currentY + (tab.targetY - tab.currentY) * 0.3
                        stillAnimating = true
                    else
                        tab.currentY = tab.targetY
                    end
                    tab.button:SetPoint('TOPLEFT', tabScroll.content, 'TOPLEFT', 0, tab.currentY)

                    if tabScroll.expandedTab == i and tab.subtabs then
                        for j = 1, table.getn(tab.subtabs) do
                            local subtab = tab.subtabs[j]
                            if math.abs(subtab.targetY - subtab.currentY) > 0.5 then
                                subtab.currentY = subtab.currentY + (subtab.targetY - subtab.currentY) * 0.3
                                stillAnimating = true
                            else
                                subtab.currentY = subtab.targetY
                            end
                            subtab.button:SetPoint('TOPLEFT', tabScroll.content, 'TOPLEFT', SUBTAB_INDENT-6, subtab.currentY)
                        end
                    end
                end

                if not stillAnimating then
                    tabScroll.animating = false
                    tabScroll:SetScript('OnUpdate', nil)
                end
            end)
        elseif not needsAnimation then
            for i = 1, table.getn(tabScroll.tabs) do
                local tab = tabScroll.tabs[i]
                tab.currentY = tab.targetY
                tab.button:SetPoint('TOPLEFT', tabScroll.content, 'TOPLEFT', 0, tab.currentY)

                if tabScroll.expandedTab == i and tab.subtabs then
                    for j = 1, table.getn(tab.subtabs) do
                        local subtab = tab.subtabs[j]
                        subtab.currentY = subtab.targetY
                        subtab.button:SetPoint('TOPLEFT', tabScroll.content, 'TOPLEFT', SUBTAB_INDENT-6, subtab.currentY)
                    end
                end
            end
        end
    end

    local function collapseAll()
        if tabScroll.expandedTab then
            local tab = tabScroll.tabs[tabScroll.expandedTab]
            if tab.subtabs then
                for i = 1, table.getn(tab.subtabs) do
                    tab.subtabs[i].button:Hide()
                end
            end
            tabScroll.expandedTab = nil
        end
    end

    local function expandTab(tabIndex)
        local tab = tabScroll.tabs[tabIndex]
        if tab.subtabs then
            tabScroll.expandedTab = tabIndex
            for i = 1, table.getn(tab.subtabs) do
                local subtab = tab.subtabs[i]
                subtab.currentY = tab.currentY
                subtab.button:Show()
            end
        end
    end

    tabScroll.clickableTabCount = 0

    local function capitalizeWords(str)
        local result = ''
        local capitalize = true
        for i = 1, string.len(str) do
            local char = string.sub(str, i, i)
            if capitalize and char >= 'a' and char <= 'z' then
                result = result .. string.upper(char)
                capitalize = false
            else
                result = result .. char
                if char == ' ' then
                    capitalize = true
                end
            end
        end
        return result
    end

    tabScroll.AddTab = function(self, tabName, subtabs)
        local tabIndex = table.getn(self.tabs) + 1
        local btn
        local clickableIndex

        if tabName == 'SPACER' then
            local spacerName = tabScroll:GetName() and (tabScroll:GetName() .. '_Spacer' .. tabIndex) or nil
            btn = CreateFrame('Frame', spacerName, tabScroll.content)
            btn:SetSize(TAB_WIDTH, TAB_HEIGHT)
        else
            tabScroll.clickableTabCount = tabScroll.clickableTabCount + 1
            clickableIndex = tabScroll.clickableTabCount
            local btnName = tabScroll:GetName() and (tabScroll:GetName() .. '_Tab' .. tabIndex) or nil
            btn = DF.ui.Button(tabScroll.content, tabName, TAB_WIDTH, TAB_HEIGHT, false, {1, 0, 0}, false, btnName)

            btn.permanentHighlight = btn:CreateTexture(nil, 'OVERLAY')
            btn.permanentHighlight:SetTexture('Interface\\QuestFrame\\UI-QuestTitleHighlight')
            btn.permanentHighlight:SetPoint('TOPLEFT', btn, 'TOPLEFT', 2, -4)
            btn.permanentHighlight:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', -2, 4)
            btn.permanentHighlight:SetBlendMode('ADD')
            btn.permanentHighlight:Hide()

            btn:SetScript('OnClick', function()
                if subtabs then
                    if tabScroll.expandedTab == tabIndex then
                        collapseAll()
                        for _, t in pairs(tabScroll.tabs) do
                            if t.button.permanentHighlight then
                                t.button.permanentHighlight:Hide()
                            end
                        end
                        tabScroll.selectedTab = nil
                        tabScroll.selectedSubtab = nil
                    else
                        collapseAll()
                        for _, t in pairs(tabScroll.tabs) do
                            if t.button.permanentHighlight then
                                t.button.permanentHighlight:Hide()
                            end
                            if t.subtabs then
                                for _, st in pairs(t.subtabs) do
                                    if st.button.permanentHighlight then
                                        st.button.permanentHighlight:Hide()
                                    end
                                end
                            end
                        end
                        btn.permanentHighlight:Show()
                        tabScroll.selectedTab = tabIndex
                        expandTab(tabIndex)
                    end
                else
                    collapseAll()
                    for _, t in pairs(tabScroll.tabs) do
                        if t.button.permanentHighlight then
                            t.button.permanentHighlight:Hide()
                        end
                        if t.subtabs then
                            for _, st in pairs(t.subtabs) do
                                if st.button.permanentHighlight then
                                    st.button.permanentHighlight:Hide()
                                end
                            end
                        end
                    end
                    btn.permanentHighlight:Show()
                    tabScroll.selectedTab = tabIndex
                    tabScroll.selectedSubtab = nil

                    if tabScroll.onTabClick then
                        tabScroll.onTabClick(clickableIndex)
                    end
                end

                updateLayout()
            end)
        end

        local tab = {
            name = tabName,
            button = btn,
            subtabs = nil,
            targetY = 0
        }

        if subtabs then
            table.sort(subtabs)
            tab.subtabs = {}
            for i = 1, table.getn(subtabs) do
                local subtabName = capitalizeWords(subtabs[i])
                local subtabIndex = i
                local subBtnName = tabScroll:GetName() and (tabScroll:GetName() .. '_Tab' .. tabIndex .. '_Sub' .. i) or nil
                local subBtn = DF.ui.Button(tabScroll.content, subtabName, TAB_WIDTH - SUBTAB_INDENT, TAB_HEIGHT, true, {1, 1, 1}, false, subBtnName)

                subBtn.permanentHighlight = subBtn:CreateTexture(nil, 'OVERLAY')
                subBtn.permanentHighlight:SetTexture('Interface\\QuestFrame\\UI-QuestTitleHighlight')
                subBtn.permanentHighlight:SetPoint('TOPLEFT', subBtn, 'TOPLEFT', 2, -4)
                subBtn.permanentHighlight:SetPoint('BOTTOMRIGHT', subBtn, 'BOTTOMRIGHT', -2, 4)
                subBtn.permanentHighlight:SetBlendMode('ADD')
                subBtn.permanentHighlight:Hide()

                subBtn:SetScript('OnClick', function()
                    for _, t in pairs(tabScroll.tabs) do
                        if t.subtabs then
                            for _, st in pairs(t.subtabs) do
                                if st.button.permanentHighlight then
                                    st.button.permanentHighlight:Hide()
                                end
                            end
                        end
                    end
                    local parentTab = tabScroll.tabs[tabIndex]
                    if parentTab and parentTab.button.permanentHighlight then
                        parentTab.button.permanentHighlight:Show()
                    end
                    subBtn.permanentHighlight:Show()
                    tabScroll.selectedTab = tabIndex
                    tabScroll.selectedSubtab = subtabIndex

                    if tabScroll.onTabClick then
                        tabScroll.onTabClick(clickableIndex, subtabIndex)
                    end
                end)
                subBtn:Hide()

                table.insert(tab.subtabs, {
                    name = subtabName,
                    button = subBtn,
                    targetY = 0
                })
            end
        end

        table.insert(self.tabs, tab)
        updateLayout()
    end

    return tabScroll
end

function DF.ui.CollapsibleSection(parent, headerText, width, startExpanded)
    if startExpanded == nil then startExpanded = true end

    local section = CreateFrame('Frame', nil, parent)
    section:SetSize(parent:GetWidth(), 20)
    section.expanded = startExpanded
    section.lines = {}

    local headerFrame = CreateFrame('Frame', nil, section)
    headerFrame:SetSize(parent:GetWidth(), 20)
    headerFrame:SetPoint('TOPLEFT', section, 'TOPLEFT', 0, 0)

    local toggleBtn = DF.ui.Button(headerFrame, startExpanded and '-' or '+', 20, 20, false)
    toggleBtn:SetPoint('LEFT', headerFrame, 'LEFT', 0, 0)
    toggleBtn:SetScript('OnClick', function()
        section.expanded = not section.expanded
        toggleBtn.text:SetText(section.expanded and '-' or '+')
        for i = 1, table.getn(section.lines) do
            if section.expanded then
                section.lines[i]:Show()
            else
                section.lines[i]:Hide()
            end
        end
        local h = 20
        if section.expanded then
            h = h + table.getn(section.lines) * 18
        end
        section:SetHeight(h)
        if section.onToggle then section.onToggle() end
        local p = section:GetParent()
        if p and p:GetParent() and p:GetParent().updateContentHeight then
            p:GetParent().updateContentHeight()
        end
    end)

    local header = DF.ui.Font(headerFrame, 11, headerText, {1, 1, 1}, 'LEFT')
    header:SetPoint('LEFT', toggleBtn, 'RIGHT', 5, 0)

    section.AddLine = function(self, label, value, tooltip)
        local line = CreateFrame('Button', nil, section)
        line:SetSize(parent:GetWidth(), 16)
        line:SetPoint('TOPLEFT', section, 'TOPLEFT', 0, -20 - (table.getn(self.lines) * 18))
        local labelText = DF.ui.Font(line, 10, label, {1, 0.82, 0}, 'LEFT')
        labelText:SetPoint('LEFT', line, 'LEFT', 20, 0)
        local valueText = DF.ui.Font(line, 10, value, {1, 1, 1}, 'RIGHT')
        valueText:SetPoint('RIGHT', line, 'RIGHT', -5, 0)
        line:SetScript('OnEnter', function()
            if tooltip then
                GameTooltip:SetOwner(line, 'ANCHOR_RIGHT')
                GameTooltip:SetText(tooltip)
                GameTooltip:Show()
            end
        end)
        line:SetScript('OnLeave', function()
            GameTooltip:Hide()
        end)
        if section.expanded then
            line:Show()
        else
            line:Hide()
        end
        line.value = valueText
        line.label = labelText
        table.insert(self.lines, line)
        return line
    end

    section.UpdateHeight = function(self)
        local h = 20
        if self.expanded then
            h = h + table.getn(self.lines) * 18
        end
        self:SetHeight(h)
    end

    return section
end

function DF.ui.StaticPopup_Show(text, btn1Text, btn1Callback, btn2Text, btn2Callback, parent, width, height, title)
    if not DF.ui.staticPopup then
        local frameHeight = title and 120 or 100
        local frameStyle = title and 2 or 3
        local frame = DF.ui.CreatePaperDollFrame('DF_StaticPopup', parent or UIParent, width or 280, height or frameHeight, frameStyle)
        frame:SetPoint('CENTER', UIParent, 'CENTER', 0, 100)
        frame:SetFrameStrata('DIALOG')
        frame:Hide()

        local titleText = nil
        if title then
            titleText = DF.ui.Font(frame, 12, '', {1, 0.82, 0}, 'CENTER')
            titleText:SetPoint('TOP', frame, 'TOP', 0, -5)
            titleText:SetWidth(240)
        end

        local bodyText = DF.ui.Font(frame, 12, '', {1, 1, 1}, 'CENTER')
        bodyText:SetPoint('CENTER', frame, 'CENTER', 0, title and 5 or 10)
        bodyText:SetWidth(240)

        local button1 = DF.ui.Button(frame, '', 100, 28)
        local button2 = DF.ui.Button(frame, '', 100, 28)

        DF.ui.staticPopup = {
            frame = frame,
            titleText = titleText,
            bodyText = bodyText,
            button1 = button1,
            button2 = button2
        }

        frame:SetScript('OnKeyDown', function()
            if arg1 == 'ESCAPE' then
                DF.ui.StaticPopup_Hide()
                if DF.ui.staticPopup.btn2Callback then
                    DF.ui.staticPopup.btn2Callback()
                end
            end
        end)
    end

    if DF.ui.staticPopup.titleText and title then
        DF.ui.staticPopup.titleText:SetText(title)
        DF.ui.staticPopup.titleText:Show()
    elseif DF.ui.staticPopup.titleText then
        DF.ui.staticPopup.titleText:Hide()
    end

    DF.ui.staticPopup.bodyText:SetText(text or '')
    DF.ui.staticPopup.btn1Callback = btn1Callback
    DF.ui.staticPopup.btn2Callback = btn2Callback

    DF.ui.staticPopup.button1.text:SetText(btn1Text or 'Accept')
    DF.ui.staticPopup.button1:SetScript('OnClick', function()
        DF.ui.StaticPopup_Hide()
        if btn1Callback then btn1Callback() end
    end)

    if btn2Text then
        DF.ui.staticPopup.button2:Show()
        DF.ui.staticPopup.button2.text:SetText(btn2Text)
        DF.ui.staticPopup.button2:SetScript('OnClick', function()
            DF.ui.StaticPopup_Hide()
            if btn2Callback then btn2Callback() end
        end)
        DF.ui.staticPopup.button1:SetPoint('BOTTOMLEFT', DF.ui.staticPopup.frame, 'BOTTOMLEFT', 30, 15)
        DF.ui.staticPopup.button2:SetPoint('BOTTOMRIGHT', DF.ui.staticPopup.frame, 'BOTTOMRIGHT', -30, 15)
    else
        DF.ui.staticPopup.button2:Hide()
        DF.ui.staticPopup.button1:SetPoint('BOTTOM', DF.ui.staticPopup.frame, 'BOTTOM', 0, 15)
    end

    DF.ui.staticPopup.frame:Show()
end

function DF.ui.StaticPopup_Hide()
    if DF.ui.staticPopup then
        DF.ui.staticPopup.frame:Hide()
    end
end
