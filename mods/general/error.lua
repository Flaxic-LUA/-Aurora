DRAGONFLIGHT()
if IsAddOnLoaded(info.debugger) then redprint'ERROR LUA EXITED EARLY' return end

DF:NewDefaults('error', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'general', subtab = 'error', 'LUA Errors', 'UI Errors'},
    },

    hideallerrors = {value = false, metadata = {element = 'checkbox', category = 'LUA Errors', indexInCategory = 1, description = 'Hide all lua errors'}},
    errorprint = {value = true, metadata = {element = 'checkbox', category = 'LUA Errors', indexInCategory = 2, description = 'Print errors to the chat frame', dependency = {key = 'hideallerrors', state = false}}},

    hideuierrors = {value = true, metadata = {element = 'checkbox', category = 'UI Errors', indexInCategory = 1, description = 'Hide UI error messages'}},
    printuierrors = {value = true, metadata = {element = 'checkbox', category = 'UI Errors', indexInCategory = 2, description = 'Print UI errors to chat', dependency = {key = 'hideuierrors', state = true}}},
    printonlyooc = {value = true, metadata = {element = 'checkbox', category = 'UI Errors', indexInCategory = 3, description = 'Only print UI errors out of combat', dependency = {key = 'printuierrors', state = true}}},

})

DF:NewModule('error', 1, function()
    local originalHandler = geterrorhandler()
    local errorCache = {}
    local inCombat = false

    local uiErrorFrame = CreateFrame('Frame')
    uiErrorFrame:SetScript('OnEvent', function()
        if event == 'PLAYER_REGEN_DISABLED' then
            inCombat = true
        elseif event == 'PLAYER_REGEN_ENABLED' then
            inCombat = false
        elseif event == 'UI_ERROR_MESSAGE' then
            if not DF.profile.error.printonlyooc or not inCombat then
                print('|cffff9900[UI Error]: ' .. arg1)
            end
        end
    end)

    local function customHandler(msg)
        errorCache[msg] = (errorCache[msg] or 0) + 1
        local _, _, source = string.find(msg, '([^:]+%.lua:%d+)')
        source = source or 'unknown source'

        if errorCache[msg] == 1 then
            print('|cffff0000[Error] - ' .. source .. ': ' .. msg)
        elseif errorCache[msg] == 2 then
            print('|cffff0000[Error Throttled] - ' .. source)
        end
    end

    local function silentHandler() end

    -- callbacks
    local callbacks = {}

    callbacks.hideallerrors = function(value)
        if value then
            seterrorhandler(silentHandler)
        else
            seterrorhandler(DF.profile.error.errorprint and customHandler or originalHandler)
        end
    end

    callbacks.errorprint = function(value)
        if not DF.profile.error.hideallerrors then
            seterrorhandler(value and customHandler or originalHandler)
        end
    end

    callbacks.hideuierrors = function(value)
        if value then
            UIErrorsFrame:Hide()
        else
            UIErrorsFrame:Show()
            uiErrorFrame:UnregisterEvent('UI_ERROR_MESSAGE')
        end
    end

    callbacks.printuierrors = function(value)
        if value then
            uiErrorFrame:RegisterEvent('UI_ERROR_MESSAGE')
            uiErrorFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
            uiErrorFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
        else
            uiErrorFrame:UnregisterEvent('UI_ERROR_MESSAGE')
            uiErrorFrame:UnregisterEvent('PLAYER_REGEN_DISABLED')
            uiErrorFrame:UnregisterEvent('PLAYER_REGEN_ENABLED')
        end
    end

    callbacks.printonlyooc = function(value)
    end

    DF:NewCallbacks('error', callbacks)
end)
