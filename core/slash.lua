DRAGONFLIGHT()

local function ShowHelp()
    redprint('COMMANDS:')
    print('/df - Toggle Dragonflight GUI')
    print('/df reset - Wipe DB and reload')
    print('/df edit or /df editmode - Toggle Edit Mode')
    print('/df gm - Open GM Help')
    print('/df safeboot - Disable all addons except Dragonflight')
    print('/load ADDONNAME - Load addon')
    print('/unload ADDONNAME - Unload addon')
end

_G.SLASH_DRAGONFLIGHT1 = '/df'
_G.SLASH_DRAGONFLIGHT2 = '/dragonflight'
_G.SlashCmdList['DRAGONFLIGHT'] = function(msg)
    if msg == 'help' then
        ShowHelp()
    elseif msg == 'safeboot' then
        DF.ui.StaticPopup_Show(
            'Disable all addons except Dragonflight and reload?',
            'Continue',
            function()
                for i = 1, GetNumAddOns() do
                    local name = GetAddOnInfo(i)
                    if name ~= info.addonName then
                        DisableAddOn(name)
                    end
                end
                ReloadUI()
            end,
            'Cancel'
        )
    elseif msg == 'gm' then
        ToggleHelpFrame()
    elseif msg == 'reset' then
        DF.ui.StaticPopup_Show(
            'Wipe EVERYTHING and reload UI?',
            'Yes',
            function()
                _G.DF_Profiles = {}
                _G.DF_LearnedData = {}
                ReloadUI()
            end,
            'No'
        )
    elseif msg == 'edit' or msg == 'editmode' then
        local frame = getglobal('DF_EditModeFrame')
        if frame then
            if frame:IsShown() then
                frame:Hide()
            else
                frame:Show()
            end
        end
    elseif msg == '' then
        DRAGONFLIGHTToggleGUI()
    else
        ShowHelp()
    end
end

_G.SLASH_LOAD1 = '/load'
_G.SlashCmdList['LOAD'] = function(addon)
    if addon == '' then
        print('Usage: /load ADDONNAME')
        return
    end
    local _, _, _, _, _, reason = GetAddOnInfo(addon)
    if reason ~= 'MISSING' then
        EnableAddOn(addon)
        ReloadUI()
    else
        print('Addon \'' .. addon .. '\' not found.')
    end
end

_G.SLASH_UNLOAD1 = '/unload'
_G.SlashCmdList['UNLOAD'] = function(addon)
    if addon == '' then
        print('Usage: /unload ADDONNAME')
        return
    end
    local _, _, _, _, _, reason = GetAddOnInfo(addon)
    if reason ~= 'MISSING' then
        DisableAddOn(addon)
        ReloadUI()
    else
        print('Addon \'' .. addon .. '\' not found.')
    end
end
