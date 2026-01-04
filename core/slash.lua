---@diagnostic disable: duplicate-set-field
DRAGONFLIGHT()

local function ShowHelp()
    redprint('Commands:')
    print('/df - Toggle Dragonflight GUI')
    print('/df reset [sense|profiles|all] - Wipe DB and reload')
    print('/df edit or /df editmode - Toggle Edit Mode')
    print('/df hover or /df hoverbind - Toggle Hoverbind Mode')
    print('/df safeboot - Disable all addons except Dragonflight')
    print('/gm - Open GM Help')
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
    elseif string.find(msg, 'reset') then
        local resetType = string.sub(msg, 7)
        if resetType == 'sense' then
            DF.ui.StaticPopup_Show(
                'Wipe all Sense Data?',
                'Yes',
                function()
                    _G.DF_LearnedData = {}
                    redprint('Sense Data wiped.')
                end,
                'No'
            )
        elseif resetType == 'profiles' then
            DF.ui.StaticPopup_Show(
                'Wipe Profiles and reload UI?',
                'Yes',
                function()
                    _G.DF_Profiles = {}
                    ReloadUI()
                end,
                'No'
            )
        elseif resetType == 'all' then
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
        else
            redprint('RESET OPTIONS:')
            print('/df reset sense - Wipe Sense Data')
            print('/df reset profiles - Wipe Profiles')
            print('/df reset all - Wipe Everything')
        end
    elseif msg == 'edit' or msg == 'editmode' then
        local frame = getglobal('DF_EditModeFrame')
        if frame then
            if frame:IsShown() then
                frame:Hide()
            else
                frame:Show()
            end
        end
    elseif msg == 'hover' or msg == 'hoverbind' then
        if DF.setups.hover.mainFrame:IsShown() then
            DF.setups.hover:Hide()
        else
            DF.setups.hover:Show()
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

_G.SLASH_GM1 = '/gm'
_G.SlashCmdList['GM'] = function()
    ToggleHelpFrame()
end
