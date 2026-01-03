DRAGONFLIGHT()

DF:NewDefaults('chat', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'chat', subtab = 'mainbar', categories = 'General'},
    },

})

DF:NewModule('chat', 1, function()
    -- temp chat fix
    local function SkinChatTab(chatTab)
        if not chatTab or chatTab.auroraSkinned then return end

        local tex = media['tex:interface:uiframetabs']

        _G[chatTab:GetName()..'Left']:Hide()
        _G[chatTab:GetName()..'Middle']:Hide()
        _G[chatTab:GetName()..'Right']:Hide()

        local hl = chatTab:GetHighlightTexture()
        if hl then hl:Hide() end

        local left = chatTab:CreateTexture(nil, 'BACKGROUND')
        left:SetTexture(tex)
        left:SetSize(35, 36)
        left:SetPoint('TOPLEFT', chatTab, 'TOPLEFT', -3, 0)
        left:SetTexCoord(0.015625, 0.5625, 0.957031, 0.816406)
        chatTab.auroraLeft = left

        local right = chatTab:CreateTexture(nil, 'BACKGROUND')
        right:SetTexture(tex)
        right:SetSize(37, 36)
        right:SetPoint('TOPRIGHT', chatTab, 'TOPRIGHT', 7, 0)
        right:SetTexCoord(0.015625, 0.59375, 0.808594, 0.667969)
        chatTab.auroraRight = right

        local middle = chatTab:CreateTexture(nil, 'BACKGROUND')
        middle:SetTexture(tex)
        middle:SetSize(1, 36)
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)
        middle:SetTexCoord(0, 0.015625, 0.316406, 0.175781)
        chatTab.auroraMiddle = middle

        local leftSel = chatTab:CreateTexture(nil, 'BACKGROUND')
        leftSel:SetTexture(tex)
        leftSel:SetSize(35, 35)
        leftSel:SetPoint('BOTTOMLEFT', chatTab, 'BOTTOMLEFT', -1, 0)
        leftSel:SetTexCoord(0.015625, 0.5625, 0.660156, 0.496094)
        leftSel:Hide()
        chatTab.auroraLeftSel = leftSel

        local rightSel = chatTab:CreateTexture(nil, 'BACKGROUND')
        rightSel:SetTexture(tex)
        rightSel:SetSize(37, 35)
        rightSel:SetPoint('BOTTOMRIGHT', chatTab, 'BOTTOMRIGHT', 8, 0)
        rightSel:SetTexCoord(0.015625, 0.59375, 0.488281, 0.324219)
        rightSel:Hide()
        chatTab.auroraRightSel = rightSel

        local middleSel = chatTab:CreateTexture(nil, 'BACKGROUND')
        middleSel:SetTexture(tex)
        middleSel:SetSize(1, 35)
        middleSel:SetPoint('BOTTOMLEFT', leftSel, 'BOTTOMRIGHT', 0, 0)
        middleSel:SetPoint('BOTTOMRIGHT', rightSel, 'BOTTOMLEFT', 0, 0)
        middleSel:SetTexCoord(0, 0.015625, 0.167969, 0.00390625)
        middleSel:Hide()
        chatTab.auroraMiddleSel = middleSel

        chatTab.auroraSkinned = true
    end

    local oldFCF_SelectDockFrame = _G.FCF_SelectDockFrame
    _G.FCF_SelectDockFrame = function(frame)
        oldFCF_SelectDockFrame(frame)
        for i = 1, NUM_CHAT_WINDOWS do
            local tab = _G['ChatFrame'..i..'Tab']
            if tab and tab.auroraSkinned then
                local isSelected = (SELECTED_DOCK_FRAME and SELECTED_DOCK_FRAME:GetID() == i)
                if isSelected then
                    tab.auroraLeft:Hide()
                    tab.auroraRight:Hide()
                    tab.auroraMiddle:Hide()
                    tab.auroraLeftSel:Show()
                    tab.auroraRightSel:Show()
                    tab.auroraMiddleSel:Show()
                else
                    tab.auroraLeft:Show()
                    tab.auroraRight:Show()
                    tab.auroraMiddle:Show()
                    tab.auroraLeftSel:Hide()
                    tab.auroraRightSel:Hide()
                    tab.auroraMiddleSel:Hide()
                end
            end
        end
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local tab = _G['ChatFrame'..i..'Tab']
        if tab then
            SkinChatTab(tab)
            tab:ClearAllPoints()
            tab:SetPoint('BOTTOMLEFT', _G['ChatFrame'..i], 'TOPLEFT', 0, 3)
        end
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local cf = _G['ChatFrame'..i]
        if cf then
            DF.common.KillFrame(_G['ChatFrame'..i..'BottomButton'])
            DF.common.KillFrame(_G['ChatFrame'..i..'DownButton'])
            DF.common.KillFrame(_G['ChatFrame'..i..'UpButton'])

            local upBtn = DF.ui.PageButton(cf, 20, 20, 'ChatFrame'..i..'UpBtn', 'north', 8)
            upBtn:SetPoint('BOTTOMLEFT', cf, 'BOTTOMLEFT', -24, 40)
            upBtn.clickDelay = 0
            upBtn:SetScript('OnUpdate', function()
                if this:GetButtonState() == 'PUSHED' then
                    this.clickDelay = this.clickDelay - arg1
                    if this.clickDelay < 0 then
                        cf:ScrollUp()
                        this.clickDelay = 0.05
                    end
                end
            end)
            upBtn:SetScript('OnMouseDown', function()
                cf:ScrollUp()
                PlaySound('igChatScrollUp')
                this.clickDelay = 0
            end)

            local downBtn = DF.ui.PageButton(cf, 20, 20, 'ChatFrame'..i..'DownBtn', 'south', 8)
            downBtn:SetPoint('BOTTOMLEFT', cf, 'BOTTOMLEFT', -24, 20)
            downBtn.clickDelay = 0
            downBtn:SetScript('OnUpdate', function()
                if this:GetButtonState() == 'PUSHED' then
                    this.clickDelay = this.clickDelay - arg1
                    if this.clickDelay < 0 then
                        cf:ScrollDown()
                        this.clickDelay = 0.05
                    end
                end
            end)
            downBtn:SetScript('OnMouseDown', function()
                cf:ScrollDown()
                PlaySound('igChatScrollDown')
                this.clickDelay = 0
            end)

            local bottomBtn = DF.ui.PageButton(cf, 20, 20, 'ChatFrame'..i..'BottomBtn', 'south', 8)
            bottomBtn:SetPoint('BOTTOMLEFT', cf, 'BOTTOMLEFT', -24, 0)
            bottomBtn:SetScript('OnClick', function()
                cf:ScrollToBottom()
                PlaySound('igChatScrollDown')
            end)

            local pulse = bottomBtn:CreateTexture(nil, 'OVERLAY')
            pulse:SetPoint('TOPLEFT', bottomBtn, 'TOPLEFT', -14, 7)
            pulse:SetPoint('BOTTOMRIGHT', bottomBtn, 'BOTTOMRIGHT', 14, -7)
            pulse:SetTexture(media['tex:micromenu:micro_highlight.blp'])
            pulse:SetBlendMode('ADD')
            pulse:SetAlpha(0)
            pulse._elapsed = 0
            pulse._direction = 1

            function bottomBtn:UpdatePulse()
                if cf:AtBottom() then
                    pulse:SetAlpha(0)
                    pulse:Hide()
                else
                    pulse:Show()
                    pulse._elapsed = pulse._elapsed + arg1
                    if pulse._elapsed >= 0.5 then
                        pulse._direction = -pulse._direction
                        pulse._elapsed = 0
                    end
                    local alpha = pulse._elapsed / 0.5
                    if pulse._direction < 0 then alpha = 1 - alpha end
                    pulse:SetAlpha(alpha * 0.5)
                end
            end

            cf:SetScript('OnUpdate', function() bottomBtn:UpdatePulse() end)
        end
    end

    DF.common.KillFrame(ChatFrameMenuButton)

    local upBtn1 = _G['ChatFrame1UpBtn']
    local menuBtn = DF.ui.PageButton(UIParent, 20, 20, 'DF_ChatMenuButton', 'east', 8)
    menuBtn:SetPoint('BOTTOM', upBtn1, 'TOP', 0, 0)
    menuBtn:SetScript('OnClick', function()
        PlaySound('igChatEmoteButton')
        ToggleDropDownMenu(1, nil, ChatFrame1TabDropDown, 'DF_ChatMenuButton', 0, 0)
    end)
    menuBtn:SetScript('OnEnter', function()
        GameTooltip_AddNewbieTip('Chat', 1.0, 1.0, 1.0, _G['NEWBIE_TOOLTIP_CHATMENU'])
    end)
    menuBtn:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)

    -- callbacks
    local callbacks = {}

    DF:NewCallbacks('chat', callbacks)
end)
