UNLOCKAURORA()

AU:NewDefaults('xprep', {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {
        {tab = 'xpbar', subtab = 'xpbar', 'XP General', 'XP Size', 'XP Appearance', 'XP Text', 'XP Rested'},
        {tab = 'xpbar', subtab = 'repbar', 'Rep General', 'Rep Size', 'Rep Appearance', 'Rep Text', 'Rep Faction'},
    },

    xpBarEnabled = {value = true, metadata = {element = 'checkbox', category = 'XP General', indexInCategory = 1, description = 'Toggle visibility of the experience bar'}},
    xpBarFadeOutDelay = {value = 0, metadata = {element = 'slider', category = 'XP General', indexInCategory = 2, description = 'Seconds before fading out after mouse leaves (0 = disabled)', min = 0, max = 10, stepSize = 0.5, dependency = {key = 'xpBarEnabled', state = true}}},
    xpBarWidth = {value = 350, metadata = {element = 'slider', category = 'XP Size', indexInCategory = 1, description = 'Width of the experience bar', min = 100, max = 800, stepSize = 10, dependency = {key = 'xpBarEnabled', state = true}}},
    xpBarHeight = {value = 6, metadata = {element = 'slider', category = 'XP Size', indexInCategory = 2, description = 'Height of the experience bar', min = 2, max = 32, stepSize = 1, dependency = {key = 'xpBarEnabled', state = true}}},
    xpBarAlpha = {value = 1, metadata = {element = 'slider', category = 'XP Appearance', indexInCategory = 1, description = 'Transparency of the experience bar', min = 0, max = 1, stepSize = 0.1, dependency = {key = 'xpBarEnabled', state = true}}},
    xpBarColour = {value = {0.6, 0.2, 0.8, 1}, metadata = {element = 'colorpicker', category = 'XP Appearance', indexInCategory = 2, description = 'Color of the experience bar', dependency = {key = 'xpBarEnabled', state = true}}},
    xpBarPulse = {value = true, metadata = {element = 'checkbox', category = 'XP Appearance', indexInCategory = 3, description = 'Enable pulse animation on XP gain', dependency = {key = 'xpBarEnabled', state = true}}},
    xpBarPulseColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = 'XP Appearance', indexInCategory = 4, description = 'Pulse color for XP bar', dependency = {key = 'xpBarPulse', state = true}}},
    xpBarShowText = {value = true, metadata = {element = 'checkbox', category = 'XP Text', indexInCategory = 1, description = 'Show experience points on the bar', dependency = {key = 'xpBarEnabled', state = true}}},
    xpBarTextFormat = {value = 'value + percent', metadata = {element = 'dropdown', category = 'XP Text', indexInCategory = 2, description = 'Text format for experience bar', options = {'value', 'value + percent', 'percent'}, dependency = {key = 'xpBarShowText', state = true}}},
    xpBarTextFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'XP Text', indexInCategory = 3, description = 'Font for experience bar text', options = media.fonts, dependency = {key = 'xpBarShowText', state = true}}},
    xpBarTextSize = {value = 12, metadata = {element = 'slider', category = 'XP Text', indexInCategory = 4, description = 'Font size for experience bar text', min = 6, max = 20, stepSize = 1, dependency = {key = 'xpBarShowText', state = true}}},
    xpBarTextColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = 'XP Text', indexInCategory = 5, description = 'Color for experience bar text', dependency = {key = 'xpBarShowText', state = true}}},
    xpBarTextAnchor = {value = 'CENTER', metadata = {element = 'dropdown', category = 'XP Text', indexInCategory = 6, description = 'Text anchor position', options = {'LEFT', 'CENTER', 'RIGHT'}, dependency = {key = 'xpBarShowText', state = true}}},
    xpBarTextOffsetX = {value = 0, metadata = {element = 'slider', category = 'XP Text', indexInCategory = 7, description = 'X offset for XP text', min = -100, max = 100, stepSize = 1, dependency = {key = 'xpBarShowText', state = true}}},
    xpBarTextOffsetY = {value = 0, metadata = {element = 'slider', category = 'XP Text', indexInCategory = 8, description = 'Y offset for XP text', min = -100, max = 100, stepSize = 1, dependency = {key = 'xpBarShowText', state = true}}},
    xpBarShowTextOnGainOnly = {value = true, metadata = {element = 'checkbox', category = 'XP Text', indexInCategory = 9, description = 'Show text only for 10 seconds after gaining XP', dependency = {key = 'xpBarShowText', state = true}}},
    xpBarShowRested = {value = true, metadata = {element = 'checkbox', category = 'XP Rested', indexInCategory = 1, description = 'Show rested XP on the bar', dependency = {key = 'xpBarEnabled', state = true}}},
    xpBarRestedFormat = {value = 'value + percent', metadata = {element = 'dropdown', category = 'XP Rested', indexInCategory = 2, description = 'Text format for rested XP', options = {'value', 'value + percent', 'percent'}, dependency = {key = 'xpBarShowRested', state = true}}},
    xpBarRestedFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'XP Rested', indexInCategory = 3, description = 'Font for rested XP text', options = media.fonts, dependency = {key = 'xpBarShowRested', state = true}}},
    xpBarRestedSize = {value = 12, metadata = {element = 'slider', category = 'XP Rested', indexInCategory = 4, description = 'Font size for rested XP text', min = 6, max = 20, stepSize = 1, dependency = {key = 'xpBarShowRested', state = true}}},
    xpBarRestedColour = {value = {0.33, 0.33, 1, 1}, metadata = {element = 'colorpicker', category = 'XP Rested', indexInCategory = 5, description = 'Color for rested XP text', dependency = {key = 'xpBarShowRested', state = true}}},
    xpBarRestedAnchor = {value = 'RIGHT', metadata = {element = 'dropdown', category = 'XP Rested', indexInCategory = 6, description = 'Rested text anchor position', options = {'LEFT', 'CENTER', 'RIGHT'}, dependency = {key = 'xpBarShowRested', state = true}}},
    xpBarRestedOffsetX = {value = -2, metadata = {element = 'slider', category = 'XP Rested', indexInCategory = 7, description = 'X offset for rested text', min = -100, max = 100, stepSize = 1, dependency = {key = 'xpBarShowRested', state = true}}},
    xpBarRestedOffsetY = {value = 0, metadata = {element = 'slider', category = 'XP Rested', indexInCategory = 8, description = 'Y offset for rested text', min = -100, max = 100, stepSize = 1, dependency = {key = 'xpBarShowRested', state = true}}},

    repBarEnabled = {value = true, metadata = {element = 'checkbox', category = 'Rep General', indexInCategory = 1, description = 'Toggle visibility of the reputation bar'}},
    repBarFadeOutDelay = {value = 0, metadata = {element = 'slider', category = 'Rep General', indexInCategory = 2, description = 'Seconds before fading out after mouse leaves (0 = disabled)', min = 0, max = 10, stepSize = 0.5, dependency = {key = 'repBarEnabled', state = true}}},
    repBarWidth = {value = 200, metadata = {element = 'slider', category = 'Rep Size', indexInCategory = 1, description = 'Width of the reputation bar', min = 100, max = 800, stepSize = 10, dependency = {key = 'repBarEnabled', state = true}}},
    repBarHeight = {value = 6, metadata = {element = 'slider', category = 'Rep Size', indexInCategory = 2, description = 'Height of the reputation bar', min = 2, max = 32, stepSize = 1, dependency = {key = 'repBarEnabled', state = true}}},
    repBarAlpha = {value = 1, metadata = {element = 'slider', category = 'Rep Appearance', indexInCategory = 1, description = 'Transparency of the reputation bar', min = 0, max = 1, stepSize = 0.1, dependency = {key = 'repBarEnabled', state = true}}},
    repBarPulse = {value = true, metadata = {element = 'checkbox', category = 'Rep Appearance', indexInCategory = 2, description = 'Enable pulse animation on reputation gain', dependency = {key = 'repBarEnabled', state = true}}},
    repBarPulseColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = 'Rep Appearance', indexInCategory = 3, description = 'Pulse color for reputation bar', dependency = {key = 'repBarPulse', state = true}}},
    repBarOverrideColour = {value = false, metadata = {element = 'checkbox', category = 'Rep Appearance', indexInCategory = 4, description = 'Override standing colors with custom color', dependency = {key = 'repBarEnabled', state = true}}},
    repBarCustomColour = {value = {0, 0.6, 0.8, 1}, metadata = {element = 'colorpicker', category = 'Rep Appearance', indexInCategory = 5, description = 'Custom color for reputation bar', dependency = {key = 'repBarOverrideColour', state = true}}},
    repBarShowText = {value = true, metadata = {element = 'checkbox', category = 'Rep Text', indexInCategory = 1, description = 'Show reputation points on the bar', dependency = {key = 'repBarEnabled', state = true}}},
    repBarTextFormat = {value = 'value + percent', metadata = {element = 'dropdown', category = 'Rep Text', indexInCategory = 2, description = 'Text format for reputation bar', options = {'value', 'value + percent', 'percent'}, dependency = {key = 'repBarShowText', state = true}}},
    repBarTextFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'Rep Text', indexInCategory = 3, description = 'Font for reputation bar text', options = media.fonts, dependency = {key = 'repBarShowText', state = true}}},
    repBarTextSize = {value = 12, metadata = {element = 'slider', category = 'Rep Text', indexInCategory = 4, description = 'Font size for reputation bar text', min = 6, max = 20, stepSize = 1, dependency = {key = 'repBarShowText', state = true}}},
    repBarTextColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = 'Rep Text', indexInCategory = 5, description = 'Color for reputation bar text', dependency = {key = 'repBarShowText', state = true}}},
    repBarTextAnchor = {value = 'CENTER', metadata = {element = 'dropdown', category = 'Rep Text', indexInCategory = 6, description = 'Text anchor position', options = {'LEFT', 'CENTER', 'RIGHT'}, dependency = {key = 'repBarShowText', state = true}}},
    repBarTextOffsetX = {value = 0, metadata = {element = 'slider', category = 'Rep Text', indexInCategory = 7, description = 'X offset for reputation text', min = -100, max = 100, stepSize = 1, dependency = {key = 'repBarShowText', state = true}}},
    repBarTextOffsetY = {value = 0, metadata = {element = 'slider', category = 'Rep Text', indexInCategory = 8, description = 'Y offset for reputation text', min = -100, max = 100, stepSize = 1, dependency = {key = 'repBarShowText', state = true}}},
    repBarShowTextOnGainOnly = {value = true, metadata = {element = 'checkbox', category = 'Rep Text', indexInCategory = 9, description = 'Show text only for 10 seconds after gaining reputation', dependency = {key = 'repBarShowText', state = true}}},
    repBarShowFactionName = {value = true, metadata = {element = 'checkbox', category = 'Rep Faction', indexInCategory = 1, description = 'Show faction name on the bar', dependency = {key = 'repBarEnabled', state = true}}},
    repBarFactionNameFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'Rep Faction', indexInCategory = 2, description = 'Font for faction name', options = media.fonts, dependency = {key = 'repBarShowFactionName', state = true}}},
    repBarFactionNameSize = {value = 12, metadata = {element = 'slider', category = 'Rep Faction', indexInCategory = 3, description = 'Font size for faction name', min = 6, max = 20, stepSize = 1, dependency = {key = 'repBarShowFactionName', state = true}}},
    repBarFactionNameColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = 'Rep Faction', indexInCategory = 4, description = 'Color for faction name', dependency = {key = 'repBarShowFactionName', state = true}}},
    repBarFactionNameAnchor = {value = 'LEFT', metadata = {element = 'dropdown', category = 'Rep Faction', indexInCategory = 5, description = 'Faction name anchor position', options = {'LEFT', 'CENTER', 'RIGHT'}, dependency = {key = 'repBarShowFactionName', state = true}}},
    repBarFactionNameOffsetX = {value = 2, metadata = {element = 'slider', category = 'Rep Faction', indexInCategory = 6, description = 'X offset for faction name', min = -100, max = 100, stepSize = 1, dependency = {key = 'repBarShowFactionName', state = true}}},
    repBarFactionNameOffsetY = {value = 0, metadata = {element = 'slider', category = 'Rep Faction', indexInCategory = 7, description = 'Y offset for faction name', min = -100, max = 100, stepSize = 1, dependency = {key = 'repBarShowFactionName', state = true}}},
})

