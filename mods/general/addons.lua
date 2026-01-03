DRAGONFLIGHT()

DF:NewDefaults('addons', {
    version = {value = '1.0'},
    enabled = {value = true},
})

DF:NewModule('addons', 1, function()
    local addonsFrame = DF.ui.CreatePaperDollFrame('DF_AddonsFrame', UIParent, 550, 450, 2)
    addonsFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    addonsFrame:EnableMouse(true)
    addonsFrame:Hide()

    local header = DF.ui.Font(addonsFrame, 12, 'Addons', {1, 1, 1}, 'CENTER')
    header:SetPoint('TOP', addonsFrame, 'TOP', 0, -6)

    local totalAddons = GetNumAddOns()
    local initialStates = {}
    local checkboxes = {}
    local addonRows = {}
    local pendingChanges = {}

    local reloadBtn = DF.ui.Button(addonsFrame, 'Reload UI', 100, 30)
    reloadBtn:SetPoint('BOTTOM', addonsFrame, 'BOTTOM', 0, 10)
    reloadBtn:Disable()

    local closeButton = DF.ui.CreateRedButton(addonsFrame, 'close', function()
        local hasChanges = false
        for j = 1, totalAddons do
            if checkboxes[j]:GetChecked() ~= initialStates[j] then
                hasChanges = true
                break
            end
        end

        if hasChanges then
            addonsFrame:Hide()
            DF.ui.StaticPopup_Show('Reload UI to apply changes?', 'Reload', function()
                for addonName, shouldEnable in pendingChanges do
                    if shouldEnable then
                        EnableAddOn(addonName)
                    else
                        DisableAddOn(addonName)
                    end
                end
                ReloadUI()
            end, 'Cancel', function()
                pendingChanges = {}
                for j = 1, totalAddons do
                    local row = addonRows[j]
                    row.checkbox:SetChecked(row.loaded)
                    if row.loaded then
                        row.titleText:SetText(row.originalTitle)
                        row.authorText:SetTextColor(1, 1, 1)
                        row.versionText:SetTextColor(1, 1, 1)
                    else
                        row.titleText:SetText('|cff808080' .. row.strippedTitle .. '|r')
                        row.authorText:SetTextColor(0.5, 0.5, 0.5)
                        row.versionText:SetTextColor(0.5, 0.5, 0.5)
                    end
                end
                reloadBtn:Disable()
            end)
        else
            addonsFrame:Hide()
        end
    end)
    closeButton:SetPoint('TOPRIGHT', addonsFrame, 'TOPRIGHT', 0, -1)

    local addonHeader = DF.ui.Font(addonsFrame, 10, 'Addon', {1, 1, 1}, 'LEFT')
    addonHeader:SetPoint('TOPLEFT', addonsFrame, 'TOPLEFT', 35, -30)

    local authorHeader = DF.ui.Font(addonsFrame, 10, 'Author', {1, 1, 1}, 'LEFT')
    authorHeader:SetPoint('TOPLEFT', addonsFrame, 'TOPLEFT', 280, -30)

    local versionHeader = DF.ui.Font(addonsFrame, 10, 'Version', {1, 1, 1}, 'LEFT')
    versionHeader:SetPoint('TOPLEFT', addonsFrame, 'TOPLEFT', 420, -30)

    local scrollFrame = DF.ui.Scrollframe(addonsFrame, 520, 330)
    scrollFrame:SetPoint('TOP', addonsFrame, 'TOP', 0, -50)
    -- debugframe(scrollFrame)

    scrollFrame.content:SetHeight(totalAddons * 30)

    for i = 1, totalAddons do
        local name, title = GetAddOnInfo(i)
        local loaded = IsAddOnLoaded(i)
        local author = GetAddOnMetadata(name, 'Author') or 'Unknown'
        author = string.gsub(author, '|c%x%x%x%x%x%x%x%x', '')
        author = string.gsub(author, '|r', '')
        if string.len(author) > 11 then
            author = string.sub(author, 1, 11) .. '...'
        end
        local version
        if name == info.addonName then
            version = info.version
        else
            version = GetAddOnMetadata(name, 'Version') or 'N/A'
        end

        local row = CreateFrame('Frame', nil, scrollFrame.content)
        row:SetWidth(500)
        row:SetHeight(30)
        row:SetPoint('TOPLEFT', scrollFrame.content, 'TOPLEFT', 0, -(i-1) * 30)

        local checkbox = CreateFrame('CheckButton', nil, row, 'UICheckButtonTemplate')
        checkbox:SetWidth(24)
        checkbox:SetHeight(24)
        checkbox:SetPoint('LEFT', row, 'LEFT', 5, 0)
        checkbox:SetChecked(loaded)

        local titleText = row:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
        titleText:SetPoint('LEFT', checkbox, 'RIGHT', 5, 0)
        local originalTitle = title or name
        local strippedTitle = string.gsub(originalTitle, '|[cCrR]%x?%x?%x?%x?%x?%x?%x?%x?', '')

        local authorText = row:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
        authorText:SetPoint('LEFT', row, 'LEFT', 260, 0)
        authorText:SetText(author)
        authorText:SetTextColor(1, 1, 1)

        local versionText = row:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
        versionText:SetPoint('LEFT', row, 'LEFT', 420, 0)
        versionText:SetText(version)

        initialStates[i] = loaded
        checkboxes[i] = checkbox
        addonRows[i] = {checkbox = checkbox, name = name, titleText = titleText, authorText = authorText, versionText = versionText, originalTitle = originalTitle, strippedTitle = strippedTitle, loaded = loaded}

        if loaded then
            titleText:SetText(originalTitle)
        else
            titleText:SetText('|cff808080' .. strippedTitle .. '|r')
        end

        if not loaded then
            authorText:SetTextColor(0.5, 0.5, 0.5)
            versionText:SetTextColor(0.5, 0.5, 0.5)
        end

        checkbox:SetScript('OnClick', function()
            if this:GetChecked() then
                pendingChanges[name] = true
                titleText:SetText(originalTitle)
                authorText:SetTextColor(1, 1, 1)
                versionText:SetTextColor(1, 0.82, 0)
            else
                pendingChanges[name] = false
                titleText:SetText('|cff808080' .. strippedTitle .. '|r')
                authorText:SetTextColor(0.5, 0.5, 0.5)
                versionText:SetTextColor(0.5, 0.5, 0.5)
            end

            local hasChanges = false
            for j = 1, totalAddons do
                if checkboxes[j]:GetChecked() ~= initialStates[j] then
                    hasChanges = true
                    break
                end
            end

            if hasChanges then
                reloadBtn:Enable()
            else
                reloadBtn:Disable()
            end
        end)
    end

    reloadBtn:SetScript('OnClick', function()
        for addonName, shouldEnable in pendingChanges do
            if shouldEnable then
                EnableAddOn(addonName)
            else
                DisableAddOn(addonName)
            end
        end
        ReloadUI()
    end)

    scrollFrame.updateScrollBar()

    table.insert(UISpecialFrames, addonsFrame:GetName())

    -- callbacks
    local helpers = {}
    local callbacks = {}

    DF:NewCallbacks('addons', callbacks)
end)
