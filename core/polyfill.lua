-- provide some global fills for all vanilla clients
_G = getfenv(0)

function print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(tostring(msg))
end

SLASH_RELOAD1 = '/rl'
SLASH_RELOAD2 = '/reload'
SlashCmdList['RELOAD'] = function()
    ReloadUI()
end

local frameMT = getmetatable(CreateFrame'Frame')
local oldIndex = frameMT.__index
frameMT.__index = function(t, k)
    if k == 'SetSize' then
        return function(self, width, height)
            self:SetWidth(width)
            self:SetHeight(height)
        end
    elseif k == 'GetSize' then
        return function(self)
            return self:GetWidth(), self:GetHeight()
        end
    end
    return oldIndex(t, k)
end
