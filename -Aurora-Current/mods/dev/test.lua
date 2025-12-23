---@diagnostic disable: duplicate-set-field
-- AU Test file
UNLOCKAURORA()

-- local combat = {active = false, start = 0, log = {}}
-- local playerGUID = nil

-- local frame = CreateFrame('Frame')
-- frame:RegisterEvent('PLAYER_REGEN_DISABLED')
-- frame:RegisterEvent('PLAYER_REGEN_ENABLED')
-- frame:RegisterEvent('UNIT_CASTEVENT')
-- frame:SetScript('OnEvent', function()
--     if event == 'PLAYER_REGEN_DISABLED' then
--         combat.active = true
--         combat.start = GetTime()
--         combat.log = {}
--         playerGUID = nil
--         debugprint('=== COMBAT START ===')

--     elseif event == 'PLAYER_REGEN_ENABLED' then
--         if combat.active then
--             debugprint('=== COMBAT END (duration: ' .. string.format('%.2f', GetTime() - combat.start) .. 's) ===')
--             for i = 1, table.getn(combat.log) do
--                 debugprint(combat.log[i])
--             end
--             combat.active = false
--         end

--     elseif event == 'UNIT_CASTEVENT' and combat.active then
--         local casterGUID, targetGUID, eventType, spellID, duration = arg1, arg2, arg3, arg4, arg5
--         if not playerGUID and UnitName(casterGUID) == UnitName('player') then
--             playerGUID = casterGUID
--         end
--         if casterGUID == playerGUID and targetGUID then
--             local time = string.format('%.3f', GetTime() - combat.start)
--             local targetName = UnitName(targetGUID) or UnitName('target') or targetGUID
--             local spellName = SpellInfo(spellID)

--             if eventType == 'START' then
--                 table.insert(combat.log, time .. 's - Cast ' .. (spellName or spellID) .. ' on ' .. targetName .. ' (' .. duration .. 'ms)')
--             elseif eventType == 'CAST' then
--                 table.insert(combat.log, time .. 's - Hit ' .. (spellName or spellID) .. ' on ' .. targetName)
--             elseif eventType == 'FAIL' then
--                 table.insert(combat.log, time .. 's - FAILED ' .. (spellName or spellID) .. ' on ' .. targetName)
--             elseif eventType == 'CHANNEL' then
--                 table.insert(combat.log, time .. 's - Channel ' .. (spellName or spellID) .. ' on ' .. targetName .. ' (' .. duration .. 'ms)')
--             elseif eventType == 'MAINHAND' then
--                 table.insert(combat.log, time .. 's - Mainhand swing on ' .. targetName)
--             elseif eventType == 'OFFHAND' then
--                 table.insert(combat.log, time .. 's - Offhand swing on ' .. targetName)
--             end
--         end
--     end
-- end)

-- local testFrame = CreateFrame('Frame')
-- testFrame:RegisterEvent('UNIT_AURA')
-- testFrame:SetScript('OnEvent', function()
--     if event == 'UNIT_AURA' and arg1 == 'target' then
--         debugprint('=== Testing UnitDebuff on target ===')
--         for i = 1, 16 do
--             local a, b, c, d, e, f, g, h, j, k = UnitDebuff('target', i)
--             if a then
--                 debugprint('Debuff '..i..': a='..(a or 'nil')..' b='..(b or 'nil')..' c='..(c or 'nil')..' d='..(d or 'nil')..' e='..(e or 'nil')..' f='..(f or 'nil')..' g='..(g or 'nil')..' h='..(h or 'nil')..' j='..(j or 'nil')..' k='..(k or 'nil'))
--             else
--                 break
--             end
--         end
--     end
-- end)

