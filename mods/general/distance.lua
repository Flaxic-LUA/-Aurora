UNLOCKDRAGONFLIGHT()
if not dependency('UnitXP') then return end

DF:NewDefaults('distance', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'extras', subtab = 'distance', 'General', 'Bars'},
    },

    attackableOnly = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Show only for attackable units'}},
    showPortrait = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 2, description = 'Show target portrait'}},
    showDecimals = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 3, description = 'Show decimal places'}},
    textSize = {value = 21, metadata = {element = 'slider', category = 'General', indexInCategory = 4, description = 'Text size', min = 8, max = 24, stepSize = 1}},
    textFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'General', indexInCategory = 5, description = 'Distance text font', options = media.fonts}},
    bgAlpha = {value = 0.2, metadata = {element = 'slider', category = 'General', indexInCategory = 6, description = 'Background opacity', min = 0, max = 1, stepSize = 0.05}},
    portraitSpacing = {value = 0.1, metadata = {element = 'slider', category = 'General', indexInCategory = 7, description = 'Portrait spacing', min = 0.1, max = 5, stepSize = 0.1}},
    showBars = {value = true, metadata = {element = 'checkbox', category = 'Bars', indexInCategory = 1, description = 'Show side bars'}},
    barWidth = {value = 30, metadata = {element = 'slider', category = 'Bars', indexInCategory = 2, description = 'Bar width', min = 10, max = 100, stepSize = 5, dependency = {key = 'showBars', state = true}}},
    barHeight = {value = 10, metadata = {element = 'slider', category = 'Bars', indexInCategory = 3, description = 'Bar height', min = 5, max = 30, stepSize = 1, dependency = {key = 'showBars', state = true}}},
    barRepeat = {value = true, metadata = {element = 'checkbox', category = 'Bars', indexInCategory = 4, description = 'Repeat bar animation', dependency = {key = 'showBars', state = true}}},
    barAnimInterval = {value = 0.05, metadata = {element = 'slider', category = 'Bars', indexInCategory = 5, description = 'Animation smoothness (lower = smoother)', min = 0.01, max = 0.1, stepSize = 0.01, }},
    barInstant = {value = false, metadata = {element = 'checkbox', category = 'Bars', indexInCategory = 6, description = 'Instant bar fill (no animation)', dependency = {key = 'barRepeat', state = false}}},
    barColorByRange = {value = true, metadata = {element = 'checkbox', category = 'Bars', indexInCategory = 7, description = 'Color bars by distance range', dependency = {key = 'showBars', state = true}}},
    distanceMode = {value = 'Melee', metadata = {element = 'dropdown', category = 'Bars', indexInCategory = 8, description = 'Distance color mode', options = {'Melee', 'Ranged'}, dependency = {key = 'barColorByRange', state = true}}},
    extendedRange = {value = false, metadata = {element = 'checkbox', category = 'Bars', indexInCategory = 9, description = 'Extended range (20-40 yards green)', dependency = {key = 'distanceMode', state = 'Ranged'}}},
    colorText = {value = true, metadata = {element = 'checkbox', category = 'Bars', indexInCategory = 10, description = 'Color distance text by range', dependency = {key = 'barColorByRange', state = true}}},

})

