DRAGONFLIGHT()

local setup = {
    portraitModels = {},
    portraits = {},
    updater = CreateFrame('Frame'),
    combatGlowElapsed = 0,
    lastTargetColor = {0, 1, 0},
    lastPlayerColor = {0, 1, 0},
    portrait2DTimer = 5, -- TODO find a better way this is total trash, unitframes needs rework

    textures = {
        portraitBorderBg = media['tex:unitframes:portrait_border_bg.blp'],
        portraitBorderEdgeBg = media['tex:unitframes:portrait_border_edge_bg.blp'],
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
        borderBoss = media['tex:unitframes:uf_boss.blp'],
        groupLeader = media['tex:unitframes:groupleader.blp']
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

-- create
function setup:CreateUnitFrame(unit, width, height)
    local frameName = 'DF_'..string.gsub(unit, '^%l', string.upper)..'Frame'
    local unitFrame = CreateFrame('Button', frameName, UIParent)
    unitFrame:SetSize(width, height)
    unitFrame.unit = unit
    unitFrame:SetFrameStrata('MEDIUM')

    unitFrame.portraitFrame = CreateFrame('Frame', nil, unitFrame)
    unitFrame.portraitFrame:SetSize(80, 80)

    unitFrame.borderBg = unitFrame.portraitFrame:CreateTexture(nil, 'BACKGROUND')
    unitFrame.borderBg:SetTexture(self.textures.portraitBorderEdgeBg)
    unitFrame.borderBg:SetAllPoints(unitFrame.portraitFrame)

    unitFrame.model = CreateFrame('PlayerModel', nil, unitFrame.portraitFrame)
    unitFrame.model:SetSize(80 + 15, 80 + 15)
    unitFrame.model:SetPoint('CENTER', unitFrame.portraitFrame, 'CENTER', 0, 0)
    unitFrame.model.update = unit
    unitFrame.model.unit = unit
    table.insert(setup.portraitModels, unitFrame.model)

    unitFrame.portrait2D = unitFrame.portraitFrame:CreateTexture(nil, 'ARTWORK')
    unitFrame.portrait2D:SetSize(80 - 26, 80 - 26)
    unitFrame.portrait2D:SetPoint('CENTER', unitFrame.portraitFrame, 'CENTER', 0, 0)
    unitFrame.portrait2D:Hide()

    unitFrame.classIcon = unitFrame.portraitFrame:CreateTexture(nil, 'ARTWORK')
    unitFrame.classIcon:SetSize(80 - 26, 80 - 26)
    unitFrame.classIcon:SetPoint('CENTER', unitFrame.portraitFrame, 'CENTER', 0, 0)
    unitFrame.classIcon:SetTexture(self.textures.classIcons)
    unitFrame.classIcon:Hide()

    local borderFrame = CreateFrame('Frame', nil, unitFrame.portraitFrame)
    borderFrame:SetFrameLevel(unitFrame.model:GetFrameLevel() + 1)
    borderFrame:SetAllPoints(unitFrame.portraitFrame)
    unitFrame.border = borderFrame:CreateTexture(nil, 'OVERLAY')
    unitFrame.border:SetTexture(self.textures.portraitBorder)
    unitFrame.border:SetAllPoints(unitFrame.portraitFrame)

    unitFrame.classBorderOverlay = borderFrame:CreateTexture(nil, 'OVERLAY')
    unitFrame.classBorderOverlay:SetPoint('CENTER', unitFrame.border, 'CENTER', 0, 0)
    unitFrame.classBorderOverlay:SetSize(96, 96)
    unitFrame.classBorderOverlay:Hide()

    if string.find(unit, 'party') or unit == 'player' then
        local leaderFrame = CreateFrame('Frame', nil, unitFrame.portraitFrame)
        leaderFrame:SetFrameLevel(borderFrame:GetFrameLevel() + 1)
        leaderFrame:SetAllPoints(unitFrame.portraitFrame)
        unitFrame.leaderIcon = leaderFrame:CreateTexture(nil, 'OVERLAY')
        unitFrame.leaderIcon:SetTexture(self.textures.groupLeader)
        unitFrame.leaderIcon:SetSize(16, 16)
        unitFrame.leaderIcon:SetPoint('TOP', unitFrame.portraitFrame, 'TOP', -25, 2)
        unitFrame.leaderIcon:Hide()
    end

    unitFrame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    unitFrame:SetScript('OnClick', function()
        if arg1 == 'LeftButton' then
            TargetUnit(this.unit)
        elseif arg1 == 'RightButton' then
            setup:ShowRightClickMenu(this.unit)
        end
    end)

    if unit == 'player' then
        unitFrame:SetScript('OnEnter', function()
            GameTooltip_SetDefaultAnchor(GameTooltip, this)
            GameTooltip_AddNewbieTip(PARTY_OPTIONS_LABEL, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_PARTYOPTIONS)
        end)
        unitFrame:SetScript('OnLeave', function()
            GameTooltip:Hide()
        end)
    elseif unit == 'target' then
        unitFrame:SetScript('OnEnter', function()
            GameTooltip_SetDefaultAnchor(GameTooltip, this)
            GameTooltip:SetUnit(this.unit)
            local r, g, b = GameTooltip_UnitColor(this.unit)
            GameTooltipTextLeft1:SetTextColor(r, g, b)
        end)
        unitFrame:SetScript('OnLeave', function()
            GameTooltip:Hide()
        end)
    end

    unitFrame.hpBar = DF.animations.CreateStatusBar(unitFrame, 120, 20, nil, frameName..'.hpBar')
    unitFrame.hpBar:SetFillColor(0, 1, 0, 1)
    unitFrame.hpBar.text = unitFrame.hpBar:CreateFontString(nil, 'OVERLAY')
    unitFrame.hpBar.text:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
    unitFrame.hpBar.pctText = unitFrame.hpBar:CreateFontString(nil, 'OVERLAY')
    unitFrame.hpBar.pctText:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')

    unitFrame.powerBar = DF.animations.CreateStatusBar(unitFrame, 120, 12, nil, frameName..'.powerBar')
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
        unitFrame.portraitFrame:SetPoint('RIGHT', unitFrame, 'RIGHT', 0, 0)
        unitFrame.hpBar:SetFillDirection('LEFT_TO_RIGHT')
        unitFrame.hpBar:SetPoint('RIGHT', unitFrame.border, 'LEFT', 6, -5)
        unitFrame.hpBar.text:SetPoint('LEFT', unitFrame.hpBar, 'LEFT', 3, 0)
        unitFrame.hpBar.pctText:SetPoint('RIGHT', unitFrame.hpBar, 'RIGHT', -3, 0)
        unitFrame.powerBar:SetFillDirection('LEFT_TO_RIGHT')
        unitFrame.powerBar:SetPoint('TOPLEFT', unitFrame.hpBar, 'BOTTOMLEFT', 0, 0)
        unitFrame.powerBar.text:SetPoint('LEFT', unitFrame.powerBar, 'LEFT', 3, 0)
        unitFrame.powerBar.pctText:SetPoint('RIGHT', unitFrame.powerBar, 'RIGHT', -3, 0)
        unitFrame.infoBg:SetPoint('BOTTOMRIGHT', unitFrame.hpBar, 'TOPRIGHT', 7, 0)
        unitFrame.name:SetPoint('LEFT', unitFrame.infoBg, 'LEFT', 3, 1)
        unitFrame.level:SetPoint('RIGHT', unitFrame.infoBg, 'RIGHT', -7, 1)
        if unitFrame.pvpIcon then
            unitFrame.pvpIconFrame:SetAllPoints(unitFrame.portraitFrame)
            unitFrame.pvpIcon:SetPoint('CENTER', unitFrame.portraitFrame, 'RIGHT', 12, -3)
        end
        unitFrame.hpBar.fill:SetTexture(media['tex:unitframes:aurora_hpbar.tga'])
        unitFrame.powerBar.fill:SetTexture(media['tex:unitframes:aurora_hpbar.tga'])
    else
        unitFrame.portraitFrame:SetPoint('LEFT', unitFrame, 'LEFT', 0, 0)
        unitFrame.hpBar:SetFillDirection('RIGHT_TO_LEFT')
        unitFrame.hpBar:SetPoint('LEFT', unitFrame.border, 'RIGHT', -6, -5)
        unitFrame.hpBar.text:SetPoint('RIGHT', unitFrame.hpBar, 'RIGHT', 0, 0)
        unitFrame.hpBar.pctText:SetPoint('LEFT', unitFrame.hpBar, 'LEFT', 3, 0)
        unitFrame.powerBar:SetFillDirection('RIGHT_TO_LEFT')
        unitFrame.powerBar:SetPoint('TOPRIGHT', unitFrame.hpBar, 'BOTTOMRIGHT', 0, 0)
        unitFrame.powerBar.text:SetPoint('RIGHT', unitFrame.powerBar, 'RIGHT', 0, 0)
        unitFrame.powerBar.pctText:SetPoint('LEFT', unitFrame.powerBar, 'LEFT', 3, 0)
        unitFrame.infoBg:SetPoint('BOTTOMLEFT', unitFrame.hpBar, 'TOPLEFT', -7, 0)
        unitFrame.name:SetPoint('LEFT', unitFrame.infoBg, 'LEFT', 5, 1)
        unitFrame.level:SetPoint('RIGHT', unitFrame.infoBg, 'RIGHT', -7, 1)
        if unitFrame.pvpIcon then
            unitFrame.pvpIconFrame:SetAllPoints(unitFrame.portraitFrame)
            unitFrame.pvpIcon:SetPoint('CENTER', unitFrame.portraitFrame, 'LEFT', 5, -3)
        end
    end

    local glowFrame = CreateFrame('Frame', nil, unitFrame)
    glowFrame:SetFrameLevel(unitFrame.model:GetFrameLevel() + 2)
    glowFrame:SetAllPoints(unitFrame)

    unitFrame.model.combatGlow = glowFrame:CreateTexture(nil, 'OVERLAY')
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
        unitFrame.happinessIcon = CreateFrame('Frame', 'DF_PetHappinessIcon', unitFrame)
        unitFrame.happinessIcon:SetSize(22, 22)
        unitFrame.happinessIcon:SetPoint('RIGHT', unitFrame.model, 'LEFT', -3, 25)
        unitFrame.happinessIcon.bg = unitFrame.happinessIcon:CreateTexture(nil, 'BACKGROUND')
        unitFrame.happinessIcon.bg:SetAllPoints(unitFrame.happinessIcon)
        unitFrame.happinessIcon.bg:SetTexture(media['tex:generic:combo_empty.blp'])
        unitFrame.happinessIcon.fill = unitFrame.happinessIcon:CreateTexture(nil, 'ARTWORK')
        unitFrame.happinessIcon.fill:SetAllPoints(unitFrame.happinessIcon)
        unitFrame.happinessIcon.fill:SetTexture(media['tex:generic:combo_full.blp'])
        unitFrame.happinessIcon:Hide()
    end

    if unit == 'player' then
        unitFrame.model.restingGlow = glowFrame:CreateTexture(nil, 'OVERLAY')
        unitFrame.model.restingGlow:SetTexture(self.textures.portraitBorderGlow)
        unitFrame.model.restingGlow:SetPoint('TOPLEFT', unitFrame.model, 'TOPLEFT', -17, 17)
        unitFrame.model.restingGlow:SetPoint('BOTTOMRIGHT', unitFrame.model, 'BOTTOMRIGHT', 17, -17)
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
        buff.buffIndex = i
        buff.parentUnit = unit
        buff:SetScript('OnEnter', function()
            GameTooltip:SetOwner(this, 'ANCHOR_RIGHT')
            GameTooltip:SetUnitBuff(this.parentUnit, this.buffIndex)
        end)
        buff:SetScript('OnLeave', function()
            GameTooltip:Hide()
        end)
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
        debuff.count = debuff:CreateFontString(nil, 'OVERLAY')
        debuff.count:SetFont('Fonts\\FRIZQT__.TTF', 8, 'OUTLINE')
        debuff.count:SetPoint('BOTTOMRIGHT', debuff, 'BOTTOMRIGHT', 0, 0)
        debuff.count:Hide()
        debuff.debuffIndex = i
        debuff.parentUnit = unit
        debuff:SetScript('OnEnter', function()
            GameTooltip:SetOwner(this, 'ANCHOR_RIGHT')
            GameTooltip:SetUnitDebuff(this.parentUnit, this.debuffIndex)
        end)
        debuff:SetScript('OnLeave', function()
            GameTooltip:Hide()
        end)
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

function setup:ShowRightClickMenu(unit)
    if unit == 'player' then
        ToggleDropDownMenu(1, nil, PlayerFrameDropDown, this, 0, 0)
    elseif unit == 'target' then
        ToggleDropDownMenu(1, nil, TargetFrameDropDown, this, 0, 0)
    elseif unit == 'pet' then
        ToggleDropDownMenu(1, nil, PetFrameDropDown, this, 0, 0)
    elseif strfind(unit, 'party%d') then
        local partyId = string.gsub(unit, 'party', '')
        ToggleDropDownMenu(1, nil, getglobal('PartyMemberFrame' .. partyId .. 'DropDown'), this, 0, 0)
    end
end

-- updates
function setup:UpdatePortraitMode(frame, unit)
    local modeKey = string.find(frame.unit, 'party') and 'partyPortraitMode' or frame.unit..'PortraitMode'
    local mode = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][modeKey]) or '3D Model'
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
        local coords = DF.tables['classicons'][playerClass]
        if coords then frame.classIcon:SetTexCoord(coords[1], coords[2], coords[3], coords[4]) end
    end
