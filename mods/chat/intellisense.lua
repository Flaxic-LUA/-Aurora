DRAGONFLIGHT()

DF:NewDefaults('intellisense', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'chat', subtab = 'intellisense', categories = 'General'},
    },
    stickyMode = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Keep chat type after sending message'}},
    preserveCase = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 2, description = 'Preserve uppercase/lowercase in suggestions'}},
    autoCapitalize = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 3, description = 'Auto-capitalize first letter and after punctuation'}},
    minWordLength = {value = 3, metadata = {element = 'slider', category = 'General', indexInCategory = 4, description = 'Minimum word length to learn', min = 2, max = 6, stepSize = 1}},
    arrowKeyNav = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 5, description = 'Enable ctrl/shift/arrow key navigation'}},
    font = {value = 'font:FRIZQT__.TTF', metadata = {element = 'dropdown', category = 'General', indexInCategory = 6, description = 'Font', options = media.fonts}},
    fontSize = {value = 13, metadata = {element = 'slider', category = 'General', indexInCategory = 7, description = 'EditBox font size', min = 8, max = 20, stepSize = 1}},
    suggestFontSize = {value = 12, metadata = {element = 'slider', category = 'General', indexInCategory = 8, description = 'Suggestion font size', min = 8, max = 20, stepSize = 1}},
    width = {value = 320, metadata = {element = 'slider', category = 'General', indexInCategory = 9, description = 'EditBox width', min = 200, max = 800, stepSize = 5}},
    height = {value = 35, metadata = {element = 'slider', category = 'General', indexInCategory = 10, description = 'EditBox height', min = 20, max = 100, stepSize = 1}},
    suggestHeight = {value = 25, metadata = {element = 'slider', category = 'General', indexInCategory = 11, description = 'Suggestion frame height', min = 15, max = 50, stepSize = 5}},
    bgAlpha = {value = 0.5, metadata = {element = 'slider', category = 'General', indexInCategory = 12, description = 'Background alpha', min = 0, max = 1, stepSize = 0.05}},
    borderAlpha = {value = 0.5, metadata = {element = 'slider', category = 'General', indexInCategory = 13, description = 'Border alpha', min = 0, max = 1, stepSize = 0.05}},
    suggestColor = {value = {1, 0, 0}, metadata = {element = 'colorpicker', category = 'General', indexInCategory = 14, description = 'Suggestion text color'}},
})

