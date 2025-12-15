UNLOCKAURORA()

local setup = {
    portraitModels = {},
    portraits = {},
    updater = CreateFrame('Frame'),
    combatGlowElapsed = 0,
    lastTargetColor = {0, 1, 0},

    textures = {
        portraitBorderBg = media['tex:unitframes:portrait_border_bg.blp'],
        portraitBorder = media['tex:unitframes:portrait_border_edge.blp'],
        portraitBorderAlt1 = media['tex:unitframes:portrait_border.blp'],
        portraitBorderAlt2 = media['tex:unitframes:portrait_border_base.blp'],
        portraitNameBg = media['tex:generic:backdrop_rounded.blp'],
        portraitBorderGlow = media['tex:unitframes:portrait_border_edge_glow.blp'],
        portraitBorderGlowAlt = media['tex:unitframes:portrait_border_glow.blp'],
        barglow = media['tex:unitframes:barglow.blp'],
        pvpAlly = media['tex:unitframes:UI-PVP-Alliance.blp'],
        pvpHorde = media['tex:unitframes:UI-PVP-Horde.blp'],
        debuffOverlay = 'Interface\\Buttons\\UI-Debuff-Overlays',
        tick = media['tex:castbar:CastingBarSpark.blp'],
        restingZZZ = media['tex:unitframes:UIUnitFrameRestingFlipbook.tga'],
        classIcons = media['tex:interface:UI-Classes-Circles.tga'],
        borderElite = media['tex:unitframes:uf_elite.blp'],
        borderRare = media['tex:unitframes:uf_rare.blp'],
        borderBoss = media['tex:unitframes:uf_boss.blp']
    },


    zzzCoords = {
        {0/512, 60/512, 0/512, 60/512}, {60/512, 120/512, 0/512, 60/512}, {120/512, 180/512, 0/512, 60/512}, {180/512, 240/512, 0/512, 60/512}, {240/512, 300/512, 0/512, 60/512}, {300/512, 360/512, 0/512, 60/512},
        {0/512, 60/512, 60/512,120/512}, {60/512, 120/512, 60/512, 120/512}, {120/512, 180/512, 60/512, 120/512}, {180/512, 240/512, 60/512, 120/512}, {240/512, 300/512, 60/512, 120/512}, {300/512, 360/512, 60/512, 120/512},
        {0/512, 60/512, 120/512, 180/512}, {60/512, 120/512, 120/512, 180/512}, {120/512, 180/512, 120/512, 180/512}, {180/512, 240/512, 120/512, 180/512}, {240/512, 300/512, 120/512, 180/512}, {300/512, 360/512, 120/512, 180/512},
        {0/512, 60/512, 180/512, 240/512}, {60/512, 120/512, 180/512, 240/512}, {120/512, 180/512, 180/512, 240/512}, {180/512, 240/512, 180/512, 240/512}, {240/512, 300/512, 180/512, 240/512}, {300/512, 360/512, 180/512, 240/512},
        {0/512, 60/512, 240/512, 300/512}, {60/512, 120/512, 240/512, 300/512}, {120/512, 180/512, 240/512, 300/512}, {180/512, 240/512, 240/512, 300/512}, {240/512, 300/512, 240/512, 300/512}, {300/512, 360/512, 240/512, 300/512},
        {0/512, 60/512, 300/512, 360/512}, {60/512, 120/512, 300/512, 360/512}, {120/512, 180/512, 300/512, 360/512}, {180/512, 240/512, 300/512, 360/512}, {240/512, 300/512, 300/512, 360/512}, {300/512, 360/512, 300/512, 360/512},
    },
}

local function GetPortraitModelOffset(size)
    local minSize, maxSize = 40, 120
    local minOffset, maxOffset = 21, 37
    local offset = minOffset + (size - minSize) * (maxOffset - minOffset) / (maxSize - minSize)
    return offset
end

-- TODO fix for now for dropdown
function setup:ShowRightClickMenu(unit)
    if unit == 'player' then
        ToggleDropDownMenu(1, nil, PlayerFrameDropDown, 'cursor')
    elseif unit == 'target' then
        ToggleDropDownMenu(1, nil, TargetFrameDropDown, 'cursor')
    elseif unit == 'pet' then
        ToggleDropDownMenu(1, nil, PetFrameDropDown, 'cursor')
    elseif unit == 'party' or strfind(unit, 'party%d') then
        local id = string.gsub(unit, 'party', '')
        ToggleDropDownMenu(1, nil, getglobal('PartyMemberFrame' .. id .. 'DropDown'), 'cursor')
    end
end

function setup:OnMouseUp()
    if arg1 == 'RightButton' then
        local unit = select(2, this:GetUnit())
        if unit then
            setup:ShowRightClickMenu(unit)
        end
    end
end

GameTooltip:SetScript('OnMouseUp', setup.OnMouseUp)

-- create
function setup:CreateUnitFrame(unit, width, height)
    local frameName = 'Aurora'..string.gsub(unit, '^%l', string.upper)..'Frame'
    local unitFrame = CreateFrame('Button', frameName, UIParent)
    unitFrame:SetSize(width, height)
    unitFrame.unit = unit
    unitFrame:SetFrameStrata('BACKGROUND')

    unitFrame.borderBg = unitFrame:CreateTexture(nil, 'BACKGROUND')
    unitFrame.borderBg:SetTexture(self.textures.portraitBorderBg)
    unitFrame.borderBg:SetSize(80, 80)

    unitFrame.model = CreateFrame('PlayerModel', nil, unitFrame)
    unitFrame.model:SetSize(80 + 15, 80 + 15)
    unitFrame.model.update = unit
    unitFrame.model.unit = unit
    table.insert(setup.portraitModels, unitFrame.model)

    unitFrame.portrait2D = unitFrame:CreateTexture(nil, 'ARTWORK')
    unitFrame.portrait2D:SetSize(80 - 26, 80 - 26)
    unitFrame.portrait2D:Hide()

    unitFrame.classIcon = unitFrame:CreateTexture(nil, 'ARTWORK')
    unitFrame.classIcon:SetSize(80 - 26, 80 - 26)
    unitFrame.classIcon:SetTexture(self.textures.classIcons)
    unitFrame.classIcon:Hide()

    local borderFrame = CreateFrame('Frame', nil, unitFrame)
    borderFrame:SetFrameLevel(unitFrame.model:GetFrameLevel() + 1)
    borderFrame:SetAllPoints(unitFrame.borderBg)
    unitFrame.border = borderFrame:CreateTexture(nil, 'OVERLAY')
    unitFrame.border:SetTexture(self.textures.portraitBorder)
    unitFrame.border:SetSize(80, 80)

    unitFrame.classBorderOverlay = borderFrame:CreateTexture(nil, 'OVERLAY')
    unitFrame.classBorderOverlay:SetPoint('CENTER', unitFrame.border, 'CENTER', 0, 0)
    unitFrame.classBorderOverlay:SetSize(96, 96)
    unitFrame.classBorderOverlay:Hide()

    unitFrame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    unitFrame:SetScript('OnClick', function()
        if arg1 == 'LeftButton' then
            TargetUnit(this.unit)
        elseif arg1 == 'RightButton' then
            setup:ShowRightClickMenu(this.unit)
        end
    end)

    unitFrame.hpBar = AU.animations.CreateStatusBar(unitFrame, 120, 20, nil, frameName..'.hpBar')
    unitFrame.hpBar:SetFillColor(0, 1, 0, 1)
    unitFrame.hpBar.text = unitFrame.hpBar:CreateFontString(nil, 'OVERLAY')
    unitFrame.hpBar.text:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
    unitFrame.hpBar.pctText = unitFrame.hpBar:CreateFontString(nil, 'OVERLAY')
    unitFrame.hpBar.pctText:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')

    unitFrame.powerBar = AU.animations.CreateStatusBar(unitFrame, 120, 12, nil, frameName..'.powerBar')
    unitFrame.powerBar:SetFillColor(0.2, 0.4, 1, 1)
    unitFrame.powerBar.text = unitFrame.powerBar:CreateFontString(nil, 'OVERLAY')
    unitFrame.powerBar.text:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
    unitFrame.powerBar.pctText = unitFrame.powerBar:CreateFontString(nil, 'OVERLAY')
    unitFrame.powerBar.pctText:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')

    if unit == 'player' then
        local tick = CreateFrame('Frame', nil, unitFrame.powerBar)
        tick:SetAllPoints(unitFrame.powerBar)
        tick.spark = tick:CreateTexture(nil, 'OVERLAY')
        tick.spark:SetTexture(self.textures.tick)
        tick.spark:SetSize(11, unitFrame.powerBar:GetHeight()+5)
        tick.spark:SetBlendMode('ADD')
        tick.enabled = true
        tick:Hide()
        unitFrame.powerBar.energyTick = tick
    end

    unitFrame.infoBg = CreateFrame('Frame', frameName..'.infoBg', unitFrame)
    unitFrame.infoBg:SetSize(unitFrame.hpBar:GetWidth(), 16)
    unitFrame.infoBg.tex = unitFrame.infoBg:CreateTexture(nil, 'BACKGROUND')
    unitFrame.infoBg.tex:SetTexture(self.textures.portraitNameBg)
    unitFrame.infoBg.tex:SetAllPoints(unitFrame.infoBg)
    unitFrame.infoBg.tex:SetVertexColor(0, 0, 0, 0.4)
    if unit == 'target' then unitFrame.infoBg.tex:SetTexCoord(1, 0, 0, 1) end

    unitFrame.name = unitFrame.infoBg:CreateFontString(nil, 'OVERLAY')
    unitFrame.name:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')

    unitFrame.level = unitFrame.infoBg:CreateFontString(nil, 'OVERLAY')
    unitFrame.level:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')

    if unit ~= 'pet' then
        unitFrame.pvpIconFrame = CreateFrame('Frame', nil, unitFrame)
        unitFrame.pvpIconFrame:SetFrameLevel(unitFrame.model:GetFrameLevel() + 3)
        unitFrame.pvpIcon = unitFrame.pvpIconFrame:CreateTexture(nil, 'OVERLAY')
        unitFrame.pvpIcon:SetSize(45, 45)
        unitFrame.pvpIcon:Hide()
    end

    if unit == 'target' then
        unitFrame.borderBg:SetPoint('LEFT', unitFrame, 'LEFT', 0, 0)
        unitFrame.model:SetPoint('LEFT', unitFrame, 'LEFT', 13, 0)
        unitFrame.portrait2D:SetPoint('LEFT', unitFrame, 'LEFT', 13, 0)
        unitFrame.classIcon:SetPoint('LEFT', unitFrame, 'LEFT', 13, 0)
        unitFrame.border:SetPoint('LEFT', unitFrame, 'LEFT', 0, 0)
        unitFrame.hpBar:SetFillDirection('LEFT_TO_RIGHT')
        unitFrame.hpBar:SetPoint('LEFT', unitFrame.border, 'RIGHT', -3, 10)
        unitFrame.hpBar.text:SetPoint('LEFT', unitFrame.hpBar, 'LEFT', 3, 0)
        unitFrame.hpBar.pctText:SetPoint('RIGHT', unitFrame.hpBar, 'RIGHT', -3, 0)
        unitFrame.powerBar:SetFillDirection('LEFT_TO_RIGHT')
        unitFrame.powerBar:SetPoint('TOPLEFT', unitFrame.hpBar, 'BOTTOMLEFT', 0, 0)
        unitFrame.powerBar.text:SetPoint('LEFT', unitFrame.powerBar, 'LEFT', 3, 0)
        unitFrame.powerBar.pctText:SetPoint('RIGHT', unitFrame.powerBar, 'RIGHT', -3, 0)
        unitFrame.infoBg:SetPoint('BOTTOMLEFT', unitFrame.hpBar, 'TOPLEFT', 0, 0)
        unitFrame.name:SetPoint('LEFT', unitFrame.infoBg, 'LEFT', 3, 1)
        unitFrame.level:SetPoint('RIGHT', unitFrame.infoBg, 'RIGHT', -3, 1)
        if unitFrame.pvpIcon then
            unitFrame.pvpIconFrame:SetAllPoints(unitFrame.borderBg)
            unitFrame.pvpIcon:SetPoint('CENTER', unitFrame.borderBg, 'LEFT', 12, 0)
        end
        unitFrame.hpBar.fill:SetTexture(media['tex:unitframes:aurora_hpbar_reversed.tga'])
        unitFrame.powerBar.fill:SetTexture(media['tex:unitframes:aurora_hpbar_reversed.tga'])
    else
        unitFrame.borderBg:SetPoint('RIGHT', unitFrame, 'RIGHT', 0, 0)
        unitFrame.model:SetPoint('RIGHT', unitFrame, 'RIGHT', -13, 0)
        unitFrame.portrait2D:SetPoint('RIGHT', unitFrame, 'RIGHT', -13, 0)
        unitFrame.classIcon:SetPoint('RIGHT', unitFrame, 'RIGHT', -13, 0)
        unitFrame.border:SetPoint('RIGHT', unitFrame, 'RIGHT', 0, 0)
        unitFrame.hpBar:SetFillDirection('RIGHT_TO_LEFT')
        unitFrame.hpBar:SetPoint('RIGHT', unitFrame.border, 'LEFT', 3, 10)
        unitFrame.hpBar.text:SetPoint('RIGHT', unitFrame.hpBar, 'RIGHT', 0, 0)
        unitFrame.hpBar.pctText:SetPoint('LEFT', unitFrame.hpBar, 'LEFT', 3, 0)
        unitFrame.powerBar:SetFillDirection('RIGHT_TO_LEFT')
        unitFrame.powerBar:SetPoint('TOPRIGHT', unitFrame.hpBar, 'BOTTOMRIGHT', 0, 0)
        unitFrame.powerBar.text:SetPoint('RIGHT', unitFrame.powerBar, 'RIGHT', 0, 0)
        unitFrame.powerBar.pctText:SetPoint('LEFT', unitFrame.powerBar, 'LEFT', 3, 0)
        unitFrame.infoBg:SetPoint('BOTTOMRIGHT', unitFrame.hpBar, 'TOPRIGHT', 0, 0)
        unitFrame.name:SetPoint('RIGHT', unitFrame.infoBg, 'RIGHT', -3, 1)
        unitFrame.level:SetPoint('LEFT', unitFrame.infoBg, 'LEFT', 3, 1)
        if unitFrame.pvpIcon then
            unitFrame.pvpIconFrame:SetAllPoints(unitFrame.borderBg)
            unitFrame.pvpIcon:SetPoint('CENTER', unitFrame.borderBg, 'RIGHT', 5, 0)
        end
    end
    -- debugframe(unitFrame)
    local glowFrame = CreateFrame('Frame', nil, unitFrame)
    glowFrame:SetFrameLevel(unitFrame.model:GetFrameLevel() + 1)
    glowFrame:SetAllPoints(unitFrame)

    unitFrame.model.combatGlow = glowFrame:CreateTexture(nil, 'BACKGROUND')
    unitFrame.model.combatGlow:SetTexture(self.textures.portraitBorderGlow)
    unitFrame.model.combatGlow:SetPoint('TOPLEFT', unitFrame.model, 'TOPLEFT', -15, 15)
    unitFrame.model.combatGlow:SetPoint('BOTTOMRIGHT', unitFrame.model, 'BOTTOMRIGHT', 15, -15)
    unitFrame.model.combatGlow:SetVertexColor(1, 0, 0)
    if unit == 'target' then unitFrame.model.combatGlow:SetTexCoord(1, 0, 0, 1) end
    unitFrame.model.combatGlow:Hide()

    unitFrame.model.combatGlow2 = glowFrame:CreateTexture(nil, 'BACKGROUND')
    unitFrame.model.combatGlow2:SetTexture(self.textures.barglow)
    unitFrame.model.combatGlow2:SetPoint('BOTTOM', unitFrame.hpBar, 'TOP', 0, 0)
    unitFrame.model.combatGlow2:SetSize(unitFrame.hpBar:GetWidth(), 15)
    unitFrame.model.combatGlow2:SetVertexColor(1, 0, 0)
    if unit == 'target' then unitFrame.model.combatGlow2:SetTexCoord(1, 0, 0, 1) end
    unitFrame.model.combatGlow2:Hide()

    if unit == 'pet' then
        unitFrame.happinessIcon = CreateFrame('Frame', nil, unitFrame)
        unitFrame.happinessIcon:SetSize(22, 22)
        unitFrame.happinessIcon:SetPoint('LEFT', unitFrame.model, 'RIGHT', 7, 7)
        unitFrame.happinessIcon.bg = unitFrame.happinessIcon:CreateTexture(nil, 'BACKGROUND')
        unitFrame.happinessIcon.bg:SetAllPoints(unitFrame.happinessIcon)
        unitFrame.happinessIcon.bg:SetTexture(media['tex:generic:combo_empty.blp'])
        unitFrame.happinessIcon.fill = unitFrame.happinessIcon:CreateTexture(nil, 'ARTWORK')
        unitFrame.happinessIcon.fill:SetAllPoints(unitFrame.happinessIcon)
        unitFrame.happinessIcon.fill:SetTexture(media['tex:generic:combo_full.blp'])
        unitFrame.happinessIcon:Hide()
    end

    if unit == 'player' then
        unitFrame.model.restingGlow = glowFrame:CreateTexture(nil, 'BACKGROUND')
        unitFrame.model.restingGlow:SetTexture(self.textures.portraitBorderGlow)
        unitFrame.model.restingGlow:SetPoint('TOPLEFT', unitFrame.model, 'TOPLEFT', -15, 15)
        unitFrame.model.restingGlow:SetPoint('BOTTOMRIGHT', unitFrame.model, 'BOTTOMRIGHT', 15, -15)
        unitFrame.model.restingGlow:SetVertexColor(.3, .82, 0)
        unitFrame.model.restingGlow:Hide()
        unitFrame.model.restingGlow.elapsed = 0

        unitFrame.model.restingGlow2 = glowFrame:CreateTexture(nil, 'BACKGROUND')
        unitFrame.model.restingGlow2:SetTexture(self.textures.barglow)
        unitFrame.model.restingGlow2:SetPoint('BOTTOM', unitFrame.hpBar, 'TOP', 0, 0)
        unitFrame.model.restingGlow2:SetVertexColor(.3, .82, 0)
        unitFrame.model.restingGlow2:SetSize(unitFrame.hpBar:GetWidth(), 15)
        unitFrame.model.restingGlow2:Hide()

        unitFrame.restingZZZ = CreateFrame('Frame', nil, glowFrame)
        unitFrame.restingZZZ:SetFrameLevel(glowFrame:GetFrameLevel() + 1)
        unitFrame.restingZZZ:SetPoint('CENTER', unitFrame.model, 'CENTER', 25, 25)
        unitFrame.restingZZZ:SetSize(24, 24)
        unitFrame.restingZZZ.tex = unitFrame.restingZZZ:CreateTexture(nil, 'OVERLAY')
        unitFrame.restingZZZ.tex:SetTexture(self.textures.restingZZZ)
        unitFrame.restingZZZ.tex:SetAllPoints(unitFrame.restingZZZ)
        unitFrame.restingZZZ.currentFrame = 1
        unitFrame.restingZZZ.elapsed = 0
        unitFrame.restingZZZ:Hide()
    end

    unitFrame.combatGlowMode = 'Both'
    unitFrame.restingGlowMode = 'Both'

    unitFrame.buffs = {}
    unitFrame.debuffs = {}
    unitFrame.buffAnchor = 'below'
    unitFrame.debuffAnchor = 'above'
    local size = 20
    for i = 1, 16 do
        local buff = CreateFrame('Button', nil, unitFrame)
        buff:SetSize(size, size)
        buff.icon = buff:CreateTexture(nil, 'ARTWORK')
        buff.icon:SetAllPoints(buff)
        buff:Hide()
        unitFrame.buffs[i] = buff

        local debuff = CreateFrame('Button', nil, unitFrame)
        debuff:SetSize(size, size)
        debuff.icon = debuff:CreateTexture(nil, 'ARTWORK')
        debuff.icon:SetAllPoints(debuff)
        debuff.border = debuff:CreateTexture(nil, 'OVERLAY')
        debuff.border:SetTexture(self.textures.debuffOverlay)
        debuff.border:SetAllPoints(debuff)
        debuff.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
        debuff.timer = debuff:CreateFontString(nil, 'OVERLAY')
        debuff.timer:SetFont('Fonts\\FRIZQT__.TTF', 8, 'OUTLINE')
        debuff.timer:SetPoint('CENTER', debuff, 'CENTER', 0, 0)
        debuff.timer:Hide()
        debuff:Hide()
        unitFrame.debuffs[i] = debuff
    end

    if unit == 'player' or UnitExists(unit) then
        unitFrame:Show()
    else
        unitFrame:Hide()
    end
    table.insert(self.portraits, unitFrame)
    return unitFrame
