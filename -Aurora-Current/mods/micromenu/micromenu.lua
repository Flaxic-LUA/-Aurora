UNLOCKAURORA()

AU:NewDefaults('micro', {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {
        {tab = 'extras', subtab = 'micromenu', 'General', 'Appearance'},
    },

    buttonSize = {value = 29, metadata = {element = 'slider', category = 'General', indexInCategory = 1, description = 'Micro menu button size', min = 20, max = 50, stepSize = 1}},
    buttonSpacing = {value = -12, metadata = {element = 'slider', category = 'General', indexInCategory = 2, description = 'Spacing between buttons', min = -20, max = 10, stepSize = 1}},
    showExpandButton = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 3, description = 'Show expand/collapse button'}},
    expandButtons = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 4, description = 'Show or hide micro menu buttons'}},
    alpha = {value = 1, metadata = {element = 'slider', category = 'Appearance', indexInCategory = 1, description = 'Button transparency', min = 0, max = 1, stepSize = 0.1, dependency = {key = 'fadeOutDelay', state = 0}}},
    fadeOutDelay = {value = 0, metadata = {element = 'slider', category = 'Appearance', indexInCategory = 2, description = 'Fade out delay (0 = disabled)', min = 0, max = 10, stepSize = 0.5}},
    minAlpha = {value = 0.1, metadata = {element = 'slider', category = 'Appearance', indexInCategory = 3, description = 'Minimum alpha when faded', min = 0, max = 1, stepSize = 0.1}},
})

AU:NewModule('micro', 1, 'PLAYER_LOGIN', function()
    local setup = AU.setups.micromenu

    setup.frame = setup:CreateMicroMenu()
    setup:OnEvent()
    setup:UpdateButtonStates()
    setup.frame:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOM', 280, 17)
    setup.frame:SetFrameStrata(UIParent:GetFrameStrata())
    setup.frame:SetFrameLevel(UIParent:GetFrameLevel() + 1)
    setup.frame:EnableMouse(true)

    -- callbacks
    local callbacks = {}
    local helpers = {}

    helpers.RepositionButtons = function()
        local size = AU.profile['micro']['buttonSize']
        local spacing = AU.profile['micro']['buttonSpacing']
        for i = 1, table.getn(setup.buttons) do
            local xOffset = (i - 1) * (size + spacing)
            setup.buttons[i]:ClearAllPoints()
            setup.buttons[i]:SetPoint('TOPLEFT', setup.frame, 'TOPLEFT', xOffset, 5)
        end
        setup.frame:SetWidth((size + spacing) * table.getn(setup.buttons))
    end

    helpers.SetupFade = function()
        local delay = AU.profile['micro']['fadeOutDelay']
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
                    if setup.frame.fadeTimer then
                        setup.frame.fadeTimer = nil
                    end
                    UIFrameFadeIn(setup.frame, 0.2, setup.frame:GetAlpha(), AU.profile['micro']['alpha'])
                end)
                setup.buttons[i]:SetScript('OnLeave', function()
                    if this.originalOnLeave then this.originalOnLeave() end
                    setup.frame.fadeTimer = delay
                    setup.frame:SetScript('OnUpdate', function()
                        if setup.frame.fadeTimer then
                            setup.frame.fadeTimer = setup.frame.fadeTimer - arg1
                            if setup.frame.fadeTimer <= 0 then
                                setup.frame.fadeTimer = nil
                                setup.frame:SetScript('OnUpdate', nil)
                                UIFrameFadeOut(setup.frame, 0.5, AU.profile['micro']['alpha'], AU.profile['micro']['minAlpha'])
                            end
                        end
                    end)
                end)
            end
            if not setup.frame.fadeEnabled then
                UIFrameFadeOut(setup.frame, 0.5, AU.profile['micro']['alpha'], AU.profile['micro']['minAlpha'])
            end
            setup.frame.fadeEnabled = true
        else
            setup.frame:SetScript('OnUpdate', nil)
            setup.frame.fadeTimer = nil
            setup.frame.fadeEnabled = nil
            for i = 1, table.getn(setup.buttons) do
                setup.buttons[i]:SetScript('OnEnter', setup.buttons[i].originalOnEnter)
                setup.buttons[i]:SetScript('OnLeave', setup.buttons[i].originalOnLeave)
            end
            setup.frame:SetAlpha(AU.profile['micro']['alpha'])
        end
    end

    callbacks.buttonSize = function(value)
        for i = 1, table.getn(setup.buttons) do
            setup.buttons[i]:SetSize(value, value * 1.17)
        end
        setup.frame.expandButton:SetSize(value * 0.79, value * 0.48)
        helpers.RepositionButtons()
    end

    callbacks.buttonSpacing = function(value)
        helpers.RepositionButtons()
    end

    callbacks.alpha = function(value)
        if AU.profile['micro']['fadeOutDelay'] == 0 then
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
            setup.frame.expandButton:Show()
        else
            setup.frame.expandButton:Hide()
        end
    end

    callbacks.expandButtons = function(value)
        setup.frame.expandButton:SetChecked(value)
        if value then
            setup.frame.expandButton:GetNormalTexture():SetTexCoord(1, 0, 0, 1)
            setup.frame.expandButton:GetHighlightTexture():SetTexCoord(1, 0, 0, 1)
        else
            setup.frame.expandButton:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
            setup.frame.expandButton:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
        end
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

    AU:NewCallbacks('micro', callbacks)
end)
