
local f = CreateFrame('Frame')
local timer = 0
local waiting = false

f:RegisterAllEvents()
f:SetScript('OnEvent', function()
    if not string.find(event, 'CHAT') then
        debugprint(GetTime() .. ' - ' .. event)
    end
    if event == 'PLAYER_ENTERING_WORLD' then
        waiting = true
        timer = 0
    end
end)

-- f:SetScript('OnUpdate', function()
--     if waiting then
--         timer = timer + arg1
--         if timer >= 1 then
--             waiting = false
--             debugprint(date('%H:%M:%S') .. ' - AFTER_ENTERING_WORLD')
--         end
--     end
-- end)

-- PlayerModel Availability Check
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

-- Pet Name Availability Check
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