DF:NewModule('distance', 1, function()
    local frameWidth = 60
    local frameHeight = 20
    local framePadding = 5
    local portraitSize = frameHeight - 5
    local fontSize = frameHeight - 8

    local distanceRanges = {
        {min = 0, max = 5, name = 'melee'},
        {min = 5, max = 10, name = 'close'},
        {min = 10, max = 20, name = 'medium'},
        {min = 20, max = 30, name = 'long'},
        {min = 30, max = 40, name = 'max'},
        {min = 40, max = 999, name = 'out'}
    }

    local distFrame = CreateFrame('Frame', 'DF_DistanceFrame', UIParent)
    distFrame:RegisterEvent('PLAYER_TARGET_CHANGED')
    distFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, -220)
    distFrame:SetSize(frameWidth, frameHeight)
    distFrame:Hide()
    local bg = distFrame:CreateTexture(nil, 'BACKGROUND')
    bg:SetTexture(media['tex:generic:distance_bg.blp'])
    bg:SetAllPoints(distFrame)
    bg:SetVertexColor(1, 1, 1, 0.2)

    local portrait = CreateFrame('PlayerModel', nil, distFrame)
    portrait:SetSize(portraitSize, portraitSize)
    portrait:SetPoint('LEFT', distFrame, 'LEFT', framePadding, 0)

    local distText = DF.ui.Font(distFrame, fontSize, '0', {1, 1, 1}, 'LEFT')
    distText:SetPoint('RIGHT', distFrame, 'RIGHT', -framePadding, 0)

    local leftBar = DF.animations.CreateStatusBar(distFrame, 30, 10, {barAnim = false, pulse = false, cutout = false})
    leftBar:SetPoint('RIGHT', distFrame, 'LEFT', -framePadding, 0)
    leftBar:SetTextures(media['tex:generic:xpbar_1.blp'], media['tex:generic:xpbar_1_bg.blp'])
    leftBar:SetFillDirection('RIGHT_TO_LEFT')
    leftBar.max = 100
    leftBar:SetValue(0, true)

    local rightBar = DF.animations.CreateStatusBar(distFrame, 30, 10, {barAnim = false, pulse = false, cutout = false})
    rightBar:SetPoint('LEFT', distFrame, 'RIGHT', framePadding, 0)
    rightBar:SetTextures(media['tex:generic:xpbar_1.blp'], media['tex:generic:xpbar_1_bg.blp'])
    rightBar.max = 100
    rightBar:SetValue(0, true)

    distFrame.fillTimer = nil
    distFrame.barRepeat = true
    distFrame.barInstant = false
    distFrame.barColorByRange = false
    distFrame.colorTable = DF.tables['distancecolors_melee']
    distFrame.extendedRange = false
    distFrame.colorText = false
    distFrame.attackableOnly = false
    distFrame.animSpeed = 0.05
    distFrame.showDecimals = true
    distFrame.showPortrait = true

    function distFrame:StartAnimation()
        if self.fillTimer then
            DF.timers.cancel(self.fillTimer)
            self.fillTimer = nil
        end
        if self.barInstant and not self.barRepeat then
            leftBar:SetValue(100, true)
            rightBar:SetValue(100, true)
        else
            leftBar:SetValue(0, true)
            rightBar:SetValue(0, true)
            self.fillTimer = DF.timers.every(self.animSpeed, function()
                leftBar:SetValue(leftBar.val + 5, true)
                rightBar:SetValue(rightBar.val + 5, true)
                if leftBar.val >= 100 then
                    if distFrame.barRepeat then
                        leftBar:SetValue(0, true)
                        rightBar:SetValue(0, true)
                    else
                        DF.timers.cancel(distFrame.fillTimer)
                        distFrame.fillTimer = nil
                    end
                end
            end)
        end
    end

    distFrame:SetScript('OnUpdate', function()
        if (this.tick or 0) > GetTime() then return end
        this.tick = GetTime() + 0.1
        if UnitExists('target') then
            local dist = UnitXP('distanceBetween', 'player', 'target')
            local format = distFrame.showDecimals and '%.1f' or '%d'
            distText:SetText(string.format(format, dist or 0))
            if distFrame.barColorByRange then
                local color
                for i = 1, table.getn(distFrame.colorTable) do
                    local range = distFrame.colorTable[i]
                    if dist >= range.min and dist < range.max then
                        color = range.color
                        break
                    end
                end
                if color then
                    leftBar:SetFillColor(color[1], color[2], color[3], 1)
                    rightBar:SetFillColor(color[1], color[2], color[3], 1)
                    if distFrame.colorText then
                        distText:SetTextColor(color[1], color[2], color[3])
                    end
                end
            end
            distFrame:Show()
        end
    end)

    distFrame:SetScript('OnEvent', function()
        if event == 'PLAYER_TARGET_CHANGED' then
            if UnitExists('target') and not UnitIsUnit('target', 'player') then
                if distFrame.attackableOnly and not UnitCanAttack('player', 'target') then
                    distFrame:Hide()
                    return
                end
                portrait:SetUnit('target')
                DF.timers.delay(0, function()
                    portrait:SetCamera(0)
                end)
                distFrame:StartAnimation()
                distFrame:Show()
            else
                if distFrame.fillTimer then
                    DF.timers.cancel(distFrame.fillTimer)
                    distFrame.fillTimer = nil
                end
                distFrame:Hide()
            end
        end
    end)

    -- callbacks
    local callbacks = {}

    callbacks.barRepeat = function(value)
        distFrame.barRepeat = value
        if UnitExists('target') and not UnitIsUnit('target', 'player') then
            distFrame:StartAnimation()
        end
    end

    callbacks.barInstant = function(value)
        distFrame.barInstant = value
        if UnitExists('target') and not UnitIsUnit('target', 'player') then
            distFrame:StartAnimation()
        end
    end

    callbacks.barColorByRange = function(value)
        distFrame.barColorByRange = value
        if not value then
            leftBar:SetFillColor(1, 1, 1, 1)
            rightBar:SetFillColor(1, 1, 1, 1)
            distText:SetTextColor(1, 1, 1)
        end
    end

    callbacks.distanceMode = function(value)
        if value == 'Ranged' then
            distFrame.colorTable = DF.tables['distancecolors_ranged']
        else
            distFrame.colorTable = DF.tables['distancecolors_melee']
        end
    end

    callbacks.extendedRange = function(value)
        if value then
            DF.tables['distancecolors_ranged'][4].max = 40
            DF.tables['distancecolors_ranged'][5].min = 40
        else
            DF.tables['distancecolors_ranged'][4].max = 30
            DF.tables['distancecolors_ranged'][5].min = 30
        end
    end

    callbacks.colorText = function(value)
        distFrame.colorText = value
        if not value then
            distText:SetTextColor(1, 1, 1)
        end
    end

    callbacks.showBars = function(value)
        if value then
            leftBar:Show()
            rightBar:Show()
        else
            leftBar:Hide()
            rightBar:Hide()
        end
    end

    callbacks.barWidth = function(value)
        leftBar:SetSize(value, leftBar:GetHeight())
        rightBar:SetSize(value, rightBar:GetHeight())
    end

    callbacks.barHeight = function(value)
        leftBar:SetSize(leftBar:GetWidth(), value)
        rightBar:SetSize(rightBar:GetWidth(), value)
    end

    callbacks.attackableOnly = function(value)
        distFrame.attackableOnly = value
    end

    callbacks.barAnimInterval = function(value)
        distFrame.animSpeed = value
        if UnitExists('target') and not UnitIsUnit('target', 'player') then
            distFrame:StartAnimation()
        end
    end

    callbacks.textSize = function(value)
        local db = DF.profile.distance
        local newHeight = value + 8
        local newPortraitSize = newHeight - 5
        local newWidth = newPortraitSize + (value * db.portraitSpacing) + (framePadding * 3)
        distFrame:SetSize(newWidth, newHeight)
        portrait:SetSize(newPortraitSize, newPortraitSize)
        distText:SetFont(distText:GetFont(), value)
    end

    callbacks.textFont = function(value)
        local _, size = distText:GetFont()
        distText:SetFont(media[value], size)
    end

    callbacks.bgAlpha = function(value)
        bg:SetVertexColor(1, 1, 1, value)
    end

    callbacks.showPortrait = function(value)
        distFrame.showPortrait = value
        local db = DF.profile.distance
        local textSize = db.textSize
        local newHeight = textSize + 8
        if value then
            portrait:Show()
            local newPortraitSize = newHeight - 5
            local newWidth = newPortraitSize + (textSize * db.portraitSpacing) + (framePadding * 3)
            distFrame:SetSize(newWidth, newHeight)
            portrait:SetSize(newPortraitSize, newPortraitSize)
            distText:ClearAllPoints()
            distText:SetPoint('RIGHT', distFrame, 'RIGHT', -framePadding, 0)
        else
            portrait:Hide()
            local newWidth = (textSize * db.portraitSpacing) + (framePadding * 2)
            distFrame:SetSize(newWidth, newHeight)
            distText:ClearAllPoints()
            distText:SetPoint('CENTER', distFrame, 'CENTER', 0, 0)
        end
    end

    callbacks.showDecimals = function(value)
        distFrame.showDecimals = value
    end

    callbacks.portraitSpacing = function(value)
        local db = DF.profile.distance
        local textSize = db.textSize
        local newHeight = textSize + 8
        local newPortraitSize = newHeight - 5
        if distFrame.showPortrait then
            local newWidth = newPortraitSize + (textSize * value) + (framePadding * 3)
            distFrame:SetSize(newWidth, newHeight)
        else
            local newWidth = (textSize * value) + (framePadding * 2)
            distFrame:SetSize(newWidth, newHeight)
        end
    end

    DF:NewCallbacks('distance', callbacks)
end)
