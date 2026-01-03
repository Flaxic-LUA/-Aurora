DRAGONFLIGHT()

local GetGameTime = GetGameTime
local format = string.format
local date = date

-- provide drift-free date and time
DF.date.currentTime = '00:00'
DF.date.currentTimeWithSeconds = '00:00:00'
DF.date.currentDate = '01/01/2000'
DF.date.serverTime = '00:00'
DF.date.timeFormat = '24h'
DF.date.showSeconds = false
DF.date.amPmColor = {0.7, 0.7, 0.7}

DF.timers.every(1, function()
    local timeFormat = DF.date.showSeconds and '%H:%M:%S' or '%H:%M'
    if DF.date.timeFormat == '12h' then
        timeFormat = DF.date.showSeconds and '%I:%M:%S %p' or '%I:%M %p'
        local timeStr = date(timeFormat)
        local timePart, ampm = DF.lua.match(timeStr, '(.+) (%a%a)')
        if timePart and ampm then
            local r, g, b = DF.date.amPmColor[1], DF.date.amPmColor[2], DF.date.amPmColor[3]
            local colorCode = format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
            DF.date.currentTime = timePart .. ' ' .. colorCode .. ampm .. '|r'
        else
            DF.date.currentTime = timeStr
        end
    else
        DF.date.currentTime = date(timeFormat)
    end
    DF.date.currentTimeWithSeconds = date('%H:%M:%S')
    DF.date.currentDate = date('%m/%d/%Y')

    local hour, minute = GetGameTime()
    DF.date.serverTime = format('%02d:%02d', hour, minute)
end)

-- publics
-- provide calendar data
function DF.date.CalendarData()
    local daysInMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    local monthNames = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'}

    local function isLeapYear(year)
        return (math.mod(year, 4) == 0 and math.mod(year, 100) ~= 0) or (math.mod(year, 400) == 0)
    end

    local function getDaysInMonth(year, month)
        if month == 2 and isLeapYear(year) then
            return 29
        end
        return daysInMonth[month]
    end

    local function getFirstDayOfMonth(year, month)
        if month < 3 then
            month = month + 12
            year = year - 1
        end
        local k = math.mod(year, 100)
        local j = math.floor(year / 100)
        local h = math.mod((1 + math.floor((13 * (month + 1)) / 5) + k + math.floor(k / 4) + math.floor(j / 4) - 2 * j), 7)
        return math.mod((h + 5), 7)
    end

    local currentYear = tonumber(date('%Y'))
    local currentMonth = tonumber(date('%m'))

    local months = {}

    for monthOffset = 0, 23 do  -- 24 months (2 years)
        local year = currentYear
        local month = currentMonth + monthOffset

        while month > 12 do
            year = year + 1
            month = month - 12
        end

        local days = getDaysInMonth(year, month)
        local firstDay = getFirstDayOfMonth(year, month)
        local grid = {}

        for day = 1, days do
            table.insert(grid, day)
        end

        months[monthOffset + 1] = {
            year = year,
            month = month,
            monthName = monthNames[month] .. ' ' .. year,
            days = days,
            firstDay = firstDay,
            grid = grid
        }
    end

    local function getCurrentDate()
        local day = tonumber(date('%d'))
        local month = tonumber(date('%m'))
        local year = tonumber(date('%y'))
        return year .. format('%02d', month) .. format('%02d', day)
    end

    local function addDays(dateStr, days)
        local year = string.sub(dateStr, 1, 2)
        local month = string.sub(dateStr, 3, 4)
        local day = string.sub(dateStr, 5, 6)

        local d, m, y = tonumber(day), tonumber(month), tonumber('20' .. year)
        d = d + days

        while d > getDaysInMonth(y, m) do
            d = d - getDaysInMonth(y, m)
            m = m + 1
            if m > 12 then
                m = 1
                y = y + 1
            end
        end

        d = DF.math.clamp(d, 1, getDaysInMonth(y, m))
        m = DF.math.clamp(m, 1, 12)
        return format('%02d%02d%02d', math.mod(y, 100), m, d)
    end

    local function formatForDisplay(dateStr)
        local year = string.sub(dateStr, 1, 2)
        local month = string.sub(dateStr, 3, 4)
        local day = string.sub(dateStr, 5, 6)
        return day .. '/' .. month .. '/' .. year
    end

    local result = {
        months = months,
        currentIndex = 1,
        minIndex = 1,
        maxIndex = 24,
        getCurrentDate = getCurrentDate,
        addDays = addDays,
        formatForDisplay = formatForDisplay
    }

    return result
end
