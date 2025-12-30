UNLOCKDRAGONFLIGHT()

-- credit to shagu v1.0
local libdebuff = CreateFrame('Frame', 'AUDebuffScanner', UIParent)
local scanner = DF.lib.libtipscan:GetScanner('libdebuff')
local _, playerClass = UnitClass('player')
local lastSpell
local cmatch = DF.lua.cmatch

libdebuff.debuffs = {}
libdebuff.pending = {}
libdebuff.queueFrame = CreateFrame('Frame')
libdebuff.queueFrame.queue = {}
libdebuff.queueFrame.interval = 0.2
libdebuff.queueFrame:SetScript('OnUpdate', function()
    this.sinceLast = (this.sinceLast or 0) + arg1
    while this.sinceLast > this.interval do
        local item = table.remove(this.queue, 1)
        if item then item() end
        this.sinceLast = this.sinceLast - this.interval
        if table.getn(this.queue) == 0 then
            this:Hide()
            return
        end
    end
end)
libdebuff.queueFrame:Hide()

function libdebuff:QueueFunction(func)
    table.insert(self.queueFrame.queue, func)
    self.queueFrame:Show()
end

local REMOVE_PENDING = {
    SPELLIMMUNESELFOTHER, IMMUNEDAMAGECLASSSELFOTHER,
    SPELLMISSSELFOTHER, SPELLRESISTSELFOTHER, SPELLEVADEDSELFOTHER,
    SPELLDODGEDSELFOTHER, SPELLDEFLECTEDSELFOTHER, SPELLREFLECTSELFOTHER,
    SPELLPARRIEDSELFOTHER, SPELLLOGABSORBSELFOTHER, SPELLFAILCASTSELF
}

function libdebuff:GetDuration(effect, rank)
    if not DF.tables['debuffs'] or not DF.tables['debuffs'][effect] then
        return 0
    end

    local rankNum = 0
    if rank then
        local numStr = string.gsub(rank, RANK, '')
        if numStr and numStr ~= '' then
            rankNum = tonumber(numStr) or 0
        end
    end
    rankNum = DF.tables['debuffs'][effect][rankNum] and rankNum or self:GetMaxRank(effect)
    local duration = DF.tables['debuffs'][effect][rankNum]

    if not duration then return 0 end

    local dyn = DF.tables['dyndebuffs']
    if effect == dyn['Rupture'] then
        duration = duration + GetComboPoints() * 2
    elseif effect == dyn['Kidney Shot'] then
        duration = duration + GetComboPoints() * 1
    elseif effect == dyn['Demoralizing Shout'] then
        local _, _, _, _, count = GetTalentInfo(2, 1)
        if count and count > 0 then
            duration = duration + (duration / 100 * (count * 10))
        end
    elseif effect == dyn['Shadow Word: Pain'] then
        local _, _, _, _, count = GetTalentInfo(3, 4)
        if count and count > 0 then
            duration = duration + count * 3
        end
    elseif effect == dyn['Frostbolt'] then
        local _, _, _, _, count = GetTalentInfo(3, 7)
        if count and count > 0 then
            duration = duration + count
        end
    elseif effect == dyn['Gouge'] then
        local _, _, _, _, count = GetTalentInfo(2, 1)
        if count and count > 0 then
            duration = duration + (count * 0.5)
        end
    end

    return duration
end

function libdebuff:GetMaxRank(effect)
    if not DF.tables['debuffs'] or not DF.tables['debuffs'][effect] then
        return 0
    end
    local max = 0
    for id in pairs(DF.tables['debuffs'][effect]) do
        if id > max then max = id end
    end
    return max
end

function libdebuff:UpdateDuration(unit, level, effect, duration)
    if not unit or not effect or not duration then return end
    level = level or 0

    if self.debuffs[unit] and self.debuffs[unit][level] and self.debuffs[unit][level][effect] then
        self.debuffs[unit][level][effect].duration = duration
    end
end

