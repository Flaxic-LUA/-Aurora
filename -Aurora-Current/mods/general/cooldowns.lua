UNLOCKAURORA()

AU:NewDefaults('cooldowns', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'extras', subtab = 'cooldowns', 'General'},
    },

    showText = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Show cooldown numbers on buttons'}},
    textSize = {value = 14, metadata = {element = 'slider', category = 'General', indexInCategory = 2, description = 'Cooldown text size', min = 8, max = 32, stepSize = 1, dependency = {key = 'showText', state = true}}},
    textFont = {value = 'font:FRIZQT__.TTF', metadata = {element = 'dropdown', category = 'General', indexInCategory = 3, description = 'Cooldown text font', options = media.fonts, dependency = {key = 'showText', state = true}}},
    colorByTime = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 4, description = 'Color text by remaining time (red <10s, yellow <30s, white otherwise)', dependency = {key = 'showText', state = true}}},
    showSeconds = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 5, description = 'Show seconds for minutes (2:30 instead of 2m)', dependency = {key = 'showText', state = true}}},

})

AU:NewModule('cooldowns', 1, function()
    local allCooldownTexts = {}

    local function GetTimeString(seconds)
        if seconds >= 86400 then
            return string.format('%dd', seconds / 86400)
        elseif seconds >= 3600 then
            return string.format('%dh', seconds / 3600)
        elseif seconds >= 60 then
            if AU.profile.cooldowns.showSeconds then
                return string.format('%d:%02d', seconds / 60, math.mod(seconds, 60))
            else
                return string.format('%dm', seconds / 60)
            end
        else
            return string.format('%d', seconds)
        end
    end

    local function OnUpdate()
        if (this.tick or .1) > GetTime() then return else this.tick = GetTime() + .1 end
        local remaining = this.duration - (GetTime() - this.start)
        if remaining >= 0 and remaining >= 1.5 then
            local font, size = this.text:GetFont()
            if not font then
                this.text:SetFont('Fonts\\FRIZQT__.TTF', 14, 'OUTLINE')
            end
            this.text:SetText(GetTimeString(remaining))
            if AU.profile.cooldowns.colorByTime then
                if remaining < 10 then
                    this.text:SetTextColor(1, 0, 0)
                elseif remaining < 30 then
                    this.text:SetTextColor(1, 1, 0)
                else
                    this.text:SetTextColor(1, 1, 1)
                end
            else
                this.text:SetTextColor(1, 1, 1)
            end
        else
            this:Hide()
        end
    end

    local function CreateCooldownText(cooldown)
        local frame = CreateFrame('Frame', nil, cooldown:GetParent())
        frame:SetAllPoints(cooldown)
        frame:SetFrameLevel(cooldown:GetParent():GetFrameLevel() + 2)
        frame.text = frame:CreateFontString(nil, 'OVERLAY')
        local fontKey = AU.profile and AU.profile.cooldowns and AU.profile.cooldowns.textFont or 'font:FRIZQT__.TTF'
        local font = (media and media[fontKey]) or 'Fonts\\FRIZQT__.TTF'
        local size = (AU.profile and AU.profile.cooldowns and AU.profile.cooldowns.textSize) or 14
        frame.text:SetFont(font, size, 'OUTLINE')
        frame.text:SetPoint('CENTER', 0, 0)
        frame:SetScript('OnUpdate', OnUpdate)
        table.insert(allCooldownTexts, frame)
        return frame
    end

    AU.hooks.HookSecureFunc('CooldownFrame_SetTimer', function(cooldownFrame, start, duration, enable)
        if not AU.profile.cooldowns.showText then
            if cooldownFrame.cdText then cooldownFrame.cdText:Hide() end
            return
        end
        if start == 0 or duration == 0 or duration < 1.5 then
            if cooldownFrame.cdText then cooldownFrame.cdText:Hide() end
            return
        end
        if not cooldownFrame.cdText then
            cooldownFrame.cdText = CreateCooldownText(cooldownFrame)
        end
        cooldownFrame.cdText.start = start
        cooldownFrame.cdText.duration = duration
        cooldownFrame.cdText:Show()
    end)

    local callbacks = {}

    callbacks.showText = function(value)
        for _, frame in pairs(allCooldownTexts) do
            if value then
                if frame.start and frame.duration then frame:Show() end
            else
                frame:Hide()
            end
        end
    end

    callbacks.textSize = function(value)
        for _, frame in pairs(allCooldownTexts) do
            local font = media[AU.profile.cooldowns.textFont] or 'Fonts\\FRIZQT__.TTF'
            frame.text:SetFont(font, value, 'OUTLINE')
        end
    end

    callbacks.textFont = function(value)
        for _, frame in pairs(allCooldownTexts) do
            local font = media[value] or 'Fonts\\FRIZQT__.TTF'
            frame.text:SetFont(font, AU.profile.cooldowns.textSize or 14, 'OUTLINE')
        end
    end

    callbacks.colorByTime = function(value)
        -- color will update on next OnUpdate tick
    end

    callbacks.showSeconds = function(value)
        -- format will update on next OnUpdate tick
    end

    AU:NewCallbacks('cooldowns', callbacks)
end)
