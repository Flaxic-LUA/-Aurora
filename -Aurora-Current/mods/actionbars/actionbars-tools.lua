UNLOCKAURORA()

local setup = {
    buttonSize = 28,
    bars = {},
    bonusBars = {},
    multiBars = {},
    petButtons = {},
    stanceButtons = {},
    pageableBars = {},
    currentPage = 1,
    currentPageBar = nil,
    activeMainButtons = nil,
    lastUsedAction = nil,
    isDragging = false,

    showKeybindsOnEmpty = false,
    rangeIndicator = 'keybind',
    reactiveEnabled = true,

    reactiveSpells = {
        ['Overpower'] = true,
        ['Revenge'] = true,
        ['Riposte'] = true,
        ['Counterattack'] = true,
        ['Mongoose Bite'] = true
    },

    animations = {
        ['zoomfade'] = function(frame)
            if frame.active == 0 then
                frame:SetWidth(frame.parent:GetWidth())
                frame:SetHeight(frame.parent:GetHeight())
                frame:SetScale(frame.parent:GetScale())
                frame.tex:SetTexture(frame.parent.icon:GetTexture())
                frame.tex:SetVertexColor(frame.parent.icon:GetVertexColor())
                frame:SetAlpha(1)
                frame.active = 1
                return
            elseif frame.active == 1 then
                local fade = 30/GetFramerate()*0.05
                frame:SetAlpha(frame:GetAlpha() - fade)
                frame:SetScale(frame:GetScale() + fade)
                if frame:GetAlpha() > 0 then return end
            end
            frame.active = nil
            frame:Hide()
        end
    },

    textures = {
        border = media['tex:actionbars:btn_border.blp'],
        highlight = media['tex:actionbars:btn_highlight_strong.blp'],
        bgAlly = media['tex:actionbars:btn_bg_ally.blp'],
        bgHorde = media['tex:actionbars:btn_bg_horde.blp'],
        equippedBorderEdge = 'Interface\\Buttons\\White8x8',
        flash = 'Interface\\Buttons\\White8x8',
        wyvern = media['tex:actionbars:WyvernNew.tga'],
        gryphon = media['tex:actionbars:GryphonNew.tga'],
        horde = media['tex:unitframes:UI-PVP-Horde.blp'],
        alliance = media['tex:unitframes:UI-PVP-Alliance.blp'],
        pageUpNormal = media['tex:actionbars:page_up_normal.tga'],
        pageUpPushed = media['tex:actionbars:page_up_pushed.tga'],
        pageUpHighlight = media['tex:actionbars:page_up_highlight.tga'],
        pageDownNormal = media['tex:actionbars:page_down_normal.tga'],
        pageDownPushed = media['tex:actionbars:page_down_pushed.tga'],
        pageDownHighlight = media['tex:actionbars:page_down_highlight.tga']
    }
}

local assert = assert

