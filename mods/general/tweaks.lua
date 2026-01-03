DRAGONFLIGHT()

DF:NewDefaults('tweaks', {
    enabled = {value = true},
    version = {value = '1.0'},
    -- defaults gui structure: {tab = 'tabname', subtab = 'subtabname', 'category1', 'category2', ...}
    -- Named keys (tab, subtab) define panel location, array elements define categories within that panel
    -- Each category groups related settings with a header, settings use category + indexInCategory for ordering
    gui = {
        {tab = 'general', subtab = 'tweaks', 'General', 'Chat'},
    },

    -- defaults examples:
    -- animationTexture = {value = 'Aura1', metadata = {element = 'dropdown', category = 'Animation', indexInCategory = 2, description = 'Animation texture style', options = {'Aura1', 'Aura2', 'Aura3', 'Aura4', 'Glow1', 'Glow2', 'Shock1', 'Shock2', 'Shock3'}, dependency = {key = 'minimapAnimation', state = true}}},
    -- customPlayerArrow = {value = true, metadata = {element = 'checkbox', category = 'Arrow', indexInCategory = 1, description = 'Use Dragonflight\'s custom player arrow', dependency = {key = 'showMinimap', state = true}}},
    -- playerArrowScale = {value = 1, metadata = {element = 'slider', category = 'Arrow', indexInCategory = 3, description = 'Size of the player arrow', min = 0.5, max = 2, stepSize = 0.1, dependency = {key = 'showMinimap', state = true}}},
    -- playerArrowColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Arrow', indexInCategory = 4, description = 'Color of the player arrow', dependency = {key = 'customPlayerArrow', state = true}}},
    stanceDancing = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Automatically switch stance when casting spells'}},
    autoForm = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 2, description = 'Extend stance dancing to cancel active forms for druids and rogues', dependency = {key = 'stanceDancing', state = true}}},
    autoDismount = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 3, description = 'Automatically dismount when casting spells'}},
    chatClassColors = {value = true, metadata = {element = 'checkbox', category = 'Chat', indexInCategory = 1, description = 'Show class colors for player names in chat'}},

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

    DF_PlayerCache.players = DF_PlayerCache.players or {}
    local playerCache = DF_PlayerCache.players

    local chatcolor = {}
    chatcolor.hooked = {}
    chatcolor.scanner = CreateFrame('Frame')
    chatcolor.scanner:RegisterEvent('PLAYER_ENTERING_WORLD')
    chatcolor.scanner:RegisterEvent('FRIENDLIST_UPDATE')
    chatcolor.scanner:RegisterEvent('GUILD_ROSTER_UPDATE')
    chatcolor.scanner:RegisterEvent('RAID_ROSTER_UPDATE')
    chatcolor.scanner:RegisterEvent('PARTY_MEMBERS_CHANGED')
    chatcolor.scanner:RegisterEvent('PLAYER_TARGET_CHANGED')
    chatcolor.scanner:RegisterEvent('UPDATE_MOUSEOVER_UNIT')
    chatcolor.scanner:RegisterEvent('WHO_LIST_UPDATE')
    chatcolor.scanner:SetScript('OnEvent', function()
        if event == 'PLAYER_ENTERING_WORLD' then
            local name = UnitName('player')
            local _, class = UnitClass('player')
            playerCache[name] = class
        elseif event == 'FRIENDLIST_UPDATE' then
            for i = 1, GetNumFriends() do
                local name, level, class = GetFriendInfo(i)
                if name and class then
                    playerCache[name] = class
                end
            end
        elseif event == 'GUILD_ROSTER_UPDATE' then
            for i = 1, GetNumGuildMembers() do
                local name, _, _, _, class = GetGuildRosterInfo(i)
                if name and class then
                    playerCache[name] = class
                end
            end
        elseif event == 'RAID_ROSTER_UPDATE' then
            for i = 1, GetNumRaidMembers() do
                local name, _, _, _, class = GetRaidRosterInfo(i)
                if name and class then
                    playerCache[name] = class
                end
            end
        elseif event == 'PARTY_MEMBERS_CHANGED' then
            for i = 1, GetNumPartyMembers() do
                local unit = 'party'..i
                local name = UnitName(unit)
                local _, class = UnitClass(unit)
                if name and class then
                    playerCache[name] = class
                end
            end
        elseif event == 'WHO_LIST_UPDATE' then
            for i = 1, GetNumWhoResults() do
                local name, _, _, _, class = GetWhoInfo(i)
                if name and class then
                    playerCache[name] = class
                end
            end
        elseif event == 'PLAYER_TARGET_CHANGED' or event == 'UPDATE_MOUSEOVER_UNIT' then
            local unit = event == 'PLAYER_TARGET_CHANGED' and 'target' or 'mouseover'
            if UnitIsPlayer(unit) then
                local name = UnitName(unit)
                local _, class = UnitClass(unit)
                if name and class then
                    playerCache[name] = class
                end
            end
        end
    end)

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

    callbacks.chatClassColors = function(value)
        for i = 1, NUM_CHAT_WINDOWS do
            local frame = getglobal('ChatFrame'..i)
            if frame then
                if value then
                    if not chatcolor.hooked[frame] then
                        chatcolor.hooked[frame] = frame.AddMessage
                        frame.AddMessage = function(self, text, r, g, b, id, hold)
                            if text then
                                for name in string.gfind(text, '|Hplayer:(.-)|h') do
                                    local parts = DF.data.split(name, ':')
                                    local real = parts[1]
                                    local class = playerCache[real]
                                    local hex
                                    if class and DF.tables.classcolors[class] then
                                        local color = DF.tables.classcolors[class]
                                        hex = string.format('|cff%02x%02x%02x', color[1]*255, color[2]*255, color[3]*255)
                                    else
                                        hex = '|cffbbbbbb'
                                    end
                                    text = string.gsub(text, '|Hplayer:'..name..'|h%['..real..'%]|h', '|r['..hex..'|Hplayer:'..name..'|h'..hex..real..'|h|r]|r')
                                end
                            end
                            chatcolor.hooked[frame](self, text, r, g, b, id, hold)
                        end
                    end
                else
                    if chatcolor.hooked[frame] then
                        frame.AddMessage = chatcolor.hooked[frame]
                        chatcolor.hooked[frame] = nil
                    end
                end
            end
        end
    end

    DF:NewCallbacks('tweaks', callbacks)
end)
