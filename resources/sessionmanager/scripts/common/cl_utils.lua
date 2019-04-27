RegisterNetEvent("gd_utils:summon") -- vehicle plate -- Summon a vehicle and put the player in it
AddEventHandler("gd_utils:summon", function(vehicle, plate, cb, loc, deletable)
    local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped)
	local heading = GetEntityHeading(ped)
    local model = GetHashKey(vehicle)
    local vehName = GetLabelText(GetDisplayNameFromVehicleModel(model))

    if loc then
        pos = loc
        if type(loc) ~= 'vector3' and loc.h then
            heading = loc.h
        end
    end

    if IsModelInCdimage(model) then
        StartLoadingText("Spawning " .. vehName)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(5) end

    	local veh = CreateVehicle(model, pos.x, pos.y, pos.z, heading, true, false)

        if plate then
            SetVehicleNumberPlateText(veh, plate)
        end
        local modelName = GetDisplayNameFromVehicleModel(model)
        SetVehicleColours(veh, math.random(0, 159), math.random(0, 159))
        SetVehicleNeedsToBeHotwired(veh, false)
        SetVehicleBodyHealth(veh, 1000.0)
        SetEntityMaxHealth(veh, 1000)
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehicleAlarm(veh, false)
    	SetPedIntoVehicle(ped, veh, -1)
        if deletable then
            DecorSetBool(veh, "omni_can_delete", true)
        end
        if cb then
            cb(veh)
        end
        Wait(500)
        StopLoadingText()
    else
        TriggerEvent("gd_utils:notify", "~r~Vehicle model ~y~" .. vehicle .. " ~r~is not a valid vehicle model")
    end
end)

local notifyStack = {}
local notifyTimer = 10
function ShowNotify()
    notifyTimer = 10
    local text = table.concat(notifyStack, "\n~w~")
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
    TriggerEvent("omni:notification", text)
    notifyStack = {}
end

function RemoveEntity(entity)
    SetEntityAsMissionEntity(entity, true, true)
    DeleteEntity(entity)
end

function IsInVehicle()
    return IsPedInAnyVehicle(PlayerPedId(), false)
end

function PlayerHasBoughtVehicle(model)
    local ownedVehicles = GetPlayerVehicles()
    for i = 1, #ownedVehicles do
        if string.find(ownedVehicles[i]:lower(), model:lower()) then
            return true
        end
    end

    return false
end

function HasTrailer()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        local hasTrailer, trailer = GetVehicleTrailerVehicle(veh)
        if hasTrailer then
            return true
        end
    end
    return false
end

local function getVehicleHealth(veh)
    local body = GetVehicleBodyHealth(veh)
    local engine = GetVehicleEngineHealth(veh)
    return math.min(2000, math.min(body * 2, math.min(engine * 2, math.min(engine + body))))
end

function GetVehicleHealth()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        return getVehicleHealth(veh)
    end
    return 0
end

function GetTrailerHealth()
    local hasTrailer, trailer = GetTrailer()
    if hasTrailer then
        return getVehicleHealth(trailer)
    end
    return 0
end

Event("notify", function(text)
    if #notifyStack >= 1 then
        ShowNotify()
    end
    table.insert(notifyStack, text)
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        notifyTimer = notifyTimer - 1
        if notifyTimer <= 0 and #notifyStack >= 1 then
            ShowNotify()
        end
    end
end)

function DrawRectCenter(x, y, width, height, r, g, b, a)
    DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

function SetBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

function useOrigin()
    return true
end

function DrawText3D(text, x, y, z, s, font, a)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    if s == nil then
        s = 1.0
    end
    if font == nil then
        font = 4
    end
    if a == nil then
        a = 255
    end

    local scale = ((1 / dist) * 2) * s
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        if useOrigin() then
            SetDrawOrigin(x, y, z, 0)
        end
        SetTextScale(0.0 * scale, 1.1 * scale)
        if useOrigin() then
            SetTextFont(font)
        else
            SetTextFont(font)
        end
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, a)
        -- SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        if useOrigin() then
            DrawText(0.0, 0.0)
            ClearDrawOrigin()
        else
            DrawText(_x, _y)
        end
    end
end

function PlayerPosition()
    local ped = PlayerPedId()
    return GetEntityCoords(ped, false) or vector3(0.0, 0.0, 0.0)
end
