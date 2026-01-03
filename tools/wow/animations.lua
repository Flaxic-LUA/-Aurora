DRAGONFLIGHT()

local GetTime = GetTime
local pairs = pairs

-- statusbars
local StatusBars = {}
local animations = {}
local pulses = {}
local cutouts = {}

local ANIMATION_SPEED = 0.1
local PULSE_DURATION = 0.3
local PULSE_FADE_IN = 0.1
local PULSE_CURVE = 0.7
local PULSE_SCALE = 1.05
local CUTOUT_DURATION = .3
local CUTOUT_ALPHA = 1

function StatusBars:UpdateBarAnimations()
    for bar in pairs(animations) do
        if bar.enableBarAnim then
            -- check if animation is complete (with epsilon for floating point precision)
            local diff = bar.val - bar.val_
            if diff < 0 then diff = -diff end
            if bar.instant or bar.val_ == bar.val or diff < 0.5 then
                -- snap to final value
                bar.val_ = bar.val
                -- remove from animation table
                animations[bar] = nil
            else
                -- lerp current value toward target value
                bar.val_ = DF.math.lerp(bar.val_, bar.val, ANIMATION_SPEED)
            end
            -- update bar visual width
            bar:Update()
        else
            -- remove disabled bars
            animations[bar] = nil
        end
    end
end

function StatusBars:UpdatePulseAnimations(now)
    for bar, endTime in pairs(pulses) do
        if bar.enablePulse and bar.val_ > 0 and bar.max > 0 then
            -- check if pulse is finished
            if now >= endTime then
                -- reset to base color
                bar.fill:SetVertexColor(bar.baseColor[1], bar.baseColor[2], bar.baseColor[3], bar.baseColor[4])
                bar:Update()
                -- remove from pulse table
                pulses[bar] = nil
            else
            -- calculate remaining time
            local timeLeft = endTime - now
            local progress
            -- determine fade phase
            if timeLeft > PULSE_DURATION * (1 - PULSE_FADE_IN) then
                -- fade in phase
                progress = 1 - ((timeLeft - PULSE_DURATION * (1 - PULSE_FADE_IN)) / (PULSE_DURATION * PULSE_FADE_IN))
            else
                -- fade out phase
                progress = (timeLeft / (PULSE_DURATION * (1 - PULSE_FADE_IN))) ^ PULSE_CURVE
            end
            -- interpolate between base and pulse colors
            local r = DF.math.lerp(bar.baseColor[1], bar.pulseColor[1], progress)
            local g = DF.math.lerp(bar.baseColor[2], bar.pulseColor[2], progress)
            local b = DF.math.lerp(bar.baseColor[3], bar.pulseColor[3], progress)
            -- apply interpolated color
            bar.fill:SetVertexColor(r, g, b, 1)

            -- calculate pulse scale effect
            local scale = 1 + (PULSE_SCALE - 1) * progress
            local pct = DF.math.clamp(bar.val_ / bar.max, 0, 1)
            local fillWidth = DF.math.clamp(bar:GetWidth() * pct * scale, 0, bar:GetWidth())
            -- apply scaled dimensions
            if bar.fillDirection == 'RIGHT_TO_LEFT' then
                bar.fill:SetTexCoord(1-pct, 1, 0, 1)
            else
                bar.fill:SetTexCoord(0, pct, 0, 1)
            end
            bar.fill:SetSize(fillWidth, bar:GetHeight() * scale)
            end
        else
            -- remove disabled pulses
            pulses[bar] = nil
        end
    end
end

function StatusBars:UpdateCutoutAnimations(now)
    for cutout, data in pairs(cutouts) do
        -- check if cutout fade is complete
        if now >= data.endTime then
            -- destroy cutout texture
            cutout:SetTexture(nil)
            -- remove from cutouts table
            cutouts[cutout] = nil
        else
            -- calculate fade progress
            local progress = DF.math.clamp((data.endTime - now) / data.duration, 0, 1)
            -- apply fading alpha
            cutout:SetAlpha(CUTOUT_ALPHA * progress)
        end
    end
end

