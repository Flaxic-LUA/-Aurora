DRAGONFLIGHT()

DF:NewDefaults('micro', {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {
        {tab = 'micromenu', 'General', 'Appearance'},
    },

    buttonSize = {value = 29, metadata = {element = 'slider', category = 'General', indexInCategory = 1, description = 'Micro menu button size', min = 20, max = 50, stepSize = 1}},
    buttonSpacing = {value = -12, metadata = {element = 'slider', category = 'General', indexInCategory = 2, description = 'Spacing between buttons', min = -20, max = 10, stepSize = 1}},
    showExpandButton = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 3, description = 'Show expand/collapse button'}},
    expandButtonRight = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 4, description = 'Position expand button on right side', dependency = {key = 'showExpandButton', state = true}}},
    expandButtons = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 5, description = 'Show or hide micro menu buttons'}},
    alpha = {value = 1, metadata = {element = 'slider', category = 'Appearance', indexInCategory = 1, description = 'Button transparency', min = 0, max = 1, stepSize = 0.1, dependency = {key = 'fadeOutDelay', state = 0}}},
    fadeOutDelay = {value = 0, metadata = {element = 'slider', category = 'Appearance', indexInCategory = 2, description = 'Fade out delay (0 = disabled)', min = 0, max = 10, stepSize = 0.5}},
    minAlpha = {value = 0.1, metadata = {element = 'slider', category = 'Appearance', indexInCategory = 3, description = 'Minimum alpha when faded', min = 0, max = 1, stepSize = 0.1}},
    buttonColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = 'Appearance', indexInCategory = 4, description = 'Color of micromenu buttons'}},
})