end

-- updates
function setup:UpdatePortraitMode(frame, unit)
    local modeKey = string.find(frame.unit, 'party') and 'partyPortraitMode' or frame.unit..'PortraitMode'
    local mode = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes'][modeKey]) or '3D Model'
    if mode == '3D Model' then
        frame.model:Show()
        frame.classIcon:Hide()
        frame.portrait2D:Hide()
    elseif mode == '2D Portrait' then
        frame.model:Hide()
        frame.classIcon:Hide()
        SetPortraitTexture(frame.portrait2D, unit)
        frame.portrait2D:Show()
    else
        frame.model:Hide()
        frame.portrait2D:Hide()
        frame.classIcon:Show()
        local _, playerClass = UnitClass(unit)
        if not playerClass and unit == 'pet' then playerClass = 'WARRIOR' end
        local coords = AU.tables['classicons'][playerClass]
        if coords then frame.classIcon:SetTexCoord(coords[1], coords[2], coords[3], coords[4]) end
    end
end

function setup:UpdateUnitPortrait(frame, unit)
    frame.model.update = unit
    setup:UpdatePortraitMode(frame, unit)
end

function setup:UpdatePortraitVisibility(portraitFrame)
    local enabledKey = string.find(portraitFrame.unit, 'party') and 'partyEnabled' or portraitFrame.unit..'Enabled'
    if AU_GlobalDB and AU.profile['unitframes'] and not AU.profile['unitframes'][enabledKey] then
        portraitFrame:Hide()
        return
    end
    if portraitFrame.unit == 'player' or UnitExists(portraitFrame.unit) then
        if not portraitFrame:IsShown() then
            portraitFrame:Show()
        end
        if portraitFrame.unit ~= 'targettarget' and portraitFrame.unit ~= 'pettarget' then
            local showPortraitKey = string.find(portraitFrame.unit, 'party') and 'partyShowPortrait' or portraitFrame.unit..'ShowPortrait'
            if AU_GlobalDB and AU.profile['unitframes'] and not AU.profile['unitframes'][showPortraitKey] then
                portraitFrame.model:Hide()
                portraitFrame.portrait2D:Hide()
                portraitFrame.classIcon:Hide()
            elseif string.find(portraitFrame.unit, 'party') and (not UnitIsVisible(portraitFrame.unit) or not UnitIsConnected(portraitFrame.unit)) then
                portraitFrame.model:Hide()
                portraitFrame.classIcon:Hide()
                SetPortraitTexture(portraitFrame.portrait2D, portraitFrame.unit)
                portraitFrame.portrait2D:Show()
            elseif portraitFrame.unit == 'target' and UnitInParty('target') and not UnitIsVisible('target') then
                portraitFrame.model:Hide()
                portraitFrame.classIcon:Hide()
                SetPortraitTexture(portraitFrame.portrait2D, portraitFrame.unit)
                portraitFrame.portrait2D:Show()
            else
                portraitFrame.portrait2D:Hide()
                setup:UpdateUnitPortrait(portraitFrame, portraitFrame.unit)
            end
        end
    else
        portraitFrame:Hide()
    end
end

function setup:UpdateUnitHealth(unitFrame, instant)
    local health = UnitHealth(unitFrame.unit)
    local maxHealth = UnitHealthMax(unitFrame.unit)
    if unitFrame.lastHealth ~= health or unitFrame.lastMaxHealth ~= maxHealth then
        unitFrame.lastHealth = health
        unitFrame.lastMaxHealth = maxHealth
        unitFrame.hpBar.max = maxHealth
        if instant then
            local prevInstant = unitFrame.hpBar.instant
            unitFrame.hpBar:SetInstant(true)
            unitFrame.hpBar:SetValue(health)
            unitFrame.hpBar:SetInstant(prevInstant)
        else
            unitFrame.hpBar:SetValue(health)
        end
    end
end

function setup:UpdatePowerBarColor(unitFrame)
    local powerType = UnitPowerType(unitFrame.unit)
    if powerType == 0 then
        unitFrame.powerBar:SetFillColor(0.2, 0.4, 1, 1)
    elseif powerType == 1 then
        unitFrame.powerBar:SetFillColor(1, 0, 0, 1)
    elseif powerType == 2 then
        unitFrame.powerBar:SetFillColor(1, 0.5, 0.25, 1)
    elseif powerType == 3 then
        unitFrame.powerBar:SetFillColor(1, 1, 0, 1)
    else
        unitFrame.powerBar:SetFillColor(0.2, 0.4, 1, 1)
    end
end

function setup:UpdateUnitMana(unitFrame, instant)
    local mana = UnitMana(unitFrame.unit)
    local maxMana = UnitManaMax(unitFrame.unit)
    if unitFrame.lastMana ~= mana or unitFrame.lastMaxMana ~= maxMana then
        unitFrame.lastMana = mana
        unitFrame.lastMaxMana = maxMana
        unitFrame.powerBar.max = maxMana > 0 and maxMana or 1
        if instant then
            local prevInstant = unitFrame.powerBar.instant
            unitFrame.powerBar:SetInstant(true)
            unitFrame.powerBar:SetValue(mana)
            unitFrame.powerBar:SetInstant(prevInstant)
        else
            unitFrame.powerBar:SetValue(mana)
        end
    end
    setup:UpdatePowerBarColor(unitFrame)
