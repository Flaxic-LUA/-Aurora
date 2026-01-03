DRAGONFLIGHT()

local libcast = {}
local player = UnitName('player')
local castframe = CreateFrame('Frame')

libcast.db = {[player] = {}}
libcast.guidToName = {}

function UnitChannelInfo(unit)
    if not unit then return end
    local guid = UnitExists(unit)
    local name = guid and libcast.guidToName[guid] or UnitName(unit)
    local db = libcast.db[name]
    if db and db.cast and db.start + db.casttime / 1000 > GetTime() then
        if not db.channel then return end
        return db.cast, db.rank, '', db.icon, db.start * 1000, db.start * 1000 + db.casttime, nil
    elseif db then
        db.cast, db.rank, db.start, db.casttime, db.icon, db.channel = nil, nil, nil, nil, nil, nil
    end
end

function UnitCastingInfo(unit)
    if not unit then return end
    local guid = UnitExists(unit)
    local name = guid and libcast.guidToName[guid] or UnitName(unit)
    local db = libcast.db[name]
    if db and db.cast and db.start + db.casttime / 1000 > GetTime() then
        if db.channel then return end
        return db.cast, db.rank or '', '', db.icon, db.start * 1000, db.start * 1000 + db.casttime, nil
    elseif db then
        db.cast, db.rank, db.start, db.casttime, db.icon, db.channel = nil, nil, nil, nil, nil, nil
    end
end

castframe:RegisterEvent('UNIT_CASTEVENT')
castframe:SetScript('OnEvent', function()
    local casterGUID, _, eventType, spellID, duration = arg1, arg2, arg3, arg4, arg5

    if eventType == 'START' then
        local name = UnitName(casterGUID)
        if not name then return end
        libcast.guidToName[casterGUID] = name
        if not libcast.db[name] then libcast.db[name] = {} end

        local spellName, _, icon = SpellInfo(spellID)

        libcast.db[name].cast = spellName
        libcast.db[name].rank = nil
        libcast.db[name].start = GetTime()
        libcast.db[name].casttime = duration
        libcast.db[name].icon = icon
        libcast.db[name].channel = false

    elseif eventType == 'CHANNEL' then
        local name = UnitName(casterGUID)
        if not name then return end
        libcast.guidToName[casterGUID] = name
        if not libcast.db[name] then libcast.db[name] = {} end

        local spellName, _, icon = SpellInfo(spellID)

        libcast.db[name].cast = spellName
        libcast.db[name].rank = nil
        libcast.db[name].start = GetTime()
        libcast.db[name].casttime = duration
        libcast.db[name].icon = icon
        libcast.db[name].channel = true

    elseif eventType == 'CAST' or eventType == 'FAIL' then
        local name = UnitName(casterGUID)
        if name and libcast.db[name] then
            libcast.db[name].cast, libcast.db[name].rank, libcast.db[name].start = nil, nil, nil
            libcast.db[name].casttime, libcast.db[name].icon, libcast.db[name].channel = nil, nil, nil
        end
    end
end)

DF.lib.libcast = libcast