-- create
function setup:CreateActionButton(parent, name, actionID)
    local button = AU.ui.SlotButton(parent, name, self.buttonSize)
    button:SetID(actionID)

    button.border:SetBackdrop(nil)
    local borderTex = button.border:CreateTexture(nil, 'BACKGROUND')
    borderTex:SetTexture(self.textures.border)
    borderTex:SetAllPoints(button.border)
    -- borderTex:SetVertexColor(0, 0, 0)

    button.highlight:SetBackdrop(nil)
    button.highlightTex = button.highlight:CreateTexture(nil, 'BACKGROUND')
    button.highlightTex:SetTexture(self.textures.highlight)
    button.highlightTex:SetPoint('TOPLEFT', button.highlight, 'TOPLEFT', -4, 4)
    button.highlightTex:SetPoint('BOTTOMRIGHT', button.highlight, 'BOTTOMRIGHT', 4, -4)
    local hColor = AU.profile['actionbars']['highlightColour']
    button.highlightTex:SetVertexColor(hColor[1], hColor[2], hColor[3], hColor[4])

    button.checked:SetBackdrop(nil)
    button.checkedTex = button.checked:CreateTexture(nil, 'ARTWORK')
    button.checkedTex:SetTexture(self.textures.highlight)
    button.checkedTex:SetPoint('TOPLEFT', button.checked, 'TOPLEFT', -4, 4)
    button.checkedTex:SetPoint('BOTTOMRIGHT', button.checked, 'BOTTOMRIGHT', 4, -4)
    local cColor = AU.profile['actionbars']['checkedColour']
    button.checkedTex:SetVertexColor(cColor[1], cColor[2], cColor[3], cColor[4])

    local id = actionID
    if id < 133 or (id >= 133 and id < 200) then
        button.bg:Hide()
        local faction = UnitFactionGroup('player')
        local bgFile = faction == 'Alliance' and self.textures.bgAlly or self.textures.bgHorde
        button.factionBg = button:CreateTexture(nil, 'BACKGROUND')
        button.factionBg:SetTexture(bgFile)
        button.factionBg:SetAllPoints(button)
    end

    button.textFrame = CreateFrame('Frame', nil, button)
    button.textFrame:SetAllPoints(button)
    button.textFrame:SetFrameLevel(button.highlight:GetFrameLevel() + 1)

    button.keybind = button.textFrame:CreateFontString(nil, 'OVERLAY')
    button.keybind:SetFont('Fonts\\FRIZQT__.TTF', 11, 'OUTLINE')
    button.keybind:SetPoint('TOPRIGHT', button, 'TOPRIGHT', -3, -3)

    button.macroText = button.textFrame:CreateFontString(nil, 'OVERLAY')
    button.macroText:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
    button.macroText:SetPoint('BOTTOM', button, 'BOTTOM', 0, 2)

    button.count = button.textFrame:CreateFontString(nil, 'OVERLAY')
    button.count:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
    button.count:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 2)

    button.equippedBorder = CreateFrame('Frame', nil, button)
    button.equippedBorder:SetAllPoints(button)
    button.equippedBorder:SetFrameLevel(button:GetFrameLevel() + 4)
    button.equippedBorder:SetBackdrop({
        edgeFile = self.textures.equippedBorderEdge,
        edgeSize = 5
    })
    local eColor = AU.profile['actionbars']['equippedBorderColour']
    button.equippedBorder:SetBackdropBorderColor(eColor[1], eColor[2], eColor[3], eColor[4])
    button.equippedBorder:Hide()

    button.flash = button:CreateTexture(nil, 'ARTWORK')
    button.flash:SetAllPoints(button)
    button.flash:SetTexture(self.textures.flash)
    button.flash:SetVertexColor(1, 0, 0, 1)
    button.flash:SetAlpha(0)
    button.flashTime = 0
    button.isFlashing = false

    button.reactive = CreateFrame('Frame', nil, button)
    button.reactive:SetAllPoints(button)
    button.reactive:SetFrameLevel(button:GetFrameLevel() + 3)
    button.reactive:SetBackdrop(nil)
    local reactiveTex = button.reactive:CreateTexture(nil, 'OVERLAY')
    reactiveTex:SetTexture(self.textures.highlight)
    reactiveTex:SetPoint('TOPLEFT', button.reactive, 'TOPLEFT', -4, 4)
    reactiveTex:SetPoint('BOTTOMRIGHT', button.reactive, 'BOTTOMRIGHT', 4, -4)
    reactiveTex:SetVertexColor(0, 1, 0, 0.8)
    button.reactive:Hide()

    button.animation = CreateFrame('Frame', nil, button)
    button.animation.parent = button
    button.animation:SetAllPoints(button)
    button.animation:SetFrameLevel(button:GetFrameLevel() + 10)
    button.animation:Hide()
    button.animation.tex = button.animation:CreateTexture(nil, 'ARTWORK')
    button.animation.tex:SetAllPoints()
    button.animation.tex:SetTexCoord(.08, .92, .08, .92)
    button.animation:SetScript('OnUpdate', function()
        if self.animations['zoomfade'] then
            self.animations['zoomfade'](this)
        end
    end)

    if id >= 133 and id <= 142 then
        button.autocast = CreateFrame('Model', nil, button)
        button.autocast:SetAllPoints()
        button.autocast:SetModel('Interface\\Buttons\\UI-AutoCastButton.mdx')
        button.autocast:SetSequence(0)
        button.autocast:SetSequenceTime(0, 0)
        button.autocast:SetAlpha(AU.profile['actionbars']['petAutocastAlpha'] or 0.5)
        button.autocast:Hide()
    end

    if AU.profile['actionbars']['clickMode'] == 'down' then
        button:RegisterForClicks('LeftButtonDown', 'RightButtonDown')
    else
        button:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    end
    button:RegisterForDrag('LeftButton')

    button.rangeTimer = 0

    button:SetScript('OnClick', function()
        setup.lastUsedAction = this:GetID()
        if AU.profile['actionbars']['animationTrigger'] == 'keypress' and HasAction(this:GetID()) then
            this.animation.active = 0
            this.animation:Show()
        end
        if this:GetID() >= 200 and this:GetID() <= 209 then
            CastShapeshiftForm(this:GetID() - 199)
        elseif this:GetID() >= 133 and this:GetID() <= 142 then
            local petID = this:GetID() - 132
            if arg1 == 'LeftButton' then
                CastPetAction(petID)
            else
                TogglePetAutocast(petID)
            end
        else
            local selfCast = false
            if AU.profile['actionbars']['altSelfCast'] and IsAltKeyDown() then
                selfCast = true
            end
            if AU.profile['actionbars']['rightSelfCast'] and arg1 == 'RightButton' then
                selfCast = true
            end
            UseAction(this:GetID(), 1, selfCast)
        end
    end)

    button:SetScript('OnDragStart', function()
        this.pushed:Hide()
        PickupAction(this:GetID())
    end)

    button:SetScript('OnReceiveDrag', function()
        PlaceAction(this:GetID())
    end)

    return button
end

function setup:CreateActionBar(parent, name, count, startID)
    local bar = CreateFrame('Frame', name, parent)
    bar:SetSize(count * self.buttonSize + (count - 1) * 3, self.buttonSize)
    bar.buttons = {}

    for i = 1, count do
        local button = self:CreateActionButton(bar, name..'Button'..i, startID + i - 1)
        if i == 1 then
            button:SetPoint('LEFT', bar, 'LEFT', 0, 0)
        else
            button:SetPoint('LEFT', bar.buttons[i-1], 'RIGHT', 3, 0)
        end
        bar.buttons[i] = button
    end

    self:CreateBarDecorations(bar)
    self.bars[name] = bar
    return bar
end

function setup:CreateBarDecorations(bar)
    bar.decorationLeftFrame = CreateFrame('Frame', nil, bar)
    bar.decorationLeftFrame:SetSize(180, 180)
    bar.decorationLeftFrame:SetPoint('RIGHT', bar, 'LEFT', 45, 10)
    bar.decorationLeftFrame:SetFrameStrata('BACKGROUND')
    bar.decorationLeft = bar.decorationLeftFrame:CreateTexture(nil, 'ARTWORK')
    bar.decorationLeft:SetAllPoints(bar.decorationLeftFrame)
    bar.decorationLeftFrame:Hide()

    bar.decorationRightFrame = CreateFrame('Frame', nil, bar)
    bar.decorationRightFrame:SetSize(180, 180)
    bar.decorationRightFrame:SetPoint('LEFT', bar, 'RIGHT', -45, 10)
    bar.decorationRightFrame:SetFrameStrata('BACKGROUND')
    bar.decorationRight = bar.decorationRightFrame:CreateTexture(nil, 'ARTWORK')
    bar.decorationRight:SetAllPoints(bar.decorationRightFrame)
    bar.decorationRight:SetTexCoord(1, 0, 0, 1)
    bar.decorationRightFrame:Hide()
