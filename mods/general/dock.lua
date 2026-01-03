DRAGONFLIGHT()

DF:NewDefaults('dock', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'extras', subtab = 'dock', 'General', 'Appearance', 'Combat Glow', 'Resting Glow', 'Widgets'},
    },

    scale = {value = 1.0, metadata = {element = 'slider', category = 'General', indexInCategory = 1, description = 'Dock Scale', min = 0.5, max = 2.0, step = 0.1}},
    centerHeight = {value = 30, metadata = {element = 'slider', category = 'General', indexInCategory = 2, description = 'Center Height', min = 20, max = 60, step = 1}},
    centerWidth = {value = 300, metadata = {element = 'slider', category = 'General', indexInCategory = 3, description = 'Center Width', min = 200, max = 500, step = 10}},
    leftScale = {value = 1.0, metadata = {element = 'slider', category = 'General', indexInCategory = 4, description = 'Left Scale', min = 0.5, max = 2.0, step = 0.1}},
    rightScale = {value = 1.0, metadata = {element = 'slider', category = 'General', indexInCategory = 5, description = 'Right Scale', min = 0.5, max = 2.0, step = 0.1}},
    leftBtnScale = {value = 1.0, metadata = {element = 'slider', category = 'General', indexInCategory = 6, description = 'Left Button Scale', min = 0.5, max = 2.0, step = 0.1}},
    rightBtnScale = {value = 1.0, metadata = {element = 'slider', category = 'General', indexInCategory = 7, description = 'Right Button Scale', min = 0.5, max = 2.0, step = 0.1}},
    font = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'Appearance', indexInCategory = 1, description = 'Font', options = media.fonts}},
    fontSize = {value = 9, metadata = {element = 'slider', category = 'Appearance', indexInCategory = 2, description = 'Font Size', min = 6, max = 16, step = 1}},
    disableMouseoverGlow = {value = false, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 3, description = 'Disable Mouseover Glow'}},
    combatGlow = {value = true, metadata = {element = 'checkbox', category = 'Combat Glow', indexInCategory = 1, description = 'Enable Combat Glow'}},
    combatGlowColor = {value = {1, 0, 0, 1}, metadata = {element = 'colorpicker', category = 'Combat Glow', indexInCategory = 2, description = 'Combat Glow Color', dependency = {key = 'combatGlow', state = true}}},
    combatGlowTop = {value = 'all', metadata = {element = 'dropdown', category = 'Combat Glow', indexInCategory = 3, description = 'Top Glow Pieces', options = {'all', 'left+right', 'left', 'center', 'right'}, dependency = {key = 'combatGlow', state = true}}},
    combatGlowBottom = {value = 'all', metadata = {element = 'dropdown', category = 'Combat Glow', indexInCategory = 4, description = 'Bottom Glow Pieces', options = {'all', 'left+right', 'left', 'center', 'right'}, dependency = {key = 'combatGlow', state = true}}},
    combatGlowAlphaTop = {value = 0.8, metadata = {element = 'slider', category = 'Combat Glow', indexInCategory = 5, description = 'Top Glow Alpha', min = 0.1, max = 1.0, step = 0.1, dependency = {key = 'combatGlow', state = true}}},
    combatGlowAlphaBottom = {value = 0.8, metadata = {element = 'slider', category = 'Combat Glow', indexInCategory = 6, description = 'Bottom Glow Alpha', min = 0.1, max = 1.0, step = 0.1, dependency = {key = 'combatGlow', state = true}}},
    combatGlowPulseSpeed = {value = 1.0, metadata = {element = 'slider', category = 'Combat Glow', indexInCategory = 7, description = 'Pulse Speed', min = 0.5, max = 3.0, step = 0.1, dependency = {key = 'combatGlow', state = true}}},

    restingGlow = {value = true, metadata = {element = 'checkbox', category = 'Resting Glow', indexInCategory = 1, description = 'Enable Resting Glow'}},
    restingGlowColor = {value = {0, 1, 1, 1}, metadata = {element = 'colorpicker', category = 'Resting Glow', indexInCategory = 2, description = 'Resting Glow Color', dependency = {key = 'restingGlow', state = true}}},
    restingGlowTop = {value = 'all', metadata = {element = 'dropdown', category = 'Resting Glow', indexInCategory = 3, description = 'Top Glow Pieces', options = {'all', 'left+right', 'left', 'center', 'right'}, dependency = {key = 'restingGlow', state = true}}},
    restingGlowBottom = {value = 'all', metadata = {element = 'dropdown', category = 'Resting Glow', indexInCategory = 4, description = 'Bottom Glow Pieces', options = {'all', 'left+right', 'left', 'center', 'right'}, dependency = {key = 'restingGlow', state = true}}},
    restingGlowAlphaTop = {value = 0.8, metadata = {element = 'slider', category = 'Resting Glow', indexInCategory = 5, description = 'Top Glow Alpha', min = 0.1, max = 1.0, step = 0.1, dependency = {key = 'restingGlow', state = true}}},
    restingGlowAlphaBottom = {value = 0.8, metadata = {element = 'slider', category = 'Resting Glow', indexInCategory = 6, description = 'Bottom Glow Alpha', min = 0.1, max = 1.0, step = 0.1, dependency = {key = 'restingGlow', state = true}}},
    restingGlowPulseSpeed = {value = 1.0, metadata = {element = 'slider', category = 'Resting Glow', indexInCategory = 7, description = 'Pulse Speed', min = 0.5, max = 3.0, step = 0.1, dependency = {key = 'restingGlow', state = true}}},

    sector1Widget = {value = 'fps', metadata = {element = 'dropdown', category = 'Widgets', indexInCategory = 1, description = 'Sector 1 (top-left)', options = {'none', 'fps', 'exp', 'gold', 'zone', 'friends', 'guild', 'durability', 'ammo', 'bagspace', 'combat'}}},
    sector2Widget = {value = 'exp', metadata = {element = 'dropdown', category = 'Widgets', indexInCategory = 2, description = 'Sector 2 (top-center)', options = {'none', 'fps', 'exp', 'gold', 'zone', 'friends', 'guild', 'durability', 'ammo', 'bagspace', 'combat'}}},
    sector3Widget = {value = 'gold', metadata = {element = 'dropdown', category = 'Widgets', indexInCategory = 3, description = 'Sector 3 (top-right)', options = {'none', 'fps', 'exp', 'gold', 'zone', 'friends', 'guild', 'durability', 'ammo', 'bagspace', 'combat'}}},
    sector4Widget = {value = 'ammo', metadata = {element = 'dropdown', category = 'Widgets', indexInCategory = 4, description = 'Sector 4 (bottom-left)', options = {'none', 'fps', 'exp', 'gold', 'zone', 'friends', 'guild', 'durability', 'ammo', 'bagspace', 'combat'}}},
    sector5Widget = {value = 'bagspace', metadata = {element = 'dropdown', category = 'Widgets', indexInCategory = 5, description = 'Sector 5 (bottom-center)', options = {'none', 'fps', 'exp', 'gold', 'zone', 'friends', 'guild', 'durability', 'ammo', 'bagspace', 'combat'}}},
    sector6Widget = {value = 'durability', metadata = {element = 'dropdown', category = 'Widgets', indexInCategory = 6, description = 'Sector 6 (bottom-right)', options = {'none', 'fps', 'exp', 'gold', 'zone', 'friends', 'guild', 'durability', 'ammo', 'bagspace', 'combat'}}}
})

