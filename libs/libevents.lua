DRAGONFLIGHT()

local libevents = CreateFrame('Frame')
local registeredFrames = {}

local customEvents = {
    ['PLAYER_AFTER_ENTERING_WORLD'] = {
        triggerEvent = 'PLAYER_ENTERING_WORLD',
        delay =  0.05,
        condition = nil,
        fired = false
    },
    ['SYNC_READY'] = {
        triggerEvent = 'PLAYER_ENTERING_WORLD',
        delay = 2,
        condition = nil,
        fired = false
    },
    ['PLAYERMODEL_READY'] = {
        triggerEvent = nil,
        delay = nil,
        frame = CreateFrame('PlayerModel'),
        fired = false,
        condition = function(self)
            self.frame:SetUnit('player')
            return self.frame:GetModel() ~= nil
        end
    }
}

-- hook DF (created before this file loads)
local _DFRegisterEvent = DF.RegisterEvent
DF.RegisterEvent = function(self, event)
    if customEvents[event] then
        registeredFrames[event] = registeredFrames[event] or {}
        table.insert(registeredFrames[event], self)
    else
        return _DFRegisterEvent(self, event)
    end
end

for _, customEvent in pairs(customEvents) do
    if customEvent.triggerEvent then
        libevents:RegisterEvent(customEvent.triggerEvent)
    end
end

-- hook future frames via CreateFrame override
local _CreateFrame = CreateFrame
CreateFrame = function(frameType, name, parent, template)
    local frame = _CreateFrame(frameType, name, parent, template)

    local _RegisterEvent = frame.RegisterEvent
    local _SetScript = frame.SetScript

    frame.RegisterEvent = function(self, event)
        if customEvents[event] then
            registeredFrames[event] = registeredFrames[event] or {}
            table.insert(registeredFrames[event], self)
        else
            return _RegisterEvent(self, event)
        end
    end

    frame.SetScript = function(self, scriptType, handler)
        return _SetScript(self, scriptType, handler)
    end

    return frame
end

-- activate custom events when trigger fires
libevents:SetScript('OnEvent', function()
    for _, customEvent in pairs(customEvents) do
        if customEvent.triggerEvent == event then
            customEvent.startTime = GetTime()
            customEvent.active = true
        end
    end
end)

-- check conditions and fire custom events
libevents:SetScript('OnUpdate', function()
    for eventName, customEvent in pairs(customEvents) do
        if not customEvent.fired and (customEvent.active or not customEvent.triggerEvent) then
            local ready = false

            if customEvent.delay then
                if GetTime() - customEvent.startTime >= customEvent.delay then
                    ready = true
                end
            elseif customEvent.condition then
                if customEvent.condition(customEvent) then
                    ready = true
                end
            end

            if ready then
                customEvent.active = false
                customEvent.fired = true
                -- debugprint('Custom event fired: ' .. eventName)
                local frames = registeredFrames[eventName]
                if frames then
                    for _, frame in pairs(frames) do
                        local handler = frame:GetScript('OnEvent')
                        if handler then
                            local oldEvent = event
                            event = eventName
                            handler()
                            event = oldEvent
                        end
                    end
                end
            end
        end
    end
end)
