UNLOCKAURORA()

AU:NewDefaults('editmode', {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {
        {indexRange = {1, 1}, tab = 'editmode', subtab = 1},
    },

    framePositions = {value = {}},
})

AU:NewModule('editmode', 1, 'PLAYER_ENTERING_WORLD', function()
    local registry = {frames = {}, panels = {}, elements = {}}
    local overlays = {}
    local gridFrame = nil

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
                line:SetTexture(.8, .6, 0)
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
                line:SetTexture(.8, .6, 0)
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
        end

        local text = AU.ui.Font(overlay, 12, label, {1, 1, 1}, 'CENTER', 'OUTLINE')
        text:SetPoint('CENTER', overlay, 'CENTER', 0, 0)

        overlay:Hide()
        return overlay
    end

    local function SaveFramePosition(frame)
        local name = frame:GetName()
        if not name then return end
        local x, y = floor(frame:GetLeft() + 0.5), floor(frame:GetTop() + 0.5)
        AU.profile['editmode']['framePositions'][name] = {x = x, y = y}
    end

    local function RestoreFramePositions()
        for name, pos in pairs(AU.profile['editmode']['framePositions']) do
            local frame = getglobal(name)
            if frame and pos.x and pos.y then
                frame:ClearAllPoints()
                frame:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', pos.x, pos.y)
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
            targetFrame:ClearAllPoints()
            local x, y = targetFrame:GetLeft() + xOffset, targetFrame:GetTop() + yOffset
            targetFrame:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', x, y)
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
                targetFrame:ClearAllPoints()
                targetFrame:SetPoint('CENTER', overlay, 'CENTER', 0, 0)
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

    local editFrame = CreateFrame('Frame', 'AU_EditModeFrame', UIParent)
    editFrame:SetWidth(300)
    editFrame:SetHeight(100)
    editFrame:SetPoint('TOP', UIParent, 'TOP', 0, -20)
    editFrame:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8X8', edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border', tile = true, tileSize = 16, edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    editFrame:SetBackdropColor(0, 0, 0, 0.6)
    editFrame:SetBackdropBorderColor(0, 0, 0, .6)
    editFrame:Hide()

    local hint = AU.ui.Font(editFrame, 10, 'Right-Click to remove overlay', {0.7, 0.7, 0.7}, 'LEFT', 'OUTLINE')
    hint:SetPoint('BOTTOMLEFT', editFrame, 'BOTTOMLEFT', 10, 10)

    gridFrame = DrawGrid()
    RestoreFramePositions()

    editFrame:SetScript('OnShow', function()
        gridFrame:Show()
        registry.frames = {}
        RegisterFrame('AuroraMainBar', 'frames')
        RegisterFrame('AU_BagBar', 'frames')
        RegisterFrame('AU_BagAnchor', 'frames')
        RegisterFrame('AuroraMultiBar1', 'frames')
        RegisterFrame('AuroraMultiBar2', 'frames')
        RegisterFrame('AuroraMultiBar3', 'frames')
        RegisterFrame('AuroraMultiBar4', 'frames')
        RegisterFrame('AuroraMultiBar5', 'frames')
        RegisterFrame('AuroraPlayerFrame', 'frames')
        RegisterFrame('AuroraTargetFrame', 'frames')
        RegisterFrame('AuroraTargettargetFrame', 'frames')
        RegisterFrame('AuroraPetFrame', 'frames')
        RegisterFrame('AuroraPagingContainer', 'frames')
        RegisterFrame('AU_TopPanel', 'frames')
        RegisterFrame('AU_MinimapCluster', 'frames')
        RegisterFrame('AuroraMicroMenu', 'frames')
        RegisterFrame('AU_BuffFrame', 'frames')
        RegisterFrame('AU_DebuffFrame', 'frames')
        RegisterFrame('AU_PlayerCastBar', 'frames')
        RegisterFrame('AU_TargetCastBar', 'frames')
        RegisterFrame('AU_XPBar', 'frames')
        RegisterFrame('AU_RepBar', 'frames')
        RegisterFrame('AU_ChatFrame', 'frames')
        RegisterFrame('AU_Dock', 'frames')
        RegisterFrame('AU_QuestTracker', 'frames')
        RegisterFrame('DurabilityFrame', 'frames')
        RegisterFrame('AU_WeaponFrame', 'frames')
        RegisterFrame('AuroraPetBar', 'frames')
        RegisterFrame('AuroraPettargetFrame', 'frames')
        RegisterFrame('AuroraParty1Frame', 'frames')
        RegisterFrame('AuroraParty2Frame', 'frames')
        RegisterFrame('AuroraParty3Frame', 'frames')
        RegisterFrame('AuroraParty4Frame', 'frames')
        RegisterFrame('AU_ComboPointsContainer', 'frames')

        ActivateMode('frames')
    end)

    editFrame:SetScript('OnHide', function()
        gridFrame:Hide()
        ActivateMode(nil)
    end)

    local cb1 = AU.ui.Checkbox(editFrame, 'Frames', 20, 20, 'RIGHT')
    cb1:SetPoint('TOPLEFT', editFrame, 'TOPLEFT', 10, -10)

    local cb3 = AU.ui.Checkbox(editFrame, 'Elements', 20, 20, 'RIGHT')
    cb3:SetPoint('TOPLEFT', cb1, 'BOTTOMLEFT', 0, -5)

    local dropdown = AU.ui.Dropdown(editFrame, 'Select', 100, 20)
    dropdown:SetPoint('LEFT', cb3.label, 'RIGHT', 10, 0)
    dropdown:AddItem('Actionbuttons', function()
        dropdown.text:SetText('Actionbuttons')
        dropdown.selectedValue = 'Actionbuttons'
        dropdown.popup:Hide()
        registry.elements = {}
        for i = 1, 12 do
            RegisterFrame('AuroraMainBarButton'..i, 'elements')
        end
        for i = 1, 12 do
            RegisterFrame('AuroraMultiBar1Button'..i, 'elements')
        end
        for i = 1, 12 do
            RegisterFrame('AuroraMultiBar2Button'..i, 'elements')
        end
        for i = 1, 12 do
            RegisterFrame('AuroraMultiBar3Button'..i, 'elements')
        end
        for i = 1, 12 do
            RegisterFrame('AuroraMultiBar4Button'..i, 'elements')
        end
        for i = 1, 12 do
            RegisterFrame('AuroraMultiBar5Button'..i, 'elements')
        end
        ActivateMode('elements')
    end)
    dropdown:AddItem('Bagbar', function()
        dropdown.text:SetText('Bagbar')
        dropdown.selectedValue = 'Bagbar'
        dropdown.popup:Hide()
        registry.elements = {}
        RegisterFrame('AU_MainBag', 'elements')
        RegisterFrame('AU_Bag0', 'elements')
        RegisterFrame('AU_Bag1', 'elements')
        RegisterFrame('AU_Bag2', 'elements')
        RegisterFrame('AU_Bag3', 'elements')
        RegisterFrame('AU_KeyRing', 'elements')
        RegisterFrame('AU_BagToggle', 'elements')
        ActivateMode('elements')
    end)
    dropdown:AddItem('Minimap Cluster', function()
        dropdown.text:SetText('Minimap Cluster')
        dropdown.selectedValue = 'Minimap Cluster'
        dropdown.popup:Hide()
        registry.elements = {}
        RegisterFrame('AU_GameTimeButton', 'elements')
        RegisterFrame('AU_MinimapZoomIn', 'elements')
        RegisterFrame('AU_MinimapZoomOut', 'elements')
        RegisterFrame('MiniMapTrackingFrame', 'elements')
        RegisterFrame('MiniMapMailFrame', 'elements')
        ActivateMode('elements')
    end)
    dropdown:AddItem('Micro Menu', function()
        dropdown.text:SetText('Micro Menu')
        dropdown.selectedValue = 'Micro Menu'
        dropdown.popup:Hide()
        registry.elements = {}
        RegisterFrame('AU_MicroButton_Character', 'elements')
        RegisterFrame('AU_MicroButton_Spellbook', 'elements')
        RegisterFrame('AU_MicroButton_Talents', 'elements')
        RegisterFrame('AU_MicroButton_QuestLog', 'elements')
        RegisterFrame('AU_MicroButton_Socials', 'elements')
        RegisterFrame('AU_MicroButton_WorldMap', 'elements')
        RegisterFrame('AU_MicroButton_MainMenu', 'elements')
        RegisterFrame('AU_MicroButton_Help', 'elements')
        ActivateMode('elements')
    end)
    dropdown:AddItem('Combopoints', function()
        dropdown.text:SetText('Combopoints')
        dropdown.selectedValue = 'Combopoints'
        dropdown.popup:Hide()
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
            registry.elements = {}
            local frame = getglobal('Aurora'..unit..'Frame')
            if frame then
                if frame.infoBg then frame.infoBg.GetName = function() return 'Aurora'..unit..'Frame.infoBg' end RegisterFrame(frame.infoBg, 'elements') end
                if frame.hpBar then frame.hpBar.GetName = function() return 'Aurora'..unit..'Frame.hpBar' end RegisterFrame(frame.hpBar, 'elements') end
                if frame.powerBar then frame.powerBar.GetName = function() return 'Aurora'..unit..'Frame.powerBar' end RegisterFrame(frame.powerBar, 'elements') end
            end
            ActivateMode('elements')
        end)
    end
    dropdown:Disable()

    cb1:SetScript('OnClick', function() if cb1:GetChecked() then cb3:SetChecked(false) dropdown:Disable() ActivateMode('frames') else ActivateMode(nil) end end)
    cb3:SetScript('OnClick', function() if cb3:GetChecked() then cb1:SetChecked(false) dropdown:Enable() ActivateMode('elements') else ActivateMode(nil) end end)

    cb1:SetChecked(true)

    local exitBtn = AU.ui.Button(editFrame, 'Exit', 100, 30)
    exitBtn:SetPoint('BOTTOMRIGHT', editFrame, 'BOTTOMRIGHT', -5, 5)
    exitBtn:SetScript('OnClick', function() editFrame:Hide() end)

    table.insert(UISpecialFrames, editFrame:GetName())

    -- callbacks
    local helpers = {}
    local callbacks = {}

    AU:NewCallbacks('editmode', callbacks)
end)
