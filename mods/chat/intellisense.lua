-- DRAGONFLIGHT()

-- DF:NewDefaults('intellisense', {
--     enabled = {value = true},
--     version = {value = '1.0'},
--     gui = {
--         {tab = 'chat', subtab = 'intellisense', categories = 'General'},
--     },

-- })

-- DF:NewModule('intellisense', 1, function()
--     local setup = DF.setups.intellisense

--     -- editbox call
--     setup:CreateChatInput()
--     setup:SetupHooks()
--     setup:LoadLearningData()

--     -- callbacks
--     local callbacks = {}

--     DF:NewCallbacks('intellisense', callbacks)
-- end)


-- local chat = {}

-- -- private
-- function chat:CreateChatFrame()
--     local frame = CreateFrame('Frame', 'DF_ChatFrame', UIParent)
--     frame:SetFrameStrata('BACKGROUND')
--     frame:SetWidth(330)
--     frame:SetHeight(150)
--     frame:SetBackdrop({
--         bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background',
--         edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
--         edgeSize = 16,
--         insets = {left = 4, right = 4, top = 4, bottom = 4}})
--     frame:SetBackdropColor(0, 0, 0, 0.45)
--     frame:SetBackdropBorderColor(0.1, 0.1, 0.1, .5)

--     -- Use ScrollingMessageFrame instead of custom scroll
--     local messageFrame = CreateFrame('ScrollingMessageFrame', nil, frame)
--     messageFrame:SetFrameStrata('LOW')
--     messageFrame:SetPoint('TOPLEFT', 5, -10)
--     messageFrame:SetPoint('BOTTOMRIGHT', -5, 10)
--     messageFrame:SetFont('Fonts\\ARIALN.TTF', 14)
--     messageFrame:SetShadowOffset(1, -1)
--     messageFrame:SetShadowColor(0, 0, 0)
--     messageFrame:SetMaxLines(100)
--     messageFrame:SetFading(false)
--     messageFrame:SetJustifyH('LEFT')
--     messageFrame:EnableMouseWheel(true)
--     messageFrame:SetScript('OnMouseWheel', function()
--         if arg1 > 0 then
--             messageFrame:ScrollUp()
--         else
--             messageFrame:ScrollDown()
--         end
--     end)

--     frame.messageFrame = messageFrame
--     frame.AddMessage = function(_, text, r, g, b)
--         frame.messageFrame:AddMessage(text, r, g, b)
--     end
--     return frame
-- end

-- function chat:CreateChatEditBox()
--     local editBox = CreateFrame('EditBox', 'DF_ChatEditBox', UIParent)
--     editBox:SetHeight(20)
--     editBox:SetAutoFocus(false)
--     editBox:SetFont('Fonts\\FRIZQT__.TTF', 12)
--     editBox:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8X8'})
--     editBox:SetBackdropColor(0, 0, 0, 0.5)
--     editBox.chatType = 'SAY'
--     editBox.stickyType = 'SAY'
--     editBox.language = GetDefaultLanguage()

--     -- dummy header for ChatEdit_UpdateHeader
--     local header = editBox:CreateFontString('DF_ChatEditBoxHeader', 'OVERLAY')
--     header:SetFont('Fonts\\FRIZQT__.TTF', 12)
--     header:SetPoint('LEFT', editBox, 'LEFT', 5, 0)
--     header:SetText('')

--     editBox:SetScript('OnEnterPressed', function()
--         chat:SendChatMessage(editBox)
--         editBox:Hide()
--     end)

--     editBox:SetScript('OnEscapePressed', function()
--         editBox:SetText('')
--         editBox:ClearFocus()
--         editBox:Hide()
--     end)

--     editBox:SetScript('OnSpacePressed', function()
--         ChatEdit_ParseText(editBox, 0)
--     end)

--     return editBox
-- end

-- function chat:UpdateChatFrame(chatFrame, event, message, sender)
--     local r, g, b = 1, 1, 1
--     local text = message

