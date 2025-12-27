---@diagnostic disable: duplicate-set-field
-- AU Test file
UNLOCKDRAGONFLIGHT()
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
