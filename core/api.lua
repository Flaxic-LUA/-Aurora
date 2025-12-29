UNLOCKDRAGONFLIGHT()

local DragonflightAPI = {}

-- addon: Puppeteer
-- reason: spams events, needs access to eventFrame to manage updates
function DragonflightAPI:PuppeteerGetActionbarsEventFrame()
    if DF.setups.actionbars and DF.setups.actionbars.eventFrame then
        return DF.setups.actionbars.eventFrame
    end
end

-- expose
_G.DragonflightAPI = DragonflightAPI