end

function setup:UpdateBarText(unitFrame)
    if UnitIsDead(unitFrame.unit) or UnitIsGhost(unitFrame.unit) then
        unitFrame.hpBar.text:ClearAllPoints()
        unitFrame.hpBar.text:SetPoint('CENTER', unitFrame.hpBar, 'CENTER', 0, 0)
        unitFrame.hpBar.text:SetText('Dead')
        unitFrame.hpBar.pctText:SetText('')
        unitFrame.powerBar.text:SetText('')
        unitFrame.powerBar.pctText:SetText('')
        return
    end

    if not UnitIsConnected(unitFrame.unit) then
        unitFrame.hpBar.text:ClearAllPoints()
        unitFrame.hpBar.text:SetPoint('CENTER', unitFrame.hpBar, 'CENTER', 0, 0)
        unitFrame.hpBar.text:SetText('Offline')
        unitFrame.hpBar.pctText:SetText('')
        unitFrame.powerBar.text:SetText('')
        unitFrame.powerBar.pctText:SetText('')
        unitFrame.hpBar:SetFillColor(0.5, 0.5, 0.5, 1)
        if unitFrame.model then unitFrame.model:SetAlpha(0.4) end
        if unitFrame.portrait2D then unitFrame.portrait2D:SetAlpha(0.4) end
        if unitFrame.classIcon then unitFrame.classIcon:SetAlpha(0.4) end
        return
    end

    if unitFrame.model then unitFrame.model:SetAlpha(1) end
    if unitFrame.portrait2D then unitFrame.portrait2D:SetAlpha(1) end
    if unitFrame.classIcon then unitFrame.classIcon:SetAlpha(1) end

    local health = UnitHealth(unitFrame.unit)
    local maxHealth = UnitHealthMax(unitFrame.unit)
    local mana = UnitMana(unitFrame.unit)
    local maxMana = UnitManaMax(unitFrame.unit)
    local hpPct = maxHealth > 0 and math.floor((health / maxHealth) * 100) or 0
    local manaPct = maxMana > 0 and math.floor((mana / maxMana) * 100) or 0

    local hpFormat = unitFrame.healthTextFormat or 'cur/max'
    local manaFormat = unitFrame.manaTextFormat or 'cur/max'
    local hpAnchor = unitFrame.healthTextAnchor or 'left'
    local manaAnchor = unitFrame.manaTextAnchor or 'left'
    local isTarget = unitFrame.unit == 'target'
    local abbreviate = unitFrame.abbreviateNumbers

    local function abbrev(num)
        if not abbreviate then return tostring(num) end
        if num >= 1000000 then
            return string.format('%.1fM', num / 1000000)
        elseif num >= 1000 then
            return string.format('%.1fK', num / 1000)
        end
        return tostring(num)
    end

    if hpFormat == 'current' then
        unitFrame.hpBar.text:SetText(abbrev(health))
    elseif hpFormat == 'none' then
        unitFrame.hpBar.text:SetText('')
    else
        unitFrame.hpBar.text:SetText(abbrev(health)..'/'..abbrev(maxHealth))
    end
    unitFrame.hpBar.pctText:SetText(unitFrame.healthTextShowPercent and hpPct..'%' or '')

    if manaFormat == 'current' then
        unitFrame.powerBar.text:SetText(abbrev(mana))
    elseif manaFormat == 'none' then
        unitFrame.powerBar.text:SetText('')
    else
        unitFrame.powerBar.text:SetText(abbrev(mana)..'/'..abbrev(maxMana))
    end
    unitFrame.powerBar.pctText:SetText(unitFrame.manaTextShowPercent and manaPct..'%' or '')

    unitFrame.hpBar.text:ClearAllPoints()
    if hpAnchor == 'center' then
        unitFrame.hpBar.text:SetPoint('CENTER', unitFrame.hpBar, 'CENTER', 0, 0)
    elseif hpAnchor == 'right' then
        unitFrame.hpBar.text:SetPoint('RIGHT', unitFrame.hpBar, 'RIGHT', -3, 0)
    else
        unitFrame.hpBar.text:SetPoint('LEFT', unitFrame.hpBar, 'LEFT', 3, 0)
    end

    unitFrame.hpBar.pctText:ClearAllPoints()
    if isTarget then
        unitFrame.hpBar.pctText:SetPoint('RIGHT', unitFrame.hpBar, 'RIGHT', -3, 0)
    else
        unitFrame.hpBar.pctText:SetPoint('LEFT', unitFrame.hpBar, 'LEFT', 3, 0)
    end

    unitFrame.powerBar.text:ClearAllPoints()
    if manaAnchor == 'center' then
        unitFrame.powerBar.text:SetPoint('CENTER', unitFrame.powerBar, 'CENTER', 0, 0)
    elseif manaAnchor == 'right' then
        unitFrame.powerBar.text:SetPoint('RIGHT', unitFrame.powerBar, 'RIGHT', -3, 0)
    else
        unitFrame.powerBar.text:SetPoint('LEFT', unitFrame.powerBar, 'LEFT', 3, 0)
    end

    unitFrame.powerBar.pctText:ClearAllPoints()
    if isTarget then
        unitFrame.powerBar.pctText:SetPoint('RIGHT', unitFrame.powerBar, 'RIGHT', -3, 0)
    else
        unitFrame.powerBar.pctText:SetPoint('LEFT', unitFrame.powerBar, 'LEFT', 3, 0)
    end
end

function setup:UpdatePvPIcon(unitFrame)
    if not unitFrame.pvpIcon then return end
    local showKey = string.find(unitFrame.unit, 'party') and 'partyShowPvPIcon' or unitFrame.unit..'ShowPvPIcon'
    local show = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes'][showKey])
    if show == false then
        unitFrame.pvpIcon:Hide()
        return
    end
    unitFrame.pvpIcon:Hide()
    if UnitIsPVP(unitFrame.unit) then
        local faction = UnitFactionGroup(unitFrame.unit)
        if faction == 'Alliance' then
            unitFrame.pvpIcon:SetTexture(self.textures.pvpAlly)
        else
            unitFrame.pvpIcon:SetTexture(self.textures.pvpHorde)
        end
        unitFrame.pvpIcon:Show()
    end
end

function setup:UpdateLevelColor(unitFrame)
    local level = UnitLevel(unitFrame.unit)
    if level == -1 or level >= 63 then
        unitFrame.level:SetText('??')
        unitFrame.level:SetTextColor(1, 0, 0)
    else
        unitFrame.level:SetText(level)
        if level > 0 and UnitCanAttack('player', unitFrame.unit) then
            local color = GetDifficultyColor(level)
            unitFrame.level:SetTextColor(color.r, color.g, color.b)
        else
            unitFrame.level:SetTextColor(1, 0.82, 0)
        end
    end
end

function setup:UpdateNameText(unitFrame)
    local name = UnitName(unitFrame.unit)
    if not name then return end
    local mode = unitFrame.nameMode or 'none'
    local maxLength = unitFrame.nameMaxLength or 8
    if mode == 'initials' and string.find(name, ' ') then
        local result = ''
        for word in string.gfind(name, '%S+') do
            result = result..string.sub(word, 1, 1)..'. '
        end
        name = result
    elseif mode == 'mixed' and string.find(name, ' ') then
        local result = ''
        local first = true
        for word in string.gfind(name, '%S+') do
            if first then
                result = word..' '
                first = false
            else
                result = result..string.sub(word, 1, 1)..'. '
            end
        end
        name = result
    elseif mode == 'truncated' and string.len(name) > maxLength then
        name = string.sub(name, 1, maxLength)..'..'
    end
    unitFrame.name:SetText(name)
    setup:UpdateNameColor(unitFrame)
end

function setup:UpdateNameColor(unitFrame)
    if unitFrame.unit == 'target' or unitFrame.unit == 'targettarget' or unitFrame.unit == 'pettarget' then
        local reactionKey = string.find(unitFrame.unit, 'party') and 'partyNameReactionColoring' or unitFrame.unit..'NameReactionColoring'
        local useReaction = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes'][reactionKey])
        if useReaction then
            local reaction = UnitReaction('player', unitFrame.unit)
            if reaction and AU.tables['factioncolors'][reaction] then
                local color = AU.tables['factioncolors'][reaction]
                unitFrame.name:SetTextColor(color[1], color[2], color[3])
                return
            end
        end
    end
    local colorKey = string.find(unitFrame.unit, 'party') and 'partyNameTextColor' or unitFrame.unit..'NameTextColor'
    local color = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes'][colorKey]) or {1, 0.82, 0, 1}
    unitFrame.name:SetTextColor(color[1], color[2], color[3])
end

function setup:UpdateClassificationBorder(unitFrame)
    if unitFrame.unit ~= 'target' then return end
    if not UnitExists('target') then
        if unitFrame.classBorderOverlay then unitFrame.classBorderOverlay:Hide() end
        return
    end
    local classification = UnitClassification('target')
    if unitFrame.classBorderOverlay then unitFrame.classBorderOverlay:Hide() end
    if classification == 'worldboss' then
        unitFrame.border:SetTexture(self.textures.borderBoss)
        unitFrame.border:SetTexCoord(0.25, 0.75, 0.25, 0.75)
        if unitFrame.classBorderOverlay then
            unitFrame.classBorderOverlay:SetTexture(self.textures.borderBoss)
            unitFrame.classBorderOverlay:SetTexCoord(0.125, 0.875, 0.125, 0.875)
            unitFrame.classBorderOverlay:SetSize(unitFrame.border:GetWidth() * 1.6, unitFrame.border:GetHeight() * 1.6)
            unitFrame.classBorderOverlay:Show()
        end
    elseif classification == 'rareelite' or classification == 'rare' then
        unitFrame.border:SetTexture(self.textures.borderRare)
        unitFrame.border:SetTexCoord(0.25, 0.75, 0.25, 0.75)
        if unitFrame.classBorderOverlay then
            unitFrame.classBorderOverlay:SetTexture(self.textures.borderRare)
            unitFrame.classBorderOverlay:SetTexCoord(0.125, 0.875, 0.125, 0.875)
            unitFrame.classBorderOverlay:SetSize(unitFrame.border:GetWidth() * 1.6, unitFrame.border:GetHeight() * 1.6)
            unitFrame.classBorderOverlay:Show()
        end
    elseif classification == 'elite' then
        unitFrame.border:SetTexture(self.textures.borderElite)
        unitFrame.border:SetTexCoord(0.25, 0.75, 0.25, 0.75)
        if unitFrame.classBorderOverlay then
            unitFrame.classBorderOverlay:SetTexture(self.textures.borderElite)
            unitFrame.classBorderOverlay:SetTexCoord(0.125, 0.875, 0.125, 0.875)
            unitFrame.classBorderOverlay:SetSize(unitFrame.border:GetWidth() * 1.6, unitFrame.border:GetHeight() * 1.6)
            unitFrame.classBorderOverlay:Show()
        end
    else
        unitFrame.border:SetTexture(self.textures.portraitBorder)
        local flipKey = 'targetFlipPortraitBorder'
        local shouldFlip = AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes'][flipKey]
        if shouldFlip then
            unitFrame.border:SetTexCoord(1, 0, 0, 1)
        else
            unitFrame.border:SetTexCoord(0, 1, 0, 1)
        end
        if unitFrame.classBorderOverlay then unitFrame.classBorderOverlay:Hide() end
    end
end

function setup:UpdateBarTextNumbers(unitFrame)
    if not unitFrame.abbreviateNumbers then return end
    local health = UnitHealth(unitFrame.unit)
    local maxHealth = UnitHealthMax(unitFrame.unit)
    local mana = UnitMana(unitFrame.unit)
    local maxMana = UnitManaMax(unitFrame.unit)
    local function abbrev(num)
        if num >= 1000000 then
            return string.format('%.1fM', num / 1000000)
        elseif num >= 1000 then
            return string.format('%.1fK', num / 1000)
        end
        return tostring(num)
    end
    unitFrame.hpBar.text:SetText(abbrev(health)..'/'..abbrev(maxHealth))
    unitFrame.powerBar.text:SetText(abbrev(mana)..'/'..abbrev(maxMana))
end

