UNLOCKDRAGONFLIGHT()

-- credit to shagu v1.0
local scanner = {}
local libtipscan = {}

local SET_METHODS = {
    'SetBagItem', 'SetAction', 'SetAuctionItem', 'SetAuctionSellItem', 'SetBuybackItem',
    'SetCraftItem', 'SetCraftSpell', 'SetHyperlink', 'SetInboxItem', 'SetInventoryItem',
    'SetLootItem', 'SetLootRollItem', 'SetMerchantItem', 'SetPetAction', 'SetPlayerBuff',
    'SetQuestItem', 'SetQuestLogItem', 'SetQuestRewardSpell', 'SetSendMailItem', 'SetShapeshift',
    'SetSpell', 'SetTalent', 'SetTrackingSpell', 'SetTradePlayerItem', 'SetTradeSkillItem', 'SetTradeTargetItem',
    'SetTrainerService', 'SetUnit', 'SetUnitBuff', 'SetUnitDebuff'
}

function scanner:GetText()
    local name = self:GetName()
    local result = {}
    for i = 1, self:NumLines() do
        local leftName = name .. 'TextLeft' .. i
        local rightName = name .. 'TextRight' .. i
        local left = _G[leftName]
        local right = _G[rightName]
        local leftText = left and left:IsVisible() and left:GetText()
        local rightText = right and right:IsVisible() and right:GetText()
        leftText = not DF.data.isEmpty(leftText) and leftText or nil
        rightText = not DF.data.isEmpty(rightText) and rightText or nil
        if leftText or rightText then
            result[i] = {leftText, rightText}
        end
    end
    return result
end

function scanner:FindText(pattern, exact)
    local name = self:GetName()
    for i = 1, self:NumLines() do
        local leftName = name .. 'TextLeft' .. i
        local rightName = name .. 'TextRight' .. i
        local left = _G[leftName]
        local right = _G[rightName]
        local leftText = left and left:IsVisible() and left:GetText()
        local rightText = right and right:IsVisible() and right:GetText()

        if exact then
            if (leftText and leftText == pattern) or (rightText and rightText == pattern) then
                return i, pattern
            end
        else
            if leftText then
                local found, _, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10 = string.find(leftText, pattern)
                if found then
                    return i, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10
                end
            end
            if rightText then
                local found, _, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10 = string.find(rightText, pattern)
                if found then
                    return i, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10
                end
            end
        end
    end
end

function scanner:GetLine(lineNum)
    local name = self:GetName()
    if lineNum <= self:NumLines() then
        local leftName = name .. 'TextLeft' .. lineNum
        local rightName = name .. 'TextRight' .. lineNum
        local left = _G[leftName]
        local right = _G[rightName]
        local leftText = left and left:IsVisible() and left:GetText()
        local rightText = right and right:IsVisible() and right:GetText()
        if leftText or rightText then
            return leftText, rightText
        end
    end
end

function scanner:FindColor(r, g, b)
    local name = self:GetName()
    if type(r) == 'table' then
        r, g, b = r.r or r[1], r.g or r[2], r.b or r[3]
    end
    for i = 1, self:NumLines() do
        local leftName = name .. 'TextLeft' .. i
        local rightName = name .. 'TextRight' .. i
        local left = _G[leftName]
        local right = _G[rightName]

        if left and left:IsVisible() then
            local lr, lg, lb = left:GetTextColor()
            lr, lg, lb = DF.math.round(lr, 1), DF.math.round(lg, 1), DF.math.round(lb, 1)
            if lr == r and lg == g and lb == b then
                return i
            end
        end

        if right and right:IsVisible() then
            local rr, rg, rb = right:GetTextColor()
            rr, rg, rb = DF.math.round(rr, 1), DF.math.round(rg, 1), DF.math.round(rb, 1)
            if rr == r and rg == g and rb == b then
                return i
            end
        end
    end
end

libtipscan.registry = setmetatable({}, {
    __index = function(t, name)
        local tooltip = CreateFrame('GameTooltip', 'AUScan' .. name, nil, 'GameTooltipTemplate')
        tooltip:SetOwner(WorldFrame, 'ANCHOR_NONE')
        tooltip:SetScript('OnHide', function()
            this:SetOwner(WorldFrame, 'ANCHOR_NONE')
        end)

        for key, method in pairs(scanner) do
            tooltip[key] = method
        end

        for _, methodName in ipairs(SET_METHODS) do
            local original = tooltip[methodName]
            tooltip[methodName] = function(self, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
                self:ClearLines()
                self:SetOwner(WorldFrame, 'ANCHOR_NONE')
                return original(self, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
            end
        end

        rawset(t, name, tooltip)
        return tooltip
    end
})

function libtipscan:GetScanner(name)
    local tooltip = self.registry[name]
    tooltip:ClearLines()
    return tooltip
end

function libtipscan:List()
    for name, _ in pairs(self.registry) do
        print(name)
    end
end

DF.lib.libtipscan = libtipscan

-- local testFrame = CreateFrame('Frame')
-- testFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
-- testFrame:SetScript('OnEvent', function()
--     debugprint('=== Testing libtipscan ===')

--     local scanner = DF.lib.libtipscan:GetScanner('test')

--     debugprint('Test 1: Scanning first spell')
--     scanner:SetSpell(1, 'spell')
--     local lines = scanner:GetText()
--     debugprint('Total lines: ' .. table.getn(lines))
--     for i = 1, table.getn(lines) do
--         if lines[i] then
--             debugprint('Line ' .. i .. ': ' .. (lines[i][1] or 'nil') .. ' | ' .. (lines[i][2] or 'nil'))
--         end
--     end
--     debugprint('Test 2: Finding cast time')
--     scanner:SetSpell(1, 'spell')
--     local lineNum, castTime = scanner:FindText('(%d+%.%d+) sec')
--     if lineNum then
--         debugprint('Found cast time on line ' .. lineNum .. ': ' .. castTime .. ' sec')
--     else
--         debugprint('No cast time found (instant spell)')
--     end

--     debugprint('Test 3: Getting line 1')
--     scanner:SetSpell(1, 'spell')
--     local left, right = scanner:GetLine(1)
--     debugprint('Line 1 left: ' .. (left or 'nil'))
--     debugprint('Line 1 right: ' .. (right or 'nil'))

--     debugprint('Test 4: Exact text match')
--     scanner:SetSpell(1, 'spell')
--     local exactLine = scanner:FindText(left, true)
--     if exactLine then
--         debugprint('Found exact match on line: ' .. exactLine)
--     else
--         debugprint('No exact match found')
--     end

--     debugprint('Test 5: Listing active scanners')
--     DF.lib.libtipscan:List()

--     debugprint('=== libtipscan tests complete ===')
-- end)