end

function setup:CreatePagingButtons()
    self.pagingContainer = CreateFrame('Frame', 'AuroraPagingContainer', UIParent)
    self.pagingContainer:SetSize(20, 60)
    -- self.pagingContainer:SetPoint('RIGHT', mainBar.buttons[1], 'LEFT', -10, 0)
    -- debugframe(self.pagingContainer)

    self.pagingUp = CreateFrame('Button', 'AuroraPagingUpButton', self.pagingContainer)
    self.pagingUp:SetSize(20, 20)
    self.pagingUp:SetPoint('TOP', self.pagingContainer, 'TOP', 0, 0)
    self.pagingUp:SetNormalTexture(self.textures.pageUpNormal)
    self.pagingUp:SetPushedTexture(self.textures.pageUpPushed)
    self.pagingUp:SetHighlightTexture(self.textures.pageUpHighlight)
    self.pagingUp:SetScript('OnClick', function()
        setup:UpdatePage(1)
    end)

    self.pagingNumber = self.pagingContainer:CreateFontString(nil, 'OVERLAY')
    self.pagingNumber:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
    self.pagingNumber:SetPoint('CENTER', self.pagingContainer, 'CENTER', 0, 0)
    self.pagingNumber:SetText('1')

    self.pagingDown = CreateFrame('Button', 'AuroraPagingDownButton', self.pagingContainer)
    self.pagingDown:SetSize(20, 20)
    self.pagingDown:SetPoint('BOTTOM', self.pagingContainer, 'BOTTOM', 0, 0)
    self.pagingDown:SetNormalTexture(self.textures.pageDownNormal)
    self.pagingDown:SetPushedTexture(self.textures.pageDownPushed)
    self.pagingDown:SetHighlightTexture(self.textures.pageDownHighlight)
    self.pagingDown:SetScript('OnClick', function()
        setup:UpdatePage(-1)
    end)
end

function setup:CreateKeyboardRouting(mainButtons, multiButtons, bonusButtons)
    self.activeMainButtons = mainButtons

    function _G.ActionButtonDown(id)
        local bonusOffset = GetBonusBarOffset()
        if bonusOffset > 0 and bonusButtons then
            if bonusButtons[bonusOffset] and bonusButtons[bonusOffset][id] then
                local btn = bonusButtons[bonusOffset][id]
                btn.pushed:Show()
                btn.highlight:Show()
            end
        elseif setup.activeMainButtons and setup.activeMainButtons[id] then
            setup.activeMainButtons[id].pushed:Show()
            setup.activeMainButtons[id].highlight:Show()
        end
    end

    function _G.ActionButtonUp(id, onSelf)
        local bonusOffset = GetBonusBarOffset()
        if bonusOffset > 0 and bonusButtons then
            if bonusButtons[bonusOffset] and bonusButtons[bonusOffset][id] then
                local btn = bonusButtons[bonusOffset][id]
                setup.lastUsedAction = btn:GetID()
                btn.pushed:Hide()
                btn.highlight:Hide()
                if AU.profile['actionbars']['animationTrigger'] == 'keypress' and HasAction(btn:GetID()) then
                    btn.animation.active = 0
                    btn.animation:Show()
                end
                UseAction(btn:GetID(), 0, onSelf)
            end
        elseif setup.activeMainButtons and setup.activeMainButtons[id] then
            setup.lastUsedAction = setup.activeMainButtons[id]:GetID()
            setup.activeMainButtons[id].pushed:Hide()
            setup.activeMainButtons[id].highlight:Hide()
            if AU.profile['actionbars']['animationTrigger'] == 'keypress' and HasAction(setup.activeMainButtons[id]:GetID()) then
                setup.activeMainButtons[id].animation.active = 0
                setup.activeMainButtons[id].animation:Show()
            end
            UseAction(setup.activeMainButtons[id]:GetID(), 0, onSelf)
        end
    end

    function _G.MultiActionButtonDown(bar, id)
        local barNum
        if bar == 'MultiBarBottomLeft' then barNum = 1
        elseif bar == 'MultiBarBottomRight' then barNum = 2
        elseif bar == 'MultiBarRight' then barNum = 3
        elseif bar == 'MultiBarLeft' then barNum = 4
        end
        if barNum and multiButtons[barNum] and multiButtons[barNum][id] then
            local btn = multiButtons[barNum][id]
            btn.pushed:Show()
            btn.highlight:Show()
        end
    end

    function _G.MultiActionButtonUp(bar, id, onSelf)
        local barNum
        if bar == 'MultiBarBottomLeft' then barNum = 1
        elseif bar == 'MultiBarBottomRight' then barNum = 2
        elseif bar == 'MultiBarRight' then barNum = 3
        elseif bar == 'MultiBarLeft' then barNum = 4
        end
        if barNum and multiButtons[barNum] and multiButtons[barNum][id] then
            local btn = multiButtons[barNum][id]
            btn.pushed:Hide()
            btn.highlight:Hide()
            if AU.profile['actionbars']['animationTrigger'] == 'keypress' and HasAction(btn:GetID()) then
                btn.animation.active = 0
                btn.animation:Show()
            end
            UseAction(btn:GetID(), 0, onSelf)
        end
    end
end

