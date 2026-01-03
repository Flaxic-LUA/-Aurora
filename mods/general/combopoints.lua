DRAGONFLIGHT()

DF:NewDefaults('combopoints', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'extras', subtab = 'combopoints', categories = 'General'},
    },
    scale = {value = 1, metadata = {element = 'slider', category = 'General', indexInCategory = 2, description = 'Scale of combo points', min = 0.5, max = 2, stepSize = 0.1}},
    color = {value = {1, 0, 1}, metadata = {element = 'colorpicker', category = 'General', indexInCategory = 3, description = 'Color of combo points'}},
})

DF:NewModule('combopoints', 1, function()
    local combopoints = {}
    combopoints.frames = {}

    function combopoints:CreateFrames()
        local container = CreateFrame('Frame', 'DF_ComboPointsContainer', UIParent)
        container:SetSize(175, 30)
        container:SetPoint('CENTER', UIParent, 'CENTER', 0, -100)
        self.container = container

        for i = 1, 5 do
            local frame = CreateFrame('Frame', 'AUComboFrame'..i, container)
            frame:SetWidth(30)
            frame:SetHeight(30)
            frame:SetPoint('CENTER', container, 'CENTER', (i - 3) * 35, 0)
            frame:SetFrameStrata('HIGH')

            frame.empty = frame:CreateTexture(nil, 'ARTWORK')
            frame.empty:SetAllPoints(frame)
            frame.empty:SetTexture(media['tex:generic:combo_empty.blp'])

            frame.full = frame:CreateTexture(nil, 'OVERLAY')
            frame.full:SetAllPoints(frame)
            frame.full:SetTexture(media['tex:generic:combo_full.blp'])
            frame.full:Hide()

            frame:Hide()
            self.frames[i] = frame
        end
    end

    function combopoints:DisplayNum(num)
        for i = 1, 5 do
            if num == 0 then
                self.frames[i]:Hide()
            else
                self.frames[i]:Show()
                self.frames[i].empty:Show()
                if i <= num then
                    self.frames[i].full:Show()
                else
                    self.frames[i].full:Hide()
                end
            end
        end
    end

    function combopoints:SetupEvents()
        local updater = CreateFrame('Frame')
        updater:RegisterEvent('UNIT_COMBO_POINTS')
        updater:RegisterEvent('PLAYER_COMBO_POINTS')
        updater:RegisterEvent('PLAYER_TARGET_CHANGED')
        updater:RegisterEvent('PLAYER_ENTERING_WORLD')

        updater:SetScript('OnEvent', function()
            local points = GetComboPoints('target')
            combopoints:DisplayNum(points)
        end)
    end

    function combopoints:UpdateScale(scale)
        for i = 1, 5 do
            self.frames[i]:SetScale(scale)
        end
    end

    function combopoints:UpdateColor(color)
        for i = 1, 5 do
            self.frames[i].full:SetVertexColor(color[1], color[2], color[3])
        end
    end

    DF.common.KillFrame(ComboFrame)
    combopoints:CreateFrames()
    combopoints:SetupEvents()

    -- callbacks
    local callbacks = {}

    callbacks.scale = function(value)
        combopoints:UpdateScale(value)
    end

    callbacks.color = function(value)
        combopoints:UpdateColor(value)
    end

    DF:NewCallbacks('combopoints', callbacks)
end)