end

function setup:UpdateUnitPortrait(frame, unit)
    frame.model.update = unit
    setup:UpdatePortraitMode(frame, unit)
end

function setup:UpdatePortraitVisibility(portraitFrame)
    local enabledKey = string.find(portraitFrame.unit, 'party') and 'partyEnabled' or portraitFrame.unit..'Enabled'
    if DF_Profiles and DF.profile['unitframes'] and not DF.profile['unitframes'][enabledKey] then
        portraitFrame:Hide()
        return
    end
    if portraitFrame.unit == 'player' or UnitExists(portraitFrame.unit) then
        if not portraitFrame:IsShown() then
            portraitFrame:Show()
        end
        local showPortraitKey = string.find(portraitFrame.unit, 'party') and 'partyShowPortrait' or portraitFrame.unit..'ShowPortrait'
        if DF_Profiles and DF.profile['unitframes'] and not DF.profile['unitframes'][showPortraitKey] then
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
            setup:UpdateUnitPortrait(portraitFrame, portraitFrame.unit)
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

    if unitFrame.unit ~= 'player' and not UnitIsPlayer(unitFrame.unit) and maxMana == 0 then
        unitFrame.powerBar.text:SetText('')
        unitFrame.powerBar.pctText:SetText('')
    else
        if manaFormat == 'current' then
            unitFrame.powerBar.text:SetText(abbrev(mana))
        elseif manaFormat == 'none' then
            unitFrame.powerBar.text:SetText('')
        else
            unitFrame.powerBar.text:SetText(abbrev(mana)..'/'..abbrev(maxMana))
        end
        unitFrame.powerBar.pctText:SetText(unitFrame.manaTextShowPercent and manaPct..'%' or '')
    end

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
    local show = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][showKey])
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

