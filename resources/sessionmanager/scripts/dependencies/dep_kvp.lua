function getActualKvp(name)
    local kvp = GetResourceKvpInt(name)
    if kvp == nil then
        return false, "nil"
    end
    if kvp == 0 then
        return false, "zero"
    end
    return true, "actually " .. kvp
end

function setActualKvp(name, bool)
    if bool then
        SetResourceKvpInt(name, 1)
    else
        SetResourceKvpInt(name, 0)
    end
end

function getActualKvpFloat(name)
    local kvp = GetResourceKvpFloat(name)
    if kvp == nil then
        return 0.0
    end
    return kvp
end

function setActualKvpFloat(name, val)
    SetResourceKvpFloat(name, val)
end
