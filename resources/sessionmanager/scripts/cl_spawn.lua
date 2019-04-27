
local spawned = false
local inSpawnProgress = false

function IsInPlay()
    return inSpawnProgress == false and spawned == true
end

function FreezeEntity(entity, freeze)
    if not freeze then
        print("unfreezing entity")
        SetEntityCollision(entity, true)
        FreezeEntityPosition(entity, false)
    else
        print("freezing entity")
        SetEntityCollision(entity, false)
        FreezeEntityPosition(entity, true)
    end
end

local function Success(vehs)
    log("spawned vehicle")

    if #vehs > 1 then
        PLAYER_TRUCK = vehs[2]
        PLAYER_TRAILER = vehs[1]
    else
        PLAYER_TRUCK = vehs[1]
    end

    for _, veh in next, vehs do
        FreezeEntity(veh, true)
        TickNoCollision(true)
        SetEntityProofs(veh, true, true, true, false, true, true, true, true)
        SetVehicleTyresCanBurst(veh, false)
    end

    ShutdownLoadingScreen()
    DoScreenFadeIn(1500)
    while IsScreenFadingIn() do
        Citizen.Wait(0)
    end

    for _, veh in next, vehs do
        FreezeEntity(veh, false)
    end
    spawned = true
    TriggerEvent("lite:client:postSpawn")
end

Event("spawn", function(data)
    log("spawning")
    if not inSpawnProgress then return false end

    RequestModel(data.skin)
    while not HasModelLoaded(data.skin) do
        Wait(0)
    end
    SetPlayerModel(PlayerId(), data.skin)
    SetModelAsNoLongerNeeded(data.skin)

    -- SetEveryoneIgnorePlayer(PlayerId(), true)
    -- SetPoliceIgnorePlayer(PlayerId(), true)
    -- SetIgnoreLowPriorityShockingEvents(PlayerId(), true)
    -- SetPedAsCop(PlayerPedId(), true)

    local poi = ClosestPOI("service", data.position)
    SetEntityCoordsNoOffset(PlayerPedId(), poi.pos.x, poi.pos.y, poi.pos.z, false, false, false, true)
    NetworkResurrectLocalPlayer(poi.pos.x, poi.pos.y, poi.pos.z, poi.h, true, true, false)
    ClearArea(poi.pos.x, poi.pos.y, poi.pos.z, 5.0, true, false, false, false)

    local veh_set = {}
    table.insert(veh_set, data.truck)
    if IsModelASemiCab(data.truck) then
        log("spawning w/ trailer")
        table.insert(veh_set, data.trailer)
    end
    local prev = nil
    local dist = 0.0
    local veh_data = {x = poi.pos.x, y = poi.pos.y, z = poi.pos.z}
    local playerPed = PlayerPedId()
    local heading = GetEntityHeading(playerPed)
    local fwx = GetEntityForwardX(playerPed)
    local fwy = GetEntityForwardY(playerPed)
    local spawned_vehicles = {}
    local function step()
        log("step")
        local pos = {x = veh_data.x, y = veh_data.y, z = veh_data.z, h = heading}
        pos.x = pos.x + fwx * dist
        pos.y = pos.y + fwy * dist
        if #veh_set <= 0 then
            Success(spawned_vehicles)
            return false
        end
        local veh_model = table.remove(veh_set)
        log("summoning model " .. veh_model .. " with plate " .. data.plate)
        TriggerEvent("gd_utils:summon", veh_model, data.plate, function(veh)
            log("summoned vehicle")
            SetVehicleColours(veh, data.primary, data.secondary)
            SetEntityHeading(veh, heading)
            table.insert(spawned_vehicles, veh)
            if prev ~= nil then
                log("hooking vehicle")
                local loops = 0
                while not IsVehicleAttachedToTrailer(veh) do
                    local male_pos = GetWorldPositionOfEntityBone(prev, GetEntityBoneIndexByName(prev, "attach_male"))
                    local female_pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "attach_female"))
                    local veh_pos = GetEntityCoords(veh, true)
                    SetEntityCoords(veh, male_pos + (veh_pos - female_pos))
                    SetEntityHeading(veh, heading)
                    if loops > 1 then Wait(500) end
                    SetVehicleFixed(veh)
                    if loops > 1 then Wait(500) end
                    AttachVehicleToTrailer(veh, prev, 10.0)
                    AttachVehicleToTrailer(prev, veh, 10.0)
                    loops = loops + 1
                end
                SetVehicleColours(veh, GetVehicleColours(prev))
                log("hooked")
            end
            prev = veh
            dist = dist + (veh_data.step or 5.0)
            step()
        end, pos, true)
    end
    step()
end)

Event("preSpawn", function()
    log("pre-spawn")
    if inSpawnProgress then return false end
    if IsOnJob() then
        StopJob()
    end
    inSpawnProgress = true
    DoScreenFadeOut(1500)
    while IsScreenFadingOut() do
        Citizen.Wait(0)
    end
    RemoveEntity(GetTrailer())
    RemoveEntity(GetVehicle())
    SendEvent("getDeliveries")
    TriggerServerEvent("lite:server:spawn")
end)

Event("postSpawn", function()
    if not inSpawnProgress then return false end
    RefreshAllDeliveryJobs()
    inSpawnProgress = false
end)

Event("quickwarp", function(pos, name)
    chat("Quick-teleported to " .. name)
    TeleportToCoords(pos.x, pos.y, pos.z)
end)


RegisterNetEvent("spawnSetPed")
AddEventHandler("spawnSetPed", function(data)
    TriggerEvent("lite:client:spawn", data)
end)

Citizen.CreateThread(function()
    while true do
        Wait(10000)
        if spawned then
            local pos = GetEntityCoords(PlayerPedId(), false)
            local heading = GetEntityHeading(PlayerPedId())
            SendEvent("ping", {x = pos.x, y = pos.y, z = pos.z, h = heading})
        end
    end
end)

RegisterCommand("respawn", function()
    TriggerEvent("lite:client:preSpawn")
end)