function setup:UpdateHealthBarColor(portrait, unit)
    local modeKey = string.find(portrait.unit, 'party') and 'partyHealthBarColorMode' or portrait.unit..'HealthBarColorMode'
    local mode = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes'][modeKey]) or 'class'
    if mode == 'custom' then
        local colorKey = string.find(portrait.unit, 'party') and 'partyHealthBarCustomColor' or portrait.unit..'HealthBarCustomColor'
        local color = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes'][colorKey]) or {0, 1, 0}
        portrait.hpBar:SetFillColor(color[1], color[2], color[3], 1)
        return
    end
    if mode == 'mirror' and portrait.unit == 'player' then
        portrait.hpBar:SetFillColor(setup.lastTargetColor[1], setup.lastTargetColor[2], setup.lastTargetColor[3], 1)
        return
    end
    if mode == 'reaction' then
        local reaction = UnitReaction(unit, 'player')
        if reaction and AU.tables['factioncolors'][reaction] then
            local color = AU.tables['factioncolors'][reaction]
            portrait.hpBar:SetFillColor(color[1], color[2], color[3], 1)
            return
        end
    end
    local _, class = UnitClass(unit)
    if class and AU.tables['classcolors'][class] and UnitIsPlayer(unit) then
        local color = AU.tables['classcolors'][class]
        portrait.hpBar:SetFillColor(color[1], color[2], color[3], 1)
    else
        local reaction = UnitReaction(unit, 'player')
        if reaction and AU.tables['factioncolors'][reaction] then
            local color = AU.tables['factioncolors'][reaction]
            portrait.hpBar:SetFillColor(color[1], color[2], color[3], 1)
        end
    end

end

function setup:UpdateBuffs(unitFrame)
    local anchor = unitFrame.buffAnchor or 'below'
    if anchor == 'Disabled' then
        for i = 1, 16 do
            unitFrame.buffs[i]:Hide()
        end
        return 0
    end
    local isRight = unitFrame.unit == 'target'
    local xBase = 0
    local yBase = -3
    local visibleBuffs = 0

    for i = 1, 16 do
        local texture = UnitBuff(unitFrame.unit, i)
        if texture then
            unitFrame.buffs[i].icon:SetTexture(texture)
            unitFrame.buffs[i]:Show()
            local row = math.floor((i - 1) / 5)
            local col = math.mod(i - 1, 5)
            unitFrame.buffs[i]:ClearAllPoints()
            if anchor == 'below' then
                if isRight then
                    unitFrame.buffs[i]:SetPoint('TOPLEFT', unitFrame.powerBar, 'BOTTOMLEFT', col * 22 + xBase, -row * 22 + yBase)
                else
                    unitFrame.buffs[i]:SetPoint('TOPRIGHT', unitFrame.powerBar, 'BOTTOMRIGHT', -col * 22 + xBase, -row * 22 + yBase)
                end
            else
                if isRight then
                    unitFrame.buffs[i]:SetPoint('BOTTOMLEFT', unitFrame.infoBg, 'TOPLEFT', col * 22 + xBase, row * 22 - yBase)
                else
                    unitFrame.buffs[i]:SetPoint('BOTTOMRIGHT', unitFrame.infoBg, 'TOPRIGHT', -col * 22 + xBase, row * 22 - yBase)
                end
            end
            visibleBuffs = visibleBuffs + 1
        else
            unitFrame.buffs[i]:Hide()
        end
    end
    return visibleBuffs
end

function setup:UpdateDebuffs(unitFrame, buffRows)
    local anchor = unitFrame.debuffAnchor or 'below'
    if anchor == 'Disabled' then
        for i = 1, 16 do
            unitFrame.debuffs[i]:Hide()
        end
        return
    end
    local buffAnchor = unitFrame.buffAnchor or 'below'
    local isRight = unitFrame.unit == 'target'
    local xBase = 0
    local yBase = -3
    local offsetRows = 0
    if anchor == buffAnchor and buffAnchor ~= 'Disabled' then
        offsetRows = buffRows
    end
    local showTimerKey = string.find(unitFrame.unit, 'party') and 'partyShowDebuffTimer' or unitFrame.unit..'ShowDebuffTimer'
    local showTimer = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes'][showTimerKey])

    for i = 1, 16 do
        local texture, stacks, debuffType = UnitDebuff(unitFrame.unit, i)
        if texture then
            unitFrame.debuffs[i].icon:SetTexture(texture)
            if debuffType == 'Magic' then
                unitFrame.debuffs[i].border:SetVertexColor(0.2, 0.6, 1)
            elseif debuffType == 'Disease' then
                unitFrame.debuffs[i].border:SetVertexColor(0.6, 0.4, 0)
            elseif debuffType == 'Poison' then
                unitFrame.debuffs[i].border:SetVertexColor(0, 0.6, 0)
            elseif debuffType == 'Curse' then
                unitFrame.debuffs[i].border:SetVertexColor(0.6, 0, 1)
            else
                unitFrame.debuffs[i].border:SetVertexColor(0.8, 0, 0)
            end
            if showTimer and AU.lib.libdebuff then
                local _, _, _, _, _, duration, timeleft = AU.lib.libdebuff:UnitDebuff(unitFrame.unit, i)
                if timeleft and timeleft > 0 then
                    local timeText
                    if timeleft >= 3600 then
                        timeText = string.format('%d|cffff0000h|r', timeleft / 3600)
                    elseif timeleft >= 60 then
                        timeText = string.format('%d|cffff0000m|r', timeleft / 60)
                    else
                        timeText = string.format('%d|cffff0000s|r', timeleft)
                    end
                    unitFrame.debuffs[i].timer:SetText(timeText)
                    unitFrame.debuffs[i].timer:Show()
                else
                    unitFrame.debuffs[i].timer:Hide()
                end
            else
                unitFrame.debuffs[i].timer:Hide()
            end
            unitFrame.debuffs[i]:Show()
            local row = math.floor((i - 1) / 5)
            local col = math.mod(i - 1, 5)
            unitFrame.debuffs[i]:ClearAllPoints()

            if anchor == 'below' then
                if isRight then
                    unitFrame.debuffs[i]:SetPoint('TOPLEFT', unitFrame.powerBar, 'BOTTOMLEFT', col * 22 + xBase, -offsetRows * 22 - row * 22 + yBase)
                else
                    unitFrame.debuffs[i]:SetPoint('TOPRIGHT', unitFrame.powerBar, 'BOTTOMRIGHT', -col * 22 + xBase, -offsetRows * 22 - row * 22 + yBase)
                end
            else
                if isRight then
                    unitFrame.debuffs[i]:SetPoint('BOTTOMLEFT', unitFrame.infoBg, 'TOPLEFT', col * 22 + xBase, offsetRows * 22 + row * 22 - yBase)
                else
                    unitFrame.debuffs[i]:SetPoint('BOTTOMRIGHT', unitFrame.infoBg, 'TOPRIGHT', -col * 22 + xBase, offsetRows * 22 + row * 22 - yBase)
                end
            end
        else
            unitFrame.debuffs[i]:Hide()
        end
    end
end

function setup:UpdateCombatGlow(unitFrame)
    if not unitFrame.model.combatGlow then return end
    local mode = unitFrame.combatGlowMode or 'Both'
    local inCombat = UnitAffectingCombat(unitFrame.unit)
    if mode == 'Both' then
        if inCombat then unitFrame.model.combatGlow:Show() else unitFrame.model.combatGlow:Hide() end
        if inCombat then unitFrame.model.combatGlow2:Show() else unitFrame.model.combatGlow2:Hide() end
    elseif mode == 'Portrait Only' then
        if inCombat then unitFrame.model.combatGlow:Show() else unitFrame.model.combatGlow:Hide() end
        unitFrame.model.combatGlow2:Hide()
    elseif mode == 'Bar Only' then
        unitFrame.model.combatGlow:Hide()
        if inCombat then unitFrame.model.combatGlow2:Show() else unitFrame.model.combatGlow2:Hide() end
    else
        unitFrame.model.combatGlow:Hide()
        unitFrame.model.combatGlow2:Hide()
    end
end

function setup:UpdateRestingGlow(unitFrame)
    if not unitFrame.model.restingGlow then return end
    local mode = unitFrame.restingGlowMode or 'Both'
    local isResting = IsResting()
    if mode == 'Both' then
        if isResting then unitFrame.model.restingGlow:Show() else unitFrame.model.restingGlow:Hide() end
        if isResting then unitFrame.model.restingGlow2:Show() else unitFrame.model.restingGlow2:Hide() end
    elseif mode == 'Portrait Only' then
        if isResting then unitFrame.model.restingGlow:Show() else unitFrame.model.restingGlow:Hide() end
        unitFrame.model.restingGlow2:Hide()
    elseif mode == 'Bar Only' then
        unitFrame.model.restingGlow:Hide()
        if isResting then unitFrame.model.restingGlow2:Show() else unitFrame.model.restingGlow2:Hide() end
    else
        unitFrame.model.restingGlow:Hide()
        unitFrame.model.restingGlow2:Hide()
    end
    if unitFrame.restingZZZ then
        if isResting and unitFrame.restingZZZ.enabled ~= false then
            unitFrame.restingZZZ:Show()
        else
            unitFrame.restingZZZ:Hide()
        end
    end
end

function setup:UpdateEnergyTick(unitFrame, event, arg1)
    local tick = unitFrame.powerBar.energyTick
    if not tick then return end
    local powerType = UnitPowerType('player')
    if powerType == 0 then
        tick.mode = 'MANA'
        if tick.enabled ~= false then
            tick:Show()
        end
    elseif powerType == 3 then
        tick.mode = 'ENERGY'
        if tick.enabled ~= false then
            tick:Show()
        end
    else
        tick:Hide()
        return
    end
    if event == 'PLAYER_ENTERING_WORLD' then
        tick.lastMana = UnitMana('player')
        if tick.mode == 'MANA' then
            tick.target = 5
        elseif tick.mode == 'ENERGY' then
            tick.target = 2
        end
        tick.elapsed = 0
    end
    if (event == 'UNIT_MANA' or event == 'UNIT_ENERGY') and arg1 == 'player' then
        tick.currentMana = UnitMana('player')
        local diff = 0
        if tick.lastMana then
            diff = tick.currentMana - tick.lastMana
        end
        if tick.mode == 'MANA' and diff < 0 then
            tick.target = 5
            tick.elapsed = 0
        elseif tick.mode == 'MANA' and diff > 0 then
            if tick.max ~= 5 and diff > (tick.badtick and tick.badtick*1.2 or 5) then
                tick.target = 2
                tick.elapsed = 0
            else
                tick.badtick = diff
            end
        elseif tick.mode == 'ENERGY' and diff > 0 then
            tick.target = 2
            tick.elapsed = 0
        end
        tick.lastMana = tick.currentMana
    end
end

