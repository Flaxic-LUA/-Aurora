DRAGONFLIGHT()

DF:NewDefaults('editmode', {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {
        {indexRange = {1, 1}, tab = 'editmode', subtab = 1},
    },

    framePositions = {value = {}},
})

DF:NewModule('editmode', 2, 'PLAYER_AFTER_ENTERING_WORLD', function()
    local registry = {frames = {}, panels = {}, elements = {}}
    local overlays = {}
    local gridFrame = nil
    local lastMode = 'frames'
    local lastDropdown = ''

    local function DrawGrid()
        local grid = CreateFrame('Frame', nil, UIParent)
        grid:SetAllPoints(WorldFrame)

        local size = 1
        local line = {}

        local width = GetScreenWidth()
        local height = GetScreenHeight()

        local ratio = width / GetScreenHeight()
        local rheight = GetScreenHeight() * ratio

        local wStep = width / 64
        local hStep = rheight / 64

        -- vertical lines
        for i = 0, 64 do
            if i == 64 / 2 then
                line = grid:CreateTexture(nil, 'BORDER')
                line:SetTexture(0, 0.8, 1)
            else
                line = grid:CreateTexture(nil, 'BACKGROUND')
                line:SetTexture(0, 0, 0, .2)
            end
            line:SetPoint('TOPLEFT', grid, 'TOPLEFT', i*wStep - (size/2), 0)
            line:SetPoint('BOTTOMRIGHT', grid, 'BOTTOMLEFT', i*wStep + (size/2), 0)
        end

        -- horizontal lines
        for i = 1, floor(height/hStep) do
            if i == floor(height/hStep / 2) then
                line = grid:CreateTexture(nil, 'BORDER')
                line:SetTexture(0, 0.8, 1)
            else
                line = grid:CreateTexture(nil, 'BACKGROUND')
                line:SetTexture(0, 0, 0, .2)
            end
            line:SetPoint('TOPLEFT', grid, 'TOPLEFT', 0, -(i*hStep) + (size/2))
            line:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -(i*hStep + size/2))
        end

        grid:Hide()
        return grid
    end

    local function CreateOverlay(targetFrame, label, isElement)
        local overlay = CreateFrame('Frame', nil, UIParent)
        overlay:SetWidth(targetFrame:GetWidth())
        overlay:SetHeight(targetFrame:GetHeight())
        overlay:SetPoint('CENTER', targetFrame, 'CENTER', 0, 0)
        overlay:SetFrameStrata('TOOLTIP')
        overlay:EnableMouse(true)
        overlay:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8X8', edgeFile = 'Interface\\Buttons\\WHITE8X8', edgeSize = 2})

        if isElement then
            overlay:SetBackdropColor(1, 1, 0, 0.2)
            overlay:SetBackdropBorderColor(1, 1, 0, 1)
        else
            overlay:SetBackdropColor(0, 0.5, 1, 0.2)
            overlay:SetBackdropBorderColor(0, 0.8, 1, 1)
            local text = DF.ui.Font(overlay, 12, label, {1, 1, 1}, 'CENTER', 'OUTLINE')
            text:SetPoint('CENTER', overlay, 'CENTER', 0, 0)
        end

        overlay:Hide()
        return overlay
    end

    local function SaveFramePosition(frame)
        local name = frame:GetName()
        if not name then return end
        if name == 'DF_BagAnchor' and DF_Profiles and DF.profile['bags'] then
            local moveMode = DF.profile['bags']['oneBagMoveMode']
            if moveMode == 'click' or moveMode == 'shiftclick' then
                return
            end
        end
        local parent = frame:GetParent()
        if parent and parent ~= UIParent then
            local px, py = parent:GetCenter()
            local fx, fy = frame:GetCenter()
            DF.profile['editmode']['framePositions'][name] = {rx = fx - px, ry = fy - py, parent = parent:GetName()}
        else
            local x, y = floor(frame:GetLeft() + 0.5), floor(frame:GetTop() + 0.5)
            DF.profile['editmode']['framePositions'][name] = {x = x, y = y}
        end
    end

    local function RestoreFramePositions()
        for name, pos in pairs(DF.profile['editmode']['framePositions']) do
            local frame = getglobal(name)
            if frame then
                local skipRestore = false
                if name == 'DF_BagAnchor' and DF_Profiles and DF.profile['bags'] then
                    local moveMode = DF.profile['bags']['oneBagMoveMode']
                    if moveMode == 'click' or moveMode == 'shiftclick' then
                        skipRestore = true
                    end
                end
                if not skipRestore then
                    frame:ClearAllPoints()
                    if pos.parent and pos.rx and pos.ry then
                        local parent = getglobal(pos.parent)
                        if parent then
                            frame:SetPoint('CENTER', parent, 'CENTER', pos.rx, pos.ry)
                        end
                    elseif pos.x and pos.y then
                        frame:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', pos.x, pos.y)
                    end
                end
            end
        end
    end

    local function CreateDirectionButton(overlay, targetFrame, dir, xOffset, yOffset)
        local button = CreateFrame('Button', nil, overlay)
        button:SetSize(8, 8)
        button:SetPoint(dir, overlay, dir, 0, 0)
        button:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8X8', edgeFile = 'Interface\\Buttons\\WHITE8X8', edgeSize = 1})
        button:SetBackdropColor(0, 0.5, 1, 0.8)
        button:SetBackdropBorderColor(0, 0.8, 1, 1)
        button:SetScript('OnClick', function()
            local parent = targetFrame:GetParent()
            targetFrame:ClearAllPoints()
            if parent and parent ~= UIParent then
                local px, py = parent:GetCenter()
                local fx, fy = targetFrame:GetCenter()
                targetFrame:SetPoint('CENTER', parent, 'CENTER', (fx - px) + xOffset, (fy - py) + yOffset)
            else
                local x, y = targetFrame:GetLeft() + xOffset, targetFrame:GetTop() + yOffset
                targetFrame:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', x, y)
            end
            overlay:ClearAllPoints()
            overlay:SetPoint('CENTER', targetFrame, 'CENTER', 0, 0)
            SaveFramePosition(targetFrame)
        end)
        button:SetScript('OnEnter', function()
            button:SetBackdropColor(0.2, 0.7, 1, 1)
        end)
        button:SetScript('OnLeave', function()
            button:SetBackdropColor(0, 0.5, 1, 0.8)
        end)
        return button
    end

    local function MakeDraggable(overlay, targetFrame)
        local isDragging = false
        local startX, startY

        overlay:SetScript('OnMouseDown', function()
            if arg1 == 'RightButton' then
                overlay:Hide()
                return
            end
            isDragging = true
            startX, startY = GetCursorPosition()
            overlay:StartMoving()
        end)

        overlay:SetScript('OnMouseUp', function()
            if isDragging then
                isDragging = false
                overlay:StopMovingOrSizing()
                local parent = targetFrame:GetParent()
                targetFrame:ClearAllPoints()
                if parent and parent ~= UIParent then
                    local px, py = parent:GetCenter()
                    local ox, oy = overlay:GetCenter()
                    targetFrame:SetPoint('CENTER', parent, 'CENTER', ox - px, oy - py)
                else
                    targetFrame:SetPoint('CENTER', overlay, 'CENTER', 0, 0)
                end
                SaveFramePosition(targetFrame)
            end
        end)

        overlay:SetMovable(true)

        CreateDirectionButton(overlay, targetFrame, 'TOP', 0, 1)
        CreateDirectionButton(overlay, targetFrame, 'LEFT', -1, 0)
        CreateDirectionButton(overlay, targetFrame, 'RIGHT', 1, 0)
        CreateDirectionButton(overlay, targetFrame, 'BOTTOM', 0, -1)
    end

    local function RegisterFrame(frameNameOrObj, frameType)
        local frame, name
        if type(frameNameOrObj) == 'string' then
            frame = getglobal(frameNameOrObj)
            name = frameNameOrObj
        else
            frame = frameNameOrObj
            name = frame.GetName and frame:GetName() or 'unknown'
        end
        if frame then
            table.insert(registry[frameType], {frame = frame, name = name})
        end
    end

    local function ActivateMode(modeType)
        for i = 1, table.getn(overlays) do
            overlays[i]:Hide()
        end
        overlays = {}

        if not modeType then return end

        currentMode = modeType
        local frames = registry[modeType]

        for i = 1, table.getn(frames) do
            local data = frames[i]
            local overlay = CreateOverlay(data.frame, data.name, modeType == 'elements')
            MakeDraggable(overlay, data.frame)
            overlay:Show()
            table.insert(overlays, overlay)
        end
    end

    local editFrame = CreateFrame('Frame', 'DF_EditModeFrame', UIParent)
    editFrame:SetWidth(300)
    editFrame:SetHeight(100)
    editFrame:SetPoint('TOP', UIParent, 'TOP', 0, -20)
    editFrame:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8X8', edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border', tile = true, tileSize = 16, edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    editFrame:SetBackdropColor(0, 0, 0, 0.6)
    editFrame:SetBackdropBorderColor(0, 0, 0, .6)
    editFrame:Hide()

    local hint = DF.ui.Font(editFrame, 10, 'Right-Click to remove overlay', {0.7, 0.7, 0.7}, 'LEFT', 'OUTLINE')
    hint:SetPoint('BOTTOMLEFT', editFrame, 'BOTTOMLEFT', 10, 10)

    gridFrame = DrawGrid()
    RestoreFramePositions()

    DF.setups.RestoreFramePositions = RestoreFramePositions
    DF.setups.SaveFramePosition = SaveFramePosition

    editFrame:SetScript('OnShow', function()
        gridFrame:Show()
        registry.frames = {}
        RegisterFrame('DF_MainBar', 'frames')
        RegisterFrame('DF_BagBar', 'frames')
        RegisterFrame('DF_BagAnchor', 'frames')
        RegisterFrame('DF_MultiBar1', 'frames')
        RegisterFrame('DF_MultiBar2', 'frames')
        RegisterFrame('DF_MultiBar3', 'frames')
        RegisterFrame('DF_MultiBar4', 'frames')
        RegisterFrame('DF_MultiBar5', 'frames')
        RegisterFrame('DF_PlayerFrame', 'frames')
        RegisterFrame('DF_TargetFrame', 'frames')
        RegisterFrame('DF_TargettargetFrame', 'frames')
        RegisterFrame('DF_PetFrame', 'frames')
        RegisterFrame('DF_PagingContainer', 'frames')
        RegisterFrame('DF_TopPanel', 'frames')
        RegisterFrame('DF_MinimapCluster', 'frames')
        RegisterFrame('DF_MicroMenu', 'frames')
        RegisterFrame('DF_BuffFrame', 'frames')
        RegisterFrame('DF_DebuffFrame', 'frames')
        RegisterFrame('DF_PlayerCastBar', 'frames')
        RegisterFrame('DF_TargetCastBar', 'frames')
        RegisterFrame('DF_XPBar', 'frames')
        RegisterFrame('DF_RepBar', 'frames')
        RegisterFrame('DF_ChatFrame', 'frames')
        RegisterFrame('DF_ChatInputContainer', 'frames')
        RegisterFrame('DF_Dock', 'frames')
        RegisterFrame('DurabilityFrame', 'frames')
        RegisterFrame('DF_WeaponFrame', 'frames')
        RegisterFrame('DF_PetBar', 'frames')
        RegisterFrame('DF_StanceBar', 'frames')
        RegisterFrame('DF_PettargetFrame', 'frames')
        RegisterFrame('DF_Party1Frame', 'frames')
        RegisterFrame('DF_Party2Frame', 'frames')
        RegisterFrame('DF_Party3Frame', 'frames')
        RegisterFrame('DF_Party4Frame', 'frames')
        RegisterFrame('DF_ComboPointsContainer', 'frames')
        RegisterFrame('DF_DistanceFrame', 'frames')
        RegisterFrame('DF_NoControlFrame', 'frames')
        RegisterFrame('DF_QuestTracker', 'frames')
    end)

    editFrame:SetScript('OnHide', function()
        gridFrame:Hide()
        ActivateMode(nil)
    end)

    local cb1 = DF.ui.Checkbox(editFrame, 'Frames', 20, 20, 'RIGHT')
    cb1:SetPoint('TOPLEFT', editFrame, 'TOPLEFT', 10, -10)

    local cb3 = DF.ui.Checkbox(editFrame, 'Elements', 20, 20, 'RIGHT')
    cb3:SetPoint('TOPLEFT', cb1, 'BOTTOMLEFT', 0, -5)

    local dropdown = DF.ui.Dropdown(editFrame, 'Select', 100, 20)
    dropdown:SetPoint('LEFT', cb3.label, 'RIGHT', 10, 0)
    dropdown:AddItem('Actionbuttons', function()
        dropdown.text:SetText('Actionbuttons')
        dropdown.selectedValue = 'Actionbuttons'
        dropdown.popup:Hide()
        lastDropdown = 'Actionbuttons'
        registry.elements = {}
        for i = 1, 12 do
            RegisterFrame('DF_MainBarButton'..i, 'elements')
        end
        for i = 1, 12 do
            RegisterFrame('DF_MultiBar1Button'..i, 'elements')
        end
        for i = 1, 12 do
            RegisterFrame('DF_MultiBar2Button'..i, 'elements')
        end
        for i = 1, 12 do
            RegisterFrame('DF_MultiBar3Button'..i, 'elements')
        end
        for i = 1, 12 do
            RegisterFrame('DF_MultiBar4Button'..i, 'elements')
        end
        for i = 1, 12 do
            RegisterFrame('DF_MultiBar5Button'..i, 'elements')
        end
        ActivateMode('elements')
    end)
    dropdown:AddItem('Petbar', function()
        dropdown.text:SetText('Petbar')
        dropdown.selectedValue = 'Petbar'
        dropdown.popup:Hide()
        lastDropdown = 'Petbar'
        registry.elements = {}
        for i = 1, 10 do
            RegisterFrame('DF_PetBarButton'..i, 'elements')
        end
        ActivateMode('elements')
    end)
    dropdown:AddItem('Stancebar', function()
        dropdown.text:SetText('Stancebar')
        dropdown.selectedValue = 'Stancebar'
        dropdown.popup:Hide()
        lastDropdown = 'Stancebar'
        registry.elements = {}
        for i = 1, 10 do
            RegisterFrame('DF_StanceBarButton'..i, 'elements')
        end
        ActivateMode('elements')
    end)
    dropdown:AddItem('Bagbar', function()
        dropdown.text:SetText('Bagbar')
        dropdown.selectedValue = 'Bagbar'
        dropdown.popup:Hide()
        lastDropdown = 'Bagbar'
        registry.elements = {}
        RegisterFrame('DF_MainBag', 'elements')
        RegisterFrame('DF_Bag0', 'elements')
        RegisterFrame('DF_Bag1', 'elements')
        RegisterFrame('DF_Bag2', 'elements')
        RegisterFrame('DF_Bag3', 'elements')
        RegisterFrame('DF_KeyRing', 'elements')
        RegisterFrame('DF_BagToggle', 'elements')
        ActivateMode('elements')
    end)
    dropdown:AddItem('Minimap Cluster', function()
        dropdown.text:SetText('Minimap Cluster')
        dropdown.selectedValue = 'Minimap Cluster'
        dropdown.popup:Hide()
        lastDropdown = 'Minimap Cluster'
        registry.elements = {}
        RegisterFrame('DF_GameTimeButton', 'elements')
        RegisterFrame('DF_MinimapZoomIn', 'elements')
        RegisterFrame('DF_MinimapZoomOut', 'elements')
        RegisterFrame('MiniMapTrackingFrame', 'elements')
        RegisterFrame('MiniMapMailFrame', 'elements')
        RegisterFrame('DF_CollectorExpandButton', 'elements')
        ActivateMode('elements')
    end)
    dropdown:AddItem('Micro Menu', function()
        dropdown.text:SetText('Micro Menu')
        dropdown.selectedValue = 'Micro Menu'
        dropdown.popup:Hide()
        lastDropdown = 'Micro Menu'
        registry.elements = {}
        RegisterFrame('DF_MicroButton_Character', 'elements')
        RegisterFrame('DF_MicroButton_Spellbook', 'elements')
        RegisterFrame('DF_MicroButton_Talents', 'elements')
        RegisterFrame('DF_MicroButton_QuestLog', 'elements')
        RegisterFrame('DF_MicroButton_Socials', 'elements')
        RegisterFrame('DF_MicroButton_WorldMap', 'elements')
        RegisterFrame('DF_MicroButton_MainMenu', 'elements')
        RegisterFrame('DF_MicroButton_Help', 'elements')
        ActivateMode('elements')
    end)
    dropdown:AddItem('Combopoints', function()
        dropdown.text:SetText('Combopoints')
        dropdown.selectedValue = 'Combopoints'
        dropdown.popup:Hide()
        lastDropdown = 'Combopoints'
        registry.elements = {}
        for i = 1, 5 do
            RegisterFrame('AUComboFrame'..i, 'elements')
        end
        ActivateMode('elements')
    end)
    local units = {'Player', 'Target', 'Targettarget', 'Pet', 'Pettarget', 'Party1', 'Party2', 'Party3', 'Party4'}
    for i = 1, table.getn(units) do
        local unit = units[i]
        dropdown:AddItem(unit..' Parts', function()
            dropdown.text:SetText(unit..' Parts')
            dropdown.selectedValue = unit..' Parts'
            dropdown.popup:Hide()
            lastDropdown = unit..' Parts'
            registry.elements = {}
            local frame = getglobal('DF_'..unit..'Frame')
            if frame then
                if frame.infoBg then frame.infoBg.GetName = function() return 'DF_'..unit..'Frame.infoBg' end RegisterFrame(frame.infoBg, 'elements') end
                if frame.hpBar then frame.hpBar.GetName = function() return 'DF_'..unit..'Frame.hpBar' end RegisterFrame(frame.hpBar, 'elements') end
                if frame.powerBar then frame.powerBar.GetName = function() return 'DF_'..unit..'Frame.powerBar' end RegisterFrame(frame.powerBar, 'elements') end
                if frame.happinessIcon then frame.happinessIcon.GetName = function() return 'DF_'..unit..'Frame.happinessIcon' end RegisterFrame(frame.happinessIcon, 'elements') end
            end
            ActivateMode('elements')
        end)
    end
    dropdown:Disable()

    cb1:SetScript('OnClick', function() if cb1:GetChecked() then cb3:SetChecked(false) dropdown:Disable() lastMode = 'frames' ActivateMode('frames') else ActivateMode(nil) end end)
    cb3:SetScript('OnClick', function() if cb3:GetChecked() then cb1:SetChecked(false) dropdown:Enable() lastMode = 'elements' ActivateMode('elements') else ActivateMode(nil) end end)

    local origOnShow = editFrame:GetScript('OnShow')
    editFrame:SetScript('OnShow', function()
        if origOnShow then origOnShow() end
        if lastMode == 'elements' and lastDropdown ~= '' then
            cb1:SetChecked(false)
            cb3:SetChecked(true)
            dropdown:Enable()
            for i = 1, table.getn(dropdown.items) do
                if dropdown.items[i].text:GetText() == lastDropdown then
                    dropdown.items[i]:GetScript('OnClick')()
                    break
                end
            end
        else
            cb1:SetChecked(true)
            ActivateMode('frames')
        end
    end)

    local exitBtn = DF.ui.Button(editFrame, 'Exit', 100, 30)
    exitBtn:SetPoint('BOTTOMRIGHT', editFrame, 'BOTTOMRIGHT', -5, 5)
    exitBtn:SetScript('OnClick', function() editFrame:Hide() end)

    table.insert(UISpecialFrames, editFrame:GetName())

    -- callbacks
    local helpers = {}
    local callbacks = {}

    DF:NewCallbacks('editmode', callbacks)
end)
