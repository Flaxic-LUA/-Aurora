UNLOCKDRAGONFLIGHT()
if not dependency('UnitXP') then return end

DF:NewDefaults('tooltip', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'tooltip', 'General'},
    },
    tooltipMouseAnchor = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Anchor tooltip to mouse cursor'}},
    tooltipOffsetX = {value = 35, metadata = {element = 'slider', category = 'General', indexInCategory = 2, description = 'Tooltip X offset', min = -100, max = 100, stepSize = 1, dependency = {key = 'tooltipMouseAnchor', state = true}}},
    tooltipOffsetY = {value = 10, metadata = {element = 'slider', category = 'General', indexInCategory = 3, description = 'Tooltip Y offset', min = -100, max = 100, stepSize = 1, dependency = {key = 'tooltipMouseAnchor', state = true}}},
    tooltipHideHealthBar = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 4, description = 'Hide tooltip healthbar'}},
    tooltipHealthText = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 5, description = 'Show HP text on healthbar', dependency = {key = 'tooltipHideHealthBar', stateNot = true}}},
    tooltipBorderColor = {value = {0.2, 0.4, 0.8}, metadata = {element = 'colorpicker', category = 'General', indexInCategory = 6, description = 'Tooltip border color'}},
    tooltipScale = {value = .8, metadata = {element = 'slider', category = 'General', indexInCategory = 7, description = 'Tooltip scale', min = 0.5, max = 2.0, stepSize = 0.05}},
    tooltipBorderAlpha = {value = .8, metadata = {element = 'slider', category = 'General', indexInCategory = 8, description = 'Tooltip border alpha', min = 0.0, max = 1.0, stepSize = 0.05}},
    tooltipBgAlpha = {value = 1, metadata = {element = 'slider', category = 'General', indexInCategory = 9, description = 'Tooltip background alpha', min = 0.0, max = 1.0, stepSize = 0.05}},
    tooltipBarTexture = {value = 'Dragonflight', metadata = {element = 'dropdown', category = 'General', indexInCategory = 10, description = 'Healthbar texture', options = {'Default', 'Dragonflight'}, dependency = {key = 'tooltipHideHealthBar', stateNot = true}}},
    tooltipBarHeight = {value = 15, metadata = {element = 'slider', category = 'General', indexInCategory = 11, description = 'Healthbar height', min = 4, max = 20, stepSize = 1, dependency = {key = 'tooltipHideHealthBar', stateNot = true}}},
    tooltipBarWidth = {value = -5, metadata = {element = 'slider', category = 'General', indexInCategory = 12, description = 'Healthbar width offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'tooltipHideHealthBar', stateNot = true}}},
    tooltipTextFont = {value = 'font:Hooge.ttf', metadata = {element = 'dropdown', category = 'General', indexInCategory = 13, description = 'HP text font', options = media.fonts, dependency = {key = 'tooltipHealthText', state = true}}},
    tooltipTextColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'General', indexInCategory = 14, description = 'HP text color', dependency = {key = 'tooltipHealthText', state = true}}},
    tooltipTextPosition = {value = 'CENTER', metadata = {element = 'dropdown', category = 'General', indexInCategory = 15, description = 'HP text position', options = {'LEFT', 'CENTER', 'RIGHT'}, dependency = {key = 'tooltipHealthText', state = true}}},
    tooltipTextFormat = {value = 'cur/max', metadata = {element = 'dropdown', category = 'General', indexInCategory = 16, description = 'HP text format', options = {'cur', 'cur/max', 'cur/max/percent'}, dependency = {key = 'tooltipHealthText', state = true}}},
    tooltipShowTarget = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 17, description = 'Show unit target'}},
    tooltipShowDistance = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 18, description = 'Show distance'}},

})