function setup:ShowAllButtons()
    self.isDragging = true
    local barNames = {'mainBar', 'multibar1', 'multibar2', 'multibar3', 'multibar4', 'multibar5'}
    local barFrames = {self.mainBar, self.multiBars[1], self.multiBars[2], self.multiBars[3], self.multiBars[4], self.multiBars[5]}

    for idx = 1, table.getn(barNames) do
        local barName = barNames[idx]
        local barFrame = barFrames[idx]
        local skipBar = false
        local anchorFrame = barFrame

        -- If mainBar is paged away, use currentPageBar for mainBar concatenate
        if barName == 'mainBar' and self.currentPageBar and self.currentPageBar ~= self.mainBar then
            if AU.profile['actionbars']['mainBarConcatenateEnabled'] then
                barFrame = self.currentPageBar
                anchorFrame = self.mainBar
                assert(barFrame ~= self.mainBar, 'ShowAllButtons: when paged, barFrame must not be mainBar')
                assert(anchorFrame == self.mainBar, 'ShowAllButtons: when paged, anchorFrame must be mainBar')
                assert(barFrame.buttons[1]:GetParent() == anchorFrame, 'ShowAllButtons: paged buttons must be parented to mainBar')
            else
                skipBar = true
            end
        end

        if not skipBar and barFrame and AU.profile['actionbars'][barName..'ConcatenateEnabled'] then
            local buttonSize = AU.profile['actionbars'][barName..'ButtonSize']
            local spacing = AU.profile['actionbars'][barName..'ButtonSpacing']
            local buttonsToShow = AU.profile['actionbars'][barName..'ButtonsToShow']

            if not barFrame.expandFrame then
                barFrame.expandFrame = CreateFrame('Frame')
                barFrame.expandFrame:Hide()
            end

            barFrame.expandFrame.buttons = {}
            barFrame.expandFrame.duration = 0.15
            barFrame.expandFrame.elapsed = 0
            barFrame.expandFrame.anchorFrame = anchorFrame

            for i = 1, buttonsToShow do
                local btn = barFrame.buttons[i]
                barFrame.expandFrame.buttons[i] = {
                    button = btn,
                    startX = btn:GetLeft() and (btn:GetLeft() - anchorFrame:GetLeft()) or ((i - 1) * (buttonSize + spacing)),
                    targetX = (i - 1) * (buttonSize + spacing)
                }
            end

            barFrame.expandFrame:SetScript('OnUpdate', function()
                this.elapsed = this.elapsed + arg1
                local progress = math.min(this.elapsed / this.duration, 1)

                for i = 1, table.getn(this.buttons) do
                    local data = this.buttons[i]
                    local currentX = data.startX + (data.targetX - data.startX) * progress
                    data.button:ClearAllPoints()
                    data.button:SetPoint('TOPLEFT', this.anchorFrame, 'TOPLEFT', currentX, 0)
                    data.button:Show()
                end

                if progress >= 1 then
                    this:SetScript('OnUpdate', nil)
                    this:Hide()
                end
            end)

            barFrame.expandFrame:Show()
        elseif not skipBar and barFrame then
            for i = 1, 12 do
                barFrame.buttons[i]:Show()
            end
        end
    end
end

function setup:HideEmptyButtons()
    self.isDragging = false
    local barNames = {'mainBar', 'multibar1', 'multibar2', 'multibar3', 'multibar4', 'multibar5'}
    local barFrames = {self.mainBar, self.multiBars[1], self.multiBars[2], self.multiBars[3], self.multiBars[4], self.multiBars[5]}
    for idx = 1, table.getn(barNames) do
        local barName = barNames[idx]
        local barFrame = barFrames[idx]
        if AU.profile['actionbars'][barName..'ConcatenateEnabled'] then
            if AU.setups.helpers and AU.setups.helpers.actionbars and AU.setups.helpers.actionbars.UpdateBarConcatenate then
                local targetFrame = barFrame
                if barName == 'mainBar' and self.currentPageBar and self.currentPageBar ~= self.mainBar then
                    targetFrame = self.currentPageBar
                    assert(targetFrame == self.currentPageBar, 'HideEmptyButtons: targetFrame must be currentPageBar when paged')
                    assert(targetFrame.buttons[1]:GetParent() == self.mainBar, 'HideEmptyButtons: paged buttons must be parented to mainBar')
                end
                AU.setups.helpers.actionbars.UpdateBarConcatenate(targetFrame, barName)
            end
        elseif AU.profile['actionbars'][barName..'HideEmptyButtons'] then
            for i = 1, 12 do
                if HasAction(barFrame.buttons[i]:GetID()) then
                    barFrame.buttons[i]:Show()
                else
                    barFrame.buttons[i]:Hide()
                end
            end
        end
    end
end

-- updates
function setup:UpdateButtonIcon(button)
    local id = button:GetID()
    local texture
    if id >= 200 and id <= 209 then
        texture = GetShapeshiftFormInfo(id - 199)
    elseif id >= 133 and id <= 142 then
        local _, _, tex, token = GetPetActionInfo(id - 132)
        texture = token and _G[tex] or tex
    else
        texture = GetActionTexture(id)
    end
    if texture then
        button.icon:SetTexture(texture)
        button.icon:Show()
    else
        button.icon:Hide()
    end
end

function setup:UpdateButtonKeybind(button)
    local id = button:GetID()
    local hasContent = HasAction(id) or (id >= 200 and id <= 209 and GetShapeshiftFormInfo(id - 199))
    if hasContent or self.showKeybindsOnEmpty then
        local key
        local useMainBarKeybind = false

        if self.currentPageBar and self.currentPageBar ~= self.mainBar then
            for i = 1, table.getn(self.currentPageBar.buttons) do
                if self.currentPageBar.buttons[i] == button then
                    useMainBarKeybind = true
                    key = GetBindingKey('ACTIONBUTTON'..i)
                    break
                end
            end
        end

        if not useMainBarKeybind then
            if id >= 1 and id <= 12 then
                key = GetBindingKey('ACTIONBUTTON'..id)
            elseif id >= 73 and id <= 84 then
                key = GetBindingKey('ACTIONBUTTON'..(id - 72))
            elseif id >= 61 and id <= 72 then
                key = GetBindingKey('MULTIACTIONBAR1BUTTON'..(id - 60))
            elseif id >= 49 and id <= 60 then
                key = GetBindingKey('MULTIACTIONBAR2BUTTON'..(id - 48))
            elseif id >= 25 and id <= 36 then
                key = GetBindingKey('MULTIACTIONBAR3BUTTON'..(id - 24))
            elseif id >= 37 and id <= 48 then
                key = GetBindingKey('MULTIACTIONBAR4BUTTON'..(id - 36))
            elseif id >= 200 and id <= 209 then
                key = GetBindingKey('SHAPESHIFTBUTTON'..(id - 199))
            end
        end

        if key then
            key = GetBindingText(key, 'KEY_')
            key = string.gsub(key, 'Mouse Wheel Up', 'MWU')
            key = string.gsub(key, 'Mouse Wheel Down', 'MWD')
            key = string.gsub(key, 'Mouse Button ', 'M')
            key = string.gsub(key, 'Num Pad ', 'N')
            key = string.gsub(key, 'Spacebar', 'Spc')
            key = string.gsub(key, 'SHIFT%-', 'S-')
            key = string.gsub(key, 'CTRL%-', 'C-')
            key = string.gsub(key, 'ALT%-', 'A-')
            button.keybind:SetText(key)
        else
            button.keybind:SetText('')
        end
    else
        button.keybind:SetText('')
    end
