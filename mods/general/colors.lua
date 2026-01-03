DRAGONFLIGHT()

DF:NewDefaults('colors', {
    enabled = {value = true},
    version = {value = '1.0'},
    -- defaults gui structure: {tab = 'tabname', subtab = 'subtabname', 'category1', 'category2', ...}
    -- Named keys (tab, subtab) define panel location, array elements define categories within that panel
    -- Each category groups related settings with a header, settings use category + indexInCategory for ordering
    gui = {
        {tab = 'general', subtab = 'colors', 'Class Colors'},
    },

    colorWarrior = {value = {0.78, 0.61, 0.43}, metadata = {element = 'colorpicker', category = 'Class Colors', indexInCategory = 1, description = 'Warrior class color'}},
    colorMage = {value = {0.41, 0.8, 0.94}, metadata = {element = 'colorpicker', category = 'Class Colors', indexInCategory = 2, description = 'Mage class color'}},
    colorRogue = {value = {1, 0.96, 0.41}, metadata = {element = 'colorpicker', category = 'Class Colors', indexInCategory = 3, description = 'Rogue class color'}},
    colorDruid = {value = {1, 0.49, 0.04}, metadata = {element = 'colorpicker', category = 'Class Colors', indexInCategory = 4, description = 'Druid class color'}},
    colorHunter = {value = {0.67, 0.83, 0.45}, metadata = {element = 'colorpicker', category = 'Class Colors', indexInCategory = 5, description = 'Hunter class color'}},
    colorShaman = {value = {0.14, 0.35, 1.0}, metadata = {element = 'colorpicker', category = 'Class Colors', indexInCategory = 6, description = 'Shaman class color'}},
    colorPriest = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Class Colors', indexInCategory = 7, description = 'Priest class color'}},
    colorWarlock = {value = {0.58, 0.51, 0.79}, metadata = {element = 'colorpicker', category = 'Class Colors', indexInCategory = 8, description = 'Warlock class color'}},
    colorPaladin = {value = {0.96, 0.55, 0.73}, metadata = {element = 'colorpicker', category = 'Class Colors', indexInCategory = 9, description = 'Paladin class color'}},

})

DF:NewModule('colors', 1, function()
    -- dragonflight module system flow:
    -- ApplyDefaults() populates DF.profile[module][option] with default values from DF.defaults
    -- ExecModules() loads modules by calling each enabled module's func() based on priority
    -- module's func() creates UI/features and calls NewCallbacks() as its last step
    -- NewCallbacks() registers callbacks and immediately executes them with current DF_Profiles values to initialize module state
    -- gui changes trigger SetConfig() which updates DF_Profiles then re-executes the callback with new value

    -- base structure area for base module setup

    -- callbacks area are options that show up for the user in the gui
    local callbacks = {}
    local callbackHelper = {} -- helper table for shared functions only

    callbackHelper.UpdateUnitFrameColors = function(className)
        if DF.setups.unitframes and DF.setups.unitframes.portraits then
            for i = 1, table.getn(DF.setups.unitframes.portraits) do
                local portrait = DF.setups.unitframes.portraits[i]
                if UnitExists(portrait.unit) and UnitIsPlayer(portrait.unit) then
                    local _, class = UnitClass(portrait.unit)
                    if class == className then
                        DF.setups.unitframes:UpdateHealthBarColor(portrait, portrait.unit)
                    end
                end
            end
        end
    end

    callbacks.colorWarrior = function(value) DF.tables.classcolors['WARRIOR'] = value callbackHelper.UpdateUnitFrameColors('WARRIOR') end
    callbacks.colorMage = function(value) DF.tables.classcolors['MAGE'] = value callbackHelper.UpdateUnitFrameColors('MAGE') end
    callbacks.colorRogue = function(value) DF.tables.classcolors['ROGUE'] = value callbackHelper.UpdateUnitFrameColors('ROGUE') end
    callbacks.colorDruid = function(value) DF.tables.classcolors['DRUID'] = value callbackHelper.UpdateUnitFrameColors('DRUID') end
    callbacks.colorHunter = function(value) DF.tables.classcolors['HUNTER'] = value callbackHelper.UpdateUnitFrameColors('HUNTER') end
    callbacks.colorShaman = function(value) DF.tables.classcolors['SHAMAN'] = value callbackHelper.UpdateUnitFrameColors('SHAMAN') end
    callbacks.colorPriest = function(value) DF.tables.classcolors['PRIEST'] = value callbackHelper.UpdateUnitFrameColors('PRIEST') end
    callbacks.colorWarlock = function(value) DF.tables.classcolors['WARLOCK'] = value callbackHelper.UpdateUnitFrameColors('WARLOCK') end
    callbacks.colorPaladin = function(value) DF.tables.classcolors['PALADIN'] = value callbackHelper.UpdateUnitFrameColors('PALADIN') end

    DF:NewCallbacks('colors', callbacks)
end)