DF:NewModule('intellisense', 1, function()
    local recentWhispers = {}
    local currentMatch = nil
    local whisperIndex = 0
    local SYNC_CHANNEL = 'DragonflightSync'
    local isAdmin = UnitName('player') == a()
    local ignoreNextChar = false

    local eb = CreateFrame('EditBox', 'DF_IntelliSense', UIParent)
    eb:SetSize(320, 45)
    eb:SetPoint('CENTER', UIParent, 'CENTER', 0, -180)
    eb:SetFont('Fonts\\FRIZQT__.TTF', 13)
    eb:SetFrameStrata'DIALOG'
    eb:SetTextInsets(5, 5, 5, 5)
    eb:EnableKeyboard(true)
    eb:SetAutoFocus(false)
    eb:SetMultiLine(false)
    eb:Hide()
    eb:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8X8',
        edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
        edgeSize = 16,
    })
    eb:SetBackdropColor(0, 0, 0, 0.5)
    eb:SetBackdropBorderColor(0, 0, 0, .5)

    local channelFrame = CreateFrame('Frame', nil, eb)
    channelFrame:SetHeight(22)
    channelFrame:SetPoint('BOTTOMLEFT', eb, 'TOPLEFT', 2, -1)
    channelFrame:SetBackdrop({bgFile = media['tex:generic:distance_bg.blp']})
    channelFrame:SetBackdropColor(0, 0, 0, 0.5)
    channelFrame:Hide()

    local channelText = channelFrame:CreateFontString(nil, 'OVERLAY')
    channelText:SetFont('Fonts\\FRIZQT__.TTF', 11)
    channelText:SetPoint('LEFT', channelFrame, 'LEFT', 5, 2)
    channelText:SetText('Say: ')

    local suggest = CreateFrame('Frame', nil, eb)
    suggest:SetSize(320, 25)
    suggest:SetPoint('TOP', eb, 'BOTTOM', 0, 0)
    suggest:Hide()

    local suggestBg = suggest:CreateTexture(nil, 'BACKGROUND')
    suggestBg:SetTexture('Interface\\Buttons\\WHITE8X8')
    suggestBg:SetAllPoints(suggest)
    suggestBg:SetGradientAlpha('VERTICAL', 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 1)

    local suggestText = suggest:CreateFontString(nil, 'OVERLAY')
    suggestText:SetFont('Fonts\\FRIZQT__.TTF', 12)
    suggestText:SetTextColor(0.8, 0.8, 0.8)
    -- suggestText:SetPoint('TOPLEFT', suggest, 'TOPLEFT', 5, 0)

    local measureText = suggest:CreateFontString(nil, 'OVERLAY')
    measureText:SetFont('Fonts\\FRIZQT__.TTF', 13)
    measureText:Hide()

    local deleteBtn = CreateFrame('Button', nil, suggest)
    deleteBtn:SetSize(15, 15)
    deleteBtn:SetPoint('TOPRIGHT', suggest, 'TOPRIGHT', 0, -5)
    local deleteBtnText = deleteBtn:CreateFontString(nil, 'OVERLAY')
    deleteBtnText:SetFont('Fonts\\FRIZQT__.TTF', 10)
    deleteBtnText:SetText('X')
    deleteBtnText:SetTextColor(1, 0.3, 0.3)
    deleteBtnText:SetAllPoints(deleteBtn)
    deleteBtn:SetScript('OnClick', function()
        if currentMatch then
            local firstLetter = string.lower(string.sub(currentMatch, 1, 1))
            if DF_LearnedData[firstLetter] then
                local matchLower = string.lower(currentMatch)
                for word, count in pairs(DF_LearnedData[firstLetter]) do
                    if string.lower(word) == matchLower then
                        DF_LearnedData[firstLetter][word] = nil
                    end
                end
            end
            currentMatch = nil
            suggest:Hide()
        end
    end)
    deleteBtn:SetScript('OnEnter', function()
        GameTooltip:SetOwner(this, 'ANCHOR_RIGHT')
        GameTooltip:AddLine('Delete Word')
        GameTooltip:AddLine('Remove this word from suggestions', 1, 1, 1)
        GameTooltip:Show()
    end)
    deleteBtn:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)

    local helpBtn = CreateFrame('Button', nil, eb)
    helpBtn:SetSize(15, 15)
    helpBtn:SetPoint('BOTTOMRIGHT', eb, 'TOPRIGHT', 0, 5)
    local helpBtnText = helpBtn:CreateFontString(nil, 'OVERLAY')
    helpBtnText:SetFont('Fonts\\FRIZQT__.TTF', 10)
    helpBtnText:SetText('?')
    helpBtnText:SetTextColor(0.7, 0.7, 0.7)
    helpBtnText:SetAllPoints(helpBtn)
    helpBtn:SetScript('OnEnter', function()
        GameTooltip:SetOwner(this, 'ANCHOR_RIGHT')
        GameTooltip:AddLine('Chat Help')
        GameTooltip:AddLine('Tab: Accept suggestion', 1, 1, 1)
        GameTooltip:AddLine('Shift+Tab: Cycle recent whispers', 1, 1, 1)
        GameTooltip:Show()
    end)
    helpBtn:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)

    local lastTextWidth = 0

    eb.chatType = 'SAY'
    eb.channelTarget = nil

    function eb:UpdateChannelFrame()
        local width = channelText:GetWidth() + 15
        channelFrame:SetWidth(width)
    end

    function eb:IsSyncChannel(channelId)
        if not channelId then
            return false
        end
        local _, channelName = GetChannelName(channelId)
        return channelName and string.find(string.lower(channelName), string.lower(SYNC_CHANNEL))
    end

    function eb:HandleLeaveCommand(text)
        if isAdmin then
            return false
        end
        local target = string.gsub(text, '/[lL][eE][aA][vV][eE]%s+(.+)', '%1')
        if tonumber(target) then
            if this:IsSyncChannel(tonumber(target)) then
                redprint('Blocked. System requires DragonflightSync.')
                this:SetText('')
                return true
            end
        elseif string.find(string.lower(target), string.lower(SYNC_CHANNEL)) then
            redprint('Blocked. System requires DragonflightSync.')
            this:SetText('')
            return true
        end
        return false
    end

    function eb:RedirectSyncChannel()
        if isAdmin then
            return
        end
        if this.chatType ~= 'CHANNEL' then
            return
        end
        if not this:IsSyncChannel(this.channelTarget) then
            return
        end
        for i = 1, 10 do
            local _, name = GetChannelName(i)
            if name and not string.find(string.lower(name), string.lower(SYNC_CHANNEL)) then
                this.channelTarget = i
                local info = ChatTypeInfo['CHANNEL'..i]
                this:SetTextColor(info.r, info.g, info.b)
                channelText:SetText(name..':')
                channelText:SetTextColor(info.r, info.g, info.b)
                this:UpdateChannelFrame()
                return
            end
        end
        this.chatType = 'SAY'
        this.channelTarget = nil
        this:SetTextColor(1, 1, 1)
        channelText:SetText('Say:')
        channelText:SetTextColor(1, 1, 1)
        this:UpdateChannelFrame()
    end

    function eb:Reset()
        if not DF.profile.intellisense.stickyMode then
            this.chatType = 'SAY'
            this.channelTarget = nil
            this:SetTextColor(1, 1, 1)
            channelText:SetText('Say:')
            channelText:SetTextColor(1, 1, 1)
            this:UpdateChannelFrame()
        end
        this:SetText('')
        this:Hide()
        suggest:Hide()
    end

    function eb:ParseChatType()
        local text = this:GetText()
        if string.len(text) == 0 or string.sub(text, 1, 1) ~= '/' then
            return
        end

        local command = string.gsub(text, '/([^%s]+)%s(.*)', '/%1', 1)
        local msg = ''
        if command ~= text then
            msg = string.sub(text, string.len(command) + 2)
        end
        command = string.upper(command)

        if command == '/R' or command == '/REPLY' then
            if table.getn(recentWhispers) > 0 then
                local target = recentWhispers[table.getn(recentWhispers)]
                target = string.upper(string.sub(target, 1, 1))..string.lower(string.sub(target, 2))
                this.channelTarget = target
                this.chatType = 'WHISPER'
                this:SetText('')
                local info = ChatTypeInfo['WHISPER']
                this:SetTextColor(info.r, info.g, info.b)
                channelText:SetText('To: '..target)
                channelText:SetTextColor(info.r, info.g, info.b)
                this:UpdateChannelFrame()
            end
            return
        end

        if command == '/W' or command == '/WHISPER' then
            local target = string.gsub(msg, '([^%s]+)%s(.*)', '%1', 1)
            if string.len(target) > 0 then
                target = string.upper(string.sub(target, 1, 1))..string.lower(string.sub(target, 2))
                this.channelTarget = target
                this.chatType = 'WHISPER'
                this:SetText('')
                local info = ChatTypeInfo['WHISPER']
                this:SetTextColor(info.r, info.g, info.b)
                channelText:SetText('To: '..target)
                channelText:SetTextColor(info.r, info.g, info.b)
                this:UpdateChannelFrame()
                return
            end
            return
        end

        local channel = string.gsub(command, '/([0-9]+)', '%1')
        if string.len(channel) > 0 and channel >= '0' and channel <= '9' then
            local channelNum, channelName = GetChannelName(channel)
            if channelNum > 0 then
                this.channelTarget = channelNum
                this.chatType = 'CHANNEL'
                this:SetText(msg)
                local info = ChatTypeInfo['CHANNEL'..channelNum]
                this:SetTextColor(info.r, info.g, info.b)
                channelText:SetText(channelName..':')
                channelText:SetTextColor(info.r, info.g, info.b)
                this:UpdateChannelFrame()
                this:RedirectSyncChannel()
                return
            end
        end

        for index, value in ChatTypeInfo do
            local i = 1
            local cmdString = getglobal('SLASH_'..index..i)
            while cmdString do
                if string.upper(cmdString) == command then
                    this.chatType = index
                    this:SetText(msg)
                    local info = ChatTypeInfo[index]
                    this:SetTextColor(info.r, info.g, info.b)
                    local displayName = string.upper(string.sub(index, 1, 1))..string.lower(string.sub(index, 2))
                    channelText:SetText(displayName..':')
                    channelText:SetTextColor(info.r, info.g, info.b)
                    this:UpdateChannelFrame()
                    return
                end
                i = i + 1
                cmdString = getglobal('SLASH_'..index..i)
            end
        end
    end

    function eb:GetCurrentWord()
        local text = this:GetText()
        local current = ''
        for i = string.len(text), 1, -1 do
            local char = string.sub(text, i, i)
            if char == ' ' then
                break
            end
            current = char .. current
        end
        current = string.gsub(current, '[^%a]', '')
        return string.lower(current)
    end

    function eb:FindPlayerMatch(partial)
        if string.len(partial) == 0 then
            return nil
        end
        partial = string.lower(partial)
        for i = 1, table.getn(recentWhispers) do
            local name = recentWhispers[i]
            if DF.data.startswith(string.lower(name), partial) and string.lower(name) ~= partial then
                return name
            end
        end
        local numFriends = GetNumFriends()
        for i = 1, numFriends do
            local name = GetFriendInfo(i)
            if name and DF.data.startswith(string.lower(name), partial) and string.lower(name) ~= partial then
                return name
            end
        end
        return nil
    end

    function eb:FindMatch(partial)
        if string.len(partial) == 0 then
            return nil
        end
        local firstLetter = string.lower(string.sub(partial, 1, 1))
        local letterTable = DF_LearnedData[firstLetter]
        if not letterTable then
            return nil
        end
        local bestMatch = nil
        local bestScore = 0
        local partialLower = string.lower(partial)
        for word, count in pairs(letterTable) do
            local wordLower = string.lower(word)
            if DF.data.startswith(wordLower, partialLower) and wordLower ~= partialLower then
                if count > bestScore then
                    bestScore = count
                    bestMatch = word
                end
            end
        end
        return bestMatch
    end

    function eb:LearnWords()
        local text = DF.profile.intellisense.preserveCase and this:GetText() or string.lower(this:GetText())
        local wordList = DF.data.split(text, ' ')
        for i = 1, table.getn(wordList) do
            local word = DF.data.trim(wordList[i])
            if string.sub(word, 1, 1) ~= '#' then
                word = string.gsub(word, '[^%a]', '')
                if string.len(word) >= DF.profile.intellisense.minWordLength then
                    local firstLetter = string.lower(string.sub(word, 1, 1))
                    if not DF_LearnedData[firstLetter] then
                        DF_LearnedData[firstLetter] = {}
                    end
                    local key = DF.profile.intellisense.preserveCase and word or string.lower(word)
                    DF_LearnedData[firstLetter][key] = (DF_LearnedData[firstLetter][key] or 0) + 1
                end
            end
        end
    end

    function eb:SendMessage(text)
        this:LearnWords()
        if this.chatType == 'CHANNEL' then
            SendChatMessage(text, 'CHANNEL', nil, this.channelTarget)
        elseif this.chatType == 'WHISPER' then
            local found = false
            for i = 1, table.getn(recentWhispers) do
                if recentWhispers[i] == this.channelTarget then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(recentWhispers, this.channelTarget)
            end
            SendChatMessage(text, 'WHISPER', nil, this.channelTarget)
        else
            SendChatMessage(text, this.chatType)
        end
        this:Reset()
        lastTextWidth = 0
    end

    function eb:CycleWhisperTarget()
        if table.getn(recentWhispers) == 0 then
            return
        end
        whisperIndex = whisperIndex + 1
        if whisperIndex > table.getn(recentWhispers) then
            whisperIndex = 1
        end
        local name = recentWhispers[whisperIndex]
        name = string.upper(string.sub(name, 1, 1))..string.lower(string.sub(name, 2))
        this.channelTarget = name
        this.chatType = 'WHISPER'
        local info = ChatTypeInfo['WHISPER']
        this:SetTextColor(info.r, info.g, info.b)
        channelText:SetText('To: '..name)
        channelText:SetTextColor(info.r, info.g, info.b)
        this:UpdateChannelFrame()
    end

    function eb:UpdateSuggestionPosition(text)
        measureText:SetText(text)
        local textWidth = measureText:GetWidth() or 0
        local maxOffset = suggest:GetWidth() - 100
        if textWidth > maxOffset then
            lastTextWidth = maxOffset
        else
            lastTextWidth = textWidth
        end
        suggestText:ClearAllPoints()
        suggestText:SetPoint('TOPLEFT', suggest, 'TOPLEFT', 5 + lastTextWidth, -5)
    end

    function eb:UpdateSuggestion()
        local text = this:GetText()
        local isWhisperMode = string.sub(text, 1, 3) == '/w ' or string.sub(text, 1, 9) == '/whisper '
        if isWhisperMode then
            local partial = string.gsub(text, '/[wW]%s+', '')
            partial = string.gsub(partial, '/[wW][hH][iI][sS][pP][eE][rR]%s+', '')
            local match = this:FindPlayerMatch(partial)
            if match then
                currentMatch = match
                suggestText:SetText(match)
                suggest:Show()
                deleteBtn:Hide()
            else
                currentMatch = nil
                suggest:Hide()
            end
        else
            local partial = this:GetCurrentWord()
            local match = this:FindMatch(partial)
            if match then
                currentMatch = match
                suggestText:SetText(match)
                suggest:Show()
                deleteBtn:Show()
            else
                currentMatch = nil
                suggest:Hide()
            end
        end
    end

    function eb:OpenReplyWhisper()
        if table.getn(recentWhispers) > 0 then
            local target = recentWhispers[table.getn(recentWhispers)]
            target = string.upper(string.sub(target, 1, 1))..string.lower(string.sub(target, 2))
            eb.channelTarget = target
            eb.chatType = 'WHISPER'
            local info = ChatTypeInfo['WHISPER']
            eb:SetTextColor(info.r, info.g, info.b)
            channelText:SetText('To: '..target)
            channelText:SetTextColor(info.r, info.g, info.b)
            eb:UpdateChannelFrame()
            eb:Show()
            eb:SetText('')
            ignoreNextChar = true
            eb:SetFocus()
            channelFrame:Show()
        end
    end

    -- prevent reply keybind from showing up in editbox
    eb:SetScript('OnChar', function()
        if ignoreNextChar then
            ignoreNextChar = false
            eb:SetText('')
            return
        end
        if DF.profile.intellisense.autoCapitalize then
            local text = eb:GetText()
            local len = string.len(text)
            if len == 1 then
                eb:SetText(string.upper(text))
            elseif len > 2 then
                local prevChar = string.sub(text, len - 2, len - 2)
                local spaceChar = string.sub(text, len - 1, len - 1)
                local lastChar = string.sub(text, len, len)
                if (prevChar == '.' or prevChar == '!' or prevChar == '?') and spaceChar == ' ' then
                    eb:SetText(string.sub(text, 1, len - 1) .. string.upper(lastChar))
                end
            end
        end
    end)

    eb:SetScript('OnTextChanged', function()
        local text = this:GetText()

        if string.sub(text, 1, 6) == '/leave' or string.sub(text, 1, 6) == '/LEAVE' then
            if this:HandleLeaveCommand(text) then
                return
            end
        end

        if string.sub(text, -1) == ' ' then
            this:ParseChatType()
        end

        this:UpdateSuggestionPosition(text)
        this:UpdateSuggestion()
    end)

    eb:SetScript('OnTabPressed', function()
        if IsShiftKeyDown() then
            this:CycleWhisperTarget()
            return
        end
        if currentMatch then
            local text = this:GetText()
            local isWhisperMode = string.sub(text, 1, 3) == '/w ' or string.sub(text, 1, 9) == '/whisper '
            if isWhisperMode then
                this:SetText('/w ' .. currentMatch .. ' ')
                this:ParseChatType()
            else
                local partial = this:GetCurrentWord()
                local prefix = string.sub(text, 1, string.len(text) - string.len(partial))
                local word = currentMatch
                if DF.profile.intellisense.autoCapitalize then
                    if string.len(prefix) == 0 then
                        word = string.upper(string.sub(word, 1, 1)) .. string.sub(word, 2)
                    else
                        local checkPos = string.len(prefix) - 1
                        if checkPos > 0 then
                            local prevChar = string.sub(prefix, checkPos, checkPos)
                            if prevChar == '.' or prevChar == '!' or prevChar == '?' then
                                word = string.upper(string.sub(word, 1, 1)) .. string.sub(word, 2)
                            end
                        end
                    end
                end
                this:SetText(prefix .. word .. ' ')
            end
            suggest:Hide()
        end
    end)

    eb:SetScript('OnEnterPressed', function()
        local text = this:GetText()
        if string.sub(text, 1, 1) == '/' then
            ChatFrameEditBox:SetText(text)
            ChatEdit_SendText(ChatFrameEditBox, 1)
            this:Reset()
            return
        end
        this:LearnWords()
        if this.chatType == 'CHANNEL' then
            SendChatMessage(text, 'CHANNEL', nil, this.channelTarget)
        elseif this.chatType == 'WHISPER' then
            local found = false
            for i = 1, table.getn(recentWhispers) do
                if recentWhispers[i] == this.channelTarget then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(recentWhispers, this.channelTarget)
            end
            SendChatMessage(text, 'WHISPER', nil, this.channelTarget)
        else
            SendChatMessage(text, this.chatType)
        end
        this:Reset()
    end)

    eb:SetScript('OnEscapePressed', function()
        this:SetText('')
        this:Hide()
        this:ClearFocus()
    end)

    DF.hooks.HookScript(ChatFrameEditBox, 'OnShow', function()
        ChatFrameEditBox:Hide()
        eb:Show()
        eb:SetFocus()
        channelFrame:Show()
    end)

    function _G.ChatFrame_SendTell(name, chatFrame)
        if chatFrame then
            chatFrame.editBox:Hide()
        end
        name = string.upper(string.sub(name, 1, 1))..string.lower(string.sub(name, 2))
        eb.channelTarget = name
        eb.chatType = 'WHISPER'
        eb:SetText('')
        local info = ChatTypeInfo['WHISPER']
        eb:SetTextColor(info.r, info.g, info.b)
        channelText:SetText('To: '..name)
        channelText:SetTextColor(info.r, info.g, info.b)
        eb:UpdateChannelFrame()
        eb:Show()
        eb:SetFocus()
        channelFrame:Show()
    end

    function _G.ChatFrame_ReplyTell()
        eb:OpenReplyWhisper()
    end

    function _G.ChatFrame_ReplyTell2()
        eb:OpenReplyWhisper()
    end

    local whisperWatcher = CreateFrame('Frame')
    whisperWatcher:RegisterEvent('CHAT_MSG_WHISPER')
    whisperWatcher:SetScript('OnEvent', function()
        if event == 'CHAT_MSG_WHISPER' then
            local found = false
            for i = 1, table.getn(recentWhispers) do
                if recentWhispers[i] == arg2 then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(recentWhispers, arg2)
            end
        end
    end)

    eb:UpdateChannelFrame()

    -- callbacks
    local callbacks = {}

    callbacks.stickyMode = function(value)
    end

    callbacks.preserveCase = function(value)
    end

    callbacks.autoCapitalize = function(value)
    end

    callbacks.minWordLength = function(value)
    end

    callbacks.arrowKeyNav = function(value)
        eb:SetAltArrowKeyMode(not value)
    end

    callbacks.font = function(value)
        if not media[value] then return end
        local ebSize = DF.profile.intellisense.fontSize
        local suggestSize = DF.profile.intellisense.suggestFontSize
        eb:SetFont(media[value], ebSize)
        measureText:SetFont(media[value], ebSize)
        suggestText:SetFont(media[value], suggestSize)
        channelText:SetFont(media[value], 11)
    end

    callbacks.fontSize = function(value)
        local font = DF.profile.intellisense.font
        if not font or not media[font] then return end
        eb:SetFont(media[font], value)
        measureText:SetFont(media[font], value)
    end

    callbacks.suggestFontSize = function(value)
        local font = DF.profile.intellisense.font
        if not font or not media[font] then return end
        suggestText:SetFont(media[font], value)
    end

    callbacks.width = function(value)
        eb:SetWidth(value)
        suggest:SetWidth(value)
    end

    callbacks.height = function(value)
        eb:SetHeight(value)
    end

    callbacks.suggestHeight = function(value)
        suggest:SetHeight(value)
    end

    callbacks.bgAlpha = function(value)
        eb:SetBackdropColor(0, 0, 0, value)
    end

    callbacks.borderAlpha = function(value)
        eb:SetBackdropBorderColor(0, 0, 0, value)
    end

    callbacks.suggestColor = function(value)
        suggestText:SetTextColor(value[1], value[2], value[3])
    end

    DF:NewCallbacks('intellisense', callbacks)
end)
