-- DRAGONFLIGHT()

-- local setup = {
--     container = nil,
--     indicator = nil,
--     suggestionFrame = nil,
--     suggestion = nil,
--     measureText = nil,

--     -- learning data
--     phrases = {},
--     phraseMaxWords = 6,
--     wordFreq = {},
--     wordNext = {},
--     lastMessage = '',
--     currentMatch = nil,
--     currentMatchType = nil,
--     lastUpdateTime = 0,

--     textures = {
--         indicator = media['tex:interface:chat_indicator.blp']
--     }
-- }

-- -- create: builds chat input container, indicator, suggestion frames and positions editbox
-- function setup:CreateChatInput()
--     local regions = {ChatFrameEditBox:GetRegions()}
--     for i = 1, table.getn(regions) do
--         if regions[i] and regions[i]:GetObjectType() == 'Texture' then
--             local layer = regions[i]:GetDrawLayer()
--             if layer ~= 'OVERLAY' then
--                 regions[i]:SetTexture(nil)
--             end
--         end
--     end

--     self.container = CreateFrame('Frame', 'DF_ChatInputContainer', UIParent)
--     self.container:SetSize(320, 35)
--     self.container:SetBackdrop({
--         bgFile = 'Interface\\Buttons\\WHITE8X8',
--         edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
--         edgeSize = 16,
--         insets = {left = 5, right = 5, top = 5, bottom = 5}
--     })
--     self.container:SetBackdropColor(0, 0, 0, 0.5)
--     self.container:SetBackdropBorderColor(0, 0, 0, .5)
--     self.container:Hide()

--     ChatFrameEditBox:ClearAllPoints()
--     ChatFrameEditBox:SetPoint('CENTER', self.container, 'CENTER', 0, 0)
--     ChatFrameEditBox:SetWidth(300)
--     ChatFrameEditBox:SetAltArrowKeyMode(false)

--     -- self.indicator = CreateFrame('Frame', nil, self.container)
--     -- self.indicator:SetSize(15, 15)
--     -- self.indicator:SetPoint('BOTTOMLEFT', ChatFrameEditBox, 'BOTTOMLEFT', 0, -3)
--     -- local indBg = self.indicator:CreateTexture(nil, 'OVERLAY')
--     -- indBg:SetAllPoints()
--     -- indBg:SetTexture(self.textures.indicator)

--     self.suggestionFrame = CreateFrame('Frame', nil, UIParent)
--     self.suggestionFrame:SetFrameStrata('TOOLTIP')
--     self.suggestionFrame:SetFrameLevel(100)
--     self.suggestionFrame:Hide()

--     self.suggestion = self.suggestionFrame:CreateFontString(nil, 'OVERLAY')
--     self.suggestion:SetFont(ChatFrameEditBox:GetFont())
--     self.suggestion:SetTextColor(0.5, 0.5, 0.5)

--     self.measureText = self.suggestionFrame:CreateFontString(nil, 'OVERLAY')
--     self.measureText:SetFont(ChatFrameEditBox:GetFont())
--     self.measureText:Hide()

--     return self.container
-- end

-- -- hooks: registers editbox events for text changes, tab completion, show/hide and position management
-- function setup:SetupHooks()
--     DF.hooks.HookScript(ChatFrameEditBox, 'OnTextChanged', function()
--         setup:UpdateSuggestion()
--     end)

--     DF.hooks.HookScript(ChatFrameEditBox, 'OnTabPressed', function()
--         setup:CompleteSuggestion()
--     end)

--     DF.hooks.HookScript(ChatFrameEditBox, 'OnEnterPressed', function()
--         setup:LearnFromMessage(ChatFrameEditBox:GetText())
--     end)

--     DF.hooks.HookScript(ChatFrameEditBox, 'OnShow', function()
--         setup.container:Show()
--     end)

--     DF.hooks.HookScript(ChatFrameEditBox, 'OnHide', function()
--         setup.container:Hide()
--         setup.suggestionFrame:Hide()
--     end)

--     local hookUIParent_ManageFramePositions = _G.UIParent_ManageFramePositions
--     _G.UIParent_ManageFramePositions = function(a1, a2, a3)
--         hookUIParent_ManageFramePositions(a1, a2, a3)
--         setup.container:ClearAllPoints()
--         local pos = DF.profile['editmode']['framePositions']['DF_ChatInputContainer']
--         if pos and pos.x and pos.y then
--             setup.container:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', pos.x, pos.y)
--         else
--             setup.container:SetPoint('CENTER', UIParent, 'CENTER', 0, -150)
--         end
--     end
-- end

-- -- tab press: accepts one word only from suggestion
-- function setup:CompleteSuggestion()
--     if self.suggestionFrame:IsShown() and self.currentMatch and self.currentMatchType then
--         local text = ChatFrameEditBox:GetText()
--         local context = self:AnalyzeInput(text)
--         local wordToComplete = self.currentMatch

