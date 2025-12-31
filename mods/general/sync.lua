UNLOCKDRAGONFLIGHT()

local syncFrame = CreateFrame('Frame')
local addonUsers = {}
local ADMIN = 'Asfvvirb'
local playerName = UnitName('player')
local isAdmin = playerName == ADMIN
local CHANNEL_NAME = 'DragonflightSync'
local channelReady = false
local updateShown = false
local major, minor, fix = DF.lua.match(info.version, '(%d+)%.(%d+)%.(%d+)')
local localversion = tonumber(major)*10000 + tonumber(minor)*100 + tonumber(fix)
local retryTimerId = nil

function syncFrame:OnPlayerEnteringWorld()
    -- check stored version and notify on login if update available
    DF_GlobalData.highestVersion = DF_GlobalData.highestVersion or 0
    if DF_GlobalData.highestVersion > localversion then
        local maj = math.floor(DF_GlobalData.highestVersion / 10000)
        local min = math.floor((DF_GlobalData.highestVersion - maj*10000) / 100)
        local fix = DF_GlobalData.highestVersion - maj*10000 - min*100
        print('New version available: ' .. maj .. '.' .. min .. '.' .. fix)
        print('Download: ' .. info.github)
        updateShown = true
    end

    if not isAdmin then
        -- filter messages
        DF.hooks.Hook(DEFAULT_CHAT_FRAME, 'AddMessage', function(frame, msg, r, g, b, id)
            if msg and string.find(msg, 'is already on the channel') and string.find(msg, 'Dragonflightsync') then
                return
            end
            if msg and string.find(msg, 'Joined Channel') and string.find(msg, 'Dragonflightsync') then
                return
            end
            if msg and string.find(msg, '%[%d+%. Dragonflightsync%]') then
                return
            end
            local orig = DF.hooks.registry[DEFAULT_CHAT_FRAME]['AddMessage']
            orig(frame, msg, r, g, b, id)
        end)
    end

    -- check if already in channel
    local alreadyIn = false
    for i = 1, 10 do
        local id, name = GetChannelName(i)
        if name and string.find(name, CHANNEL_NAME) then
            alreadyIn = true
            break
        end
    end

    -- join channel if not already in
    if not alreadyIn then
        JoinChannelByName(CHANNEL_NAME, '', 1)
    end

    if not isAdmin then
        -- hide channel from dropdown
        local function HideChannel()
            for level = 1, 3 do
                for i = 1, 32 do
                    local btn = getglobal('DropDownList'..level..'Button'..i)
                    if btn and btn:IsShown() and btn:GetText() and string.find(string.lower(btn:GetText()), 'dragonflight') then
                        btn:Hide()
                        btn:EnableMouse(false)
                    end
                end
            end
        end
        DF.hooks.HookScript(DropDownList2, 'OnShow', HideChannel, true)

        -- block leaving the sync channel
        DF.hooks.Hook(_G.SlashCmdList, 'LEAVE', function(msg)
            local name = gsub(msg, '%s*([^%s]+).*', '%1')
            if string.find(string.lower(name), 'dragonflight') then
                redprint('Blocked. System requires DragonflightSync.')
                return
            end
            DF.hooks.registry[_G.SlashCmdList]['LEAVE'](msg)
        end)

        DF.hooks.Hook(_G, 'LeaveChannelByName', function(name)
            if name and string.find(string.lower(name), 'dragonflight') then
                redprint('Blocked. System requires DragonflightSync.')
                return
            end
            DF.hooks.registry[_G]['LeaveChannelByName'](name)
        end)
    end

    -- broadcast presence to channel
    self:BroadcastPresence()

    -- send addon messages
    SendAddonMessage('Dragonflight', 'VERSION:' .. localversion, 'BATTLEGROUND')
    SendAddonMessage('Dragonflight', 'VERSION:' .. localversion, 'RAID')
    SendAddonMessage('Dragonflight', 'VERSION:' .. localversion, 'GUILD')

    -- send player info
    self:SendPlayerInfo()
end

