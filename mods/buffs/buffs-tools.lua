DRAGONFLIGHT()

local setup = {
    buttonSize = 30,
    spacing = 5,

    debuffColors = {
        ['none'] = {0.80, 0, 0},
        ['Magic'] = {0.20, 0.60, 1.00},
        ['Curse'] = {0.60, 0.00, 1.00},
        ['Disease'] = {0.60, 0.40, 0},
        ['Poison'] = {0.00, 0.60, 0}
    }
}

-- create
function setup:CreateBuffButton(parent, name, id, buffFilter)
    local button = CreateFrame('Button', name, parent)
    button:SetWidth(self.buttonSize)
    button:SetHeight(self.buttonSize)
    button:SetID(id)
    button.buffFilter = buffFilter
    -- debugframe(button)

    button.icon = button:CreateTexture(nil, 'BORDER')
    button.icon:SetAllPoints(button)

    button.border = button:CreateTexture(nil, 'OVERLAY')
    button.border:SetTexture('Interface\\Buttons\\UI-Debuff-Overlays')
    button.border:SetSize(self.buttonSize, self.buttonSize)
    button.border:SetPoint('CENTER', button, 'CENTER', 0, 0)
    button.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
    button.border:Hide()

    button.count = button:CreateFontString(nil, 'OVERLAY')
    button.count:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
    button.count:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 2)
    button.count:SetTextColor(1, 1, 1, 1)

    button.duration = button:CreateFontString(nil, 'OVERLAY')
    button.duration:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
    button.duration:SetPoint('TOP', button, 'BOTTOM', 0, 0)
    button.duration:SetTextColor(1, 1, 1, 1)

    return button
end

-- updates
function setup:UpdateIcon(button)
    local frame = button:GetParent()
    local sortedIndex = frame.sortedIndices and frame.sortedIndices[button:GetID()] or button:GetID()
    local buffIndex = GetPlayerBuff(sortedIndex, button.buffFilter)
    button.buffIndex = buffIndex
    if buffIndex >= 0 then
        local texture = GetPlayerBuffTexture(buffIndex)
        button.icon:SetTexture(texture)
        button:Show()
    else
        button:Hide()
    end
end

function setup:UpdateBorder(button)
    if button.buffFilter == 'HARMFUL' then
        if button.buffIndex and button.buffIndex >= 0 then
            local debuffType = GetPlayerBuffDispelType(button.buffIndex)
            local color = self.debuffColors[debuffType] or self.debuffColors['none']
            button.border:SetVertexColor(color[1], color[2], color[3])
            button.border:Show()
        else
            button.border:Hide()
        end
    end
end

function setup:UpdateCount(button)
    if button.buffIndex and button.buffIndex >= 0 then
        local count = GetPlayerBuffApplications(button.buffIndex)
        if count > 1 then
            button.count:SetText(count)
            button.count:Show()
        else
            button.count:Hide()
        end
    else
        button.count:Hide()
    end
end

function setup:UpdateDuration(button)
    if button.buffIndex and button.buffIndex >= 0 then
        local timeLeft = GetPlayerBuffTimeLeft(button.buffIndex)
        if timeLeft and timeLeft > 0 then
            button.duration:SetText(SecondsToTimeAbbrev(timeLeft))
            button.duration:Show()
        else
            button.duration:Hide()
        end
    else
        button.duration:Hide()
    end
end

function setup:UpdateWeaponIcon(button)
    local mh, mhtime, mhcharge, oh, ohtime, ohcharge = GetWeaponEnchantInfo()
    local hasEnchant = (button:GetID() == 1 and mh) or (button:GetID() == 2 and oh)
    if hasEnchant then
        local slot = button:GetID() == 1 and 16 or 17
        local texture = GetInventoryItemTexture('player', slot)
        button.icon:SetTexture(texture)
        button:Show()
    else
        button:Hide()
    end
end

function setup:UpdateWeaponDuration(button)
    local mh, mhtime, mhcharge, oh, ohtime, ohcharge = GetWeaponEnchantInfo()
    local timeLeft = 0
    if button:GetID() == 1 and mh and mhtime then
        timeLeft = mhtime / 1000
    elseif button:GetID() == 2 and oh and ohtime then
        timeLeft = ohtime / 1000
    end
    if timeLeft > 0 then
        button.duration:SetText(SecondsToTimeAbbrev(timeLeft))
        button.duration:Show()
    else
        button.duration:Hide()
    end
end

function setup:UpdateWeaponCount(button)
    local mh, mhtime, mhcharge, oh, ohtime, ohcharge = GetWeaponEnchantInfo()
    local count = 0
    if button:GetID() == 1 and mhcharge then
        count = mhcharge
    elseif button:GetID() == 2 and ohcharge then
        count = ohcharge
    end
    if count > 1 then
        button.count:SetText(count)
        button.count:Show()
    else
        button.count:Hide()
    end
end

function setup:UpdateWeaponButton(button)
    self:UpdateWeaponIcon(button)
    self:UpdateWeaponCount(button)
    self:UpdateWeaponDuration(button)
end

