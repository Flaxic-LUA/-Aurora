DRAGONFLIGHT()

DF:NewDefaults('questtracker', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'general', subtab = 'questtracker', 'Questtracker'},
    },

    showQuestLevel = {value = true, metadata = {element = 'checkbox', category = 'Questtracker', indexInCategory = 1, description = 'Show quest level in tracker'}},
    colorQuestLevel = {value = true, metadata = {element = 'checkbox', category = 'Questtracker', indexInCategory = 2, description = 'Color quest level by difficulty', dependency = {key = 'showQuestLevel', state = true}}},
    showQuestPercent = {value = true, metadata = {element = 'checkbox', category = 'Questtracker', indexInCategory = 3, description = 'Show quest percentage in tracker'}},
    trackerScale = {value = 1, metadata = {element = 'slider', category = 'Questtracker', indexInCategory = 4, description = 'Quest tracker scale', min = 0.5, max = 1.5, stepSize = 0.1}},
    headerFontSize = {value = 10, metadata = {element = 'slider', category = 'Questtracker', indexInCategory = 5, description = 'Quest header font size', min = 8, max = 11, stepSize = 1}},
    objectiveFontSize = {value = 10, metadata = {element = 'slider', category = 'Questtracker', indexInCategory = 6, description = 'Quest objective font size', min = 8, max = 11, stepSize = 1}},

})