AU:NewModule('xprep', 1, 'PLAYER_ENTERING_WORLD', function()
    local xpbar = AU.animations.CreateStatusBar(UIParent, AU.profile['xprep']['xpBarWidth'], AU.profile['xprep']['xpBarHeight'], {pulse = AU.profile['xprep']['xpBarPulse']}, 'AU_XPBar')
    xpbar:SetTextures(media['tex:generic:xpbar_1.blp'], media['tex:generic:xpbar_1_bg.blp'])
    xpbar:SetPoint('BOTTOM', UIParent, 'BOTTOM', -0, 135)
    local color = AU.profile['xprep']['xpBarColour']
    xpbar:SetFillColor(color[1], color[2], color[3], color[4])
    local pulseColor = AU.profile['xprep']['xpBarPulseColour']
    xpbar:SetPulseColor(pulseColor[1], pulseColor[2], pulseColor[3], pulseColor[4])
    xpbar:SetAlpha(AU.profile['xprep']['xpBarAlpha'])
    xpbar:EnableMouse(true)
    xpbar:SetFrameStrata('BACKGROUND')
    if not AU.profile['xprep']['xpBarEnabled'] then
        xpbar:Hide()
    end

    local xpText = xpbar:CreateFontString(nil, 'OVERLAY')
    local xpFont = AU.profile['xprep']['xpBarTextFont']
    if strfind(xpFont, 'font:') then
        xpFont = media[xpFont]
    end
    xpText:SetFont(xpFont, AU.profile['xprep']['xpBarTextSize'], 'OUTLINE')
    xpText:SetPoint(AU.profile['xprep']['xpBarTextAnchor'], xpbar, AU.profile['xprep']['xpBarTextAnchor'], AU.profile['xprep']['xpBarTextOffsetX'], AU.profile['xprep']['xpBarTextOffsetY'])
    local xpColor = AU.profile['xprep']['xpBarTextColour']
    xpText:SetTextColor(xpColor[1], xpColor[2], xpColor[3], xpColor[4])

    local xpRestedText = xpbar:CreateFontString(nil, 'OVERLAY')
    local restedFont = AU.profile['xprep']['xpBarRestedFont']
    if strfind(restedFont, 'font:') then
        restedFont = media[restedFont]
    end
    xpRestedText:SetFont(restedFont, AU.profile['xprep']['xpBarRestedSize'], 'OUTLINE')
    xpRestedText:SetPoint(AU.profile['xprep']['xpBarRestedAnchor'], xpbar, AU.profile['xprep']['xpBarRestedAnchor'], AU.profile['xprep']['xpBarRestedOffsetX'], AU.profile['xprep']['xpBarRestedOffsetY'])
    local restedColor = AU.profile['xprep']['xpBarRestedColour']
    xpRestedText:SetTextColor(restedColor[1], restedColor[2], restedColor[3], restedColor[4])

    local repbar = AU.animations.CreateStatusBar(UIParent, AU.profile['xprep']['repBarWidth'], AU.profile['xprep']['repBarHeight'], {pulse = AU.profile['xprep']['repBarPulse']}, 'AU_RepBar')
    repbar:SetTextures(media['tex:generic:xpbar_1.blp'], media['tex:generic:xpbar_1_bg.blp'])
    repbar:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOM', 250, 15)
    repbar:SetAlpha(AU.profile['xprep']['repBarAlpha'])
    local repPulseColor = AU.profile['xprep']['repBarPulseColour']
    repbar:SetPulseColor(repPulseColor[1], repPulseColor[2], repPulseColor[3], repPulseColor[4])
    repbar:EnableMouse(true)
    repbar:SetFrameStrata('BACKGROUND')
    if not AU.profile['xprep']['repBarEnabled'] then
        repbar:Hide()
    end

    local repText = repbar:CreateFontString(nil, 'OVERLAY')
    local repFont = AU.profile['xprep']['repBarTextFont']
    if strfind(repFont, 'font:') then
        repFont = media[repFont]
    end
    repText:SetFont(repFont, AU.profile['xprep']['repBarTextSize'], 'OUTLINE')
    repText:SetPoint(AU.profile['xprep']['repBarTextAnchor'], repbar, AU.profile['xprep']['repBarTextAnchor'], AU.profile['xprep']['repBarTextOffsetX'], AU.profile['xprep']['repBarTextOffsetY'])
    local repColor = AU.profile['xprep']['repBarTextColour']
    repText:SetTextColor(repColor[1], repColor[2], repColor[3], repColor[4])

    local repFactionText = repbar:CreateFontString(nil, 'OVERLAY')
    local factionFont = AU.profile['xprep']['repBarFactionNameFont']
    if strfind(factionFont, 'font:') then
        factionFont = media[factionFont]
    end
    repFactionText:SetFont(factionFont, AU.profile['xprep']['repBarFactionNameSize'], 'OUTLINE')
    repFactionText:SetPoint(AU.profile['xprep']['repBarFactionNameAnchor'], repbar, AU.profile['xprep']['repBarFactionNameAnchor'], AU.profile['xprep']['repBarFactionNameOffsetX'], AU.profile['xprep']['repBarFactionNameOffsetY'])
    local factionColor = AU.profile['xprep']['repBarFactionNameColour']
    repFactionText:SetTextColor(factionColor[1], factionColor[2], factionColor[3], factionColor[4])

    local lastXP = UnitXP('player')
    local repName, repStanding, repMin, repMax, repValue = GetWatchedFactionInfo()
    local lastRep = repValue or 0
    local xpTextHideTimer = nil
    local repTextHideTimer = nil

    local function UpdateXP()
        if UnitLevel('player') == 60 then
            xpbar:Hide()
            return
        end
        if AU.profile['xprep']['xpBarEnabled'] then
            xpbar:Show()
        end
        local xp = UnitXP('player')
        local maxxp = UnitXPMax('player')
        xpbar.max = maxxp
        xpbar:SetValue(xp)

        if xp ~= lastXP then
            lastXP = xp
            if AU.profile['xprep']['xpBarShowTextOnGainOnly'] then
                xpTextHideTimer = 10
            end
        end

        if AU.profile['xprep']['xpBarShowText'] then
            local text
            local format = AU.profile['xprep']['xpBarTextFormat']
            if format == 'percent' then
                local percent = math.floor((xp / maxxp) * 100)
                text = percent .. '%'
            elseif format == 'value' then
                text = xp .. ' / ' .. maxxp
            else
                local percent = math.floor((xp / maxxp) * 100)
                text = xp .. ' / ' .. maxxp .. ' (' .. percent .. '%)'
            end
            xpText:SetText(text)
            if AU.profile['xprep']['xpBarShowTextOnGainOnly'] then
                if xpTextHideTimer and xpTextHideTimer > 0 then
                    xpText:Show()
                else
                    xpText:Hide()
                end
            else
                xpText:Show()
            end
        else
            xpText:Hide()
        end

        local rested = GetXPExhaustion()
        if rested and AU.profile['xprep']['xpBarShowRested'] then
            local text
            local format = AU.profile['xprep']['xpBarRestedFormat']
            if format == 'percent' then
                local percent = math.floor((rested / maxxp) * 100)
                text = '+' .. percent .. '%'
            elseif format == 'value' then
                text = '+' .. rested
            else
                local percent = math.floor((rested / maxxp) * 100)
                text = '+' .. rested .. ' (' .. percent .. '%)'
            end
            xpRestedText:SetText(text)
            if AU.profile['xprep']['xpBarShowTextOnGainOnly'] then
                if xpTextHideTimer and xpTextHideTimer > 0 then
                    xpRestedText:Show()
                else
                    xpRestedText:Hide()
                end
            else
                xpRestedText:Show()
            end
        else
            xpRestedText:Hide()
        end
    end

    local function UpdateRep()
        local name, standing, min, max, value = GetWatchedFactionInfo()
        if name then
            if AU.profile['xprep']['repBarEnabled'] then
                repbar:Show()
            end
            if max == min then max = min + 1 end
            repbar.max = max
            repbar.min = min
            repbar:SetValue(value)

            if value ~= lastRep then
                lastRep = value
                if AU.profile['xprep']['repBarShowTextOnGainOnly'] then
                    repTextHideTimer = 10
                end
            end

            if AU.profile['xprep']['repBarOverrideColour'] then
                local customColor = AU.profile['xprep']['repBarCustomColour']
                repbar:SetFillColor(customColor[1], customColor[2], customColor[3], customColor[4])
            else
                if standing == 1 or standing == 2 then
                    repbar:SetFillColor(0.8, 0, 0, 1)
                elseif standing == 3 then
                    repbar:SetFillColor(0.8, 0.3, 0, 1)
                elseif standing == 4 then
                    repbar:SetFillColor(1, 0.82, 0, 1)
                elseif standing == 5 then
                    repbar:SetFillColor(0.0, 0.6, 0.1, 1)
                elseif standing == 6 then
                    repbar:SetFillColor(0, 0.7, 0.1, 1)
                elseif standing == 7 then
                    repbar:SetFillColor(0, 0.8, 0.1, 1)
                elseif standing == 8 then
                    repbar:SetFillColor(0, 0.8, 0.5, 1)
                end
            end

            if AU.profile['xprep']['repBarShowFactionName'] then
                repFactionText:SetText(name)
                if AU.profile['xprep']['repBarShowTextOnGainOnly'] then
                    if repTextHideTimer and repTextHideTimer > 0 then
                        repFactionText:Show()
                    else
                        repFactionText:Hide()
                    end
                else
                    repFactionText:Show()
                end
            else
                repFactionText:Hide()
            end

            if AU.profile['xprep']['repBarShowText'] then
                local current = value - min
                local total = max - min
                local text
                local format = AU.profile['xprep']['repBarTextFormat']
                if format == 'percent' then
                    local percent = math.floor((current / total) * 100)
                    text = percent .. '%'
                elseif format == 'value' then
                    text = current .. ' / ' .. total
                else
                    local percent = math.floor((current / total) * 100)
                    text = current .. ' / ' .. total .. ' (' .. percent .. '%)'
                end
                repText:SetText(text)
                if AU.profile['xprep']['repBarShowTextOnGainOnly'] then
                    if repTextHideTimer and repTextHideTimer > 0 then
                        repText:Show()
                    else
                        repText:Hide()
                    end
                else
                    repText:Show()
                end
            else
                repText:Hide()
            end
        else
            repbar:Hide()
            repText:Hide()
            repFactionText:Hide()
        end
    end

    local f = CreateFrame('Frame')
    f:RegisterEvent('PLAYER_XP_UPDATE')
    f:RegisterEvent('PLAYER_LEVEL_UP')
    f:RegisterEvent('UPDATE_EXHAUSTION')
    f:RegisterEvent('UPDATE_FACTION')
    f:SetScript('OnEvent', function()
        if event == 'UPDATE_FACTION' then
            UpdateRep()
        else
            UpdateXP()
        end
    end)
    f:SetScript('OnUpdate', function()
        if xpTextHideTimer and xpTextHideTimer > 0 then
            xpTextHideTimer = xpTextHideTimer - arg1
            if xpTextHideTimer <= 0 then
                xpTextHideTimer = 0
                UpdateXP()
            end
        end
        if repTextHideTimer and repTextHideTimer > 0 then
            repTextHideTimer = repTextHideTimer - arg1
            if repTextHideTimer <= 0 then
                repTextHideTimer = 0
                UpdateRep()
            end
        end
    end)

    UpdateXP()
    UpdateRep()

    -- callbacks
    local helpers = {
        SetupBarFade = function(frame, delayKey, alphaKey, isXP)
            local delay = AU.profile['xprep'][delayKey]
            local wasEnabled = frame.fadeEnabled
            if delay > 0 then
                frame:SetScript('OnEnter', function()
                    if frame.fadeTimer then
                        frame.fadeTimer = nil
                    end
                    UIFrameFadeIn(frame, 0.2, frame:GetAlpha(), AU.profile['xprep'][alphaKey])
                    if isXP then
                        xpText:Show()
                        xpRestedText:Show()
                    else
                        repText:Show()
                        repFactionText:Show()
                    end
                end)
                frame:SetScript('OnLeave', function()
                    if isXP then
                        xpText:Hide()
                        xpRestedText:Hide()
                    else
                        repText:Hide()
                        repFactionText:Hide()
                    end
                    frame.fadeTimer = delay
                    frame:SetScript('OnUpdate', function()
                        if frame.fadeTimer then
                            frame.fadeTimer = frame.fadeTimer - arg1
                            if frame.fadeTimer <= 0 then
                                frame.fadeTimer = nil
                                frame:SetScript('OnUpdate', nil)
                                UIFrameFadeOut(frame, 0.5, AU.profile['xprep'][alphaKey], 0)
                            end
                        end
                    end)
                end)
                frame.fadeEnabled = true
                if not wasEnabled then
                    UIFrameFadeOut(frame, 0.5, AU.profile['xprep'][alphaKey], 0)
                end
            else
                frame:SetScript('OnEnter', function()
                    if isXP then
                        xpText:Show()
                        xpRestedText:Show()
                    else
                        repText:Show()
                        repFactionText:Show()
                    end
                end)
                frame:SetScript('OnLeave', function()
                    if isXP then
                        xpText:Hide()
                        xpRestedText:Hide()
                    else
                        repText:Hide()
                        repFactionText:Hide()
                    end
                end)
                frame:SetScript('OnUpdate', nil)
                frame.fadeTimer = nil
                frame.fadeEnabled = nil
                frame:SetAlpha(AU.profile['xprep'][alphaKey])
            end
        end
    }
    local callbacks = {}

    helpers.SetupBarFade(xpbar, 'xpBarFadeOutDelay', 'xpBarAlpha', true)
    helpers.SetupBarFade(repbar, 'repBarFadeOutDelay', 'repBarAlpha', false)

    callbacks.xpBarEnabled = function(value)
        if value and UnitLevel('player') ~= 60 then
            xpbar:Show()
        else
            xpbar:Hide()
        end
    end

    callbacks.xpBarWidth = function(value)
        xpbar:SetWidth(value)
    end

    callbacks.xpBarHeight = function(value)
        xpbar:SetHeight(value)
    end

    callbacks.xpBarAlpha = function(value)
        xpbar:SetAlpha(value)
    end

    callbacks.xpBarColour = function(value)
        xpbar:SetFillColor(value[1], value[2], value[3], value[4])
    end

    callbacks.repBarEnabled = function(value)
        if value then
            UpdateRep()
        else
            repbar:Hide()
        end
    end

    callbacks.repBarWidth = function(value)
        repbar:SetWidth(value)
    end

    callbacks.repBarHeight = function(value)
        repbar:SetHeight(value)
    end

    callbacks.repBarAlpha = function(value)
        repbar:SetAlpha(value)
    end

    callbacks.xpBarShowText = function(value)
        UpdateXP()
    end

    callbacks.xpBarTextFormat = function(value)
        UpdateXP()
    end

    callbacks.repBarShowText = function(value)
        UpdateRep()
    end

    callbacks.repBarTextFormat = function(value)
        UpdateRep()
    end

    callbacks.xpBarTextFont = function(value)
        local font = value
        if strfind(font, 'font:') then
            font = media[font]
        end
        xpText:SetFont(font, AU.profile['xprep']['xpBarTextSize'], 'OUTLINE')
    end

    callbacks.xpBarTextSize = function(value)
        local font = AU.profile['xprep']['xpBarTextFont']
        if strfind(font, 'font:') then
            font = media[font]
        end
        xpText:SetFont(font, value, 'OUTLINE')
    end

    callbacks.xpBarTextColour = function(value)
        xpText:SetTextColor(value[1], value[2], value[3], value[4])
    end

    callbacks.xpBarTextAnchor = function(value)
        xpText:ClearAllPoints()
        xpText:SetPoint(value, xpbar, value, AU.profile['xprep']['xpBarTextOffsetX'], AU.profile['xprep']['xpBarTextOffsetY'])
    end

    callbacks.xpBarTextOffsetX = function(value)
        xpText:ClearAllPoints()
        xpText:SetPoint(AU.profile['xprep']['xpBarTextAnchor'], xpbar, AU.profile['xprep']['xpBarTextAnchor'], value, AU.profile['xprep']['xpBarTextOffsetY'])
    end

    callbacks.xpBarTextOffsetY = function(value)
        xpText:ClearAllPoints()
        xpText:SetPoint(AU.profile['xprep']['xpBarTextAnchor'], xpbar, AU.profile['xprep']['xpBarTextAnchor'], AU.profile['xprep']['xpBarTextOffsetX'], value)
    end

    callbacks.xpBarShowRested = function(value)
        UpdateXP()
    end

    callbacks.xpBarRestedFormat = function(value)
        UpdateXP()
    end

    callbacks.xpBarRestedFont = function(value)
        local font = value
        if strfind(font, 'font:') then
            font = media[font]
        end
        xpRestedText:SetFont(font, AU.profile['xprep']['xpBarRestedSize'], 'OUTLINE')
    end

    callbacks.xpBarRestedSize = function(value)
        local font = AU.profile['xprep']['xpBarRestedFont']
        if strfind(font, 'font:') then
            font = media[font]
        end
        xpRestedText:SetFont(font, value, 'OUTLINE')
    end

    callbacks.xpBarRestedColour = function(value)
        xpRestedText:SetTextColor(value[1], value[2], value[3], value[4])
    end

    callbacks.xpBarRestedAnchor = function(value)
        xpRestedText:ClearAllPoints()
        xpRestedText:SetPoint(value, xpbar, value, AU.profile['xprep']['xpBarRestedOffsetX'], AU.profile['xprep']['xpBarRestedOffsetY'])
    end

    callbacks.xpBarRestedOffsetX = function(value)
        xpRestedText:ClearAllPoints()
        xpRestedText:SetPoint(AU.profile['xprep']['xpBarRestedAnchor'], xpbar, AU.profile['xprep']['xpBarRestedAnchor'], value, AU.profile['xprep']['xpBarRestedOffsetY'])
    end

    callbacks.xpBarRestedOffsetY = function(value)
        xpRestedText:ClearAllPoints()
        xpRestedText:SetPoint(AU.profile['xprep']['xpBarRestedAnchor'], xpbar, AU.profile['xprep']['xpBarRestedAnchor'], AU.profile['xprep']['xpBarRestedOffsetX'], value)
    end

    callbacks.repBarTextFont = function(value)
        local font = value
        if strfind(font, 'font:') then
            font = media[font]
        end
        repText:SetFont(font, AU.profile['xprep']['repBarTextSize'], 'OUTLINE')
    end

    callbacks.repBarTextSize = function(value)
        local font = AU.profile['xprep']['repBarTextFont']
        if strfind(font, 'font:') then
            font = media[font]
        end
        repText:SetFont(font, value, 'OUTLINE')
    end

    callbacks.repBarTextColour = function(value)
        repText:SetTextColor(value[1], value[2], value[3], value[4])
    end

    callbacks.repBarTextAnchor = function(value)
        repText:ClearAllPoints()
        repText:SetPoint(value, repbar, value, AU.profile['xprep']['repBarTextOffsetX'], AU.profile['xprep']['repBarTextOffsetY'])
    end

    callbacks.repBarTextOffsetX = function(value)
        repText:ClearAllPoints()
        repText:SetPoint(AU.profile['xprep']['repBarTextAnchor'], repbar, AU.profile['xprep']['repBarTextAnchor'], value, AU.profile['xprep']['repBarTextOffsetY'])
    end

    callbacks.repBarTextOffsetY = function(value)
        repText:ClearAllPoints()
        repText:SetPoint(AU.profile['xprep']['repBarTextAnchor'], repbar, AU.profile['xprep']['repBarTextAnchor'], AU.profile['xprep']['repBarTextOffsetX'], value)
    end

    callbacks.xpBarFadeOutDelay = function(value)
        helpers.SetupBarFade(xpbar, 'xpBarFadeOutDelay', 'xpBarAlpha', true)
    end

    callbacks.repBarFadeOutDelay = function(value)
        helpers.SetupBarFade(repbar, 'repBarFadeOutDelay', 'repBarAlpha', false)
    end

    callbacks.xpBarPulse = function(value)
        xpbar:SetPulseAnimation(value)
    end

    callbacks.xpBarPulseColour = function(value)
        xpbar:SetPulseColor(value[1], value[2], value[3], value[4])
    end

    callbacks.repBarPulse = function(value)
        repbar:SetPulseAnimation(value)
    end

    callbacks.repBarPulseColour = function(value)
        repbar:SetPulseColor(value[1], value[2], value[3], value[4])
    end

    callbacks.repBarOverrideColour = function(value)
        UpdateRep()
    end

    callbacks.repBarCustomColour = function(value)
        if AU.profile['xprep']['repBarOverrideColour'] then
            repbar:SetFillColor(value[1], value[2], value[3], value[4])
        end
    end

    callbacks.xpBarShowTextOnGainOnly = function(value)
        if not value then
            xpTextHideTimer = nil
        end
        UpdateXP()
    end

    callbacks.repBarShowTextOnGainOnly = function(value)
        if not value then
            repTextHideTimer = nil
        end
        UpdateRep()
    end

    callbacks.repBarShowFactionName = function(value)
        UpdateRep()
    end

    callbacks.repBarFactionNameFont = function(value)
        local font = value
        if strfind(font, 'font:') then
            font = media[font]
        end
        repFactionText:SetFont(font, AU.profile['xprep']['repBarFactionNameSize'], 'OUTLINE')
    end

    callbacks.repBarFactionNameSize = function(value)
        local font = AU.profile['xprep']['repBarFactionNameFont']
        if strfind(font, 'font:') then
            font = media[font]
        end
        repFactionText:SetFont(font, value, 'OUTLINE')
    end

    callbacks.repBarFactionNameColour = function(value)
        repFactionText:SetTextColor(value[1], value[2], value[3], value[4])
    end

    callbacks.repBarFactionNameAnchor = function(value)
        repFactionText:ClearAllPoints()
        repFactionText:SetPoint(value, repbar, value, AU.profile['xprep']['repBarFactionNameOffsetX'], AU.profile['xprep']['repBarFactionNameOffsetY'])
    end

    callbacks.repBarFactionNameOffsetX = function(value)
        repFactionText:ClearAllPoints()
        repFactionText:SetPoint(AU.profile['xprep']['repBarFactionNameAnchor'], repbar, AU.profile['xprep']['repBarFactionNameAnchor'], value, AU.profile['xprep']['repBarFactionNameOffsetY'])
    end

    callbacks.repBarFactionNameOffsetY = function(value)
        repFactionText:ClearAllPoints()
        repFactionText:SetPoint(AU.profile['xprep']['repBarFactionNameAnchor'], repbar, AU.profile['xprep']['repBarFactionNameAnchor'], AU.profile['xprep']['repBarFactionNameOffsetX'], value)
    end

    AU:NewCallbacks('xprep', callbacks)
end)