DF:NewModule('micro', 1, 'PLAYER_LOGIN', function()
    local setup = DF.setups.micromenu

    setup.frame = setup:CreateMicroMenu()
    setup:OnEvent()
    setup:UpdateButtonStates()
    setup.frame:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -40, 12)
    setup.frame:SetFrameStrata(UIParent:GetFrameStrata())
    setup.frame:SetFrameLevel(UIParent:GetFrameLevel() + 1)
    setup.frame:EnableMouse(true)

    -- callbacks
    local callbacks = {}
    local helpers = {}

    helpers.RepositionButtons = function()
        local size = DF.profile['micro']['buttonSize']
        local spacing = DF.profile['micro']['buttonSpacing']
        for i = 1, table.getn(setup.buttons) do
            local xOffset = (i - 1) * (size + spacing)
            setup.buttons[i]:ClearAllPoints()
            setup.buttons[i]:SetPoint('TOPLEFT', setup.frame, 'TOPLEFT', xOffset, 5)
        end
        setup.frame:SetWidth((size + spacing) * table.getn(setup.buttons))
    end

    helpers.ShowButtonTooltip = function(button)
        local data = button.data
        local globalName = string.upper(data.name)..'_BUTTON'
        if data.name == 'Spellbook' then globalName = 'SPELLBOOK_ABILITIES_BUTTON' end
        if data.name == 'Socials' then globalName = 'SOCIAL_BUTTON' end
        local tooltipText = _G[globalName] or data.name
        local keyBinding = GetBindingKey(data.action)
        if keyBinding then
            tooltipText = tooltipText..' '..NORMAL_FONT_COLOR_CODE..'('..keyBinding..')'..FONT_COLOR_CODE_CLOSE
        end
        local newbieName = data.name == 'Socials' and 'SOCIAL' or string.upper(data.name)
        local newbieText = _G['NEWBIE_TOOLTIP_'..newbieName]
        GameTooltip_AddNewbieTip(tooltipText, 1.0, 1.0, 1.0, newbieText)
    end

    helpers.HideTooltip = function()
        GameTooltip:Hide()
    end

    helpers.SetupFade = function()
        local delay = DF.profile['micro']['fadeOutDelay']
        if not setup.frame.originalScriptsStored then
            for i = 1, table.getn(setup.buttons) do
                setup.buttons[i].originalOnEnter = setup.buttons[i]:GetScript('OnEnter')
                setup.buttons[i].originalOnLeave = setup.buttons[i]:GetScript('OnLeave')
            end
            setup.frame.originalScriptsStored = true
        end
        if delay > 0 then
            for i = 1, table.getn(setup.buttons) do
                setup.buttons[i]:SetScript('OnEnter', function()
                    if this.originalOnEnter then this.originalOnEnter() end
                    helpers.ShowButtonTooltip(this)
                    if setup.frame.fadeTimer then
                        setup.frame.fadeTimer = nil
                    end
                    UIFrameFadeIn(setup.frame, 0.2, setup.frame:GetAlpha(), DF.profile['micro']['alpha'])
                end)
                setup.buttons[i]:SetScript('OnLeave', function()
                    if this.originalOnLeave then this.originalOnLeave() end
                    helpers.HideTooltip()
                    setup.frame.fadeTimer = delay
                    setup.frame:SetScript('OnUpdate', function()
                        if setup.frame.fadeTimer then
                            setup.frame.fadeTimer = setup.frame.fadeTimer - arg1
                            if setup.frame.fadeTimer <= 0 then
                                setup.frame.fadeTimer = nil
                                setup.frame:SetScript('OnUpdate', nil)
                                UIFrameFadeOut(setup.frame, 0.5, DF.profile['micro']['alpha'], DF.profile['micro']['minAlpha'])
                            end
                        end
                    end)
                end)
            end
            if not setup.frame.fadeEnabled then
                UIFrameFadeOut(setup.frame, 0.5, DF.profile['micro']['alpha'], DF.profile['micro']['minAlpha'])
            end
            setup.frame.fadeEnabled = true
        else
            setup.frame:SetScript('OnUpdate', nil)
            setup.frame.fadeTimer = nil
            setup.frame.fadeEnabled = nil
            for i = 1, table.getn(setup.buttons) do
                setup.buttons[i]:SetScript('OnEnter', function()
                    if this.originalOnEnter then this.originalOnEnter() end
                    helpers.ShowButtonTooltip(this)
                end)
                setup.buttons[i]:SetScript('OnLeave', function()
                    if this.originalOnLeave then this.originalOnLeave() end
                    helpers.HideTooltip()
                end)
            end
            setup.frame:SetAlpha(DF.profile['micro']['alpha'])
        end
    end

    callbacks.buttonSize = function(value)
        for i = 1, table.getn(setup.buttons) do
            setup.buttons[i]:SetSize(value, value * 1.17)
        end
        setup.frame.expandButtonLeft:SetSize(value * 0.79, value * 0.48)
        setup.frame.expandButtonRight:SetSize(value * 0.79, value * 0.48)
        helpers.RepositionButtons()
    end

    callbacks.buttonSpacing = function(value)
        helpers.RepositionButtons()
    end

    callbacks.alpha = function(value)
        if DF.profile['micro']['fadeOutDelay'] == 0 then
            setup.frame:SetAlpha(value)
        end
    end

    callbacks.fadeOutDelay = function(value)
        helpers.SetupFade()
    end

    callbacks.minAlpha = function(value)
    end

    callbacks.showExpandButton = function(value)
        if value then
            if DF.profile['micro']['expandButtonRight'] then
                setup.frame.expandButtonRight:Show()
                setup.frame.expandButtonLeft:Hide()
            else
                setup.frame.expandButtonLeft:Show()
                setup.frame.expandButtonRight:Hide()
            end
        else
            setup.frame.expandButtonLeft:Hide()
            setup.frame.expandButtonRight:Hide()
        end
    end

    callbacks.expandButtons = function(value)
        setup.frame.expandButtonLeft:SetChecked(value)
        setup.frame.expandButtonRight:SetChecked(value)
        for _, button in ipairs(setup.buttons) do
            if value then
                button:Show()
            else
                button:Hide()
            end
        end
        if value then
            setup.msIndicator:Show()
        else
            setup.msIndicator:Hide()
        end
    end

    callbacks.buttonColour = function(value)
        for _, button in ipairs(setup.buttons) do
            button:GetNormalTexture():SetVertexColor(value[1], value[2], value[3], value[4])
            button:GetPushedTexture():SetVertexColor(value[1], value[2], value[3], value[4])
            button:GetDisabledTexture():SetVertexColor(value[1], value[2], value[3], value[4])
        end
    end

    callbacks.expandButtonRight = function(value)
        if value then
            setup.frame.expandButtonLeft:Hide()
            setup.frame.expandButtonRight:Show()
        else
            setup.frame.expandButtonRight:Hide()
            setup.frame.expandButtonLeft:Show()
        end
    end

    DF:NewCallbacks('micro', callbacks)
end)