function setup:UpdateLeaderIcon(unitFrame)
    if not unitFrame.leaderIcon then return end
    if GetNumPartyMembers() == 0 then
        unitFrame.leaderIcon:Hide()
        return
    end
    if unitFrame.unit == 'player' then
        if GetPartyLeaderIndex() == 0 then
            unitFrame.leaderIcon:Show()
        else
            unitFrame.leaderIcon:Hide()
        end
    else
        local idStr = string.gsub(unitFrame.unit, 'party', '')
        local id = tonumber(idStr)
        if GetPartyLeaderIndex() == id then
            unitFrame.leaderIcon:Show()
        else
            unitFrame.leaderIcon:Hide()
        end
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
        local useReaction = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][reactionKey])
        if useReaction then
            local reaction = UnitReaction('player', unitFrame.unit)
            if reaction and DF.tables['factioncolors'][reaction] then
                local color = DF.tables['factioncolors'][reaction]
                unitFrame.name:SetTextColor(color[1], color[2], color[3])
                return
            end
        end
    end
    local colorKey = string.find(unitFrame.unit, 'party') and 'partyNameTextColor' or unitFrame.unit..'NameTextColor'
    local color = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][colorKey]) or {1, 0.82, 0, 1}
    unitFrame.name:SetTextColor(color[1], color[2], color[3])
end

function setup:UpdateClassificationBorder(unitFrame)
    if unitFrame.unit ~= 'target' then return end
    if not UnitExists('target') then
        return
    end
    local classification = UnitClassification('target')
    if classification == 'worldboss' then
        unitFrame.border:SetTexture(self.textures.borderBoss)
        unitFrame.border:SetTexCoord(0.25, 0.75, 0.25, 0.75)
    elseif classification == 'rareelite' or classification == 'rare' then
        unitFrame.border:SetTexture(self.textures.borderRare)
        unitFrame.border:SetTexCoord(0.25, 0.75, 0.25, 0.75)
    elseif classification == 'elite' then
        unitFrame.border:SetTexture(self.textures.borderElite)
        unitFrame.border:SetTexCoord(0.25, 0.75, 0.25, 0.75)
    else
        local borderTexture = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes']['targetPortraitBorderTexture']) or 'portrait_border_edge'
        local tex
        if borderTexture == 'portrait_border_edge' then
            tex = self.textures.portraitBorder
        elseif borderTexture == 'portrait_border' then
            tex = self.textures.portraitBorderAlt1
        elseif borderTexture == 'portrait_border_base' then
            tex = self.textures.portraitBorderAlt2
        end
        unitFrame.border:SetTexture(tex)
        local flipKey = 'targetFlipPortraitBorder'
        local shouldFlip = DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][flipKey]
        if shouldFlip then
            unitFrame.border:SetTexCoord(1, 0, 0, 1)
        else
            unitFrame.border:SetTexCoord(0, 1, 0, 1)
        end
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
    if unitFrame.unit ~= 'player' and not UnitIsPlayer(unitFrame.unit) and maxMana == 0 then
        unitFrame.powerBar.text:SetText('')
    else
        unitFrame.powerBar.text:SetText(abbrev(mana)..'/'..abbrev(maxMana))
    end
end

