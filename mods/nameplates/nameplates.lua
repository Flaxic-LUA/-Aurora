UNLOCKDRAGONFLIGHT()
if not dependency('UnitXP') then return end

DF:NewDefaults('nameplates', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'nameplates', 'Layout & Size', 'Appearance', 'Text & Widgets', 'Target Highlight', 'Portrait', 'Debuffs', 'Healthbar Colors'},
    },
    healthbarTexture = {value = 'Dragonflight', metadata = {element = 'dropdown', category = 'Appearance', indexInCategory = 1, description = 'Healthbar texture', options = {'Default', 'Dragonflight'}}},
    clickThrough = {value = false, metadata = {element = 'checkbox', category = 'Appearance', indexInCategory = 2, description = 'Click through nameplates (disable mouse)'}},
    overlapNameplates = {value = false, metadata = {element = 'checkbox', category = 'Layout & Size', indexInCategory = 1, description = 'Stack nameplates on top of each other (removes collision)'}},
    healthbarWidth = {value = 100, metadata = {element = 'slider', category = 'Layout & Size', indexInCategory = 2, description = 'Healthbar width', min = 50, max = 200, stepSize = 1}},
    healthbarHeight = {value = 18, metadata = {element = 'slider', category = 'Layout & Size', indexInCategory = 3, description = 'Healthbar height', min = 5, max = 30, stepSize = 1}},
    scaleNameplates = {value = true, metadata = {element = 'checkbox', category = 'Layout & Size', indexInCategory = 4, description = 'Scale nameplates based on target'}},
    scaleTargeted = {value = 1.2, metadata = {element = 'slider', category = 'Layout & Size', indexInCategory = 5, description = 'Scale for targeted nameplate', min = 0.5, max = 2, stepSize = 0.1, dependency = {key = 'scaleNameplates', state = true}}},
    scaleUntargeted = {value = 0.8, metadata = {element = 'slider', category = 'Layout & Size', indexInCategory = 6, description = 'Scale for untargeted nameplates', min = 0.5, max = 2, stepSize = 0.1, dependency = {key = 'scaleNameplates', state = true}}},
    textFont = {value = 'font:Expressway.ttf', metadata = {element = 'dropdown', category = 'Text & Widgets', indexInCategory = 1, description = 'Font for nameplate text', options = media.fonts}},
    showName = {value = true, metadata = {element = 'checkbox', category = 'Text & Widgets', indexInCategory = 2, description = 'Show name text'}},
    showNameOnlyTarget = {value = true, metadata = {element = 'checkbox', category = 'Text & Widgets', indexInCategory = 3, description = 'Show name only for targeted unit', dependency = {key = 'showName', state = true}}},
    nameOffsetX = {value = 0, metadata = {element = 'slider', category = 'Text & Widgets', indexInCategory = 4, description = 'Name horizontal offset', min = -50, max = 50, stepSize = 1}},
    nameOffsetY = {value = 2, metadata = {element = 'slider', category = 'Text & Widgets', indexInCategory = 5, description = 'Name vertical offset', min = -50, max = 50, stepSize = 1}},
    showLevel = {value = true, metadata = {element = 'checkbox', category = 'Text & Widgets', indexInCategory = 6, description = 'Show level indicator'}},
    showLevelOnlyTarget = {value = false, metadata = {element = 'checkbox', category = 'Text & Widgets', indexInCategory = 7, description = 'Show level only for targeted unit', dependency = {key = 'showLevel', state = true}}},
    levelBorderColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Text & Widgets', indexInCategory = 8, description = 'Level border color'}},
    showDistance = {value = true, metadata = {element = 'checkbox', category = 'Text & Widgets', indexInCategory = 9, description = 'Show distance indicator'}},
    showDistanceOnlyTarget = {value = true, metadata = {element = 'checkbox', category = 'Text & Widgets', indexInCategory = 10, description = 'Show distance only for targeted unit', dependency = {key = 'showDistance', state = true}}},
    distanceBorderColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Text & Widgets', indexInCategory = 11, description = 'Distance border color'}},
    hpTextPosition = {value = 'CENTER', metadata = {element = 'dropdown', category = 'Text & Widgets', indexInCategory = 12, description = 'HP text position', options = {'LEFT', 'CENTER', 'RIGHT'}}},
    showHpText = {value = true, metadata = {element = 'checkbox', category = 'Text & Widgets', indexInCategory = 13, description = 'Show HP text on healthbar'}},
    hpTextSize = {value = 14, metadata = {element = 'slider', category = 'Text & Widgets', indexInCategory = 14, description = 'HP text font size', min = 5, max = 25, stepSize = 1}},
    showGlow = {value = false, metadata = {element = 'checkbox', category = 'Target Highlight', indexInCategory = 1, description = 'Show target glow'}},
    glowColor = {value = {0.4, 0.8, 0.9}, metadata = {element = 'colorpicker', category = 'Target Highlight', indexInCategory = 2, description = 'Target glow color', dependency = {key = 'showGlow', state = true}}},
    showBorder = {value = true, metadata = {element = 'checkbox', category = 'Target Highlight', indexInCategory = 3, description = 'Show healthbar border'}},
    showBorderOnlyTarget = {value = false, metadata = {element = 'checkbox', category = 'Target Highlight', indexInCategory = 4, description = 'Show border only for targeted unit', dependency = {key = 'showBorder', state = true}}},
    borderColor = {value = {0.4, 0.8, 0.9}, metadata = {element = 'colorpicker', category = 'Target Highlight', indexInCategory = 5, description = 'Healthbar border color', dependency = {key = 'showBorder', state = true}}},
    showTargetIndicator = {value = true, metadata = {element = 'checkbox', category = 'Target Highlight', indexInCategory = 6, description = 'Show target indicator arrow'}},
    targetIndicatorTexture = {value = 'tex:generic:Arrow0.blp', metadata = {element = 'dropdown', category = 'Target Highlight', indexInCategory = 7, description = 'Target indicator texture', options = {'tex:generic:Arrow0.blp', 'tex:generic:Arrow1.blp', 'tex:generic:Arrow2.blp', 'tex:generic:Arrow3.blp', 'tex:generic:Arrow4.blp', 'tex:generic:Arrow5.blp', 'tex:generic:Arrow6.blp', 'tex:generic:Arrow7.blp', 'tex:generic:Arrow8.blp'}, dependency = {key = 'showTargetIndicator', state = true}}},
    targetIndicatorScale = {value = 1, metadata = {element = 'slider', category = 'Target Highlight', indexInCategory = 8, description = 'Target indicator scale', min = 0.5, max = 2, stepSize = 0.1, dependency = {key = 'showTargetIndicator', state = true}}},
    targetIndicatorColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Target Highlight', indexInCategory = 9, description = 'Target indicator color', dependency = {key = 'showTargetIndicator', state = true}}},
    showPortrait = {value = true, metadata = {element = 'checkbox', category = 'Portrait', indexInCategory = 1, description = 'Show target portrait'}},
    portraitScale = {value = 1, metadata = {element = 'slider', category = 'Portrait', indexInCategory = 2, description = 'Portrait scale', min = 0.5, max = 2, stepSize = 0.1, dependency = {key = 'showPortrait', state = true}}},
    portraitBorderColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Portrait', indexInCategory = 3, description = 'Portrait border color', dependency = {key = 'showPortrait', state = true}}},
    showDebuffs = {value = true, metadata = {element = 'checkbox', category = 'Debuffs', indexInCategory = 1, description = 'Show debuffs on nameplates'}},
    colorTagged = {value = true, metadata = {element = 'checkbox', category = 'Healthbar Colors', indexInCategory = 1, description = 'Color tagged units gray'}},
    colorTaggedColor = {value = {0.5, 0.5, 0.5}, metadata = {element = 'colorpicker', category = 'Healthbar Colors', indexInCategory = 2, description = 'Tagged unit color', dependency = {key = 'colorTagged', state = true}}},
    colorTargeted = {value = true, metadata = {element = 'checkbox', category = 'Healthbar Colors', indexInCategory = 3, description = 'Color targeted nameplate differently'}},
    colorTargetedMode = {value = 'HP Value', metadata = {element = 'dropdown', category = 'Healthbar Colors', indexInCategory = 4, description = 'Targeted color mode', options = {'Distance', 'HP Value', 'Reaction'}, dependency = {key = 'colorTargeted', state = true}}},
    colorDistance = {value = true, metadata = {element = 'checkbox', category = 'Healthbar Colors', indexInCategory = 5, description = 'Color by distance (range/melee)'}},
    colorDistanceMode = {value = 'Range', metadata = {element = 'dropdown', category = 'Healthbar Colors', indexInCategory = 6, description = 'Distance mode', options = {'Range', 'Melee'}, dependency = {key = 'colorDistance', state = true}}},
    colorDistanceInRange = {value = {0.4, 0.85, 0.4}, metadata = {element = 'colorpicker', category = 'Healthbar Colors', indexInCategory = 7, description = 'In range color', dependency = {key = 'colorDistance', state = true}}},
    colorDistanceOutRange = {value = {0.5, 0.6, 0.9}, metadata = {element = 'colorpicker', category = 'Healthbar Colors', indexInCategory = 8, description = 'Out of range color', dependency = {key = 'colorDistance', state = true}}},
    colorHpValue = {value = false, metadata = {element = 'checkbox', category = 'Healthbar Colors', indexInCategory = 9, description = 'Color by HP value'}},
    colorHpValueLow = {value = {0.9, 0.2, 0.2}, metadata = {element = 'colorpicker', category = 'Healthbar Colors', indexInCategory = 10, description = 'Low HP color (0%)', dependency = {key = 'colorHpValue', state = true}}},
    colorHpValueMid = {value = {0.9, 0.8, 0.2}, metadata = {element = 'colorpicker', category = 'Healthbar Colors', indexInCategory = 11, description = 'Mid HP color (50%)', dependency = {key = 'colorHpValue', state = true}}},
    colorHpValueHigh = {value = {0.4, 0.85, 0.4}, metadata = {element = 'colorpicker', category = 'Healthbar Colors', indexInCategory = 12, description = 'High HP color (100%)', dependency = {key = 'colorHpValue', state = true}}},
    colorReaction = {value = true, metadata = {element = 'checkbox', category = 'Healthbar Colors', indexInCategory = 13, description = 'Color by reaction (hostile/neutral/friendly)'}},
    colorReactionFriendly = {value = {0.4, 0.85, 0.4}, metadata = {element = 'colorpicker', category = 'Healthbar Colors', indexInCategory = 14, description = 'Friendly color', dependency = {key = 'colorReaction', state = true}}},
    colorReactionNeutral = {value = {0.9, 0.8, 0.2}, metadata = {element = 'colorpicker', category = 'Healthbar Colors', indexInCategory = 15, description = 'Neutral color', dependency = {key = 'colorReaction', state = true}}},
    colorReactionHostile = {value = {0.9, 0.2, 0.2}, metadata = {element = 'colorpicker', category = 'Healthbar Colors', indexInCategory = 16, description = 'Hostile color', dependency = {key = 'colorReaction', state = true}}},
})

