local function log(text)
    print("^2[money] ^6" .. text .. "^7")
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

function GiveMoney(source, amount)
    local money = GetMoney(source)
    log("giving $" .. amount .. " to player " .. source)
    if amount > 0 then
        SendEvent("notify", source, "Received ~g~$" .. ReadableNumber(amount, 2))
    end
    local data = GetPlayerData(source)
    data.earned = data.earned + amount
    SetMoney(source, money + amount)
end

function TakeMoney(source, amount)
    local money = GetMoney(source)
    log("taking $" .. amount .. " from player " .. source)
    if amount > 0 then
        SendEvent("notify", source, "Paid ~g~$" .. ReadableNumber(amount, 2))
    end
    local data = GetPlayerData(source)
    data.paid = data.paid + amount
    SetMoney(source, money - amount)
end

function SetMoney(source, amount)
    local data = GetPlayerData(source)
    log("setting player " .. source .." money to $" .. amount)
    data.money = amount
    TriggerClientEvent("lite:client:data:SetMoney", source, amount)
end

function GetMoney(source)
    local data = GetPlayerData(source)
    return data.money
end

function TryPayment(source, amount)
    local money = GetMoney(source)
    if money >= amount then
        TakeMoney(source, amount)
        return true
    end
    return false
end
