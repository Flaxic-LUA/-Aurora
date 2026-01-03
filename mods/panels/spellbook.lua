DRAGONFLIGHT()

DF:NewDefaults('spellbook', {
    version = {value = '1.0'},
    enabled = {value = true},
})

DF:NewModule('spellbook', 1, 'PLAYER_ENTERING_WORLD', function()
    DF.common.KillFrame(SpellBookFrame)

    local BUTTONS_PER_PAGE = 36
    local COLUMN_SPACING = 110
    local ROW_SPACING = 65

    local spellData = {}

    local spellbook = DF.ui.CreatePaperDollFrame("DF_SpellBookFrame", UIParent, 750, 530, 1)
    spellbook:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
    spellbook:SetFrameStrata('MEDIUM')
    spellbook:SetFrameLevel(25)
    spellbook:EnableMouse(true)
    spellbook:SetScale(.9)
    DF.setups.spellbookBg = spellbook.Bg

    local leftPage = spellbook:CreateTexture(nil, "ARTWORK")
    leftPage:SetTexture(media['tex:panels:spellbook_right_page.blp'])
    leftPage:SetPoint("TOPLEFT", spellbook, "TOPLEFT", 10, -60)
    leftPage:SetPoint("BOTTOM", spellbook, "BOTTOM", -5, 10)
    leftPage:SetWidth(365)

    local rightPage = spellbook:CreateTexture(nil, "ARTWORK")
    rightPage:SetTexture(media['tex:panels:spellbook_left_page.blp'])
    rightPage:SetPoint("TOPRIGHT", spellbook, "TOPRIGHT", -10, -60)
    rightPage:SetPoint("BOTTOM", spellbook, "BOTTOM", 5, 10)
    rightPage:SetWidth(365)

    local topWood = spellbook:CreateTexture(nil, "BORDER")
    topWood:SetTexture(media['tex:panels:spellbook_top_wood.blp'])
    topWood:SetPoint("TOP", spellbook, "TOP", 0, -20)
    topWood:SetWidth(730)
    topWood:SetHeight(64)

    local classIcon = spellbook:CreateTexture(nil, "ARTWORK")
    classIcon:SetTexture(media['tex:interface:UI-Classes-Circles.tga'])
    local _, playerClass = UnitClass("player")
    local coords = DF.tables["classicons"][playerClass]
    if coords then
        classIcon:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
    end
    classIcon:SetPoint("TOPLEFT", spellbook, "TOPLEFT", 0, 3)
    classIcon:SetWidth(52)
    classIcon:SetHeight(52)

    local title = spellbook:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetText("Spellbook")
    title:SetTextColor(1, 1, 1)
    title:SetPoint("TOP", spellbook, "TOP", 0, -6)

    local closeBtn = DF.ui.CreateRedButton(spellbook, "close", function() spellbook:Hide() end)
    closeBtn:SetPoint("TOPRIGHT", spellbook, "TOPRIGHT", 0, -1)

    spellbook:SetScript("OnShow", function()
        PlaySound("igSpellBookOpen")
        local btn = getglobal('DF_MicroButton_Spellbook')
        if btn then btn:SetButtonState('PUSHED', 1) end
    end)
    spellbook:SetScript("OnHide", function()
        PlaySound("igSpellBookClose")
        local btn = getglobal('DF_MicroButton_Spellbook')
        if btn then btn:SetButtonState('NORMAL') end
    end)

    local showPassiveCheckbox = DF.ui.Checkbox(spellbook, "Show Passive", 15, 15)
    showPassiveCheckbox:SetPoint("TOPRIGHT", spellbook, "TOPRIGHT", -30, -35)
    showPassiveCheckbox:SetChecked(true)
    showPassiveCheckbox:SetScript("OnClick", function()
        spellbook.currentPage = 1
        spellbook:UpdateSpellDisplay()
    end)

    local showRanksCheckbox = DF.ui.Checkbox(spellbook, "Show Spell Ranks", 15, 15)
    showRanksCheckbox:SetPoint("RIGHT", showPassiveCheckbox, "LEFT", -120, 0)
    showRanksCheckbox:SetChecked(false)
    showRanksCheckbox:SetScript("OnClick", function()
        spellbook.currentPage = 1
        spellbook:UpdateSpellDisplay()
    end)

    local bookmark = spellbook:CreateTexture(nil, "OVERLAY")
    bookmark:SetTexture(media['tex:panels:spellbook_bookmark.blp'])
    bookmark:SetPoint("TOPRIGHT", leftPage, "TOPRIGHT", 45, 0)
    bookmark:SetWidth(50)
    bookmark:SetHeight(500)

    DF.setups.spellbookLeftPage = leftPage
    DF.setups.spellbookRightPage = rightPage
    DF.setups.spellbookTopWood = topWood
    DF.setups.spellbookBookmark = bookmark

    spellbook.selectedTabIndex = 1
    spellbook.currentPage = 1
    spellbook.maxPages = 1
    spellbook.spellButtons = {}
    spellbook.bookType = BOOKTYPE_SPELL
    spellbook.petTab = nil

    function spellbook:CollectSpells(tabIndex, bookType)
        spellData = {}
        bookType = bookType or BOOKTYPE_SPELL

        if bookType == BOOKTYPE_PET then
            local hasPetSpells, petToken = HasPetSpells()
            if hasPetSpells then
                for i = 1, hasPetSpells do
                    local spellName, spellRank = GetSpellName(i, BOOKTYPE_PET)
                    if spellName then
                        table.insert(spellData, {
                            index = i,
                            name = spellName,
                            rank = spellRank,
                            variant = nil,
                            variantRank = 0,
                            texture = GetSpellTexture(i, BOOKTYPE_PET),
                            isPassive = IsSpellPassive(i, BOOKTYPE_PET),
                            isRacial = false,
                            tabIndex = tabIndex
                        })
                    end
                end
            end
        elseif tabIndex then
            local name, texture, offset, numSpells = GetSpellTabInfo(tabIndex)
            for i = 1, numSpells do
                local spellIndex = offset + i
                local spellName, spellRank = GetSpellName(spellIndex, BOOKTYPE_SPELL)
                if spellName then
                    local variant = nil
                    local cleanName = spellName
                    local variantStart, variantEnd = string.find(spellName, "%((.-)%)")
                    if variantStart then
                        variant = string.sub(spellName, variantStart + 1, variantEnd - 1)
                        cleanName = string.sub(spellName, 1, variantStart - 2)
                    end
                    local variantRank = 3
                    if variant == "Minor" then
                        variantRank = 1
                    elseif variant == "Lesser" then
                        variantRank = 2
                    elseif variant == "Greater" then
                        variantRank = 4
                    elseif variant == "Major" then
                        variantRank = 5
                    end
                    local isRacial = spellRank and string.find(spellRank, "Racial")
                    table.insert(spellData, {
                        index = spellIndex,
                        name = cleanName,
                        rank = spellRank,
                        variant = variant,
                        variantRank = variantRank,
                        texture = GetSpellTexture(spellIndex, BOOKTYPE_SPELL),
                        isPassive = IsSpellPassive(spellIndex, BOOKTYPE_SPELL),
                        isRacial = isRacial,
                        tabIndex = tabIndex
                    })
                end
            end
        end
    end

    function spellbook:CreateSpellButton(parent)
        local container = CreateFrame("Frame", nil, parent)
        container:SetWidth(120)
        container:SetHeight(40)

        local iconBtn = CreateFrame("Button", nil, container)
        iconBtn:SetWidth(32)
        iconBtn:SetHeight(32)
        iconBtn:SetPoint("LEFT", container, "LEFT", 5, 0)
        container.iconBtn = iconBtn

        iconBtn.cooldown = CreateFrame('Model', nil, iconBtn, 'CooldownFrameTemplate')
        iconBtn.cooldown:SetAllPoints(iconBtn)

        local icon = iconBtn:CreateTexture(nil, "BACKGROUND")
        icon:SetAllPoints(iconBtn)
        container.icon = icon

        local border = iconBtn:CreateTexture(nil, "ARTWORK")
        border:SetWidth(43)
        border:SetHeight(43)
        border:SetPoint("CENTER", iconBtn, "CENTER", -3, -2)
        container.border = border

        local highlight = iconBtn:CreateTexture(nil, "HIGHLIGHT")
        highlight:SetTexture(media['tex:panels:spellbook_highlight.blp'])
        highlight:SetWidth(43)
        highlight:SetHeight(43)
        highlight:SetPoint("CENTER", iconBtn, "CENTER", 0, 0)
        highlight:SetBlendMode("ADD")
        container.highlight = highlight

        local maxRankHighlight = iconBtn:CreateTexture(nil, "OVERLAY")
        maxRankHighlight:SetTexture(media['tex:panels:spellbook_highlight.blp'])
        maxRankHighlight:SetWidth(53)
        maxRankHighlight:SetHeight(53)
        maxRankHighlight:SetPoint("CENTER", iconBtn, "CENTER", 0, 0)
        maxRankHighlight:SetBlendMode("ADD")
        maxRankHighlight:SetAlpha(.3)
        maxRankHighlight:Hide()
        container.maxRankHighlight = maxRankHighlight

        local name = container:CreateFontString(nil, "OVERLAY")
        name:SetFont("Fonts\\FRIZQT__.TTF", 10)
        name:SetPoint("LEFT", iconBtn, "RIGHT", 5, 0)
        name:SetPoint("RIGHT", container, "RIGHT", -5, 0)
        name:SetJustifyH("LEFT")
        name:SetTextColor(0, 0, 0)
        container.name = name

        local passive = container:CreateFontString(nil, "OVERLAY")
        passive:SetFont("Fonts\\FRIZQT__.TTF", 8)
        passive:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, 0)
        passive:SetText("Passive")
        passive:SetTextColor(0.2, 0.2, 0.2)
        passive:Hide()
        container.passive = passive

        local racial = container:CreateFontString(nil, "OVERLAY")
        racial:SetFont("Fonts\\FRIZQT__.TTF", 8)
        racial:SetText("Racial")
        racial:SetTextColor(0.2, 0.2, 0.2)
        racial:Hide()
        container.racial = racial

        local rank = container:CreateFontString(nil, "OVERLAY")
        rank:SetFont("Fonts\\FRIZQT__.TTF", 8)
        rank:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, 0)
        rank:SetTextColor(0.2, 0.2, 0.2)
        rank:Hide()
        container.rank = rank

        iconBtn:SetScript("OnClick", function()
            if container.spellIndex and container.bookType then
                CastSpell(container.spellIndex, container.bookType)
            end
        end)

        iconBtn:SetScript("OnDragStart", function()
            if container.spellIndex and container.bookType then
                PickupSpell(container.spellIndex, container.bookType)
            end
        end)

        iconBtn:SetScript("OnEnter", function()
            if container.spellIndex and container.bookType then
                GameTooltip:SetOwner(iconBtn, 'ANCHOR_RIGHT')
                GameTooltip:SetSpell(container.spellIndex, container.bookType)
                GameTooltip:Show()
            end
        end)

        iconBtn:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        iconBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        iconBtn:RegisterForDrag("LeftButton")

        return container
    end

    for i = 1, BUTTONS_PER_PAGE do
        local btn = spellbook:CreateSpellButton(spellbook)

        if i <= 18 then
            local leftRow = math.floor((i - 1) / 3)
            local leftCol = math.mod(i - 1, 3)
            btn:SetPoint("TOPLEFT", leftPage, "TOPLEFT", 15 + leftCol * COLUMN_SPACING, -35 - leftRow * ROW_SPACING)
        else
            local rightRow = math.floor((i - 19) / 3)
            local rightCol = math.mod(i - 19, 3)
            btn:SetPoint("TOPLEFT", rightPage, "TOPLEFT", 15 + rightCol * COLUMN_SPACING, -35 - rightRow * ROW_SPACING)
        end

        -- debugframe(btn)

        table.insert(spellbook.spellButtons, btn)
    end

    local pageText = DF.ui.Font(spellbook, 11, nil, {1, .82, 0}, 'RIGHT', 'NONE')
    pageText:SetPoint("BOTTOMRIGHT", rightPage, "BOTTOMRIGHT", -100, 18)
    spellbook.pageText = pageText

    local prevBtn, nextBtn

    function spellbook:UpdateSpellDisplay()
        spellbook:CollectSpells(spellbook.selectedTabIndex, spellbook.bookType)

        local filteredSpells = {}
        for i, spell in ipairs(spellData) do
            if showPassiveCheckbox:GetChecked() or not spell.isPassive then
                table.insert(filteredSpells, spell)
            end
        end

        local maxRanks = {}
        for i, spell in ipairs(filteredSpells) do
            if not maxRanks[spell.name] or spell.variantRank > maxRanks[spell.name].variantRank or (spell.variantRank == maxRanks[spell.name].variantRank and spell.index > maxRanks[spell.name].index) then
                maxRanks[spell.name] = spell
            end
        end

        if not showRanksCheckbox:GetChecked() then
            filteredSpells = {}
            for name, spell in pairs(maxRanks) do
                table.insert(filteredSpells, spell)
            end
            table.sort(filteredSpells, function(a, b) return a.index < b.index end)
        end

        spellbook.maxPages = math.ceil(table.getn(filteredSpells) / 36)
        if spellbook.maxPages < 1 then spellbook.maxPages = 1 end

        local startIndex = (spellbook.currentPage - 1) * 36 + 1
        for i, btn in ipairs(spellbook.spellButtons) do
            local spell = filteredSpells[startIndex + i - 1]
            if spell then
                btn.icon:SetTexture(spell.texture)
                btn.name:SetText(spell.name)
                btn.spellIndex = spell.index
                btn.bookType = spellbook.bookType

                local start, duration, enable = GetSpellCooldown(spell.index, spellbook.bookType)
                if btn.iconBtn.cooldown and start and duration then
                    CooldownFrame_SetTimer(btn.iconBtn.cooldown, start, duration, enable)
                end
                local lastAnchor = btn.name
                if spell.isPassive then
                    btn.passive:Show()
                    lastAnchor = btn.passive
                    btn.border:SetTexture(media['tex:panels:spellbook_passives_border.blp'])
                else
                    btn.passive:Hide()
                    btn.border:SetTexture(media['tex:panels:spellbook_actives_border.blp'])
                end
                if spell.isRacial then
                    btn.racial:ClearAllPoints()
                    btn.racial:SetPoint("TOPLEFT", lastAnchor, "BOTTOMLEFT", 0, 0)
                    btn.racial:Show()
                    lastAnchor = btn.racial
                else
                    btn.racial:Hide()
                end
                btn.rank:ClearAllPoints()
                btn.rank:SetPoint("TOPLEFT", lastAnchor, "BOTTOMLEFT", 0, 0)
                if spell.variant then
                    btn.rank:SetText(spell.variant)
                    btn.rank:Show()
                elseif spell.rank and spell.rank ~= "" and spell.rank ~= "Passive" and spell.rank ~= "Racial" and spell.rank ~= "Racial Passive" then
                    btn.rank:SetText(spell.rank)
                    btn.rank:Show()
                else
                    btn.rank:Hide()
                end

                if spellbook.bookType == BOOKTYPE_SPELL and type(spellbook.selectedTabIndex) == 'number' then
                    local tabName = GetSpellTabInfo(spellbook.selectedTabIndex)
                    local isGeneralTab = tabName and string.find(tabName, "General")
                    if showRanksCheckbox:GetChecked() and maxRanks[spell.name] and maxRanks[spell.name].index == spell.index and not isGeneralTab then
                        btn.maxRankHighlight:Show()
                    else
                        btn.maxRankHighlight:Hide()
                    end
                else
                    btn.maxRankHighlight:Hide()
                end

                btn:Show()
            else
                btn:Hide()
            end
        end

        pageText:SetText("Page "..spellbook.currentPage.." / "..spellbook.maxPages)

        if spellbook.currentPage <= 1 then
            prevBtn:Disable()
        else
            prevBtn:Enable()
        end

        if spellbook.currentPage >= spellbook.maxPages then
            nextBtn:Disable()
        else
            nextBtn:Enable()
        end
    end

    function spellbook:CreateDynamicTabs()
        for i, tab in ipairs(spellbook.Tabs) do
            tab:Hide()
        end
        spellbook.Tabs = {}

        local numTabs = GetNumSpellTabs()
        for tabIndex = 1, numTabs do
            local name, texture, offset, numSpells = GetSpellTabInfo(tabIndex)
            if numSpells > 0 then
                name = string.gsub(name, ' Combat', '')
                local capturedIndex = tabIndex
                local spacing = 2
                if tabIndex == 2 then
                    spacing = 10
                end
                spellbook:AddTab(name, function()
                    spellbook.bookType = BOOKTYPE_SPELL
                    spellbook.selectedTabIndex = capturedIndex
                    spellbook.currentPage = 1
                    spellbook:UpdateSpellDisplay()
                end, 90, spacing)
            end
        end

        local hasPetSpells, petToken = HasPetSpells()
        local petTabText = 'Pet'
        if petToken then
            local petTypeName = getglobal('PET_TYPE_'..petToken)
            if petTypeName then
                petTabText = TEXT(petTypeName)
            end
        end

        spellbook.petTab = spellbook:AddTab(petTabText, function()
            spellbook.bookType = BOOKTYPE_PET
            spellbook.selectedTabIndex = 'pet'
            spellbook.currentPage = 1
            spellbook:UpdateSpellDisplay()
        end, 50, 10)

        function spellbook:UpdatePetTab()
            local hasPet, token = HasPetSpells()
            if hasPet then
                if token then
                    local petTypeName = getglobal('PET_TYPE_'..token)
                    if petTypeName and spellbook.petTab.Text then
                        spellbook.petTab.Text:SetText(TEXT(petTypeName))
                    end
                end
                spellbook.petTab:Show()
            else
                spellbook.petTab:Hide()
            end
        end

        spellbook:UpdatePetTab()

        if spellbook.Tabs[1] then
            spellbook.Tabs[1]:SetSelected(true)
            spellbook.selectedTab = spellbook.Tabs[1]
            spellbook.selectedTabIndex = 1
        end
    end

    prevBtn = DF.ui.PageButton(spellbook, 27, 27, nil, 'west')
    prevBtn:SetPoint("BOTTOMRIGHT", rightPage, "BOTTOMRIGHT", -60, 10)
    prevBtn:SetScript("OnClick", function()
        if spellbook.currentPage > 1 then
            spellbook.currentPage = spellbook.currentPage - 1
            spellbook:UpdateSpellDisplay()
        end
    end)

    nextBtn = DF.ui.PageButton(spellbook, 27, 27, nil, 'east')
    nextBtn:SetPoint("BOTTOMRIGHT", rightPage, "BOTTOMRIGHT", -20, 10)
    nextBtn:SetScript("OnClick", function()
        if spellbook.currentPage < spellbook.maxPages then
            spellbook.currentPage = spellbook.currentPage + 1
            spellbook:UpdateSpellDisplay()
        end
    end)

    spellbook:CreateDynamicTabs()
    spellbook:UpdateSpellDisplay()
    spellbook:Hide()

    spellbook:RegisterEvent('SPELL_UPDATE_COOLDOWN')
    spellbook:RegisterEvent('PET_BAR_UPDATE')
    spellbook:RegisterEvent('UNIT_PET')
    spellbook:RegisterEvent('SPELLS_CHANGED')
    spellbook:SetScript('OnEvent', function()
        if event == 'SPELL_UPDATE_COOLDOWN' then
            for i, btn in ipairs(spellbook.spellButtons) do
                if btn.spellIndex and btn:IsShown() and btn.bookType then
                    local start, duration, enable = GetSpellCooldown(btn.spellIndex, btn.bookType)
                    if btn.iconBtn.cooldown then
                        CooldownFrame_SetTimer(btn.iconBtn.cooldown, start, duration, enable)
                    end
                end
            end
        elseif event == 'PET_BAR_UPDATE' or (event == 'UNIT_PET' and arg1 == 'player') or event == 'SPELLS_CHANGED' then
            if spellbook.UpdatePetTab then
                spellbook:UpdatePetTab()
            end
            if spellbook.bookType == BOOKTYPE_PET and spellbook:IsShown() then
                spellbook:UpdateSpellDisplay()
            end
        end
    end)

    _G.ToggleSpellBook = function(bookType)
        local gameMenu = getglobal('DF_GameMenuFrame')
        if gameMenu and gameMenu:IsVisible() then
            return
        end
        if spellbook:IsShown() then
            spellbook:Hide()
        else
            spellbook:Show()
        end
    end

    table.insert(UISpecialFrames, spellbook:GetName())

    -- callbacks
    local helpers = {}
    local callbacks = {}


    DF:NewCallbacks('spellbook', callbacks)
end)
