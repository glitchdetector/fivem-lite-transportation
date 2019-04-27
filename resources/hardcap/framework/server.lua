local function log(text)
    print("^2[server] ^6" .. text .. "^7")
end

function Event(event, func)
    event = "lite:server:" .. event
    log("registered event " .. event)
    RegisterServerEvent(event)
    AddEventHandler(event, function(...)
        log("triggered event " .. event)
        func(...)
    end)
end

function SendEvent(event, source, ...)
    event = "lite:client:" .. event
    log("sending event " .. event .. " to " .. source)
    TriggerClientEvent(event, source, ...)
end

function BanPlayer(source, reason)
    local data = GetPlayerData(source)
    data.banned = true
    data.bantime = 0
    data.reason = reason
    log("banning player " .. source .. ": " .. reason)
    KickPlayer(source, "Banned: " .. reason)
end

function KickPlayer(source, reason)
    log("kicking player " .. source .. ": " .. reason)
    DropPlayer(source, reason)
end

AddEventHandler("playerConnecting", function(name, SKR, deferral)
    local source = source
    local done = false
    local function success(text)
        if done then return false end
        done = true
        Wait(500)
        deferral.done()
    end
    local function fail(text)
        if done then return false end
        done = true
        Wait(500)
        log("player " .. source .. " failed connection: " .. text)
        deferral.done(": " .. text .. " :")
        ClearPlayerData(source)
    end
    local function update(text)
        log("player " .. source .. " connection status: " .. text)
        deferral.update(text .. " :")
    end
    update("Loading account data")
    LoadPlayerData(source, function(ok)
        if ok then
            update("Verifying account data")
            GetPlayerData(source, function(data)
                if data then
                    if not data.banned then
                        success()
                    else
                        local expireText = "Permanently banned"
                        if data.bantime ~= 0 then
                            if data.bantime > os.time() then
                                expireText = "Suspended until " .. os.date("%c", data.bantime)
                            else
                                data.banned = false
                                data.bantime = 0
                                success()
                            end
                        end
                        fail(expireText .. " for " .. data.reason .. "")
                    end
                else
                    fail("Failed to verify account data")
                end
            end)
        else
            fail("Failed to load account data")
        end
    end)
end)

RegisterServerEvent("playerSpawned")
AddEventHandler("playerSpawned", function()
    local source = source
    log("player " .. source .. " spawned")
    GetPlayerData(source, function(data)
        TriggerClientEvent("lite:client:preSpawn", source, data)
        TriggerClientEvent("lite:client:data:SetMoney", source, data.money)
    end)
end)

RegisterServerEvent("lite:server:spawn")
AddEventHandler("lite:server:spawn", function()
    local source = source
    GetPlayerData(source, function(data)
        TriggerClientEvent("spawnSetPed", source, data)
        SendEvent("data", source, data)
        SendEvent("playerInfo", -1, source, "admin", IsAdmin(source))
        SendEvent("playerInfo", -1, source, "title", data.title)
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(60000)
        for _, user in pairs(GetPlayers()) do
            SavePlayerData(user)
        end
    end
end)

RegisterServerEvent("lite:server:ping")
AddEventHandler("lite:server:ping", function(pos)
    local source = source
    GetPlayerData(source, function(data)
        if pos.x then data.position.x = pos.x end
        if pos.y then data.position.y = pos.y end
        if pos.z then data.position.z = pos.z end
        if pos.h then data.position.h = pos.h end
    end)
end)

AddEventHandler("playerDropped", function(reason)
    local source = source
    log("player " .. source .. " dropped: " .. reason)
    ClearPlayerData(source)
end)
