UNLOCKAURORA()

local frameConfigs = {
    {prefix = 'buff', name = 'Buff', hasSorting = true, defaultSize = 22, defaultPerRow = 8, maxPerRow = 16},
    {prefix = 'debuff', name = 'Debuff', hasSorting = true, defaultSize = 33, defaultPerRow = 8, maxPerRow = 16},
    {prefix = 'weapon', name = 'Weapon', hasSorting = false, defaultSize = 30, defaultPerRow = 2, maxPerRow = 2}
}

local defaults = {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {},
}

local catGeneral = 'General'
local catBuffs = 'Buffs'
local catDebuffs = 'Debuffs'
local catWeapons = 'Weapon Buffs'
table.insert(defaults.gui, {tab = 'buffs', catGeneral, catBuffs, catDebuffs, catWeapons})

defaults.frameSpacing = {value = 15, metadata = {element = 'slider', category = catGeneral, indexInCategory = 1, description = 'Spacing between frames', min = 0, max = 50, stepSize = 1}}

for i = 1, table.getn(frameConfigs) do
    local cfg = frameConfigs[i]
    local showKey = 'show'..cfg.name..'s'
    local cat = (cfg.prefix == 'buff') and catBuffs or (cfg.prefix == 'debuff') and catDebuffs or catWeapons
    local idx = 1
    
    defaults[showKey] = {value = true, metadata = {element = 'checkbox', category = cat, indexInCategory = idx, description = 'Show '..string.lower(cfg.name)..'s'}}
    idx = idx + 1
    defaults[cfg.prefix..'ButtonsPerRow'] = {value = cfg.defaultPerRow, metadata = {element = 'slider', category = cat, indexInCategory = idx, description = cfg.name..' buttons per row', min = 1, max = cfg.maxPerRow, stepSize = 1, dependency = {key = showKey, state = true}}}
    idx = idx + 1
    defaults[cfg.prefix..'Size'] = {value = cfg.defaultSize, metadata = {element = 'slider', category = cat, indexInCategory = idx, description = cfg.name..' size', min = 20, max = 50, stepSize = 1, dependency = {key = showKey, state = true}}}
    idx = idx + 1
    defaults[cfg.prefix..'Spacing'] = {value = 5, metadata = {element = 'slider', category = cat, indexInCategory = idx, description = cfg.name..' button spacing', min = 0, max = 20, stepSize = 1, dependency = {key = showKey, state = true}}}
    idx = idx + 1
    defaults[cfg.prefix..'DurationFont'] = {value = 'font:Expressway.ttf', metadata = {element = 'dropdown', category = cat, indexInCategory = idx, description = cfg.name..' duration font', options = media.fonts, dependency = {key = showKey, state = true}}}
    idx = idx + 1
    defaults[cfg.prefix..'DurationFontSize'] = {value = 10, metadata = {element = 'slider', category = cat, indexInCategory = idx, description = cfg.name..' duration font size', min = 6, max = 20, stepSize = 1, dependency = {key = showKey, state = true}}}
    idx = idx + 1
    if cfg.hasSorting then
        defaults[cfg.prefix..'SortOrder'] = {value = 'descending', metadata = {element = 'dropdown', category = cat, indexInCategory = idx, description = cfg.name..' sort by duration', options = {'ascending', 'descending'}, dependency = {key = showKey, state = true}}}
    end
end

AU:NewDefaults('buffs', defaults)

AU:NewModule('buffs', 1, 'PLAYER_LOGIN', function()
    local setup = AU.setups.buffs
    local frameSpacing = AU.profile['buffs']['frameSpacing'] or 15

    local buffFrame = setup:CreateBuffFrame('AU_BuffFrame', 16, 'HELPFUL', AU.profile['buffs']['buffButtonsPerRow'] or 8)
    buffFrame.buttonSize = AU.profile['buffs']['buffSize'] or 22
    buffFrame.spacing = AU.profile['buffs']['buffSpacing'] or 5
    buffFrame:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -15, -15)

    local debuffFrame = setup:CreateBuffFrame('AU_DebuffFrame', 16, 'HARMFUL', AU.profile['buffs']['debuffButtonsPerRow'] or 8)
    debuffFrame.buttonSize = AU.profile['buffs']['debuffSize'] or 33
    debuffFrame.spacing = AU.profile['buffs']['debuffSpacing'] or 5
    debuffFrame:SetPoint('TOPRIGHT', buffFrame, 'BOTTOMRIGHT', 0, -frameSpacing)

    local weaponFrame = setup:CreateWeaponFrame('AU_WeaponFrame', AU.profile['buffs']['weaponButtonsPerRow'] or 2)
    weaponFrame.buttonSize = AU.profile['buffs']['weaponSize'] or 30
    weaponFrame.spacing = AU.profile['buffs']['weaponSpacing'] or 5
    weaponFrame:SetPoint('TOPRIGHT', debuffFrame, 'BOTTOMRIGHT', 0, -frameSpacing)

    local frames = {
        {frame = buffFrame, prefix = 'buff', hasSorting = true},
        {frame = debuffFrame, prefix = 'debuff', hasSorting = true},
        {frame = weaponFrame, prefix = 'weapon', hasSorting = false}
    }

    local callbacks = {}

    callbacks.frameSpacing = function(value)
        debuffFrame:ClearAllPoints()
        debuffFrame:SetPoint('TOPRIGHT', buffFrame, 'BOTTOMRIGHT', 0, -value)
        weaponFrame:ClearAllPoints()
        weaponFrame:SetPoint('TOPRIGHT', debuffFrame, 'BOTTOMRIGHT', 0, -value)
    end

    for _, f in pairs(frames) do
        local prefix = f.prefix
        local frame = f.frame
        local showKey = 'show'..string.upper(string.sub(prefix, 1, 1))..string.sub(prefix, 2)..'s'

        callbacks[showKey] = function(value)
            if value then frame:Show() else frame:Hide() end
        end

        callbacks[prefix..'ButtonsPerRow'] = function(value)
            setup:UpdateFrameLayout(frame, frame.buttons, value)
        end

        callbacks[prefix..'Size'] = function(value)
            frame.buttonSize = value
            for _, btn in pairs(frame.buttons) do
                btn:SetSize(value, value)
            end
            setup:UpdateFrameLayout(frame, frame.buttons, AU.profile['buffs'][prefix..'ButtonsPerRow'])
        end

        callbacks[prefix..'Spacing'] = function(value)
            frame.spacing = value
            setup:UpdateFrameLayout(frame, frame.buttons, AU.profile['buffs'][prefix..'ButtonsPerRow'])
        end

        callbacks[prefix..'DurationFont'] = function(value)
            for _, btn in pairs(frame.buttons) do
                btn.duration:SetFont(media[value], AU.profile['buffs'][prefix..'DurationFontSize'], 'OUTLINE')
            end
        end

        callbacks[prefix..'DurationFontSize'] = function(value)
            for _, btn in pairs(frame.buttons) do
                btn.duration:SetFont(media[AU.profile['buffs'][prefix..'DurationFont']], value, 'OUTLINE')
            end
        end

        if f.hasSorting then
            callbacks[prefix..'SortOrder'] = function(value)
                frame.sortOrder = value
                setup:SortButtons(frame)
                for _, btn in pairs(frame.buttons) do
                    setup:UpdateButton(btn)
                end
            end
        end
    end

    AU:NewCallbacks('buffs', callbacks)
end)
