UNLOCKDRAGONFLIGHT()

-- TODO move to generate defaults
local defaults = {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {},
}

local barConfigs = {
    {name = 'mainBar', displayName = 'Main Bar', subtab = 'mainbar', maxButtons = 12},
    {name = 'multibar1', displayName = 'Multi Bar 1', subtab = 'multibar1', maxButtons = 12},
    {name = 'multibar2', displayName = 'Multi Bar 2', subtab = 'multibar2', maxButtons = 12},
    {name = 'multibar3', displayName = 'Multi Bar 3', subtab = 'multibar3', maxButtons = 12},
    {name = 'multibar4', displayName = 'Multi Bar 4', subtab = 'multibar4', maxButtons = 12},
    {name = 'multibar5', displayName = 'Multi Bar 5', subtab = 'multibar5', maxButtons = 12},
    {name = 'petBar', displayName = 'Pet Bar', subtab = 'petbar', maxButtons = 10},
    {name = 'stanceBar', displayName = 'Stance Bar', subtab = 'stancebar', maxButtons = 10},
}

local catGenSettings = 'General Settings'
local catHotkeys = 'Hotkeys'
local catMacros = 'Macros'
local catCounts = 'Counts'
local catColors = 'Colors'
local catBehavior = 'Behavior'
table.insert(defaults.gui, {tab = 'actionbars', subtab = 'general', catGenSettings, catHotkeys, catMacros, catCounts, catColors, catBehavior})

defaults.abbreviateMacroNames = {value = true, metadata = {element = 'checkbox', category = catGenSettings, indexInCategory = 1, description = 'Abbreviate macro names to 4 characters'}}
defaults.rangeIndicatorMode = {value = 'keybind', metadata = {element = 'dropdown', category = catGenSettings, indexInCategory = 2, description = 'Range indicator mode', options = {'keybind', 'icon'}}}
defaults.showKeybindsOnEmpty = {value = false, metadata = {element = 'checkbox', category = catGenSettings, indexInCategory = 3, description = 'Show keybinds on empty buttons'}}

defaults.hotkeyShow = {value = true, metadata = {element = 'checkbox', category = catHotkeys, indexInCategory = 1, description = 'Toggle visibility of hotkey bindings on action buttons'}}
defaults.hotkeyFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = catHotkeys, indexInCategory = 2, description = 'Select font for hotkey text', options = media.fonts, dependency = {key = 'hotkeyShow', state = true}}}
defaults.hotkeyFontSize = {value = 11, metadata = {element = 'slider', category = catHotkeys, indexInCategory = 3, description = 'Adjust the font size of hotkey text', min = 6, max = 20, stepSize = 1, dependency = {key = 'hotkeyShow', state = true}}}
defaults.hotkeyColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catHotkeys, indexInCategory = 4, description = 'Set the color of hotkey text', dependency = {key = 'hotkeyShow', state = true}}}
defaults.hotkeyX = {value = -1, metadata = {element = 'slider', category = catHotkeys, indexInCategory = 5, description = 'Horizontal position offset for hotkey text', min = -20, max = 20, stepSize = 1, dependency = {key = 'hotkeyShow', state = true}}}
defaults.hotkeyY = {value = -1, metadata = {element = 'slider', category = catHotkeys, indexInCategory = 6, description = 'Vertical position offset for hotkey text', min = -20, max = 20, stepSize = 1, dependency = {key = 'hotkeyShow', state = true}}}

defaults.macroShow = {value = true, metadata = {element = 'checkbox', category = catMacros, indexInCategory = 1, description = 'Toggle visibility of macro text on action buttons'}}
defaults.macroFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = catMacros, indexInCategory = 2, description = 'Select font for macro text', options = media.fonts, dependency = {key = 'macroShow', state = true}}}
defaults.macroFontSize = {value = 10, metadata = {element = 'slider', category = catMacros, indexInCategory = 3, description = 'Adjust the font size of macro text', min = 6, max = 20, stepSize = 1, dependency = {key = 'macroShow', state = true}}}
defaults.macroColour = {value = {1, 0.82, 0, 1}, metadata = {element = 'colorpicker', category = catMacros, indexInCategory = 4, description = 'Set the color of macro text', dependency = {key = 'macroShow', state = true}}}
defaults.macroX = {value = 0, metadata = {element = 'slider', category = catMacros, indexInCategory = 5, description = 'Horizontal position offset for macro text', min = -20, max = 20, stepSize = 1, dependency = {key = 'macroShow', state = true}}}
defaults.macroY = {value = -1, metadata = {element = 'slider', category = catMacros, indexInCategory = 6, description = 'Vertical position offset for macro text', min = -20, max = 20, stepSize = 1, dependency = {key = 'macroShow', state = true}}}

defaults.countShow = {value = true, metadata = {element = 'checkbox', category = catCounts, indexInCategory = 1, description = 'Toggle visibility of count text on action buttons'}}
defaults.countFont = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = catCounts, indexInCategory = 2, description = 'Select font for count text', options = media.fonts, dependency = {key = 'countShow', state = true}}}
defaults.countFontSize = {value = 10, metadata = {element = 'slider', category = catCounts, indexInCategory = 3, description = 'Adjust the font size of count text', min = 6, max = 20, stepSize = 1, dependency = {key = 'countShow', state = true}}}
defaults.countColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catCounts, indexInCategory = 4, description = 'Set the color of count text', dependency = {key = 'countShow', state = true}}}
defaults.countX = {value = -2, metadata = {element = 'slider', category = catCounts, indexInCategory = 5, description = 'Horizontal position offset for count text', min = -20, max = 20, stepSize = 1, dependency = {key = 'countShow', state = true}}}
defaults.countY = {value = 2, metadata = {element = 'slider', category = catCounts, indexInCategory = 6, description = 'Vertical position offset for count text', min = -20, max = 20, stepSize = 1, dependency = {key = 'countShow', state = true}}}

defaults.equippedBorderColour = {value = {0, 1, 0, 0.35}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 1, description = 'Set the color of equipped item border'}}
defaults.highlightColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 2, description = 'Set the color of button highlight'}}
defaults.checkedColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 3, description = 'Set the color of checked/active button'}}
defaults.usableColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 4, description = 'Color for usable actions'}}
defaults.unusableColour = {value = {0.4, 0.4, 0.4, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 5, description = 'Color for unusable actions'}}
defaults.manaColour = {value = {0.5, 0.5, 1, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 6, description = 'Color for out of mana/energy'}}
defaults.rangeColour = {value = {1, 0.1, 0.1, 1}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 7, description = 'Color for out of range'}}
defaults.reactiveEnabled = {value = true, metadata = {element = 'checkbox', category = catColors, indexInCategory = 8, description = 'Enable reactive spell highlighting'}}
defaults.reactiveColour = {value = {0, 1, 0, 0.8}, metadata = {element = 'colorpicker', category = catColors, indexInCategory = 9, description = 'Reactive spell highlight color', dependency = {key = 'reactiveEnabled', state = true}}}