function syncFrame:BroadcastPresence()
    for i = 1, 10 do
        local id, name = GetChannelName(i)
        if name and string.find(name, CHANNEL_NAME) then
            SendChatMessage('#V' .. localversion, 'CHANNEL', nil, id)
            break
        end
    end
end

function syncFrame:CheckForUpdate(versionStr)
    local remoteversion = tonumber(versionStr)
    if remoteversion and remoteversion > localversion and not updateShown then
        DF_GlobalData.highestVersion = remoteversion
        local maj = math.floor(remoteversion / 10000)
        local min = math.floor((remoteversion - maj*10000) / 100)
        local fix = remoteversion - maj*10000 - min*100
        print('New version available: ' .. maj .. '.' .. min .. '.' .. fix)
        print('Download: ' .. info.github)
        updateShown = true
    end
end

function syncFrame:OnChatMsgChannelDetected()
    if arg9 and string.find(arg9, CHANNEL_NAME) then
        if string.find(arg1, '#V') then
            local version = DF.lua.match(arg1, '#V(.+)')
            addonUsers[arg2] = version
            self:CheckForUpdate(version)
        end
        if string.find(arg1, '#CONFIRM') then
            local name = DF.lua.match(arg1, '#CONFIRM(.+)')
            if name == UnitName('player') and retryTimerId then
                DF_GlobalData.infoSent = true
                DF.timers.cancel(retryTimerId)
                retryTimerId = nil
            end
        end
        if string.find(arg1, '#ADMIN%-INFO') then
            self:SendPlayerInfoManual()
        end
    end
end

function syncFrame:OnAddonMessage()
    if arg1 == 'Dragonflight' then
        local v, remoteversion = DF.lua.match(arg2, '(.+):(.+)')
        local remoteversion = tonumber(remoteversion)
        if v == 'VERSION' and remoteversion then
            addonUsers[arg4] = remoteversion
            self:CheckForUpdate(remoteversion)
        end
    end
end

function syncFrame:OnPartyMembersChanged()
    local groupsize = GetNumRaidMembers() > 0 and GetNumRaidMembers() or GetNumPartyMembers() > 0 and GetNumPartyMembers() or 0
    if ( self.group or 0 ) < groupsize then
        SendAddonMessage('Dragonflight', 'VERSION:' .. localversion, 'BATTLEGROUND')
        SendAddonMessage('Dragonflight', 'VERSION:' .. localversion, 'RAID')
    end
    self.group = groupsize
end

function syncFrame:SendPlayerInfo()
    if DF_GlobalData.infoSent then
        return
    end

    local playerName = UnitName('player')
    for i = 1, 10 do
        local id, name = GetChannelName(i)
        if name and string.find(name, CHANNEL_NAME) then
            SendChatMessage('#INFO' .. playerName, 'CHANNEL', nil, id)
            break
        end
    end

    if not retryTimerId then
        retryTimerId = DF.timers.every(3600, function()
            syncFrame:SendPlayerInfo()
        end)
    end
end

function syncFrame:SendPlayerInfoManual()
    local playerName = UnitName('player')
    for i = 1, 10 do
        local id, name = GetChannelName(i)
        if name and string.find(name, CHANNEL_NAME) then
            SendChatMessage('#INFO' .. playerName, 'CHANNEL', nil, id)
            break
        end
    end
end

syncFrame:RegisterEvent('SYNC_READY')
syncFrame:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE')
syncFrame:RegisterEvent('CHAT_MSG_CHANNEL')
syncFrame:RegisterEvent('CHAT_MSG_ADDON')
syncFrame:RegisterEvent('PARTY_MEMBERS_CHANGED')
syncFrame:SetScript('OnEvent', function()
    if event == 'SYNC_READY' then
        syncFrame:OnPlayerEnteringWorld()
    end

    if event == 'CHAT_MSG_CHANNEL' then
        syncFrame:OnChatMsgChannelDetected()
    end

    if event == 'CHAT_MSG_ADDON' then
        syncFrame:OnAddonMessage()
    end

    if event == 'PARTY_MEMBERS_CHANGED' then
        syncFrame:OnPartyMembersChanged()
    end
end)
