local biosStartTime = GetTime()
local _, _, addonBIOS = string.find(debugstack(), 'AddOns\\([^\\]+)\\')
local addonName = string.gsub(addonBIOS, '-BIOS', '')

local texPaths = {
    'actionbars',
    'micromenu',
    'unitframes',
    'minimap',
    'interface',
    'generic',
    'bags',
    'castbar',
    'panels'
}

local ENV = setmetatable({
        performance = {startTime = GetTime()},
        errors = {},
        info = {
            addonBIOS = addonBIOS,
            addonName = addonName,
            addonNameColor = '|cFF00CCFFAUROR|r|CFFFFFFFFA|r',
            AddonCurrent = addonName .. '-Current',
            AddonLTS = addonName .. '-LTS',
            PathBIOS = 'Interface\\AddOns\\' .. addonBIOS .. '\\',
            PathCurrent = 'Interface\\AddOns\\' .. addonName .. '-Current\\',
            PathLTS = 'Interface\\AddOns\\' .. addonName .. '-LTS\\',
            VersionBIOS = GetAddOnMetadata(addonBIOS, 'X-Version-BIOS'),
            VersionCurrent = GetAddOnMetadata(addonBIOS, 'X-Version-Current'),
            VersionLTS = GetAddOnMetadata(addonBIOS, 'X-Version-LTS'),
            CurrentPatch = GetAddOnMetadata(addonBIOS, 'X-Current-Patch'),
            LTSPatch = GetAddOnMetadata(addonBIOS, 'X-LTS-Patch'),
        },
        media = setmetatable({
            fonts = {
                'Fonts\\FRIZQT__.TTF',
                'Fonts\\ARIALN.TTF',
                'Fonts\\skurri.ttf',
                'Fonts\\MORPHEUS.TTF',
                'font:BigNoodleTitling.ttf',
                'font:Continuum.ttf',
                'font:DieDieDie.ttf',
                'font:Expressway.ttf',
                'font:Homespun.ttf',
                'font:Hooge.ttf',
                'font:Myriad-Pro.ttf',
                'font:Prototype.ttf',
                'font:PT-Sans-Narrow-Bold.ttf',
                'font:PT-Sans-Narrow-Regular.ttf',
                'font:RobotoMono.ttf'
            }
        }, { __index = function(tab,key)
            local value = tostring(key)
            for i = 1, table.getn(texPaths) do
                local pattern = 'tex:' .. texPaths[i] .. ':'
                if strfind(value, pattern) then
                    value = string.gsub(value, pattern, 'Interface\\AddOns\\' .. addonBIOS .. '\\media\\tex\\' .. texPaths[i] .. '\\')
                    rawset(tab,key,value)
                    return value
                end
            end
            if strfind(value, 'tex:') then
                value = string.gsub(value, 'tex:', 'Interface\\AddOns\\' .. addonBIOS .. '\\media\\tex\\')
            elseif strfind(value, 'font:') then
                value = string.gsub(value, 'font:', 'Interface\\AddOns\\' .. addonBIOS .. '\\media\\fonts\\')
            elseif strfind(value, 'sound:') then
                value = string.gsub(value, 'sound:', 'Interface\\AddOns\\' .. addonBIOS .. '\\media\\sound\\')
            end
            rawset(tab,key,value)
            return value
        end}),
}, {__index = getfenv()})

local originalDebugstack = debugstack

local oldErrorHandler = geterrorhandler()
seterrorhandler(function(err)
    table.insert(ENV.errors, {time = GetTime(), msg = err, stack = debugstack(2)})
    oldErrorHandler(err)
end)

function ENV:GetEnv()
    if debugstack ~= originalDebugstack then return end

    local stack = debugstack()

    local allowed = string.find(stack, self.info.PathCurrent, 1, true) or
                    string.find(stack, self.info.PathLTS, 1, true) or
                    string.find(stack, self.info.PathBIOS, 1, true)

    if not allowed then
        error('AURORA Access denied')
        return
    end
    setfenv(3, self)
end

function ENV:BiosPrint(msg)
    DEFAULT_CHAT_FRAME:AddMessage('BIOS: ' .. tostring(msg), 1, 0, 0)
end

function print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(ENV.info.addonNameColor .. ': ' .. tostring(msg))
end

function UNLOCKAURORA()
    if IsAddOnLoaded(ENV.info.AddonCurrent) and IsAddOnLoaded(ENV.info.AddonLTS) then
        print(ENV.info.addonBIOS .. ': Both Current and LTS loaded, aborting')
        return true
    end

    ENV:GetEnv()
    return false
end

local lastMem
local perfFrame = CreateFrame'Frame'
perfFrame:RegisterEvent'ADDON_LOADED'
perfFrame:RegisterEvent'VARIABLES_LOADED'
perfFrame:SetScript('OnEvent', function()
    if event == 'VARIABLES_LOADED' then
        perfFrame:UnregisterAllEvents()
        perfFrame:SetScript('OnEvent', nil)
        -- ENV:BiosPrint('loaded in ' .. string.format('%.3f', GetTime() - biosStartTime) .. 's')
        return
    end
    if arg1 == ENV.info.addonBIOS then
        collectgarbage()
        lastMem = gcinfo()
        local biosLoadTime = GetTime() - biosStartTime
        ENV.performance[arg1] = {time = biosLoadTime, memory = 0}
        return
    end
    collectgarbage()
    local currentMem = gcinfo()
    local memUsed = currentMem - lastMem
    local loadTime = GetTime() - ENV.performance.startTime
    ENV.performance[arg1] = {time = loadTime, memory = memUsed}
    lastMem = currentMem
end)