end

function setup:UpdateButtonMacroText(button)
    local text = GetActionText(button:GetID())
    if text and self.abbreviateMacroNames then
        text = string.sub(text, 1, 4)
    end
    button.macroText:SetText(text or '')
end

function setup:UpdateButtonCount(button)
    if IsConsumableAction(button:GetID()) then
        button.count:SetText(GetActionCount(button:GetID()))
    else
        button.count:SetText('')
    end
end

function setup:UpdateButtonCooldown(button)
    local id = button:GetID()
    local start, duration, enable
    if id >= 200 and id <= 209 then
        start, duration, enable = GetShapeshiftFormCooldown(id - 199)
    elseif id >= 133 and id <= 142 then
        start, duration, enable = GetPetActionCooldown(id - 132)
    else
        start, duration, enable = GetActionCooldown(id)
    end
    CooldownFrame_SetTimer(button.cooldown, start, duration, enable)
end

function setup:UpdateButtonBorder(button)
    if IsEquippedAction(button:GetID()) then
        button.equippedBorder:Show()
    else
        button.equippedBorder:Hide()
    end
end

function setup:UpdateButtonUsable(button)
    local id = button:GetID()
    local isUsable, oom

    if id >= 200 and id <= 209 then
        local _, _, _, isCastable = GetShapeshiftFormInfo(id - 199)
        isUsable = isCastable
        oom = false
    elseif id >= 133 and id <= 142 then
        isUsable = true
        oom = false
    else
        isUsable, oom = IsUsableAction(id)
    end

    local outOfRange = ActionHasRange(id) and IsActionInRange(id) == 0
    local rangeColor = AU.profile['actionbars']['rangeColour']
    local manaColor = AU.profile['actionbars']['manaColour']
    local usableColor = AU.profile['actionbars']['usableColour']
    local unusableColor = AU.profile['actionbars']['unusableColour']

    if self.rangeIndicator == 'keybind' then
        if outOfRange then
            button.keybind:SetTextColor(rangeColor[1], rangeColor[2], rangeColor[3], rangeColor[4])
        else
            local color = AU.profile['actionbars']['hotkeyColour']
            button.keybind:SetTextColor(color[1], color[2], color[3], color[4])
        end

        if oom then
            button.icon:SetVertexColor(manaColor[1], manaColor[2], manaColor[3], manaColor[4])
        elseif isUsable then
            button.icon:SetVertexColor(usableColor[1], usableColor[2], usableColor[3], usableColor[4])
        else
            button.icon:SetVertexColor(unusableColor[1], unusableColor[2], unusableColor[3], unusableColor[4])
        end
    else
        if outOfRange then
            button.icon:SetVertexColor(rangeColor[1], rangeColor[2], rangeColor[3], rangeColor[4])
        elseif oom then
            button.icon:SetVertexColor(manaColor[1], manaColor[2], manaColor[3], manaColor[4])
        elseif isUsable then
            button.icon:SetVertexColor(usableColor[1], usableColor[2], usableColor[3], usableColor[4])
        else
            button.icon:SetVertexColor(unusableColor[1], unusableColor[2], unusableColor[3], unusableColor[4])
        end
    end
end

function setup:UpdateButtonReactive(button)
    if not self.reactiveEnabled then
        button.reactive:Hide()
        return
    end

    local id = button:GetID()
    if id >= 133 or not HasAction(id) then return end

    GameTooltip:SetOwner(UIParent, 'ANCHOR_NONE')
    GameTooltip:SetAction(id)
    local spellName = GameTooltipTextLeft1:GetText()
    GameTooltip:Hide()

    if not spellName or not self.reactiveSpells[spellName] then
        button.reactive:Hide()
        return
    end

    local isUsable, oom = IsUsableAction(id)

    if isUsable and not oom then
        button.reactive:Show()
        -- debugprint('Reactive PROC: '..spellName)
    else
        button.reactive:Hide()
    end
end

function setup:UpdateButtonFlash(button, elapsed)
    if button.isFlashing then
        button.flashTime = button.flashTime + elapsed
        if button.flashTime >= 0.4 then
            button.flashTime = 0
            local currentAlpha = button.flash:GetAlpha()
            button.flash:SetAlpha(currentAlpha > 0 and 0 or 0.4)
        end
    else
        button.flash:SetAlpha(0)
    end
end

function setup:UpdateBarDecorations(bar, texture, position)
    local texPath = self.textures[texture]
    if position == 'none' then
        bar.decorationLeftFrame:Hide()
        bar.decorationRightFrame:Hide()
    elseif position == 'left' then
        bar.decorationLeft:SetTexture(texPath)
        bar.decorationLeftFrame:Show()
        bar.decorationRightFrame:Hide()
    elseif position == 'right' then
        bar.decorationRight:SetTexture(texPath)
        bar.decorationRightFrame:Show()
        bar.decorationLeftFrame:Hide()
    elseif position == 'both' then
        bar.decorationLeft:SetTexture(texPath)
        bar.decorationRight:SetTexture(texPath)
        bar.decorationLeftFrame:Show()
        bar.decorationRightFrame:Show()
    end
