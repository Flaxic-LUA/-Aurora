DRAGONFLIGHT()

-- quick force disabler for now -- TODO doesnt work this way disable needs reload -,-
local disableList = {'Prat', 'TurtleChatColors', 'Chatter', 'ChatMOD', 'WorldFilter'}

local detectList = {'pfQuest'}

local compatFrame = CreateFrame('Frame')
compatFrame:RegisterEvent('ADDON_LOADED')
compatFrame:RegisterEvent('VARIABLES_LOADED')
compatFrame:SetScript('OnEvent', function()
    for _, addon in pairs(disableList) do
        DisableAddOn(addon)
    end

    if event == 'ADDON_LOADED' then
        for _, addon in pairs(detectList) do
            if arg1 == addon then
                DF.others[addon] = true
            end
        end
    end

    if event == 'VARIABLES_LOADED' then
        compatFrame:UnregisterAllEvents()
    end
end)
