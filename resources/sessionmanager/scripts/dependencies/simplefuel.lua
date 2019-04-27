--[[
    SIMPLE FUEL
    BY GLITCHDETECTOR
    CUSTOM
]]

local fuelRemainder = 100.0
local fuelUsage = 0.0

function SetFuel(value)
    value = math.min(100, math.max(0, value))
    if value <= 0.0 then
        SetVehicleFuelLevel(GetVehiclePedIsUsing(PlayerPedId(), false), 0.0)
    elseif value <= 35.0 then
        SetVehicleFuelLevel(GetVehiclePedIsUsing(PlayerPedId(), false), value * 3.0)
    else
        SetVehicleFuelLevel(GetVehiclePedIsUsing(PlayerPedId(), false), 100.0)
    end
    if value ~= fuelRemainder then
        fuelRemainder = value
        return true
    end
    return false
end

function GetFuel()
    return fuelRemainder
end

function GetFuelColor()
    return 250, 130, 0
end

function GetFuelUsage()
    return fuelUsage
end

function AddFuel(value)
    return SetFuel(GetFuel() + value)
end

function TakeFuel(value)
    fuelUsage = value
    return SetFuel(GetFuel() - value)
end

Citizen.CreateThread(function()
    while true do
        if GetUserConfig("game_disable_fuel", false) then
            Wait(1000)
        else
            local veh = GetVehiclePedIsIn(PlayerPedId())
            local rpm = GetVehicleCurrentRpm(veh)
            local usage = math.max(0.0, math.floor((rpm - 0.2) * 1000))
            TakeFuel(usage / 1000000)
            Wait(0)
        end
    end
end)
