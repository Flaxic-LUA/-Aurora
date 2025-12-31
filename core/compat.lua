UNLOCKDRAGONFLIGHT()

-- quick force disabler for now
local disableList = {'Prat', 'TurtleChatColors', 'Chatter', 'ChatMOD', 'WorldFilter'}

local compatFrame = CreateFrame('Frame')
compatFrame:RegisterEvent('ADDON_LOADED')
compatFrame:RegisterEvent('VARIABLES_LOADED')
compatFrame:SetScript('OnEvent', function()
    for _, addon in pairs(disableList) do
        DisableAddOn(addon)
    end
    if event == 'VARIABLES_LOADED' then
        compatFrame:UnregisterAllEvents()
    end
end)
