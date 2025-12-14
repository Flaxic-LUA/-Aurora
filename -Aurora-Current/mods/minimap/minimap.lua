UNLOCKAURORA()

AU:NewDefaults('minimap', {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {
        {tab = 'minimap', subtab = 'minimap', 'General', 'Border', 'Animation', 'Arrow', 'Display', 'Zoom'},
        {tab = 'minimap', subtab = 'toppanel', 'Panel', 'Zone', 'Time'},
    },

    showMinimap = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Show or hide the minimap'}},
    minimapSize = {value = 105, metadata = {element = 'slider', category = 'General', indexInCategory = 2, description = 'Size of the minimap', min = 140, max = 350, stepSize = 5, dependency = {key = 'showMinimap', state = true}}},
    mapSquare = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 3, description = 'Use square minimap shape', dependency = {key = 'showMinimap', state = true}}},
    mapAlpha = {value = 1, metadata = {element = 'slider', category = 'General', indexInCategory = 4, description = 'Transparency of the minimap', min = 0, max = 1, stepSize = 0.05, dependency = {key = 'showMinimap', state = true}}},
    showPing = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 5, description = 'Show name of the pinging player on minimap', dependency = {key = 'showMinimap', state = true}}},
    printPing = {value = false, metadata = {element = 'checkbox', category = 'General', indexInCategory = 6, description = 'Print ping player name to chat', dependency = {key = 'showPing', state = true}}},
    minimapBorder = {value = 'tex:minimap:uiminimapborder.tga', metadata = {element = 'dropdown', category = 'Border', indexInCategory = 1, description = 'Border texture for minimap', options = {'tex:minimap:uiminimapborder.tga', 'tex:minimap:map_dragonflight_square2.tga'}, dependency = {key = 'showMinimap', state = true}}},
    minimapShadow = {value = 'Inside', metadata = {element = 'dropdown', category = 'Border', indexInCategory = 2, description = 'Shadow style for minimap', options = {'None', 'Inside', 'Outside', 'Both'}, dependency = {key = 'showMinimap', state = true}}},
    alphaShadow = {value = 0.5, metadata = {element = 'slider', category = 'Border', indexInCategory = 3, description = 'Transparency of the shadow', min = 0, max = 1, stepSize = 0.05, dependency = {key = 'showMinimap', state = true}}},
    minimapAnimation = {value = true, metadata = {element = 'checkbox', category = 'Animation', indexInCategory = 1, description = 'Enable minimap animations', dependency = {key = 'showMinimap', state = true}}},
    animationTexture = {value = 'Aura1', metadata = {element = 'dropdown', category = 'Animation', indexInCategory = 2, description = 'Animation texture style', options = {'Aura1', 'Aura2', 'Aura3', 'Aura4', 'Glow1', 'Glow2', 'Shock1', 'Shock2', 'Shock3'}, dependency = {key = 'minimapAnimation', state = true}}},
    animationSpeed = {value = 0.1, metadata = {element = 'slider', category = 'Animation', indexInCategory = 3, description = 'Animation speed', min = -5, max = 5, stepSize = 0.1, dependency = {key = 'minimapAnimation', state = true}}},
    animationSize = {value = 190, metadata = {element = 'slider', category = 'Animation', indexInCategory = 4, description = 'Animation size', min = 100, max = 300, stepSize = 5, dependency = {key = 'minimapAnimation', state = true}}},
    animationAlpha = {value = .5, metadata = {element = 'slider', category = 'Animation', indexInCategory = 5, description = 'Animation transparency', min = 0, max = 1, stepSize = 0.05, dependency = {key = 'minimapAnimation', state = true}}},
    animationStrata = {value = 'BACKGROUND', metadata = {element = 'dropdown', category = 'Animation', indexInCategory = 6, description = 'Animation layer', options = {'BACKGROUND', 'LOW', 'MEDIUM', 'HIGH'}, dependency = {key = 'minimapAnimation', state = true}}},
    animationColor = {value = {1, .82, 0}, metadata = {element = 'colorpicker', category = 'Animation', indexInCategory = 7, description = 'Animation color tint', dependency = {key = 'minimapAnimation', state = true}}},
    minimapAnimation2 = {value = true, metadata = {element = 'checkbox', category = 'Animation', indexInCategory = 8, description = 'Enable second animation layer', dependency = {key = 'showMinimap', state = true}}},
    animationTexture2 = {value = 'Aura4', metadata = {element = 'dropdown', category = 'Animation', indexInCategory = 9, description = 'Animation 2 texture style', options = {'Aura1', 'Aura2', 'Aura3', 'Aura4', 'Glow1', 'Glow2', 'Shock1', 'Shock2', 'Shock3'}, dependency = {key = 'minimapAnimation2', state = true}}},
    animationSpeed2 = {value = -0.1, metadata = {element = 'slider', category = 'Animation', indexInCategory = 10, description = 'Animation 2 speed', min = -5, max = 5, stepSize = 0.1, dependency = {key = 'minimapAnimation2', state = true}}},
    animationSize2 = {value = 250, metadata = {element = 'slider', category = 'Animation', indexInCategory = 11, description = 'Animation 2 size', min = 100, max = 300, stepSize = 5, dependency = {key = 'minimapAnimation2', state = true}}},
    animationAlpha2 = {value = .3, metadata = {element = 'slider', category = 'Animation', indexInCategory = 12, description = 'Animation 2 transparency', min = 0, max = 1, stepSize = 0.05, dependency = {key = 'minimapAnimation2', state = true}}},
    animationStrata2 = {value = 'BACKGROUND', metadata = {element = 'dropdown', category = 'Animation', indexInCategory = 13, description = 'Animation 2 layer', options = {'BACKGROUND', 'LOW', 'MEDIUM', 'HIGH'}, dependency = {key = 'minimapAnimation2', state = true}}},
    animationColor2 = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Animation', indexInCategory = 14, description = 'Animation 2 color tint', dependency = {key = 'minimapAnimation2', state = true}}},
    customPlayerArrow = {value = true, metadata = {element = 'checkbox', category = 'Arrow', indexInCategory = 1, description = 'Use Dragonflight\'s custom player arrow', dependency = {key = 'showMinimap', state = true}}},
    playerArrowTexture = {value = 'Arrow1', metadata = {element = 'dropdown', category = 'Arrow', indexInCategory = 2, description = 'Arrow texture style', options = {'Arrow1', 'Arrow2', 'Arrow3'}, dependency = {key = 'customPlayerArrow', state = true}}},
    playerArrowScale = {value = 1, metadata = {element = 'slider', category = 'Arrow', indexInCategory = 3, description = 'Size of the player arrow', min = 0.5, max = 2, stepSize = 0.1, dependency = {key = 'showMinimap', state = true}}},
    playerArrowColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Arrow', indexInCategory = 4, description = 'Color of the player arrow', dependency = {key = 'customPlayerArrow', state = true}}},
    mapColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'General', indexInCategory = 7, description = 'Color tint of the map', dependency = {key = 'showMinimap', state = true}}},
    showSunMoon = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 8, description = 'Show sun/moon indicator', dependency = {key = 'showMinimap', state = true}}},
    gameTimeSize = {value = 25, metadata = {element = 'slider', category = 'General', indexInCategory = 9, description = 'Size of sun/moon button', min = 16, max = 48, stepSize = 1, dependency = {key = 'showSunMoon', state = true}}},
    mailSize = {value = 32, metadata = {element = 'slider', category = 'General', indexInCategory = 10, description = 'Size of mail icon', min = 16, max = 48, stepSize = 1, dependency = {key = 'showMinimap', state = true}}},
    showZoom = {value = true, metadata = {element = 'checkbox', category = 'Zoom', indexInCategory = 1, description = 'Show zoom buttons', dependency = {key = 'showMinimap', state = true}}},
    zoomSize = {value = 15, metadata = {element = 'slider', category = 'Zoom', indexInCategory = 2, description = 'Size of zoom buttons', min = 20, max = 50, stepSize = 1, dependency = {key = 'showZoom', state = true}}},
    zoomTextures = {value = 'Default', metadata = {element = 'dropdown', category = 'Zoom', indexInCategory = 3, description = 'Zoom button textures', options = {'Default'}, dependency = {key = 'showZoom', state = true}}},
    alphaZoom = {value = 1, metadata = {element = 'slider', category = 'Zoom', indexInCategory = 4, description = 'Transparency of zoom buttons', min = 0, max = 1, stepSize = 0.05, dependency = {key = 'showZoom', state = true}}},
    mouseWheelZoom = {value = true, metadata = {element = 'checkbox', category = 'Zoom', indexInCategory = 5, description = 'Enable mouse wheel zoom', dependency = {key = 'showMinimap', state = true}}},
    zoomX = {value = 0, metadata = {element = 'slider', category = 'Zoom', indexInCategory = 6, description = 'Horizontal position offset', min = -100, max = 100, stepSize = 1, dependency = {key = 'showZoom', state = true}}},
    zoomY = {value = 0, metadata = {element = 'slider', category = 'Zoom', indexInCategory = 7, description = 'Vertical position offset', min = -100, max = 100, stepSize = 1, dependency = {key = 'showZoom', state = true}}},
    showTopPanel = {value = false, metadata = {element = 'checkbox', category = 'Panel', indexInCategory = 1, description = 'Show top panel', dependency = {key = 'showMinimap', state = true}}},
    topPanelTexture = {value = 'tex:generic:backdrop_rounded.blp', metadata = {element = 'dropdown', category = 'Panel', indexInCategory = 2, description = 'Top panel texture', options = {'tex:generic:backdrop_rounded.blp'}, dependency = {key = 'showTopPanel', state = true}}},
    topPanelWidth = {value = 170, metadata = {element = 'slider', category = 'Panel', indexInCategory = 3, description = 'Width of top panel', min = 100, max = 300, stepSize = 5, dependency = {key = 'showTopPanel', state = true}}},
    topPanelHeight = {value = 20, metadata = {element = 'slider', category = 'Panel', indexInCategory = 4, description = 'Height of top panel', min = 15, max = 40, stepSize = 1, dependency = {key = 'showTopPanel', state = true}}},
    zoneTextSize = {value = 11, metadata = {element = 'slider', category = 'Zone', indexInCategory = 1, description = 'Font size of zone text', min = 8, max = 20, stepSize = 1, dependency = {key = 'showTopPanel', state = true}}},
    zoneTextColour = {value = {1, 0.82, 0}, metadata = {element = 'colorpicker', category = 'Zone', indexInCategory = 2, description = 'Color of zone text', dependency = {key = 'showTopPanel', state = true}}},
    zoneTextAnchor = {value = 'LEFT', metadata = {element = 'dropdown', category = 'Zone', indexInCategory = 3, description = 'Text alignment for zone', options = {'LEFT', 'CENTER', 'RIGHT'}, dependency = {key = 'showTopPanel', state = true}}},
    zoneTextFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'Zone', indexInCategory = 4, description = 'Font for zone text', options = media.fonts, dependency = {key = 'showTopPanel', state = true}}},
    showTime = {value = true, metadata = {element = 'checkbox', category = 'Time', indexInCategory = 1, description = 'Show time on top panel', dependency = {key = 'showTopPanel', state = true}}},
    timeColour = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'time', indexInCategory = 2, description = 'Color of time text', dependency = {key = 'showTime', state = true}}},
    timeSize = {value = 11, metadata = {element = 'slider', category = 'time', indexInCategory = 3, description = 'Font size of time text', min = 8, max = 20, stepSize = 1, dependency = {key = 'showTime', state = true}}},
    timeAnchor = {value = 'RIGHT', metadata = {element = 'dropdown', category = 'time', indexInCategory = 4, description = 'Text alignment for time', options = {'LEFT', 'CENTER', 'RIGHT'}, dependency = {key = 'showTime', state = true}}},
    timeFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'time', indexInCategory = 5, description = 'Font for time text', options = media.fonts, dependency = {key = 'showTime', state = true}}},
    timeFormat = {value = '24h', metadata = {element = 'dropdown', category = 'time', indexInCategory = 6, description = 'Time format', options = {'24h', '12h'}, dependency = {key = 'showTime', state = true}}},
    showSeconds = {value = false, metadata = {element = 'checkbox', category = 'time', indexInCategory = 7, description = 'Show seconds in time', dependency = {key = 'showTime', state = true}}},
    amPmColor = {value = {0.5, 0.5, 0.5}, metadata = {element = 'colorpicker', category = 'time', indexInCategory = 8, description = 'Color of AM/PM text', dependency = {key = 'timeFormat', state = '12h'}}},
})

