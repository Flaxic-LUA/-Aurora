UNLOCKDRAGONFLIGHT()

DF.hooks.registry = {}

-- hook operations (might get moved to \wow)

-- Hook: complete function replacement, control original execution
-- tbl (table/string) - table containing function or global function name
-- name (string) - function name in table
-- handler (function) - replacement function
-- returns: nothing
function DF.hooks.Hook(tbl, name, handler)
    if type(tbl) == 'string' then
        handler, name, tbl = name, tbl, _G
    end

    local orig = tbl[name]
    if not orig then return end

    -- store potential for unhooking
    DF.hooks.registry[tbl] = DF.hooks.registry[tbl] or {}
    DF.hooks.registry[tbl][name] = orig

    tbl[name] = handler
end

-- modified Shagu code
-- HookSecureFunc: post-hook function that runs after original
-- tbl (table/string) - table containing function or global function name
-- name (string) - function name in table
-- func (function) - your hook function to run after original
-- returns: nothing
function DF.hooks.HookSecureFunc(tbl, name, func)
    if type(tbl) == 'string' then
        func, name, tbl = name, tbl, _G
    end

    local orig = tbl[name]
    if not orig then return end

    -- Store original for unhooking
    DF.hooks.registry[tbl] = DF.hooks.registry[tbl] or {}
    DF.hooks.registry[tbl][name] = orig

    tbl[name] = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        local ret1, ret2, ret3, ret4, ret5 = orig(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        func(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        return ret1, ret2, ret3, ret4, ret5
    end
end

-- WrapHandler: wrap callback registration functions
-- getter (string) - function name that gets current handler
-- setter (string) - function name that sets new handler
-- wrapper (function) - your function that wraps the original handler
-- returns: nothing
function DF.hooks.WrapHandler(getter, setter, wrapper)
    local original = _G[getter]()
    _G[setter](function(arg1, arg2, arg3, arg4, arg5)
        return wrapper(original, arg1, arg2, arg3, arg4, arg5)
    end)
end

-- HookScript: hook frame script that runs before or after original
-- frame (frame) - frame object to hook script on
-- script (string) - script name to hook
-- handler (function) - your hook function
-- runAfter (boolean) - if true, runs after original; if false/nil, runs before original
-- returns: nothing
function DF.hooks.HookScript(frame, script, handler, runAfter)
    local orig = frame:GetScript(script)

    -- Store original for unhooking
    DF.hooks.registry[frame] = DF.hooks.registry[frame] or {}
    DF.hooks.registry[frame][script] = orig

    frame:SetScript(script, function(arg1, arg2, arg3, arg4, arg5)
        if not runAfter then
            handler(arg1, arg2, arg3, arg4, arg5)
        end
        if orig then orig(arg1, arg2, arg3, arg4, arg5) end
        if runAfter then
            handler(arg1, arg2, arg3, arg4, arg5)
        end
    end)
end

-- IsHooked: check if function or script is currently hooked
-- tbl (table/string) - table containing function or global function name
-- name (string) - function name in table
-- returns: true if hooked, false if not
function DF.hooks.IsHooked(tbl, name)
    if type(tbl) == 'string' then
        name, tbl = tbl, _G
    end

    return DF.hooks.registry[tbl] and DF.hooks.registry[tbl][name] and true or false
end

-- Unhook: restore original function
-- tbl (table/string) - table containing function or global function name
-- name (string) - function name in table
-- returns: true if unhooked, false if not found
function DF.hooks.Unhook(tbl, name)
    if type(tbl) == 'string' then
        name, tbl = tbl, _G
    end

    if DF.hooks.registry[tbl] and DF.hooks.registry[tbl][name] then
        local orig = DF.hooks.registry[tbl][name]

        -- Check if this is a frame script by testing if GetScript works
        local isScript = false
        if tbl.GetScript then
            local success = pcall(function() tbl:GetScript(name) end)
            isScript = success
        end

        if isScript then
            tbl:SetScript(name, orig)
        else
            tbl[name] = orig
        end

        DF.hooks.registry[tbl][name] = nil
        return true
    end
    return false
end
