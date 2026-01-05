DRAGONFLIGHT()

DF:NewDefaults('ambient', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'extras', subtab = 'ambient', 'Normal Mode', 'Combat Mode', 'Resting Mode'},
    },

    enableNormal = {value = true, metadata = {element = 'checkbox', category = 'Normal Mode', indexInCategory = 1, description = 'Enable normal mode'}},
    normalColor = {value = {0, 0, 0}, metadata = {element = 'colorpicker', category = 'Normal Mode', indexInCategory = 2, description = 'Normal mode color'}},
    normalDimensions = {value = 8, metadata = {element = 'slider', category = 'Normal Mode', indexInCategory = 3, description = 'Normal border thickness', min = 3, max = 50, stepSize = 1}},
    normalShowTop = {value = true, metadata = {element = 'checkbox', category = 'Normal Mode', indexInCategory = 4, description = 'Show top'}},
    normalShowBottom = {value = true, metadata = {element = 'checkbox', category = 'Normal Mode', indexInCategory = 5, description = 'Show bottom'}},
    normalShowLeft = {value = true, metadata = {element = 'checkbox', category = 'Normal Mode', indexInCategory = 6, description = 'Show left'}},
    normalShowRight = {value = true, metadata = {element = 'checkbox', category = 'Normal Mode', indexInCategory = 7, description = 'Show right'}},

    enableCombat = {value = true, metadata = {element = 'checkbox', category = 'Combat Mode', indexInCategory = 1, description = 'Enable combat mode'}},
    combatColor = {value = {1, 0, 0}, metadata = {element = 'colorpicker', category = 'Combat Mode', indexInCategory = 2, description = 'Combat mode color'}},
    combatDimensions = {value = 12, metadata = {element = 'slider', category = 'Combat Mode', indexInCategory = 3, description = 'Combat border thickness', min = 3, max = 50, stepSize = 1}},
    combatShowTop = {value = false, metadata = {element = 'checkbox', category = 'Combat Mode', indexInCategory = 4, description = 'Show top'}},
    combatShowBottom = {value = true, metadata = {element = 'checkbox', category = 'Combat Mode', indexInCategory = 5, description = 'Show bottom'}},
    combatShowLeft = {value = false, metadata = {element = 'checkbox', category = 'Combat Mode', indexInCategory = 6, description = 'Show left'}},
    combatShowRight = {value = false, metadata = {element = 'checkbox', category = 'Combat Mode', indexInCategory = 7, description = 'Show right'}},

    enableResting = {value = true, metadata = {element = 'checkbox', category = 'Resting Mode', indexInCategory = 1, description = 'Enable resting mode'}},
    restingColor = {value = {0, 1, 1}, metadata = {element = 'colorpicker', category = 'Resting Mode', indexInCategory = 2, description = 'Resting mode color'}},
    restingDimensions = {value = 8, metadata = {element = 'slider', category = 'Resting Mode', indexInCategory = 3, description = 'Resting border thickness', min = 3, max = 50, stepSize = 1}},
    restingShowTop = {value = false, metadata = {element = 'checkbox', category = 'Resting Mode', indexInCategory = 4, description = 'Show top'}},
    restingShowBottom = {value = true, metadata = {element = 'checkbox', category = 'Resting Mode', indexInCategory = 5, description = 'Show bottom'}},
    restingShowLeft = {value = false, metadata = {element = 'checkbox', category = 'Resting Mode', indexInCategory = 6, description = 'Show left'}},
    restingShowRight = {value = false, metadata = {element = 'checkbox', category = 'Resting Mode', indexInCategory = 7, description = 'Show right'}},

})

