DRAGONFLIGHT()

local setup = {
    buttonWidth = 29,
    buttonHeight = 34,
    buttonSpacing = -12,
    buttons = {},
    eventFrame = nil,
    msIndicator = nil,

    buttonData = {
        {name = 'Character', icon = 'char', func = function() ToggleCharacter('PaperDollFrame') end, action = 'TOGGLECHARACTER0'},
        {name = 'Spellbook', icon = 'spellbook', func = function() ToggleSpellBook(BOOKTYPE_SPELL) end, action = 'TOGGLESPELLBOOK'},
        {name = 'Talents', icon = 'talents', func = function() ToggleTalentFrame() end, action = 'TOGGLETALENTS'},
        {name = 'QuestLog', icon = 'quest', func = function() ToggleQuestLog() end, action = 'TOGGLEQUESTLOG'},
        {name = 'Socials', icon = 'tabard', func = function() ToggleFriendsFrame() end, action = 'TOGGLESOCIAL'},
        {name = 'WorldMap', icon = 'shield', func = function() ToggleWorldMap() end, action = 'TOGGLEWORLDMAP'},
        {name = 'MainMenu', icon = 'wow', func = function() ToggleGameMenu(1) end, action = 'TOGGLEGAMEMENU'},
        {name = 'Help', icon = 'question', func = function() ToggleHelpFrame() end, action = 'TOGGLEHELP'}
    },
}

-- create
function setup:CreateButton(data, index, frame)
    local button = CreateFrame('Button', 'DF_MicroButton_' .. data.name, frame)
    button:SetWidth(self.buttonWidth)
    button:SetHeight(self.buttonHeight)
    -- debugframe(button)

    local xOffset = (index-1) * (self.buttonWidth + self.buttonSpacing)
    button:SetPoint('TOPLEFT', frame, 'TOPLEFT', xOffset, 5)

    button:SetNormalTexture(media['tex:micromenu:' .. data.icon .. '-regular.tga'])
    button:SetPushedTexture(media['tex:micromenu:' .. data.icon .. '-highlight.tga'])
    if data.name == 'Talents' and UnitLevel('player') < 10 then
        button:SetDisabledTexture(media['tex:micromenu:talents-disabled.tga'])
    else
        button:SetDisabledTexture(media['tex:micromenu:' .. data.icon .. '-faded.tga'])
    end
    button:SetHighlightTexture(media['tex:micromenu:' .. data.icon .. '-highlight.tga'])
    button:SetHitRectInsets(8, 8, 10, 10)

    button.hoverOverlay = button:CreateTexture(nil, 'HIGHLIGHT')
    button.hoverOverlay:SetTexture(media['tex:micromenu:micro_highlight.blp'])
    button.hoverOverlay:SetPoint('TOPLEFT', button, 'TOPLEFT', -9, 9)
    button.hoverOverlay:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 9, -9)
    button.hoverOverlay:SetBlendMode('ADD')
    button.hoverOverlay:SetAlpha(0.1)
    button.hoverOverlay:Hide()

    if data.name == 'Talents' and UnitLevel('player') < 10 then
        button:SetButtonState('DISABLED')
    end

    button.data = data

    button:SetScript('OnClick', function()
        button.data.func()
    end)

    button:SetScript('OnEnter', function()
        button.hoverOverlay:Show()
    end)
    button:SetScript('OnLeave', function()
        button.hoverOverlay:Hide()
    end)

    return button
end

function setup:CreateMicroMenu()
    local frame = CreateFrame('Frame', 'DF_MicroMenu', UIParent)
    frame:SetWidth((self.buttonWidth + self.buttonSpacing) * 9)
    frame:SetHeight(self.buttonHeight - 10)
    -- debugframe(frame)

    for i, data in ipairs(self.buttonData) do
        local button = self:CreateButton(data, i, frame)
        self.buttons[table.getn(self.buttons) + 1] = button
        if data.name == 'Help' then
            self.msIndicator = frame:CreateTexture(nil, 'OVERLAY')
            self.msIndicator:SetTexture('Interface\\Buttons\\White8x8')
            self.msIndicator:SetHeight(2)
            self.msIndicator:SetPoint('BOTTOMLEFT', button, 'BOTTOMLEFT', 8, 2)
            self.msIndicator:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -8, 2)
            self.msIndicator:SetVertexColor(0, 1, 0)
            -- debugframe(button)
        end
    end

    frame.expandButtonLeft = DF.ui.ExpandButton(frame, 23, 14, media['tex:bags:expand.tga'], function()
        local checked = this:GetChecked() and true or false
        DF:SetConfig('micro', 'expandButtons', checked)
    end, 'DF_MicroMenuExpandLeft', true)
    frame.expandButtonLeft:SetPoint('RIGHT', frame, 'LEFT', 3, 0)

    frame.expandButtonRight = DF.ui.ExpandButton(frame, 23, 14, media['tex:bags:expand.tga'], function()
        local checked = this:GetChecked() and true or false
        DF:SetConfig('micro', 'expandButtons', checked)
    end, 'DF_MicroMenuExpandRight', false)
    frame.expandButtonRight:SetPoint('LEFT', frame, 'RIGHT', 6, 0)

    frame.expandButton = frame.expandButtonLeft

    return frame
end

-- updates
function setup:UpdateButtonStates()
    for _, button in ipairs(self.buttons) do
        local data = button.data
        local isPushed = false

        if data.name == 'Character' and CharacterFrame:IsVisible() then
            isPushed = true
        elseif data.name == 'Spellbook' and SpellBookFrame:IsVisible() then
            isPushed = true
        elseif data.name == 'Talents' and _G.DF_TalentFrame and _G.DF_TalentFrame:IsVisible() then
            isPushed = true
        elseif data.name == 'QuestLog' and QuestLogFrame:IsVisible() then
            isPushed = true
        elseif data.name == 'Socials' and FriendsFrame:IsVisible() then
            isPushed = true
        elseif data.name == 'WorldMap' and WorldMapFrame:IsVisible() then
            isPushed = true
        elseif data.name == 'MainMenu' and (GameMenuFrame:IsVisible() or OptionsFrame:IsVisible()) then
            isPushed = true
        elseif data.name == 'Help' and HelpFrame:IsVisible() then
            isPushed = true
        end

        if data.name == 'Talents' and UnitLevel('player') < 10 then
            button:SetButtonState('DISABLED')
        elseif isPushed then
            button:SetButtonState('PUSHED', 1)
        else
            button:SetButtonState('NORMAL')
        end
    end
end

function setup:UpdateMS()
    local _, _, latency = GetNetStats()
    if self.msIndicator then
        if latency <= 50 then
            self.msIndicator:SetVertexColor(0, 1, 0)
        elseif latency <= 100 then
            self.msIndicator:SetVertexColor(1, 1, 0)
        else
            self.msIndicator:SetVertexColor(1, 0, 0)
        end
    end
end

-- events
function setup:OnEvent()
    self.eventFrame = CreateFrame('Frame')
    self.eventFrame:RegisterEvent('PLAYER_LEVEL_UP')
    self.eventFrame:SetScript('OnEvent', function()
        setup:UpdateButtonStates()
    end)

    self.eventFrame:SetScript('OnUpdate', function()
        if not this.msTimer then this.msTimer = 0 end
        this.msTimer = this.msTimer + arg1
        if this.msTimer >= 1 then
            this.msTimer = 0
            setup:UpdateMS()
        end
    end)

    DF.hooks.HookSecureFunc('UpdateMicroButtons', function()
        setup:UpdateButtonStates()
    end)
end

-- expose
DF.setups.micromenu = setup
