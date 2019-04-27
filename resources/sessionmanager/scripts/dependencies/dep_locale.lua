--[[
    For reference:
    ms -> Meters per second (game uses m/s)
    kmh -> Kilometers per hour
    mph -> Miles per hour

    All annotations are in lower case and only use a-z, A-Z characters.
]]

local unitResolvers = {
    {
        from = "ms",
        to = "kmh",
        resolve = function(value)
            return value * 3.6
        end
    },
    {
        from = "ms",
        to = "mph",
        resolve = function(value)
            return value * 2.2369362912
        end
    }
}

local function _resolveUnit(value, from, to)
    for _, resolver in ipairs(unitResolvers) do

        if from == resolver.from and to == resolver.to then
            return resolver.resolve(value)
        end
    end

    return value

    --TODO: Possible convert units in directly.
    --      If for instance mp/h to km/h doesn't exist, we could say to first convert to m/s then to km/h.
    --      Possibly build some tree stucture to resolve this.
end

-- TODO: possible move this to a library for math stuff or something.
local function _round(value, decimals)
    return tonumber(string.format(string.format("%%.%df", decimals or 0), value or 0))
end

function GetUnitForVehicleSpeed(speed, decimalPlaces)
    local convertedUnit = 0.0
    local unit = ""
    if ShouldUseMetricMeasurements() then
        convertedUnit = _resolveUnit(speed, "ms", "kmh")
        unit = "kmh"
    else
        convertedUnit = _resolveUnit(speed, "ms", "mph")
        unit = "mph"
    end

    return string.format("%d %s", _round(convertedUnit), unit)
end