end

function setup:UpdatePage(direction)
    local numPages = table.getn(self.pageableBars)
    if numPages <= 1 then return end

    if self.currentPageBar then
        for i = 1, table.getn(self.currentPageBar.buttons) do
            self.currentPageBar.buttons[i]:Hide()
        end
        if self.currentPageBar ~= self.mainBar then
            for i = 1, table.getn(self.currentPageBar.buttons) do
                self.currentPageBar.buttons[i]:SetParent(self.currentPageBar)
            end
        end
    end

    self.currentPage = self.currentPage + direction
    if self.currentPage < 1 then
        self.currentPage = numPages
    elseif self.currentPage > numPages then
        self.currentPage = 1
    end

    self.pagingNumber:SetText(self.currentPage)

    if not self.mainBar then return end

    for i = 1, table.getn(self.mainBar.buttons) do
        self.mainBar.buttons[i]:Hide()
    end

    local pagedBar = self.pageableBars[self.currentPage]
    if pagedBar then
        self.currentPageBar = pagedBar
        self.activeMainButtons = pagedBar.buttons
        assert(self.currentPageBar, 'UpdatePage: currentPageBar must be set')

        local mainSize = AU.profile['actionbars']['mainBarButtonSize']
        local mainSpacing = AU.profile['actionbars']['mainBarButtonSpacing']
        local mainPerRow = AU.profile['actionbars']['mainBarButtonsPerRow']

        for i = 1, table.getn(pagedBar.buttons) do
            local btn = pagedBar.buttons[i]
            btn:SetWidth(mainSize)
            btn:SetHeight(mainSize)
            btn:ClearAllPoints()
            btn:SetParent(self.mainBar)

            local row = math.floor((i - 1) / mainPerRow)
            local col = math.mod(i - 1, mainPerRow)
            if i == 1 then
                btn:SetPoint('TOPLEFT', self.mainBar, 'TOPLEFT', 0, 0)
            else
                btn:SetPoint('TOPLEFT', self.mainBar, 'TOPLEFT', col * (mainSize + mainSpacing), -row * (mainSize + mainSpacing))
            end

            if i <= AU.profile['actionbars']['mainBarButtonsToShow'] then
                btn:Show()
            else
                btn:Hide()
            end

            self:UpdateButtonIcon(btn)
            self:UpdateButtonKeybind(btn)
            self:UpdateButtonMacroText(btn)
            self:UpdateButtonCount(btn)
            self:UpdateButtonCooldown(btn)
            self:UpdateButtonUsable(btn)
            self:UpdateButtonBorder(btn)
        end
        if pagedBar ~= self.mainBar then
            assert(pagedBar.buttons[1]:GetParent() == self.mainBar, 'UpdatePage: paged buttons must be parented to mainBar')
        end
        if AU_GlobalDB and AU.profile['actionbars'] and AU.profile['actionbars']['mainBarConcatenateEnabled'] then
            if AU.setups.helpers and AU.setups.helpers.actionbars and AU.setups.helpers.actionbars.UpdateBarConcatenate then
                AU.setups.helpers.actionbars.UpdateBarConcatenate(pagedBar, 'mainBar')
            end
        end
    end
end

function setup:UpdatePageableBars()
    self.pageableBars = {}
    if self.mainBar then
        table.insert(self.pageableBars, self.mainBar)
    end
    for i = 1, table.getn(self.multiBars) do
        local barName = 'multibar'..i
        if AU_GlobalDB and AU.profile['actionbars'] and not AU.profile['actionbars'][barName..'Enabled'] then
            table.insert(self.pageableBars, self.multiBars[i])
        end
    end
end

function setup:UpdateBonusBarVisibility()
    local offset = GetBonusBarOffset()

    if offset > 0 then
        for _, bar in pairs(self.bars) do
            for i = 1, table.getn(bar.buttons) do
                local id = bar.buttons[i]:GetID()
                if id >= 1 and id <= 12 then
                    bar.buttons[i]:Hide()
                end
            end
        end
        for i = 1, 4 do
            if i == offset then
                self.bonusBars[i]:Show()
            else
                self.bonusBars[i]:Hide()
            end
        end
    else
        for i = 1, 4 do
            self.bonusBars[i]:Hide()
        end
    end
end

function setup:UpdatePetBarVisibility()
    if self.petBar then
        if AU_GlobalDB and AU.profile['actionbars'] and AU.profile['actionbars']['petBarEnabled'] and PetHasActionBar() then
            self.petBar:Show()
        else
            self.petBar:Hide()
        end
    end
end

function setup:UpdateStanceBarVisibility()
    local numForms = GetNumShapeshiftForms()
    if self.stanceBar then
        if AU_GlobalDB and AU.profile['actionbars'] and AU.profile['actionbars']['stanceBarEnabled'] and numForms > 0 then
            for i = 1, table.getn(self.stanceButtons) do
                if i <= numForms then
                    self.stanceButtons[i]:Show()
                else
                    self.stanceButtons[i]:Hide()
                end
            end
            self.stanceBar:SetSize(numForms * self.buttonSize + (numForms - 1) * 3, self.buttonSize)
            self.stanceBar:Show()
        else
            self.stanceBar:Hide()
        end
    end
end

