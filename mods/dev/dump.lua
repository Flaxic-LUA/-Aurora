-- combat logger tracking casts and swings with timestamps
--[[
    local combat = {active = false, start = 0, log = {}}
    local playerGUID = nil

    local frame = CreateFrame('Frame')
    frame:RegisterEvent('PLAYER_REGEN_DISABLED')
    frame:RegisterEvent('PLAYER_REGEN_ENABLED')
    frame:RegisterEvent('UNIT_CASTEVENT')
    frame:SetScript('OnEvent', function()
        if event == 'PLAYER_REGEN_DISABLED' then
            combat.active = true
            combat.start = GetTime()
            combat.log = {}
            playerGUID = nil
            debugprint('=== COMBAT START ===')

        elseif event == 'PLAYER_REGEN_ENABLED' then
            if combat.active then
                debugprint('=== COMBAT END (duration: ' .. string.format('%.2f', GetTime() - combat.start) .. 's) ===')
                for i = 1, table.getn(combat.log) do
                    debugprint(combat.log[i])
                end
                combat.active = false
            end

        elseif event == 'UNIT_CASTEVENT' and combat.active then
            local casterGUID, targetGUID, eventType, spellID, duration = arg1, arg2, arg3, arg4, arg5
            if not playerGUID and UnitName(casterGUID) == UnitName('player') then
                playerGUID = casterGUID
            end
            if casterGUID == playerGUID and targetGUID then
                local time = string.format('%.3f', GetTime() - combat.start)
                local targetName = UnitName(targetGUID) or UnitName('target') or targetGUID
                local spellName = SpellInfo(spellID)

                if eventType == 'START' then
                    table.insert(combat.log, time .. 's - Cast ' .. (spellName or spellID) .. ' on ' .. targetName .. ' (' .. duration .. 'ms)')
                elseif eventType == 'CAST' then
                    table.insert(combat.log, time .. 's - Hit ' .. (spellName or spellID) .. ' on ' .. targetName)
                elseif eventType == 'FAIL' then
                    table.insert(combat.log, time .. 's - FAILED ' .. (spellName or spellID) .. ' on ' .. targetName)
                elseif eventType == 'CHANNEL' then
                    table.insert(combat.log, time .. 's - Channel ' .. (spellName or spellID) .. ' on ' .. targetName .. ' (' .. duration .. 'ms)')
                elseif eventType == 'MAINHAND' then
                    table.insert(combat.log, time .. 's - Mainhand swing on ' .. targetName)
                elseif eventType == 'OFFHAND' then
                    table.insert(combat.log, time .. 's - Offhand swing on ' .. targetName)
                end
            end
        end
    end)
--]]

-- playermodel readiness detector using onupdate polling
    --[[
    local testModel = CreateFrame('PlayerModel')
    local modelReady = false

    testModel:SetScript('OnUpdate', function()
        if not modelReady then
            testModel:SetUnit('player')
            if testModel:GetModel() then
                modelReady = true
                -- debugprint(GetTime() .. ' - PLAYERMODEL_READY')
                testModel:SetScript('OnUpdate', nil)
            end
        end
    end)
--]]

-- pet name readiness checker polling until valid name appears
--[[
    local petNameReady = false
    local petChecker = CreateFrame('Frame')

    petChecker:SetScript('OnUpdate', function()
        if not petNameReady and UnitExists('pet') then
            local petName = UnitName('pet')
            if petName and petName ~= 'Unknown' and petName ~= '' then
                petNameReady = true
                debugprint(GetTime() .. ' - PETNAME_READY')
                petChecker:SetScript('OnUpdate', nil)
            end
        end
    end)
--]]

-- dotted line renderer from screen center to nameplate target
--[[
    -- 1. CREATE DOTS (in nameplate creation function)
    local lineDots = {}
    for i = 1, 50 do
        local dot = UIParent:CreateTexture(nil, 'OVERLAY')
        dot:SetTexture('Interface\\Buttons\\WHITE8X8')
        dot:SetSize(2, 2)
        dot:SetVertexColor(1, 1, 1, 1)
        dot:Hide()
        lineDots[i] = dot
    end

    -- 2. HIDE ON NAMEPLATE HIDE
    overlay:SetScript('OnHide', function()
        for i = 1, 50 do lineDots[i]:Hide() end
    end)

    -- 3. STORE REFERENCE
    frame.custom.lineDots = lineDots

    -- 4. UPDATE IN OnUpdate (when target detected)
    if targetGuid == currentGuid then
        -- dotted line
        local npx, npy = frame.custom.frame:GetCenter()
        if npx and npy then
            local scale = frame.custom.frame:GetScale()
            local screenW = GetScreenWidth()
            local screenH = GetScreenHeight()
            local ux = screenW / 2
            local uy = screenH / 2
            npx = (npx * scale) + 80  -- X offset
            npy = (npy * scale) + 100 -- Y offset
            for i = 1, 50 do
                local t = (i - 1) / 49
                local px = ux + (npx - ux) * t
                local py = uy + (npy - uy) * t
                frame.custom.lineDots[i]:ClearAllPoints()
                frame.custom.lineDots[i]:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', px, py)
                frame.custom.lineDots[i]:Show()
            end
        end
    else
        -- 5. HIDE WHEN NOT TARGETED
        for i = 1, 50 do frame.custom.lineDots[i]:Hide() end
    end
--]]