defaults.clickMode = {value = 'up', metadata = {element = 'dropdown', category = catBehavior, indexInCategory = 1, description = 'Button click trigger mode', options = {'up', 'down'}}}
defaults.altSelfCast = {value = false, metadata = {element = 'checkbox', category = catBehavior, indexInCategory = 2, description = 'Alt key casts on self'}}
defaults.rightSelfCast = {value = false, metadata = {element = 'checkbox', category = catBehavior, indexInCategory = 3, description = 'Right click casts on self'}}
defaults.animationTrigger = {value = 'keypress', metadata = {element = 'dropdown', category = catBehavior, indexInCategory = 4, description = 'Animation trigger mode', options = {'none', 'keypress'}}}

-- Bar-specific overrides - customize individual bars here because easier to edit than loop exceptions
local barOverrides = {
    mainBar = {
        -- Main bar uses default button size because it matches multibar1 and multibar2
        gradientDirection = 'none',
        minAlpha = 0.4,
        -- Main bar gets paging buttons because it's the primary action bar
        hasPaging = true,
        -- Main bar gets background texture because it's not stance bar
        hasBgTexture = true,
        -- Main bar shows gryphons on both sides because it's the primary bar
        decorationPosition = 'both',
    },
    multibar1 = {
        -- Multi bar 1 uses default button size because it matches mainbar and multibar2
        gradientDirection = 'none',
        minAlpha = 0.4,
        hasBgTexture = true,
    },
    multibar2 = {
        -- Multi bar 2 uses default button size because it matches mainbar and multibar1
        gradientDirection = 'none',
        minAlpha = 0.4,
        hasBgTexture = true,
    },
    multibar3 = {
        -- Multi bar 3 gets smaller buttons because it's vertical on the right side
        buttonSize = 24,
        gradientDirection = 'none',
        minAlpha = 0.3,
        hasBgTexture = true,
        -- Multi bar 3 has 1 button per row because it's vertical
        buttonsPerRow = 1,
    },
    multibar4 = {
        -- Multi bar 4 is disabled because not needed
        enabled = false,
        buttonSize = 24,
        gradientDirection = 'none',
        minAlpha = 0.3,
        hasBgTexture = true,
        buttonsPerRow = 1,
    },
    multibar5 = {
        -- Multi bar 5 is disabled because not needed
        enabled = false,
        buttonSize = 24,
        gradientDirection = 'none',
        minAlpha = 0.3,
        hasBgTexture = true,
        buttonsPerRow = 1,
    },
    petBar = {
        -- Pet bar gets background texture because it's not stance bar
        hasBgTexture = true,
        buttonSize = 20,
    },
    stanceBar = {
        -- Stance bar doesn't get background texture because it's special
        hasBgTexture = false,
        buttonSize = 20,
    },
}

