local function log(text)
    print("^2[skills] ^6" .. text .. "^7")
end

function GetExp(source, skill)
    local data = GetPlayerData(source)
    return data.skills[skill]
end

function GiveExp(source, skill, amount)
    local exp = GetExp(source, skill)
    log(("giving %s %s exp to %s"):format(amount, skill, source))
    SetExp(source, skill, exp + amount)
end

function TakeExp(source, skill, amount)
    local exp = GetExp(source, skill)
    log(("taking %s %s exp from %s"):format(amount, skill, source))
    SetExp(source, skill, exp - amount)
end

function SetExp(source, skill, amount)
    local data = GetPlayerData(source)
    log(("setting%s exp to %s for %s"):format(amount, skill, source))
    local was = data.skills[skill]
    data.skills[skill] = amount
    SendEvent("changeExp", source, skill, was, amount)
    SendEvent("data:SetExp", source, skill, amount)
end
