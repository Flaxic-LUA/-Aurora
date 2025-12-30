UNLOCKDRAGONFLIGHT()

local textures = {
    background = media['tex:castbar:CastingBarBackground.blp'],
    bar = media['tex:castbar:CastingBarStandard3.tga'],
    border = media['tex:castbar:CastingBarFrame.blp'],
    spark = media['tex:castbar:CastingBarSpark.blp'],
    flash = media['tex:castbar:CastingBarFrameFlash.tga'],
    dropshadow = media['tex:castbar:CastingBarFrameDropShadow.blp']
}

-- public
function DF.lib.CreateCastBar(unit)
    local cast = {}
    cast.unit = unit or 'player'

    cast.config = {
        width = 200,
        height = 16,
        barColor = {1, 0.82, 0},
        alphaSpeed = .9,
        fillDirection = 'left',
        sparkTrail = false,
        trailMaxCount = 15,
        trailSpawnDistance = 5,
        showLag = true,
        autoColorTime = true,
        timeFormatWhole = false,
        showIcon = true,
        showSpellName = true,
        showRank = true,
        showTime = true
    }

    cast.state = {
        fadeOut = false,
        lastCast = nil,
        lastEndTime = nil,
        interrupted = false,
        sparkPositions = {},
        calculatedFadeTime = 1,
        currentLag = 0
    }

    function cast:CreateCastFrame()
        local frameName = nil
        if self.unit == 'player' then
            frameName = 'DF_PlayerCastBar'
        elseif self.unit == 'target' then
            frameName = 'DF_TargetCastBar'
        end
        local frame = CreateFrame('Frame', frameName, UIParent)
        frame:SetWidth(self.config.width)
        frame:SetHeight(self.config.height)
        frame:SetAlpha(0)
        frame:Show()
        frame:SetFrameStrata('LOW')
        local dropshadow = frame:CreateTexture(nil, 'BACKGROUND', 1)
        dropshadow:SetWidth(self.config.width + 1)
        dropshadow:SetHeight(self.config.height + 9)
        dropshadow:SetPoint('TOP', frame, 'BOTTOM', 0, 5)
        dropshadow:SetTexture(textures.dropshadow)

        local bg = frame:CreateTexture(nil, 'BACKGROUND', 7)
        bg:SetAllPoints(frame)
        bg:SetTexture(textures.background)

        local icon = frame:CreateTexture(nil, 'BORDER')
        icon:SetWidth(self.config.height)
        icon:SetHeight(self.config.height)
        icon:SetPoint('RIGHT', frame, 'LEFT', -5, 0)
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

        local bar = frame:CreateTexture(nil, 'BORDER')
        bar:SetPoint('LEFT', frame, 'LEFT', 0, 0)
        bar:SetHeight(self.config.height)
        bar:SetWidth(0)
        bar:SetTexture(textures.bar)
        bar:SetVertexColor(self.config.barColor[1], self.config.barColor[2], self.config.barColor[3])

        local border = frame:CreateTexture(nil, 'ARTWORK')
        border:SetAllPoints(frame)
        border:SetTexture(textures.border)

        local spark = frame:CreateTexture(nil, 'OVERLAY')
        spark:SetHeight(self.config.height + 5)
        spark:SetWidth(25)
        spark:SetTexture(textures.spark)
        spark:SetBlendMode('ADD')
        spark:Hide()

        local spark2 = frame:CreateTexture(nil, 'OVERLAY')
        spark2:SetHeight(self.config.height + 5)
        spark2:SetWidth(25)
        spark2:SetTexture(textures.spark)
        spark2:SetBlendMode('ADD')
        spark2:Hide()

        local flash = frame:CreateTexture(nil, 'OVERLAY')
        flash:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, 5)
        flash:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', 0, -5)
        flash:SetTexture(textures.flash)
        flash:SetAlpha(0)
        flash:Hide()

        local text = frame:CreateFontString(nil, 'OVERLAY')
        text:SetFont('Fonts\\FRIZQT__.TTF', 12, 'OUTLINE')
        text:SetPoint('LEFT', frame, 'LEFT', 5, -16)
        text:SetTextColor(1, 1, 1)

        local rankText = frame:CreateFontString(nil, 'OVERLAY')
        rankText:SetFont('Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
        rankText:SetPoint('LEFT', text, 'RIGHT', 3, 0)
        rankText:SetTextColor(0.9, 0.9, 0.9)

        local timeText = frame:CreateFontString(nil, 'OVERLAY')
        timeText:SetFont('Fonts\\FRIZQT__.TTF', 12, 'OUTLINE')
        timeText:SetPoint('RIGHT', frame, 'RIGHT', -5, -16)
        timeText:SetTextColor(1, 1, 1)

        local sparkTrails = {}
        for i = 1, self.config.trailMaxCount do
            local trail = frame:CreateTexture(nil, 'OVERLAY')
            trail:SetHeight(self.config.height + 5)
            trail:SetWidth(25)
            trail:SetTexture(textures.spark)
            trail:SetBlendMode('ADD')
            trail:Hide()
            sparkTrails[i] = trail
        end

        local lagIndicator = frame:CreateTexture(nil, 'BORDER')
        lagIndicator:SetHeight(self.config.height)
        lagIndicator:SetWidth(0)
        lagIndicator:SetTexture('Interface\\Buttons\\WHITE8x8')
        lagIndicator:SetVertexColor(1, 0, 0)
        lagIndicator:SetAlpha(0.5)
        lagIndicator:Hide()

        local lagIndicator2 = frame:CreateTexture(nil, 'BORDER')
        lagIndicator2:SetHeight(self.config.height)
        lagIndicator2:SetWidth(0)
        lagIndicator2:SetTexture('Interface\\Buttons\\WHITE8x8')
        lagIndicator2:SetVertexColor(1, 0, 0)
        lagIndicator2:SetAlpha(0.5)
        lagIndicator2:Hide()

        self.frame = frame
        self.dropshadow = dropshadow
        self.bg = bg
        self.icon = icon
        self.bar = bar
        self.border = border
        self.spark = spark
        self.spark2 = spark2
        self.flash = flash
        self.text = text
        self.rankText = rankText
        self.timeText = timeText
        self.sparkTrails = sparkTrails
        self.lagIndicator = lagIndicator
        self.lagIndicator2 = lagIndicator2

        return frame
    end

    function cast:UpdateSparkHeights()
        local sparkHeight = self.config.height + 5
        self.spark:SetHeight(sparkHeight)
        self.spark2:SetHeight(sparkHeight)
        for i = 1, self.config.trailMaxCount do
            if self.sparkTrails[i] then
                self.sparkTrails[i]:SetHeight(sparkHeight)
            end
        end
    end

    function cast:UpdateProgress(progress, startTime, endTime)
        progress = DF.math.clamp(progress, 0, 1)
        local totalWidth = self.config.width
        local newWidth = progress * totalWidth
        if newWidth < 0.1 then newWidth = 0.1 end
        local fillDir = self.config.fillDirection

        if self.unit == 'player' and self.config.showLag and startTime and endTime then
            local duration = (endTime - startTime) / 1000
            local lagWidth = (totalWidth / duration) * (self.state.currentLag / 1000)
            lagWidth = math.min(totalWidth, lagWidth)

            if fillDir == 'left' then
                self.lagIndicator:ClearAllPoints()
                self.lagIndicator:SetPoint('RIGHT', self.frame, 'RIGHT', 0, 0)
                self.lagIndicator:SetWidth(lagWidth)
                self.lagIndicator:Show()
                self.lagIndicator2:Hide()
            elseif fillDir == 'right' then
                self.lagIndicator:ClearAllPoints()
                self.lagIndicator:SetPoint('LEFT', self.frame, 'LEFT', 0, 0)
                self.lagIndicator:SetWidth(lagWidth)
                self.lagIndicator:Show()
                self.lagIndicator2:Hide()
            elseif fillDir == 'center' or fillDir == 'centerreversed' then
                local halfLagWidth = lagWidth / 2
                self.lagIndicator:ClearAllPoints()
                self.lagIndicator:SetPoint('LEFT', self.frame, 'LEFT', 0, 0)
                self.lagIndicator:SetWidth(halfLagWidth)
                self.lagIndicator:Show()
                self.lagIndicator2:ClearAllPoints()
                self.lagIndicator2:SetPoint('RIGHT', self.frame, 'RIGHT', 0, 0)
                self.lagIndicator2:SetWidth(halfLagWidth)
                self.lagIndicator2:Show()
            end
        else
            self.lagIndicator:Hide()
            self.lagIndicator2:Hide()
        end

        if fillDir == 'left' then
            self.bar:ClearAllPoints()
            self.bar:SetPoint('LEFT', self.frame, 'LEFT', 0, 0)
            self.bar:SetWidth(newWidth)
            self.bar:SetTexCoord(0, progress, 0, 1)
        elseif fillDir == 'right' then
            local xOffset = totalWidth - newWidth
            self.bar:ClearAllPoints()
            self.bar:SetPoint('LEFT', self.frame, 'LEFT', xOffset, 0)
            self.bar:SetWidth(newWidth)
            self.bar:SetTexCoord(1 - progress, 1, 0, 1)
        elseif fillDir == 'center' then
            local halfWidth = newWidth / 2
            local xOffset = (totalWidth / 2) - halfWidth
            self.bar:ClearAllPoints()
            self.bar:SetPoint('LEFT', self.frame, 'LEFT', xOffset, 0)
            self.bar:SetWidth(newWidth)
            local halfProgress = progress / 2
            self.bar:SetTexCoord(0.5 - halfProgress, 0.5 + halfProgress, 0, 1)
        elseif fillDir == 'centerreversed' then
            local invertedProgress = 1 - progress
            local reversedWidth = invertedProgress * totalWidth
            if reversedWidth < 0.1 then reversedWidth = 0.1 end
            local halfWidth = reversedWidth / 2
            local xOffset = (totalWidth / 2) - halfWidth
            self.bar:ClearAllPoints()
            self.bar:SetPoint('LEFT', self.frame, 'LEFT', xOffset, 0)
            self.bar:SetWidth(reversedWidth)
            local halfProgress = invertedProgress / 2
            self.bar:SetTexCoord(0.5 - halfProgress, 0.5 + halfProgress, 0, 1)
        end

        if self.spark and progress > 0 and progress < 1 then
            local sparkX, sparkX2
            if fillDir == 'left' then
                sparkX = newWidth
                self.spark:SetPoint('CENTER', self.frame, 'LEFT', sparkX, 0)
                self.spark:Show()
                if self.spark2 then self.spark2:Hide() end
            elseif fillDir == 'right' then
                sparkX = totalWidth - newWidth
                self.spark:SetPoint('CENTER', self.frame, 'LEFT', sparkX, 0)
                self.spark:Show()
                if self.spark2 then self.spark2:Hide() end
            elseif fillDir == 'center' then
                local halfWidth = newWidth / 2
                local centerPoint = totalWidth / 2
                sparkX = centerPoint - halfWidth
                sparkX2 = centerPoint + halfWidth
                self.spark:SetPoint('CENTER', self.frame, 'LEFT', sparkX, 0)
                self.spark:Show()
                if self.spark2 then
                    self.spark2:SetPoint('CENTER', self.frame, 'LEFT', sparkX2, 0)
                    self.spark2:Show()
                end
            elseif fillDir == 'centerreversed' then
                local invertedProgress = 1 - progress
                local reversedWidth = invertedProgress * totalWidth
                if reversedWidth < 0.1 then reversedWidth = 0.1 end
                local halfWidth = reversedWidth / 2
                local centerPoint = totalWidth / 2
                sparkX = centerPoint - halfWidth
                sparkX2 = centerPoint + halfWidth
                self.spark:SetPoint('CENTER', self.frame, 'LEFT', sparkX, 0)
                self.spark:Show()
                if self.spark2 then
                    self.spark2:SetPoint('CENTER', self.frame, 'LEFT', sparkX2, 0)
                    self.spark2:Show()
                end
            end

            if self.config.sparkTrail and sparkX then
                local shouldAddPosition = false
                if table.getn(self.state.sparkPositions) == 0 then
                    shouldAddPosition = true
                else
                    local lastPos = self.state.sparkPositions[1]
                    local distance = math.abs(sparkX - lastPos.x1)
                    if distance > self.config.trailSpawnDistance then
                        shouldAddPosition = true
                    end
                end

                if shouldAddPosition then
                    table.insert(self.state.sparkPositions, 1, {x1 = sparkX, x2 = sparkX2, time = GetTime()})
                    if table.getn(self.state.sparkPositions) > self.config.trailMaxCount then
                        table.remove(self.state.sparkPositions)
                    end
                end

                local currentTime = GetTime()
                local fadeTime = self.state.calculatedFadeTime
                local trailIndex = 1
                for i = 1, table.getn(self.state.sparkPositions) do
                    local pos = self.state.sparkPositions[i]
                    if pos then
                        local age = currentTime - pos.time
                        if age < fadeTime then
                            local alpha = 1 - (age / fadeTime)
                            local trail = self.sparkTrails[trailIndex]
                            if trail then
                                trail:SetPoint('CENTER', self.frame, 'LEFT', pos.x1, 0)
                                trail:SetAlpha(alpha)
                                trail:Show()
                                trailIndex = trailIndex + 1
                            end
                            if pos.x2 and trailIndex <= self.config.trailMaxCount then
                                local trail2 = self.sparkTrails[trailIndex]
                                if trail2 then
                                    trail2:SetPoint('CENTER', self.frame, 'LEFT', pos.x2, 0)
                                    trail2:SetAlpha(alpha)
                                    trail2:Show()
                                    trailIndex = trailIndex + 1
                                end
                            end
                        end
                    end
                end
                for i = trailIndex, self.config.trailMaxCount do
                    if self.sparkTrails[i] then
                        self.sparkTrails[i]:Hide()
                    end
                end
            end
        elseif self.spark then
            self.spark:Hide()
            if self.spark2 then self.spark2:Hide() end
            for i = 1, self.config.trailMaxCount do
                if self.sparkTrails[i] then
                    self.sparkTrails[i]:Hide()
                end
            end
            self.state.sparkPositions = {}
        end
    end

    function cast:SetColors(r, g, b, rText, gText, bText)
        self.spark:SetVertexColor(r, g, b)
        if self.spark2 then self.spark2:SetVertexColor(r, g, b) end
        for i = 1, self.config.trailMaxCount do
            if self.sparkTrails[i] then self.sparkTrails[i]:SetVertexColor(r, g, b) end
        end
        self.text:SetTextColor(rText, gText, bText)
        self.rankText:SetTextColor(rText, gText, bText)
    end

    function cast:UpdateFrame(elapsed)
        local castName, rank, text, icon, startTime, endTime = UnitCastingInfo(self.unit)
        local channelName, channelRank, channelText, channelIcon, channelStart, channelEnd = UnitChannelInfo(self.unit)

        if castName then
            self.state.interrupted = false
            if castName ~= self.state.lastCast then
                self.state.lastCast = castName
                local castDuration = (endTime - startTime) / 1000
                local fadeTime = castDuration * 0.2
                self.state.calculatedFadeTime = DF.math.clamp(fadeTime, 0.3, 2.5)
                if self.unit == 'player' and self.config.showLag then
                    local _, _, lag = GetNetStats()
                    self.state.currentLag = lag or 0
                end
            end

            self.state.fadeOut = false
            self.frame:SetAlpha(1)
            self.bar:SetVertexColor(self.config.barColor[1], self.config.barColor[2], self.config.barColor[3])
            self:SetColors(1, 1, 1, 1, 1, 1)
            self.rankText:SetTextColor(0.9, 0.9, 0.9)
            self.flash:Hide()

            local now = GetTime() * 1000
            self.state.lastEndTime = endTime
            local progress = DF.math.normalize(now, startTime, endTime)
            progress = DF.math.clamp(progress, 0, 1)
            self:UpdateProgress(progress, startTime, endTime)

            local remaining = (endTime - now) / 1000
            if self.config.showSpellName then
                self.text:SetText(castName)
            else
                self.text:SetText('')
            end
            if self.config.showRank then
                self.rankText:SetText(rank or '')
            else
                self.rankText:SetText('')
            end
            if self.config.showTime then
                local timeStr = self.config.timeFormatWhole and DF.data.formatTime(remaining, 0) or DF.data.formatTime(remaining)
                self.timeText:SetText(timeStr)
                if self.config.autoColorTime then
                    if remaining < 1 then
                        self.timeText:SetTextColor(1, remaining, remaining)
                    else
                        self.timeText:SetTextColor(1, 1, 1)
                    end
                end
            else
                self.timeText:SetText('')
            end
            if icon and self.config.showIcon then self.icon:SetTexture(icon) self.icon:Show() else self.icon:Hide() end

        elseif channelName then
            self.state.interrupted = false
            if channelName ~= self.state.lastCast then
                self.state.lastCast = channelName
                local channelDuration = (channelEnd - channelStart) / 1000
                local fadeTime = channelDuration * 0.2
                self.state.calculatedFadeTime = DF.math.clamp(fadeTime, 0.3, 2.5)
                if self.unit == 'player' and self.config.showLag then
                    local _, _, lag = GetNetStats()
                    self.state.currentLag = lag or 0
                end
            end

            self.state.fadeOut = false
            self.frame:SetAlpha(1)
            self.bar:SetVertexColor(self.config.barColor[1], self.config.barColor[2], self.config.barColor[3])
            self:SetColors(1, 1, 1, 1, 1, 1)
            self.rankText:SetTextColor(0.9, 0.9, 0.9)
            self.flash:Hide()

            local now = GetTime() * 1000
            self.state.lastEndTime = channelEnd
            local timeLeft = channelEnd - now
            local progress = DF.math.normalize(timeLeft, 0, channelEnd - channelStart)
            progress = DF.math.clamp(progress, 0, 1)
            self:UpdateProgress(progress, channelStart, channelEnd)

            if self.config.showSpellName then
                self.text:SetText(channelName)
            else
                self.text:SetText('')
            end
            if self.config.showRank then
                self.rankText:SetText(channelRank or '')
            else
                self.rankText:SetText('')
            end
            local channelRemaining = timeLeft / 1000
            if self.config.showTime then
                local timeStr = self.config.timeFormatWhole and DF.data.formatTime(channelRemaining, 0) or DF.data.formatTime(channelRemaining)
                self.timeText:SetText(timeStr)
                if self.config.autoColorTime then
                    if channelRemaining < 1 then
                        self.timeText:SetTextColor(1, channelRemaining, channelRemaining)
                    else
                        self.timeText:SetTextColor(1, 1, 1)
                    end
                end
            else
                self.timeText:SetText('')
            end
            if channelIcon and self.config.showIcon then self.icon:SetTexture(channelIcon) self.icon:Show() else self.icon:Hide() end

        elseif self.state.lastCast then
            local now = GetTime() * 1000
            local lagTolerance = self.state.currentLag + 100
            if self.state.lastEndTime and now < self.state.lastEndTime - lagTolerance then
                self.state.interrupted = true
            end

            self.state.fadeOut = true
            if self.state.interrupted then
                self.bar:SetVertexColor(1, 0, 0)
                self.flash:SetVertexColor(1, 0, 0)
                self:SetColors(1, 0, 0, 1, 0, 0)
            else
                self.flash:SetVertexColor(0, 1, 0)
                self:SetColors(0, 1, 0, 0, 1, 0)
            end
            self.flash:SetAlpha(1)
            self.flash:Show()
        end

        if self.state.fadeOut and not castName and not channelName then
            local currentAlpha = self.frame:GetAlpha()
            local newAlpha = DF.math.clamp(currentAlpha - (self.config.alphaSpeed * elapsed), 0, 1)
            if newAlpha <= 0 then
                self.state.fadeOut = false
                self.state.lastCast = nil
                self.frame:SetAlpha(0)
            else
                self.frame:SetAlpha(newAlpha)
            end
        end
    end

    cast:CreateCastFrame()
    cast.frame:SetScript('OnUpdate', function()
        cast:UpdateFrame(arg1)
    end)

    if cast.unit == 'target' then
        local eventFrame = CreateFrame('Frame')
        eventFrame:RegisterEvent('PLAYER_TARGET_CHANGED')
        eventFrame:SetScript('OnEvent', function()
            cast.frame:SetAlpha(0)
            cast.state.fadeOut = false
            cast.state.lastCast = nil
            cast.state.lastEndTime = nil
            cast.state.interrupted = false
            cast.state.sparkPositions = {}
            for i = 1, cast.config.trailMaxCount do
                if cast.sparkTrails[i] then
                    cast.sparkTrails[i]:Hide()
                end
            end
        end)
    end

    return cast
end