DF:NewModule('ambient', 1, function()
    local frame = CreateFrame("Frame", "DF_AmbientFrame", UIParent)
    frame:SetFrameStrata("BACKGROUND")
    frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
    frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

    local top = frame:CreateTexture(nil, "BACKGROUND")
    top:SetTexture("Interface\\Buttons\\WHITE8X8")
    top:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    top:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    top:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0.7)

    local bottom = frame:CreateTexture(nil, "BACKGROUND")
    bottom:SetTexture("Interface\\Buttons\\WHITE8X8")
    bottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    bottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    bottom:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.7, 0, 0, 0, 0)

    local left = frame:CreateTexture(nil, "BACKGROUND")
    left:SetTexture("Interface\\Buttons\\WHITE8X8")
    left:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    left:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    left:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.7, 0, 0, 0, 0)

    local right = frame:CreateTexture(nil, "BACKGROUND")
    right:SetTexture("Interface\\Buttons\\WHITE8X8")
    right:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    right:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    right:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0, 0, 0, 0, 0.7)

    local inCombat = false
    local isResting = false

    local callbacks = {}
    local callbackHelper = {}

    callbackHelper.UpdateAmbient = function()
        local p = DF.profile.ambient
        local color, dimensions, showTop, showBottom, showLeft, showRight

        if inCombat and p.enableCombat then
            color = p.combatColor
            dimensions = p.combatDimensions
            showTop = p.combatShowTop
            showBottom = p.combatShowBottom
            showLeft = p.combatShowLeft
            showRight = p.combatShowRight
        elseif isResting and p.enableResting then
            color = p.restingColor
            dimensions = p.restingDimensions
            showTop = p.restingShowTop
            showBottom = p.restingShowBottom
            showLeft = p.restingShowLeft
            showRight = p.restingShowRight
        elseif p.enableNormal then
            color = p.normalColor
            dimensions = p.normalDimensions
            showTop = p.normalShowTop
            showBottom = p.normalShowBottom
            showLeft = p.normalShowLeft
            showRight = p.normalShowRight
        else
            top:Hide()
            bottom:Hide()
            left:Hide()
            right:Hide()
            return
        end

        top:SetGradientAlpha('VERTICAL', color[1], color[2], color[3], 0, color[1], color[2], color[3], 0.7)
        bottom:SetGradientAlpha('VERTICAL', color[1], color[2], color[3], 0.7, color[1], color[2], color[3], 0)
        left:SetGradientAlpha('HORIZONTAL', color[1], color[2], color[3], 0.7, color[1], color[2], color[3], 0)
        right:SetGradientAlpha('HORIZONTAL', color[1], color[2], color[3], 0, color[1], color[2], color[3], 0.7)
        top:SetHeight(dimensions)
        bottom:SetHeight(dimensions)
        left:SetWidth(dimensions)
        right:SetWidth(dimensions)

        if showTop then top:Show() else top:Hide() end
        if showBottom then bottom:Show() else bottom:Hide() end
        if showLeft then left:Show() else left:Hide() end
        if showRight then right:Show() else right:Hide() end
    end

    callbacks.enableNormal = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.enableCombat = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.enableResting = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.normalColor = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.combatColor = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.restingColor = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.normalDimensions = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.combatDimensions = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.restingDimensions = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.normalShowTop = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.normalShowBottom = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.normalShowLeft = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.normalShowRight = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.combatShowTop = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.combatShowBottom = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.combatShowLeft = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.combatShowRight = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.restingShowTop = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.restingShowBottom = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.restingShowLeft = function(value)
        callbackHelper.UpdateAmbient()
    end

    callbacks.restingShowRight = function(value)
        callbackHelper.UpdateAmbient()
    end

    -- events
    local eventFrame = CreateFrame('Frame')
    eventFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
    eventFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
    eventFrame:RegisterEvent('PLAYER_UPDATE_RESTING')

    eventFrame:SetScript('OnEvent', function()
        if event == 'PLAYER_REGEN_DISABLED' then
            inCombat = true
        elseif event == 'PLAYER_REGEN_ENABLED' then
            inCombat = false
        elseif event == 'PLAYER_UPDATE_RESTING' then
            isResting = IsResting()
        end
        callbackHelper.UpdateAmbient()
    end)

    DF:NewCallbacks('ambient', callbacks)
end)