DF:NewModule('nameplates', 1, 'PLAYER_ENTERING_WORLD', function()
    local plates = DF.setups.plates

    local scanner = CreateFrame('Frame')
    scanner:SetScript('OnUpdate', function()
        plates:ScanNamePlates()
    end)

    local callbacks = {}
    local callbackHelper = {}

    callbackHelper.colorStates = {
        tagged = false,
        taggedColor = nil,
        targeted = false,
        targetedMode = 'Distance',
        distance = false,
        distanceMode = 'Range',
        distanceInRange = nil,
        distanceOutRange = nil,
        hpValue = false,
        hpValueLow = nil,
        hpValueMid = nil,
        hpValueHigh = nil,
        reaction = true,
        reactionFriendly = nil,
        reactionNeutral = nil,
        reactionHostile = nil
    }

    callbackHelper.GetDistanceColor = function(guid)
        local dist = UnitXP('distanceBetween', 'player', guid)
        local states = callbackHelper.colorStates
        local threshold = states.distanceMode == 'Range' and 30 or 5

        if dist and dist > threshold then
            local c = states.distanceOutRange
            return c[1], c[2], c[3], 1
        else
            local c = states.distanceInRange
            return c[1], c[2], c[3], 1
        end
    end

    callbackHelper.GetHpValueColor = function(hp)
        local min, max = hp:GetMinMaxValues()
        if max > 0 then
            local percent = hp:GetValue() / max
            local states = callbackHelper.colorStates
            local low, mid, high = states.hpValueLow, states.hpValueMid, states.hpValueHigh
            local r, g, b = DF.math.colorGradient(percent, low[1], low[2], low[3], mid[1], mid[2], mid[3], high[1], high[2], high[3])
            return r, g, b, 1
        end
        return 0, 1, 0, 1
    end

    callbackHelper.GetReactionColor = function(guid)
        local reaction = UnitReaction('player', guid)
        local states = callbackHelper.colorStates
        if reaction then
            if reaction >= 5 then
                local c = states.reactionFriendly
                return c[1], c[2], c[3], 1
            elseif reaction == 4 then
                local c = states.reactionNeutral
                return c[1], c[2], c[3], 1
            else
                local c = states.reactionHostile
                return c[1], c[2], c[3], 1
            end
        end
        return 0, 1, 0, 1
    end

    callbackHelper.UpdateHealthbarColor = function(frame, guid)
        local hp = frame.custom.healthbar
        local states = callbackHelper.colorStates

        -- Priority 1: Tagged
        if states.tagged then
            if UnitIsTapped(guid) and not UnitIsTappedByPlayer(guid) then
                local c = states.taggedColor
                hp:SetStatusBarColor(c[1], c[2], c[3], 1)
                return
            end
        end

        -- Priority 2: Targeted
        if states.targeted then
            if UnitName('target') == UnitName(guid) and UnitExists('target') then
                local _, targetGuid = UnitExists('target')
                if targetGuid == guid then
                    local r, g, b, a
                    if states.targetedMode == 'Distance' then
                        r, g, b, a = callbackHelper.GetDistanceColor(guid)
                    elseif states.targetedMode == 'HP Value' then
                        r, g, b, a = callbackHelper.GetHpValueColor(hp)
                    elseif states.targetedMode == 'Reaction' then
                        r, g, b, a = callbackHelper.GetReactionColor(guid)
                    end
                    hp:SetStatusBarColor(r, g, b, a)
                    return
                end
            end
        end

        -- Priority 3: Distance
        if states.distance then
            local dist = UnitXP('distanceBetween', 'player', guid)
            local threshold = states.distanceMode == 'Range' and 30 or 5
            if dist and dist > threshold then
                local r, g, b, a = callbackHelper.GetDistanceColor(guid)
                hp:SetStatusBarColor(r, g, b, a)
                return
            end
        end

        -- Priority 4: HP Value
        if states.hpValue then
            local r, g, b, a = callbackHelper.GetHpValueColor(hp)
            hp:SetStatusBarColor(r, g, b, a)
            return
        end

        -- Priority 5: Reaction (fallback)
        if states.reaction then
            local r, g, b, a = callbackHelper.GetReactionColor(guid)
            hp:SetStatusBarColor(r, g, b, a)
            return
        end

        -- Default fallback
        hp:SetStatusBarColor(0, 1, 0, 1)
    end

    callbacks.overlapNameplates = function(value)
        plates.overlapEnabled = value
    end

    callbacks.showDistance = function(value)
        plates.showDistance = value
    end

    callbacks.showDistanceOnlyTarget = function(value)
        plates.showDistanceOnlyTarget = value
    end

    callbacks.showLevel = function(value)
        plates.showLevel = value
    end

    callbacks.showLevelOnlyTarget = function(value)
        plates.showLevelOnlyTarget = value
    end

    callbacks.showName = function(value)
        plates.showName = value
    end

    callbacks.showNameOnlyTarget = function(value)
        plates.showNameOnlyTarget = value
    end

    callbacks.showGlow = function(value)
        plates.showGlow = value
    end

    callbacks.showBorder = function(value)
        plates.showBorder = value
    end

    callbacks.showBorderOnlyTarget = function(value)
        plates.showBorderOnlyTarget = value
    end

    callbacks.glowColor = function(value)
        plates.glowColor = value
        for frame in pairs(plates.registry) do
            frame.custom.topGlow:SetVertexColor(value[1], value[2], value[3], .4)
            frame.custom.botGlow:SetVertexColor(value[1], value[2], value[3], .4)
        end
    end

    callbacks.borderColor = function(value)
        plates.borderColor = value
        for frame in pairs(plates.registry) do
            for _, tex in pairs(frame.custom.borderLeftTex) do
                tex:SetVertexColor(value[1], value[2], value[3], .5)
            end
            for _, tex in pairs(frame.custom.borderRightTex) do
                tex:SetVertexColor(value[1], value[2], value[3], .5)
            end
        end
    end

    callbacks.textFont = function(value)
        local font = media[value]
        for frame in pairs(plates.registry) do
            frame.custom.nameText:SetFont(font, 10, 'OUTLINE')
            frame.custom.levelText:SetFont(font, 10, 'OUTLINE')
            frame.custom.hpText:SetFont(font, plates.hpTextSize or 8, 'OUTLINE')
            frame.custom.distText:SetFont(font, 8, 'OUTLINE')
        end
    end

    callbacks.colorTagged = function(value)
        callbackHelper.colorStates.tagged = value
    end

    callbacks.colorTaggedColor = function(value)
        callbackHelper.colorStates.taggedColor = value
    end

    callbacks.colorTargeted = function(value)
        callbackHelper.colorStates.targeted = value
    end

    callbacks.colorTargetedMode = function(value)
        callbackHelper.colorStates.targetedMode = value
    end

    callbacks.colorDistance = function(value)
        callbackHelper.colorStates.distance = value
    end

    callbacks.colorDistanceMode = function(value)
        callbackHelper.colorStates.distanceMode = value
    end

    callbacks.colorDistanceInRange = function(value)
        callbackHelper.colorStates.distanceInRange = value
    end

    callbacks.colorDistanceOutRange = function(value)
        callbackHelper.colorStates.distanceOutRange = value
    end

    callbacks.colorHpValue = function(value)
        callbackHelper.colorStates.hpValue = value
    end

    callbacks.colorHpValueLow = function(value)
        callbackHelper.colorStates.hpValueLow = value
    end

    callbacks.colorHpValueMid = function(value)
        callbackHelper.colorStates.hpValueMid = value
    end

    callbacks.colorHpValueHigh = function(value)
        callbackHelper.colorStates.hpValueHigh = value
    end

    callbacks.colorReaction = function(value)
        callbackHelper.colorStates.reaction = value
    end

    callbacks.colorReactionFriendly = function(value)
        callbackHelper.colorStates.reactionFriendly = value
    end

    callbacks.colorReactionNeutral = function(value)
        callbackHelper.colorStates.reactionNeutral = value
    end

    callbacks.colorReactionHostile = function(value)
        callbackHelper.colorStates.reactionHostile = value
    end

    callbacks.scaleNameplates = function(value)
        plates.scaleNameplates = value
    end

    callbacks.scaleTargeted = function(value)
        plates.scaleTargeted = value
    end

    callbacks.scaleUntargeted = function(value)
        plates.scaleUntargeted = value
    end

    callbacks.hpTextPosition = function(value)
        plates.hpTextPosition = value
        for frame in pairs(plates.registry) do
            frame.custom.hpText:ClearAllPoints()
            frame.custom.hpText:SetPoint(value, frame.custom.healthbar, value, 0, 0)
        end
    end

    callbacks.nameOffsetX = function(value)
        plates.nameOffsetX = value
        for frame in pairs(plates.registry) do
            frame.custom.nameText:ClearAllPoints()
            frame.custom.nameText:SetPoint('BOTTOM', frame.custom.healthbar, 'TOP', value, plates.nameOffsetY or 2)
        end
    end

    callbacks.nameOffsetY = function(value)
        plates.nameOffsetY = value
        for frame in pairs(plates.registry) do
            frame.custom.nameText:ClearAllPoints()
            frame.custom.nameText:SetPoint('BOTTOM', frame.custom.healthbar, 'TOP', plates.nameOffsetX or 0, value)
        end
    end

    callbacks.showPortrait = function(value)
        plates.showPortrait = value
    end

    callbacks.portraitScale = function(value)
        plates.portraitScale = value
        for frame in pairs(plates.registry) do
            local size = 20 * value
            frame.custom.portrait:SetSize(size, size)
        end
    end

    callbacks.portraitBorderColor = function(value)
        plates.portraitBorderColor = value
        for frame in pairs(plates.registry) do
            frame.custom.portraitBorder:SetVertexColor(value[1], value[2], value[3], 1)
        end
    end

    callbacks.showTargetIndicator = function(value)
        plates.showTargetIndicator = value
    end

    callbacks.targetIndicatorTexture = function(value)
        plates.targetIndicatorTexture = value
        for frame in pairs(plates.registry) do
            frame.custom.targetIndicator:SetTexture(media[value])
        end
    end

    callbacks.targetIndicatorScale = function(value)
        plates.targetIndicatorScale = value
        for frame in pairs(plates.registry) do
            local size = 20 * value
            frame.custom.targetIndicator:SetSize(size, size)
        end
    end

    callbacks.targetIndicatorColor = function(value)
        plates.targetIndicatorColor = value
        for frame in pairs(plates.registry) do
            frame.custom.targetIndicator:SetVertexColor(value[1], value[2], value[3], 1)
        end
    end

    callbacks.healthbarWidth = function(value)
        plates.healthbarWidth = value
        for frame in pairs(plates.registry) do
            frame.custom.frame:SetSize(value, plates.healthbarHeight or 14)
        end
    end

    callbacks.healthbarHeight = function(value)
        plates.healthbarHeight = value
        for frame in pairs(plates.registry) do
            frame.custom.frame:SetSize(plates.healthbarWidth or 100, value)
        end
    end

    callbacks.levelBorderColor = function(value)
        plates.levelBorderColor = value
        for frame in pairs(plates.registry) do
            frame.custom.levelBorder:SetVertexColor(value[1], value[2], value[3], 1)
        end
    end

    callbacks.distanceBorderColor = function(value)
        plates.distanceBorderColor = value
        for frame in pairs(plates.registry) do
            frame.custom.distBorder:SetVertexColor(value[1], value[2], value[3], 1)
        end
    end

    callbacks.showDebuffs = function(value)
        plates.showDebuffs = value
    end

    callbacks.showHpText = function(value)
        plates.showHpText = value
    end

    callbacks.hpTextSize = function(value)
        plates.hpTextSize = value
        local font = media[plates.textFont or 'font:PT-Sans-Narrow-Bold.ttf']
        for frame in pairs(plates.registry) do
            frame.custom.hpText:SetFont(font, value, 'OUTLINE')
        end
    end

    callbacks.healthbarTexture = function(value)
        plates.healthbarTexture = value
        local tex = value == 'Dragonflight' and media['tex:unitframes:aurora_hpbar.tga'] or 'Interface\\Buttons\\WHITE8X8'
        for frame in pairs(plates.registry) do
            frame.custom.healthbar:SetStatusBarTexture(tex)
        end
    end

    callbacks.clickThrough = function(value)
        plates.clickThrough = value
        for frame in pairs(plates.registry) do
            frame.custom.frame:EnableMouse(not value)
        end
    end

    -- expose to tools SetupOnUpdate
    DF.setups.nameplatesColor = callbackHelper.UpdateHealthbarColor

    DF:NewCallbacks('nameplates', callbacks)
end)