function setup:OnUpdate()
    self.updater:SetScript('OnUpdate', function()
        for i = 1, table.getn(setup.portraitModels) do
            local model = setup.portraitModels[i]
            if model.update then
                model.delay = (model.delay or 0) + 1
                if model.delay > 2 then
                    model:SetUnit(model.update)
                    model:SetCamera(0)
                    model.update = nil
                    model.delay = 0
                end
            elseif model:IsShown() and model.unit and UnitExists(model.unit) then
                model.cameraCheck = (model.cameraCheck or 0) + arg1
                if model.cameraCheck > 0.5 then
                    model:SetCamera(0)
                    model.cameraCheck = 0
                end
            end
        end
        setup.combatGlowElapsed = setup.combatGlowElapsed + arg1
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if UnitExists(portrait.unit) then
                setup:UpdateCombatGlow(portrait)
            end
            if portrait.unit == 'targettarget' or portrait.unit == 'pettarget' or string.find(portrait.unit, 'party') then
                portrait.tick = (portrait.tick or 0) + arg1
                if portrait.tick >= 0.2 then
                    portrait.tick = 0
                    if portrait.unit == 'pettarget' and (not UnitExists('pet') or not UnitIsVisible('pettarget')) then
                        portrait:Hide()
                    elseif string.find(portrait.unit, 'party') then
                        if not AU.profile['unitframes']['partyEnabled'] then
                            portrait:Hide()
                        elseif UnitExists(portrait.unit) then
                            if not AU.profile['unitframes']['partyShowPortrait'] then
                                portrait.model:Hide()
                                portrait.portrait2D:Hide()
                            elseif not UnitIsVisible(portrait.unit) or not UnitIsConnected(portrait.unit) then
                                portrait.model:Hide()
                                SetPortraitTexture(portrait.portrait2D, portrait.unit)
                                portrait.portrait2D:Show()
                            else
                                portrait.portrait2D:Hide()
                                portrait.model:Show()
                                local name = UnitName(portrait.unit)
                                if portrait.model.lastUnit ~= name then
                                    portrait.model.update = portrait.unit
                                    portrait.model.lastUnit = name
                                end
                            end
                            portrait.hpBar.max = UnitHealthMax(portrait.unit)
                            portrait.hpBar:SetValue(UnitHealth(portrait.unit))
                            portrait.powerBar.max = UnitManaMax(portrait.unit)
                            portrait.powerBar:SetValue(UnitMana(portrait.unit))
                            setup:UpdateHealthBarColor(portrait, portrait.unit)
                            setup:UpdateNameText(portrait)
                            setup:UpdateLevelColor(portrait)
                            setup:UpdatePvPIcon(portrait)
                            setup:UpdateBarText(portrait)
                            setup:UpdateBarTextNumbers(portrait)
                            local visibleBuffs = setup:UpdateBuffs(portrait)
                            setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
                            portrait:Show()
                        else
                            portrait:Hide()
                        end
                    else
                        local name = UnitName(portrait.unit)
                        if name ~= portrait.namebuf1 then
                            portrait.namebuf1 = name
                            if UnitExists(portrait.unit) then
                                portrait.hpBar.max = UnitHealthMax(portrait.unit)
                                portrait.powerBar.max = UnitManaMax(portrait.unit) > 0 and UnitManaMax(portrait.unit) or 1
                            end
                        elseif name ~= portrait.namebuf2 then
                            portrait.namebuf2 = name
                        else
                            setup:UpdatePortraitVisibility(portrait)
                            if UnitExists(portrait.unit) and UnitIsConnected(portrait.unit) then
                                local isNewTarget = portrait.model.lastUnit ~= name
                                if isNewTarget then
                                    portrait.model.update = portrait.unit
                                    portrait.model.lastUnit = name
                                end
                                setup:UpdateUnitHealth(portrait, isNewTarget)
                                setup:UpdateUnitMana(portrait, isNewTarget)
                                setup:UpdateHealthBarColor(portrait, portrait.unit)
                                setup:UpdateNameText(portrait)
                                setup:UpdateLevelColor(portrait)
                                setup:UpdatePvPIcon(portrait)
                                setup:UpdateBarText(portrait)
                                setup:UpdateBarTextNumbers(portrait)
                                local visibleBuffs = setup:UpdateBuffs(portrait)
                                setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
                            end
                        end
                    end
                end
            end
            if portrait.model.restingGlow and (portrait.model.restingGlow:IsShown() or portrait.model.restingGlow2:IsShown()) then
                portrait.model.restingGlow.elapsed = portrait.model.restingGlow.elapsed + arg1
                local alpha = (math.sin(portrait.model.restingGlow.elapsed * 3) + 1) / 2
                portrait.model.restingGlow:SetAlpha(alpha * (portrait.restingGlowMaxAlpha or 0.7))
                portrait.model.restingGlow2:SetAlpha(alpha * (portrait.restingGlow2MaxAlpha or 0.7))
            end
            if portrait.model.combatGlow and (portrait.model.combatGlow:IsShown() or portrait.model.combatGlow2:IsShown()) then
                local alpha = (math.sin(setup.combatGlowElapsed * 3) + 1) / 2
                portrait.model.combatGlow:SetAlpha(alpha * (portrait.combatGlowMaxAlpha or 0.7))
                portrait.model.combatGlow2:SetAlpha(alpha * (portrait.combatGlow2MaxAlpha or 0.7))
            end
            if portrait.unit == 'player' and portrait.powerBar.energyTick and portrait.powerBar.energyTick:IsShown() and portrait.powerBar.energyTick.target then
                local tick = portrait.powerBar.energyTick
                tick.elapsed = (tick.elapsed or 0) + arg1
                if tick.elapsed > tick.target then
                    tick.elapsed = 0
                end
                local progress = tick.elapsed / tick.target
                tick.spark:SetPoint('CENTER', portrait.powerBar, 'LEFT', progress * portrait.powerBar:GetWidth(), 0)
            end
            if portrait.restingZZZ and portrait.restingZZZ:IsShown() then
                portrait.restingZZZ.elapsed = portrait.restingZZZ.elapsed + arg1
                if portrait.restingZZZ.elapsed >= 0.05 then
                    portrait.restingZZZ.currentFrame = portrait.restingZZZ.currentFrame + 1
                    if portrait.restingZZZ.currentFrame > 36 then portrait.restingZZZ.currentFrame = 1 end
                    local c = setup.zzzCoords[portrait.restingZZZ.currentFrame]
                    portrait.restingZZZ.tex:SetTexCoord(c[1], c[2], c[3], c[4])
                    portrait.restingZZZ.elapsed = 0
                end
            end
            local showTimerKey = string.find(portrait.unit, 'party') and 'partyShowDebuffTimer' or portrait.unit..'ShowDebuffTimer'
            if AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes'][showTimerKey] and AU.lib.libdebuff then
                for k = 1, 16 do
                    if portrait.debuffs[k]:IsShown() then
                        local _, _, _, _, _, duration, timeleft = AU.lib.libdebuff:UnitDebuff(portrait.unit, k)
                        if timeleft and timeleft > 0 then
                            local timeText
                            if timeleft >= 3600 then
                                timeText = string.format('%d|cffff0000h|r', timeleft / 3600)
                            elseif timeleft >= 60 then
                                timeText = string.format('%d|cffff0000m|r', timeleft / 60)
                            else
                                timeText = string.format('%d|cffff0000s|r', timeleft)
                            end
                            portrait.debuffs[k].timer:SetText(timeText)
                            portrait.debuffs[k].timer:Show()
                        else
                            portrait.debuffs[k].timer:Hide()
                        end
                    end
                end
            end
        end
    end)
end

-- event
function setup:OnEvent()
    self.eventFrame = CreateFrame'Frame'
    self.eventFrame:RegisterEvent'PLAYER_ENTERING_WORLD'
    self.eventFrame:RegisterEvent'PLAYER_TARGET_CHANGED'
    self.eventFrame:RegisterEvent'UNIT_HEALTH'
    self.eventFrame:RegisterEvent'UNIT_MANA'
    self.eventFrame:RegisterEvent'UNIT_RAGE'
    self.eventFrame:RegisterEvent'UNIT_ENERGY'
    self.eventFrame:RegisterEvent'UNIT_FOCUS'
    self.eventFrame:RegisterEvent'UNIT_FACTION'
    self.eventFrame:RegisterEvent'UNIT_AURA'
    self.eventFrame:RegisterEvent'PLAYER_UPDATE_RESTING'
    self.eventFrame:RegisterEvent'PLAYER_REGEN_DISABLED'
    self.eventFrame:RegisterEvent'PLAYER_REGEN_ENABLED'
    self.eventFrame:RegisterEvent'UNIT_DISPLAYPOWER'
    self.eventFrame:RegisterEvent'UNIT_PET'
    self.eventFrame:RegisterEvent'UNIT_HAPPINESS'
    self.eventFrame:RegisterEvent'PARTY_MEMBERS_CHANGED'
    self.eventFrame:RegisterEvent'PARTY_MEMBER_ENABLE'
    self.eventFrame:RegisterEvent'PARTY_MEMBER_DISABLE'
    self.eventFrame:RegisterEvent'PARTY_LEADER_CHANGED'
    self.eventFrame:RegisterEvent'PARTY_LOOT_METHOD_CHANGED'
    self.eventFrame:RegisterEvent'RAID_ROSTER_UPDATE'
    self.eventFrame:RegisterEvent'PLAYER_LEVEL_UP'
    self.eventFrame:RegisterEvent'UNIT_LEVEL'
    self.eventFrame:SetScript('OnEvent', function()
    if event == 'PLAYER_TARGET_CHANGED' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if portrait.unit == 'targettarget' then
                portrait.namebuf1 = nil
                portrait.namebuf2 = nil
                portrait.model.lastUnit = nil
            elseif portrait.unit == 'target' then
                if UnitExists('target') then
                    if UnitIsEnemy('target', 'player') then
                        PlaySound('igCreatureAggroSelect')
                    elseif UnitIsFriend('player', 'target') then
                        PlaySound('igCharacterNPCSelect')
                    else
                        PlaySound('igCreatureNeutralSelect')
                    end
                    local targetMode = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes']['targetHealthBarColorMode']) or 'class'
                    if targetMode == 'custom' then
                        local color = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes']['targetHealthBarCustomColor']) or {0, 1, 0}
                        setup.lastTargetColor = {color[1], color[2], color[3]}
                    elseif targetMode == 'reaction' then
                        local reaction = UnitReaction('target', 'player')
                        if reaction and AU.tables['factioncolors'][reaction] then
                            local color = AU.tables['factioncolors'][reaction]
                            setup.lastTargetColor = {color[1], color[2], color[3]}
                        end
                    else
                        local _, class = UnitClass('target')
                        if class and AU.tables['classcolors'][class] then
                            local color = AU.tables['classcolors'][class]
                            setup.lastTargetColor = {color[1], color[2], color[3]}
                        end
                    end

                else
                    PlaySound('INTERFACESOUND_LOSTTARGETUNIT')
                end
                setup:UpdatePortraitVisibility(portrait)
                setup:UpdateClassificationBorder(portrait)
                setup:UpdateUnitHealth(portrait, true)
                setup:UpdateUnitMana(portrait, true)
                setup:UpdateHealthBarColor(portrait, portrait.unit)
                setup:UpdateNameText(portrait)
                setup:UpdateLevelColor(portrait)
                setup:UpdatePvPIcon(portrait)
                setup:UpdateBarText(portrait)
                setup:UpdateBarTextNumbers(portrait)
                local visibleBuffs = setup:UpdateBuffs(portrait)
                setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
                for k = 1, table.getn(setup.portraits) do
                    if setup.portraits[k].unit == 'player' then
                        local playerMode = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes']['playerHealthBarColorMode']) or 'class'
                        if playerMode == 'mirror' then
                            setup:UpdateHealthBarColor(setup.portraits[k], 'player')
                        end
                        break
                    end
                end
            end
        end
    elseif event == 'PLAYER_ENTERING_WORLD' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            portrait.hpBar.max = UnitHealthMax(portrait.unit)
            portrait.hpBar:SetValue(UnitHealth(portrait.unit))
            portrait.powerBar.max = UnitManaMax(portrait.unit)
            portrait.powerBar:SetValue(UnitMana(portrait.unit))
            setup:UpdatePowerBarColor(portrait)
            setup:UpdateHealthBarColor(portrait, portrait.unit)
            setup:UpdateNameText(portrait)
            setup:UpdateLevelColor(portrait)
            setup:UpdatePvPIcon(portrait)
            setup:UpdateBarText(portrait)
            setup:UpdateBarTextNumbers(portrait)
            local visibleBuffs = setup:UpdateBuffs(portrait)
            setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
            setup:UpdateCombatGlow(portrait)
            if portrait.unit == 'player' then
                setup:UpdateRestingGlow(portrait)
                setup:UpdateEnergyTick(portrait, event, arg1)
            end
        end
    elseif event == 'UNIT_HEALTH' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if arg1 == portrait.unit then
                portrait.hpBar.max = UnitHealthMax(portrait.unit)
                portrait.hpBar:SetValue(UnitHealth(portrait.unit))
                setup:UpdateHealthBarColor(portrait, portrait.unit)
                setup:UpdateBarText(portrait)
            end
        end
    elseif event == 'UNIT_MANA' or event == 'UNIT_RAGE' or event == 'UNIT_ENERGY' or event == 'UNIT_FOCUS' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if arg1 == portrait.unit then
                if portrait.unit == 'player' and (event == 'UNIT_MANA' or event == 'UNIT_ENERGY') then
                    setup:UpdateEnergyTick(portrait, event, arg1)
                end
                portrait.powerBar.max = UnitManaMax(portrait.unit)
                portrait.powerBar:SetValue(UnitMana(portrait.unit))
                setup:UpdatePowerBarColor(portrait)
                setup:UpdateBarText(portrait)
            end
        end
    elseif event == 'UNIT_FACTION' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if arg1 == portrait.unit then
                setup:UpdatePvPIcon(portrait)
            end
        end
    elseif event == 'UNIT_AURA' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if arg1 == portrait.unit then
                local visibleBuffs = setup:UpdateBuffs(portrait)
                setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
            end
        end
    elseif event == 'PLAYER_UPDATE_RESTING' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if portrait.unit == 'player' then
                setup:UpdateRestingGlow(portrait)
            end
        end
    elseif event == 'PLAYER_REGEN_DISABLED' or event == 'PLAYER_REGEN_ENABLED' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            setup:UpdateCombatGlow(portrait)
        end
    elseif event == 'UNIT_DISPLAYPOWER' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if arg1 == portrait.unit then
                portrait.model.update = portrait.unit
                if portrait.unit == 'player' then
                    setup:UpdateEnergyTick(portrait, event, arg1)
                end
                setup:UpdatePowerBarColor(portrait)
            end
        end
    elseif event == 'UNIT_PET' or event == 'UNIT_HAPPINESS' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if portrait.unit == 'pet' then
                setup:UpdatePortraitVisibility(portrait)
                if UnitExists('pet') then
                    portrait.hpBar.max = UnitHealthMax('pet')
                    portrait.hpBar:SetValue(UnitHealth('pet'))
                    portrait.powerBar.max = UnitManaMax('pet')
                    portrait.powerBar:SetValue(UnitMana('pet'))
                    setup:UpdateHealthBarColor(portrait, 'pet')
                    setup:UpdateNameText(portrait)
                    setup:UpdateLevelColor(portrait)
                    setup:UpdateBarText(portrait)
                    setup:UpdateBarTextNumbers(portrait)
                    if portrait.happinessIcon then
                        local _, class = UnitClass('player')
                        if class == 'HUNTER' then
                            local happiness = GetPetHappiness()
                            if happiness == 1 then
                                portrait.happinessIcon.fill:SetVertexColor(1, 0, 0)
                            elseif happiness == 2 then
                                portrait.happinessIcon.fill:SetVertexColor(1, 1, 0)
                            elseif happiness == 3 then
                                portrait.happinessIcon.fill:SetVertexColor(0, 1, 0)
                            end
                            portrait.happinessIcon:Show()
                        else
                            portrait.happinessIcon:Hide()
                        end
                    end
                end
            end
        end
    elseif event == 'PLAYER_LEVEL_UP' or event == 'UNIT_LEVEL' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if UnitExists(portrait.unit) then
                setup:UpdateLevelColor(portrait)
            end
        end
    elseif event == 'PARTY_MEMBERS_CHANGED' or event == 'PARTY_MEMBER_ENABLE' or event == 'PARTY_MEMBER_DISABLE' or event == 'PARTY_LEADER_CHANGED' or event == 'PARTY_LOOT_METHOD_CHANGED' or event == 'RAID_ROSTER_UPDATE' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if string.find(portrait.unit, 'party') then
                if not AU.profile['unitframes']['partyEnabled'] then
                    portrait:Hide()
                elseif UnitInRaid('player') then
                    portrait:Hide()
                else
                    setup:UpdatePortraitVisibility(portrait)
                    if UnitExists(portrait.unit) then
                        portrait.hpBar.max = UnitHealthMax(portrait.unit)
                        portrait.hpBar:SetValue(UnitHealth(portrait.unit))
                        portrait.powerBar.max = UnitManaMax(portrait.unit)
                        portrait.powerBar:SetValue(UnitMana(portrait.unit))
                        setup:UpdateHealthBarColor(portrait, portrait.unit)
                        setup:UpdateNameText(portrait)
                        setup:UpdateLevelColor(portrait)
                        setup:UpdatePvPIcon(portrait)
                        setup:UpdateBarText(portrait)
                        setup:UpdateBarTextNumbers(portrait)
                        local visibleBuffs = setup:UpdateBuffs(portrait)
                        setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
                    end
                end
            end
        end
    end
    end)
