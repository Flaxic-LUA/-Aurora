-- update world tracker

-- local combat = {active = false, start = 0, log = {}}
-- local playerGUID = nil

-- local frame = CreateFrame('Frame')
-- frame:RegisterEvent('PLAYER_REGEN_DISABLED')
-- frame:RegisterEvent('PLAYER_REGEN_ENABLED')
-- frame:RegisterEvent('UNIT_CASTEVENT')
-- frame:SetScript('OnEvent', function()
--     if event == 'PLAYER_REGEN_DISABLED' then
--         combat.active = true
--         combat.start = GetTime()
--         combat.log = {}
--         playerGUID = nil
--         debugprint('=== COMBAT START ===')

--     elseif event == 'PLAYER_REGEN_ENABLED' then
--         if combat.active then
--             debugprint('=== COMBAT END (duration: ' .. string.format('%.2f', GetTime() - combat.start) .. 's) ===')
--             for i = 1, table.getn(combat.log) do
--                 debugprint(combat.log[i])
--             end
--             combat.active = false
--         end

--     elseif event == 'UNIT_CASTEVENT' and combat.active then
--         local casterGUID, targetGUID, eventType, spellID, duration = arg1, arg2, arg3, arg4, arg5
--         if not playerGUID and UnitName(casterGUID) == UnitName('player') then
--             playerGUID = casterGUID
--         end
--         if casterGUID == playerGUID and targetGUID then
--             local time = string.format('%.3f', GetTime() - combat.start)
--             local targetName = UnitName(targetGUID) or UnitName('target') or targetGUID
--             local spellName = SpellInfo(spellID)

--             if eventType == 'START' then
--                 table.insert(combat.log, time .. 's - Cast ' .. (spellName or spellID) .. ' on ' .. targetName .. ' (' .. duration .. 'ms)')
--             elseif eventType == 'CAST' then
--                 table.insert(combat.log, time .. 's - Hit ' .. (spellName or spellID) .. ' on ' .. targetName)
--             elseif eventType == 'FAIL' then
--                 table.insert(combat.log, time .. 's - FAILED ' .. (spellName or spellID) .. ' on ' .. targetName)
--             elseif eventType == 'CHANNEL' then
--                 table.insert(combat.log, time .. 's - Channel ' .. (spellName or spellID) .. ' on ' .. targetName .. ' (' .. duration .. 'ms)')
--             elseif eventType == 'MAINHAND' then
--                 table.insert(combat.log, time .. 's - Mainhand swing on ' .. targetName)
--             elseif eventType == 'OFFHAND' then
--                 table.insert(combat.log, time .. 's - Offhand swing on ' .. targetName)
--             end
--         end
--     end
-- end)
-------------------------------------------
-- local testFrame = CreateFrame('Frame')
-- testFrame:RegisterEvent('UNIT_AURA')
-- testFrame:SetScript('OnEvent', function()
--     if event == 'UNIT_AURA' and arg1 == 'target' then
--         debugprint('=== Testing UnitDebuff on target ===')
--         for i = 1, 16 do
--             local a, b, c, d, e, f, g, h, j, k = UnitDebuff('target', i)
--             if a then
--                 debugprint('Debuff '..i..': a='..(a or 'nil')..' b='..(b or 'nil')..' c='..(c or 'nil')..' d='..(d or 'nil')..' e='..(e or 'nil')..' f='..(f or 'nil')..' g='..(g or 'nil')..' h='..(h or 'nil')..' j='..(j or 'nil')..' k='..(k or 'nil'))
--             else
--                 break
--             end
--         end
--     end
-- end)


-- local f = CreateFrame('Frame')
-- local timer = 0
-- local waiting = false

-- f:RegisterAllEvents()
-- f:SetScript('OnEvent', function()
--     if not string.find(event, 'CHAT') then
--         debugprint(GetTime() .. ' - ' .. event)
--     end
--     if event == 'PLAYER_ENTERING_WORLD' then
--         waiting = true
--         timer = 0
--     end
-- end)

-- -- f:SetScript('OnUpdate', function()
-- --     if waiting then
-- --         timer = timer + arg1
-- --         if timer >= 1 then
-- --             waiting = false
-- --             debugprint(date('%H:%M:%S') .. ' - AFTER_ENTERING_WORLD')
-- --         end
-- --     end
-- -- end)




-------------------------------------------
-- -- playermodel availability check
-- local testModel = CreateFrame('PlayerModel')
-- local modelReady = false

-- testModel:SetScript('OnUpdate', function()
--     if not modelReady then
--         testModel:SetUnit('player')
--         if testModel:GetModel() then
--             modelReady = true
--             -- debugprint(GetTime() .. ' - PLAYERMODEL_READY')
--             testModel:SetScript('OnUpdate', nil)
--         end
--     end
-- end)
-------------------------------------------
-- -- pet name availability check
-- local petNameReady = false
-- local petChecker = CreateFrame('Frame')

-- petChecker:SetScript('OnUpdate', function()
--     if not petNameReady and UnitExists('pet') then
--         local petName = UnitName('pet')
--         if petName and petName ~= 'Unknown' and petName ~= '' then
--             petNameReady = true
--             debugprint(GetTime() .. ' - PETNAME_READY')
--             petChecker:SetScript('OnUpdate', nil)
--         end
--     end
-- end)



-------------------------------------------
-- dottted lines on uiparent
-- -- 1. CREATE DOTS (in nameplate creation function)
-- local lineDots = {}
-- for i = 1, 50 do
--     local dot = UIParent:CreateTexture(nil, 'OVERLAY')
--     dot:SetTexture('Interface\\Buttons\\WHITE8X8')
--     dot:SetSize(2, 2)
--     dot:SetVertexColor(1, 1, 1, 1)
--     dot:Hide()
--     lineDots[i] = dot
-- end

-- -- 2. HIDE ON NAMEPLATE HIDE
-- overlay:SetScript('OnHide', function()
--     for i = 1, 50 do lineDots[i]:Hide() end
-- end)

-- -- 3. STORE REFERENCE
-- frame.custom.lineDots = lineDots

-- -- 4. UPDATE IN OnUpdate (when target detected)
-- if targetGuid == currentGuid then
--     -- dotted line
--     local npx, npy = frame.custom.frame:GetCenter()
--     if npx and npy then
--         local scale = frame.custom.frame:GetScale()
--         local screenW = GetScreenWidth()
--         local screenH = GetScreenHeight()
--         local ux = screenW / 2
--         local uy = screenH / 2
--         npx = (npx * scale) + 80  -- X offset
--         npy = (npy * scale) + 100 -- Y offset
--         for i = 1, 50 do
--             local t = (i - 1) / 49
--             local px = ux + (npx - ux) * t
--             local py = uy + (npy - uy) * t
--             frame.custom.lineDots[i]:ClearAllPoints()
--             frame.custom.lineDots[i]:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', px, py)
--             frame.custom.lineDots[i]:Show()
--         end
--     end
-- else
--     -- 5. HIDE WHEN NOT TARGETED
--     for i = 1, 50 do frame.custom.lineDots[i]:Hide() end
-- end