function setup:UpdateButton(button)
    self:UpdateIcon(button)
    self:UpdateBorder(button)
    self:UpdateCount(button)
    self:UpdateDuration(button)
end

function setup:SortButtons(frame)
    local sortOrder = frame.sortOrder or DF.profile['buffs'][frame.buffFilter == 'HELPFUL' and 'buffSortOrder' or 'debuffSortOrder'] or 'descending'

    local buffData = {}
    local i = 0
    while true do
        local buffIndex = GetPlayerBuff(i, frame.buffFilter)
        if buffIndex < 0 then break end
        local timeLeft = GetPlayerBuffTimeLeft(buffIndex) or 0
        table.insert(buffData, {index = i, timeLeft = timeLeft})
        i = i + 1
    end

    table.sort(buffData, function(a, b)
        if sortOrder == 'ascending' then
            return a.timeLeft > b.timeLeft
        else
            return a.timeLeft < b.timeLeft
        end
    end)

    frame.sortedIndices = {}
    for i = 1, table.getn(buffData) do
        frame.sortedIndices[i - 1] = buffData[i].index
    end
end

function setup:UpdateFrameLayout(frame, buttons, buttonsPerRow)
    local totalButtons = table.getn(buttons)
    local cols = buttonsPerRow
    local rows = math.ceil(totalButtons / cols)
    local size = frame.buttonSize or self.buttonSize
    local gap = frame.spacing or self.spacing

    local slotIndex = 1
    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            if slotIndex <= totalButtons then
                local button = buttons[slotIndex]
                button:ClearAllPoints()
                button:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', -(col * (size + gap)), -(row * (size + gap)))
                slotIndex = slotIndex + 1
            end
        end
    end

    frame:SetWidth(cols * size + (cols - 1) * gap)
    frame:SetHeight(rows * size + (rows - 1) * gap)
end

-- events
function setup:OnEvent(button)
    button:SetScript('OnUpdate', function()
        setup:UpdateDuration(button)
    end)
    button:RegisterForClicks('RightButtonUp')
    button:SetScript('OnClick', function()
        if button.buffIndex and button.buffIndex >= 0 then
            CancelPlayerBuff(button.buffIndex)
        end
    end)
    button:SetScript('OnEnter', function()
        if button.buffIndex and button.buffIndex >= 0 then
            GameTooltip:SetOwner(this, 'ANCHOR_BOTTOMRIGHT')
            GameTooltip:SetPlayerBuff(button.buffIndex)
            GameTooltip:Show()
        end
    end)
    button:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)
end

function setup:OnWeaponEvent(button)
    button:SetScript('OnUpdate', function()
        setup:UpdateWeaponDuration(button)
    end)
    button:RegisterForClicks('RightButtonUp')
    button:SetScript('OnClick', function()
        if button:GetID() == 1 and CancelItemTempEnchantment then
            CancelItemTempEnchantment(1)
        elseif button:GetID() == 2 and CancelItemTempEnchantment then
            CancelItemTempEnchantment(2)
        end
    end)
    button:SetScript('OnEnter', function()
        local slot = button:GetID() == 1 and 16 or 17
        GameTooltip:SetOwner(button, 'ANCHOR_BOTTOMRIGHT')
        GameTooltip:SetInventoryItem('player', slot)
    end)
    button:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)
end

-- init
function setup:CreateBuffFrame(name, count, buffFilter, buttonsPerRow)
    local frame = CreateFrame('Frame', name, UIParent)
    frame.buttons = {}
    frame.buffFilter = buffFilter

    for i = 1, count do
        local button = self:CreateBuffButton(frame, name..i, i - 1, buffFilter)
        self:OnEvent(button)
        self:UpdateButton(button)
        frame.buttons[i] = button
    end

    frame.tick = 0
    frame:SetScript('OnUpdate', function()
        if not frame:IsShown() then return end
        if frame.tick > GetTime() then return else frame.tick = GetTime() + 0.4 end
        setup:SortButtons(frame)
        for _, btn in pairs(frame.buttons) do
            setup:UpdateButton(btn)
        end
    end)

    setup:SortButtons(frame)
    self:UpdateFrameLayout(frame, frame.buttons, buttonsPerRow)

    return frame
end

function setup:CreateWeaponFrame(name, buttonsPerRow)
    local frame = CreateFrame('Frame', name, UIParent)
    frame.buttons = {}

    for i = 1, 2 do
        local button = self:CreateBuffButton(frame, name..i, i, nil)
        self:OnWeaponEvent(button)
        self:UpdateWeaponButton(button)
        frame.buttons[i] = button
    end

    frame.tick = 0
    frame:SetScript('OnUpdate', function()
        if not frame:IsShown() then return end
        if frame.tick > GetTime() then return else frame.tick = GetTime() + 0.4 end
        for _, btn in pairs(frame.buttons) do
            setup:UpdateWeaponButton(btn)
        end
    end)

    self:UpdateFrameLayout(frame, frame.buttons, buttonsPerRow)

    return frame
end

-- expose
DF.setups.buffs = setup
DF.common.KillFrame(BuffFrame)
DF.common.KillFrame(TemporaryEnchantFrame)