--     -- colors and prefixes based on message type
--     if event == 'LUA_ERROR' then
--         r, g, b = 1, 0, 0
--         text = 'ERROR: ' .. message
--     elseif event == 'CHAT_MSG_SYSTEM' then
--         r, g, b = 1, 1, 0
--     elseif event == 'CHAT_MSG_TEXT_EMOTE' or event == 'CHAT_MSG_EMOTE' then
--         r, g, b = 1, 0.5, 0.25
--     elseif event == 'CHAT_MSG_YELL' then
--         r, g, b = 1, 0, 0
--         text = '[' .. sender .. ']: ' .. message
--     elseif sender and strlen(sender) > 0 then
--         text = '[' .. sender .. ']: ' .. message
--     end

--     chatFrame.messageFrame:AddMessage(text, r, g, b)
-- end

-- function chat:SendChatMessage(editBox)
--     local text = editBox:GetText()
--     if strlen(text) > 0 then
--         if strsub(text, 1, 1) == '/' then
--             -- Process slash commands using Blizzard's parser
--             ChatEdit_ParseText(editBox, 1)
--         else
--             -- Send as regular chat
--             SendChatMessage(text, editBox.chatType)
--         end
--         editBox:SetText('')
--     end
--     editBox:ClearFocus()
-- end

-- function chat:SetupChatEvents(chatFrame)
--     chatFrame:RegisterEvent('CHAT_MSG_SAY')
--     chatFrame:RegisterEvent('CHAT_MSG_YELL')
--     chatFrame:RegisterEvent('CHAT_MSG_PARTY')
--     chatFrame:RegisterEvent('CHAT_MSG_GUILD')
--     chatFrame:RegisterEvent('CHAT_MSG_WHISPER')
--     chatFrame:RegisterEvent('CHAT_MSG_SYSTEM')
--     chatFrame:RegisterEvent('CHAT_MSG_COMBAT_ERROR')
--     chatFrame:RegisterEvent('CHAT_MSG_EMOTE')
--     chatFrame:RegisterEvent('CHAT_MSG_TEXT_EMOTE')

--     chatFrame:SetScript('OnEvent', function()
--         chat:UpdateChatFrame(chatFrame, event, arg1, arg2)
--     end)

--     DF.hooks.WrapHandler('geterrorhandler', 'seterrorhandler', function(original, err)
--         chat:UpdateChatFrame(chatFrame, 'LUA_ERROR', err, 'ERROR')
--         return original(err)
--     end)
-- end

-- -- public
-- function DF.lib.CreateChatWindow()
--     local chatFrame = chat:CreateChatFrame()
--     chat:SetupChatEvents(chatFrame)

--     local editBox = chat:CreateChatEditBox()
--     editBox:SetWidth(200)
--     editBox:SetPoint('CENTER', UIParent, 'CENTER', 0, -155)
--     editBox.chatFrame = chatFrame

--     return chatFrame, editBox
-- end

-- -- test rea
-- local testChatFrame, testEditBox = DF.lib.CreateChatWindow()
-- testChatFrame:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 15, 45)
-- testEditBox:Hide()

-- _G.DEFAULT_CHAT_FRAME = testChatFrame

-- DF.hooks.Hook('ChatFrame_OpenChat', function()
--     testEditBox:Show()
--     testEditBox:SetFocus()
-- end)

-- -- kill blizzard chat v1
-- do
--     _G.ChatFrame1.Show = function() end
--     ChatFrame1:SetAlpha(0)
--     ChatFrame1:ClearAllPoints()
--     ChatFrame1:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', -5000, -5000)
--     ChatFrame1:Hide()
--     DF.common.KillFrame(ChatFrameMenuButton)
--     DF.common.KillFrame(ChatMenu)
--     DF.common.KillFrame(EmoteMenu)
--     DF.common.KillFrame(LanguageMenu)
--     DF.common.KillFrame(VoiceMacroMenu)
--     DF.common.KillFrame(CombatLogQuickButtonFrame)
--     DF.common.KillFrame(ChatFrame1UpButton)
--     DF.common.KillFrame(ChatFrame1DownButton)
--     DF.common.KillFrame(ChatFrame1BottomButton)
--     DF.hooks.Hook('FloatingChatFrame_Update', function() end)
--     DF.hooks.Hook('FCF_DockUpdate', function() end)
--     DF.hooks.Hook('FCF_SelectDockFrame', function() end)
--     DF.hooks.Hook('FCF_UpdateDockPosition', function() end)
--     DF.hooks.Hook('FCF_UpdateButtonSide', function() end)
--     DF.hooks.Hook('FCF_OnUpdate', function() end)
-- end
