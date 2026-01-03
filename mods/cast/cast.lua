DRAGONFLIGHT()
if not dependency('SuperWoW') then return end

DF:NewDefaults('castbar', {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {
        {tab = 'castbar', subtab = 'player', 'Player Appearance', 'Player Colors', 'Player Icon', 'Player Text', 'Player Behavior'},
        {tab = 'castbar', subtab = 'target', 'Target Appearance', 'Target Colors', 'Target Icon', 'Target Text', 'Target Behavior'},
    },

    showPlayerCastbar = {value = true, metadata = {element = 'checkbox', category = 'Player Appearance', indexInCategory = 1, description = 'Show or hide the player castbar'}},
    playerCastbarWidth = {value = 155, metadata = {element = 'slider', category = 'Player Appearance', indexInCategory = 2, description = 'Width of the player castbar', min = 100, max = 400, stepSize = 1, dependency = {key = 'showPlayerCastbar', state = true}}},
    playerCastbarHeight = {value = 16, metadata = {element = 'slider', category = 'Player Appearance', indexInCategory = 3, description = 'Height of the player castbar', min = 10, max = 40, stepSize = 1, dependency = {key = 'showPlayerCastbar', state = true}}},
    playerShowDropshadow = {value = true, metadata = {element = 'checkbox', category = 'Player Appearance', indexInCategory = 4, description = 'Show or hide the dropshadow', dependency = {key = 'showPlayerCastbar', state = true}}},
    playerDropshadowWidth = {value = 154, metadata = {element = 'slider', category = 'Player Appearance', indexInCategory = 5, description = 'Width of the dropshadow', min = 100, max = 400, stepSize = 1, dependency = {key = 'playerShowDropshadow', state = true}}},
    playerDropshadowHeight = {value = 25, metadata = {element = 'slider', category = 'Player Appearance', indexInCategory = 6, description = 'Height of the dropshadow', min = 10, max = 50, stepSize = 1, dependency = {key = 'playerShowDropshadow', state = true}}},
    playerBarColor = {value = {1, 0.82, 0}, metadata = {element = 'colorpicker', category = 'Player Colors', indexInCategory = 1, description = 'Color of the castbar fill', dependency = {key = 'showPlayerCastbar', state = true}}},
    playerSparkColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Player Colors', indexInCategory = 2, description = 'Color of the spark', dependency = {key = 'showPlayerCastbar', state = true}}},
    playerBackgroundColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Player Colors', indexInCategory = 3, description = 'Color of the background', dependency = {key = 'showPlayerCastbar', state = true}}},
    playerBorderColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Player Colors', indexInCategory = 4, description = 'Color of the border', dependency = {key = 'showPlayerCastbar', state = true}}},
    playerShowIcon = {value = false, metadata = {element = 'checkbox', category = 'Player Icon', indexInCategory = 1, description = 'Show or hide the spell icon', dependency = {key = 'showPlayerCastbar', state = true}}},
    playerIconSize = {value = 16, metadata = {element = 'slider', category = 'Player Icon', indexInCategory = 2, description = 'Size of the spell icon', min = 10, max = 50, stepSize = 1, dependency = {key = 'playerShowIcon', state = true}}},
    playerIconAnchor = {value = 'LEFT', metadata = {element = 'dropdown', category = 'Player Icon', indexInCategory = 3, description = 'Icon position relative to castbar', options = {'LEFT', 'RIGHT'}, dependency = {key = 'playerShowIcon', state = true}}},
    playerFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'Player Text', indexInCategory = 1, description = 'Font for text', options = media.fonts, dependency = {key = 'showPlayerCastbar', state = true}}},
    playerShowSpellName = {value = true, metadata = {element = 'checkbox', category = 'Player Text', indexInCategory = 2, description = 'Show or hide spell name', dependency = {key = 'showPlayerCastbar', state = true}}},
    playerSpellColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Player Text', indexInCategory = 3, description = 'Color of spell name text', dependency = {key = 'playerShowSpellName', state = true}}},
    playerShowRank = {value = true, metadata = {element = 'checkbox', category = 'Player Text', indexInCategory = 4, description = 'Show or hide rank', dependency = {key = 'showPlayerCastbar', state = true}}},
    playerRankColor = {value = {0.9, 0.9, 0.9}, metadata = {element = 'colorpicker', category = 'Player Text', indexInCategory = 5, description = 'Color of rank text', dependency = {key = 'playerShowRank', state = true}}},
    playerShowTime = {value = true, metadata = {element = 'checkbox', category = 'Player Text', indexInCategory = 6, description = 'Show or hide time', dependency = {key = 'showPlayerCastbar', state = true}}},
    playerTimeColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Player Text', indexInCategory = 7, description = 'Color of time text', dependency = {key = 'playerShowTime', state = true}}},
    playerAutoColorTime = {value = true, metadata = {element = 'checkbox', category = 'Player Text', indexInCategory = 8, description = 'Auto color time from white to red when less than one second remaining', dependency = {key = 'playerShowTime', state = true}}},
    playerTimeFormatWhole = {value = false, metadata = {element = 'checkbox', category = 'Player Text', indexInCategory = 9, description = 'Show time as whole numbers without decimals', dependency = {key = 'playerShowTime', state = true}}},
    playerSpellNameOffsetX = {value = 0, metadata = {element = 'slider', category = 'Player Text', indexInCategory = 10, description = 'Spell name X position offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'playerShowSpellName', state = true}}},
    playerSpellNameOffsetY = {value = -15, metadata = {element = 'slider', category = 'Player Text', indexInCategory = 11, description = 'Spell name Y position offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'playerShowSpellName', state = true}}},
    playerTimeOffsetX = {value = 0, metadata = {element = 'slider', category = 'Player Text', indexInCategory = 12, description = 'Cast time X position offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'playerShowTime', state = true}}},
    playerTimeOffsetY = {value = -15, metadata = {element = 'slider', category = 'Player Text', indexInCategory = 13, description = 'Cast time Y position offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'playerShowTime', state = true}}},
    playerFillDirection = {value = 'left', metadata = {element = 'dropdown', category = 'Player Behavior', indexInCategory = 1, description = 'Direction the castbar fills', options = {'left', 'right', 'center', 'centerreversed'}, dependency = {key = 'showPlayerCastbar', state = true}}},
    playerSparkTrail = {value = true, metadata = {element = 'checkbox', category = 'Player Behavior', indexInCategory = 2, description = 'Enable spark trail effect', dependency = {key = 'showPlayerCastbar', state = true}}},
    playerTrailMaxCount = {value = 25, metadata = {element = 'slider', category = 'Player Behavior', indexInCategory = 3, description = 'Maximum number of trail sparks', min = 5, max = 30, stepSize = 1, dependency = {key = 'playerSparkTrail', state = true}}},
    playerTrailSpawnDistance = {value = 5, metadata = {element = 'slider', category = 'Player Behavior', indexInCategory = 4, description = 'Distance between trail sparks', min = 1, max = 20, stepSize = 1, dependency = {key = 'playerSparkTrail', state = true}}},
    playerShowLag = {value = true, metadata = {element = 'checkbox', category = 'Player Behavior', indexInCategory = 5, description = 'Show lag indicator on castbar', dependency = {key = 'showPlayerCastbar', state = true}}},

    showTargetCastbar = {value = true, metadata = {element = 'checkbox', category = 'Target Appearance', indexInCategory = 1, description = 'Show or hide the target castbar'}},
    targetCastbarWidth = {value = 125, metadata = {element = 'slider', category = 'Target Appearance', indexInCategory = 2, description = 'Width of the target castbar', min = 100, max = 400, stepSize = 1, dependency = {key = 'showTargetCastbar', state = true}}},
    targetCastbarHeight = {value = 13, metadata = {element = 'slider', category = 'Target Appearance', indexInCategory = 3, description = 'Height of the target castbar', min = 10, max = 40, stepSize = 1, dependency = {key = 'showTargetCastbar', state = true}}},
    targetShowDropshadow = {value = true, metadata = {element = 'checkbox', category = 'Target Appearance', indexInCategory = 4, description = 'Show or hide the dropshadow', dependency = {key = 'showTargetCastbar', state = true}}},
    targetDropshadowWidth = {value = 125, metadata = {element = 'slider', category = 'Target Appearance', indexInCategory = 5, description = 'Width of the dropshadow', min = 100, max = 400, stepSize = 1, dependency = {key = 'targetShowDropshadow', state = true}}},
    targetDropshadowHeight = {value = 25, metadata = {element = 'slider', category = 'Target Appearance', indexInCategory = 6, description = 'Height of the dropshadow', min = 10, max = 50, stepSize = 1, dependency = {key = 'targetShowDropshadow', state = true}}},
    targetBarColor = {value = {1, 0.82, 0}, metadata = {element = 'colorpicker', category = 'Target Colors', indexInCategory = 1, description = 'Color of the castbar fill', dependency = {key = 'showTargetCastbar', state = true}}},
    targetSparkColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Target Colors', indexInCategory = 2, description = 'Color of the spark', dependency = {key = 'showTargetCastbar', state = true}}},
    targetBackgroundColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Target Colors', indexInCategory = 3, description = 'Color of the background', dependency = {key = 'showTargetCastbar', state = true}}},
    targetBorderColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Target Colors', indexInCategory = 4, description = 'Color of the border', dependency = {key = 'showTargetCastbar', state = true}}},
    targetShowIcon = {value = true, metadata = {element = 'checkbox', category = 'Target Icon', indexInCategory = 1, description = 'Show or hide the spell icon', dependency = {key = 'showTargetCastbar', state = true}}},
    targetIconSize = {value = 14, metadata = {element = 'slider', category = 'Target Icon', indexInCategory = 2, description = 'Size of the spell icon', min = 10, max = 50, stepSize = 1, dependency = {key = 'targetShowIcon', state = true}}},
    targetIconAnchor = {value = 'LEFT', metadata = {element = 'dropdown', category = 'Target Icon', indexInCategory = 3, description = 'Icon position relative to castbar', options = {'LEFT', 'RIGHT'}, dependency = {key = 'targetShowIcon', state = true}}},
    targetFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'Target Text', indexInCategory = 1, description = 'Font for text', options = media.fonts, dependency = {key = 'showTargetCastbar', state = true}}},
    targetShowSpellName = {value = true, metadata = {element = 'checkbox', category = 'Target Text', indexInCategory = 2, description = 'Show or hide spell name', dependency = {key = 'showTargetCastbar', state = true}}},
    targetSpellColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Target Text', indexInCategory = 3, description = 'Color of spell name text', dependency = {key = 'targetShowSpellName', state = true}}},
    targetShowRank = {value = true, metadata = {element = 'checkbox', category = 'Target Text', indexInCategory = 4, description = 'Show or hide rank', dependency = {key = 'showTargetCastbar', state = true}}},
    targetRankColor = {value = {0.9, 0.9, 0.9}, metadata = {element = 'colorpicker', category = 'Target Text', indexInCategory = 5, description = 'Color of rank text', dependency = {key = 'targetShowRank', state = true}}},
    targetShowTime = {value = true, metadata = {element = 'checkbox', category = 'Target Text', indexInCategory = 6, description = 'Show or hide time', dependency = {key = 'showTargetCastbar', state = true}}},
    targetTimeColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Target Text', indexInCategory = 7, description = 'Color of time text', dependency = {key = 'targetShowTime', state = true}}},
    targetAutoColorTime = {value = true, metadata = {element = 'checkbox', category = 'Target Text', indexInCategory = 8, description = 'Auto color time from white to red when less than one second remaining', dependency = {key = 'targetShowTime', state = true}}},
    targetTimeFormatWhole = {value = false, metadata = {element = 'checkbox', category = 'Target Text', indexInCategory = 9, description = 'Show time as whole numbers without decimals', dependency = {key = 'targetShowTime', state = true}}},
    targetSpellNameOffsetX = {value = 0, metadata = {element = 'slider', category = 'Target Text', indexInCategory = 10, description = 'Spell name X position offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'targetShowSpellName', state = true}}},
    targetSpellNameOffsetY = {value = -15, metadata = {element = 'slider', category = 'Target Text', indexInCategory = 11, description = 'Spell name Y position offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'targetShowSpellName', state = true}}},
    targetTimeOffsetX = {value = 0, metadata = {element = 'slider', category = 'Target Text', indexInCategory = 12, description = 'Cast time X position offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'targetShowTime', state = true}}},
    targetTimeOffsetY = {value = -15, metadata = {element = 'slider', category = 'Target Text', indexInCategory = 13, description = 'Cast time Y position offset', min = -50, max = 50, stepSize = 1, dependency = {key = 'targetShowTime', state = true}}},
    targetFillDirection = {value = 'left', metadata = {element = 'dropdown', category = 'Target Behavior', indexInCategory = 1, description = 'Direction the castbar fills', options = {'left', 'right', 'center', 'centerreversed'}, dependency = {key = 'showTargetCastbar', state = true}}},
    targetSparkTrail = {value = true, metadata = {element = 'checkbox', category = 'Target Behavior', indexInCategory = 2, description = 'Enable spark trail effect', dependency = {key = 'showTargetCastbar', state = true}}},
    targetTrailMaxCount = {value = 15, metadata = {element = 'slider', category = 'Target Behavior', indexInCategory = 3, description = 'Maximum number of trail sparks', min = 5, max = 30, stepSize = 1, dependency = {key = 'targetSparkTrail', state = true}}},
    targetTrailSpawnDistance = {value = 5, metadata = {element = 'slider', category = 'Target Behavior', indexInCategory = 4, description = 'Distance between trail sparks', min = 1, max = 20, stepSize = 1, dependency = {key = 'targetSparkTrail', state = true}}},
})

DF:NewModule('castbar', 2, 'PLAYER_LOGIN', function()
    DF.common.KillFrame(CastingBarFrame)

    local castBar = DF.lib.CreateCastBar('player')
    castBar.frame:SetPoint('CENTER', UIParent, 'CENTER', 0, -150)

    local targetCastBar = DF.lib.CreateCastBar('target')
    targetCastBar.frame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 260, -130)


    -- callbacks
    local helpers = {}
    local callbacks = {}

    callbacks.showPlayerCastbar = function(value)
        if value then
            castBar.frame:Show()
        else
            castBar.frame:Hide()
        end
    end

    callbacks.showTargetCastbar = function(value)
        if value then
            targetCastBar.frame:Show()
        else
            targetCastBar.frame:Hide()
        end
    end

    callbacks.playerCastbarWidth = function(value)
        castBar.config.width = value
        castBar.frame:SetWidth(value)
    end

    callbacks.playerCastbarHeight = function(value)
        castBar.config.height = value
        castBar.frame:SetHeight(value)
        castBar.bar:SetHeight(value)
        castBar.lagIndicator:SetHeight(value)
        castBar.lagIndicator2:SetHeight(value)
        castBar:UpdateSparkHeights()
    end

    callbacks.targetCastbarWidth = function(value)
        targetCastBar.config.width = value
        targetCastBar.frame:SetWidth(value)
    end

    callbacks.targetCastbarHeight = function(value)
        targetCastBar.config.height = value
        targetCastBar.frame:SetHeight(value)
        targetCastBar.bar:SetHeight(value)
        targetCastBar.lagIndicator:SetHeight(value)
        targetCastBar.lagIndicator2:SetHeight(value)
        targetCastBar:UpdateSparkHeights()
    end

    callbacks.playerShowDropshadow = function(value)
        if value then
            castBar.dropshadow:Show()
        else
            castBar.dropshadow:Hide()
        end
    end

    callbacks.playerDropshadowWidth = function(value)
        castBar.dropshadow:SetWidth(value)
    end

    callbacks.playerDropshadowHeight = function(value)
        castBar.dropshadow:SetHeight(value)
    end

    callbacks.playerBarColor = function(value)
        castBar.config.barColor = value
        castBar.bar:SetVertexColor(value[1], value[2], value[3])
    end

    callbacks.playerSparkColor = function(value)
        castBar.spark:SetVertexColor(value[1], value[2], value[3])
        castBar.spark2:SetVertexColor(value[1], value[2], value[3])
        for i = 1, castBar.config.trailMaxCount do
            if castBar.sparkTrails[i] then
                castBar.sparkTrails[i]:SetVertexColor(value[1], value[2], value[3])
            end
        end
    end

    callbacks.playerBackgroundColor = function(value)
        castBar.bg:SetVertexColor(value[1], value[2], value[3])
    end

    callbacks.playerBorderColor = function(value)
        castBar.border:SetVertexColor(value[1], value[2], value[3])
    end

    callbacks.targetShowDropshadow = function(value)
        if value then
            targetCastBar.dropshadow:Show()
        else
            targetCastBar.dropshadow:Hide()
        end
    end

    callbacks.targetDropshadowWidth = function(value)
        targetCastBar.dropshadow:SetWidth(value)
    end

    callbacks.targetDropshadowHeight = function(value)
        targetCastBar.dropshadow:SetHeight(value)
    end

    callbacks.targetBarColor = function(value)
        targetCastBar.config.barColor = value
        targetCastBar.bar:SetVertexColor(value[1], value[2], value[3])
    end

    callbacks.targetSparkColor = function(value)
        targetCastBar.spark:SetVertexColor(value[1], value[2], value[3])
        targetCastBar.spark2:SetVertexColor(value[1], value[2], value[3])
        for i = 1, targetCastBar.config.trailMaxCount do
            if targetCastBar.sparkTrails[i] then
                targetCastBar.sparkTrails[i]:SetVertexColor(value[1], value[2], value[3])
            end
        end
    end

    callbacks.targetBackgroundColor = function(value)
        targetCastBar.bg:SetVertexColor(value[1], value[2], value[3])
    end

    callbacks.targetBorderColor = function(value)
        targetCastBar.border:SetVertexColor(value[1], value[2], value[3])
    end

    callbacks.playerShowIcon = function(value)
        castBar.config.showIcon = value
        if not value then
            castBar.icon:Hide()
        end
    end

    callbacks.playerIconSize = function(value)
        castBar.icon:SetWidth(value)
        castBar.icon:SetHeight(value)
    end

    callbacks.playerIconAnchor = function(value)
        castBar.icon:ClearAllPoints()
        if value == 'LEFT' then
            castBar.icon:SetPoint('RIGHT', castBar.frame, 'LEFT', -5, 0)
        else
            castBar.icon:SetPoint('LEFT', castBar.frame, 'RIGHT', 5, 0)
        end
    end

    callbacks.playerFont = function(value)
        local _, size, flags = castBar.text:GetFont()
        castBar.text:SetFont(value, size, flags)
        castBar.rankText:SetFont(value, size - 2, flags)
        castBar.timeText:SetFont(value, size, flags)
    end

    callbacks.playerShowSpellName = function(value)
        castBar.config.showSpellName = value
        if not value then
            castBar.text:SetText('')
        end
    end

    callbacks.playerSpellColor = function(value)
        castBar.text:SetTextColor(value[1], value[2], value[3])
    end

    callbacks.playerShowRank = function(value)
        castBar.config.showRank = value
        if not value then
            castBar.rankText:SetText('')
        end
    end

    callbacks.playerRankColor = function(value)
        castBar.rankText:SetTextColor(value[1], value[2], value[3])
    end

    callbacks.playerShowTime = function(value)
        castBar.config.showTime = value
        if not value then
            castBar.timeText:SetText('')
        end
    end

    callbacks.playerTimeColor = function(value)
        castBar.timeText:SetTextColor(value[1], value[2], value[3])
    end

    callbacks.targetShowIcon = function(value)
        targetCastBar.config.showIcon = value
        if not value then
            targetCastBar.icon:Hide()
        end
    end

    callbacks.targetIconSize = function(value)
        targetCastBar.icon:SetWidth(value)
        targetCastBar.icon:SetHeight(value)
    end

    callbacks.targetIconAnchor = function(value)
        targetCastBar.icon:ClearAllPoints()
        if value == 'LEFT' then
            targetCastBar.icon:SetPoint('RIGHT', targetCastBar.frame, 'LEFT', -5, 0)
        else
            targetCastBar.icon:SetPoint('LEFT', targetCastBar.frame, 'RIGHT', 5, 0)
        end
    end

    callbacks.targetFont = function(value)
        local _, size, flags = targetCastBar.text:GetFont()
        targetCastBar.text:SetFont(value, size, flags)
        targetCastBar.rankText:SetFont(value, size - 2, flags)
        targetCastBar.timeText:SetFont(value, size, flags)
    end

    callbacks.targetShowSpellName = function(value)
        targetCastBar.config.showSpellName = value
        if not value then
            targetCastBar.text:SetText('')
        end
    end

    callbacks.targetSpellColor = function(value)
        targetCastBar.text:SetTextColor(value[1], value[2], value[3])
    end

    callbacks.targetShowRank = function(value)
        targetCastBar.config.showRank = value
        if not value then
            targetCastBar.rankText:SetText('')
        end
    end

    callbacks.targetRankColor = function(value)
        targetCastBar.rankText:SetTextColor(value[1], value[2], value[3])
    end

    callbacks.targetShowTime = function(value)
        targetCastBar.config.showTime = value
        if not value then
            targetCastBar.timeText:SetText('')
        end
    end

    callbacks.targetTimeColor = function(value)
        targetCastBar.timeText:SetTextColor(value[1], value[2], value[3])
    end

    callbacks.playerAutoColorTime = function(value)
        castBar.config.autoColorTime = value
        if not value then
            local color = DF.profile['castbar']['playerTimeColor']
            castBar.timeText:SetTextColor(color[1], color[2], color[3])
        end
    end

    callbacks.playerTimeFormatWhole = function(value)
        castBar.config.timeFormatWhole = value
    end

    callbacks.targetAutoColorTime = function(value)
        targetCastBar.config.autoColorTime = value
        if not value then
            local color = DF.profile['castbar']['targetTimeColor']
            targetCastBar.timeText:SetTextColor(color[1], color[2], color[3])
        end
    end

    callbacks.targetTimeFormatWhole = function(value)
        targetCastBar.config.timeFormatWhole = value
    end

    callbacks.playerFillDirection = function(value)
        castBar.config.fillDirection = value
    end

    callbacks.targetFillDirection = function(value)
        targetCastBar.config.fillDirection = value
    end

    callbacks.playerSparkTrail = function(value)
        castBar.config.sparkTrail = value
    end

    callbacks.playerTrailMaxCount = function(value)
        castBar.config.trailMaxCount = value
    end

    callbacks.playerTrailSpawnDistance = function(value)
        castBar.config.trailSpawnDistance = value
    end

    callbacks.playerShowLag = function(value)
        castBar.config.showLag = value
    end

    callbacks.targetSparkTrail = function(value)
        targetCastBar.config.sparkTrail = value
    end

    callbacks.targetTrailMaxCount = function(value)
        targetCastBar.config.trailMaxCount = value
    end

    callbacks.targetTrailSpawnDistance = function(value)
        targetCastBar.config.trailSpawnDistance = value
    end

    callbacks.playerSpellNameOffsetX = function(value)
        castBar.text:ClearAllPoints()
        castBar.text:SetPoint('LEFT', castBar.frame, 'LEFT', 5 + value, castBar.config.spellNameOffsetY or 0)
        castBar.config.spellNameOffsetX = value
    end

    callbacks.playerSpellNameOffsetY = function(value)
        castBar.text:ClearAllPoints()
        castBar.text:SetPoint('LEFT', castBar.frame, 'LEFT', 5 + (castBar.config.spellNameOffsetX or 0), value)
        castBar.config.spellNameOffsetY = value
    end

    callbacks.playerTimeOffsetX = function(value)
        castBar.timeText:ClearAllPoints()
        castBar.timeText:SetPoint('RIGHT', castBar.frame, 'RIGHT', -5 + value, castBar.config.timeOffsetY or 0)
        castBar.config.timeOffsetX = value
    end

    callbacks.playerTimeOffsetY = function(value)
        castBar.timeText:ClearAllPoints()
        castBar.timeText:SetPoint('RIGHT', castBar.frame, 'RIGHT', -5 + (castBar.config.timeOffsetX or 0), value)
        castBar.config.timeOffsetY = value
    end

    callbacks.targetSpellNameOffsetX = function(value)
        targetCastBar.text:ClearAllPoints()
        targetCastBar.text:SetPoint('LEFT', targetCastBar.frame, 'LEFT', 5 + value, targetCastBar.config.spellNameOffsetY or 0)
        targetCastBar.config.spellNameOffsetX = value
    end

    callbacks.targetSpellNameOffsetY = function(value)
        targetCastBar.text:ClearAllPoints()
        targetCastBar.text:SetPoint('LEFT', targetCastBar.frame, 'LEFT', 5 + (targetCastBar.config.spellNameOffsetX or 0), value)
        targetCastBar.config.spellNameOffsetY = value
    end

    callbacks.targetTimeOffsetX = function(value)
        targetCastBar.timeText:ClearAllPoints()
        targetCastBar.timeText:SetPoint('RIGHT', targetCastBar.frame, 'RIGHT', -5 + value, targetCastBar.config.timeOffsetY or 0)
        targetCastBar.config.timeOffsetX = value
    end

    callbacks.targetTimeOffsetY = function(value)
        targetCastBar.timeText:ClearAllPoints()
        targetCastBar.timeText:SetPoint('RIGHT', targetCastBar.frame, 'RIGHT', -5 + (targetCastBar.config.timeOffsetX or 0), value)
        targetCastBar.config.timeOffsetY = value
    end

    DF:NewCallbacks('castbar', callbacks)
end)
