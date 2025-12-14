UNLOCKAURORA()

-- Defaults gui structure: {tab = 'tabname', subtab = 'subtabname', 'category1', 'category2', ...}
-- Named keys (tab, subtab) define panel location, array elements define categories within that panel
-- Each category groups related settings with a header, settings use category + indexInCategory for ordering

AU:NewDefaults('template', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'template', subtab = 'mainbar', categories = 'General'},
    },

    templateprint = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'template print description'}},



    -- examples:
    -- animationTexture = {value = 'Aura1', metadata = {element = 'dropdown', category = 'Animation', indexInCategory = 2, description = 'Animation texture style', options = {'Aura1', 'Aura2', 'Aura3', 'Aura4', 'Glow1', 'Glow2', 'Shock1', 'Shock2', 'Shock3'}, dependency = {key = 'minimapAnimation', state = true}}},
    -- customPlayerArrow = {value = true, metadata = {element = 'checkbox', category = 'Arrow', indexInCategory = 1, description = 'Use Dragonflight\'s custom player arrow', dependency = {key = 'showMinimap', state = true}}},
    -- playerArrowScale = {value = 1, metadata = {element = 'slider', category = 'Arrow', indexInCategory = 3, description = 'Size of the player arrow', min = 0.5, max = 2, stepSize = 0.1, dependency = {key = 'showMinimap', state = true}}},
    -- playerArrowColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Arrow', indexInCategory = 4, description = 'Color of the player arrow', dependency = {key = 'customPlayerArrow', state = true}}},

})

AU:NewModule('template', 1, function()
    -- Aurora Module System Flow:
    -- ApplyDefaults() populates AU.profile[module][option] with default values from AU.defaults
    -- ExecModules() loads modules by calling each enabled module's func() based on priority
    -- Module's func() creates UI/features and calls NewCallbacks() as its last step
    -- NewCallbacks() registers callbacks and immediately executes them with current AU_GlobalDB values to initialize module state
    -- GUI changes trigger SetConfig() which updates AU_GlobalDB then re-executes the callback with new value


    -- callbacks
    local callbacks = {}
    local callbackHelper = {definesomethinginheredirectly}

    callbacks.templateprint = function(value)
        if value then
            print('template print from AU!')
        end
    end

    AU:NewCallbacks('template', callbacks)
end)
