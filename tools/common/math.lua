DRAGONFLIGHT()

-- math operations

-- modf: splits number into integer and fractional parts
-- f (number) - number to split
-- returns: integer part, fractional part
function DF.math.modf(f)
    if f > 0 then
        return math.floor(f), math.mod(f,1)
    end
    return math.ceil(f), math.mod(f,1)
end

-- huge: infinity constant
-- returns: positive infinity
DF.math.huge = 1/0

-- round: rounds float to specified decimal places
-- input (number) - number to round
-- places (number) - decimal places, defaults to 0
-- returns: rounded number
function DF.math.round(input, places)
    if not places then places = 0 end
    if type(input) == 'number' and type(places) == 'number' then
        local pow = 1
        for i = 1, places do pow = pow * 10 end
        return math.floor(input * pow + 0.5) / pow
    end
end

-- clamp: limits number to specified range
-- x (number) - number to clamp
-- min (number) - minimum value
-- max (number) - maximum value
-- returns: clamped number
function DF.math.clamp(x, min, max)
    if type(x) == 'number' and type(min) == 'number' and type(max) == 'number' then
        return x < min and min or x > max and max or x
    else
        return x
    end
end

-- abbreviate: formats large numbers with k/m suffixes
-- number (number) - number to abbreviate
-- returns: abbreviated string or original number
function DF.math.abbreviate(number)
    if type(number) ~= 'number' then return number end

    local sign = number < 0 and -1 or 1
    number = math.abs(number)

    if number > 1000000 then
        return DF.math.round(number/1000000*sign, 1) .. 'm'
    elseif number > 1000 then
        return DF.math.round(number/1000*sign, 1) .. 'k'
    end

    return number * sign
end

-- isEven: checks if number is even
-- num (number) - number to check
-- returns: true if even, false if odd
function DF.math.isEven(num)
    if type(num) == 'number' then
        return math.mod(num, 2) == 0
    end
end

-- roundDecimal: rounds number with decimal place support
-- num (number) - number to round
-- places (number) - decimal places, defaults to 0
-- returns: rounded number
function DF.math.roundDecimal(num, places)
    if type(num) ~= 'number' then return num end
    if places and places > 0 then
        local mult = 10 ^ places
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

-- truncate: truncates number to specified decimal places
-- v (number) - number to truncate
-- decimals (number) - decimal places, defaults to 0
-- returns: truncated number
function DF.math.truncate(v, decimals)
    if type(v) ~= 'number' then return v end
    return v - math.mod(v, 0.1 ^ (decimals or 0))
end

-- colorGradient: interpolates between colors based on percentage
-- perc (number) - percentage (0-1)
-- r1,g1,b1 (numbers) - first color RGB
-- r2,g2,b2 (numbers) - second color RGB
-- r3,g3,b3 (numbers) - third color RGB (optional)
-- returns: interpolated r,g,b values
function DF.math.colorGradient(perc, r1, g1, b1, r2, g2, b2, r3, g3, b3)
    if perc >= 1 then
        return r3 or r2, g3 or g2, b3 or b2
    elseif perc <= 0 then
        return r1, g1, b1
    end

    local segment, relperc = DF.math.modf(perc)
    if segment > 0 and r3 then
        r1, g1, b1, r2, g2, b2 = r2, g2, b2, r3, g3, b3
    end

    return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

-- sign: returns sign of number
-- x (number) - number to check
-- returns: -1, 0, or 1
function DF.math.sign(x)
    if type(x) ~= 'number' then return 0 end
    if x > 0 then return 1
    elseif x < 0 then return -1
    else return 0 end
end

-- lerp: linear interpolation between two values
-- a (number) - start value
-- b (number) - end value
-- t (number) - interpolation factor (0-1)
-- returns: interpolated value
function DF.math.lerp(a, b, t)
    if type(a) == 'number' and type(b) == 'number' and type(t) == 'number' then
        return a + (b - a) * t
    end
end

-- map: maps value from one range to another
-- value (number) - input value
-- inMin (number) - input range minimum
-- inMax (number) - input range maximum
-- outMin (number) - output range minimum
-- outMax (number) - output range maximum
-- returns: mapped value
function DF.math.map(value, inMin, inMax, outMin, outMax)
    if type(value) == 'number' and type(inMin) == 'number' and type(inMax) == 'number' and type(outMin) == 'number' and type(outMax) == 'number' then
        return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
    end
end

-- min: minimum of multiple values (up to 5 args)
-- a,b,c,d,e (numbers) - values to compare
-- returns: smallest value
function DF.math.min(a, b, c, d, e)
    if type(a) ~= 'number' then return end
    local minVal = a
    if type(b) == 'number' and b < minVal then minVal = b end
    if type(c) == 'number' and c < minVal then minVal = c end
    if type(d) == 'number' and d < minVal then minVal = d end
    if type(e) == 'number' and e < minVal then minVal = e end
    return minVal
end

-- max: maximum of multiple values (up to 5 args)
-- a,b,c,d,e (numbers) - values to compare
-- returns: largest value
function DF.math.max(a, b, c, d, e)
    if type(a) ~= 'number' then return end
    local maxVal = a
    if type(b) == 'number' and b > maxVal then maxVal = b end
    if type(c) == 'number' and c > maxVal then maxVal = c end
    if type(d) == 'number' and d > maxVal then maxVal = d end
    if type(e) == 'number' and e > maxVal then maxVal = e end
    return maxVal
end

-- normalize: converts value from any range to 0-1 range
-- value (number) - input value
-- min (number) - minimum of input range
-- max (number) - maximum of input range
-- returns: normalized value (0-1)
function DF.math.normalize(value, min, max)
    if type(value) ~= 'number' or type(min) ~= 'number' or type(max) ~= 'number' then return 0 end
    if max == min then return 0 end
    return (value - min) / (max - min)
end