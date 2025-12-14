UNLOCKAURORA()

AU:NewDefaults('gui-generator', {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {
        {tab = 'general', subtab = 'GUI', categories = 'General'},
    },

    guiscale = {value = 100, metadata = {element = 'dropdown', category = 'General', indexInCategory = 1, description = 'Scale the entire GUI interface', options = {50, 60, 70, 80, 90, 100}}},
    guibgalpha = {value = 100, metadata = {element = 'slider', category = 'General', indexInCategory = 2, description = 'Background transparency for GUI frames', min = 0, max = 100, stepSize = 5}},
    guifont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'General', indexInCategory = 3, description = 'Font used throughout the GUI', options = media.fonts}},
    guimovable = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 4, description = 'Allow dragging the GUI with mouse'}},
})

AU:NewModule('gui-generator', 3, function()
    local setup = {
        paddingLeft = 40,
        paddingRight = 40,
        spacingHeader = 40,
        spacingCheckbox = 40,
        spacingDropdown = 40,
        spacingColorpicker = 40,
        initialYOffset = -70,
    }

    function setup:CollectMetadata()
        local modules = {}
        for moduleName, moduleDefaults in pairs(AU.defaults) do
            modules[moduleName] = {gui = nil, elements = {}}
            for key, data in pairs(moduleDefaults) do
                if key == 'gui' then
                    modules[moduleName].gui = data
                elseif key ~= 'enabled' and key ~= 'version' and data.metadata then
                    local element = {
                        key = key,
                        value = data.value,
                        moduleName = moduleName,
                    }
                    for metaKey, metaValue in pairs(data.metadata) do
                        element[metaKey] = metaValue
                    end
                    table.insert(modules[moduleName].elements, element)
                end
            end
        end
        return modules
    end

    function setup:FormatKeyName(key)
        local result = ''
        local i = 1
        while i <= string.len(key) do
            local char = string.sub(key, i, i)
            if i == 1 then
                result = result .. string.upper(char)
            elseif char == string.upper(char) and char ~= string.lower(char) then
                result = result .. ' ' .. char
            else
                result = result .. char
            end
            i = i + 1
        end
        return result
    end

    function setup:CheckDependency(mod, dep)
        if not dep then return true end
        if dep.key then
            local depValue = AU.profile[mod][dep.key]
            if dep.state ~= nil then
                if dep.state == false then
                    return (depValue == 0 or depValue == false)
                else
                    return (depValue == dep.state)
                end
            elseif dep.stateNot ~= nil then
                if dep.stateNot == false then
                    return (depValue ~= 0 and depValue ~= false)
                else
                    return (depValue ~= dep.stateNot)
                end
            end
        elseif dep[1] then
            for i = 1, table.getn(dep) do
                if not setup:CheckDependency(mod, dep[i]) then
                    return false
                end
            end
            return true
        end
        return true
    end

    function setup:FindPanelForCategory(guiTable, category, elementKey, moduleName)
        if not guiTable then
            return nil, nil
        end
        local categoryLower = string.lower(category)
        local numMappings = table.getn(guiTable)
        for i = 1, numMappings do
            local mapping = guiTable[i]
            if mapping.tab then
                if mapping.categories and string.lower(mapping.categories) == categoryLower then
                    return mapping.tab, mapping.subtab
                end
                for j = 1, table.getn(mapping) do
                    if string.lower(mapping[j]) == categoryLower then
                        return mapping.tab, mapping.subtab
                    end
                end
            end
        end
        return nil, nil
    end

    function setup:GenerateGUI()
        if AU.setups.guiGenerated then
            return
        end
        AU.setups.guiGenerated = true

        local collectedModules = setup:CollectMetadata()
        local guiBase = AU.setups.guiBase
        local widgets = {}
        local dependencies = {}

        for moduleName, moduleData in pairs(collectedModules) do
            if table.getn(moduleData.elements) == 0 then
            else
                table.sort(moduleData.elements, function(a, b)
                    if a.category == b.category then
                        return (a.indexInCategory or 0) < (b.indexInCategory or 0)
                    end
                    return (a.category or '') < (b.category or '')
                end)

                local panelElements = {}

                for i = 1, table.getn(moduleData.elements) do
                    local element = moduleData.elements[i]
                    local tabKey, subtab = setup:FindPanelForCategory(moduleData.gui, element.category, element.key, moduleName)

                    if tabKey then
                        local panelKey = subtab and (tabKey .. '_' .. subtab) or tabKey
                        if not panelElements[panelKey] then
                            panelElements[panelKey] = {elements = {}}
                        end
                        table.insert(panelElements[panelKey].elements, element)
                    end

                    if element.dependency then
                        if element.dependency.key then
                            local depKey = moduleName .. '.' .. element.dependency.key
                            if not dependencies[depKey] then
                                dependencies[depKey] = {}
                            end
                            table.insert(dependencies[depKey], {mod = moduleName, key = element.key, state = element.dependency.state, stateNot = element.dependency.stateNot})
                        elseif element.dependency[1] then
                            for i = 1, table.getn(element.dependency) do
                                local singleDep = element.dependency[i]
                                if singleDep.key then
                                    local depKey = moduleName .. '.' .. singleDep.key
                                    if not dependencies[depKey] then
                                        dependencies[depKey] = {}
                                    end
                                    table.insert(dependencies[depKey], {mod = moduleName, key = element.key, state = singleDep.state, stateNot = singleDep.stateNot})
                                end
                            end
                        end
                    end
                end

                for panelKey, panelData in pairs(panelElements) do
                    if not guiBase.panels[panelKey] then
                        local panel = CreateFrame('Frame', nil, guiBase.panelframe.content)
                        panel:SetAllPoints(guiBase.panelframe.content)
                        panel:Hide()
                        guiBase.panels[panelKey] = panel
                    end

                    local panel = guiBase.panels[panelKey]
                    if panel then
                        local yOffset = setup.initialYOffset
                        local lastCategory = nil

                        for i = 1, table.getn(panelData.elements) do
                            local element = panelData.elements[i]

                            if element.category and element.category ~= lastCategory then
                                local header = AU.ui.Font(panel, 13, element.category, {1, 0.82, 0}, 'LEFT')
                                header:SetPoint('TOPLEFT', panel, 'TOPLEFT', setup.paddingLeft, yOffset)
                                yOffset = yOffset - setup.spacingHeader
                                lastCategory = element.category
                            end

                            if element.element == 'checkbox' then
                                local mod = moduleName
                                local key = element.key
                                local dep = element.dependency

                                local desc = AU.ui.Font(panel, 12, element.description, {.9, .9, .9}, 'LEFT')
                                desc:SetPoint('TOPLEFT', panel, 'TOPLEFT', setup.paddingLeft, yOffset)

                                local checkbox = AU.ui.Checkbox(panel, setup:FormatKeyName(key))
                                checkbox:SetPoint('TOPRIGHT', panel, 'TOPRIGHT', -setup.paddingRight, yOffset)
                                checkbox:SetChecked(AU.profile[mod][key])
                                checkbox:SetScript('OnClick', function()
                                    local newValue = this:GetChecked() and true or false
                                    AU:SetConfig(mod, key, newValue)

                                    local depKey = mod .. '.' .. key
                                    if dependencies[depKey] then
                                        for j = 1, table.getn(dependencies[depKey]) do
                                            local depInfo = dependencies[depKey][j]
                                            local widget = widgets[depInfo.mod .. '.' .. depInfo.key]
                                            local widgetDesc = widgets[depInfo.mod .. '.' .. depInfo.key .. '.desc']
                                            if widget then
                                                local shouldEnable = false
                                                if depInfo.state then
                                                    shouldEnable = (newValue == depInfo.state)
                                                elseif depInfo.stateNot then
                                                    shouldEnable = (newValue ~= depInfo.stateNot)
                                                end
                                                if shouldEnable then
                                                    widget:Enable()
                                                    if widgetDesc then widgetDesc:SetTextColor(.9, .9, .9) end
                                                else
                                                    widget:Disable()
                                                    if widgetDesc then widgetDesc:SetTextColor(.5, .5, .5) end
                                                end
                                            end
                                        end
                                    end
                                end)
                                widgets[mod .. '.' .. key] = checkbox
                                widgets[mod .. '.' .. key .. '.desc'] = desc

                                if dep then
                                    if setup:CheckDependency(mod, dep) then
                                        checkbox:Enable()
                                        desc:SetTextColor(.9, .9, .9)
                                    else
                                        checkbox:Disable()
                                        desc:SetTextColor(.5, .5, .5)
                                    end
                                end
                                yOffset = yOffset - setup.spacingCheckbox

                            elseif element.element == 'slider' then
                                local mod = moduleName
                                local key = element.key
                                local dep = element.dependency

                                local desc = AU.ui.Font(panel, 12, element.description, {.9, .9, .9}, 'LEFT')
                                desc:SetPoint('TOPLEFT', panel, 'TOPLEFT', setup.paddingLeft, yOffset)

                                local slider = AU.ui.Slider(panel, nil, setup:FormatKeyName(key), element.min, element.max, element.stepSize, '%.0f')
                                slider:SetPoint('TOPRIGHT', panel, 'TOPRIGHT', -setup.paddingRight, yOffset)
                                local profileValue = AU.profile[mod][key]
                                if profileValue == nil then
                                    profileValue = element.value
                                    AU.profile[mod][key] = profileValue
                                end
                                slider:SetValue(profileValue)
                                slider:SetScript('OnValueChanged', function()
                                    local newValue = this:GetValue()
                                    AU:SetConfig(mod, key, newValue)

                                    local depKey = mod .. '.' .. key
                                    if dependencies[depKey] then
                                        for j = 1, table.getn(dependencies[depKey]) do
                                            local depInfo = dependencies[depKey][j]
                                            local widget = widgets[depInfo.mod .. '.' .. depInfo.key]
                                            local widgetDesc = widgets[depInfo.mod .. '.' .. depInfo.key .. '.desc']
                                            if widget then
                                                local shouldEnable = false
                                                if depInfo.state ~= nil then
                                                    if depInfo.state == false then
                                                        shouldEnable = (newValue == 0 or newValue == false)
                                                    else
                                                        shouldEnable = (newValue == depInfo.state)
                                                    end
                                                elseif depInfo.stateNot ~= nil then
                                                    if depInfo.stateNot == false then
                                                        shouldEnable = (newValue ~= 0 and newValue ~= false)
                                                    else
                                                        shouldEnable = (newValue ~= depInfo.stateNot)
                                                    end
                                                end
                                                if shouldEnable then
                                                    widget:Enable()
                                                    if widgetDesc then widgetDesc:SetTextColor(.9, .9, .9) end
                                                else
                                                    widget:Disable()
                                                    if widgetDesc then widgetDesc:SetTextColor(.5, .5, .5) end
                                                end
                                            end
                                        end
                                    end
                                end)
                                widgets[mod .. '.' .. key] = slider
                                widgets[mod .. '.' .. key .. '.desc'] = desc

                                if dep then
                                    if setup:CheckDependency(mod, dep) then
                                        slider:Enable()
                                        desc:SetTextColor(.9, .9, .9)
                                    else
                                        slider:Disable()
                                        desc:SetTextColor(.5, .5, .5)
                                    end
                                end
                                yOffset = yOffset - 40

                            elseif element.element == 'dropdown' then
                                local mod = moduleName
                                local key = element.key
                                local dep = element.dependency

                                local desc = AU.ui.Font(panel, 12, element.description, {.9, .9, .9}, 'LEFT')
                                desc:SetPoint('TOPLEFT', panel, 'TOPLEFT', setup.paddingLeft, yOffset)

                                local dropdown = AU.ui.Dropdown(panel, setup:FormatKeyName(key))
                                dropdown:SetPoint('TOPRIGHT', panel, 'TOPRIGHT', -setup.paddingRight, yOffset)
                                if not element.options then
                                    error('Dropdown element '..key..' in module '..mod..' has no options!')
                                end
                                for j = 1, table.getn(element.options) do
                                    local option = element.options[j]
                                    local displayText = string.gsub(option, 'Fonts\\', '')
                                    displayText = string.gsub(displayText, 'font:', '')
                                    dropdown:AddItem(displayText, function()
                                        dropdown.text:SetText(displayText)
                                        dropdown.selectedValue = option
                                        dropdown.popup:Hide()
                                        AU:SetConfig(mod, key, option)

                                        local depKey = mod .. '.' .. key
                                        if dependencies[depKey] then
                                            for k = 1, table.getn(dependencies[depKey]) do
                                                local depInfo = dependencies[depKey][k]
                                                local widget = widgets[depInfo.mod .. '.' .. depInfo.key]
                                                local widgetDesc = widgets[depInfo.mod .. '.' .. depInfo.key .. '.desc']
                                                if widget then
                                                    local shouldEnable = false
                                                    if depInfo.state then
                                                        shouldEnable = (option == depInfo.state)
                                                    elseif depInfo.stateNot then
                                                        shouldEnable = (option ~= depInfo.stateNot)
                                                    end
                                                    if shouldEnable then
                                                        widget:Enable()
                                                        if widgetDesc then widgetDesc:SetTextColor(.9, .9, .9) end
                                                    else
                                                        widget:Disable()
                                                        if widgetDesc then widgetDesc:SetTextColor(.5, .5, .5) end
                                                    end
                                                end
                                            end
                                        end
                                    end)
                                end
                                local currentValue = AU.profile[mod][key]
                                local currentDisplay = string.gsub(currentValue, 'Fonts\\', '')
                                currentDisplay = string.gsub(currentDisplay, 'font:', '')
                                dropdown.text:SetText(currentDisplay)
                                dropdown.selectedValue = currentValue
                                widgets[mod .. '.' .. key] = dropdown
                                widgets[mod .. '.' .. key .. '.desc'] = desc

                                if dep then
                                    if setup:CheckDependency(mod, dep) then
                                        dropdown:Enable()
                                        desc:SetTextColor(.9, .9, .9)
                                    else
                                        dropdown:Disable()
                                        desc:SetTextColor(.5, .5, .5)
                                    end
                                end
                                yOffset = yOffset - setup.spacingDropdown

                            elseif element.element == 'colorpicker' then
                                local mod = moduleName
                                local key = element.key
                                local dep = element.dependency

                                local desc = AU.ui.Font(panel, 12, element.description, {.9, .9, .9}, 'LEFT')
                                desc:SetPoint('TOPLEFT', panel, 'TOPLEFT', setup.paddingLeft, yOffset)

                                local colorpicker = AU.ui.ColorPicker(panel, AU.profile[mod][key], function(color)
                                    AU:SetConfig(mod, key, color)
                                end)
                                colorpicker:SetPoint('TOPRIGHT', panel, 'TOPRIGHT', -setup.paddingRight, yOffset)
                                widgets[mod .. '.' .. key] = colorpicker
                                widgets[mod .. '.' .. key .. '.desc'] = desc

                                if dep then
                                    if setup:CheckDependency(mod, dep) then
                                        colorpicker:Enable()
                                        desc:SetTextColor(.9, .9, .9)
                                    else
                                        colorpicker:Disable()
                                        desc:SetTextColor(.5, .5, .5)
                                    end
                                end
                                yOffset = yOffset - setup.spacingColorpicker
                            end
                        end

                        local panelHeight = math.abs(yOffset) + 10
                        panel:SetHeight(panelHeight)
                        guiBase.panelframe.content:SetHeight(panelHeight)
                        guiBase.panelframe.updateScrollBar()
                    end
                end
            end
        end
    end

    setup:GenerateGUI()

    local guiBase = AU.setups.guiBase
    local callbacks = {}

    callbacks.guiscale = function(value)
        guiBase.mainframe:SetScale(value / 100)
    end

    callbacks.guibgalpha = function(value)
        guiBase.mainframe.Bg:SetAlpha(value / 100)
    end

    callbacks.guifont = function(value)
        AU.ui.UpdateFrameFonts(guiBase.mainframe, media[value])
    end

    callbacks.guimovable = function(value)
        if value then
            guiBase.mainframe:SetMovable(true)
            guiBase.mainframe:RegisterForDrag('LeftButton')
        else
            guiBase.mainframe:SetMovable(false)
            guiBase.mainframe:RegisterForDrag()
        end
    end

    AU:NewCallbacks('gui-generator', callbacks)
end)