-- events
function setup:OnEvent()
    setup.eventFrame = CreateFrame'Frame'
    setup.eventFrame:RegisterEvent'ACTIONBAR_SLOT_CHANGED'
    setup.eventFrame:RegisterEvent'UPDATE_BINDINGS'
    setup.eventFrame:RegisterEvent'UNIT_INVENTORY_CHANGED'
    setup.eventFrame:RegisterEvent'ACTIONBAR_UPDATE_COOLDOWN'
    setup.eventFrame:RegisterEvent'SPELL_UPDATE_COOLDOWN'
    setup.eventFrame:RegisterEvent'ACTIONBAR_UPDATE_USABLE'
    setup.eventFrame:RegisterEvent'ACTIONBAR_UPDATE_STATE'
    setup.eventFrame:RegisterEvent'PLAYER_TARGET_CHANGED'
    setup.eventFrame:RegisterEvent'UPDATE_INVENTORY_ALERTS'
    setup.eventFrame:RegisterEvent'CRAFT_SHOW'
    setup.eventFrame:RegisterEvent'CRAFT_CLOSE'
    setup.eventFrame:RegisterEvent'TRADE_SKILL_SHOW'
    setup.eventFrame:RegisterEvent'TRADE_SKILL_CLOSE'
    setup.eventFrame:RegisterEvent'PLAYER_AURAS_CHANGED'
    setup.eventFrame:RegisterEvent'PLAYER_ENTER_COMBAT'
    setup.eventFrame:RegisterEvent'PLAYER_LEAVE_COMBAT'
    setup.eventFrame:RegisterEvent'START_AUTOREPEAT_SPELL'
    setup.eventFrame:RegisterEvent'STOP_AUTOREPEAT_SPELL'
    setup.eventFrame:RegisterEvent'UPDATE_BONUS_ACTIONBAR'
    setup.eventFrame:RegisterEvent'PET_BAR_UPDATE'
    setup.eventFrame:RegisterEvent'PET_BAR_UPDATE_COOLDOWN'
    setup.eventFrame:RegisterEvent'UPDATE_SHAPESHIFT_FORMS'
    setup.eventFrame:RegisterEvent'UPDATE_SHAPESHIFT_FORM'
    setup.eventFrame:RegisterEvent'SPELL_UPDATE_USABLE'
    setup.eventFrame:RegisterEvent'ACTIONBAR_SHOWGRID'
    setup.eventFrame:RegisterEvent'ACTIONBAR_HIDEGRID'
    setup.hideEmptyFrame = CreateFrame('Frame')
    setup.hideEmptyFrame:SetScript('OnUpdate', function()
        if setup.hideEmptyTimer then
            setup.hideEmptyTimer = setup.hideEmptyTimer - arg1
            if setup.hideEmptyTimer <= 0 then
                setup.hideEmptyTimer = nil
                setup:HideEmptyButtons()
            end
        end
    end)

    setup.eventFrame:SetScript('OnEvent', function()
    if event == 'ACTIONBAR_SLOT_CHANGED' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                local button = bar.buttons[i]
                if arg1 == 0 or arg1 == button:GetID() then
                    setup:UpdateButtonIcon(button)
                    setup:UpdateButtonKeybind(button)
                    setup:UpdateButtonMacroText(button)
                    setup:UpdateButtonCount(button)
                    setup:UpdateButtonCooldown(button)
                    setup:UpdateButtonUsable(button)
                    setup:UpdateButtonBorder(button)
                end
            end
        end
        local activeBar = setup.currentPageBar and setup.currentPageBar:GetName() or 'mainBar'
        -- debugprint('ACTIONBAR_SLOT_CHANGED: activeBar='..activeBar..' isPaged='..(setup.currentPageBar and setup.currentPageBar ~= setup.mainBar and 'YES' or 'NO'))
        local barNames = {'mainBar', 'multibar1', 'multibar2', 'multibar3', 'multibar4', 'multibar5'}
        local barFrames = {setup.mainBar, setup.multiBars[1], setup.multiBars[2], setup.multiBars[3], setup.multiBars[4], setup.multiBars[5]}
        for idx = 1, table.getn(barNames) do
            if AU.setups.helpers and AU.setups.helpers.actionbars and AU.setups.helpers.actionbars.UpdateBarConcatenate then
                local targetFrame = barFrames[idx]
                if barNames[idx] == 'mainBar' and setup.currentPageBar and setup.currentPageBar ~= setup.mainBar then
                    targetFrame = setup.currentPageBar
                    assert(targetFrame == setup.currentPageBar, 'ACTIONBAR_SLOT_CHANGED: targetFrame must be currentPageBar when paged')
                    assert(targetFrame.buttons[1]:GetParent() == setup.mainBar, 'ACTIONBAR_SLOT_CHANGED: paged buttons must be parented to mainBar')
                end
                -- debugprint('ACTIONBAR_SLOT_CHANGED calling UpdateBarConcatenate for '..barNames[idx]..' targetFrame='..tostring(targetFrame:GetName()))
                AU.setups.helpers.actionbars.UpdateBarConcatenate(targetFrame, barNames[idx])
            end
        end
    elseif event == 'UPDATE_BINDINGS' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                setup:UpdateButtonKeybind(bar.buttons[i])
            end
        end
    elseif event == 'UNIT_INVENTORY_CHANGED' then
        if arg1 == 'player' then
            for _, bar in pairs(setup.bars) do
                for i = 1, table.getn(bar.buttons) do
                    setup:UpdateButtonCount(bar.buttons[i])
                end
            end
        end
    elseif event == 'ACTIONBAR_UPDATE_COOLDOWN' or event == 'SPELL_UPDATE_COOLDOWN' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                setup:UpdateButtonCooldown(bar.buttons[i])
            end
        end
    elseif event == 'ACTIONBAR_UPDATE_USABLE' or event == 'PLAYER_TARGET_CHANGED' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                setup:UpdateButtonUsable(bar.buttons[i])
            end
        end
    elseif event == 'SPELL_UPDATE_USABLE' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                setup:UpdateButtonReactive(bar.buttons[i])
            end
        end
    elseif event == 'UPDATE_INVENTORY_ALERTS' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                setup:UpdateButtonBorder(bar.buttons[i])
            end
        end
    elseif event == 'ACTIONBAR_UPDATE_STATE' or event == 'CRAFT_SHOW' or event == 'CRAFT_CLOSE' or event == 'TRADE_SKILL_SHOW' or event == 'TRADE_SKILL_CLOSE' or event == 'PLAYER_AURAS_CHANGED' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                local button = bar.buttons[i]
                local id = button:GetID()
                local isActive = false

                if id >= 200 and id <= 209 then
                    local _, _, active = GetShapeshiftFormInfo(id - 199)
                    isActive = active
                elseif id >= 133 and id <= 142 then
                    local _, _, _, _, active = GetPetActionInfo(id - 132)
                    isActive = active
                else
                    local hasAction = HasAction(id)
                    local isCurrent = IsCurrentAction(id)
                    local isAutoRepeat = IsAutoRepeatAction(id)
                    isActive = hasAction and (isCurrent or isAutoRepeat)
                end

                if isActive then
                    button.checked:Show()
                else
                    button.checked:Hide()
                end
            end
        end
    elseif event == 'PLAYER_ENTER_COMBAT' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                local button = bar.buttons[i]
                if IsAttackAction(button:GetID()) then
                    button.isFlashing = true
                    button:SetScript('OnUpdate', function()
                        setup:UpdateButtonFlash(this, arg1)
                    end)
                end
            end
        end
    elseif event == 'PLAYER_LEAVE_COMBAT' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                local button = bar.buttons[i]
                if IsAttackAction(button:GetID()) then
                    button.isFlashing = false
                    button.flash:SetAlpha(0)
                    button:SetScript('OnUpdate', nil)
                end
            end
        end
    elseif event == 'START_AUTOREPEAT_SPELL' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                local button = bar.buttons[i]
                if IsAutoRepeatAction(button:GetID()) then
                    button.isFlashing = true
                    button:SetScript('OnUpdate', function()
                        setup:UpdateButtonFlash(this, arg1)
                    end)
                end
            end
        end
    elseif event == 'STOP_AUTOREPEAT_SPELL' then
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                local button = bar.buttons[i]
                if IsAutoRepeatAction(button:GetID()) then
                    button.isFlashing = false
                    button.flash:SetAlpha(0)
                    button:SetScript('OnUpdate', nil)
                end
            end
        end
    elseif event == 'UPDATE_BONUS_ACTIONBAR' then
        setup:UpdateBonusBarVisibility()
    elseif event == 'PET_BAR_UPDATE' or event == 'PET_BAR_UPDATE_COOLDOWN' then
        for i = 1, table.getn(setup.petButtons) do
            local button = setup.petButtons[i]
            setup:UpdateButtonIcon(button)
            setup:UpdateButtonUsable(button)
            setup:UpdateButtonCooldown(button)
            local _, _, _, _, active, _, autocast = GetPetActionInfo(i)
            if active then
                button.checked:Show()
            else
                button.checked:Hide()
            end
            if button.autocast then
                if autocast then
                    button.autocast:Show()
                else
                    button.autocast:Hide()
                end
            end
        end
        setup:UpdatePetBarVisibility()
    elseif event == 'UPDATE_SHAPESHIFT_FORMS' or event == 'UPDATE_SHAPESHIFT_FORM' then
        for i = 1, table.getn(setup.stanceButtons) do
            local button = setup.stanceButtons[i]
            setup:UpdateButtonIcon(button)
            setup:UpdateButtonUsable(button)
            setup:UpdateButtonCooldown(button)
        end
        if event == 'UPDATE_SHAPESHIFT_FORMS' then
            setup:UpdateStanceBarVisibility()
        end
    elseif event == 'ACTIONBAR_SHOWGRID' then
        setup:ShowAllButtons()
    elseif event == 'ACTIONBAR_HIDEGRID' then
        setup.hideEmptyTimer = 0.15
    end
    end)