DF:NewModule('questtracker', 1, 'PLAYER_LOGIN' ,function()
    -- we boot this module on player login due to pfquest being huge and i just want to be sure
    -- maybe we make a specific event for big addons like pfquest/aux etc in libevents to be extra safe
    local HEADER_TO_OBJECTIVE_SPACING = -2
    local QUEST_TO_QUEST_SPACING = -8
    local INITIAL_YOFFSET = -10

    local anchor = CreateFrame('Frame', 'DF_QuestTracker', UIParent)
    anchor:SetSize(200, 50)
    anchor:SetPoint('TOP', Minimap, 'BOTTOM', -50, -70)

    local mainFrame = CreateFrame('Frame', nil, UIParent)
    mainFrame:SetSize(200, 200)
    mainFrame:SetPoint('TOP', anchor, 'TOP')

    DF.mixins.pfQuestButtons(mainFrame)

    local collapsed = {}
    local buttons = {}
    local lines = {}
    local titleBgs = {}
    for i = 1, 15 do
        lines[i] = mainFrame:CreateFontString(nil, 'OVERLAY')
        lines[i]:SetFont('Fonts\\FRIZQT__.TTF', 10)
        lines[i]:SetShadowOffset(1, -1)
        lines[i]:SetShadowColor(0, 0, 0, 1)
        lines[i]:SetJustifyH('LEFT')
        lines[i]:SetWidth(240)

        titleBgs[i] = mainFrame:CreateTexture(nil, 'BACKGROUND')
        titleBgs[i]:SetTexture(media['tex:interface:questbar.blp'])
        titleBgs[i]:SetHeight(17)

        buttons[i] = CreateFrame('Button', nil, mainFrame)
        buttons[i]:SetSize(12, 12)

        local btnTxt = buttons[i]:CreateFontString(nil, 'OVERLAY')
        btnTxt:SetFont('Fonts\\FRIZQT__.TTF', 18)
        btnTxt:SetPoint('CENTER', buttons[i], 'CENTER', 0, 0)
        btnTxt:SetTextColor(1, 1, 1)
        buttons[i].text = btnTxt

        local highlight = buttons[i]:CreateTexture(nil, 'HIGHLIGHT')
        highlight:SetTexture('Interface\\QuestFrame\\UI-QuestTitleHighlight')
        highlight:SetPoint('TOPLEFT', buttons[i], 'TOPLEFT', 0, 0)
        highlight:SetPoint('BOTTOMRIGHT', buttons[i], 'BOTTOMRIGHT', 0, 0)
        highlight:SetBlendMode('ADD')

        local percentTxt = buttons[i]:CreateFontString(nil, 'OVERLAY')
        percentTxt:SetFont('Fonts\\FRIZQT__.TTF', 10)
        percentTxt:SetShadowOffset(1, -1)
        percentTxt:SetShadowColor(0, 0, 0, 1)
        percentTxt:SetJustifyH('RIGHT')
        buttons[i].percentText = percentTxt

        buttons[i]:SetScript('OnClick', function()
            collapsed[this.questIndex] = not collapsed[this.questIndex]
            this.text:SetText(collapsed[this.questIndex] and '+' or '-')
            mainFrame:Update()
        end)
    end

    function mainFrame:GetQuestProgress(questIndex)
        local cur, max = 0, 0
        local numObjectives = GetNumQuestLeaderBoards(questIndex)
        for j = 1, numObjectives do
            local text, type, finished = GetQuestLogLeaderBoard(j, questIndex)
            if text then
                local _, _, objNum, objNeeded = strfind(text, '(%d+)/(%d+)')
                if objNum and objNeeded then
                    cur = cur + tonumber(objNum)
                    max = max + tonumber(objNeeded)
                elseif not finished then
                    max = max + 1
                else
                    cur = cur + 1
                    max = max + 1
                end
            end
        end
        local percent = max > 0 and math.floor(cur/max*100) or 0
        return percent
    end

    function mainFrame:UpdateQuestTitle(btnIndex, questIndex, title, yOffset, lineIndex)
        titleBgs[btnIndex]:ClearAllPoints()
        titleBgs[btnIndex]:SetPoint('TOPLEFT', mainFrame, 'TOPLEFT', 5, yOffset + 3)
        titleBgs[btnIndex]:SetPoint('TOPRIGHT', mainFrame, 'TOPRIGHT', -5, yOffset + 2)
        titleBgs[btnIndex]:Show()

        buttons[btnIndex].questIndex = questIndex
        buttons[btnIndex]:ClearAllPoints()
        buttons[btnIndex]:SetPoint('TOPLEFT', mainFrame, 'TOPLEFT', -5, yOffset)
        buttons[btnIndex].text:SetText(collapsed[questIndex] and '+' or '-')
        buttons[btnIndex]:Show()

        local _, level = GetQuestLogTitle(questIndex)
        local percent = mainFrame:GetQuestProgress(questIndex)
        local percentColor = percent == 100 and '|cffffffff' or '|cffaaaaaa'

        local color = GetDifficultyColor(level)
        local levelColor = DF.profile.questtracker.colorQuestLevel and string.format('|cff%02x%02x%02x', color.r*255, color.g*255, color.b*255) or '|cffffffff'
        local levelText = DF.profile.questtracker.showQuestLevel and '[' .. levelColor .. (level or '??') .. '|r] ' or ''
        local maxTitleLen = DF.profile.questtracker.showQuestLevel and (21 - string.len('[' .. (level or '??') .. '] ')) or 24
        local truncatedTitle = string.len(title) > maxTitleLen and string.sub(title, 1, maxTitleLen) .. '...' or title

        buttons[btnIndex].percentText:ClearAllPoints()
        buttons[btnIndex].percentText:SetPoint('TOPRIGHT', mainFrame, 'TOPRIGHT', -10, yOffset)
        buttons[btnIndex].percentText:SetFont('Fonts\\FRIZQT__.TTF', DF.profile.questtracker.headerFontSize)
        if DF.profile.questtracker.showQuestPercent then
            buttons[btnIndex].percentText:SetText(percentColor .. '(' .. percent .. '%)|r')
            buttons[btnIndex].percentText:Show()
        else
            buttons[btnIndex].percentText:Hide()
        end

        lines[lineIndex]:ClearAllPoints()
        lines[lineIndex]:SetPoint('TOPLEFT', mainFrame, 'TOPLEFT', 20, yOffset)
        lines[lineIndex]:SetFont('Fonts\\FRIZQT__.TTF', DF.profile.questtracker.headerFontSize)
        lines[lineIndex]:SetText(levelText .. truncatedTitle)
        lines[lineIndex]:SetTextColor(1, 0.8, 0)
        lines[lineIndex]:Show()

        local headerHeight = DF.profile.questtracker.headerFontSize + 3
        return yOffset + HEADER_TO_OBJECTIVE_SPACING - headerHeight
    end

    function mainFrame:UpdateQuestObjectives(questIndex, lineIndex, yOffset)
        if not collapsed[questIndex] then
            local numObjectives = GetNumQuestLeaderBoards(questIndex)
            for j = 1, numObjectives do
                local text, type, finished = GetQuestLogLeaderBoard(j, questIndex)
                if text then
                    lines[lineIndex]:ClearAllPoints()
                    lines[lineIndex]:SetPoint('TOPLEFT', mainFrame, 'TOPLEFT', 20, yOffset)
                    lines[lineIndex]:SetFont('Fonts\\FRIZQT__.TTF', DF.profile.questtracker.objectiveFontSize)
                    lines[lineIndex]:SetText(' - '..text)
                    if finished then
                        lines[lineIndex]:SetTextColor(1, 1, 1)
                    else
                        lines[lineIndex]:SetTextColor(.7, .7, .7)
                    end
                    lines[lineIndex]:Show()
                    local objHeight = DF.profile.questtracker.objectiveFontSize + 3
                    yOffset = yOffset - objHeight
                    lineIndex = lineIndex + 1
                end
            end
        end
        return lineIndex, yOffset
    end

    function mainFrame:CleanupUnusedElements(btnIndex, lineIndex)
        for i = btnIndex, 15 do
            buttons[i]:Hide()
            buttons[i].percentText:Hide()
            titleBgs[i]:Hide()
        end

        for i = lineIndex, 15 do
            lines[i]:Hide()
        end
    end

    function mainFrame:Update()
        local lineIndex = 1
        local numWatched = GetNumQuestWatches()
        local yOffset = INITIAL_YOFFSET
        local btnIndex = 1
        local seenTitles = {}

        for i = 1, numWatched do
            local questIndex = GetQuestIndexForWatch(i)
            if questIndex then
                local title = GetQuestLogTitle(questIndex)
                if not seenTitles[title] then
                    seenTitles[title] = true

                    yOffset = mainFrame:UpdateQuestTitle(btnIndex, questIndex, title, yOffset, lineIndex)
                    lineIndex = lineIndex + 1
                    btnIndex = btnIndex + 1

                    lineIndex, yOffset = mainFrame:UpdateQuestObjectives(questIndex, lineIndex, yOffset)
                    yOffset = yOffset + QUEST_TO_QUEST_SPACING
                end
            end
        end

        mainFrame:CleanupUnusedElements(btnIndex, lineIndex)
        mainFrame:SetHeight(math.abs(yOffset))

        if numWatched == 0 then
            mainFrame:Hide()
        else
            mainFrame:Show()
        end
    end

    DF.hooks.HookSecureFunc('AddQuestWatch', function()
        mainFrame:Update()
    end)

    DF.hooks.HookSecureFunc('RemoveQuestWatch', function()
        mainFrame:Update()
    end)

    mainFrame:SetScript('OnUpdate', function()
        if QuestWatchFrame and QuestWatchFrame:IsShown() then
            QuestWatchFrame:Hide()
        end

        if (this.tick or 1) < GetTime() then
            mainFrame:Update()
            this.tick = GetTime() + 1
        end
    end)

    -- callbacks
    local callbacks = {}

    callbacks.showQuestLevel = function()
        mainFrame:Update()
    end

    callbacks.showQuestPercent = function()
        mainFrame:Update()
    end

    callbacks.headerFontSize = function()
        mainFrame:Update()
    end

    callbacks.objectiveFontSize = function()
        mainFrame:Update()
    end

    callbacks.trackerScale = function(value)
        mainFrame:SetScale(value)
    end

    callbacks.colorQuestLevel = function()
        mainFrame:Update()
    end

    DF:NewCallbacks('questtracker', callbacks)
end)