function setup:UpdateHealthBarColor(portrait, unit)
    local modeKey = string.find(portrait.unit, 'party') and 'partyHealthBarColorMode' or portrait.unit..'HealthBarColorMode'
    local mode = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][modeKey]) or 'class'
    if mode == 'custom' then
        local colorKey = string.find(portrait.unit, 'party') and 'partyHealthBarCustomColor' or portrait.unit..'HealthBarCustomColor'
        local color = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][colorKey]) or {0, 1, 0}
        portrait.hpBar:SetFillColor(color[1], color[2], color[3], 1)
        return
    end
    if mode == 'mirror' and portrait.unit == 'player' then
        portrait.hpBar:SetFillColor(setup.lastTargetColor[1], setup.lastTargetColor[2], setup.lastTargetColor[3], 1)
        return
    end
    if mode == 'mirror' and portrait.unit == 'pet' then
        portrait.hpBar:SetFillColor(setup.lastPlayerColor[1], setup.lastPlayerColor[2], setup.lastPlayerColor[3], 1)
        return
    end
    if mode == 'reaction' then
        local reaction = UnitReaction(unit, 'player')
        if reaction and DF.tables['factioncolors'][reaction] then
            local color = DF.tables['factioncolors'][reaction]
            portrait.hpBar:SetFillColor(color[1], color[2], color[3], 1)
            return
        end
    end
    local _, class = UnitClass(unit)
    if class and DF.tables['classcolors'][class] and UnitIsPlayer(unit) then
        local color = DF.tables['classcolors'][class]
        portrait.hpBar:SetFillColor(color[1], color[2], color[3], 1)
        if portrait.unit == 'player' then
            setup.lastPlayerColor = {color[1], color[2], color[3]}
        end
    else
        local reaction = UnitReaction(unit, 'player')
        if reaction and DF.tables['factioncolors'][reaction] then
            local color = DF.tables['factioncolors'][reaction]
            portrait.hpBar:SetFillColor(color[1], color[2], color[3], 1)
            if portrait.unit == 'player' then
                setup.lastPlayerColor = {color[1], color[2], color[3]}
            end
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
                unitFrame.buffs[i]:SetPoint('TOPRIGHT', unitFrame.powerBar, 'BOTTOMRIGHT', -col * 22 + xBase, -row * 22 + yBase)
            else
                unitFrame.buffs[i]:SetPoint('BOTTOMRIGHT', unitFrame.infoBg, 'TOPRIGHT', -col * 22 + xBase, row * 22 - yBase)
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
    local xBase = 0
    local yBase = -3
    local offsetRows = 0
    if anchor == buffAnchor and buffAnchor ~= 'Disabled' then
        offsetRows = buffRows
    end
    local showTimerKey = string.find(unitFrame.unit, 'party') and 'partyShowDebuffTimer' or unitFrame.unit..'ShowDebuffTimer'
    local showTimer = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][showTimerKey])

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
            if stacks and stacks > 1 then
                unitFrame.debuffs[i].count:SetText(stacks)
                unitFrame.debuffs[i].count:Show()
            else
                unitFrame.debuffs[i].count:Hide()
            end
            if showTimer and DF.lib.libdebuff then
                local _, _, _, _, _, duration, timeleft = DF.lib.libdebuff:UnitDebuff(unitFrame.unit, i)
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
                unitFrame.debuffs[i]:SetPoint('TOPRIGHT', unitFrame.powerBar, 'BOTTOMRIGHT', -col * 22 + xBase, -offsetRows * 22 - row * 22 + yBase)
            else
                unitFrame.debuffs[i]:SetPoint('BOTTOMRIGHT', unitFrame.infoBg, 'TOPRIGHT', -col * 22 + xBase, offsetRows * 22 + row * 22 - yBase)
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
    if unitFrame.unit == 'player' then
        setup:UpdateRestingGlow(unitFrame)
    end
end

