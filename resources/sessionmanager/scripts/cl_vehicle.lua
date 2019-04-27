PLAYER_TRUCK = nil
PLAYER_TRAILER = nil

function GetVehicle()
    if IsInVehicle() then
        return GetVehiclePedIsIn(PlayerPedId(), false)
    end
    return PLAYER_TRUCK
end

function GetTrailer()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        local hasTrailer, trailer = GetVehicleTrailerVehicle(veh)
        if hasTrailer then
            return trailer
        end
    end
    return PLAYER_TRAILER
end

-- Prevent vehicle exit
Citizen.CreateThread(function()
    while true do
        Wait(0)
        DisableControlAction(0, 75, true)
        SetMaxWantedLevel(0)
        SetPlayerWantedLevelNow(PlayerId(), 0)
        SetPlayerWantedLevel(PlayerId(), 0, false)
        SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
    end
end)

function GetVehicleSpeed()
    local veh = GetVehicle()
    local speed = GetEntitySpeed(veh)
    return speed
end

-- Cruise Control
CruiseControl = {
    enabled = false,
    target = 0.0,
    bar = false,
}

Citizen.CreateThread(function()
    local wasAccel = false
    local wasEnabled = false
    while true do
        Wait(0)
        if CruiseControl.enabled then
            local veh = GetVehicle()
            local speed = GetEntitySpeed(veh)
            local gear = GetVehicleCurrentGear(veh)
            if math.abs(speed - CruiseControl.target) > 10.0 then
                CruiseControl.enabled = false
            end
            if IsControlPressed(0, 71) or IsControlPressed(0, 72) then
                wasAccel = true
                if gear == 0 then
                    CruiseControl.enabled = false
                else
                    CruiseControl.target = speed
                end
            else
                if wasAccel then
                    wasAccel = false
                end
                if IsVehicleOnAllWheels(veh) then
                    SetVehicleForwardSpeed(veh, lerp(speed, CruiseControl.target, 0.2))
                end
            end
            if IsControlJustPressed(0, 20) then
                if wasEnabled then
                    CruiseControl.enabled = false
                end
            end
            if not wasEnabled then
                wasEnabled = true
                SetInstructions()
            end
        else
            if IsControlJustPressed(0, 20) then
                if not wasEnabled then
                    local veh = GetVehicle()
                    local speed = GetEntitySpeed(veh)
                    CruiseControl.enabled = true
                    CruiseControl.target = speed
                end
            end
            if wasEnabled then
                wasEnabled = false
                SetInstructions()
            end
        end
    end
end)

local function checkVehicle(veh)
    if not IsVehicleDriveable(veh, false) then
        chat("Your vehicle has become undriveable")
        TriggerEvent("lite:client:preSpawn")
    end
    if IsEntityDead(veh) then
        log("Your vehicle is dead")
        TriggerEvent("lite:client:preSpawn")
    end
    if IsVehicleStuckOnRoof(veh) then
        log("Your vehicle is stuck")
        TriggerEvent("lite:client:preSpawn")
    end
end

-- Respawn if in destroyed vehicle
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if IsInPlay() then
            if IsInVehicle() then
                checkVehicle(GetVehicle())
            else
                chat("You abandoned your vehicle")
                TriggerEvent("lite:client:preSpawn")
            end
            if HasTrailer() then
                checkVehicle(GetTrailer())
            else
                if IsModelASemiCab(GetPlayerTruck()) then
                    chat("You abandoned your trailer")
                    TriggerEvent("lite:client:preSpawn")
                end
            end
        end
    end
end)

function GetVehicleBonus()
    local bonus = 0.0
    if HasTrailer() then
        bonus = bonus + GetVehicleBonusData(GetPlayerTrailer())
        log("Trailer Bonus: " .. bonus)
    end
    bonus = bonus + GetVehicleBonusData(GetPlayerTruck())
    log("Total Bonus: " .. bonus)
    return bonus
end
