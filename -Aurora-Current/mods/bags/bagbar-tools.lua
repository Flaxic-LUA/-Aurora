UNLOCKAURORA()

local setup = {
    iconSize = 20,
    slotSize = 30.5,
    container = nil,
    mainBag = nil,
    smallBags = {},
    keyRing = nil,
    expandButton = nil,

    textures = {
        bagslotCutout = media['tex:bags:bagslotCutout.blp'],
        bagslots2x = media['tex:bags:bagslots2x.blp'],
        bigbag = media['tex:bags:bigbag.blp'],
        bigbagHighlight = media['tex:bags:bigbagHighlight.blp'],
        expand = media['tex:bags:expand.tga'],
        keyringIcon = media['tex:bags:KeyRing-Bag-Icon.blp']
    }
}

-- create
function setup:CreateMainBag()
    local frame = CreateFrame('CheckButton', 'AU_MainBag', UIParent)
    frame:SetWidth(45)
    frame:SetHeight(45)
    frame:SetNormalTexture(self.textures.bigbag)
    frame:SetHighlightTexture(self.textures.bigbagHighlight)
    frame:SetCheckedTexture(self.textures.bigbagHighlight)

    frame.border = frame:CreateTexture(nil, 'ARTWORK')
    frame.border:SetTexture(self.textures.bagslotCutout)
    frame.border:SetAllPoints(frame)

    frame:SetScript('OnClick', function() ToggleBackpack() end)

    return frame
end

function setup:CreateSmallBag(bagID, isKeyRing)
    local frameName = isKeyRing and 'AU_KeyRing' or 'AU_Bag'..bagID
    local frame = CreateFrame('CheckButton', frameName, UIParent)
    frame:SetWidth(30)
    frame:SetHeight(30)

    frame:SetNormalTexture(self.textures.bagslots2x)
    frame:SetHighlightTexture(self.textures.bagslots2x)
    frame:SetCheckedTexture(self.textures.bagslots2x)

    local normal = frame:GetNormalTexture()
    normal:SetTexCoord(0.576172, 0.695312, 0.5, 0.976562)
    normal:SetDrawLayer('BACKGROUND', 0)

    local highlight = frame:GetHighlightTexture()
    highlight:SetTexCoord(0.699219, 0.818359, 0.0078125, 0.484375)

    local checked = frame:GetCheckedTexture()
    if checked then
        checked:SetTexCoord(0.699219, 0.818359, 0.0078125, 0.484375)
        checked:SetDrawLayer('OVERLAY', 7)
        checked:SetBlendMode('ADD')
        checked:SetAlpha(1)
    end

    frame.icon = frame:CreateTexture(nil, 'BORDER')
    frame.icon:SetWidth(self.iconSize - 1.5)
    frame.icon:SetHeight(self.iconSize - 1.5)
    if isKeyRing then
        frame.icon:SetTexture(self.textures.keyringIcon)
        frame.icon:SetPoint('CENTER', frame, 'CENTER', 0, 0)
    else
        frame.icon:SetPoint('CENTER', frame, 'CENTER', 0, 2)
    end

    frame.border = frame:CreateTexture(nil, 'ARTWORK')
    frame.border:SetTexture(self.textures.bagslots2x)
    frame.border:SetTexCoord(0.576172, 0.695312, 0.0078125, 0.484375)
    frame.border:SetWidth(self.slotSize + 1)
    frame.border:SetHeight(self.slotSize + 1)
    frame.border:SetPoint('CENTER', frame, 'CENTER', 0, 0)

    if not isKeyRing then
        frame:RegisterForDrag('LeftButton')
        frame:SetScript('OnDragStart', function()
            local ID = this:GetID() + 1
            local bagFrame = AU.setups.bags[ID]
            if bagFrame and bagFrame:IsShown() then
                bagFrame:Hide()
            end
            this:SetChecked(nil)
            PickupInventoryItem(ContainerIDToInventoryID(ID))
        end)
        frame:SetScript('OnReceiveDrag', function()
            PickupInventoryItem(ContainerIDToInventoryID(this:GetID() + 1))
        end)
        frame:SetScript('OnClick', function()
            local gameMenu = getglobal('AU_GameMenuFrame')
            if gameMenu and gameMenu:IsVisible() then return end
            if AU.profile['bags']['oneBagMode'] then
                local unified = AU.setups.bags.unified
                if unified then
                    if unified:IsShown() then unified:Hide() else unified:Show() end
                end
                this:SetChecked(nil)
            else
                local bagFrame = AU.setups.bags[this:GetID() + 1]
                if bagFrame then
                    if bagFrame:IsShown() then bagFrame:Hide() else bagFrame:Show() end
                end
            end
        end)
    else
        frame:SetScript('OnClick', function()
            ToggleKeyRing()
        end)
    end

    return frame
end

function setup:CreateBagBar()
    self.container = CreateFrame('Frame', 'AU_BagBar', UIParent)
    self.container:SetWidth(250)
    self.container:SetHeight(40)
    self.container:EnableMouse(true)

    self.mainBag = self:CreateMainBag()
    self.mainBag:SetParent(self.container)

    for i = 0, 3 do
        self.smallBags[i] = self:CreateSmallBag(i)
        self.smallBags[i]:SetParent(self.container)
        self.smallBags[i]:SetID(i)
    end

    self.keyRing = self:CreateSmallBag(-1, true)
    self.keyRing:SetParent(self.container)

    self.expandButton = AU.ui.ExpandButton(self.container, 23, 14, self.textures.expand, function()
        local checked = this:GetChecked() and true or false
        -- debugprint('Expand button clicked, checked=' .. tostring(checked))
        AU:SetConfig('bagbar', 'expandBags', checked)
    end, 'AU_BagToggle')

    return self.container
end

-- updates
function setup:UpdateBagIcon(bagFrame, bagID)
    local texture = GetInventoryItemTexture('player', ContainerIDToInventoryID(bagID))
    if texture then
        bagFrame.icon:SetTexture(texture)
        bagFrame.icon:Show()
        bagFrame:RegisterForClicks('LeftButtonUp')
    else
        bagFrame.icon:Hide()
        bagFrame:RegisterForClicks('LeftButtonUp')
    end
end

-- events
function setup:OnEvent()
    self.eventFrame = CreateFrame('Frame')
    self.eventFrame:RegisterEvent('BAG_UPDATE')
    self.eventFrame:SetScript('OnEvent', function()
        for i = 0, 3 do
            setup:UpdateBagIcon(setup.smallBags[i], i + 1)
        end
    end)
end

-- expose
AU.setups.bagbar = setup
