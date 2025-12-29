UNLOCKDRAGONFLIGHT()

DF:NewDefaults('tweaks', {
    enabled = {value = true},
    version = {value = '1.0'},
    -- defaults gui structure: {tab = 'tabname', subtab = 'subtabname', 'category1', 'category2', ...}
    -- Named keys (tab, subtab) define panel location, array elements define categories within that panel
    -- Each category groups related settings with a header, settings use category + indexInCategory for ordering
    gui = {
        {tab = 'general', subtab = 'automation', 'General'},
    },

    -- defaults examples:
    -- animationTexture = {value = 'Aura1', metadata = {element = 'dropdown', category = 'Animation', indexInCategory = 2, description = 'Animation texture style', options = {'Aura1', 'Aura2', 'Aura3', 'Aura4', 'Glow1', 'Glow2', 'Shock1', 'Shock2', 'Shock3'}, dependency = {key = 'minimapAnimation', state = true}}},
    -- customPlayerArrow = {value = true, metadata = {element = 'checkbox', category = 'Arrow', indexInCategory = 1, description = 'Use Dragonflight\'s custom player arrow', dependency = {key = 'showMinimap', state = true}}},
    -- playerArrowScale = {value = 1, metadata = {element = 'slider', category = 'Arrow', indexInCategory = 3, description = 'Size of the player arrow', min = 0.5, max = 2, stepSize = 0.1, dependency = {key = 'showMinimap', state = true}}},
    -- playerArrowColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Arrow', indexInCategory = 4, description = 'Color of the player arrow', dependency = {key = 'customPlayerArrow', state = true}}},
    stanceDancing = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Automatically switch stance when casting spells'}},
    autoForm = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 2, description = 'Extend stance dancing to cancel active forms for druids and rogues', dependency = {key = 'stanceDancing', state = true}}},
    autoDismount = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 3, description = 'Automatically dismount when casting spells'}},

})

DF:NewModule('tweaks', 1, function()
    -- dragonflight module system flow:
    -- ApplyDefaults() populates DF.profile[module][option] with default values from DF.defaults
    -- ExecModules() loads modules by calling each enabled module's func() based on priority
    -- module's func() creates UI/features and calls NewCallbacks() as its last step
    -- NewCallbacks() registers callbacks and immediately executes them with current DF_Profiles values to initialize module state
    -- gui changes trigger SetConfig() which updates DF_Profiles then re-executes the callback with new value

    -- base structure area
    local stancedance = CreateFrame('Frame')
    stancedance.scanString = string.gsub(SPELL_FAILED_ONLY_SHAPESHIFT, '%%s', '(.+)')
    stancedance.formString = SPELL_FAILED_NOT_SHAPESHIFT

    local dismount = CreateFrame('Frame')
    dismount.mountStrings = {'Increases speed by', 'speed based on', 'Slow and steady', 'Riding'}
    dismount.shapeshiftTextures = {'ability_racial_bearform', 'ability_druid_catform', 'ability_druid_travelform', 'spell_nature_forceofnature', 'ability_druid_aquaticform', 'spell_nature_spiritwolf'}
    dismount.dismountErrors = {SPELL_FAILED_NOT_MOUNTED, ERR_ATTACK_MOUNTED, ERR_TAXIPLAYERALREADYMOUNTED, SPELL_FAILED_NOT_SHAPESHIFT, SPELL_FAILED_NO_ITEMS_WHILE_SHAPESHIFTED, SPELL_NOT_SHAPESHIFTED, SPELL_NOT_SHAPESHIFTED_NOSPACE, ERR_CANT_INTERACT_SHAPESHIFTED, ERR_NOT_WHILE_SHAPESHIFTED, ERR_NO_ITEMS_WHILE_SHAPESHIFTED, ERR_TAXIPLAYERSHAPESHIFTED, ERR_MOUNT_SHAPESHIFTED}
    dismount.scanner = DF.lib.libtipscan:GetScanner('dismount')

    -- callbacks are options that show up for the user in the gui
    local callbacks = {}
    local callbackHelper = {} -- helper table for shared functions only

    callbacks.stanceDancing = function(value)
        if value then
            stancedance:RegisterEvent('UI_ERROR_MESSAGE')
            stancedance:SetScript('OnEvent', function()
                for stances in string.gfind(arg1, stancedance.scanString) do
                    for _, stance in pairs(DF.data.split(stances, ',')) do
                        CastSpellByName(string.gsub(stance, '^%s*(.-)%s*$', '%1'))
                    end
                end
                if DF.profile.tweaks.autoForm and arg1 == stancedance.formString then
                    for i = 1, GetNumShapeshiftForms() do
                        local _, _, isActive = GetShapeshiftFormInfo(i)
                        if isActive then
                            CastShapeshiftForm(i)
                            return
                        end
                    end
                end
            end)
        else
            stancedance:UnregisterEvent('UI_ERROR_MESSAGE')
            stancedance:SetScript('OnEvent', nil)
        end
    end

    callbacks.autoForm = function(value)
    end

    callbacks.autoDismount = function(value)
        if value then
            dismount:RegisterEvent('UI_ERROR_MESSAGE')
            dismount:SetScript('OnEvent', function()
                if arg1 == SPELL_FAILED_NOT_STANDING then
                    SitOrStand()
                    return
                end
                for _, errorstring in pairs(dismount.dismountErrors) do
                    if arg1 == errorstring then
                        for i = 0, 31 do
                            dismount.scanner:SetPlayerBuff(i)
                            for _, str in pairs(dismount.mountStrings) do
                                if dismount.scanner:FindText(str) then
                                    CancelPlayerBuff(i)
                                    return
                                end
                            end
                            local buff = GetPlayerBuffTexture(i)
                            if buff then
                                for _, bufftype in pairs(dismount.shapeshiftTextures) do
                                    if string.find(string.lower(buff), bufftype) then
                                        CancelPlayerBuff(i)
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            dismount:UnregisterEvent('UI_ERROR_MESSAGE')
            dismount:SetScript('OnEvent', nil)
        end
    end

    DF:NewCallbacks('tweaks', callbacks)
end)