function setup:UpdateRestingGlow(unitFrame)
    if not unitFrame.model.restingGlow then return end
    local mode = unitFrame.restingGlowMode or 'Both'
    local isResting = IsResting()
    local inCombat = UnitAffectingCombat(unitFrame.unit)
    if inCombat then
        unitFrame.model.restingGlow:Hide()
        unitFrame.model.restingGlow2:Hide()
    elseif mode == 'Both' then
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
        if setup.portrait2DTimer > 0 then
            setup.portrait2DTimer = setup.portrait2DTimer - arg1
            for i = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[i]
                local modeKey = string.find(portrait.unit, 'party') and 'partyPortraitMode' or portrait.unit..'PortraitMode'
                local mode = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][modeKey]) or '3D Model'
                if mode == '2D Portrait' then
                    portrait.portrait2D:Show()
                    SetPortraitTexture(portrait.portrait2D, portrait.unit)
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
                        if not DF.profile['unitframes']['partyEnabled'] then
                            portrait:Hide()
                        elseif UnitExists(portrait.unit) then
                            if not DF.profile['unitframes']['partyShowPortrait'] then
                                portrait.model:Hide()
                                portrait.portrait2D:Hide()
                            elseif not UnitIsVisible(portrait.unit) or not UnitIsConnected(portrait.unit) then
                                local modeKey = 'partyPortraitMode'
                                local mode = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][modeKey]) or '3D Model'
                                if mode == '3D Model' then
                                    portrait.model:Hide()
                                    portrait.classIcon:Hide()
                                    SetPortraitTexture(portrait.portrait2D, portrait.unit)
                                    portrait.portrait2D:Show()
                                else
                                    setup:UpdatePortraitMode(portrait, portrait.unit)
                                end
                            else
                                setup:UpdatePortraitMode(portrait, portrait.unit)
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
                                portrait.model.lastUnit = nil
                            end
                        elseif name ~= portrait.namebuf2 then
                            portrait.namebuf2 = name
                        else
                            if UnitExists(portrait.unit) then
                                if not portrait:IsShown() then portrait:Show() end
                                if UnitIsConnected(portrait.unit) then
                                    local isNewTarget = portrait.model.lastUnit ~= name
                                    if isNewTarget then
                                        portrait.model.update = portrait.unit
                                        portrait.model.lastUnit = name
                                    end
                                    setup:UpdatePortraitMode(portrait, portrait.unit)
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
                            else
                                portrait:Hide()
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
            if DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][showTimerKey] and DF.lib.libdebuff then
                for k = 1, 16 do
                    if portrait.debuffs[k]:IsShown() then
                        local _, _, _, _, _, duration, timeleft = DF.lib.libdebuff:UnitDebuff(portrait.unit, k)
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
    self.eventFrame:RegisterEvent'UNIT_PORTRAIT_UPDATE'
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
                    local targetMode = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes']['targetHealthBarColorMode']) or 'class'
                    if targetMode == 'custom' then
                        local color = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes']['targetHealthBarCustomColor']) or {0, 1, 0}
                        setup.lastTargetColor = {color[1], color[2], color[3]}
                    elseif targetMode == 'reaction' then
                        local reaction = UnitReaction('target', 'player')
                        if reaction and DF.tables['factioncolors'][reaction] then
                            local color = DF.tables['factioncolors'][reaction]
                            setup.lastTargetColor = {color[1], color[2], color[3]}
                        end
                    else
                        local _, class = UnitClass('target')
                        if class and DF.tables['classcolors'][class] then
                            local color = DF.tables['classcolors'][class]
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
                        local playerMode = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes']['playerHealthBarColorMode']) or 'class'
                        if playerMode == 'mirror' then
                            setup:UpdateHealthBarColor(setup.portraits[k], 'player')
                        end
                        break
                    end
                end
                for k = 1, table.getn(setup.portraits) do
                    if setup.portraits[k].unit == 'pet' then
                        local petMode = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes']['petHealthBarColorMode']) or 'class'
                        if petMode == 'mirror' then
                            setup:UpdateHealthBarColor(setup.portraits[k], 'pet')
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
            setup:UpdatePortraitMode(portrait, portrait.unit)
            setup:UpdateNameText(portrait)
            setup:UpdateLevelColor(portrait)
            setup:UpdatePvPIcon(portrait)
            if string.find(portrait.unit, 'party') or portrait.unit == 'player' then
                setup:UpdateLeaderIcon(portrait)
            end
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
                if portrait.unit == 'player' then
                    for j = 1, table.getn(setup.portraits) do
                        if setup.portraits[j].unit == 'pet' then
                            local petMode = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes']['petHealthBarColorMode']) or 'class'
                            if petMode == 'mirror' then
                                setup:UpdateHealthBarColor(setup.portraits[j], 'pet')
                            end
                            break
                        end
                    end
                end
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
                portrait.hpBar.max = UnitHealthMax(portrait.unit)
                portrait.hpBar:SetValue(UnitHealth(portrait.unit))
                portrait.powerBar.max = UnitManaMax(portrait.unit)
                portrait.powerBar:SetValue(UnitMana(portrait.unit))
                -- setup:UpdateHealthBarColor(portrait, portrait.unit)
                -- setup:UpdatePowerBarColor(portrait)
                setup:UpdateBarText(portrait)
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
    elseif event == 'UNIT_PORTRAIT_UPDATE' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if arg1 == portrait.unit then
                portrait.model.update = portrait.unit
                SetPortraitTexture(portrait.portrait2D, portrait.unit)
            end
        end
    elseif event == 'PARTY_MEMBERS_CHANGED' or event == 'PARTY_MEMBER_ENABLE' or event == 'PARTY_MEMBER_DISABLE' or event == 'PARTY_LEADER_CHANGED' or event == 'PARTY_LOOT_METHOD_CHANGED' or event == 'RAID_ROSTER_UPDATE' then
        for i = 1, table.getn(setup.portraits) do
            local portrait = setup.portraits[i]
            if portrait.unit == 'player' then
                setup:UpdateLeaderIcon(portrait)
            elseif string.find(portrait.unit, 'party') then
                if not DF.profile['unitframes']['partyEnabled'] then
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
                        setup:UpdateLeaderIcon(portrait)
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
    local frameOverrides = {
        player = {
            hasPlayerFeatures = true,
            hasNameAbbreviation = false,
            hasNameReactionColoring = false,
            hasRestingFeatures = true,
            hasPvPIcon = true,
        },
        target = {
            healthBarFillDirection = 'RIGHT_TO_LEFT',
            manaBarFillDirection = 'RIGHT_TO_LEFT',
            flipPortraitBorder = true,
            hasNameAbbreviation = true,
            hasNameReactionColoring = true,
            hasPvPIcon = true,
            healthBarTexture = 'aurora_hpbar',
            manaBarTexture = 'aurora_hpbar',
        },
        targettarget = {
            hasNameAbbreviation = true,
            hasNameReactionColoring = true,
            hasPvPIcon = true,
            portraitBorderTexture = 'portrait_border_base',
            scale = 0.8,
            showHealthText = false,
            showManaText = false,
        },
        pet = {
            hasPvPIcon = false,
            hasHappinessIcon = true,
            hasNameAbbreviation = true,
            portraitBorderTexture = 'portrait_border_base',
            scale = 0.8,
        },
        pettarget = {
            hasNameAbbreviation = true,
            hasNameReactionColoring = true,
            hasPvPIcon = true,
            portraitBorderTexture = 'portrait_border_base',
            scale = 0.8,
        },
        party = {
            hasNameAbbreviation = true,
            hasPvPIcon = true,
            portraitBorderTexture = 'portrait_border_base',
            scale = 0.8,
        },
    }

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
        local healthBarFillDirection = 'LEFT_TO_RIGHT'
        local manaBarFillDirection = 'LEFT_TO_RIGHT'
        local flipPortraitBorder = false
        local hasPlayerFeatures = false
        local hasNameAbbreviation = true
        local hasNameReactionColoring = false
        local hasRestingFeatures = false
        local hasPvPIcon = true
        local hasHappinessIcon = false
        local portraitBorderTexture = 'portrait_border_edge'
        local scale = 1

        local healthBarTexture = 'aurora_hpbar_reversed'
        local manaBarTexture = 'aurora_hpbar_reversed'
        local showHealthText = true
        local showManaText = true

        local overrides = frameOverrides[frame.key]
        if overrides then
            healthBarFillDirection = overrides.healthBarFillDirection or healthBarFillDirection
            manaBarFillDirection = overrides.manaBarFillDirection or manaBarFillDirection
            flipPortraitBorder = overrides.flipPortraitBorder or flipPortraitBorder
            hasPlayerFeatures = overrides.hasPlayerFeatures or hasPlayerFeatures
            hasNameAbbreviation = overrides.hasNameAbbreviation ~= nil and overrides.hasNameAbbreviation or hasNameAbbreviation
            hasNameReactionColoring = overrides.hasNameReactionColoring or hasNameReactionColoring
            hasRestingFeatures = overrides.hasRestingFeatures or hasRestingFeatures
            hasPvPIcon = overrides.hasPvPIcon ~= nil and overrides.hasPvPIcon or hasPvPIcon
            hasHappinessIcon = overrides.hasHappinessIcon or hasHappinessIcon
            portraitBorderTexture = overrides.portraitBorderTexture or portraitBorderTexture
            scale = overrides.scale or scale
            healthBarTexture = overrides.healthBarTexture or healthBarTexture
            manaBarTexture = overrides.manaBarTexture or manaBarTexture
            if overrides.showHealthText ~= nil then showHealthText = overrides.showHealthText end
            if overrides.showManaText ~= nil then showManaText = overrides.showManaText end
        end

        defaults[frame.key..'Enabled'] = {value = true, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 1, description = 'Show or hide the '..frame.name..' frame'}}
        defaults[frame.key..'Scale'] = {value = scale, metadata = {element = 'slider', category = catGeneral, indexInCategory = 2, description = 'Frame scale', min = 0.5, max = 2, step = 0.05, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ShowPortrait'] = {value = true, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 3, description = 'Show or hide the portrait', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'PortraitMode'] = {value = '3D Model', metadata = {element = 'dropdown', category = catGeneral, indexInCategory = 4, description = 'Portrait display mode', options = {'3D Model', '2D Portrait', 'Class Icon'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'PortraitSize'] = {value = 80, metadata = {element = 'slider', category = catGeneral, indexInCategory = 5, description = 'Portrait size', min = 40, max = 120, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ShowLevel'] = {value = true, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 6, description = 'Show level text', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ShowName'] = {value = true, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 7, description = 'Show name text', dependency = {key = frame.key..'Enabled', state = true}}}
        if hasNameAbbreviation then
            defaults[frame.key..'NameAbbreviation'] = {value = 'truncated', metadata = {element = 'dropdown', category = catGeneral, indexInCategory = 8, description = 'Name abbreviation mode', options = {'none', 'initials', 'truncated'}, dependency = {key = frame.key..'Enabled', state = true}}}
            defaults[frame.key..'NameMaxLength'] = {value = 14, metadata = {element = 'slider', category = catGeneral, indexInCategory = 9, description = 'Max name length (truncated mode)', min = 3, max = 20, step = 1, dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'NameAbbreviation', state = 'truncated'}}}}
        end
        defaults[frame.key..'InfoBgWidth'] = {value = 127, metadata = {element = 'slider', category = catGeneral, indexInCategory = 10, description = 'Name bar width', min = 60, max = 300, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'InfoBgHeight'] = {value = 16, metadata = {element = 'slider', category = catGeneral, indexInCategory = 11, description = 'Name bar height', min = 8, max = 30, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarWidth'] = {value = 120, metadata = {element = 'slider', category = catHealthBar, indexInCategory = 1, description = 'Health bar width', min = 60, max = 300, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarHeight'] = {value = 20, metadata = {element = 'slider', category = catHealthBar, indexInCategory = 2, description = 'Health bar height', min = 10, max = 50, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarTexture'] = {value = healthBarTexture, metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 3, description = 'Health bar texture', options = {'aurora_hpbar', 'aurora_hpbar_sharp', 'aurora_hpbar_reversed', 'aurora_hpbar_sharp_reversed', 'white8x8'}, dependency = {key = frame.key..'Enabled', state = true}}}

        defaults[frame.key..'HealthBarFillDirection'] = {value = healthBarFillDirection, metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 4, description = 'Health bar fill direction', options = {'LEFT_TO_RIGHT', 'RIGHT_TO_LEFT'}, dependency = {key = frame.key..'Enabled', state = true}}}
        local colorModeOptions = hasPlayerFeatures and {'class', 'reaction', 'custom', 'mirror'} or (frame.key == 'pet' and {'class', 'reaction', 'custom', 'mirror'} or {'class', 'reaction', 'custom'})
        defaults[frame.key..'HealthBarColorMode'] = {value = frame.key == 'pet' and 'mirror' or 'class', metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 5, description = 'Health bar color mode', options = colorModeOptions, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarCustomColor'] = {value = {0, 1, 0}, metadata = {element = 'colorpicker', category = catHealthBar, indexInCategory = 6, description = 'Custom health bar color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'HealthBarColorMode', state = 'custom'}}}}
        defaults[frame.key..'HealthBarSmoothTransition'] = {value = true, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 7, description = 'Smooth health bar transition', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarEnablePulse'] = {value = false, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 8, description = 'Enable health bar pulse', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarPulseColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catHealthBar, indexInCategory = 9, description = 'Health bar pulse color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'HealthBarEnablePulse', state = true}}}}
        defaults[frame.key..'HealthBarEnableCutout'] = {value = false, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 10, description = 'Enable health bar cutout', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthBarCutoutColor'] = {value = {1, 0.2, 0.2, 1}, metadata = {element = 'colorpicker', category = catHealthBar, indexInCategory = 11, description = 'Health bar cutout color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'HealthBarEnableCutout', state = true}}}}
        defaults[frame.key..'ShowHealthText'] = {value = showHealthText, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 12, description = 'Show health text', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextFormat'] = {value = 'cur/max', metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 13, description = 'Health text format', options = {'current', 'cur/max', 'none'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextShowPercent'] = {value = false, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 14, description = 'Show health percentage', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextAbbreviate'] = {value = true, metadata = {element = 'checkbox', category = catHealthBar, indexInCategory = 15, description = 'Abbreviate health numbers', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'HealthTextAnchor'] = {value = 'center', metadata = {element = 'dropdown', category = catHealthBar, indexInCategory = 16, description = 'Health text anchor', options = {'left', 'center', 'right'}, dependency = {key = frame.key..'Enabled', state = true}}}
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
        defaults[frame.key..'NameTextColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catGeneral, indexInCategory = 16, description = 'Name text color', dependency = {key = frame.key..'Enabled', state = true}}}
        if hasNameReactionColoring then
            defaults[frame.key..'NameReactionColoring'] = {value = false, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 17, description = 'Use reaction coloring for name', dependency = {key = frame.key..'Enabled', state = true}}}
        end
        defaults[frame.key..'ManaBarWidth'] = {value = 120, metadata = {element = 'slider', category = catPowerBar, indexInCategory = 1, description = 'Power bar width', min = 60, max = 300, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarHeight'] = {value = 12, metadata = {element = 'slider', category = catPowerBar, indexInCategory = 2, description = 'Power bar height', min = 6, max = 30, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarTexture'] = {value = manaBarTexture, metadata = {element = 'dropdown', category = catPowerBar, indexInCategory = 3, description = 'Power bar texture', options = {'aurora_hpbar', 'aurora_hpbar_sharp', 'aurora_hpbar_reversed', 'aurora_hpbar_sharp_reversed', 'white8x8'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarFillDirection'] = {value = manaBarFillDirection, metadata = {element = 'dropdown', category = catPowerBar, indexInCategory = 4, description = 'Power bar fill direction', options = {'LEFT_TO_RIGHT', 'RIGHT_TO_LEFT'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarSmoothTransition'] = {value = true, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 5, description = 'Smooth power bar transition', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarEnablePulse'] = {value = true, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 6, description = 'Enable power bar pulse', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarPulseColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catPowerBar, indexInCategory = 7, description = 'Power bar pulse color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ManaBarEnablePulse', state = true}}}}
        defaults[frame.key..'ManaBarEnableCutout'] = {value = false, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 8, description = 'Enable power bar cutout', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaBarCutoutColor'] = {value = {1, 0.2, 0.2, 1}, metadata = {element = 'colorpicker', category = catPowerBar, indexInCategory = 9, description = 'Power bar cutout color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ManaBarEnableCutout', state = true}}}}
        defaults[frame.key..'ShowManaText'] = {value = showManaText, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 10, description = 'Show power text', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextFormat'] = {value = 'cur/max', metadata = {element = 'dropdown', category = catPowerBar, indexInCategory = 11, description = 'Power text format', options = {'current', 'cur/max', 'none'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextShowPercent'] = {value = false, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 12, description = 'Show power percentage', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextAbbreviate'] = {value = true, metadata = {element = 'checkbox', category = catPowerBar, indexInCategory = 13, description = 'Abbreviate power numbers', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'ManaTextAnchor'] = {value = 'center', metadata = {element = 'dropdown', category = catPowerBar, indexInCategory = 14, description = 'Power text anchor', options = {'left', 'center', 'right'}, dependency = {key = frame.key..'Enabled', state = true}}}
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
        defaults[frame.key..'ShowDebuffTimer'] = {value = true, metadata = {element = 'checkbox', category = catBuffsDebuffs, indexInCategory = 5, description = 'Show debuff timer', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'DebuffTimerFont'] = {value = 'font:FRIZQT__.TTF', metadata = {element = 'dropdown', category = catBuffsDebuffs, indexInCategory = 6, description = 'Debuff timer font', options = media.fonts, dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ShowDebuffTimer', state = true}}}}
        defaults[frame.key..'DebuffTimerSize'] = {value = 15, metadata = {element = 'slider', category = catBuffsDebuffs, indexInCategory = 7, description = 'Debuff timer size', min = 5, max = 25, step = 1, dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ShowDebuffTimer', state = true}}}}
        defaults[frame.key..'DebuffTimerOffsetX'] = {value = 0, metadata = {element = 'slider', category = catBuffsDebuffs, indexInCategory = 8, description = 'Debuff timer X offset', min = -20, max = 20, step = 1, dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ShowDebuffTimer', state = true}}}}
        defaults[frame.key..'DebuffTimerOffsetY'] = {value = 0, metadata = {element = 'slider', category = catBuffsDebuffs, indexInCategory = 9, description = 'Debuff timer Y offset', min = -20, max = 20, step = 1, dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ShowDebuffTimer', state = true}}}}
        defaults[frame.key..'DebuffStackSize'] = {value = 8, metadata = {element = 'slider', category = catBuffsDebuffs, indexInCategory = 10, description = 'Debuff stack count size', min = 5, max = 20, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'DebuffStackOffsetX'] = {value = 0, metadata = {element = 'slider', category = catBuffsDebuffs, indexInCategory = 11, description = 'Debuff stack X offset', min = -20, max = 20, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'DebuffStackOffsetY'] = {value = 0, metadata = {element = 'slider', category = catBuffsDebuffs, indexInCategory = 12, description = 'Debuff stack Y offset', min = -20, max = 20, step = 1, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'PortraitBorderTexture'] = {value = portraitBorderTexture, metadata = {element = 'dropdown', category = catEffects, indexInCategory = 1, description = 'Portrait border texture', options = {'portrait_border_edge', 'portrait_border', 'portrait_border_base'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'FlipPortraitBorder'] = {value = flipPortraitBorder, metadata = {element = 'checkbox', category = catEffects, indexInCategory = 2, description = 'Flip portrait border horizontally', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'PortraitBorderColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 3, description = 'Portrait border color', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'CombatGlowTextures'] = {value = 'Both', metadata = {element = 'dropdown', category = catEffects, indexInCategory = 4, description = 'Combat glow textures', options = {'Both', 'Portrait Only', 'Bar Only', 'None'}, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'CombatGlowColor'] = {value = {1, 0, 0, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 5, description = 'Combat glow color', dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'CombatGlowMaxAlpha'] = {value = 0.7, metadata = {element = 'slider', category = catEffects, indexInCategory = 6, description = 'Combat glow max alpha (portrait)', min = 0, max = 1, step = 0.05, dependency = {key = frame.key..'Enabled', state = true}}}
        defaults[frame.key..'CombatGlow2MaxAlpha'] = {value = 0.7, metadata = {element = 'slider', category = catEffects, indexInCategory = 7, description = 'Combat glow max alpha (bar)', min = 0, max = 1, step = 0.05, dependency = {key = frame.key..'Enabled', state = true}}}
        if hasPvPIcon then
            defaults[frame.key..'ShowPvPIcon'] = {value = true, metadata = {element = 'checkbox', category = catEffects, indexInCategory = 8, description = 'Show PvP icon', dependency = {key = frame.key..'Enabled', state = true}}}
            defaults[frame.key..'PvPIconSize'] = {value = 45, metadata = {element = 'slider', category = catEffects, indexInCategory = 9, description = 'PvP icon size', min = 20, max = 80, step = 1, dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ShowPvPIcon', state = true}}}}
            defaults[frame.key..'PvPIconColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 10, description = 'PvP icon color', dependency = {{key = frame.key..'Enabled', state = true}, {key = frame.key..'ShowPvPIcon', state = true}}}}
        end

        if hasHappinessIcon then
            defaults['petHappinessIconSize'] = {value = 22, metadata = {element = 'slider', category = catEffects, indexInCategory = 11, description = 'Happiness icon size', min = 8, max = 40, step = 2, dependency = {key = 'petEnabled', state = true}}}
        end

        if hasRestingFeatures then
            defaults['playerShowRestingZZZ'] = {value = true, metadata = {element = 'checkbox', category = catEffects, indexInCategory = 11, description = 'Show resting ZZZ animation', dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerRestingZZZColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 12, description = 'Resting ZZZ color', dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerShowEnergyTick'] = {value = true, metadata = {element = 'checkbox', category = catEffects, indexInCategory = 13, description = 'Show energy tick indicator', dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerEnergyTickColor'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 14, description = 'Energy tick color', dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerRestingGlowTextures'] = {value = 'Both', metadata = {element = 'dropdown', category = catEffects, indexInCategory = 15, description = 'Resting glow textures', options = {'Both', 'Portrait Only', 'Bar Only', 'None'}, dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerRestingGlowColor'] = {value = {0, 1, 1, 1}, metadata = {element = 'colorpicker', category = catEffects, indexInCategory = 16, description = 'Resting glow color', dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerRestingGlowMaxAlpha'] = {value = 0.7, metadata = {element = 'slider', category = catEffects, indexInCategory = 17, description = 'Resting glow max alpha (portrait)', min = 0, max = 1, step = 0.05, dependency = {key = 'playerEnabled', state = true}}}
            defaults['playerRestingGlow2MaxAlpha'] = {value = 0.7, metadata = {element = 'slider', category = catEffects, indexInCategory = 18, description = 'Resting glow max alpha (bar)', min = 0, max = 1, step = 0.05, dependency = {key = 'playerEnabled', state = true}}}
        end
    end

    return defaults
end

local function GetPortraitModelOffset(size)
    local minSize, maxSize = 40, 120
    local minOffset, maxOffset = 17, 50
    local offset = minOffset + (size - minSize) * (maxOffset - minOffset) / (maxSize - minSize)
    return offset
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
                    local glowOffset = math.floor(value * 0.2)
                    portrait.portraitFrame:SetSize(value, value)
                    portrait.borderBg:SetSize(value, value)
                    portrait.model:SetSize(value - offset, value - offset)
                    -- portrait.portrait2D:SetSize(value - offset, value - offset)
                    -- portrait.classIcon:SetSize(value - offset, value - offset)
                    portrait.border:SetSize(value, value)
                    if portrait.model.combatGlow then
                        portrait.model.combatGlow:SetPoint('TOPLEFT', portrait.model, 'TOPLEFT', -glowOffset, glowOffset)
                        portrait.model.combatGlow:SetPoint('BOTTOMRIGHT', portrait.model, 'BOTTOMRIGHT', glowOffset, -glowOffset)
                    end
                    if portrait.model.restingGlow then
                        portrait.model.restingGlow:SetPoint('TOPLEFT', portrait.model, 'TOPLEFT', -glowOffset - 2, glowOffset + 2)
                        portrait.model.restingGlow:SetPoint('BOTTOMRIGHT', portrait.model, 'BOTTOMRIGHT', glowOffset + 2, -glowOffset - 2)
                    end
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
                    if portrait.model.combatGlow2 then portrait.model.combatGlow2:SetWidth(value -3) end
                    if portrait.model.restingGlow2 then portrait.model.restingGlow2:SetWidth(value -3) end
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
                        portrait.debuffs[k].count:SetFont(media[value] or 'Fonts\\FRIZQT__.TTF', currentSize or 8, currentFlags or 'OUTLINE')
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
        callbacks[frame.key..'DebuffStackSize'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    for k = 1, table.getn(portrait.debuffs) do
                        local currentFont, _, currentFlags = portrait.debuffs[k].count:GetFont()
                        portrait.debuffs[k].count:SetFont(currentFont or 'Fonts\\FRIZQT__.TTF', value, currentFlags or 'OUTLINE')
                    end
                end
            end
        end
        callbacks[frame.key..'DebuffTimerOffsetX'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    for k = 1, table.getn(portrait.debuffs) do
                        local offsetY = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][frame.key..'DebuffTimerOffsetY']) or 0
                        portrait.debuffs[k].timer:ClearAllPoints()
                        portrait.debuffs[k].timer:SetPoint('CENTER', portrait.debuffs[k], 'CENTER', value, offsetY)
                    end
                end
            end
        end
        callbacks[frame.key..'DebuffTimerOffsetY'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    for k = 1, table.getn(portrait.debuffs) do
                        local offsetX = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][frame.key..'DebuffTimerOffsetX']) or 0
                        portrait.debuffs[k].timer:ClearAllPoints()
                        portrait.debuffs[k].timer:SetPoint('CENTER', portrait.debuffs[k], 'CENTER', offsetX, value)
                    end
                end
            end
        end
        callbacks[frame.key..'DebuffStackOffsetX'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    for k = 1, table.getn(portrait.debuffs) do
                        local offsetY = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][frame.key..'DebuffStackOffsetY']) or 0
                        portrait.debuffs[k].count:ClearAllPoints()
                        portrait.debuffs[k].count:SetPoint('BOTTOMRIGHT', portrait.debuffs[k], 'BOTTOMRIGHT', value, offsetY)
                    end
                end
            end
        end
        callbacks[frame.key..'DebuffStackOffsetY'] = function(value)
            for j = 1, table.getn(setup.portraits) do
                local portrait = setup.portraits[j]
                if (frame.key == 'party' and string.find(portrait.unit, 'party')) or portrait.unit == frame.key then
                    for k = 1, table.getn(portrait.debuffs) do
                        local offsetX = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][frame.key..'DebuffStackOffsetX']) or 0
                        portrait.debuffs[k].count:ClearAllPoints()
                        portrait.debuffs[k].count:SetPoint('BOTTOMRIGHT', portrait.debuffs[k], 'BOTTOMRIGHT', offsetX, value)
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
                    local tex, glowTex, bgTex
                    if value == 'portrait_border_edge' then
                        tex = setup.textures.portraitBorder
                        glowTex = setup.textures.portraitBorderGlow
                        bgTex = setup.textures.portraitBorderEdgeBg
                    elseif value == 'portrait_border' then
                        tex = setup.textures.portraitBorderAlt1
                        glowTex = setup.textures.portraitBorderGlowAlt
                        bgTex = setup.textures.portraitBorderBg
                    elseif value == 'portrait_border_base' then
                        tex = setup.textures.portraitBorderAlt2
                        glowTex = setup.textures.portraitBorderGlowAlt
                        bgTex = setup.textures.portraitBorderBg
                    end
                    portrait.border:SetTexture(tex)
                    portrait.borderBg:SetTexture(bgTex)
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
                    local borderTexture = (DF_Profiles and DF.profile['unitframes'] and DF.profile['unitframes'][borderKey]) or 'portrait_border_edge'
                    if value then
                        portrait.border:SetTexCoord(1, 0, 0, 1)
                        portrait.borderBg:SetTexCoord(1, 0, 0, 1)
                        if borderTexture == 'portrait_border_edge' then
                            if portrait.model.combatGlow then portrait.model.combatGlow:SetTexCoord(1, 0, 0, 1) end
                            if portrait.model.restingGlow then portrait.model.restingGlow:SetTexCoord(1, 0, 0, 1) end
                        end
                    else
                        portrait.border:SetTexCoord(0, 1, 0, 1)
                        portrait.borderBg:SetTexCoord(0, 1, 0, 1)
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
DF.setups.unitframes = setup