for i = 1, table.getn(barConfigs) do
    local bar = barConfigs[i]
    local catGeneral = bar.displayName..' General'
    local catLayout = bar.displayName..' Layout'
    local catVisibility = bar.displayName..' Visibility'
    local catDecorations = bar.displayName..' Decorations'
    local catAppearance = bar.displayName..' Appearance'
    table.insert(defaults.gui, {tab = 'actionbars', subtab = bar.subtab, catGeneral, catLayout, catVisibility, catDecorations, catAppearance})

    -- Get default values because all bars start with same base settings
    local buttonSize = 32
    local maxButtons = bar.maxButtons
    local isPetOrStance = bar.name == 'petBar' or bar.name == 'stanceBar'
    local gradientDirection = 'none'
    local minAlpha = 0.07
    local hasPaging = false
    local hasBgTexture = true
    local decorationPosition = 'none'
    local buttonsPerRow = maxButtons
    local enabled = true

    -- Apply bar-specific overrides because individual bars need custom settings
    local overrides = barOverrides[bar.name]
    if overrides then
        buttonSize = overrides.buttonSize or buttonSize
        gradientDirection = overrides.gradientDirection or gradientDirection
        minAlpha = overrides.minAlpha or minAlpha
        hasPaging = overrides.hasPaging or hasPaging
        hasBgTexture = overrides.hasBgTexture ~= nil and overrides.hasBgTexture or hasBgTexture
        decorationPosition = overrides.decorationPosition or decorationPosition
        buttonsPerRow = overrides.buttonsPerRow or buttonsPerRow
        enabled = overrides.enabled ~= nil and overrides.enabled or enabled
    end

    defaults[bar.name..'Enabled'] = {value = enabled, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 1, description = 'Toggle bar visibility'}}
    if not isPetOrStance then
        defaults[bar.name..'ButtonsToShow'] = {value = maxButtons, metadata = {element = 'slider', category = catGeneral, indexInCategory = 2, description = 'Number of buttons to show', min = 1, max = maxButtons, stepSize = 1, dependency = {key = bar.name..'Enabled', state = true}}}
        defaults[bar.name..'HideEmptyButtons'] = {value = false, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 3, description = 'Hide empty buttons', dependency = {key = bar.name..'Enabled', state = true}}}
        defaults[bar.name..'ConcatenateEnabled'] = {value = false, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 4, description = 'Auto-concatenate filled buttons', dependency = {{key = bar.name..'ButtonsPerRow', state = maxButtons}, {key = bar.name..'Enabled', state = true}}}}
        defaults[bar.name..'ConcatenateDirection'] = {value = 'left', metadata = {element = 'dropdown', category = catGeneral, indexInCategory = 5, description = 'Concatenate direction', options = {'left', 'right'}, dependency = {{key = bar.name..'ConcatenateEnabled', state = true}, {key = bar.name..'Enabled', state = true}}}}
    end
    defaults[bar.name..'ButtonsPerRow'] = {value = buttonsPerRow, metadata = {element = 'slider', category = catLayout, indexInCategory = 1, description = 'Buttons per row', min = 1, max = maxButtons, stepSize = 1, dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'ButtonSize'] = {value = buttonSize, metadata = {element = 'slider', category = catLayout, indexInCategory = 2, description = 'Button size in pixels', min = 20, max = 50, stepSize = 1, dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'ButtonSpacing'] = {value = 3, metadata = {element = 'slider', category = catLayout, indexInCategory = 3, description = 'Spacing between buttons', min = 0, max = 10, stepSize = 1, dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'Alpha'] = {value = 1, metadata = {element = 'slider', category = catVisibility, indexInCategory = 1, description = 'Bar transparency', min = 0, max = 1, stepSize = 0.1, dependency = {{key = bar.name..'FadeOutDelay', state = 0}, {key = bar.name..'GradientDirection', state = 'none'}, {key = bar.name..'Enabled', state = true}}}}
    defaults[bar.name..'FadeOutDelay'] = {value = 0, metadata = {element = 'slider', category = catVisibility, indexInCategory = 2, description = 'Fade out delay (0 = disabled)', min = 0, max = 10, stepSize = 0.5, dependency = {{key = bar.name..'GradientDirection', state = 'none'}, {key = bar.name..'Enabled', state = true}}}}
    defaults[bar.name..'GradientDirection'] = {value = gradientDirection, metadata = {element = 'dropdown', category = catVisibility, indexInCategory = 3, description = 'Gradient alpha direction', options = {'none', 'leftToRight', 'rightToLeft', 'centerOut'}, dependency = {{key = bar.name..'FadeOutDelay', state = 0}, {key = bar.name..'Enabled', state = true}}}}
    defaults[bar.name..'MinAlpha'] = {value = minAlpha, metadata = {element = 'slider', category = catVisibility, indexInCategory = 4, description = 'Minimum alpha for gradient', min = 0, max = 1, stepSize = 0.01, dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'DecorationTexture'] = {value = 'gryphon', metadata = {element = 'dropdown', category = catDecorations, indexInCategory = 1, description = 'Decoration texture', options = {'wyvern', 'gryphon', 'horde', 'alliance'}, dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'DecorationPosition'] = {value = decorationPosition, metadata = {element = 'dropdown', category = catDecorations, indexInCategory = 2, description = 'Decoration position', options = {'none', 'left', 'right', 'both'}, dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'DecorationSize'] = {value = 180, metadata = {element = 'slider', category = catDecorations, indexInCategory = 3, description = 'Decoration size', min = 20, max = 200, stepSize = 5, dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'DecorationColour'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catDecorations, indexInCategory = 4, description = 'Decoration color', dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'DecorationFlipped'] = {value = false, metadata = {element = 'checkbox', category = catDecorations, indexInCategory = 5, description = 'Flip decoration texture', dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'DecorationStrata'] = {value = 'BACKGROUND', metadata = {element = 'dropdown', category = catDecorations, indexInCategory = 6, description = 'Decoration frame strata', options = {'BACKGROUND', 'LOW', 'MEDIUM', 'HIGH', 'DIALOG', 'FULLSCREEN', 'FULLSCREEN_DIALOG', 'TOOLTIP'}, dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'DecorationX'] = {value = 45, metadata = {element = 'slider', category = catDecorations, indexInCategory = 7, description = 'Horizontal position offset for decorations', min = -20, max = 20, stepSize = 1, dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'DecorationY'] = {value = 0, metadata = {element = 'slider', category = catDecorations, indexInCategory = 8, description = 'Vertical position offset for decorations', min = -20, max = 20, stepSize = 1, dependency = {key = bar.name..'Enabled', state = true}}}

    -- Add background texture setting because most bars need it except stance bar
    if hasBgTexture then
        defaults[bar.name..'BgTexture'] = {value = 'alliance', metadata = {element = 'dropdown', category = catAppearance, indexInCategory = 1, description = 'Button background texture', options = {'alliance', 'horde'}, dependency = {key = bar.name..'Enabled', state = true}}}
    end

    defaults[bar.name..'BorderColour'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catAppearance, indexInCategory = 2, description = 'Button border color', dependency = {key = bar.name..'Enabled', state = true}}}
    defaults[bar.name..'BgColour'] = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catAppearance, indexInCategory = 3, description = 'Button background color', dependency = {key = bar.name..'Enabled', state = true}}}

    if bar.name == 'petBar' then
        defaults.petAutocastAlpha = {value = 0.8, metadata = {element = 'slider', category = catAppearance, indexInCategory = 4, description = 'Pet autocast alpha', min = 0, max = 1, stepSize = 0.1, dependency = {key = bar.name..'Enabled', state = true}}}
    end

    -- Add paging settings because only main bar needs them
    if hasPaging then
        defaults.pagingShow = {value = true, metadata = {element = 'checkbox', category = catGeneral, indexInCategory = 6, description = 'Show paging buttons'}}
        defaults.pagingButtonSize = {value = 20, metadata = {element = 'slider', category = catGeneral, indexInCategory = 7, description = 'Paging button size', min = 10, max = 40, stepSize = 1, dependency = {key = 'pagingShow', state = true}}}
        defaults.pagingFontSize = {value = 10, metadata = {element = 'slider', category = catGeneral, indexInCategory = 8, description = 'Paging number font size', min = 6, max = 20, stepSize = 1, dependency = {key = 'pagingShow', state = true}}}
        defaults.pagingColour = {value = {1, 1, 1, 1}, metadata = {element = 'colorpicker', category = catGeneral, indexInCategory = 9, description = 'Paging color (buttons and text)', dependency = {key = 'pagingShow', state = true}}}
    end
end

-- Apply any additional bar-specific overrides that weren't handled in the loop because some settings need post-processing
for barName, overrides in barOverrides do
    for settingName, value in overrides do
        local fullKey = barName .. string.upper(string.sub(settingName, 1, 1)) .. string.sub(settingName, 2)
        if defaults[fullKey] and defaults[fullKey].value ~= value then
            defaults[fullKey].value = value
        end
    end
end

DF:NewDefaults('actionbars', defaults)

DF:NewModule('actionbars', 1, 'PLAYER_LOGIN', function()
    local setup = DF.setups.actionbars

    function _G.MultiActionBar_Update() end
    DF.common.KillFrame(MainMenuBar)
    DF.common.KillFrame(MultiBarBottomLeft)
    DF.common.KillFrame(MultiBarBottomRight)
    DF.common.KillFrame(MultiBarLeft)
    DF.common.KillFrame(MultiBarRight)
    DF.common.KillFrame(BonusActionBarFrame)

    setup.mainBar = setup:CreateActionBar(UIParent, 'DF_MainBar', 12, 1)
    setup.mainBar:SetPoint('BOTTOM', UIParent, 'BOTTOM', -0, 95)
    setup:InitializeBar(setup.mainBar)

    setup.multiBars[1] = setup:CreateActionBar(UIParent, 'DF_MultiBar1', 12, 61)
    setup.multiBars[1]:SetPoint('BOTTOM', setup.mainBar, 'TOP', 0, 25)
    setup:InitializeBar(setup.multiBars[1])
    -- setup.multiBars[1]:Hide()

    setup.multiBars[2] = setup:CreateActionBar(UIParent, 'DF_MultiBar2', 12, 49)
    setup.multiBars[2]:SetPoint('TOP', setup.mainBar, 'BOTTOM', 0, -5)
    setup:InitializeBar(setup.multiBars[2])
    -- setup.multiBars[2]:Hide()

    setup.multiBars[3] = setup:CreateActionBar(UIParent, 'DF_MultiBar3', 12, 37)
    setup.multiBars[3]:SetPoint('RIGHT', UIParent, 'RIGHT', -10, -80)
    setup:InitializeBar(setup.multiBars[3])
    -- setup.multiBars[3]:Hide()

    setup.multiBars[4] = setup:CreateActionBar(UIParent, 'DF_MultiBar4', 12, 25)
    setup.multiBars[4]:SetPoint('RIGHT', setup.multiBars[3], 'LEFT', -5, 0)
    setup:InitializeBar(setup.multiBars[4])
    -- setup.multiBars[4]:Hide()

    setup.multiBars[5] = setup:CreateActionBar(UIParent, 'DF_MultiBar5', 12, 13)
    setup.multiBars[5]:SetPoint('RIGHT', setup.multiBars[4], 'LEFT', -5, -0)
    setup:InitializeBar(setup.multiBars[5])
    -- setup.multiBars[5]:Hide()

    for i = 1, 4 do
        setup.bonusBars[i] = setup:CreateActionBar(UIParent, 'DF_BonusBar'..i, 12, 61 + i * 12)
        setup.bonusBars[i]:SetPoint('CENTER', setup.mainBar, 'CENTER', 0, 0)
        setup:InitializeBar(setup.bonusBars[i])
        setup.bonusBars[i]:Hide()
        setup.bars['DF_BonusBar'..i] = setup.bonusBars[i]
    end

    setup.petBar = setup:CreateActionBar(UIParent, 'DF_PetBar', 10, 133)
    setup.petBar:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOM', -240, 8)
    setup:InitializeBar(setup.petBar)
    setup.petButtons = setup.petBar.buttons
    -- debugframe(setup.petBar)

    setup.stanceBar = setup:CreateActionBar(UIParent, 'DF_StanceBar', 10, 200)
    setup.stanceBar:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOM', -240, 8)
    setup:InitializeBar(setup.stanceBar)
    setup.stanceButtons = setup.stanceBar.buttons
    -- debugframe(setup.stanceBar)

    setup:CreatePagingButtons(setup.mainBar)
    setup.pagingContainer:SetPoint('RIGHT', setup.mainBar, 'LEFT', -10, 0)
    -- setup.pagingContainer:Hide()

    setup:CreateKeyboardRouting( -- TODO add petbar/stancebar ec.
        setup.mainBar.buttons,
        {setup.multiBars[1].buttons, setup.multiBars[2].buttons, setup.multiBars[3].buttons, setup.multiBars[4].buttons},
        {setup.bonusBars[1].buttons, setup.bonusBars[2].buttons, setup.bonusBars[3].buttons, setup.bonusBars[4].buttons}
    )

    setup:OnEvent()
    setup:UpdateBonusBarVisibility()
    setup:UpdatePetBarVisibility()
    setup:UpdateStanceBarVisibility()
    setup:UpdatePageableBars()

    DF.hooks.HookSecureFunc('PickupAction', function()
        setup:ShowAllButtons()
        setup.hideEmptyTimer = nil
    end)
    DF.hooks.HookSecureFunc('PickupSpell', function()
        setup:ShowAllButtons()
        setup.hideEmptyTimer = nil
    end)
    DF.hooks.HookSecureFunc('PickupItem', function()
        setup:ShowAllButtons()
        setup.hideEmptyTimer = nil
    end)

    -- callbacks
    local callbacks = {}
    local helpers = {}

    DF.setups.helpers = DF.setups.helpers or {}
    DF.setups.helpers.actionbars = helpers

    helpers.RepositionButtons = function(frame, buttons, buttonsPerRow, buttonSize, spacing)
        local buttonCount = table.getn(buttons)
        local rows = math.ceil(buttonCount / buttonsPerRow)
        for i = 1, buttonCount do
            buttons[i]:ClearAllPoints()
            local row = math.floor((i - 1) / buttonsPerRow)
            local col = math.mod(i - 1, buttonsPerRow)
            if i == 1 then
                buttons[i]:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, 0)
            else
                buttons[i]:SetPoint('TOPLEFT', frame, 'TOPLEFT', col * (buttonSize + spacing), -row * (buttonSize + spacing))
            end
        end
        frame:SetWidth(buttonsPerRow * buttonSize + (buttonsPerRow - 1) * spacing)
        frame:SetHeight(rows * buttonSize + (rows - 1) * spacing)
    end

    helpers.ApplyGradientAlpha = function(buttons, direction, minAlpha, countKey)
        local count = DF.profile['actionbars'][countKey] or table.getn(buttons)
        if direction == 'none' then
            for i = 1, count do
                buttons[i].baseAlpha = 1
                buttons[i]:SetAlpha(1)
            end
        elseif direction == 'leftToRight' then
            for i = 1, count do
                local alpha = minAlpha + ((i - 1) * (1 - minAlpha) / (count - 1))
                buttons[i].baseAlpha = alpha
                buttons[i]:SetAlpha(alpha)
            end
        elseif direction == 'rightToLeft' then
            for i = 1, count do
                local alpha = 1 - ((i - 1) * (1 - minAlpha) / (count - 1))
                buttons[i].baseAlpha = alpha
                buttons[i]:SetAlpha(alpha)
            end
        elseif direction == 'centerOut' then
            local center = (count + 1) / 2
            local maxDist = math.max(center - 1, count - center)
            for i = 1, count do
                local dist = math.abs(i - center)
                local alpha = 1 - (dist * (1 - minAlpha) / maxDist)
                buttons[i].baseAlpha = alpha
                buttons[i]:SetAlpha(alpha)
            end
        end
    end

    helpers.RestoreBarSettings = function(barName, barFrame)
        local buttonSize = DF.profile['actionbars'][barName..'ButtonSize']
        local buttonSpacing = DF.profile['actionbars'][barName..'ButtonSpacing']
        local buttonsPerRow = DF.profile['actionbars'][barName..'ButtonsPerRow']
        local buttonsToShow = DF.profile['actionbars'][barName..'ButtonsToShow']

        for i = 1, table.getn(barFrame.buttons) do
            barFrame.buttons[i]:SetWidth(buttonSize)
            barFrame.buttons[i]:SetHeight(buttonSize)
            barFrame.buttons[i]:SetParent(barFrame)
        end

        helpers.RepositionButtons(barFrame, barFrame.buttons, buttonsPerRow, buttonSize, buttonSpacing)

        for i = 1, 12 do
            if i <= buttonsToShow then
                barFrame.buttons[i]:Show()
            else
                barFrame.buttons[i]:Hide()
            end
        end

        if DF.profile['actionbars'][barName..'ConcatenateEnabled'] then
            helpers.UpdateBarConcatenate(barFrame, barName)
        end
    end

    helpers.ShowButtonTooltip = function(button)
        button.highlight:Show()
        GameTooltip:SetOwner(button, 'ANCHOR_RIGHT')
        local id = button:GetID()
        if id >= 200 and id <= 209 then
            GameTooltip:SetShapeshift(id - 199)
        elseif id >= 133 and id <= 142 then
            GameTooltip:SetPetAction(id - 132)
        else
            GameTooltip:SetAction(id)
        end
    end

    helpers.HideButtonTooltip = function(button)
        button.highlight:Hide()
        GameTooltip:Hide()
    end

    helpers.SetupBarFadeAndHighlight = function(frame, buttons, delayKey, alphaKey, countKey)
        local delay = DF.profile['actionbars'][delayKey]
        local count = DF.profile['actionbars'][countKey] or table.getn(buttons)
        if not frame.originalScriptsStored then
            for i = 1, count do
                buttons[i].originalOnEnter = buttons[i]:GetScript('OnEnter')
                buttons[i].originalOnLeave = buttons[i]:GetScript('OnLeave')
            end
            frame.originalScriptsStored = true
        end
        if delay > 0 then
            for i = 1, count do
                buttons[i]:SetScript('OnEnter', function()
                    if this.originalOnEnter then this.originalOnEnter() end
                    helpers.ShowButtonTooltip(this)
                    if frame.fadeTimer then
                        frame.fadeTimer = nil
                    end
                    UIFrameFadeIn(frame, 0.2, frame:GetAlpha(), DF.profile['actionbars'][alphaKey])
                end)
                buttons[i]:SetScript('OnLeave', function()
                    if this.originalOnLeave then this.originalOnLeave() end
                    helpers.HideButtonTooltip(this)
                    frame.fadeTimer = delay
                    frame:SetScript('OnUpdate', function()
                        if frame.fadeTimer then
                            frame.fadeTimer = frame.fadeTimer - arg1
                            if frame.fadeTimer <= 0 then
                                frame.fadeTimer = nil
                                frame:SetScript('OnUpdate', nil)
                                local minAlphaKey = string.gsub(alphaKey, 'Alpha$', 'MinAlpha')
                                UIFrameFadeOut(frame, 0.5, DF.profile['actionbars'][alphaKey], DF.profile['actionbars'][minAlphaKey])
                            end
                        end
                    end)
                end)
            end
            if not frame.fadeEnabled then
                local minAlphaKey = string.gsub(alphaKey, 'Alpha$', 'MinAlpha')
                UIFrameFadeOut(frame, 0.5, DF.profile['actionbars'][alphaKey], DF.profile['actionbars'][minAlphaKey])
            end
            frame.fadeEnabled = true
        else
            frame:SetScript('OnUpdate', nil)
            frame.fadeTimer = nil
            frame.fadeEnabled = nil
            for i = 1, count do
                buttons[i]:SetScript('OnEnter', function()
                    if this.originalOnEnter then this.originalOnEnter() end
                    helpers.ShowButtonTooltip(this)
                end)
                buttons[i]:SetScript('OnLeave', function()
                    if this.originalOnLeave then this.originalOnLeave() end
                    helpers.HideButtonTooltip(this)
                end)
            end
            frame:SetAlpha(DF.profile['actionbars'][alphaKey])
        end
    end

    helpers.RefreshAllButtons = function()
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                setup:UpdateButtonKeybind(bar.buttons[i])
                setup:UpdateButtonMacroText(bar.buttons[i])
                setup:UpdateButtonUsable(bar.buttons[i])
            end
        end
    end

    helpers.UpdateBarConcatenate = function(barFrame, barName)
        if not DF.profile['actionbars'][barName..'ConcatenateEnabled'] then return end
        if setup.isDragging then return end

        -- debugprint('UpdateBarConcatenate: barName='..barName..' barFrame='..tostring(barFrame:GetName())..' currentPageBar='..tostring(setup.currentPageBar and setup.currentPageBar:GetName() or 'nil'))
        assert(barFrame and barFrame.buttons, 'UpdateBarConcatenate: barFrame must have buttons')

        local buttonSize = DF.profile['actionbars'][barName..'ButtonSize']
        local spacing = DF.profile['actionbars'][barName..'ButtonSpacing']
        local buttonsToShow = DF.profile['actionbars'][barName..'ButtonsToShow']
        local direction = DF.profile['actionbars'][barName..'ConcatenateDirection']
        local buttons = barFrame.buttons

        local anchorFrame = buttons[1]:GetParent()
        if not anchorFrame then
            anchorFrame = barFrame
        end
        -- debugprint('UpdateBarConcatenate: anchorFrame='..tostring(anchorFrame:GetName()))
        assert(anchorFrame == buttons[1]:GetParent(), 'UpdateBarConcatenate: anchorFrame must match button parent')
        if barName == 'mainBar' and setup.currentPageBar and setup.currentPageBar ~= setup.mainBar then
            assert(anchorFrame == setup.mainBar, 'UpdateBarConcatenate: when paged, anchorFrame must be mainBar')
        end

        local filledButtons = {}
        for i = 1, buttonsToShow do
            if HasAction(buttons[i]:GetID()) then
                table.insert(filledButtons, buttons[i])
            end
        end

        local filledCount = table.getn(filledButtons)

        if not barFrame.animFrame then
            barFrame.animFrame = CreateFrame('Frame')
            barFrame.animFrame:Hide()
        end

        barFrame.animFrame.buttons = {}
        barFrame.animFrame.duration = 0.15
        barFrame.animFrame.elapsed = 0

        for i = 1, table.getn(buttons) do
            local btn = buttons[i]
            barFrame.animFrame.buttons[i] = {
                button = btn,
                startX = btn:GetLeft() and (btn:GetLeft() - anchorFrame:GetLeft()) or 0,
                targetX = nil,
                shouldShow = false
            }
        end

        if direction == 'left' then
            for i = 1, filledCount do
                local idx
                for j = 1, table.getn(buttons) do
                    if buttons[j] == filledButtons[i] then
                        idx = j
                        break
                    end
                end
                if idx then
                    barFrame.animFrame.buttons[idx].targetX = (i - 1) * (buttonSize + spacing)
                    barFrame.animFrame.buttons[idx].shouldShow = true
                end
            end
        else
            for i = 1, filledCount do
                local idx
                for j = 1, table.getn(buttons) do
                    if buttons[j] == filledButtons[i] then
                        idx = j
                        break
                    end
                end
                if idx then
                    barFrame.animFrame.buttons[idx].targetX = (buttonsToShow - filledCount + i - 1) * (buttonSize + spacing)
                    barFrame.animFrame.buttons[idx].shouldShow = true
                end
            end
        end

        barFrame.animFrame.anchorFrame = anchorFrame
        barFrame.animFrame:SetScript('OnUpdate', function()
            this.elapsed = this.elapsed + arg1
            local progress = math.min(this.elapsed / this.duration, 1)

            for i = 1, table.getn(this.buttons) do
                local data = this.buttons[i]
                if data.targetX then
                    local currentX = data.startX + (data.targetX - data.startX) * progress
                    data.button:ClearAllPoints()
                    data.button:SetPoint('TOPLEFT', this.anchorFrame, 'TOPLEFT', currentX, 0)
                    if data.shouldShow then
                        data.button:Show()
                    end
                else
                    data.button:Hide()
                end
            end

            if progress >= 1 then
                this:SetScript('OnUpdate', nil)
                this:Hide()
            end
        end)

        barFrame.animFrame:Show()
    end

    callbacks.abbreviateMacroNames = function(value)
        setup.abbreviateMacroNames = value
        helpers.RefreshAllButtons()
    end

    callbacks.rangeIndicatorMode = function(value)
        setup.rangeIndicator = value
        helpers.RefreshAllButtons()
    end

    callbacks.showKeybindsOnEmpty = function(value)
        setup.showKeybindsOnEmpty = value
        helpers.RefreshAllButtons()
    end

    callbacks.hotkeyShow = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                if value then bar.buttons[i].keybind:Show() else bar.buttons[i].keybind:Hide() end
            end
        end
    end

    callbacks.hotkeyFont = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].keybind:SetFont(media[value], DF.profile['actionbars']['hotkeyFontSize'], 'OUTLINE')
            end
        end
    end

    callbacks.hotkeyFontSize = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].keybind:SetFont(media[DF.profile['actionbars']['hotkeyFont']], value, 'OUTLINE')
                -- bar.buttons[i].rangeDot:SetFont(media[DF.profile['actionbars']['hotkeyFont']], value +4, 'OUTLINE')
            end
        end
    end

    callbacks.hotkeyColour = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].keybind:SetTextColor(value[1], value[2], value[3], value[4])
            end
        end
    end

    callbacks.hotkeyX = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].keybind:ClearAllPoints()
                bar.buttons[i].keybind:SetPoint('TOPRIGHT', bar.buttons[i], 'TOPRIGHT', value, DF.profile['actionbars']['hotkeyY'])
            end
        end
    end

    callbacks.hotkeyY = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].keybind:ClearAllPoints()
                bar.buttons[i].keybind:SetPoint('TOPRIGHT', bar.buttons[i], 'TOPRIGHT', DF.profile['actionbars']['hotkeyX'], value)
            end
        end
    end

    callbacks.macroShow = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                if value then bar.buttons[i].macroText:Show() else bar.buttons[i].macroText:Hide() end
            end
        end
    end

    callbacks.macroFont = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].macroText:SetFont(media[value], DF.profile['actionbars']['macroFontSize'], 'OUTLINE')
            end
        end
    end

    callbacks.macroFontSize = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].macroText:SetFont(media[DF.profile['actionbars']['macroFont']], value, 'OUTLINE')
            end
        end
    end

    callbacks.macroColour = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].macroText:SetTextColor(value[1], value[2], value[3], value[4])
            end
        end
    end

    callbacks.macroX = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].macroText:ClearAllPoints()
                bar.buttons[i].macroText:SetPoint('BOTTOM', bar.buttons[i], 'BOTTOM', value, DF.profile['actionbars']['macroY'])
            end
        end
    end

    callbacks.macroY = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].macroText:ClearAllPoints()
                bar.buttons[i].macroText:SetPoint('BOTTOM', bar.buttons[i], 'BOTTOM', DF.profile['actionbars']['macroX'], value)
            end
        end
    end

    callbacks.countShow = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                if value then bar.buttons[i].count:Show() else bar.buttons[i].count:Hide() end
            end
        end
    end

    callbacks.countFont = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].count:SetFont(media[value], DF.profile['actionbars']['countFontSize'], 'OUTLINE')
            end
        end
    end

    callbacks.countFontSize = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].count:SetFont(media[DF.profile['actionbars']['countFont']], value, 'OUTLINE')
            end
        end
    end

    callbacks.countColour = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].count:SetTextColor(value[1], value[2], value[3], value[4])
            end
        end
    end

    callbacks.countX = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].count:ClearAllPoints()
                bar.buttons[i].count:SetPoint('BOTTOMRIGHT', bar.buttons[i], 'BOTTOMRIGHT', value, DF.profile['actionbars']['countY'])
            end
        end
    end

    callbacks.countY = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].count:ClearAllPoints()
                bar.buttons[i].count:SetPoint('BOTTOMRIGHT', bar.buttons[i], 'BOTTOMRIGHT', DF.profile['actionbars']['countX'], value)
            end
        end
    end

    callbacks.equippedBorderColour = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].equippedBorder:SetBackdropBorderColor(value[1], value[2], value[3], value[4])
            end
        end
    end

    callbacks.highlightColour = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].highlightTex:SetVertexColor(value[1], value[2], value[3], value[4])
            end
        end
    end

    callbacks.checkedColour = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                bar.buttons[i].checkedTex:SetVertexColor(value[1], value[2], value[3], value[4])
            end
        end
    end

    callbacks.usableColour = function(value)
        helpers.RefreshAllButtons()
    end

    callbacks.unusableColour = function(value)
        helpers.RefreshAllButtons()
    end

    callbacks.manaColour = function(value)
        helpers.RefreshAllButtons()
    end

    callbacks.rangeColour = function(value)
        helpers.RefreshAllButtons()
    end

    callbacks.clickMode = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                if value == 'down' then
                    bar.buttons[i]:RegisterForClicks('LeftButtonDown', 'RightButtonDown')
                else
                    bar.buttons[i]:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
                end
            end
        end
    end

    callbacks.altSelfCast = function(value)
    end

    callbacks.rightSelfCast = function(value)
    end

    callbacks.animationTrigger = function(value)
    end

    callbacks.reactiveEnabled = function(value)
        setup.reactiveEnabled = value
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                if value then
                    setup:UpdateButtonReactive(bar.buttons[i])
                else
                    bar.buttons[i].reactive:Hide()
                end
            end
        end
    end

    callbacks.reactiveColour = function(value)
        for _, bar in setup.bars do
            for i = 1, table.getn(bar.buttons) do
                local reactiveTex = bar.buttons[i].reactive:GetRegions()
                if reactiveTex then
                    reactiveTex:SetVertexColor(value[1], value[2], value[3], value[4])
                end
            end
        end
    end

    callbacks.petAutocastAlpha = function(value)
        for i = 1, table.getn(setup.petButtons) do
            if setup.petButtons[i].autocast then
                setup.petButtons[i].autocast:SetAlpha(value)
            end
        end
    end

    callbacks.pagingShow = function(value)
        if value then setup.pagingContainer:Show() else setup.pagingContainer:Hide() end
    end

    callbacks.pagingButtonSize = function(value)
        setup.pagingUp:SetSize(value, value)
        setup.pagingDown:SetSize(value, value)
        setup.pagingContainer:SetSize(value, value * 3)
    end

    callbacks.pagingFontSize = function(value)
        setup.pagingNumber:SetFont('Fonts\\FRIZQT__.TTF', value, 'OUTLINE')
    end

    callbacks.pagingColour = function(value)
        setup.pagingNumber:SetTextColor(value[1], value[2], value[3], value[4])
        setup.pagingUp:GetNormalTexture():SetVertexColor(value[1], value[2], value[3], value[4])
        setup.pagingUp:GetPushedTexture():SetVertexColor(value[1], value[2], value[3], value[4])
        setup.pagingUp:GetHighlightTexture():SetVertexColor(value[1], value[2], value[3], value[4])
        setup.pagingDown:GetNormalTexture():SetVertexColor(value[1], value[2], value[3], value[4])
        setup.pagingDown:GetPushedTexture():SetVertexColor(value[1], value[2], value[3], value[4])
        setup.pagingDown:GetHighlightTexture():SetVertexColor(value[1], value[2], value[3], value[4])
    end

    local barFrames = {
        {name = 'mainBar', frame = setup.mainBar},
        {name = 'multibar1', frame = setup.multiBars[1]},
        {name = 'multibar2', frame = setup.multiBars[2]},
        {name = 'multibar3', frame = setup.multiBars[3]},
        {name = 'multibar4', frame = setup.multiBars[4]},
        {name = 'multibar5', frame = setup.multiBars[5]},
        {name = 'petBar', frame = setup.petBar},
        {name = 'stanceBar', frame = setup.stanceBar},
    }

    for _, bar in barFrames do
        local barName = bar.name
        local barFrame = bar.frame

        callbacks[barName..'Enabled'] = function(value)
            if barName == 'petBar' then
                setup:UpdatePetBarVisibility()
            elseif barName == 'stanceBar' then
                setup:UpdateStanceBarVisibility()
            else
                if value then
                    if setup.currentPageBar == barFrame then
                        setup:UpdatePage(1 - setup.currentPage)
                    end
                    helpers.RestoreBarSettings(barName, barFrame)
                    barFrame:Show()
                else
                    barFrame:Hide()
                end
                setup:UpdatePageableBars()
            end
        end

        if barName ~= 'petBar' and barName ~= 'stanceBar' then
            callbacks[barName..'HideEmptyButtons'] = function(value)
                setup:HideEmptyButtons()
            end
        end

        callbacks[barName..'ButtonsPerRow'] = function(value)
            if barName ~= 'mainBar' and barName ~= 'petBar' and barName ~= 'stanceBar' and not DF.profile['actionbars'][barName..'Enabled'] then return end
            helpers.RepositionButtons(barFrame, barFrame.buttons, value, DF.profile['actionbars'][barName..'ButtonSize'], DF.profile['actionbars'][barName..'ButtonSpacing'])
            if barName == 'mainBar' then
                for i = 1, 4 do
                    helpers.RepositionButtons(setup.bonusBars[i], setup.bonusBars[i].buttons, value, DF.profile['actionbars'][barName..'ButtonSize'], DF.profile['actionbars'][barName..'ButtonSpacing'])
                end
            end
            if barName ~= 'petBar' and barName ~= 'stanceBar' then
                helpers.UpdateBarConcatenate(barFrame, barName)
            end
        end

        callbacks[barName..'ButtonSize'] = function(value)
            if barName ~= 'mainBar' and barName ~= 'petBar' and barName ~= 'stanceBar' and not DF.profile['actionbars'][barName..'Enabled'] then return end
            for i = 1, table.getn(barFrame.buttons) do
                barFrame.buttons[i]:SetWidth(value)
                barFrame.buttons[i]:SetHeight(value)
                if barName == 'petBar' and barFrame.buttons[i].autocast then
                    barFrame.buttons[i].autocast:ClearAllPoints()
                    -- barFrame.buttons[i].autocast:SetPoint('TOPLEFT', barFrame.buttons[i], 'TOPLEFT', 0, 0)
                    -- barFrame.buttons[i].autocast:SetPoint('BOTTOMRIGHT', barFrame.buttons[i], 'BOTTOMRIGHT', 0, 0)
                    barFrame.buttons[i].autocast:SetAllPoints(barFrame.buttons[i])
                    barFrame.buttons[i].autocast:SetScale(value / 25)
                    -- debugframe(barFrame.buttons[i])
                    -- debugframe(barFrame.buttons[i].autocast)
                    -- print"asd"
                end
            end
            helpers.RepositionButtons(barFrame, barFrame.buttons, DF.profile['actionbars'][barName..'ButtonsPerRow'], value, DF.profile['actionbars'][barName..'ButtonSpacing'])
            if barName == 'mainBar' then
                for i = 1, 4 do
                    for j = 1, table.getn(setup.bonusBars[i].buttons) do
                        setup.bonusBars[i].buttons[j]:SetWidth(value)
                        setup.bonusBars[i].buttons[j]:SetHeight(value)
                    end
                    helpers.RepositionButtons(setup.bonusBars[i], setup.bonusBars[i].buttons, DF.profile['actionbars'][barName..'ButtonsPerRow'], value, DF.profile['actionbars'][barName..'ButtonSpacing'])
                end
            end
            if barName ~= 'petBar' and barName ~= 'stanceBar' then
                helpers.UpdateBarConcatenate(barFrame, barName)
            end
        end

        callbacks[barName..'ButtonSpacing'] = function(value)
            if barName ~= 'mainBar' and barName ~= 'petBar' and barName ~= 'stanceBar' and not DF.profile['actionbars'][barName..'Enabled'] then return end
            helpers.RepositionButtons(barFrame, barFrame.buttons, DF.profile['actionbars'][barName..'ButtonsPerRow'], DF.profile['actionbars'][barName..'ButtonSize'], value)
            if barName == 'mainBar' then
                for i = 1, 4 do
                    helpers.RepositionButtons(setup.bonusBars[i], setup.bonusBars[i].buttons, DF.profile['actionbars'][barName..'ButtonsPerRow'], DF.profile['actionbars'][barName..'ButtonSize'], value)
                end
            end
            if barName ~= 'petBar' and barName ~= 'stanceBar' then
                helpers.UpdateBarConcatenate(barFrame, barName)
            end
        end

        callbacks[barName..'Alpha'] = function(value)
            if DF.profile['actionbars'][barName..'FadeOutDelay'] == 0 then
                barFrame:SetAlpha(value)
            end
        end

        callbacks[barName..'FadeOutDelay'] = function(value)
            helpers.SetupBarFadeAndHighlight(barFrame, barFrame.buttons, barName..'FadeOutDelay', barName..'Alpha', barName..'ButtonsToShow')
            if barName == 'mainBar' then
                for i = 1, 4 do
                    helpers.SetupBarFadeAndHighlight(setup.bonusBars[i], setup.bonusBars[i].buttons, barName..'FadeOutDelay', barName..'Alpha', barName..'ButtonsToShow')
                end
            end
        end

        callbacks[barName..'GradientDirection'] = function(value)
            helpers.ApplyGradientAlpha(barFrame.buttons, value, DF.profile['actionbars'][barName..'MinAlpha'], barName..'ButtonsToShow')
            if barName == 'mainBar' then
                for i = 1, 4 do
                    helpers.ApplyGradientAlpha(setup.bonusBars[i].buttons, value, DF.profile['actionbars'][barName..'MinAlpha'], barName..'ButtonsToShow')
                end
            end
        end

        callbacks[barName..'MinAlpha'] = function(value)
            helpers.ApplyGradientAlpha(barFrame.buttons, DF.profile['actionbars'][barName..'GradientDirection'], value, barName..'ButtonsToShow')
            if barName == 'mainBar' then
                for i = 1, 4 do
                    helpers.ApplyGradientAlpha(setup.bonusBars[i].buttons, DF.profile['actionbars'][barName..'GradientDirection'], value, barName..'ButtonsToShow')
                end
            end
        end

        if barName ~= 'petBar' and barName ~= 'stanceBar' then
            callbacks[barName..'ButtonsToShow'] = function(value)
                if barName ~= 'mainBar' and not DF.profile['actionbars'][barName..'Enabled'] then return end
                for i = 1, 12 do
                    if i <= value then
                        barFrame.buttons[i]:Show()
                    else
                        barFrame.buttons[i]:Hide()
                    end
                end
                helpers.ApplyGradientAlpha(barFrame.buttons, DF.profile['actionbars'][barName..'GradientDirection'], DF.profile['actionbars'][barName..'MinAlpha'], barName..'ButtonsToShow')
                helpers.SetupBarFadeAndHighlight(barFrame, barFrame.buttons, barName..'FadeOutDelay', barName..'Alpha', barName..'ButtonsToShow')
                helpers.UpdateBarConcatenate(barFrame, barName)
            end

            callbacks[barName..'ConcatenateEnabled'] = function(value)
                if barName ~= 'mainBar' and not DF.profile['actionbars'][barName..'Enabled'] then return end
                local targetFrame = barFrame
                if barName == 'mainBar' and setup.currentPageBar and setup.currentPageBar ~= setup.mainBar then
                    targetFrame = setup.currentPageBar
                end
                if value then
                    helpers.UpdateBarConcatenate(targetFrame, barName)
                else
                    helpers.RepositionButtons(targetFrame, targetFrame.buttons, DF.profile['actionbars'][barName..'ButtonsPerRow'], DF.profile['actionbars'][barName..'ButtonSize'], DF.profile['actionbars'][barName..'ButtonSpacing'])
                    for i = 1, 12 do
                        if i <= DF.profile['actionbars'][barName..'ButtonsToShow'] then
                            targetFrame.buttons[i]:Show()
                        else
                            targetFrame.buttons[i]:Hide()
                        end
                    end
                end
            end

            callbacks[barName..'ConcatenateDirection'] = function(value)
                if barName ~= 'mainBar' and not DF.profile['actionbars'][barName..'Enabled'] then return end
                local targetFrame = barFrame
                if barName == 'mainBar' and setup.currentPageBar and setup.currentPageBar ~= setup.mainBar then
                    targetFrame = setup.currentPageBar
                end
                helpers.UpdateBarConcatenate(targetFrame, barName)
            end
        end

        callbacks[barName..'DecorationTexture'] = function(value)
            setup:UpdateBarDecorations(barFrame, value, DF.profile['actionbars'][barName..'DecorationPosition'])
        end

        callbacks[barName..'DecorationPosition'] = function(value)
            setup:UpdateBarDecorations(barFrame, DF.profile['actionbars'][barName..'DecorationTexture'], value)
        end

        callbacks[barName..'DecorationSize'] = function(value)
            barFrame.decorationLeftFrame:SetSize(value, value)
            barFrame.decorationRightFrame:SetSize(value, value)
        end

        callbacks[barName..'DecorationColour'] = function(value)
            barFrame.decorationLeft:SetVertexColor(value[1], value[2], value[3], value[4])
            barFrame.decorationRight:SetVertexColor(value[1], value[2], value[3], value[4])
        end

        callbacks[barName..'DecorationFlipped'] = function(value)
            if value then
                barFrame.decorationLeft:SetTexCoord(1, 0, 0, 1)
                barFrame.decorationRight:SetTexCoord(0, 1, 0, 1)
            else
                barFrame.decorationLeft:SetTexCoord(0, 1, 0, 1)
                barFrame.decorationRight:SetTexCoord(1, 0, 0, 1)
            end
        end

        callbacks[barName..'DecorationStrata'] = function(value)
            if barFrame.decorationLeftFrame then
                barFrame.decorationLeftFrame:SetFrameStrata(value)
            end
            if barFrame.decorationRightFrame then
                barFrame.decorationRightFrame:SetFrameStrata(value)
            end
        end

        callbacks[barName..'DecorationX'] = function(value)
            if barFrame.decorationLeftFrame then
                barFrame.decorationLeftFrame:ClearAllPoints()
                barFrame.decorationLeftFrame:SetPoint('RIGHT', barFrame, 'LEFT', value, DF.profile['actionbars'][barName..'DecorationY'])
            end
            if barFrame.decorationRightFrame then
                barFrame.decorationRightFrame:ClearAllPoints()
                barFrame.decorationRightFrame:SetPoint('LEFT', barFrame, 'RIGHT', -value, DF.profile['actionbars'][barName..'DecorationY'])
            end
        end

        callbacks[barName..'DecorationY'] = function(value)
            if barFrame.decorationLeftFrame then
                barFrame.decorationLeftFrame:ClearAllPoints()
                barFrame.decorationLeftFrame:SetPoint('RIGHT', barFrame, 'LEFT', DF.profile['actionbars'][barName..'DecorationX'], value)
            end
            if barFrame.decorationRightFrame then
                barFrame.decorationRightFrame:ClearAllPoints()
                barFrame.decorationRightFrame:SetPoint('LEFT', barFrame, 'RIGHT', -DF.profile['actionbars'][barName..'DecorationX'], value)
            end
        end

        if barName ~= 'stanceBar' then
            callbacks[barName..'BgTexture'] = function(value)
                local texPath = value == 'alliance' and setup.textures.bgAlly or setup.textures.bgHorde
                for i = 1, table.getn(barFrame.buttons) do
                    if barFrame.buttons[i].factionBg then
                        barFrame.buttons[i].factionBg:SetTexture(texPath)
                    end
                end
            end
        end

        callbacks[barName..'BorderColour'] = function(value)
            for i = 1, table.getn(barFrame.buttons) do
                local borderTex = barFrame.buttons[i].border:GetRegions()
                if borderTex then
                    borderTex:SetVertexColor(value[1], value[2], value[3], value[4])
                end
            end
        end

        callbacks[barName..'BgColour'] = function(value)
            for i = 1, table.getn(barFrame.buttons) do
                local btn = barFrame.buttons[i]
                if btn.factionBg then
                    btn.factionBg:SetVertexColor(value[1], value[2], value[3], value[4])
                elseif btn.bg then
                    btn.bg:SetVertexColor(value[1], value[2], value[3], value[4])
                end
            end
        end
    end

    DF:NewCallbacks('actionbars', callbacks)
end)
