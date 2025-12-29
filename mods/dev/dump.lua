-- update world tracker

-- TODO: count active users by counting world chat msg and repot to central me

-- local addonframe = CreateFrame('Frame')
-- local pendingGeneralJoin = false
-- local wasInGeneral = false

-- function addonframe:OnPartyMembersChanged()
--     if GetNumPartyMembers() > 0 then
--         SendAddonMessage(info.addonName, 'Hello from party!', 'PARTY')
--     end
-- end

-- function addonframe:OnChannelNotice()
--     if pendingGeneralJoin and string.find(arg9 or '', 'General') then
--         pendingGeneralJoin = false
--         for i = 1, 10 do
--             local id, name = GetChannelName(i)
--             if name and string.find(name, 'General') then
--                 SendChatMessage('hello', 'CHANNEL', nil, id)
--                 break
--             end
--         end
--         if not wasInGeneral then
--             LeaveChannelByName('General')
--         end
--     end
-- end

-- function addonframe:OnPlayerEnteringWorld()
--     DF.hooks.Hook(DEFAULT_CHAT_FRAME, 'AddMessage', function(frame, msg, r, g, b, id)
--         if msg and string.find(msg, 'yells: hello') then
--             debugprint('FILTERED: yell message blocked')
--             DF.hooks.Unhook(DEFAULT_CHAT_FRAME, 'AddMessage')
--             return
--         end
--         local orig = DF.hooks.registry[DEFAULT_CHAT_FRAME]['AddMessage']
--         orig(frame, msg, r, g, b, id)
--     end)

--     wasInGeneral = false
--     for i = 1, 10 do
--         local id, name = GetChannelName(i)
--         if name and string.find(name, 'General') then
--             wasInGeneral = true
--             break
--         end
--     end

--     SendChatMessage('hello', 'SAY')
--     SendChatMessage('hello', 'YELL')

--     if not wasInGeneral then
--         pendingGeneralJoin = true
--         JoinChannelByName('General', '', 1)
--     else
--         for i = 1, 10 do
--             local id, name = GetChannelName(i)
--             if name and string.find(name, 'General') then
--                 SendChatMessage('hello', 'CHANNEL', nil, id)
--                 break
--             end
--         end
--     end
-- end

-- addonframe:RegisterEvent('PARTY_MEMBERS_CHANGED')
-- addonframe:RegisterEvent('PLAYER_ENTERING_WORLD')
-- addonframe:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE')
-- addonframe:SetScript('OnEvent', function()
--     if event == 'PARTY_MEMBERS_CHANGED' then
--         addonframe:OnPartyMembersChanged()
--     end

--     if event == 'CHAT_MSG_CHANNEL_NOTICE' and arg1 == 'YOU_JOINED' then
--         addonframe:OnChannelNotice()
--     end

--     if event == 'PLAYER_ENTERING_WORLD' then
--         addonframe:OnPlayerEnteringWorld()
--     end
-- end)
---------------------------------------------------

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
-------------------------------------------
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


-- local f = CreateFrame('Frame')
-- local timer = 0
-- local waiting = false

-- f:RegisterAllEvents()
-- f:SetScript('OnEvent', function()
--     if not string.find(event, 'CHAT') then
--         debugprint(GetTime() .. ' - ' .. event)
--     end
--     if event == 'PLAYER_ENTERING_WORLD' then
--         waiting = true
--         timer = 0
--     end
-- end)

-- -- f:SetScript('OnUpdate', function()
-- --     if waiting then
-- --         timer = timer + arg1
-- --         if timer >= 1 then
-- --             waiting = false
-- --             debugprint(date('%H:%M:%S') .. ' - AFTER_ENTERING_WORLD')
-- --         end
-- --     end
-- -- end)




-------------------------------------------
-- -- playermodel availability check
-- local testModel = CreateFrame('PlayerModel')
-- local modelReady = false

-- testModel:SetScript('OnUpdate', function()
--     if not modelReady then
--         testModel:SetUnit('player')
--         if testModel:GetModel() then
--             modelReady = true
--             -- debugprint(GetTime() .. ' - PLAYERMODEL_READY')
--             testModel:SetScript('OnUpdate', nil)
--         end
--     end
-- end)
-------------------------------------------
-- -- pet name availability check
-- local petNameReady = false
-- local petChecker = CreateFrame('Frame')

-- petChecker:SetScript('OnUpdate', function()
--     if not petNameReady and UnitExists('pet') then
--         local petName = UnitName('pet')
--         if petName and petName ~= 'Unknown' and petName ~= '' then
--             petNameReady = true
--             debugprint(GetTime() .. ' - PETNAME_READY')
--             petChecker:SetScript('OnUpdate', nil)
--         end
--     end
-- end)