AU:NewModule('minimap', 1, 'PLAYER_LOGIN', function()
    local cluster, border, shadow, topPanel, timeText, zoneText, zoomIn, zoomOut = AU.lib.CreateMinimapUI()
    cluster:SetFrameStrata('LOW')
    -- cluster:SetFrameStrata('BACKGROUND')

    AU.lib.CreateButtonSkinner()

    local gameTimeButton, gameTimeBorder, gameTimeIcon = AU.lib.CreateGameTimeButton(cluster)
    gameTimeButton:SetPoint('TOPRIGHT', Minimap, 'BOTTOMLEFT', 15, 15)

    local pingFrame
    local pingText
    local pingTimerId
    local rotatingFrames = {}
    local playerArrow

    local animTextures = {
        ['Aura1'] = 'SPELLS\\AURARUNE256.BLP',
        ['Aura2'] = 'SPELLS\\AuraRune256b.blp',
        ['Aura3'] = 'SPELLS\\AuraRune_A.blp',
        ['Aura4'] = 'SPELLS\\AuraRune_B.blp',
        ['Glow1'] = 'PARTICLES\\GENERICGLOW5.BLP',
        ['Glow2'] = 'SPELLS\\GENERICGLOW64.BLP',
        ['Shock1'] = 'SPELLS\\Shockwave4.blp',
        ['Shock2'] = 'World\\ENVIRONMENT\\DOODAD\\GENERALDOODADS\\ELEMENTALRIFTS\\Shockwave_blue.blp',
        ['Shock3'] = 'SPELLS\\SHOCKWAVE_INVERTGREY.BLP',
    }

    --callbacks

    local helpers = {
        CalculateTexOffset = function(size)
            local minSize, maxSize = 140, 350
            local minOffset, maxOffset = 10, 26
            local offset = minOffset + (size - minSize) * (maxOffset - minOffset) / (maxSize - minSize)
            return offset
        end,

        CreateRotatingTexture = function(layer, textureName, speed, size, alpha, strata, colorArray)
            local texPath = animTextures[textureName]
            if not texPath then return end

            local frame = CreateFrame('Frame', nil, Minimap)
            frame:SetPoint('CENTER', Minimap, 'CENTER')
            frame:SetWidth(size)
            frame:SetHeight(size)
            frame:SetFrameStrata(strata)

            local tex = frame:CreateTexture(nil, 'OVERLAY')
            tex:SetTexture(texPath)
            tex:SetAllPoints(frame)
            tex:SetBlendMode('ADD')
            tex:SetVertexColor(colorArray[1], colorArray[2], colorArray[3])
            tex:SetAlpha(alpha)
            tex.angle = 0

            frame.texture = tex

            local function OnUpdate()
                tex.angle = (tex.angle or 0) + speed
                if tex.angle > 360 then tex.angle = tex.angle - 360 end
                local s = math.sin(math.rad(tex.angle))
                local c = math.cos(math.rad(tex.angle))
                tex:SetTexCoord(
                    0.5 - s, 0.5 + c,
                    0.5 + c, 0.5 + s,
                    0.5 - c, 0.5 - s,
                    0.5 + s, 0.5 - c
                )
            end

            frame:SetScript('OnUpdate', OnUpdate)
            rotatingFrames[layer] = frame
        end,

        DestroyRotatingTexture = function(layer)
            if rotatingFrames[layer] then
                rotatingFrames[layer]:SetScript('OnUpdate', nil)
                rotatingFrames[layer]:Hide()
                rotatingFrames[layer] = nil
            end
        end,

        FindPlayerArrow = function()
            for k, v in pairs({Minimap:GetChildren()}) do
                if v:IsObjectType('Model') and not v:GetName() then
                    local model = v:GetModel()
                    if model and string.find(string.lower(model), 'interface\\minimap\\minimaparrow') then
                        return v
                    end
                end
            end
            return nil
        end
    }

    playerArrow = helpers.FindPlayerArrow()
    customArrowFrame, customArrowTex, originalArrow = AU.lib.CreateCustomPlayerArrow()
    local callbacks = {}

    callbacks.showMinimap = function(value)
        if value then
            cluster:Show()
        else
            cluster:Hide()
        end
    end

    callbacks.minimapSize = function(value)
        Minimap:SetHeight(value)
        Minimap:SetWidth(value)

        local offset = helpers.CalculateTexOffset(value)
        border:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -offset, offset)
        border:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', offset, -offset)

        shadow:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -offset, offset)
        shadow:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', offset, -offset)
    end

    callbacks.mapSquare = function(value)
        if value then
            border:SetTexture(media['tex:minimap:map_dragonflight_square2.tga'])
            shadow:SetTexture(media['tex:minimap:map_dragonflight_square_shadow.tga'])
            Minimap:SetMaskTexture('Interface\\BUTTONS\\WHITE8X8')
        else
            border:SetTexture(media['tex:minimap:uiminimapborder.tga'])
            shadow:SetTexture(media['tex:minimap:uiminimapshadow.tga'])
            Minimap:SetMaskTexture('Textures\\MinimapMask')
        end
    end

    callbacks.mapAlpha = function(value)
        Minimap:SetAlpha(value)
    end

    callbacks.mapColor = function(value)
        border:SetVertexColor(value[1], value[2], value[3])
        zoomIn:GetNormalTexture():SetVertexColor(value[1], value[2], value[3])
        zoomOut:GetNormalTexture():SetVertexColor(value[1], value[2], value[3])
        gameTimeBorder:SetVertexColor(value[1], value[2], value[3])
    end

    callbacks.showPing = function(value)
        if value then
            if not pingFrame then
                pingFrame = CreateFrame('Frame', nil, Minimap)
                pingFrame:SetFrameStrata('TOOLTIP')
                pingText = pingFrame:CreateFontString(nil, 'OVERLAY')
                pingText:SetFont('Fonts\\FRIZQT__.TTF', 14, 'OUTLINE')
                pingText:SetTextColor(1, 1, 0)
                pingText:Hide()

                pingFrame:SetScript('OnEvent', function()
                    if arg1 and arg2 and arg3 then
                        local name = UnitName(arg1)
                        if name then
                            if pingTimerId then
                                AU.timers.cancel(pingTimerId)
                            end

                            pingText:SetText(name)
                            pingText:SetPoint('CENTER', Minimap, 'CENTER', arg2 * Minimap:GetWidth(), arg3 * Minimap:GetHeight())
                            pingText:SetAlpha(1)
                            pingText:Show()

                            pingTimerId = AU.timers.delay(3, function()
                                pingText:Hide()
                                pingTimerId = nil
                            end)

                            if AU.profile.minimap.printPing then
                                print(name .. " pinged the minimap")
                            end
                        end
                    end
                end)
            end
            pingFrame:RegisterEvent('MINIMAP_PING')
        else
            if pingFrame then
                pingFrame:UnregisterEvent('MINIMAP_PING')
                if pingText then
                    pingText:Hide()
                end
            end
        end
    end

    callbacks.printPing = function()
        -- handled within showPing callback
    end

    callbacks.minimapBorder = function(value)
        if value == 'tex:minimap:uiminimapborder.tga' then
            border:SetTexture(media['tex:minimap:uiminimapborder.tga'])
        elseif value == 'tex:minimap:map_dragonflight_square2.tga' then
            print('Dragonflight square border not fully implemented yet')
            border:SetTexture(media['tex:minimap:map_dragonflight_square2.tga'])
        end
    end

    callbacks.minimapShadow = function(value)
        if value == 'None' then
            shadow:Hide()
        elseif value == 'Inside' then
            shadow:Show()
        elseif value == 'Outside' then
            print('Outside shadow not implemented yet')
            shadow:Hide()
        elseif value == 'Both' then
            print('Both shadows not implemented yet')
            shadow:Show()
        end
    end

    callbacks.alphaShadow = function(value)
        shadow:SetAlpha(value)
    end

    local function CreateAnimationCallbacks(layer)
        local suffix = layer == 1 and '' or tostring(layer)

        callbacks['minimapAnimation'..suffix] = function(value)
            if rotatingFrames[layer] then
                if value then
                    rotatingFrames[layer]:Show()
                else
                    rotatingFrames[layer]:Hide()
                end
            end
        end

        callbacks['animationTexture'..suffix] = function(value)
            helpers.DestroyRotatingTexture(layer)
            local db = AU.profile.minimap
            helpers.CreateRotatingTexture(layer, value, db['animationSpeed'..suffix], db['animationSize'..suffix], db['animationAlpha'..suffix], db['animationStrata'..suffix], db['animationColor'..suffix])
            if not db['minimapAnimation'..suffix] then
                rotatingFrames[layer]:Hide()
            end
        end

        callbacks['animationSize'..suffix] = function(value)
            if rotatingFrames[layer] then
                rotatingFrames[layer]:SetWidth(value)
                rotatingFrames[layer]:SetHeight(value)
            end
        end

        callbacks['animationAlpha'..suffix] = function(value)
            if rotatingFrames[layer] and rotatingFrames[layer].texture then
                rotatingFrames[layer].texture:SetAlpha(value)
            end
        end

        callbacks['animationStrata'..suffix] = function(value)
            if rotatingFrames[layer] then
                rotatingFrames[layer]:SetFrameStrata(value)
            end
        end

        callbacks['animationSpeed'..suffix] = function(value)
            if rotatingFrames[layer] and rotatingFrames[layer].texture then
                local tex = rotatingFrames[layer].texture
                local function OnUpdate()
                    tex.angle = (tex.angle or 0) + value
                    if tex.angle > 360 then tex.angle = tex.angle - 360 end
                    local s = math.sin(math.rad(tex.angle))
                    local c = math.cos(math.rad(tex.angle))
                    tex:SetTexCoord(
                        0.5 - s, 0.5 + c,
                        0.5 + c, 0.5 + s,
                        0.5 - c, 0.5 - s,
                        0.5 + s, 0.5 - c
                    )
                end
                rotatingFrames[layer]:SetScript('OnUpdate', OnUpdate)
            end
        end

        callbacks['animationColor'..suffix] = function(value)
            if rotatingFrames[layer] and rotatingFrames[layer].texture then
                rotatingFrames[layer].texture:SetVertexColor(value[1], value[2], value[3])
            end
        end
    end

    CreateAnimationCallbacks(1)
    CreateAnimationCallbacks(2)

    callbacks.showSunMoon = function(value)
        if value then
            gameTimeButton:Show()
        else
            gameTimeButton:Hide()
        end
    end

    callbacks.gameTimeSize = function(value)
        gameTimeButton:SetSize(value, value)
        gameTimeBorder:SetSize(value, value)
        gameTimeIcon:SetSize(value, value)
    end

    callbacks.mailSize = function(value)
        MiniMapMailFrame:SetSize(value, value)
    end

    callbacks.customPlayerArrow = function(value)
        if value then
            local db = AU.profile.minimap
            if customArrowTex then
                customArrowTex:SetVertexColor(db.playerArrowColor[1], db.playerArrowColor[2], db.playerArrowColor[3])
            end
            if customArrowFrame then
                customArrowFrame:SetScale(db.playerArrowScale)
                customArrowFrame:SetFrameStrata(Minimap:GetFrameStrata())
                customArrowFrame:Show()
            end
            if originalArrow then
                originalArrow:Hide()
            end
        else
            if customArrowFrame then
                customArrowFrame:Hide()
            end
            if originalArrow then
                originalArrow:Show()
            end
        end
    end

    callbacks.playerArrowScale = function(value)
        if customArrowFrame then
            customArrowFrame:SetScale(value)
        elseif playerArrow then
            playerArrow:SetScale(value)
        end
    end

    callbacks.playerArrowColor = function(value)
        if customArrowTex then
            customArrowTex:SetVertexColor(value[1], value[2], value[3])
        end
    end

    callbacks.playerArrowTexture = function(value)
        -- print('Arrow texture changed to: ' .. value)
    end

    callbacks.showZoom = function(value)
        if value then
            zoomIn:Show()
            zoomOut:Show()
        else
            zoomIn:Hide()
            zoomOut:Hide()
        end
    end

    callbacks.zoomSize = function(value)
        zoomIn:SetWidth(value)
        zoomIn:SetHeight(value)
        zoomOut:SetWidth(value)
        zoomOut:SetHeight(value)
    end

    callbacks.zoomTextures = function(value)
        -- print('Zoom texture changed to: ' .. value)
    end

    callbacks.alphaZoom = function(value)
        zoomIn:SetAlpha(value)
        zoomOut:SetAlpha(value)
    end

    callbacks.mouseWheelZoom = function(value)
        if value then
            Minimap:EnableMouseWheel(true)
            Minimap:SetScript('OnMouseWheel', function()
                if arg1 > 0 then
                    zoomIn:Click()
                elseif arg1 < 0 then
                    zoomOut:Click()
                end
            end)
        else
            Minimap:EnableMouseWheel(false)
            Minimap:SetScript('OnMouseWheel', nil)
        end
    end

    callbacks.showTopPanel = function(value)
        if value then
            topPanel:Show()
        else
            topPanel:Hide()
        end
    end

    callbacks.topPanelTexture = function(value)
        -- print('Top panel texture changed to: ' .. value)
    end

    callbacks.topPanelWidth = function(value)
        topPanel:SetWidth(value)
    end

    callbacks.topPanelHeight = function(value)
        topPanel:SetHeight(value)
    end

    callbacks.zoneTextSize = function(value)
        local font = zoneText:GetFont()
        zoneText:SetFont(font, value, 'OUTLINE')
    end

    callbacks.zoneTextColour = function(value)
        zoneText:SetTextColor(value[1], value[2], value[3])
    end

    callbacks.zoneTextAnchor = function(value)
        zoneText:ClearAllPoints()
        zoneText:SetPoint(value, topPanel, value, value == 'LEFT' and 11 or (value == 'RIGHT' and -11 or 0), 0)
    end

    callbacks.zoneTextFont = function(value)
        local _, size = zoneText:GetFont()
        zoneText:SetFont(media[value], size, 'OUTLINE')
    end

    callbacks.showTime = function(value)
        if value then
            timeText:Show()
        else
            timeText:Hide()
        end
    end

    callbacks.timeColour = function(value)
        timeText:SetTextColor(value[1], value[2], value[3])
    end

    callbacks.timeSize = function(value)
        local font = timeText:GetFont()
        timeText:SetFont(font, value, 'OUTLINE')
    end

    callbacks.timeAnchor = function(value)
        timeText:ClearAllPoints()
        timeText:SetPoint(value, topPanel, value, value == 'LEFT' and 11 or (value == 'RIGHT' and -11 or 0), 0)
    end

    callbacks.timeFont = function(value)
        local _, size = timeText:GetFont()
        timeText:SetFont(media[value], size, 'OUTLINE')
    end

    callbacks.timeFormat = function(value)
        AU.date.timeFormat = value
    end

    callbacks.showSeconds = function(value)
        AU.date.showSeconds = value
    end

    callbacks.amPmColor = function(value)
        AU.date.amPmColor = value
    end

    AU:NewCallbacks('minimap', callbacks)
end)