-- public
function DF.animations.CreateStatusBar(parent, width, height, animConfig, name)
    local bar = CreateFrame('Frame', name, parent)
    bar:SetSize(width or 200, height or 20)
    -- debugframe(bar)
    bar.bg = bar:CreateTexture(nil, 'BACKGROUND')
    bar.bg:SetPoint('TOPLEFT', bar, 'TOPLEFT', 0, 0)
    bar.bg:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 0, 0)
    bar.bg:SetTexture(media['tex:unitframes:aurora_hpbar.tga'])
    bar.bg:SetVertexColor(0, 0, 0, .5)

    bar.fill = bar:CreateTexture(nil, 'ARTWORK')
    bar.fill:SetPoint('TOPLEFT', bar, 'TOPLEFT', 0, 0)
    bar.fill:SetTexture(media['tex:unitframes:aurora_hpbar.tga'])
    bar.fill:Hide()

    bar.val = 0
    bar.val_ = 0
    bar.max = 1
    bar.baseColor = {1, 1, 1, 1}
    bar.pulseColor = {1, 1, 1, 1}
    bar.cutoutColor = {1, 0.2, 0.2, 1}
    -- bar.bgColor = {0.2, 0.2, 0.2, .1}
    bar.cutoutDuration = CUTOUT_DURATION
    bar.cutoutTexture = media['tex:unitframes:aurora_hpbar.tga']
    bar.fillDirection = 'LEFT_TO_RIGHT'

    animConfig = animConfig or {}
    bar.enableBarAnim = animConfig.barAnim ~= true
    bar.enablePulse = animConfig.pulse == true
    bar.enableCutout = animConfig.cutout == true

    function bar:Update()
        if self.max <= 0 or self.val_ <= 0 then
            self.fill:Hide()
            self.fill:SetWidth(0)
            return
        end
        self.fill:Show()
        local pct = DF.math.clamp(self.val_ / self.max, 0, 1)
        local fillWidth = DF.math.clamp(self:GetWidth() * pct, 0, self:GetWidth())
        if self.fillDirection == 'RIGHT_TO_LEFT' then
            self.fill:SetTexCoord(1-pct, 1, 0, 1)
        else
            self.fill:SetTexCoord(0, pct, 0, 1)
        end
        self.fill:SetWidth(fillWidth)
        self.fill:SetHeight(self:GetHeight())
    end

    function bar:SetValue(val, instant)
        -- only process if value actually changed or if max changed (instant can be true/false or maxChanged flag)
        if self.val ~= val or instant == true then
            -- create cutout effect for value decreases (damage taken)
            if val < self.val and not instant and self.enableCutout then
                -- calculate old and new percentages
                local oldPct = self.val / self.max
                local newPct = val / self.max
                local cutWidth = self:GetWidth() * (oldPct - newPct)

                -- create cutout texture to show lost value
                local cutout = self:CreateTexture(nil, 'ARTWORK')
                cutout:SetTexture(self.cutoutTexture)
                cutout:SetVertexColor(self.cutoutColor[1], self.cutoutColor[2], self.cutoutColor[3], CUTOUT_ALPHA)
                -- set texture coordinates for cutout portion
                if self.cutoutTexCoord then
                    cutout:SetTexCoord(self.cutoutTexCoord[1], self.cutoutTexCoord[2], self.cutoutTexCoord[3], self.cutoutTexCoord[4])
                else
                    if self.fillDirection == 'RIGHT_TO_LEFT' then
                        cutout:SetTexCoord(1-oldPct, 1-newPct, 0, 1)
                    else
                        cutout:SetTexCoord(newPct, oldPct, 0, 1)
                    end
                end
                -- position cutout at the lost value area
                if self.fillDirection == 'RIGHT_TO_LEFT' then
                    cutout:SetPoint('TOPLEFT', self, 'TOPLEFT', self:GetWidth() * (1-oldPct), 0)
                else
                    cutout:SetPoint('TOPLEFT', self, 'TOPLEFT', self:GetWidth() * newPct, 0)
                end
                cutout:SetSize(cutWidth, self:GetHeight())

                -- register cutout for fade animation
                cutouts[cutout] = {endTime = GetTime() + self.cutoutDuration, duration = self.cutoutDuration}
            end

            -- determine if we should use instant update
            local useInstant = instant or self.instant
            self.val = val
            -- handle animated vs instant updates
            if not useInstant and (self.enableBarAnim or self.enablePulse) then
                -- register for smooth value animation
                if self.enableBarAnim then
                    animations[self] = true
                end
                -- register for pulse color animation
                if self.enablePulse then
                    pulses[self] = GetTime() + PULSE_DURATION
                end
                -- if no bar animation, update display value immediately
                if not self.enableBarAnim then
                    self.val_ = val
                    self:Update()
                end
            else
                -- instant update - no animations
                pulses[self] = nil
                self.fill:SetVertexColor(self.baseColor[1], self.baseColor[2], self.baseColor[3], self.baseColor[4])
                self.val_ = val
                self:Update()
            end
        end
    end

    function bar:SetInstant(instant)
        self.instant = instant
    end

    function bar:SetBarAnimation(enabled)
        self.enableBarAnim = enabled
        if not enabled then animations[self] = nil end
    end

    function bar:SetPulseAnimation(enabled)
        self.enablePulse = enabled
        if not enabled then pulses[self] = nil end
    end

    function bar:SetCutoutAnimation(enabled)
        self.enableCutout = enabled
    end

    function bar:SetTextures(fillTex, bgTex)
        self.fill:SetTexture(fillTex)
        self.bg:SetTexture(bgTex)
        self.cutoutTexture = fillTex
    end

    function bar:SetFillColor(r, g, b, a)
        self.baseColor = {r, g, b, a}
        self.fill:SetVertexColor(r, g, b, a)
    end

    function bar:SetCutoutColor(r, g, b, a)
        self.cutoutColor = {r, g, b, a}
    end

    function bar:SetPulseColor(r, g, b, a)
        self.pulseColor = {r, g, b, a}
    end

    function bar:SetBgColor(r, g, b, a)
        -- self.bgColor = {r, g, b, a}
        self.bg:SetVertexColor(r, g, b, a)
    end

    function bar:SetFillDirection(direction)
        self.fillDirection = direction
        if direction == 'RIGHT_TO_LEFT' then
            self.fill:ClearAllPoints()
            self.fill:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, 0)
        else
            self.fill:ClearAllPoints()
            self.fill:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
        end
        self:Update()
    end

    return bar
