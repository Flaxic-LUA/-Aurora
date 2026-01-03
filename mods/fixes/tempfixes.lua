DRAGONFLIGHT()

DF:NewDefaults('tempfixes', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('tempfixes', 1, 'PLAYER_ENTERING_WORLD', function()
    local questTracker = CreateFrame('Frame', 'DF_QuestTracker', UIParent)
    questTracker:SetPoint('RIGHT', UIParent, 'RIGHT', -140, 200)
    questTracker:SetWidth(170)
    questTracker:SetHeight(10)
    questTracker:SetScale(.8)
    QuestWatchFrame:SetParent(questTracker)
    QuestWatchFrame:SetAllPoints(questTracker)
    QuestWatchFrame:SetFrameLevel(1)

    DurabilityFrame:ClearAllPoints()
    DurabilityFrame:SetPoint('RIGHT', UIParent, 'RIGHT', -15, 200)
    DurabilityFrame:SetScale(0.7)

    -- callbacks
    local callbacks = {}
    DF:NewCallbacks('tempfixes', callbacks)
end)