DF:NewModule('dock', 1, function()
    local mainFrame = CreateFrame('Frame', 'DF_Dock', UIParent)
    mainFrame:SetFrameStrata'BACKGROUND'
    mainFrame:SetSize(300, 30)
    mainFrame:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 8)
    mainFrame:EnableMouse(true)
    local tex = mainFrame:CreateTexture(nil, 'BACKGROUND')
    tex:SetTexture(media['tex:interface:dock_glassy.blp'])
    tex:SetAllPoints(mainFrame)

    local mainGlowTop = mainFrame:CreateTexture(nil, 'ARTWORK')
    mainGlowTop:SetTexture(media['tex:unitframes:barglow.blp'])
    mainGlowTop:SetSize(mainFrame:GetWidth() - 10, 10)
    mainGlowTop:SetPoint('BOTTOM', mainFrame, 'TOP', 0, 0)
    mainGlowTop:SetAlpha(0)

    local mainGlowBottom = mainFrame:CreateTexture(nil, 'ARTWORK')
    mainGlowBottom:SetTexture(media['tex:unitframes:barglow.blp'])
    mainGlowBottom:SetSize(mainFrame:GetWidth() - 10, 10)
    mainGlowBottom:SetPoint('TOP', mainFrame, 'BOTTOM', 0, 0)
    mainGlowBottom:SetTexCoord(0, 1, 1, 0)
    mainGlowBottom:SetAlpha(0)

    local sectorWidth = mainFrame:GetWidth() / 3
    local sectorHeight = mainFrame:GetHeight() / 2
    local sectors = {}
    for i = 1, 3 do
        local topSector = CreateFrame('Frame', nil, mainFrame)
        topSector:SetSize(sectorWidth, sectorHeight)
        topSector:SetPoint('TOPLEFT', mainFrame, 'TOPLEFT', (i - 1) * sectorWidth, 0)
        sectors[i] = topSector
        -- debugframe(topSector)

        local bottomSector = CreateFrame('Frame', nil, mainFrame)
        bottomSector:SetSize(sectorWidth, sectorHeight)
        bottomSector:SetPoint('BOTTOMLEFT', mainFrame, 'BOTTOMLEFT', (i - 1) * sectorWidth, 0)
        sectors[i + 3] = bottomSector
        -- debugframe(bottomSector)
    end

    local leftFrame = CreateFrame('Frame', nil, mainFrame)
    leftFrame:SetSize(90, 20)
    leftFrame:SetPoint('RIGHT', mainFrame, 'LEFT', 3, 0)
    leftFrame:EnableMouse(true)
    local leftTex = leftFrame:CreateTexture(nil, 'BACKGROUND')
    leftTex:SetTexture(media['tex:interface:dock_metal.blp'])
    leftTex:SetAllPoints(leftFrame)

    local leftGlowTop = leftFrame:CreateTexture(nil, 'ARTWORK')
    leftGlowTop:SetTexture(media['tex:unitframes:barglow.blp'])
    leftGlowTop:SetSize(45, 6)
    leftGlowTop:SetPoint('BOTTOMRIGHT', leftFrame, 'TOPRIGHT', 0, -1)
    leftGlowTop:SetAlpha(0)

    local leftGlowBottom = leftFrame:CreateTexture(nil, 'ARTWORK')
    leftGlowBottom:SetTexture(media['tex:unitframes:barglow.blp'])
    leftGlowBottom:SetSize(58, 6)
    leftGlowBottom:SetPoint('TOPRIGHT', leftFrame, 'BOTTOMRIGHT', 0, 1)
    leftGlowBottom:SetTexCoord(0, 1, 1, 0)
    leftGlowBottom:SetAlpha(0)

    local leftBtn = CreateFrame('Button', nil, mainFrame)
    leftBtn:SetSize(25, 25)
    leftBtn:SetPoint('RIGHT', leftFrame, 'CENTER', 5, 0)
    leftBtn:SetFrameLevel(mainFrame:GetFrameLevel() + 1)
    local leftBtnTex = leftBtn:CreateTexture(nil, 'ARTWORK')
    leftBtnTex:SetTexture(media['tex:interface:dock_endcap.blp'])
    leftBtnTex:SetAllPoints(leftBtn)
    local leftBtnHighlight = leftBtn:CreateTexture(nil, 'HIGHLIGHT')
    leftBtnHighlight:SetTexture(media['tex:interface:dock_endcap.blp'])
    leftBtnHighlight:SetAllPoints(leftBtn)
    leftBtnHighlight:SetBlendMode('ADD')

    local rightFrame = CreateFrame('Frame', nil, mainFrame)
    rightFrame:SetSize(90, 20)
    rightFrame:SetPoint('LEFT', mainFrame, 'RIGHT', -3, 0)
    rightFrame:EnableMouse(true)
    local rightTex = rightFrame:CreateTexture(nil, 'BACKGROUND')
    rightTex:SetTexture(media['tex:interface:dock_metal.blp'])
    rightTex:SetAllPoints(rightFrame)
    rightTex:SetTexCoord(1, 0, 0, 1)

    local rightGlowTop = rightFrame:CreateTexture(nil, 'ARTWORK')
    rightGlowTop:SetTexture(media['tex:unitframes:barglow.blp'])
    rightGlowTop:SetSize(45, 6)
    rightGlowTop:SetPoint('BOTTOMLEFT', rightFrame, 'TOPLEFT', 0, -1)
    rightGlowTop:SetAlpha(0)

    local rightGlowBottom = rightFrame:CreateTexture(nil, 'ARTWORK')
    rightGlowBottom:SetTexture(media['tex:unitframes:barglow.blp'])
    rightGlowBottom:SetSize(58, 6)
    rightGlowBottom:SetPoint('TOPLEFT', rightFrame, 'BOTTOMLEFT', 0, 1)
    rightGlowBottom:SetTexCoord(0, 1, 1, 0)
    rightGlowBottom:SetAlpha(0)

    local rightBtn = CreateFrame('Button', nil, mainFrame)
    rightBtn:SetSize(25, 25)
    rightBtn:SetPoint('LEFT', rightFrame, 'CENTER', -5, 0)
    rightBtn:SetFrameLevel(mainFrame:GetFrameLevel() + 1)
    local rightBtnTex = rightBtn:CreateTexture(nil, 'ARTWORK')
    rightBtnTex:SetTexture(media['tex:interface:dock_endcap.blp'])
    rightBtnTex:SetAllPoints(rightBtn)
    rightBtnTex:SetTexCoord(1, 0, 0, 1)
    local rightBtnHighlight = rightBtn:CreateTexture(nil, 'HIGHLIGHT')
    rightBtnHighlight:SetTexture(media['tex:interface:dock_endcap.blp'])
    rightBtnHighlight:SetAllPoints(rightBtn)
    rightBtnHighlight:SetTexCoord(1, 0, 0, 1)
    rightBtnHighlight:SetBlendMode('ADD')

    local glowManager = {
        activeCondition = nil,
        mouseoverBlocked = false,
        mouseoverDisabled = false,
        maxAlpha = 0.8,
        maxAlphaTop = 0.8,
        maxAlphaBottom = 0.8,
        durationTimer = nil,
        combatGlowEnabled = true,
        restingGlowEnabled = true
    }

    local glowConditions = {
        combat = {
            color = {r=1, g=0, b=0},
            mode = 'pulse',
            pulseSpeed = 1,
            duration = 'fullevent',
            blockMouseover = true,
            glows = {mainGlowTop, mainGlowBottom, leftGlowTop, leftGlowBottom, rightGlowTop, rightGlowBottom}
        },
        resting = {
            color = {r=0, g=1, b=0},
            mode = 'pulse',
            pulseSpeed = 1,
            duration = 'fullevent',
            blockMouseover = false,
            glows = {mainGlowTop, mainGlowBottom, leftGlowTop, leftGlowBottom, rightGlowTop, rightGlowBottom}
        }
    }

    local helpers = {}
    local fpsSectors = {}
    local widget = {}

    helpers.ColorNum = function(num, color)
        return '|cff'..color..num..'|r'
    end

    helpers.GetThresholdColor = function(value, low, high, invert)
        if invert then
            if value <= low then return '80ff80' end
            if value >= high then return 'ff8080' end
            return 'ffff80'
        else
            if value >= high then return '80ff80' end
            if value <= low then return 'ff8080' end
            return 'ffff80'
        end
    end

    helpers.SetGlowCondition = function(name, active)
        if active then
            glowManager.activeCondition = name
            local condition = glowConditions[name]
            if type(condition.duration) == 'number' then
                glowManager.durationTimer = condition.duration
            else
                glowManager.durationTimer = nil
            end
        else
            if glowManager.activeCondition == name then
                glowManager.activeCondition = nil
                glowManager.durationTimer = nil
            end
        end
        helpers.UpdateGlowState()
    end

    helpers.UpdateGlowState = function()
        if glowManager.activeCondition then
            local condition = glowConditions[glowManager.activeCondition]
            glowManager.mouseoverBlocked = condition.blockMouseover
            helpers.ApplyGlows(condition.glows, condition.color, true)
        else
            glowManager.mouseoverBlocked = false
            local allGlows = {mainGlowTop, mainGlowBottom, leftGlowTop, leftGlowBottom, rightGlowTop, rightGlowBottom}
            helpers.ApplyGlows(allGlows, {r=1, g=1, b=1}, false)
        end
    end

    helpers.ApplyGlows = function(glowTextures, color, fadeIn)
        for _, glow in pairs(glowTextures) do
            glow:SetVertexColor(color.r, color.g, color.b)
            if fadeIn then
                UIFrameFadeIn(glow, 0.2, glow:GetAlpha(), glowManager.maxAlpha)
            else
                UIFrameFadeOut(glow, 0.2, glow:GetAlpha(), 0)
            end
        end
    end

    helpers.GetGlowPieces = function(topOption, bottomOption)
        local glows = {}
        if topOption == 'all' then
            table.insert(glows, mainGlowTop)
            table.insert(glows, leftGlowTop)
            table.insert(glows, rightGlowTop)
        elseif topOption == 'left+right' then
            table.insert(glows, leftGlowTop)
            table.insert(glows, rightGlowTop)
        elseif topOption == 'left' then
            table.insert(glows, leftGlowTop)
        elseif topOption == 'center' then
            table.insert(glows, mainGlowTop)
        elseif topOption == 'right' then
            table.insert(glows, rightGlowTop)
        end
        if bottomOption == 'all' then
            table.insert(glows, mainGlowBottom)
            table.insert(glows, leftGlowBottom)
            table.insert(glows, rightGlowBottom)
        elseif bottomOption == 'left+right' then
            table.insert(glows, leftGlowBottom)
            table.insert(glows, rightGlowBottom)
        elseif bottomOption == 'left' then
            table.insert(glows, leftGlowBottom)
        elseif bottomOption == 'center' then
            table.insert(glows, mainGlowBottom)
        elseif bottomOption == 'right' then
            table.insert(glows, rightGlowBottom)
        end
        return glows
    end

    helpers.ApplyWidget = function(sector, widgetName, sectorIndex)
        fpsSectors[sectorIndex] = (widgetName == 'fps')
        if widgetName == 'none' then
            if sector.text then sector.text:SetText('') end
        elseif widgetName == 'fps' then widget:FPS(sector)
        elseif widgetName == 'exp' then widget:EXP(sector)
        elseif widgetName == 'gold' then widget:Gold(sector)
        elseif widgetName == 'zone' then widget:Zone(sector)
        elseif widgetName == 'friends' then widget:Friends(sector)
        elseif widgetName == 'guild' then widget:Guild(sector)
        elseif widgetName == 'durability' then widget:Durability(sector)
        elseif widgetName == 'ammo' then widget:Ammo(sector)
        elseif widgetName == 'bagspace' then widget:Bagspace(sector)
        elseif widgetName == 'combat' then widget:Combat(sector)
        end
    end

    function widget:FPS(sector)
        if not sector.text then
            sector.text = sector:CreateFontString(nil, 'OVERLAY')
            sector.text:SetFont(STANDARD_TEXT_FONT, 9)
            sector.text:SetPoint('CENTER', sector, 'CENTER', 0, 0)
        end
        local _, _, latency = GetNetStats()
        local fps = GetFramerate()
        local fpsColor = helpers.GetThresholdColor(fps, 30, 60)
        local msColor = helpers.GetThresholdColor(latency, 100, 300, true)
        sector.text:SetText('FPS: '..helpers.ColorNum(string.format('%.0f', fps), fpsColor)..' / MS: '..helpers.ColorNum(latency, msColor))
    end

    function widget:EXP(sector)
        if not sector.text then
            sector.text = sector:CreateFontString(nil, 'OVERLAY')
            sector.text:SetFont(STANDARD_TEXT_FONT, 9)
            sector.text:SetPoint('CENTER', sector, 'CENTER', 0, 0)
        end
        local level = UnitLevel('player')
        if level == 60 then
            sector.text:SetText('MAX')
        else
            local xp = UnitXP('player')
            local xpMax = UnitXPMax('player')
            local percent = math.floor((xp / xpMax) * 100)
            local xpColor = helpers.GetThresholdColor(percent, 25, 75)
            sector.text:SetText('XP: '..helpers.ColorNum(percent, xpColor)..'%')
        end
    end

    function widget:Gold(sector)
        if not sector.text then
            sector.text = sector:CreateFontString(nil, 'OVERLAY')
            sector.text:SetFont(STANDARD_TEXT_FONT, 9)
            sector.text:SetPoint('CENTER', sector, 'CENTER', 0, 0)
        end
        local money = GetMoney()
        local gold = math.floor(money / 10000)
        local silver = math.floor(math.mod(money / 100, 100))
        local copper = math.mod(money, 100)
        sector.text:SetText(string.format('|cffffd700%dg|r|cffc7c7cf%ds|r|cffeda55f%dc|r', gold, silver, copper))
    end

    function widget:Zone(sector)
        if not sector.text then
            sector.text = sector:CreateFontString(nil, 'OVERLAY')
            sector.text:SetFont(STANDARD_TEXT_FONT, 9)
            sector.text:SetPoint('CENTER', sector, 'CENTER', 0, 0)
        end
        sector.text:SetText(GetMinimapZoneText())
    end

    function widget:Friends(sector)
        if not sector.text then
            sector.text = sector:CreateFontString(nil, 'OVERLAY')
            sector.text:SetFont(STANDARD_TEXT_FONT, 9)
            sector.text:SetPoint('CENTER', sector, 'CENTER', 0, 0)
        end
        local total = GetNumFriends()
        local online = 0
        for i = 1, total do
            local _, _, _, _, connected = GetFriendInfo(i)
            if connected then
                online = online + 1
            end
        end
        sector.text:SetText('F: '..helpers.ColorNum(online, '80ffff')..' / '..total)
    end

    function widget:Guild(sector)
        if not sector.text then
            sector.text = sector:CreateFontString(nil, 'OVERLAY')
            sector.text:SetFont(STANDARD_TEXT_FONT, 9)
            sector.text:SetPoint('CENTER', sector, 'CENTER', 0, 0)
        end
        local guildName = GetGuildInfo('player')
        if guildName then
            local total = GetNumGuildMembers()
            sector.text:SetText('G: '..helpers.ColorNum(total, '80ffff'))
        else
            sector.text:SetText('No Guild')
        end
    end

    function widget:Durability(sector)
        if not sector.text then
            sector.text = sector:CreateFontString(nil, 'OVERLAY')
            sector.text:SetFont(STANDARD_TEXT_FONT, 9)
            sector.text:SetPoint('CENTER', sector, 'CENTER', 0, 0)
        end

        if not sector.scanner then
            sector.scanner = DF.lib.libtipscan:GetScanner('durability')
            sector.slots = {1, 3, 5, 6, 7, 8, 9, 10, 16, 17, 18}
            sector.pattern = string.gsub(DURABILITY_TEMPLATE, '%%[^%s]+', '(.+)')
        end

        local lowestPercent = 100
        for _, slot in pairs(sector.slots) do
            local hasItem = sector.scanner:SetInventoryItem('player', slot)
            if hasItem then
                local _, cur, max = sector.scanner:FindText(sector.pattern)
                if cur and max then
                    local percent = math.floor((tonumber(cur) / tonumber(max)) * 100)
                    if percent < lowestPercent then
                        lowestPercent = percent
                    end
                end
            end
        end

        local durColor = helpers.GetThresholdColor(lowestPercent, 25, 50)
        sector.text:SetText('DUR: '..helpers.ColorNum(lowestPercent, durColor)..'%')
    end

    function widget:Ammo(sector)
        if not sector.text then
            sector.text = sector:CreateFontString(nil, 'OVERLAY')
            sector.text:SetFont(STANDARD_TEXT_FONT, 9)
            sector.text:SetPoint('CENTER', sector, 'CENTER', 0, 0)
        end
        if GetInventoryItemQuality('player', 0) then
            local count = GetInventoryItemCount('player', 0)
            local ammoColor = helpers.GetThresholdColor(count, 50, 100)
            sector.text:SetText('AMMO: '..helpers.ColorNum(count, ammoColor))
        else
            sector.text:SetText('AMMO: -')
        end
    end

    function widget:Bagspace(sector)
        if not sector.text then
            sector.text = sector:CreateFontString(nil, 'OVERLAY')
            sector.text:SetFont(STANDARD_TEXT_FONT, 9)
            sector.text:SetPoint('CENTER', sector, 'CENTER', 0, 0)
        end
        local maxSlots = 0
        local usedSlots = 0
        for bag = 0, 4 do
            local bagSize = GetContainerNumSlots(bag)
            maxSlots = maxSlots + bagSize
            for slot = 1, bagSize do
                if GetContainerItemLink(bag, slot) then
                    usedSlots = usedSlots + 1
                end
            end
        end
        local freeSlots = maxSlots - usedSlots
        local freePercent = (freeSlots / maxSlots) * 100
        local bagColor = helpers.GetThresholdColor(freePercent, 20, 50)
        sector.text:SetText('BAG: '..helpers.ColorNum(freeSlots, bagColor)..' / '..maxSlots)
    end

    function widget:Combat(sector)
        if not sector.text then
            sector.text = sector:CreateFontString(nil, 'OVERLAY')
            sector.text:SetFont(STANDARD_TEXT_FONT, 9)
            sector.text:SetPoint('CENTER', sector, 'CENTER', 0, 0)
        end
        if UnitAffectingCombat('player') then
            sector.text:SetText('|cffff0000IN COMBAT|r')
        else
            sector.text:SetText('Out of Combat')
        end
    end

    local pulseFrame = CreateFrame'Frame'
    pulseFrame.elapsed = 0
    pulseFrame:SetScript('OnUpdate', function()
        if glowManager.durationTimer then
            glowManager.durationTimer = glowManager.durationTimer - arg1
            if glowManager.durationTimer <= 0 then
                helpers.SetGlowCondition(glowManager.activeCondition, false)
                return
            end
        end

        if not glowManager.activeCondition then return end

        local condition = glowConditions[glowManager.activeCondition]
        if condition.mode ~= 'pulse' then return end

        this.elapsed = this.elapsed + arg1
        local cycle = this.elapsed / condition.pulseSpeed
        local alpha = (math.sin(cycle * 3.14159 * 2) + 1) / 2

        for _, glow in pairs(condition.glows) do
            if glow == mainGlowTop or glow == leftGlowTop or glow == rightGlowTop then
                glow:SetAlpha(alpha * glowManager.maxAlphaTop)
            else
                glow:SetAlpha(alpha * glowManager.maxAlphaBottom)
            end
        end
    end)

    mainFrame:SetScript('OnEnter', function()
        if not glowManager.mouseoverBlocked and not glowManager.mouseoverDisabled then
            UIFrameFadeIn(mainGlowTop, 0.2, 0, glowManager.maxAlpha)
            UIFrameFadeIn(mainGlowBottom, 0.2, 0, glowManager.maxAlpha)
        end
    end)
    mainFrame:SetScript('OnLeave', function()
        if not glowManager.mouseoverBlocked and not glowManager.mouseoverDisabled then
            UIFrameFadeOut(mainGlowTop, 0.2, glowManager.maxAlpha, 0)
            UIFrameFadeOut(mainGlowBottom, 0.2, glowManager.maxAlpha, 0)
        end
    end)
    leftFrame:SetScript('OnEnter', function()
        if not glowManager.mouseoverBlocked and not glowManager.mouseoverDisabled then
            UIFrameFadeIn(leftGlowTop, 0.2, 0, glowManager.maxAlpha)
            UIFrameFadeIn(leftGlowBottom, 0.2, 0, glowManager.maxAlpha)
        end
    end)
    leftFrame:SetScript('OnLeave', function()
        if not glowManager.mouseoverBlocked and not glowManager.mouseoverDisabled then
            UIFrameFadeOut(leftGlowTop, 0.2, glowManager.maxAlpha, 0)
            UIFrameFadeOut(leftGlowBottom, 0.2, glowManager.maxAlpha, 0)
        end
    end)
    rightFrame:SetScript('OnEnter', function()
        if not glowManager.mouseoverBlocked and not glowManager.mouseoverDisabled then
            UIFrameFadeIn(rightGlowTop, 0.2, 0, glowManager.maxAlpha)
            UIFrameFadeIn(rightGlowBottom, 0.2, 0, glowManager.maxAlpha)
        end
    end)
    rightFrame:SetScript('OnLeave', function()
        if not glowManager.mouseoverBlocked and not glowManager.mouseoverDisabled then
            UIFrameFadeOut(rightGlowTop, 0.2, glowManager.maxAlpha, 0)
            UIFrameFadeOut(rightGlowBottom, 0.2, glowManager.maxAlpha, 0)
        end
    end)

    local elapsed = 0
    local updateFrame = CreateFrame'Frame'
    updateFrame:SetScript('OnUpdate', function()
        elapsed = elapsed + arg1
        if elapsed >= 0.5 then
            for i = 1, 6 do
                if fpsSectors[i] then
                    widget:FPS(sectors[i])
                end
            end
            elapsed = 0
        end
    end)

    local eventFrame = CreateFrame'Frame'
    eventFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
    eventFrame:RegisterEvent('PLAYER_XP_UPDATE')
    eventFrame:RegisterEvent('PLAYER_MONEY')
    eventFrame:RegisterEvent('FRIENDLIST_UPDATE')
    eventFrame:RegisterEvent('GUILD_ROSTER_UPDATE')
    eventFrame:RegisterEvent('PLAYER_GUILD_UPDATE')
    eventFrame:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
    eventFrame:RegisterEvent('UNIT_INVENTORY_CHANGED')
    eventFrame:RegisterEvent('BAG_UPDATE')
    eventFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
    eventFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
    eventFrame:RegisterEvent('PLAYER_UPDATE_RESTING')
    eventFrame:SetScript('OnEvent', function()
        if event == 'PLAYER_ENTERING_WORLD' or event == 'PLAYER_XP_UPDATE' then
            widget:EXP(sectors[2])
        end
        if event == 'PLAYER_ENTERING_WORLD' or event == 'PLAYER_MONEY' then
            widget:Gold(sectors[3])
        end
        if event == 'PLAYER_ENTERING_WORLD' or event == 'FRIENDLIST_UPDATE' then
            -- widget:Friends(sectors[4])
        end
        if event == 'PLAYER_ENTERING_WORLD' or event == 'GUILD_ROSTER_UPDATE' or event == 'PLAYER_GUILD_UPDATE' then
            -- widget:Guild(sectors[5])
        end
        if event == 'PLAYER_ENTERING_WORLD' or event == 'UPDATE_INVENTORY_DURABILITY' or (event == 'UNIT_INVENTORY_CHANGED' and arg1 == 'player') then
            widget:Durability(sectors[6])
        end
        if event == 'PLAYER_ENTERING_WORLD' or (event == 'UNIT_INVENTORY_CHANGED' and arg1 == 'player') or event == 'BAG_UPDATE' then
            widget:Ammo(sectors[4])
        end
        if event == 'PLAYER_ENTERING_WORLD' or event == 'BAG_UPDATE' then
            widget:Bagspace(sectors[5])
        end
        if event == 'PLAYER_REGEN_DISABLED' then
            if glowManager.combatGlowEnabled then
                helpers.SetGlowCondition('combat', true)
            end
        elseif event == 'PLAYER_REGEN_ENABLED' then
            if glowManager.combatGlowEnabled then
                helpers.SetGlowCondition('combat', false)
            end
        elseif event == 'PLAYER_UPDATE_RESTING' or event == 'PLAYER_ENTERING_WORLD' then
            if glowManager.restingGlowEnabled then
                helpers.SetGlowCondition('resting', IsResting())
            end
        end
    end)

    local glowTopOption = 'all'
    local glowBottomOption = 'all'
    local restingGlowTopOption = 'all'
    local restingGlowBottomOption = 'all'

    local callbacks = {}

    callbacks.scale = function(value) mainFrame:SetScale(value) end
    callbacks.centerHeight = function(value)
        mainFrame:SetSize(mainFrame:GetWidth(), value)
        local sectorHeight = value / 2
        for i = 1, 3 do
            sectors[i]:SetSize(sectors[i]:GetWidth(), sectorHeight)
            sectors[i + 3]:SetSize(sectors[i + 3]:GetWidth(), sectorHeight)
        end
    end
    callbacks.centerWidth = function(value)
        mainFrame:SetSize(value, mainFrame:GetHeight())
        mainGlowTop:SetSize(value - 10, mainGlowTop:GetHeight())
        mainGlowBottom:SetSize(value - 10, mainGlowBottom:GetHeight())
        local sectorWidth = value / 3
        for i = 1, 3 do
            sectors[i]:SetSize(sectorWidth, sectors[i]:GetHeight())
            sectors[i]:SetPoint('TOPLEFT', mainFrame, 'TOPLEFT', (i - 1) * sectorWidth, 0)
            sectors[i + 3]:SetSize(sectorWidth, sectors[i + 3]:GetHeight())
            sectors[i + 3]:SetPoint('BOTTOMLEFT', mainFrame, 'BOTTOMLEFT', (i - 1) * sectorWidth, 0)
        end
    end
    callbacks.leftScale = function(value) leftFrame:SetScale(value) end
    callbacks.rightScale = function(value) rightFrame:SetScale(value) end
    callbacks.leftBtnScale = function(value) leftBtn:SetScale(value) end
    callbacks.rightBtnScale = function(value) rightBtn:SetScale(value) end
    callbacks.font = function(value)
        local fontPath = media[value]
        for i = 1, 6 do
            if sectors[i].text then
                local _, size = sectors[i].text:GetFont()
                sectors[i].text:SetFont(fontPath, size or 9)
            end
        end
    end
    callbacks.fontSize = function(value)
        for i = 1, 6 do
            if sectors[i].text then
                local font = sectors[i].text:GetFont()
                sectors[i].text:SetFont(font, value)
            end
        end
    end
    callbacks.disableMouseoverGlow = function(value)
        glowManager.mouseoverDisabled = value
    end
    callbacks.combatGlow = function(value)
        glowManager.combatGlowEnabled = value
        if not value and glowManager.activeCondition == 'combat' then
            helpers.SetGlowCondition('combat', false)
        elseif value and UnitAffectingCombat('player') then
            helpers.SetGlowCondition('combat', true)
        end
    end
    callbacks.combatGlowColor = function(value)
        glowConditions.combat.color = {r=value[1], g=value[2], b=value[3]}
        if glowManager.activeCondition == 'combat' then helpers.UpdateGlowState() end
    end
    callbacks.combatGlowTop = function(value)
        glowTopOption = value
        glowConditions.combat.glows = helpers.GetGlowPieces(glowTopOption, glowBottomOption)
        if glowManager.activeCondition == 'combat' then helpers.UpdateGlowState() end
    end
    callbacks.combatGlowBottom = function(value)
        glowBottomOption = value
        glowConditions.combat.glows = helpers.GetGlowPieces(glowTopOption, glowBottomOption)
        if glowManager.activeCondition == 'combat' then helpers.UpdateGlowState() end
    end
    callbacks.combatGlowAlphaTop = function(value)
        glowManager.maxAlphaTop = value
    end
    callbacks.combatGlowAlphaBottom = function(value)
        glowManager.maxAlphaBottom = value
    end
    callbacks.combatGlowPulseSpeed = function(value)
        glowConditions.combat.pulseSpeed = value
    end
    callbacks.restingGlow = function(value)
        glowManager.restingGlowEnabled = value
        if not value and glowManager.activeCondition == 'resting' then
            helpers.SetGlowCondition('resting', false)
        elseif value and IsResting() then
            helpers.SetGlowCondition('resting', true)
        end
    end
    callbacks.restingGlowColor = function(value)
        glowConditions.resting.color = {r=value[1], g=value[2], b=value[3]}
        if glowManager.activeCondition == 'resting' then helpers.UpdateGlowState() end
    end
    callbacks.restingGlowTop = function(value)
        restingGlowTopOption = value
        glowConditions.resting.glows = helpers.GetGlowPieces(restingGlowTopOption, restingGlowBottomOption)
        if glowManager.activeCondition == 'resting' then helpers.UpdateGlowState() end
    end
    callbacks.restingGlowBottom = function(value)
        restingGlowBottomOption = value
        glowConditions.resting.glows = helpers.GetGlowPieces(restingGlowTopOption, restingGlowBottomOption)
        if glowManager.activeCondition == 'resting' then helpers.UpdateGlowState() end
    end
    callbacks.restingGlowAlphaTop = function(value)
        glowManager.maxAlphaTop = value
    end
    callbacks.restingGlowAlphaBottom = function(value)
        glowManager.maxAlphaBottom = value
    end
    callbacks.restingGlowPulseSpeed = function(value)
        glowConditions.resting.pulseSpeed = value
    end
    callbacks.sector1Widget = function(value) helpers.ApplyWidget(sectors[1], value, 1) end
    callbacks.sector2Widget = function(value) helpers.ApplyWidget(sectors[2], value, 2) end
    callbacks.sector3Widget = function(value) helpers.ApplyWidget(sectors[3], value, 3) end
    callbacks.sector4Widget = function(value) helpers.ApplyWidget(sectors[4], value, 4) end
    callbacks.sector5Widget = function(value) helpers.ApplyWidget(sectors[5], value, 5) end
    callbacks.sector6Widget = function(value) helpers.ApplyWidget(sectors[6], value, 6) end

    DF:NewCallbacks('dock', callbacks)
end)
