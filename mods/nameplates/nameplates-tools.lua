DRAGONFLIGHT()

local WorldFrame = WorldFrame
local getn = table.getn

local plates = {
    registry = {},
    lastChildCount = 0
}

-- create
function plates:CreateNameplate(frame) -- v2
    local guid = frame:GetName(1) -- SuperWoW: get nameplate GUID

    -- OVERLAY PARENT
    local overlay = CreateFrame('Button', nil, WorldFrame)
    --overlay:SetAllPoints(frame) -- v1: removed - when overlap enabled parent becomes 1x1, overlay shrinks to 1x1 too
    overlay:SetPoint('CENTER', frame, 'CENTER', 0, 3)
    local hbWidth = DF.profile.nameplates.healthbarWidth or 100
    local hbHeight = DF.profile.nameplates.healthbarHeight or 14
    overlay:SetSize(hbWidth, hbHeight)
    overlay:SetFrameStrata('BACKGROUND')
    frame:SetScript('OnShow', function() overlay:Show() end) -- v1: reparented overlay to WorldFrame for overlap feature, now must sync visibility manually
    frame:SetScript('OnHide', function() overlay:Hide() end)
    -- /OVERLAY PARENT
    -- debugframe(overlay)

    -- PLATE CLICKS
    -- pass through method: triggers Blizzard's mouseover glow, using pfuis approach for now
    -- didnt try to find workaround tho.
    frame:EnableMouse(false)
    overlay:EnableMouse(false)
    overlay:SetScript('OnClick', function() frame:Click() end)
    -- /PLATE CLICKS

    -- OVERLAP TOOLTIP
    -- pfui doesnt solve this, but when overlap active, tooltips dont show - we use superwow do fix that via guid
    overlay:SetScript('OnEnter', function()
        if plates.overlapEnabled then
            local currentGuid = frame:GetName(1) -- v2: read guid fresh on hover, nameplates recycle so stored guid becomes stale
            if currentGuid then
                GameTooltip_SetDefaultAnchor(GameTooltip, this)
                GameTooltip:SetUnit(currentGuid)
                local r, g, b = GameTooltip_UnitColor(currentGuid)
                GameTooltipTextLeft1:SetTextColor(r, g, b)
            end
        end
    end)
    overlay:SetScript('OnLeave', function()
        if plates.overlapEnabled then
            GameTooltip:Hide()
        end
    end)
    -- /OVERLAP TOOLTIP

    local healthbar = CreateFrame('StatusBar', nil, overlay)
    healthbar:SetAllPoints(overlay)
    local hbTex = DF.profile.nameplates.healthbarTexture or 'Default'
    local tex = hbTex == 'Dragonflight' and media['tex:unitframes:aurora_hpbar.tga'] or 'Interface\\Buttons\\WHITE8X8'
    healthbar:SetStatusBarTexture(tex)
    healthbar:SetStatusBarColor(0, 1, 0, 1)
    -- healthbar:SetFrameLevel(overlay:GetFrameLevel())

    local healthbarBg = healthbar:CreateTexture(nil, 'BACKGROUND')
    healthbarBg:SetAllPoints(healthbar)
    healthbarBg:SetTexture('Interface\\Buttons\\WHITE8X8')
    healthbarBg:SetVertexColor(0, 0, 0, 0.5)

    local borderLeft = CreateFrame('Frame', nil, healthbar)
    borderLeft:SetFrameLevel(healthbar:GetFrameLevel() -1)
    borderLeft:SetPoint('TOPLEFT', healthbar, 'TOPLEFT', -2, 2)
    borderLeft:SetPoint('BOTTOMRIGHT', healthbar, 'BOTTOM', -30, -2)
    local c = DF.profile.nameplates.borderColor
    local borderLeftTex = DF.ui.CreateSelectiveBorder(borderLeft, {top=true, bottom=true, left=true}, 2, c[1], c[2], c[3], .5)

    local borderRight = CreateFrame('Frame', nil, healthbar)
    borderRight:SetFrameLevel(healthbar:GetFrameLevel() -1)
    borderRight:SetPoint('TOPLEFT', healthbar, 'TOP', 30, 2)
    borderRight:SetPoint('BOTTOMRIGHT', healthbar, 'BOTTOMRIGHT', 2, -2)
    local borderRightTex = DF.ui.CreateSelectiveBorder(borderRight, {top=true, bottom=true, right=true}, 2, c[1], c[2], c[3], .5)

    local nameText = healthbar:CreateFontString(nil, 'OVERLAY')
    nameText:SetFont(media[DF.profile.nameplates.textFont] or 'Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
    local nx = DF.profile.nameplates.nameOffsetX or 0
    local ny = DF.profile.nameplates.nameOffsetY or 2
    nameText:SetPoint('BOTTOM', healthbar, 'TOP', nx, ny)
    nameText:SetText(UnitName(guid) or '')

    local levelBg = overlay:CreateTexture(nil, 'BACKGROUND')
    levelBg:SetTexture(media['tex:generic:solid_small_round.blp'])
    levelBg:SetSize(20, 20)
    levelBg:SetPoint('RIGHT', healthbar, 'LEFT', -5, 0)
    levelBg:SetVertexColor(0, 0, 0, 0.8)

    local levelBorder = overlay:CreateTexture(nil, 'OVERLAY')
    levelBorder:SetTexture(media['tex:generic:generic_round_border_shiny.blp'])
    levelBorder:SetAllPoints(levelBg)
    local lbColor = DF.profile.nameplates.levelBorderColor or {1, 1, 1}
    levelBorder:SetVertexColor(lbColor[1], lbColor[2], lbColor[3], 1)

    local levelText = healthbar:CreateFontString(nil, 'OVERLAY')
    levelText:SetFont(media[DF.profile.nameplates.textFont] or 'Fonts\\FRIZQT__.TTF', 10, 'OUTLINE')
    levelText:SetPoint('CENTER', levelBg, 'CENTER', 0, 0)
    local levelNum = UnitLevel(guid)
    if levelNum and levelNum > 0 then
        levelText:SetText(levelNum)
        if UnitCanAttack('player', guid) then
            local color = GetDifficultyColor(levelNum)
            levelText:SetTextColor(color.r, color.g, color.b)
        else
            levelText:SetTextColor(1, 0.82, 0)
        end
    else
        levelText:SetText('??')
        levelText:SetTextColor(1, 0, 0)
    end

    local hpText = healthbar:CreateFontString(nil, 'OVERLAY')
    local hpSize = DF.profile.nameplates.hpTextSize or 8
    hpText:SetFont(media[DF.profile.nameplates.textFont] or 'Fonts\\FRIZQT__.TTF', hpSize, 'OUTLINE')
    local hpPos = DF.profile.nameplates.hpTextPosition or 'CENTER'
    hpText:SetPoint(hpPos, healthbar, hpPos, 0, 0)
    hpText:SetText('')

    local distBg = overlay:CreateTexture(nil, 'BACKGROUND')
    distBg:SetTexture(media['tex:generic:solid_small_round.blp'])
    distBg:SetSize(20, 20)
    distBg:SetPoint('LEFT', healthbar, 'RIGHT', 5, 0)
    distBg:SetVertexColor(0, 0, 0, 0.8)
    distBg:Hide()

    local distBorder = overlay:CreateTexture(nil, 'OVERLAY')
    distBorder:SetTexture(media['tex:generic:generic_round_border_shiny.blp'])
    distBorder:SetAllPoints(distBg)
    local dbColor = DF.profile.nameplates.distanceBorderColor or {1, 1, 1}
    distBorder:SetVertexColor(dbColor[1], dbColor[2], dbColor[3], 1)
    distBorder:Hide()

    local distText = healthbar:CreateFontString(nil, 'OVERLAY')
    distText:SetFont(media[DF.profile.nameplates.textFont] or 'Fonts\\FRIZQT__.TTF', 8, 'OUTLINE')
    distText:SetPoint('CENTER', distBg, 'CENTER', 0, 0)
    distText:SetText('')
    distText:Hide()

    local targetIndicator = healthbar:CreateTexture(nil, 'OVERLAY')
    local tiTexture = DF.profile.nameplates.targetIndicatorTexture or 'tex:generic:Arrow0.blp'
    targetIndicator:SetTexture(media[tiTexture])
    targetIndicator:SetTexCoord(0, 1, 1, 0)
    local tiScale = DF.profile.nameplates.targetIndicatorScale or 1
    local tiColor = DF.profile.nameplates.targetIndicatorColor or {1, 1, 1}
    targetIndicator:SetSize(20 * tiScale, 20 * tiScale)
    targetIndicator:SetPoint('BOTTOM', healthbar, 'TOP', 0, 50)
    targetIndicator:SetVertexColor(tiColor[1], tiColor[2], tiColor[3], 1)
    targetIndicator:Hide()

    local portrait = overlay:CreateTexture(nil, 'ARTWORK')
    local pScale = DF.profile.nameplates.portraitScale or 1
    portrait:SetSize(20 * pScale, 20 * pScale)
    portrait:SetPoint('BOTTOM', targetIndicator, 'TOP', -0, 5)

    local portraitBorder = overlay:CreateTexture(nil, 'OVERLAY')
    portraitBorder:SetTexture(media['tex:generic:generic_round_border_shiny.blp'])
    portraitBorder:SetPoint('TOPLEFT', portrait, 'TOPLEFT', -1, 1)
    portraitBorder:SetPoint('BOTTOMRIGHT', portrait, 'BOTTOMRIGHT', 1, -1)
    local pbColor = DF.profile.nameplates.portraitBorderColor or {1, 1, 1}
    portraitBorder:SetVertexColor(pbColor[1], pbColor[2], pbColor[3], 1)

    local topGlow = borderLeft:CreateTexture(nil, 'BACKGROUND')
    topGlow:SetTexture(media['tex:generic:nocontrol_glow.blp'])
    topGlow:SetSize(overlay:GetWidth(), 20)
    topGlow:SetPoint('BOTTOM', healthbar, 'TOP', 0, 0)
    local g = DF.profile.nameplates.glowColor
    topGlow:SetVertexColor(g[1], g[2], g[3], .4)
    topGlow:Hide()

    local botGlow = borderLeft:CreateTexture(nil, 'BACKGROUND')
    botGlow:SetTexture(media['tex:generic:nocontrol_glow.blp'])
    botGlow:SetTexCoord(0, 1, 1, 0)
    botGlow:SetSize(overlay:GetWidth(), 20)
    botGlow:SetPoint('TOP', healthbar, 'BOTTOM', 0, 0)
    botGlow:SetVertexColor(g[1], g[2], g[3], .4)
    botGlow:Hide()

    local debuffs = {}
    for i = 1, 16 do
        local btn = CreateFrame('Button', nil, overlay)
        btn:SetSize(14, 14)
        -- debugframe(btn)
        local icon = btn:CreateTexture(nil, 'ARTWORK')
        icon:SetAllPoints(btn)

        local row = math.floor((i - 1) / 5)
        local col = math.mod(i - 1, 5)

        if i == 1 then
            btn:SetPoint('BOTTOMLEFT', healthbar, 'TOPLEFT', 0, 12)
        elseif col == 0 then
            btn:SetPoint('BOTTOMLEFT', debuffs[i - 5], 'TOPLEFT', 0, 2)
        else
            btn:SetPoint('LEFT', debuffs[i - 1], 'RIGHT', 2, 0)
        end

        btn.icon = icon
        btn:Hide()
        debuffs[i] = btn
    end

    -- LEVEL HIDE
    --origLevel:Hide() -- using SetWidth instead - more efficient
    frame.original.level:SetWidth(0.001)
    -- /LEVEL HIDE

    frame.custom = {
        frame = overlay,
        healthbar = healthbar,
        healthbarBg = healthbarBg,
        borderLeft = borderLeft,
        borderLeftTex = borderLeftTex,
        borderRight = borderRight,
        borderRightTex = borderRightTex,
        portrait = portrait,
        portraitBorder = portraitBorder,
        distText = distText,
        distBg = distBg,
        distBorder = distBorder,
        levelBg = levelBg,
        levelBorder = levelBorder,
        targetIndicator = targetIndicator,
        topGlow = topGlow,
        botGlow = botGlow,
        nameText = nameText,
        levelText = levelText,
        hpText = hpText,
        lastValue = -1,
        lastWidth = 0,
        lastGuid = guid,
        debuffs = debuffs,
    }
end

function plates:IsNamePlate(frame)
    if frame:GetObjectType() ~= "Button" then return nil end

    local region = frame:GetRegions()
    if not region then return nil end
    if not region.GetObjectType then return nil end
    if not region.GetTexture then return nil end

    if region:GetObjectType() ~= "Texture" then return nil end
    return region:GetTexture() == "Interface\\Tooltips\\Nameplate-Border" or nil
end

function plates:DisableObject(object)
    if not object then return end
    if not object.GetObjectType then return end

    local otype = object:GetObjectType()

    if otype == 'Texture' then
        object:SetTexture('')
        object:SetTexCoord(0, 0, 0, 0)
    elseif otype == 'FontString' then
        object:SetWidth(0.001)
    elseif otype == 'StatusBar' then
        object:SetStatusBarTexture('')
    end
end

function plates:HideBlizzardElements(frame) -- v2 had to use pfuis approahc due to glow tex coming back with /Hide() when overlap activated
    plates:DisableObject(frame.original.healthbar)
    plates:DisableObject(frame.original.border)
    plates:DisableObject(frame.original.glow)
    plates:DisableObject(frame.original.elite)
    plates:DisableObject(frame.original.raidicon)
    plates:DisableObject(frame.original.name)
    plates:DisableObject(frame.original.level)
end

function plates:ExtractElements(frame)
    local children = { frame:GetChildren() }
    local blizzBar = children[1]
    local regions = { frame:GetRegions() }

    -- find fontstrings
    local nameFontString, levelFontString
    for i = 1, getn(regions) do
        if regions[i]:GetObjectType() == "FontString" then
            if not nameFontString then
                nameFontString = regions[i]
            else
                levelFontString = regions[i]
            end
        end
    end

    -- store original elements
    frame.original = {
        healthbar = blizzBar,
        border = regions[1],
        glow = regions[2],
        elite = regions[5],
        raidicon = regions[6],
        name = nameFontString,
        level = levelFontString
    }

    --debugprint("[EXTRACT] Stored healthbar: "..(frame.original.healthbar and "OK" or "NIL"))
    --debugprint("[EXTRACT] Stored border: "..(frame.original.border and "OK" or "NIL"))
    --debugprint("[EXTRACT] Stored glow: "..(frame.original.glow and "OK" or "NIL"))
    --debugprint("[EXTRACT] Stored elite: "..(frame.original.elite and "OK" or "NIL"))
    --debugprint("[EXTRACT] Stored raidicon: "..(frame.original.raidicon and "OK" or "NIL"))
    --debugprint("[EXTRACT] Stored name: "..(frame.original.name and "OK" or "NIL"))
    --debugprint("[EXTRACT] Stored level: "..(frame.original.level and "OK" or "NIL"))
end

function plates:SetupOnUpdate(frame) -- v1
    local origBar = frame.original.healthbar
    local healthbar = frame.custom.healthbar

    frame.custom.frame:SetScript('OnUpdate', function() -- stupid design double setscrpt, but idk for now, will rewrite anyways
        -- hide friendly NPCs check
        local currentGuid = frame:GetName(1)
        if plates.hideFriendlyNpcs and currentGuid then
            if not UnitIsPlayer(currentGuid) then
                local reaction = UnitReaction('player', currentGuid)
                if reaction and reaction >= 5 then
                    frame:Hide()
                    return
                end
            end
        end
        frame:Show()

        -- overlay parented to WorldFrame for overlap feature, must sync alpha manually
        -- blizzard fades non-targeted nameplates by setting alpha on parent frame
        frame.custom.frame:SetAlpha(frame:GetAlpha())

        -- overlap feature: shrink blizzard frame to 1x1, clicks go to custom overlay
        local clickFrame = plates.overlapEnabled and frame.custom.frame or frame
        local currentWidth = frame:GetWidth()
        if plates.overlapEnabled then
            if currentWidth > 1 and currentWidth ~= frame.custom.lastWidth then
                frame:SetSize(1, 1)
                frame.custom.lastWidth = 1
            end
        else
            if currentWidth ~= frame.custom.lastWidth then
                frame:SetSize(frame.custom.frame:GetWidth(), frame.custom.frame:GetHeight())
                frame.custom.lastWidth = currentWidth
            end
        end

        -- allows clicks
        local enableMouse = not plates.clickThrough
        clickFrame:EnableMouse(enableMouse)

        -- THROTTLE UPDATES
        -- only update custom healthbar when value changes for better performance
        -- without: SetMinMaxValues + SetValue called every frame (~60fps) even if health unchanged
        -- with: only called when health value differs from lastValue (damage/healing events)
        -- saves ~4 function calls per nameplate per frame when health static
        if origBar then
            local value = origBar:GetValue()
            if value ~= frame.custom.lastValue then
                local min, max = origBar:GetMinMaxValues()
                healthbar:SetMinMaxValues(min, max)
                healthbar:SetValue(value)
                frame.custom.hpText:SetText(DF.math.abbreviate(value)..'/'..DF.math.abbreviate(max))
                frame.custom.lastValue = value
            end
        end
        -- /THROTTLE UPDATES

        -- hp text visibility
        if plates.showHpText then
            frame.custom.hpText:Show()
        else
            frame.custom.hpText:Hide()
        end

        -- update name and level when GUID changes
        local currentGuid = frame:GetName(1)
        if currentGuid and currentGuid ~= frame.custom.lastGuid then
            frame.custom.nameText:SetText(UnitName(currentGuid) or '')
            local levelNum = UnitLevel(currentGuid)
            if levelNum and levelNum > 0 then
                frame.custom.levelText:SetText(levelNum)
                if UnitCanAttack('player', currentGuid) then
                    local color = GetDifficultyColor(levelNum)
                    frame.custom.levelText:SetTextColor(color.r, color.g, color.b)
                else
                    frame.custom.levelText:SetTextColor(1, 0.82, 0)
                end
            else
                frame.custom.levelText:SetText('??')
                frame.custom.levelText:SetTextColor(1, 0, 0)
            end
            frame.custom.lastGuid = currentGuid
        end

        -- healthbar color update
        if currentGuid and DF.setups.nameplatesColor then
            DF.setups.nameplatesColor(frame, currentGuid)
        end

        -- distance for all nameplates
        if currentGuid and plates.showDistance then
            local showDist = true
            if plates.showDistanceOnlyTarget then
                if UnitName('target') == UnitName(currentGuid) and UnitExists('target') then
                    local _, targetGuid = UnitExists('target')
                    showDist = (targetGuid == currentGuid)
                else
                    showDist = false
                end
            end

            if showDist then
                local dist = UnitXP('distanceBetween', 'player', currentGuid)
                if dist then
                    frame.custom.distText:SetText(string.format('%.0f', dist))
                    frame.custom.distText:Show()
                    frame.custom.distBg:Show()
                    frame.custom.distBorder:Show()
                else
                    frame.custom.distText:Hide()
                    frame.custom.distBg:Hide()
                    frame.custom.distBorder:Hide()
                end
            else
                frame.custom.distText:Hide()
                frame.custom.distBg:Hide()
                frame.custom.distBorder:Hide()
            end
        else
            frame.custom.distText:Hide()
            frame.custom.distBg:Hide()
            frame.custom.distBorder:Hide()
        end

        -- level visibility
        if currentGuid and plates.showLevel then
            local showLvl = true
            if plates.showLevelOnlyTarget then
                if UnitName('target') == UnitName(currentGuid) and UnitExists('target') then
                    local _, targetGuid = UnitExists('target')
                    showLvl = (targetGuid == currentGuid)
                else
                    showLvl = false
                end
            end
            if showLvl then
                frame.custom.levelText:Show()
                frame.custom.levelBg:Show()
                frame.custom.levelBorder:Show()
            else
                frame.custom.levelText:Hide()
                frame.custom.levelBg:Hide()
                frame.custom.levelBorder:Hide()
            end
        else
            frame.custom.levelText:Hide()
            frame.custom.levelBg:Hide()
            frame.custom.levelBorder:Hide()
        end

        -- name visibility
        if currentGuid and plates.showName then
            local showNm = true
            if plates.showNameOnlyTarget then
                if UnitName('target') == UnitName(currentGuid) and UnitExists('target') then
                    local _, targetGuid = UnitExists('target')
                    showNm = (targetGuid == currentGuid)
                else
                    showNm = false
                end
            end
            if showNm then
                frame.custom.nameText:Show()
            else
                frame.custom.nameText:Hide()
            end
        else
            frame.custom.nameText:Hide()
        end

        -- debuff updates
        if currentGuid and plates.showDebuffs then
            for i = 1, 16 do
                local effect, rank, texture, stacks, dtype, duration, timeleft, caster = DF.lib.libdebuff:UnitDebuff(currentGuid, i)
                if texture then
                    frame.custom.debuffs[i].icon:SetTexture(texture)
                    frame.custom.debuffs[i]:Show()
                else
                    frame.custom.debuffs[i]:Hide()
                end
            end
        else
            for i = 1, 16 do
                frame.custom.debuffs[i]:Hide()
            end
        end

        -- target detection: show portrait and indicator, raise strata
        if UnitName('target') == UnitName(currentGuid) and UnitExists('target') then
            local _, targetGuid = UnitExists('target')
            if targetGuid == currentGuid then
                frame.custom.frame:SetFrameStrata('LOW')

                -- portrait visibility
                if plates.showPortrait then
                    SetPortraitTexture(frame.custom.portrait, 'target')
                    frame.custom.portraitBorder:Show()
                else
                    frame.custom.portrait:SetTexture(nil)
                    frame.custom.portraitBorder:Hide()
                end

                -- target indicator visibility
                if plates.showTargetIndicator then
                    frame.custom.targetIndicator:Show()
                else
                    frame.custom.targetIndicator:Hide()
                end

                -- scale
                if plates.scaleNameplates then
                    frame.custom.frame:SetScale(plates.scaleTargeted or 1)
                else
                    frame.custom.frame:SetScale(1)
                end

                -- glow visibility
                if plates.showGlow then
                    frame.custom.topGlow:Show()
                    frame.custom.botGlow:Show()
                else
                    frame.custom.topGlow:Hide()
                    frame.custom.botGlow:Hide()
                end

                -- border visibility
                if plates.showBorder then
                    local showBrd = true
                    if plates.showBorderOnlyTarget then
                        showBrd = true
                    end
                    if showBrd then
                        for _, tex in pairs(frame.custom.borderLeftTex) do tex:Show() end
                        for _, tex in pairs(frame.custom.borderRightTex) do tex:Show() end
                    else
                        for _, tex in pairs(frame.custom.borderLeftTex) do tex:Hide() end
                        for _, tex in pairs(frame.custom.borderRightTex) do tex:Hide() end
                    end
                else
                    for _, tex in pairs(frame.custom.borderLeftTex) do tex:Hide() end
                    for _, tex in pairs(frame.custom.borderRightTex) do tex:Hide() end
                end
            else
                frame.custom.frame:SetFrameStrata('BACKGROUND')
                frame.custom.portrait:SetTexture(nil)
                frame.custom.portraitBorder:Hide()
                frame.custom.targetIndicator:Hide()
                frame.custom.topGlow:Hide()
                frame.custom.botGlow:Hide()

                -- scale
                if plates.scaleNameplates then
                    frame.custom.frame:SetScale(plates.scaleUntargeted or 1)
                else
                    frame.custom.frame:SetScale(1)
                end

                -- border visibility for non-target
                if plates.showBorder and not plates.showBorderOnlyTarget then
                    for _, tex in pairs(frame.custom.borderLeftTex) do tex:Show() end
                    for _, tex in pairs(frame.custom.borderRightTex) do tex:Show() end
                else
                    for _, tex in pairs(frame.custom.borderLeftTex) do tex:Hide() end
                    for _, tex in pairs(frame.custom.borderRightTex) do tex:Hide() end
                end
            end
        else
            frame.custom.frame:SetFrameStrata('BACKGROUND')
            frame.custom.portrait:SetTexture(nil)
            frame.custom.portraitBorder:Hide()
            frame.custom.targetIndicator:Hide()
            frame.custom.topGlow:Hide()
            frame.custom.botGlow:Hide()

            -- scale
            if plates.scaleNameplates then
                frame.custom.frame:SetScale(plates.scaleUntargeted or 1)
            else
                frame.custom.frame:SetScale(1)
            end

            -- border visibility for non-target
            if plates.showBorder and not plates.showBorderOnlyTarget then
                for _, tex in pairs(frame.custom.borderLeftTex) do tex:Show() end
                for _, tex in pairs(frame.custom.borderRightTex) do tex:Show() end
            else
                for _, tex in pairs(frame.custom.borderLeftTex) do tex:Hide() end
                for _, tex in pairs(frame.custom.borderRightTex) do tex:Hide() end
            end
        end
    end)
end

function plates:ScanNamePlates() -- v1 continuous scan for now, will improve performance later
    local count = WorldFrame:GetNumChildren()

    if count > plates.lastChildCount then
        local children = { WorldFrame:GetChildren() }
        for i = plates.lastChildCount + 1, count do
            local frame = children[i]
            if plates:IsNamePlate(frame) and not plates.registry[frame] then
                plates.registry[frame] = true
                plates:ExtractElements(frame)
                plates:CreateNameplate(frame)
                plates:HideBlizzardElements(frame)
                plates:SetupOnUpdate(frame)
            end
        end
        plates.lastChildCount = count
    end
end

-- expose
DF.setups.plates = plates
