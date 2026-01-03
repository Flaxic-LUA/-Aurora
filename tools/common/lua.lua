DRAGONFLIGHT()

-- lua 5.1 operations

-- match: pattern matching without position info
-- str (string) - string to search in
-- pattern (string) - Lua pattern to match
-- returns: captured groups or matched substring
function DF.lua.match(str, pattern)
    local _, _, capture1, capture2, capture3 = string.find(str, pattern)
    if capture1 then
        return capture1, capture2, capture3
    else
        local start, stop = string.find(str, pattern)
        if start then
            return string.sub(str, start, stop)
        end
    end
end

-- cmatch: pattern matching for combat log (up to 5 captures)
-- str (string) - string to search in
-- pattern (string) - Lua pattern to match
-- returns: up to 5 captured values
function DF.lua.cmatch(str, pattern)
    if not str or not pattern then return nil end
    local _, _, a, b, c, d, e = string.find(str, pattern)
    return a, b, c, d, e
end

-- maxn: finds highest numeric key in table
-- t (table) - table to search
-- returns: highest numeric index
function DF.lua.maxn(t)
    local max = 0
    for k in pairs(t) do
        if type(k) == 'number' and k > max then max = k end
    end
    return max
end

-- reverse: reverses a string
-- s (string) - string to reverse
-- returns: reversed string
function DF.lua.reverse(s)
    local result = ''
    for i = string.len(s), 1, -1 do
        result = result .. string.sub(s, i, i)
    end
    return result
end