--         -- if phrase, extract the word at current position
--         if self.currentMatchType == 'phrase' then
--             local textLen = string.len(text)
--             local remainingPhrase = string.sub(self.currentMatch, textLen + 1)
--             local spacePos = string.find(remainingPhrase, ' ')
--             if spacePos then
--                 wordToComplete = string.sub(remainingPhrase, 1, spacePos - 1)
--             else
--                 wordToComplete = remainingPhrase
--             end
--         end

--         --debugprint('[AUTOCOMPLETE] Tab - accepting one word: ' .. wordToComplete)

--         local finalText = ''
--         if self.currentMatchType == 'pair' then
--             finalText = text .. wordToComplete
--         elseif self.currentMatchType == 'phrase' then
--             finalText = text .. wordToComplete
--         else -- freq
--             local prefixLen = string.len(text) - string.len(context.currentWord)
--             finalText = string.sub(text, 1, prefixLen) .. wordToComplete
--         end

--         if string.sub(finalText, -1) ~= ' ' then
--             finalText = finalText .. ' '
--         end

--         ChatFrameEditBox:SetText(finalText)
--         self.suggestionFrame:Hide()
--     end
-- end

-- -- logic ----------

-- -- main handler: orchestrates prediction pipeline and calls logic methods
-- function setup:UpdateSuggestion()
--     local now = GetTime()
--     if now - self.lastUpdateTime < 0.05 then
--         return
--     end
--     self.lastUpdateTime = now

--     local text = ChatFrameEditBox:GetText()
--     --debugprint('[AUTOCOMPLETE] Input changed: "' .. text .. '"')

--     -- step 1: analyze input
--     local context = self:AnalyzeInput(text)

--     -- step 2: find matches
--     local matches = self:FindMatches(text, context)

--     -- step 3: rank suggestions
--     local bestMatch = self:RankSuggestions(matches, context)

--     -- step 4: display
--     if bestMatch then
--         self:DisplaySuggestion(text, bestMatch, context)
--     else
--         self.suggestionFrame:Hide()
--     end
-- end

-- -- step 1: analyze input and extract context
-- function setup:AnalyzeInput(text)
--     local words = {}
--     local current = ''

--     for i = 1, string.len(text) do
--         local char = string.sub(text, i, i)
--         if char == ' ' then
--             if string.len(current) > 0 then
--                 table.insert(words, current)
--                 current = ''
--             end
--         else
--             current = current .. char
--         end
--     end

--     local isTypingWord = string.len(current) > 0
--     local currentWord = current
--     local previousWord = words[table.getn(words)]

--     local mode = isTypingWord and 'typing word' or 'after space'
--     --debugprint('[STEP 1] Context: ' .. mode .. ' | current="' .. (currentWord or '') .. '" | prev="' .. (previousWord or '') .. '"')

--     return {
--         currentWord = currentWord,
--         previousWord = previousWord,
--         isTypingWord = isTypingWord,
--         fullText = text
--     }
-- end

-- -- step 2: find candidate matches from phrases and words
-- function setup:FindMatches(text, context)
--     local matches = {}
--     local textLower = string.lower(text)
--     local phraseCount = 0
--     local pairCount = 0
--     local freqCount = 0

--     -- priority 1: phrase matches (only if phrase is longer than input)
--     if string.len(text) > 0 then
--         for phrase, count in pairs(self.phrases) do
--             local phraseLower = string.lower(phrase)
--             if string.len(phraseLower) > string.len(textLower) and string.sub(phraseLower, 1, string.len(textLower)) == textLower then
--                 table.insert(matches, {word = phrase, score = count * 1000, source = 'phrase'})
--                 phraseCount = phraseCount + 1
--             end
--         end
--     end

--     -- priority 2: word-pair matches (if typing new word after space)
--     if not context.isTypingWord and context.previousWord then
--         local prevLower = string.lower(context.previousWord)
--         if self.wordNext[prevLower] then
--             for nextWord, count in pairs(self.wordNext[prevLower]) do
--                 table.insert(matches, {word = nextWord, score = count * 100, source = 'pair'})
--                 pairCount = pairCount + 1
--             end
--         end
--     end

--     -- priority 3: word frequency matches (if typing partial word)
--     if context.isTypingWord and string.len(context.currentWord) > 0 then
--         local currentLower = string.lower(context.currentWord)
--         for word, count in pairs(self.wordFreq) do
--             local wordLower = string.lower(word)
--             if string.sub(wordLower, 1, string.len(currentLower)) == currentLower then
--                 table.insert(matches, {word = word, score = count, source = 'freq'})
--                 freqCount = freqCount + 1
--             end
--         end
--     end

--     --debugprint('[STEP 2] Found ' .. table.getn(matches) .. ' matches: ' .. phraseCount .. ' phrases, ' .. pairCount .. ' pairs, ' .. freqCount .. ' words')

--     return matches
-- end

-- -- step 3: rank suggestions and return best match object
-- function setup:RankSuggestions(matches, context)
--     if table.getn(matches) == 0 then
--         --debugprint('[STEP 3] No matches to rank')
--         return nil
--     end

