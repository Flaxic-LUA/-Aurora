DRAGONFLIGHT()

DF:NewDefaults('tweaks', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'general', subtab = 'tweaks', 'General', 'Chat'},
    },
    stanceDancing = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'Automatically switch stance when casting spells'}},
    autoForm = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 2, description = 'Extend stance dancing to cancel active forms for druids and rogues', dependency = {key = 'stanceDancing', state = true}}},
    autoDismount = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 3, description = 'Automatically dismount when casting spells'}},
    chatClassColors = {value = true, metadata = {element = 'checkbox', category = 'Chat', indexInCategory = 1, description = 'Show class colors for player names in chat'}},

})

DF:NewModule('tweaks', 1, function()
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
    chatcolor.scanTimer = 0
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
                    -- debugprint('Scanned: '..name..' - '..class)
                end
            end
        end
    end)

    -- chatcolor.tempCache = {}
    -- chatcolor.scanner:SetScript('OnUpdate', function()
    --     TargetByName('Ironforge Guard')
        -- debugprint('OnUpdate running')
        -- chatcolor.scanTimer = chatcolor.scanTimer + arg1
        -- if chatcolor.scanTimer >= 0.5 then
        --     chatcolor.scanTimer = 0
        --     debugprint('Timer hit')
        --     if not UnitExists('target') then
        --         debugprint('Targeting...')
        --         _G.PlaySound = function() end
        --         debugprint('Target exists: '..tostring(UnitExists('target')))
        --         if UnitIsPlayer('target') then
        --             local name = UnitName('target')
        --             debugprint('Player found: '..(name or 'nil'))
        --             if name and not chatcolor.tempCache[name] then
        --                 chatcolor.tempCache[name] = true
        --                 debugprint('Auto-targeting: '..name)
        --             end
        --         end
        --         ClearTarget()
        --         _G.PlaySound = PlaySound
        --     end
        -- end
    -- end)

    -- callbacks
    local callbacks = {}

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

    callbacks.autoForm = function()
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
