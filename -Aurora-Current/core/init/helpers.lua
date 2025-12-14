UNLOCKAURORA()

_G.SLASH_AURORA1 = '/au'
_G.SLASH_AURORA2 = '/aurora'
_G.SlashCmdList['AURORA'] = function(msg)
    if msg == 'help' then
        print('COMMANDS:')
        print('/au - Toggle Aurora GUI')
        print('/au reset - Wipe DB and reload')
        print('/au edit or /au editmode - Toggle Edit Mode')
        print('/load ADDONNAME - Load addon')
        print('/unload ADDONNAME - Unload addon')
    elseif msg == 'reset' then
        AU.ui.StaticPopup_Show(
            'Wipe AU_GlobalDB and reload UI?',
            'Yes',
            function()
                _G.AU_GlobalDB = {}
                ReloadUI()
            end,
            'No'
        )
    elseif msg == 'edit' or msg == 'editmode' then
        local frame = getglobal('AU_EditModeFrame')
        if frame then
            if frame:IsShown() then
                frame:Hide()
            else
                frame:Show()
            end
        end
    else
        AURORAToggleGUI()
    end
end
