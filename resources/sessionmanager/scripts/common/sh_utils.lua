function SecondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds / 3600));
        mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
        secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
        return hours..":"..mins..":"..secs
    end
end

function MsToClock(milliseconds)
    local milliseconds = tonumber(milliseconds)

    if milliseconds <= 0 then
        return "00:00.000";
    else
        hours = string.format("%02.f", math.floor(milliseconds / 3600000));
        mins = string.format("%02.f", math.floor(milliseconds / 60000 - (hours * 60)));
        secs = string.format("%02.f", math.floor(milliseconds / 1000 - hours * 3600 - mins * 60));
        mills = string.format("%03.f", math.floor(milliseconds - hours * 3600000 - mins * 60000 - secs * 1000));
        if milliseconds > 3600000 then
            return hours..":"..mins..":"..secs.."."..mills
        else
            return mins..":"..secs.."."..mills
        end
    end
end

function ReadableNumber(num, places)
    local ret
    local placeValue = ("%%.%df"):format(places or 0)
    if not num then
        return 0
    elseif num >= 1000000000000 then
        ret = placeValue:format(num / 1000000000000) .. "T" -- trillion
    elseif num >= 1000000000 then
        ret = placeValue:format(num / 1000000000) .. "B" -- billion
    elseif num >= 1000000 then
        ret = placeValue:format(num / 1000000) .. "M" -- million
    elseif num >= 1000 then
        ret = placeValue:format(num / 1000) .. "k" -- thousand
    else
        ret = num -- hundreds
    end
    return ret
end

function lerp(a, b, t)
	return a + (b - a) * t
end

function InZone(pos1, pos2)
    return #(pos1 - pos2) <= 14.5
end