--     -- sort by score descending, prefer longer matches on tie
--     table.sort(matches, function(a, b)
--         if a.score == b.score then
--             return string.len(a.word) > string.len(b.word)
--         end
--         return a.score > b.score
--     end)

--     local best = matches[1]
--     --debugprint('[STEP 3] Best match: "' .. best.word .. '" (score=' .. best.score .. ', source=' .. best.source .. ')')

--     return best
-- end

-- -- step 4: display suggestion at correct position
-- function setup:DisplaySuggestion(text, bestMatch, context)
--     self.currentMatch = bestMatch.word
--     self.currentMatchType = bestMatch.source

--     local displayText = ''
--     if bestMatch.source == 'phrase' then
--         displayText = string.sub(bestMatch.word, string.len(text) + 1)
--     elseif bestMatch.source == 'pair' then
--         displayText = bestMatch.word
--     else -- freq
--         displayText = string.sub(bestMatch.word, string.len(context.currentWord) + 1)
--     end

--     --debugprint('[STEP 4] Displaying: "' .. displayText .. '" (full match: "' .. bestMatch.word .. '", type: ' .. bestMatch.source .. ')')

--     local header = ChatFrameEditBoxHeader
--     local headerWidth = header:GetWidth() or 0
--     self.measureText:SetText(text)
--     local textWidth = self.measureText:GetWidth() or 0

--     self.suggestion:ClearAllPoints()
--     self.suggestion:SetPoint('LEFT', ChatFrameEditBox, 'LEFT', 15 + headerWidth + textWidth, 0)
--     self.suggestion:SetText(displayText)
--     self.suggestionFrame:Show()
-- end

-- -- learning ----------

-- -- learn: parse sent message and update phrase/word data
-- function setup:LearnFromMessage(text)
--     if not text or string.len(text) == 0 then
--         return
--     end

--     -- trim leading and trailing spaces
--     local textLower = string.lower(text)
--     while string.sub(textLower, 1, 1) == ' ' do
--         textLower = string.sub(textLower, 2)
--     end
--     while string.sub(textLower, -1) == ' ' do
--         textLower = string.sub(textLower, 1, -2)
--     end

--     if string.len(textLower) == 0 then
--         return
--     end

--     --debugprint('[LEARNING] Message sent: "' .. textLower .. '"')

--     -- learn full phrase (if <= 6 words)
--     local words = {}
--     local current = ''
--     for i = 1, string.len(textLower) do
--         local char = string.sub(textLower, i, i)
--         if char == ' ' then
--             if string.len(current) > 0 then
--                 table.insert(words, current)
--                 current = ''
--             end
--         else
--             current = current .. char
--         end
--     end
--     if string.len(current) > 0 then
--         table.insert(words, current)
--     end

--     local wordCount = table.getn(words)

--     -- store phrase if short enough
--     if wordCount > 0 and wordCount <= self.phraseMaxWords then
--         local oldCount = self.phrases[textLower] or 0
--         self.phrases[textLower] = oldCount + 1
--         --debugprint('[LEARNING] Phrase learned: count=' .. (oldCount + 1))
--     end

--     -- learn word frequency and pairs
--     for i = 1, wordCount do
--         local word = words[i]
--         self.wordFreq[word] = (self.wordFreq[word] or 0) + 1

--         if i < wordCount then
--             if not self.wordNext[word] then
--                 self.wordNext[word] = {}
--             end
--             local nextWord = words[i + 1]
--             self.wordNext[word][nextWord] = (self.wordNext[word][nextWord] or 0) + 1
--         end
--     end

--     --debugprint('[LEARNING] Learned ' .. wordCount .. ' words and ' .. (wordCount - 1) .. ' word pairs')
--     self.lastMessage = textLower
-- end

-- -- load: read learning data from savedvariables (wow auto-saves on logout)
-- function setup:LoadLearningData()
--     if not DF_LearnedData then
--         DF_LearnedData = {phrases = {}, wordFreq = {}, wordNext = {}}
--         --debugprint('[LOAD] No saved data found, starting fresh')
--     else
--         DF_LearnedData.phrases = DF_LearnedData.phrases or {}
--         DF_LearnedData.wordFreq = DF_LearnedData.wordFreq or {}
--         DF_LearnedData.wordNext = DF_LearnedData.wordNext or {}

--         local phraseCount = 0
--         for _ in pairs(DF_LearnedData.phrases) do phraseCount = phraseCount + 1 end
--         local wordCount = 0
--         for _ in pairs(DF_LearnedData.wordFreq) do wordCount = wordCount + 1 end
--         --debugprint('[LOAD] Loaded ' .. phraseCount .. ' phrases and ' .. wordCount .. ' words from SavedVariables')
--     end
--     self.phrases = DF_LearnedData.phrases
--     self.wordFreq = DF_LearnedData.wordFreq
--     self.wordNext = DF_LearnedData.wordNext
-- end

-- -- expose
-- DF.setups.intellisense = setup