function libdebuff:AddPending(unit, level, effect, duration, caster)
    if not unit or not effect or duration <= 0 then return end
    if not DF.tables['debuffs'] or not DF.tables['debuffs'][effect] then return end
    if self.pending[3] then return end

    self.pending[1] = unit
    self.pending[2] = level or 0
    self.pending[3] = effect
    self.pending[4] = duration
    self.pending[5] = caster

    self:QueueFunction(function() libdebuff:PersistPending() end)
end

function libdebuff:RemovePending()
    self.pending[1] = nil
    self.pending[2] = nil
    self.pending[3] = nil
    self.pending[4] = nil
    self.pending[5] = nil
end

function libdebuff:PersistPending(effect)
    if not libdebuff.pending[3] then return end

    if libdebuff.pending[3] == effect or (effect == nil and libdebuff.pending[3]) then
        libdebuff:AddEffect(libdebuff.pending[1], libdebuff.pending[2], libdebuff.pending[3], libdebuff.pending[4], libdebuff.pending[5])
    end

    libdebuff:RemovePending()
end

function libdebuff:RevertLastAction()
    if not lastSpell then return end
    lastSpell.start = lastSpell.startOld
    lastSpell.startOld = nil
end

function libdebuff:AddEffect(unit, level, effect, duration, caster)
    if not unit or not effect then return end
    level = level or 0

    if not self.debuffs[unit] then self.debuffs[unit] = {} end
    if not self.debuffs[unit][level] then self.debuffs[unit][level] = {} end
    if not self.debuffs[unit][level][effect] then self.debuffs[unit][level][effect] = {} end

    lastSpell = self.debuffs[unit][level][effect]

    self.debuffs[unit][level][effect].effect = effect
    self.debuffs[unit][level][effect].startOld = self.debuffs[unit][level][effect].start
    self.debuffs[unit][level][effect].start = GetTime()
    self.debuffs[unit][level][effect].duration = duration or self:GetDuration(effect)
    self.debuffs[unit][level][effect].caster = caster
end

libdebuff:RegisterEvent('CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE')
libdebuff:RegisterEvent('CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE')
libdebuff:RegisterEvent('CHAT_MSG_SPELL_FAILED_LOCALPLAYER')
libdebuff:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
libdebuff:RegisterEvent('PLAYER_TARGET_CHANGED')
libdebuff:RegisterEvent('SPELLCAST_STOP')
libdebuff:RegisterEvent('UNIT_AURA')

if playerClass == 'PALADIN' then
    libdebuff:RegisterEvent('CHAT_MSG_COMBAT_SELF_HITS')
end

libdebuff:SetScript('OnEvent', function()
    if event == 'CHAT_MSG_COMBAT_SELF_HITS' then
        local hit = cmatch(arg1, COMBATHITSELFOTHER)
        local crit = cmatch(arg1, COMBATHITCRITSELFOTHER)
        if hit or crit then
            for seal in pairs(DF.tables['judgements']) do
                local name = UnitName('target')
                local level = UnitLevel('target')
                if name and libdebuff.debuffs[name] then
                    if level and libdebuff.debuffs[name][level] and libdebuff.debuffs[name][level][seal] then
                        libdebuff:AddEffect(name, level, seal)
                    elseif libdebuff.debuffs[name][0] and libdebuff.debuffs[name][0][seal] then
                        libdebuff:AddEffect(name, 0, seal)
                    end
                end
            end
        end

    elseif event == 'CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE' or event == 'CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE' then
        local unit, effect = cmatch(arg1, AURAADDEDOTHERHARMFUL)
        if unit and effect then
            local level = UnitName('target') == unit and UnitLevel('target') or 0
            if not libdebuff.debuffs[unit] or not libdebuff.debuffs[unit][level] or not libdebuff.debuffs[unit][level][effect] then
                libdebuff:AddEffect(unit, level, effect)
            end
        end

    elseif (event == 'UNIT_AURA' and arg1 == 'target') or event == 'PLAYER_TARGET_CHANGED' then
        for i = 1, 16 do
            local effect, rank, texture, stacks, dtype, duration, timeleft = libdebuff:UnitDebuff('target', i)
            if not texture then return end

            if texture and effect and effect ~= '' then
                local level = UnitLevel('target') or 0
                local unit = UnitName('target')
                if not libdebuff.debuffs[unit] or not libdebuff.debuffs[unit][level] or not libdebuff.debuffs[unit][level][effect] then
                    libdebuff:AddEffect(unit, level, effect)
                end
            end
        end

    elseif event == 'CHAT_MSG_SPELL_FAILED_LOCALPLAYER' or event == 'CHAT_MSG_SPELL_SELF_DAMAGE' then
        for _, msg in pairs(REMOVE_PENDING) do
            local effect = cmatch(arg1, msg)
            if effect and libdebuff.pending[3] == effect then
                libdebuff:RemovePending()
                return
            elseif effect and lastSpell and lastSpell.startOld and lastSpell.effect == effect then
                libdebuff:RevertLastAction()
                return
            end
        end

    elseif event == 'SPELLCAST_STOP' then
        libdebuff:PersistPending()
    end
end)

