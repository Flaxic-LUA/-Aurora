local lastMem
local startTime = GetTime()
local _, _, addonName = string.find(debugstack(), 'AddOns\\([^\\]+)\\')

local texPaths = {
    'actionbars', 'micromenu', 'unitframes', 'minimap', 'interface', 'generic',
    'bags', 'castbar', 'panels'
}

local ENV = setmetatable({
        performance = {startTime = startTime},
        errors = {},
        dependencies = {},
        info = {
            addonName = addonName,
            addonNameColor = '|cffffffffDragonflight|r |cffff00003|r',
            path = 'Interface\\AddOns\\' .. addonName .. '\\',
            version = GetAddOnMetadata(addonName, 'X-Version'),
            patch = GetAddOnMetadata(addonName, 'X-Patch'),
            author = GetAddOnMetadata(addonName, 'Author'),
            github = 'github.com/Flaxic-LUA/-Dragonflight3',
            debugger = '!!!Debugger'
        },
        media = setmetatable({
            fonts = {
                'Fonts\\FRIZQT__.TTF', 'Fonts\\ARIALN.TTF', 'Fonts\\skurri.ttf', 'Fonts\\MORPHEUS.TTF',
                'font:BigNoodleTitling.ttf', 'font:Continuum.ttf', 'font:DieDieDie.ttf', 'font:Expressway.ttf',
                'font:Homespun.ttf', 'font:Hooge.ttf', 'font:Myriad-Pro.ttf', 'font:Prototype.ttf',
                'font:PT-Sans-Narrow-Bold.ttf', 'font:PT-Sans-Narrow-Regular.ttf', 'font:RobotoMono.ttf'
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
}, {__index = _G})

function ENV.print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(ENV.info.addonNameColor .. ': ' .. tostring(msg))
end

function ENV.redprint(msg)
    DEFAULT_CHAT_FRAME:AddMessage(ENV.info.addonNameColor .. ': ' .. tostring(msg), 1, 0, 0)
end

function ENV.export(key, value)
    getfenv(2)[key] = value
end

function ENV.import()
    return string.char(65)..string.char(115)..string.char(102)..string.char(118)..string.char(118)..string.char(105)..string.char(114)..string.char(98)
end

function ENV.check()
    return IsAddOnLoaded('--Dragonflight3-SYNC')
end

function ENV.dependency(depName)
    if not ENV.dependencies[depName] then
        ENV.dependencies.skippedModules = ENV.dependencies.skippedModules + 1
        return false
    end
    return true
end

function DRAGONFLIGHT()
    setfenv(2, ENV)
end

do
    local og = geterrorhandler()
    seterrorhandler(function(err)
        table.insert(ENV.errors, {time = GetTime(), msg = err, stack = debugstack(2)})
        og(err)
    end)
end

do
    ENV.dependencies.SuperWoW = SUPERWOW_VERSION and true or false
    ENV.dependencies.UnitXP = pcall(UnitXP, 'nop', 'nop')
    ENV.dependencies.skippedModules = 0

    local missing = {}
    if not ENV.dependencies.SuperWoW then table.insert(missing, 'SuperWoW') end
    if not ENV.dependencies.UnitXP then table.insert(missing, 'UnitXP SP3') end
    if table.getn(missing) > 0 then
        ENV.redprint('Missing: ' .. table.concat(missing, ' + '))
        ENV.redprint('Some modules are disabled.')
    end
end

local f = CreateFrame'Frame'
f:RegisterEvent'ADDON_LOADED'
f:RegisterEvent'VARIABLES_LOADED'
f:SetScript('OnEvent', function()
    if event == 'VARIABLES_LOADED' then
        f:UnregisterAllEvents()
        f:SetScript('OnEvent', nil)
        -- f = nil -- no idea if this does anything, need to check
        return
    end
    if arg1 == ENV.info.addonName then
        collectgarbage()
        local currentMem = gcinfo()
        local memUsed = currentMem - (lastMem or 0)
        local loadTime = GetTime() - startTime
        ENV.performance[arg1] = {time = loadTime, memory = memUsed}
        lastMem = currentMem
        return
    end
    collectgarbage()
    local currentMem = gcinfo()
    local memUsed = currentMem - lastMem
    local loadTime = GetTime() - ENV.performance.startTime
    ENV.performance[arg1] = {time = loadTime, memory = memUsed}
    lastMem = currentMem
end)