end

CreateFrame'Frame':SetScript('OnUpdate', function()
    local now = GetTime()
    StatusBars:UpdateBarAnimations()
    StatusBars:UpdatePulseAnimations(now)
    StatusBars:UpdateCutoutAnimations(now)
end)

-- -- loading bars
-- local LoadingBars = {
--     bars = {},
--     nextId = 1
-- }

-- -- core functions (?)
-- function LoadingBars:Create(id, width, height, repeating, direction, time)
--     if self.bars[id] then
--         self:Destroy(id)
--     end

--     local frame = CreateFrame('Frame', nil, UIParent)
--     frame:SetWidth(width)
--     frame:SetHeight(height)

--     local bg = frame:CreateTexture(nil, 'BACKGROUND')
--     bg:SetTexture('Interface\\Buttons\\WHITE8X8')
--     bg:SetAllPoints(frame)
--     bg:SetVertexColor(0.2, 0.2, 0.2, 1)

--     local bar = frame:CreateTexture(nil, 'ARTWORK')
--     bar:SetTexture('Interface\\Buttons\\WHITE8X8')
--     bar:SetPoint('LEFT', frame, 'LEFT', 0, 0)
--     bar:SetHeight(height)
--     bar:SetWidth(0)

--     local barData = {
--         frame = frame,
--         bar = bar,
--         width = width,
--         height = height,
--         repeating = repeating,
--         direction = direction or 'left',
--         time = time,
--         elapsed = 0,
--         progress = 0
--     }

--     frame:SetScript('OnUpdate', function()
--         LoadingBars:Update(id)
--     end)

--     self.bars[id] = barData
--     return frame
-- end

-- function LoadingBars:Update(id)
--     local barData = self.bars[id]
--     if not barData then return end

--     local parent = barData.frame:GetParent()
--     if parent and not parent:IsVisible() then return end

--     barData.elapsed = barData.elapsed + arg1
--     barData.progress = barData.elapsed / barData.time

--     if barData.progress >= 1 then
--         if barData.repeating then
--             barData.elapsed = 0
--             barData.progress = 0
--         else
--             self:Destroy(id)
--             return
--         end
--     end

--     self:UpdateTexture(barData)
-- end

-- function LoadingBars:UpdateTexture(data)
--     local newWidth = data.width * data.progress
--     if data.direction == 'right' then
--         data.bar:SetPoint('RIGHT', data.frame, 'RIGHT', 0, 0)
--         data.bar:SetWidth(newWidth)
--     else
--         data.bar:SetWidth(newWidth)
--     end
-- end

-- function LoadingBars:Destroy(id)
--     local data = self.bars[id]
--     if data then
--         data.frame:Hide()
--         data.frame = nil
--         self.bars[id] = nil
--     end
-- end

-- -- public functions
-- function DF.animations.LoadingBar(width, height, repeating, direction, time)
--     local id = 'bar_' .. LoadingBars.nextId
--     LoadingBars.nextId = LoadingBars.nextId + 1
--     return LoadingBars:Create(id, width, height, repeating, direction, time)
-- end
