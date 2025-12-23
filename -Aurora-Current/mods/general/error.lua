UNLOCKAURORA()

AU:NewDefaults('error', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'general', subtab = 'error', categories = 'General'},
    },

    errorprint = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Print errors to the chat frame'}},
    hideallerrors = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 2, description = 'Hide all lua errors'}},

})

AU:NewModule('error', 1, function()
    local originalHandler = geterrorhandler()
    local errorCache = {}

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

    callbacks.errorprint = function(value)
        if not AU.profile.error.hideallerrors then
            seterrorhandler(value and customHandler or originalHandler)
        end
    end

    callbacks.hideallerrors = function(value)
        if value then
            seterrorhandler(silentHandler)
        else
            seterrorhandler(AU.profile.error.errorprint and customHandler or originalHandler)
        end
    end

    AU:NewCallbacks('error', callbacks)
end)
