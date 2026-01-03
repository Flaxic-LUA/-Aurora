DRAGONFLIGHT()

-- string operations

-- split: splits string by delimiter
-- str (string) - input string to split
-- delim (string) - delimiter, defaults to ','
-- returns: table of strings
function DF.data.split(str, delim)
    if not str then return {} end
    delim = delim or ','
    local result = {}
    local pattern = string.format('([^%s]+)', delim)
    local _ = string.gsub(str, pattern, function(c)
        result[table.getn(result)+1] = c
    end)
    return result
end

-- trim: removes leading and trailing whitespace
-- str (string) - input string to trim
-- returns: trimmed string
function DF.data.trim(str)
    if not str then return '' end
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

-- startswith: checks if string starts with prefix
-- str (string) - input string to check
-- prefix (string) - prefix to look for
-- returns: boolean
function DF.data.startswith(str, prefix)
    if not str or not prefix then return false end
    return string.sub(str, 1, string.len(prefix)) == prefix
end

-- endswith: checks if string ends with suffix
-- str (string) - input string to check
-- suffix (string) - suffix to look for
-- returns: boolean
function DF.data.endswith(str, suffix)
    if not str or not suffix then return false end
    return string.sub(str, -string.len(suffix)) == suffix
end

-- join: joins table elements into string
-- tbl (table) - array of values to join
-- delim (string) - delimiter, defaults to ','
-- returns: joined string
function DF.data.join(tbl, delim)
    if not tbl then return '' end
    delim = delim or ','
    local result = ''
    for i = 1, table.getn(tbl) do
        if i > 1 then result = result .. delim end
        result = result .. tostring(tbl[i])
    end
    return result
end

-- table operations

-- copy: creates shallow or deep copy of table
-- tbl (table) - table to copy
-- deep (boolean) - if true, creates deep copy with circular reference protection
-- returns: copied table
function DF.data.copy(tbl, deep, _lookup)
    -- return as-is instead of error
    if type(tbl) ~= 'table' then return tbl end

    -- lookup table for circular reference protection
    local lookup = _lookup or {}

    -- check for circular reference - return cached copy if exists
    if lookup[tbl] then return lookup[tbl] end

    local result = {}
    lookup[tbl] = result  -- cache before recursion to handle circles

    for k, v in pairs(tbl) do
        if deep then
            -- deep copy table keys too - prevents shared key references
            local newKey = type(k) == 'table' and DF.data.copy(k, true, lookup) or k
            -- recursive copy ensures complete independence from original
            result[newKey] = DF.data.copy(v, true, lookup)
        else
            -- shallow copy - only copy top level, share nested references
            result[k] = v
        end
    end

    -- preserve metatable if it exists
    local mt = getmetatable(tbl)
    if mt then
        setmetatable(result, deep and DF.data.copy(mt, true, lookup) or mt)
    end

    return result
end

-- merge: combines two tables
-- tbl1 (table) - first table
-- tbl2 (table) - second table (overwrites tbl1 values)
-- returns: merged table
function DF.data.merge(tbl1, tbl2)
    if not tbl1 then return tbl2 end
    if not tbl2 then return tbl1 end
    local result = DF.data.copy(tbl1)
    for k, v in pairs(tbl2) do
        result[k] = v
    end
    return result
end

-- keys: extracts all table keys
-- tbl (table) - input table
-- returns: array of keys
function DF.data.keys(tbl)
    if not tbl then return {} end
    local result = {}
    for k, _ in pairs(tbl) do
        result[table.getn(result)+1] = k
    end
    return result
end

-- values: extracts all table values
-- tbl (table) - input table
-- returns: array of values
function DF.data.values(tbl)
    if not tbl then return {} end
    local result = {}
    for _, v in pairs(tbl) do
        result[table.getn(result)+1] = v
    end
    return result
end

-- hasValue: checks if table contains specific value
-- tbl (table) - table to search
-- value (any) - value to find
-- returns: boolean
function DF.data.hasValue(tbl, value)
    if not tbl then return false end
    for _, v in pairs(tbl) do
        if v == value then return true end
    end
    return false
end

-- wipeT: empties table while preserving reference
-- tbl (table) - table to empty
-- returns: same table (now empty)
function DF.data.wipeT(tbl)
    if not tbl then return nil end
    -- Clear all entries while preserving table reference
    for k in pairs(tbl) do
        tbl[k] = nil
    end
    return tbl
end

-- data validation

-- isEmpty: checks if value is empty or nil
-- value (any) - value to check (string, table, or nil)
-- returns: boolean
function DF.data.isEmpty(value)
    if value == nil then return true end
    if type(value) == 'string' then return value == '' end
    if type(value) == 'table' then
        for _ in pairs(value) do return false end
        return true
    end
    return false
end

-- getType: enhanced type detection with array support
-- value (any) - value to check type of
-- returns: string ('array', 'table', or standard Lua type)
function DF.data.getType(value)
    local baseType = type(value)
    if baseType == 'table' then
        -- Check if it's an array (consecutive numeric keys starting from 1)
        local count = 0
        for k in pairs(value) do
            count = count + 1
            if type(k) ~= 'number' or k ~= count then
                return 'table'
            end
        end
        return count > 0 and 'array' or 'table'
    end
    return baseType
end

-- formatTime: formats time values for UI display
-- time (number) - time in seconds
-- decimals (number) - decimal places, defaults to 0 for >=10s, 1 for <10s
-- returns: formatted string with specified precision
function DF.data.formatTime(time, decimals)
    if type(time) ~= 'number' then return '0' end
    decimals = decimals or (time >= 10 and 0 or 1)
    local rounded = DF.math.round(time, decimals)
    return string.format('%.' .. decimals .. 'f', rounded)
end

export('a', import)
export('s', check)