end

function setup:InitUpdateTimer()
    if self.buttonUpdateTimer then return end
    self.buttonUpdateTimer = AU.timers.every(0.1, function()
        for _, bar in pairs(setup.bars) do
            for i = 1, table.getn(bar.buttons) do
                local button = bar.buttons[i]
                if button:IsVisible() then
                    local btnID = button:GetID()

                    if btnID < 133 or btnID > 209 then
                        local hasAction = HasAction(btnID)
                        local isCurrent = IsCurrentAction(btnID)
                        local isAutoRepeat = IsAutoRepeatAction(btnID)
                        local isChanneling = UnitChannelInfo('player') and setup.lastUsedAction == btnID
                        if hasAction and (isCurrent or isAutoRepeat or isChanneling) then
                            button.checked:Show()
                        else
                            button.checked:Hide()
                        end
                    end

                    if btnID >= 200 and btnID <= 209 then
                        button.rangeTimer = button.rangeTimer - 0.1
                        if button.rangeTimer <= 0 then
                            setup:UpdateButtonIcon(button)
                            button.rangeTimer = 0.2
                        end
                    elseif HasAction(btnID) then
                        button.rangeTimer = button.rangeTimer - 0.1
                        if button.rangeTimer <= 0 then
                            setup:UpdateButtonUsable(button)
                            button.rangeTimer = 0.1
                        end
                    end
                end
            end
        end
    end)
end

-- init
function setup:InitializeBar(bar)
    for i = 1, table.getn(bar.buttons) do
        local button = bar.buttons[i]
        self:UpdateButtonIcon(button)
        self:UpdateButtonKeybind(button)
        self:UpdateButtonMacroText(button)
        self:UpdateButtonCount(button)
        self:UpdateButtonCooldown(button)
        self:UpdateButtonUsable(button)
        self:UpdateButtonBorder(button)
    end
    self:InitUpdateTimer()
end

function setup:GenerateDefaults()
end

-- expose
AU.setups.actionbars = setup