DF.hooks.HookSecureFunc('CastSpell', function(id, bookType)
    local effect, rank = DF.lib.libspell:GetSpellInfo(id, bookType)
    local duration = libdebuff:GetDuration(effect, rank)
    libdebuff:AddPending(UnitName('target'), UnitLevel('target'), effect, duration, 'player')
end)

DF.hooks.HookSecureFunc('CastSpellByName', function(spellName, target)
    local effect, rank = DF.lib.libspell:GetSpellInfo(spellName)
    local duration = libdebuff:GetDuration(effect, rank)
    libdebuff:AddPending(UnitName('target'), UnitLevel('target'), effect, duration, 'player')
end)

DF.hooks.HookSecureFunc('UseAction', function(slot, target, button)
    if GetActionText(slot) or not IsCurrentAction(slot) then return end
    scanner:SetAction(slot)
    local effect, rank = scanner:GetLine(1)
    local duration = libdebuff:GetDuration(effect, rank)
    libdebuff:AddPending(UnitName('target'), UnitLevel('target'), effect, duration, 'player')
end)

function libdebuff:UnitDebuff(unit, id)
    local unitName = UnitName(unit)
    local unitLevel = UnitLevel(unit)
    local texture, stacks, dtype = UnitDebuff(unit, id)
    local duration, timeleft = nil, -1
    local rank = nil
    local caster = nil
    local effect

    if texture then
        scanner:SetUnitDebuff(unit, id)
        effect = scanner:GetLine(1) or ''
        -- debugprint('Scanner line 1: '..(effect or 'nil')..', texture: '..(texture or 'nil'))
    end

    local data = self.debuffs[unitName] and self.debuffs[unitName][unitLevel]
    data = data or self.debuffs[unitName] and self.debuffs[unitName][0]

    if data and data[effect] then
        if data[effect].duration and data[effect].start and data[effect].duration + data[effect].start > GetTime() then
            duration = data[effect].duration
            timeleft = duration + data[effect].start - GetTime()
            caster = data[effect].caster
        else
            data[effect] = nil
        end
    end

    return effect, rank, texture, stacks, dtype, duration, timeleft, caster
end

local cache = {}
function libdebuff:UnitOwnDebuff(unit, id)
    for k in pairs(cache) do cache[k] = nil end

    local count = 1
    for i = 1, 16 do
        local effect, rank, texture, stacks, dtype, duration, timeleft, caster = self:UnitDebuff(unit, i)
        if effect and not cache[effect] and caster and caster == 'player' then
            cache[effect] = true

            if count == id then
                return effect, rank, texture, stacks, dtype, duration, timeleft, caster
            else
                count = count + 1
            end
        end
    end
end

DF.lib.libdebuff = libdebuff


-- _G.SLASH_LIBDEBUFFTEST1 = '/ldt'
-- _G.SlashCmdList['LIBDEBUFFTEST'] = function()
--     local e, r, t, s, d, dur, tl, c = libdebuff:UnitDebuff('target', 1)
--     debugprint('Effect: ' .. (e or 'nil') .. ' Dur: ' .. (dur or 'nil') .. ' Left: ' .. (tl or 'nil'))
-- end