DF:NewModule('tooltip', 1, 'PLAYER_ENTERING_WORLD', function()
    local origSetDefaultAnchor = _G.GameTooltip_SetDefaultAnchor

    GameTooltip:SetScript('OnShow', function()
        if GameTooltip:GetAnchorType() ~= 'ANCHOR_NONE' then return end
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -25, 35)
    end)

    local cursorFrame = CreateFrame('Frame', nil, UIParent)
    cursorFrame:SetSize(1, 1)

    local callbacks = {}
    local callbackHelper = {definesomethinginheredirectly}
    local offsetX, offsetY
    local borderColor
    local borderAlpha, bgAlpha
    local textFont, textColor, textPosition, textFormat
    local showTarget, showDistance
    local distanceLineIndex

    DF.hooks.HookScript(GameTooltip, 'OnShow', function()
        if borderColor and borderAlpha then
            GameTooltip:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderAlpha)
        end
        if bgAlpha then
            GameTooltip:SetBackdropColor(0, 0, 0, bgAlpha)
        end
        if UnitExists('mouseover') then
            if showTarget then
                local targetName = UnitName('mouseovertarget')
                if targetName then
                    GameTooltip:AddLine('Target: '..targetName, 1, 1, 1)
                end
            end
            if showDistance then
                local dist = UnitXP('distanceBetween', 'player', 'mouseover')
                if dist then
                    GameTooltip:AddLine('Distance: '..string.format('%.1f', dist)..'y', 1, 1, 1)
                    distanceLineIndex = GameTooltip:NumLines()
                end
            end
            if showTarget or showDistance then
                GameTooltip:Show()
            end
        end
    end, true)

    DF.hooks.HookScript(GameTooltip, 'OnUpdate', function()
        if showDistance and distanceLineIndex and UnitExists('mouseover') then
            local dist = UnitXP('distanceBetween', 'player', 'mouseover')
            if dist then
                local line = getglobal('GameTooltipTextLeft'..distanceLineIndex)
                if line then
                    line:SetText('Distance: '..string.format('%.1f', dist)..'y')
                end
            end
        end
    end, true)

    DF.hooks.HookScript(GameTooltip, 'OnHide', function()
        distanceLineIndex = nil
    end, true)

    callbacks.tooltipMouseAnchor = function(value)
        if value then
            cursorFrame:SetScript('OnUpdate', function()
                local scale = UIParent:GetScale()
                local x, y = GetCursorPosition()
                this:ClearAllPoints()
                this:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', x/scale, y/scale)
            end)
            _G.GameTooltip_SetDefaultAnchor = function(frame, parent)
                frame:SetOwner(parent, 'ANCHOR_CURSOR')
                frame:SetPoint('BOTTOMLEFT', cursorFrame, 'CENTER', offsetX or 0, offsetY or 0)
            end
        else
            cursorFrame:SetScript('OnUpdate', nil)
            _G.GameTooltip_SetDefaultAnchor = origSetDefaultAnchor
        end
    end

    callbacks.tooltipOffsetX = function(value)
        offsetX = value
    end

    callbacks.tooltipOffsetY = function(value)
        offsetY = value
    end

    callbacks.tooltipHideHealthBar = function(value)
        if value then
            GameTooltipStatusBar:Hide()
            GameTooltipStatusBar:SetScript('OnShow', function() this:Hide() end)
        else
            GameTooltipStatusBar:SetScript('OnShow', nil)
        end
    end

    callbacks.tooltipHealthText = function(value)
        if value then
            if not GameTooltipStatusBar.text then
                GameTooltipStatusBar.text = GameTooltipStatusBar:CreateFontString(nil, 'OVERLAY')
                local font = DF.profile['tooltip'].tooltipTextFont
                GameTooltipStatusBar.text:SetFont(media[font], 12, 'OUTLINE')
                GameTooltipStatusBar.text:SetPoint('CENTER', GameTooltipStatusBar, 'CENTER', 0, 0)
                local color = DF.profile['tooltip'].tooltipTextColor
                GameTooltipStatusBar.text:SetTextColor(color[1], color[2], color[3])
            end
            GameTooltipStatusBar:SetScript('OnValueChanged', function()
                HealthBar_OnValueChanged(arg1)
                local min, max = this:GetMinMaxValues()
                local cur = this:GetValue()
                if cur > 0 and textFormat then
                    if textFormat == 'cur' then
                        this.text:SetText(DF.math.abbreviate(cur))
                    elseif textFormat == 'cur/max' then
                        this.text:SetText(DF.math.abbreviate(cur)..'/'..DF.math.abbreviate(max))
                    elseif textFormat == 'cur/max/percent' then
                        local pct = math.floor(cur/max*100)
                        this.text:SetText(DF.math.abbreviate(cur)..'/'..DF.math.abbreviate(max)..' ('..pct..'%)')
                    end
                else
                    this.text:SetText('')
                end
            end)
        else
            if GameTooltipStatusBar.text then
                GameTooltipStatusBar.text:SetText('')
            end
            GameTooltipStatusBar:SetScript('OnValueChanged', function()
                HealthBar_OnValueChanged(arg1)
            end)
        end
    end

    callbacks.tooltipBorderColor = function(value)
        borderColor = value
        if borderAlpha then
            GameTooltip:SetBackdropBorderColor(value[1], value[2], value[3], borderAlpha)
        end
    end

    callbacks.tooltipScale = function(value)
        GameTooltip:SetScale(value)
    end

    callbacks.tooltipBorderAlpha = function(value)
        borderAlpha = value
        if borderColor then
            GameTooltip:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], value)
        end
    end

    callbacks.tooltipBgAlpha = function(value)
        bgAlpha = value
        GameTooltip:SetBackdropColor(0, 0, 0, value)
    end

    callbacks.tooltipBarTexture = function(value)
        if value == 'Dragonflight' then
            GameTooltipStatusBar:SetStatusBarTexture(media['tex:unitframes:aurora_hpbar.tga'])
        else
            GameTooltipStatusBar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
        end
    end

    callbacks.tooltipBarHeight = function(value)
        GameTooltipStatusBar:SetHeight(value)
        local widthOffset = DF.profile['tooltip'].tooltipBarWidth
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint('TOPLEFT', GameTooltip, 'BOTTOMLEFT', -widthOffset, 0)
        GameTooltipStatusBar:SetPoint('TOPRIGHT', GameTooltip, 'BOTTOMRIGHT', widthOffset, 0)
    end

    callbacks.tooltipBarWidth = function(value)
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint('TOPLEFT', GameTooltip, 'BOTTOMLEFT', -value, 0)
        GameTooltipStatusBar:SetPoint('TOPRIGHT', GameTooltip, 'BOTTOMRIGHT', value, 0)
    end

    callbacks.tooltipTextFont = function(value)
        textFont = value
        if GameTooltipStatusBar.text then
            GameTooltipStatusBar.text:SetFont(media[value], 12, 'OUTLINE')
        end
    end

    callbacks.tooltipTextColor = function(value)
        textColor = value
        if GameTooltipStatusBar.text then
            GameTooltipStatusBar.text:SetTextColor(value[1], value[2], value[3])
        end
    end

    callbacks.tooltipTextPosition = function(value)
        textPosition = value
        if GameTooltipStatusBar.text then
            GameTooltipStatusBar.text:ClearAllPoints()
            GameTooltipStatusBar.text:SetPoint(value, GameTooltipStatusBar, value, 0, 0)
        end
    end

    callbacks.tooltipTextFormat = function(value)
        textFormat = value
    end

    callbacks.tooltipShowTarget = function(value)
        showTarget = value
    end

    callbacks.tooltipShowDistance = function(value)
        showDistance = value
    end

    DF:NewCallbacks('tooltip', callbacks)
end)
