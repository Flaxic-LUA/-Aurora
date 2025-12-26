local startTime = GetTime()

local _, _, addonName = string.find(debugstack(), 'AddOns\\([^\\]+)\\')

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
        performance = {startTime = startTime},
        errors = {},
        info = {
            addonName = addonName,
            addonNameColor = '|cffffffffDragonflight|r |cffff00003|r',
            path = 'Interface\\AddOns\\' .. addonName .. '\\',
            version = GetAddOnMetadata(addonName, 'X-Version'),
            patch = GetAddOnMetadata(addonName, 'X-Patch'),
            author = GetAddOnMetadata(addonName, 'Author'),
            github = 'github.com/Flaxic-LUA/-Dragonflight3',
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
                    value = string.gsub(value, pattern, 'Interface\\AddOns\\' .. addonName .. '\\media\\tex\\' .. texPaths[i] .. '\\')
                    rawset(tab,key,value)
                    return value
                end
            end
            if strfind(value, 'tex:') then
                value = string.gsub(value, 'tex:', 'Interface\\AddOns\\' .. addonName .. '\\media\\tex\\')
            elseif strfind(value, 'font:') then
                value = string.gsub(value, 'font:', 'Interface\\AddOns\\' .. addonName .. '\\media\\fonts\\')
            elseif strfind(value, 'sound:') then
                value = string.gsub(value, 'sound:', 'Interface\\AddOns\\' .. addonName .. '\\media\\sound\\')
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

    if not string.find(stack, self.info.path, 1, true) then
        error('DRAGONFLIGHT Access denied')
        return
    end
    setfenv(3, self)
end

function ENV.redprint(msg)
    DEFAULT_CHAT_FRAME:AddMessage(ENV.info.addonNameColor .. ': ' .. tostring(msg), 1, 0, 0)
end

function ENV.print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(ENV.info.addonNameColor .. ': ' .. tostring(msg))
end

function UNLOCKDRAGONFLIGHT()
    ENV:GetEnv()
end

if not SUPERWOW_VERSION then
    ENV.redprint('SuperWoW missing. Some features wont work.')
    return
end

local lastMem
local perfFrame = CreateFrame'Frame'
perfFrame:RegisterEvent'ADDON_LOADED'
perfFrame:RegisterEvent'VARIABLES_LOADED'
perfFrame:SetScript('OnEvent', function()
    if event == 'VARIABLES_LOADED' then
        perfFrame:UnregisterAllEvents()
        perfFrame:SetScript('OnEvent', nil)
        -- ENV.redprint('loaded in ' .. string.format('%.3f', GetTime() - startTime) .. 's')
        return
    end
    if arg1 == ENV.info.addonName then
        collectgarbage()
        lastMem = gcinfo()
        local loadTime = GetTime() - startTime
        ENV.performance[arg1] = {time = loadTime, memory = 0}
        return
    end
    collectgarbage()
    local currentMem = gcinfo()
    local memUsed = currentMem - lastMem
    local loadTime = GetTime() - ENV.performance.startTime
    ENV.performance[arg1] = {time = loadTime, memory = memUsed}
    lastMem = currentMem
end)