end

-- init
function setup:GenerateDefaults()
    local frames = {
        {key = 'player', name = 'Player'},
        {key = 'target', name = 'Target'},
        {key = 'targettarget', name = 'Target of Target'},
        {key = 'pet', name = 'Pet'},
        {key = 'pettarget', name = 'Pet Target'},
        {key = 'party', name = 'Party Frames'}
    }

    local defaults = {
        enabled = {value = true},
        version = {value = '1.0'},
        gui = {}
    }

    for i = 1, table.getn(frames) do
        local frame = frames[i]
        local catGeneral = frame.name..' General'
        local catHealthBar = frame.name..' Health Bar'
        local catPowerBar = frame.name..' Power Bar'
        local catBuffsDebuffs = frame.name..' Buffs & Debuffs'
        local catEffects = frame.name..' Effects & Icons'
        table.insert(defaults.gui, {tab = 'unitframes', subtab = frame.key, catGeneral, catHealthBar, catPowerBar, catBuffsDebuffs, catEffects})
        defaults[frame.key..'Enabled'] = {value = true, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 1, description = 'Show or hide the '..frame.name..' frame'}}
        defaults[frame.key..'Scale'] = {value = 1, metadata = {element = 'slider', category = catGeneral, indexInCategory = 2, description = 'Frame scale', min = 0.5, max = 2, step = 0.05, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ShowPortrait'] = {value = true, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 3, description = 'Show or hide the portrait', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'PortraitMode'] = {value = '3D Model', metadata = {element = 'dropdown', category = catGeneral, indexInCategory = 4, description = 'Portrait display mode', options = {'3D Model', '2D Portrait', 'Class Icon'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'PortraitSize'] = {value = 80, metadata = {element = 'slider', category = catGeneral, indexInCategory = 5, description = 'Portrait size', min = 40, max = 120, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ShowLevel'] = {value = true, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 6, description = 'Show level text', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ShowName'] = {value = true, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 7, description = 'Show name text', dependency = {key = frame.key..'Enabled', state = true}}}
        if frame.key ~= 'player' then
            defaults[frame.key..'NameAbbreviation'] = {value = 'truncated', metadata = {element = 'dropdown', category = catGeneral, indexInCategory = 8, description = 'Name abbreviation mode', options = {'none', 'initials', 'truncated'}, dependency = {key = frame.key..'Enabled', state = true}}}
            defaults[frame.key..'NameMaxLength'] = {value = 14, metadata = {element = 'slider', category = catGeneral, indexInCategory = 9, description = 'Max name length (truncated mode)', min = 3, max = 20, step = 1, dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'NameAbbreviation', state = 'truncated'}}}}
        end
        defaults[frame.key..'InfoBgWidth'] = {value = 120, metadata = {element = 'slider', category = catGeneral, indexInCategory = 10, description = 'Name bar width', min = 60, max = 300, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'InfoBgHeight'] = {value = 16, metadata = {element = 'slider', category = catGeneral, indexInCategory = 11, description = 'Name bar height', min = 8, max = 30, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarWidth'] = {value = 120, metadata = {element = 'slider', category = catHealthBar, indexInCategory = 1, description = 'Health bar width', min = 60, max = 300, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarHeight'] = {value = 20, metadata = {element = 'slider', category = catHealthBar, indexInCategory = 2, description = 'Health bar height', min = 10, max = 50, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarTexture'] = {value = 'aurora_hpbar', metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 3, description = 'Health bar texture', options = {'aurora_hpbar', 'aurora_hpbar_sharp', 'aurora_hpbar_reversed', 'aurora_hpbar_sharp_reversed', 'white8x8'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarFillDirection'] = {value = (frame.key == 'target') and 'RIGHT_TO_LEFT' or 'LEFT_TO_RIGHT', metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 4, description = 'Health bar fill direction', options = {'LEFT_TO_RIGHT', 'RIGHT_TO_LEFT'}, dependency = {key = frame.key..'Enabled', state = true}}}
        local colorModeOptions = (frame.key == 'player') and {'class', 'reaction', 'custom', 'mirror'} or {'class', 'reaction', 'custom'}
        defaults[frame.key..'HealthBarColorMode'] = {value = 'class', metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 5, description = 'Health bar color mode', options = colorModeOptions, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarCustomColor'] = {value = {0, 1, 0}, metadata = {element = 'colorpicker', category = catHealthBar, indexInCategory = 6, description = 'Custom health bar color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'HealthBarColorMode', state = 'custom'}}}}
        defaults[frame.key..'HealthBarSmoothTransition'] = {value = true, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 7, description = 'Smooth health bar transition', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarEnablePulse'] = {value = false, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 8, description = 'Enable health bar pulse', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarPulseColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catHealthBar, indexInCategory = 9, description = 'Health bar pulse color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'HealthBarEnablePulse', state = true}}}}
        defaults[frame.key..'HealthBarEnableCutout'] = {value = false, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 10, description = 'Enable health bar cutout', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarCutoutColor'] = {value = {1, 0.2, 0.2, 1}, metadata = {element = 'colorpicker', category = catHealthBar, indexInCategory = 11, description = 'Health bar cutout color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'HealthBarEnableCutout', state = true}}}}
        defaults[frame.key..'ShowHealthText'] = {value = true, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 12, description = 'Show health text', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextFormat'] = {value = 'cur/max', metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 13, description = 'Health text format', options = {'current', 'cur/max', 'none'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextShowPercent'] = {value = false, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 14, description = 'Show health percentage', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextAbbreviate'] = {value = false, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 15, description = 'Abbreviate health numbers', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextAnchor'] = {value = 'left', metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 16, description = 'Health text anchor', options = {'left', 'center', 'right'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextFont'] = {value = 'font:FRIZQT__.TTF', metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 17, description = 'Health text font', options = media.fonts, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextSize'] = {value = 10, metadata = {element = 'slider', category = catHealthBar, indexInCategory = 18, description = 'Health text size', min = 6, max = 20, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catHealthBar, indexInCategory = 19, description = 'Health text color', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthPercentTextFont'] = {value = 'font:FRIZQT__.TTF', metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 20, description = 'Health percent text font', options = media.fonts, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthPercentTextSize'] = {value = 10, metadata = {element = 'slider', category = catHealthBar, indexInCategory = 21, description = 'Health percent text size', min = 6, max = 20, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthPercentTextColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catHealthBar, indexInCategory = 22, description = 'Health percent text color', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'LevelTextFont'] = {value = 'font:FRIZQT__.TTF', metadata = {element = 'dropdown', category = catGeneral, indexInCategory = 12, description = 'Level text font', options = media.fonts, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'LevelTextSize'] = {value = 10, metadata = {element = 'slider', category = catGeneral, indexInCategory = 13, description = 'Level text size', min = 6, max = 20, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'NameTextFont'] = {value = 'font:FRIZQT__.TTF', metadata = {element = 'dropdown', category = catGeneral, indexInCategory = 14, description = 'Name text font', options = media.fonts, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'NameTextSize'] = {value = 10, metadata = {element = 'slider', category = catGeneral, indexInCategory = 15, description = 'Name text size', min = 6, max = 20, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'NameTextColor'] = {value = {1, 0.82, 0, 1}, metadata = {element = 'colorpicker', category = catGeneral, indexInCategory = 16, description = 'Name text color', dependency = {key = frame.key..'Enabled', state = true}}}
        if frame.key == 'target' or frame.key == 'targettarget' or frame.key == 'pettarget' then
            defaults[frame.key..'NameReactionColoring'] = {value = false, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 17, description = 'Use reaction coloring for name', dependency = {key = frame.key..'Enabled', state = true}}}
        end
        defaults[frame.key..'ManaBarWidth'] = {value = 120, metadata = {element = 'slider', category = catPowerBar, indexInCategory = 1, description = 'Power bar width', min = 60, max = 300, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarHeight'] = {value = 12, metadata = {element = 'slider', category = catPowerBar, indexInCategory = 2, description = 'Power bar height', min = 6, max = 30, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarTexture'] = {value = 'aurora_hpbar', metadata = {element = 'dropdown', category = catPowerBar, indexInCategory = 3, description = 'Power bar texture', options = {'aurora_hpbar', 'aurora_hpbar_sharp', 'aurora_hpbar_reversed', 'aurora_hpbar_sharp_reversed', 'white8x8'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarFillDirection'] = {value = (frame.key == 'target') and 'RIGHT_TO_LEFT' or 'LEFT_TO_RIGHT', metadata = {element = 'dropdown', category = catPowerBar, indexInCategory = 4, description = 'Power bar fill direction', options = {'LEFT_TO_RIGHT', 'RIGHT_TO_LEFT'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarSmoothTransition'] = {value = true, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 5, description = 'Smooth power bar transition', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarEnablePulse'] = {value = true, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 6, description = 'Enable power bar pulse', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarPulseColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catPowerBar, indexInCategory = 7, description = 'Power bar pulse color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ManaBarEnablePulse', state = true}}}}
        defaults[frame.key..'ManaBarEnableCutout'] = {value = false, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 8, description = 'Enable power bar cutout', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarCutoutColor'] = {value = {1, 0.2, 0.2, 1}, metadata = {element = 'colorpicker', category = catPowerBar, indexInCategory = 9, description = 'Power bar cutout color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ManaBarEnableCutout', state = true}}}}
        defaults[frame.key..'ShowManaText'] = {value = true, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 10, description = 'Show power text', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextFormat'] = {value = 'cur/max', metadata = {element = 'dropdown', category = catPowerBar, indexInCategory = 11, description = 'Power text format', options = {'current', 'cur/max', 'none'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextShowPercent'] = {value = false, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 12, description = 'Show power percentage', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextAbbreviate'] = {value = false, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 13, description = 'Abbreviate power numbers', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextAnchor'] = {value = 'left', metadata = {element = 'dropdown', category = catPowerBar, indexInCategory = 14, description = 'Power text anchor', options = {'left', 'center', 'right'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextFont'] = {value = 'font:FRIZQT__.TTF', metadata = {element = 'dropdown', category = catPowerBar, indexInCategory = 15, description = 'Power text font', options = media.fonts, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextSize'] = {value = 10, metadata = {element = 'slider', category = catPowerBar, indexInCategory = 16, description = 'Power text size', min = 6, max = 20, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catPowerBar, indexInCategory = 17, description = 'Power text color', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaPercentTextFont'] = {value = 'font:FRIZQT__.TTF', metadata = {element = 'dropdown', category = catPowerBar, indexInCategory = 18, description = 'Power percent text font', options = media.fonts, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaPercentTextSize'] = {value = 10, metadata = {element = 'slider', category = catPowerBar, indexInCategory = 19, description = 'Power percent text size', min = 6, max = 20, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaPercentTextColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catPowerBar, indexInCategory = 20, description = 'Power percent text color', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'BuffAnchor'] = {value = 'below', metadata = {element = 'dropdown', category = catBuffsDebuffs, indexInCategory = 1, description = 'Buff anchor position', options = {'below', 'above', 'Disabled'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'BuffSize'] = {value = 20, metadata = {element = 'slider', category = catBuffsDebuffs, indexInCategory = 2, description = 'Buff size', min = 10, max = 40, step = 2, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'DebuffAnchor'] = {value = 'below', metadata = {element = 'dropdown', category = catBuffsDebuffs, indexInCategory = 3, description = 'Debuff anchor position', options = {'below', 'above', 'Disabled'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'DebuffSize'] = {value = 20, metadata = {element = 'slider', category = catBuffsDebuffs, indexInCategory = 4, description = 'Debuff size', min = 10, max = 40, step = 2, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ShowDebuffTimer'] = {value = false, metadata = {element = 'checkbox', category = catBuffsDebuffs, indexInCategory = 5, description = 'Show debuff timer', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'DebuffTimerFont'] = {value = 'font:FRIZQT__.TTF', metadata = {element = 'dropdown', category = catBuffsDebuffs, indexInCategory = 6, description = 'Debuff timer font', options = media.fonts, dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ShowDebuffTimer', state = true}}}}
        defaults[frame.key..'DebuffTimerSize'] = {value = 8, metadata = {element = 'slider', category = catBuffsDebuffs, indexInCategory = 7, description = 'Debuff timer size', min = 6, max = 16, step = 1, dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ShowDebuffTimer', state = true}}}}
        defaults[frame.key..'PortraitBorderTexture'] = {value = 'portrait_border_edge', metadata = {element = 'dropdown', category = catEffects, indexInCategory = 1, description = 'Portrait border texture', options = {'portrait_border_edge', 'portrait_border', 'portrait_border_base'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'FlipPortraitBorder'] = {value = (frame.key == 'target'), metadata = {element = 'checkbox', category = catEffects, indexInCategory = 2, description = 'Flip portrait border horizontally', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'PortraitBorderColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 3, description = 'Portrait border color', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'CombatGlowTextures'] = {value = 'Both', metadata = {element = 'dropdown', category = catEffects, indexInCategory = 4, description = 'Combat glow textures', options = {'Both', 'Portrait Only', 'Bar Only', 'None'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'CombatGlowColor'] = {value = {1, 0, 0, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 5, description = 'Combat glow color', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'CombatGlowMaxAlpha'] = {value = 0.7, metadata = {element = 'slider', category = catEffects, indexInCategory = 6, description = 'Combat glow max alpha (portrait)', min = 0, max = 1, step = 0.05, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'CombatGlow2MaxAlpha'] = {value = 0.7, metadata = {element = 'slider', category = catEffects, indexInCategory = 7, description = 'Combat glow max alpha (bar)', min = 0, max = 1, step = 0.05, dependency = {key = frame.key..'Enabled', state = true}}}
        if frame.key ~= 'pet' then
            defaults[frame.key..'ShowPvPIcon'] = {value = true, metadata = {element = 'checkbox', category = catEffects, indexInCategory = 8, description = 'Show PvP icon', dependency = {key = frame.key..'Enabled', state = true}}}
            defaults[frame.key..'PvPIconSize'] = {value = 45, metadata = {element = 'slider', category = catEffects, indexInCategory = 9, description = 'PvP icon size', min = 20, max = 80, step = 1, dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ShowPvPIcon', state = true}}}}
            defaults[frame.key..'PvPIconColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 10, description = 'PvP icon color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ShowPvPIcon', state = true}}}}
        end
        if frame.key == 'pet' then
            defaults['petHappinessIconSize'] = {value = 22, metadata = {element = 'slider', category = catEffects, indexInCategory = 11, description = 'Happiness icon size', min = 8, max = 40, step = 2, dependency = {key = 'petEnabled', state = true}}}
        end
        if frame.key == 'player' then
            defaults['playerShowRestingZZZ'] = {value = true, metadata = {element = 'checkbox', category = catEffects, indexInCategory = 11, description = 'Show resting ZZZ animation', dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerRestingZZZColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 12, description = 'Resting ZZZ color', dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerShowEnergyTick'] = {value = true, metadata = {element = 'checkbox', category = catEffects, indexInCategory = 13, description = 'Show energy tick indicator', dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerEnergyTickColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 14, description = 'Energy tick color', dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerRestingGlowTextures'] = {value = 'Both', metadata = {element = 'dropdown', category = catEffects, indexInCategory = 15, description = 'Resting glow textures', options = {'Both', 'Portrait Only', 'Bar Only', 'None'}, dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerRestingGlowColor'] = {value = {.3, .82, 0, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 16, description = 'Resting glow color', dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerRestingGlowMaxAlpha'] = {value = 0.7, metadata = {element = 'slider', category = catEffects, indexInCategory = 17, description = 'Resting glow max alpha (portrait)', min = 0, max = 1, step = 0.05, dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerRestingGlow2MaxAlpha'] = {value = 0.7, metadata = {element = 'slider', category = catEffects, indexInCategory = 18, description = 'Resting glow max alpha (bar)', min = 0, max = 1, step = 0.05, dependency = {key = 'playerEnabled', state = true}}}
        end
    end

    return defaults
end

function setup:GenerateCallbacks()
    local frames = {
        {key = 'player', name = 'Player'},
        {key = 'target', name = 'Target'},
        {key = 'targettarget', name = 'Target of Target'},
        {key = 'pet', name = 'Pet'},
        {key = 'pettarget', name = 'Pet Target'},
        {key = 'party', name = 'Party Frames'}
    }

    local callbacks = {}

    for i = 1, table.getn(frames) do
        local frame = frames[i]
        callbacks[frame.key..'Enabled'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if frame.key == 'party' then
                    if string.find(portrait.unit, 'party') then
                        if value then
                            setup:UpdatePortraitVisibility(portrait)
                        else
                            portrait:Hide()
                        end
                    end
                elseif portrait.unit == frame.key then
                    if value then
                        setup:UpdatePortraitVisibility(portrait)
                    else
                        portrait:Hide()
                    end
                end
            end
        end
        callbacks[frame.key..'ShowPortrait'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if frame.key == 'party' then
                    if string.find(portrait.unit, 'party') then
                        if value then
                            portrait.borderBg:Show()
                            portrait.border:Show()
                            setup:UpdateCombatGlow(portrait)
                            if portrait.model.restingGlow then setup:UpdateRestingGlow(portrait) end
                        else
                            portrait.borderBg:Hide()
                            portrait.model:Hide()
                            portrait.portrait2D:Hide()
                            portrait.classIcon:Hide()
                            portrait.border:Hide()
                            if portrait.model.combatGlow then portrait.model.combatGlow:Hide() end
                            if portrait.model.restingGlow then portrait.model.restingGlow:Hide() end
                        end
                    end
                elseif portrait.unit == frame.key then
                    if value then
                        portrait.borderBg:Show()
                        portrait.border:Show()
                        setup:UpdateCombatGlow(portrait)
                        if portrait.model.restingGlow then setup:UpdateRestingGlow(portrait) end
                    else
                        portrait.borderBg:Hide()
                        portrait.model:Hide()
                        portrait.portrait2D:Hide()
                        portrait.classIcon:Hide()
                        portrait.border:Hide()
                        if portrait.model.combatGlow then portrait.model.combatGlow:Hide() end
                        if portrait.model.restingGlow then portrait.model.restingGlow:Hide() end
                    end
                end
            end
        end
        callbacks[frame.key..'PortraitMode'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if frame.key == 'party' then
                    if string.find(portrait.unit, 'party') then
                        setup:UpdatePortraitMode(portrait, portrait.unit)
                    end
                elseif portrait.unit == frame.key then
                    setup:UpdatePortraitMode(portrait, portrait.unit)
                end
            end
        end
        callbacks[frame.key..'ShowLevel'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    if value then portrait.level:Show() else portrait.level:Hide() end
                end
            end
        end
        callbacks[frame.key..'ShowName'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    if value then portrait.name:Show() else portrait.name:Hide() end
                end
            end
        end
        if frame.key ~= 'player' then
            callbacks[frame.key..'NameAbbreviation'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                        portrait.nameMode = value
                        setup:UpdateNameText(portrait)
                    end
                end
            end
            callbacks[frame.key..'NameMaxLength'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                        portrait.nameMaxLength = value
                        setup:UpdateNameText(portrait)
                    end
                end
            end
        end
        callbacks[frame.key..'ShowHealthText'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    if value then
                        portrait.hpBar.text:Show()
                        portrait.hpBar.pctText:Show()
                    else
                        portrait.hpBar.text:Hide()
                        portrait.hpBar.pctText:Hide()
                    end
                end
            end
        end
        callbacks[frame.key..'ShowManaText'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    if value then
                        portrait.powerBar.text:Show()
                        portrait.powerBar.pctText:Show()
                    else
                        portrait.powerBar.text:Hide()
                        portrait.powerBar.pctText:Hide()
                    end
                end
            end
        end
        callbacks[frame.key..'HealthTextFormat'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.healthTextFormat = value
                    setup:UpdateBarText(portrait)
                end
            end
        end
        callbacks[frame.key..'HealthTextShowPercent'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.healthTextShowPercent = value
                    setup:UpdateBarText(portrait)
                end
            end
        end
        callbacks[frame.key..'HealthTextAbbreviate'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.abbreviateNumbers = value
                    setup:UpdateBarText(portrait)
                end
            end
        end
        callbacks[frame.key..'HealthTextAnchor'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.healthTextAnchor = value
                    setup:UpdateBarText(portrait)
                end
            end
        end
        callbacks[frame.key..'ManaTextFormat'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.manaTextFormat = value
                    setup:UpdateBarText(portrait)
                end
            end
        end
        callbacks[frame.key..'ManaTextShowPercent'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.manaTextShowPercent = value
                    setup:UpdateBarText(portrait)
                end
            end
        end
        callbacks[frame.key..'ManaTextAbbreviate'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.abbreviateNumbers = value
                    setup:UpdateBarText(portrait)
                end
            end
        end
        callbacks[frame.key..'ManaTextAnchor'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.manaTextAnchor = value
                    setup:UpdateBarText(portrait)
                end
            end
        end
        callbacks[frame.key..'Scale'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait:SetScale(value)
                end
            end
        end
        callbacks[frame.key..'PortraitSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local offset = GetPortraitModelOffset(value)
                    portrait.borderBg:SetSize(value, value)
                    portrait.model:SetSize(value - offset, value - offset)
                    portrait.portrait2D:SetSize(value - offset, value - offset)
                    portrait.classIcon:SetSize(value - offset, value - offset)
                    portrait.border:SetSize(value, value)
                end
            end
        end
        callbacks[frame.key..'InfoBgWidth'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.infoBg:SetWidth(value)
                end
            end
        end
        callbacks[frame.key..'InfoBgHeight'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.infoBg:SetHeight(value)
                end
            end
        end
        callbacks[frame.key..'HealthBarWidth'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.hpBar:SetWidth(value)
                    portrait.hpBar:Update()
                    if portrait.model.combatGlow2 then portrait.model.combatGlow2:SetWidth(value + 2) end
                    if portrait.model.restingGlow2 then portrait.model.restingGlow2:SetWidth(value + 2) end
                end
            end
        end
        callbacks[frame.key..'HealthBarHeight'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.hpBar:SetHeight(value)
                    portrait.hpBar:Update()
                end
            end
        end
        callbacks[frame.key..'ManaBarWidth'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.powerBar:SetWidth(value)
                    portrait.powerBar:Update()
                end
            end
        end
        callbacks[frame.key..'ManaBarHeight'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.powerBar:SetHeight(value)
                    portrait.powerBar:Update()
                end
            end
        end
        callbacks[frame.key..'LevelTextFont'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local _, currentSize, currentFlags = portrait.level:GetFont()
                    portrait.level:SetFont(media[value] or 'Fonts\\FRIZQT__.TTF', currentSize or 10, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'LevelTextSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local currentFont, _, currentFlags = portrait.level:GetFont()
                    portrait.level:SetFont(currentFont or 'Fonts\\FRIZQT__.TTF', value, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'NameTextFont'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local _, currentSize, currentFlags = portrait.name:GetFont()
                    portrait.name:SetFont(media[value] or 'Fonts\\FRIZQT__.TTF', currentSize or 10, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'NameTextSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local currentFont, _, currentFlags = portrait.name:GetFont()
                    portrait.name:SetFont(currentFont or 'Fonts\\FRIZQT__.TTF', value, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'NameTextColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    setup:UpdateNameColor(portrait)
                end
            end
        end
        if frame.key == 'target' or frame.key == 'targettarget' or frame.key == 'pettarget' then
            callbacks[frame.key..'NameReactionColoring'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if portrait.unit == frame.key then
                        setup:UpdateNameColor(portrait)
                    end
                end
            end
        end
        callbacks[frame.key..'HealthTextFont'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local _, currentSize, currentFlags = portrait.hpBar.text:GetFont()
                    portrait.hpBar.text:SetFont(media[value] or 'Fonts\\FRIZQT__.TTF', currentSize or 10, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'HealthTextSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local currentFont, _, currentFlags = portrait.hpBar.text:GetFont()
                    portrait.hpBar.text:SetFont(currentFont or 'Fonts\\FRIZQT__.TTF', value, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'HealthTextColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.hpBar.text:SetTextColor(color[1], color[2], color[3])
                end
            end
        end
        callbacks[frame.key..'HealthPercentTextFont'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local _, currentSize, currentFlags = portrait.hpBar.pctText:GetFont()
                    portrait.hpBar.pctText:SetFont(media[value] or 'Fonts\\FRIZQT__.TTF', currentSize or 10, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'HealthPercentTextSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local currentFont, _, currentFlags = portrait.hpBar.pctText:GetFont()
                    portrait.hpBar.pctText:SetFont(currentFont or 'Fonts\\FRIZQT__.TTF', value, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'HealthPercentTextColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.hpBar.pctText:SetTextColor(color[1], color[2], color[3])
                end
            end
        end
        callbacks[frame.key..'ManaTextFont'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local _, currentSize, currentFlags = portrait.powerBar.text:GetFont()
                    portrait.powerBar.text:SetFont(media[value] or 'Fonts\\FRIZQT__.TTF', currentSize or 10, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'ManaTextSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local currentFont, _, currentFlags = portrait.powerBar.text:GetFont()
                    portrait.powerBar.text:SetFont(currentFont or 'Fonts\\FRIZQT__.TTF', value, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'ManaTextColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.powerBar.text:SetTextColor(color[1], color[2], color[3])
                end
            end
        end
        callbacks[frame.key..'ManaPercentTextFont'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local _, currentSize, currentFlags = portrait.powerBar.pctText:GetFont()
                    portrait.powerBar.pctText:SetFont(media[value] or 'Fonts\\FRIZQT__.TTF', currentSize or 10, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'ManaPercentTextSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local currentFont, _, currentFlags = portrait.powerBar.pctText:GetFont()
                    portrait.powerBar.pctText:SetFont(currentFont or 'Fonts\\FRIZQT__.TTF', value, currentFlags or 'OUTLINE')
                end
            end
        end
        callbacks[frame.key..'ManaPercentTextColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.powerBar.pctText:SetTextColor(color[1], color[2], color[3])
                end
            end
        end
        callbacks[frame.key..'HealthBarColorMode'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    if UnitExists(portrait.unit) then
                        setup:UpdateHealthBarColor(portrait, portrait.unit)
                    end
                end
            end
        end
        callbacks[frame.key..'HealthBarCustomColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    if UnitExists(portrait.unit) then
                        setup:UpdateHealthBarColor(portrait, portrait.unit)
                    end
                end
            end
        end
        callbacks[frame.key..'HealthBarTexture'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local tex = value == 'white8x8' and 'Interface\\Buttons\\White8x8' or media['tex:unitframes:'..value..'.tga']
                    portrait.hpBar:SetTextures(tex, tex)
                end
            end
        end
        callbacks[frame.key..'HealthBarFillDirection'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.hpBar:SetFillDirection(value)
                end
            end
        end
        callbacks[frame.key..'HealthBarSmoothTransition'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.hpBar:SetBarAnimation(value)
                end
            end
        end
        callbacks[frame.key..'HealthBarEnablePulse'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.hpBar:SetPulseAnimation(value)
                end
            end
        end
        callbacks[frame.key..'HealthBarEnableCutout'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.hpBar:SetCutoutAnimation(value)
                end
            end
        end
        callbacks[frame.key..'HealthBarPulseColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.hpBar:SetPulseColor(color[1], color[2], color[3], color[4])
                end
            end
        end
        callbacks[frame.key..'HealthBarCutoutColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.hpBar:SetCutoutColor(color[1], color[2], color[3], color[4])
                end
            end
        end
        callbacks[frame.key..'ManaBarTexture'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local tex = value == 'white8x8' and 'Interface\\Buttons\\White8x8' or media['tex:unitframes:'..value..'.tga']
                    portrait.powerBar:SetTextures(tex, tex)
                end
            end
        end
        callbacks[frame.key..'ManaBarFillDirection'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.powerBar:SetFillDirection(value)
                end
            end
        end
        callbacks[frame.key..'ManaBarSmoothTransition'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.powerBar:SetBarAnimation(value)
                end
            end
        end
        callbacks[frame.key..'ManaBarEnablePulse'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.powerBar:SetPulseAnimation(value)
                end
            end
        end
        callbacks[frame.key..'ManaBarEnableCutout'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.powerBar:SetCutoutAnimation(value)
                end
            end
        end
        callbacks[frame.key..'ManaBarPulseColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.powerBar:SetPulseColor(color[1], color[2], color[3], color[4])
                end
            end
        end
        callbacks[frame.key..'ManaBarCutoutColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.powerBar:SetCutoutColor(color[1], color[2], color[3], color[4])
                end
            end
        end
        callbacks[frame.key..'BuffAnchor'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.buffAnchor = value
                    local visibleBuffs = setup:UpdateBuffs(portrait)
                    setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
                end
            end
        end
        callbacks[frame.key..'BuffSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    for k = 1, table.getn(portrait.buffs) do
                        portrait.buffs[k]:SetSize(value, value)
                    end
                    local visibleBuffs = setup:UpdateBuffs(portrait)
                    setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
                end
            end
        end
        callbacks[frame.key..'DebuffAnchor'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.debuffAnchor = value
                    local visibleBuffs = setup:UpdateBuffs(portrait)
                    setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
                end
            end
        end
        callbacks[frame.key..'DebuffSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    for k = 1, table.getn(portrait.debuffs) do
                        portrait.debuffs[k]:SetSize(value, value)
                    end
                    local visibleBuffs = setup:UpdateBuffs(portrait)
                    setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
                end
            end
        end
        callbacks[frame.key..'ShowDebuffTimer'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local visibleBuffs = setup:UpdateBuffs(portrait)
                    setup:UpdateDebuffs(portrait, math.ceil(visibleBuffs / 5))
                end
            end
        end
        callbacks[frame.key..'DebuffTimerFont'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    for k = 1, table.getn(portrait.debuffs) do
                        local _, currentSize, currentFlags = portrait.debuffs[k].timer:GetFont()
                        portrait.debuffs[k].timer:SetFont(media[value] or 'Fonts\\FRIZQT__.TTF', currentSize or 8, currentFlags or 'OUTLINE')
                    end
                end
            end
        end
        callbacks[frame.key..'DebuffTimerSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    for k = 1, table.getn(portrait.debuffs) do
                        local currentFont, _, currentFlags = portrait.debuffs[k].timer:GetFont()
                        portrait.debuffs[k].timer:SetFont(currentFont or 'Fonts\\FRIZQT__.TTF', value, currentFlags or 'OUTLINE')
                    end
                end
            end
        end
        if frame.key ~= 'pet' then
            callbacks[frame.key..'ShowPvPIcon'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                        setup:UpdatePvPIcon(portrait)
                    end
                end
            end
            callbacks[frame.key..'PvPIconSize'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                        if portrait.pvpIcon then
                            portrait.pvpIcon:SetSize(value, value)
                        end
                    end
                end
            end
            callbacks[frame.key..'PvPIconColor'] = function(color)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                        if portrait.pvpIcon then
                            portrait.pvpIcon:SetVertexColor(color[1], color[2], color[3], color[4])
                        end
                    end
                end
            end
        end
        callbacks[frame.key..'PortraitBorderTexture'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    local tex, glowTex
                    if value == 'portrait_border_edge' then
                        tex = setup.textures.portraitBorder
                        glowTex = setup.textures.portraitBorderGlow
                    elseif value == 'portrait_border' then
                        tex = setup.textures.portraitBorderAlt1
                        glowTex = setup.textures.portraitBorderGlowAlt
                    elseif value == 'portrait_border_base' then
                        tex = setup.textures.portraitBorderAlt2
                        glowTex = setup.textures.portraitBorderGlowAlt
                    end
                    portrait.border:SetTexture(tex)
                    if portrait.model.combatGlow then portrait.model.combatGlow:SetTexture(glowTex) end
                    if portrait.model.restingGlow then portrait.model.restingGlow:SetTexture(glowTex) end
                end
            end
        end
        callbacks[frame.key..'FlipPortraitBorder'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    if portrait.unit == 'target' and UnitExists('target') then
                        local classification = UnitClassification('target')
                        if classification == 'elite' or classification == 'rareelite' or classification == 'rare' or classification == 'worldboss' then
                            return
                        end
                    end
                    local borderKey = string.find(portrait.unit, 'party') and 'partyPortraitBorderTexture' or portrait.unit..'PortraitBorderTexture'
                    local borderTexture = (AU_GlobalDB and AU.profile['unitframes'] and AU.profile['unitframes'][borderKey]) or 'portrait_border_edge'
                    if value then
                        portrait.border:SetTexCoord(1, 0, 0, 1)
                        if borderTexture == 'portrait_border_edge' then
                            if portrait.model.combatGlow then portrait.model.combatGlow:SetTexCoord(1, 0, 0, 1) end
                            if portrait.model.restingGlow then portrait.model.restingGlow:SetTexCoord(1, 0, 0, 1) end
                        end
                    else
                        portrait.border:SetTexCoord(0, 1, 0, 1)
                        if borderTexture == 'portrait_border_edge' then
                            if portrait.model.combatGlow then portrait.model.combatGlow:SetTexCoord(0, 1, 0, 1) end
                            if portrait.model.restingGlow then portrait.model.restingGlow:SetTexCoord(0, 1, 0, 1) end
                        end
                    end
                end
            end
        end
        callbacks[frame.key..'PortraitBorderColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.border:SetVertexColor(color[1], color[2], color[3], color[4])
                end
            end
        end
        callbacks[frame.key..'CombatGlowTextures'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.combatGlowMode = value
                    setup:UpdateCombatGlow(portrait)
                end
            end
        end
        callbacks[frame.key..'CombatGlowColor'] = function(color)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    if portrait.model.combatGlow then
                        portrait.model.combatGlow:SetVertexColor(color[1], color[2], color[3])
                    end
                    if portrait.model.combatGlow2 then
                        portrait.model.combatGlow2:SetVertexColor(color[1], color[2], color[3])
                    end
                end
            end
        end
        callbacks[frame.key..'CombatGlowMaxAlpha'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.combatGlowMaxAlpha = value
                end
            end
        end
        callbacks[frame.key..'CombatGlow2MaxAlpha'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    portrait.combatGlow2MaxAlpha = value
                end
            end
        end
        if frame.key == 'player' then
            callbacks['playerShowRestingZZZ'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if portrait.unit == 'player' and portrait.restingZZZ then
                        portrait.restingZZZ.enabled = value
                        if value and IsResting() then
                            portrait.restingZZZ:Show()
                        else
                            portrait.restingZZZ:Hide()
                        end
                    end
                end
            end
            callbacks['playerRestingZZZColor'] = function(color)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if portrait.unit == 'player' and portrait.restingZZZ then
                        portrait.restingZZZ.tex:SetVertexColor(color[1], color[2], color[3], color[4])
                    end
                end
            end
            callbacks['playerShowEnergyTick'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if portrait.unit == 'player' and portrait.powerBar.energyTick then
                        portrait.powerBar.energyTick.enabled = value
                        if value then
                            local powerType = UnitPowerType('player')
                            if powerType == 0 or powerType == 3 then
                                portrait.powerBar.energyTick:Show()
                            end
                        else
                            portrait.powerBar.energyTick:Hide()
                        end
                    end
                end
            end
            callbacks['playerEnergyTickColor'] = function(color)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if portrait.unit == 'player' and portrait.powerBar.energyTick then
                        portrait.powerBar.energyTick.spark:SetVertexColor(color[1], color[2], color[3], color[4])
                    end
                end
            end
            callbacks['playerRestingGlowTextures'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if portrait.unit == 'player' then
                        portrait.restingGlowMode = value
                        setup:UpdateRestingGlow(portrait)
                    end
                end
            end
            callbacks['playerRestingGlowColor'] = function(color)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if portrait.unit == 'player' then
                        if portrait.model.restingGlow then
                            portrait.model.restingGlow:SetVertexColor(color[1], color[2], color[3])
                        end
                        if portrait.model.restingGlow2 then
                            portrait.model.restingGlow2:SetVertexColor(color[1], color[2], color[3])
                        end
                    end
                end
            end
            callbacks['playerRestingGlowMaxAlpha'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if portrait.unit == 'player' then
                        portrait.restingGlowMaxAlpha = value
                    end
                end
            end
            callbacks['playerRestingGlow2MaxAlpha'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if portrait.unit == 'player' then
                        portrait.restingGlow2MaxAlpha = value
                    end
                end
            end
        end
        if frame.key == 'pet' then
            callbacks['petHappinessIconSize'] = function(value)
                for j = 1, table.getn(setup.portraits) do
                    local portrait = setup.portraits[j]
                    if portrait.unit == 'pet' and portrait.happinessIcon then
                        portrait.happinessIcon:SetSize(value, value)
                    end
                end
            end
        end
    end

    return callbacks
end

-- expose
AU.setups.unitframes = setup
