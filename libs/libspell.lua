UNLOCKDRAGONFLIGHT()

-- credit to shagu v1.0
local scanner = DF.lib.libtipscan:GetScanner('libspell')
local libspell = {}

local spellmaxrank = {}
function libspell:GetSpellMaxRank(name)
    local cache = spellmaxrank[name]
    if cache then return cache[1], cache[2] end
    name = string.lower(name)

    local rank = {0, nil}
    for i = 1, GetNumSpellTabs() do
        local _, _, offset, num = GetSpellTabInfo(i)
        for id = offset + 1, offset + num do
            local spellName, spellRank = GetSpellName(id, BOOKTYPE_SPELL)
            if name == string.lower(spellName) then
                if not rank[2] then rank[2] = spellRank end
                local _, _, numRank = string.find(spellRank, ' (%d+)$')
                if numRank and tonumber(numRank) > rank[1] then
                    rank = {tonumber(numRank), spellRank}
                end
            end
        end
    end

    spellmaxrank[name] = {rank[2], rank[1]}
    return rank[2], rank[1]
end

local spellindex = {}
function libspell:GetSpellIndex(name, rank)
    if not name then return end
    name = string.lower(name)
    local cache = spellindex[name .. (rank and ('(' .. rank .. ')') or '')]
    if cache then return cache[1], cache[2] end

    if not rank then rank = self:GetSpellMaxRank(name) end

    for i = 1, GetNumSpellTabs() do
        local _, _, offset, num = GetSpellTabInfo(i)
        for id = offset + 1, offset + num do
            local spellName, spellRank = GetSpellName(id, BOOKTYPE_SPELL)
            if rank and rank == spellRank and name == string.lower(spellName) then
                spellindex[name .. '(' .. rank .. ')'] = {id, BOOKTYPE_SPELL}
                return id, BOOKTYPE_SPELL
            elseif not rank and name == string.lower(spellName) then
                spellindex[name] = {id, BOOKTYPE_SPELL}
                return id, BOOKTYPE_SPELL
            end
        end
    end

    spellindex[name .. (rank and ('(' .. rank .. ')') or '')] = {nil}
    return nil
end

local spellinfo = {}
function libspell:GetSpellInfo(index, bookType)
    local cache = spellinfo[index]
    if cache then return cache[1], cache[2], cache[3], cache[4], cache[5], cache[6], cache[7], cache[8] end

    local name, rank, id
    local icon = ''
    local castingTime = 0
    local minRange = 0
    local maxRange = 0

    if type(index) == 'string' then
        local _, _, sname, srank = string.find(index, '(.+)%((.+)%)')
        name = sname or index
        rank = srank or self:GetSpellMaxRank(name)
        id, bookType = self:GetSpellIndex(name, rank)
        if id and bookType then
            name = GetSpellName(id, bookType)
        end
    else
        name, rank = GetSpellName(index, bookType)
        id, bookType = self:GetSpellIndex(name, rank)
    end

    if name and id then
        icon = GetSpellTexture(id, bookType)
    end

    if id then
        scanner:SetSpell(id, bookType)
        local _, castTime = scanner:FindText('(%d+%.%d+) sec cast')
        local _, castTimeMin = scanner:FindText('(%d+%.%d+) min cast')
        local _, range = scanner:FindText('(%d+) yd range')

        castingTime = (tonumber(castTime) or tonumber(castTimeMin) or 0) * 1000
        if range then
            local _, _, min, max = string.find(range, '(%d+)%-(%d+)')
            if min and max then
                minRange = tonumber(min)
                maxRange = tonumber(max)
            else
                minRange = 0
                maxRange = tonumber(range)
            end
        end
    end

    spellinfo[index] = {name, rank, icon, castingTime, minRange, maxRange, id, bookType}
    return name, rank, icon, castingTime, minRange, maxRange, id, bookType
end

local resetcache = CreateFrame('Frame')
resetcache:RegisterEvent('LEARNED_SPELL_IN_TAB')
resetcache:SetScript('OnEvent', function()
    spellmaxrank, spellindex, spellinfo = {}, {}, {}
end)

DF.lib.libspell = libspell

-- local testFrame = CreateFrame('Frame')
-- testFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
-- testFrame:SetScript('OnEvent', function()
--     debugprint('=== Testing libspell ===')

--     -- Test Fireball
--     debugprint('Test: Fireball spell')
--     local name, rank, icon, castTime, minRange, maxRange, id, book = DF.lib.libspell:GetSpellInfo('Fireball')
--     debugprint('Name: ' .. (name or 'nil'))
--     debugprint('Rank: ' .. (rank or 'nil'))
--     debugprint('Icon: ' .. (icon or 'nil'))
--     debugprint('Cast Time: ' .. (castTime or 0) .. 'ms')
--     debugprint('Range: ' .. (minRange or 0) .. '-' .. (maxRange or 0) .. ' yards')
--     debugprint('ID: ' .. (id or 'nil'))

--     debugprint('=== libspell tests complete ===')
-- end)
