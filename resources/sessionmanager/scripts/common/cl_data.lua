local PlayerData = {}

Event("data", function(data)
    PlayerData = data
    RefreshAllDeliveryJobs()
end)

function GetPlayerMoneyText()
    return ReadableNumber(GetPlayerMoney(), 2)
end

function GetPlayerMoney()
    return PlayerData.money or 0
end

function GetPlayerJob()
    return PlayerData.job or ""
end

function GetPlayerSkills()
    return PlayerData.skills or {}
end

function GetPlayerVehicles()
    return PlayerData.vehicles or {}
end

function GetPlayerFaction()
    return PlayerData.faction or ""
end

function GetPlayerDiamonds()
    return PlayerData.diamonds or 0
end

function GetPlayerInventory()
    return PlayerData.inventory or {}
end

function GetPlayerPosition()
    return PlayerData.position or {x=0.0,y=0.0,z=0.0}
end

function GetPlayerTruck()
    return PlayerData.truck or ""
end

function GetPlayerTrailer()
    return PlayerData.trailer or ""
end

function GetPlayerSkin()
    return PlayerData.skin or ""
end

function GetPlayerAdmin()
    return PlayerData.admin or false
end

function GetPlayerBanned()
    return PlayerData.banned or false
end

function GetPlayerBantime()
    return PlayerData.bantime or 0
end

function GetPlayerReason()
    return PlayerData.reason or ""
end

function GetPlayerPrimary()
    return PlayerData.primary or 0
end

function GetPlayerSecondary()
    return PlayerData.secondary or 0
end

Event("data:SetMoney", function(data)
    PlayerData["money"] = data
end)

Event("data:SetJob", function(data)
    PlayerData["job"] = data
end)

Event("data:SetExp", function(skill, data)
    GetPlayerSkills()[skill] = data
end)

Event("data:SetSkills", function(data)
    PlayerData["skills"] = data
end)

Event("data:SetVehicles", function(data)
    PlayerData["vehicles"] = data
end)

Event("data:SetFaction", function(data)
    PlayerData["faction"] = data
end)

Event("data:SetDiamonds", function(data)
    PlayerData["diamonds"] = data
end)

Event("data:SetInventory", function(data)
    PlayerData["inventory"] = data
end)

Event("data:SetPosition", function(data)
    PlayerData["position"] = data
end)

Event("data:SetTruck", function(data)
    PlayerData["truck"] = data
end)

Event("data:SetTrailer", function(data)
    PlayerData["trailer"] = data
end)

Event("data:SetSkin", function(data)
    PlayerData["skin"] = data
end)

Event("data:SetAdmin", function(data)
    PlayerData["admin"] = data
end)

Event("data:SetBanned", function(data)
    PlayerData["banned"] = data
end)

Event("data:SetBantime", function(data)
    PlayerData["bantime"] = data
end)

Event("data:SetReason", function(data)
    PlayerData["reason"] = data
end)

Event("data:SetPrimary", function(data)
    PlayerData["primary"] = data
end)

Event("data:SetSecondary", function(data)
    PlayerData["secondary"] = data
end)
