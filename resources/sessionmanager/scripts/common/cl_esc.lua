--[[
    EMERGENCY SIREN CONTROL
]]

Citizen.CreateThread(function()
    -- LOCAL OPTIMIZATION
    local Wait = Wait
    local GetVehiclePedIsUsing = GetVehiclePedIsUsing
    local PlayerPedId = PlayerPedId
    local IsVehicleSirenOn = IsVehicleSirenOn
    local DisableControlAction = DisableControlAction
    local IsDisabledControlJustPressed = IsDisabledControlJustPressed
    local DecorExistOn = DecorExistOn
    local DecorGetBool = DecorGetBool
    local DecorSetBool = DecorSetBool
    local PlaySoundFrontend = PlaySoundFrontend
    -- END LOCAL OPTIMIZATION
    while true do
        Wait(0)
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        if veh then
            -- INPUT_SCRIPT_RLEFT (Left Ctrl)
            if IsVehicleSirenOn(veh) then
                DisableControlAction(0, 80, true)
                if IsDisabledControlJustPressed(0, 80) then
                    if DecorExistOn(veh, "esc_siren_enabled") and DecorGetBool(veh, "esc_siren_enabled") then
                        DecorSetBool(veh, "esc_siren_enabled", false)
                    else
                        DecorSetBool(veh, "esc_siren_enabled", true)
                    end
                    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    -- LOCAL OPTIMIZATION
    local EnumerateVehicles = EnumerateVehicles
    local DecorExistOn = DecorExistOn
    local DecorGetBool = DecorGetBool
    local DisableVehicleImpactExplosionActivation = DisableVehicleImpactExplosionActivation
    local Wait = Wait
    -- END LOCAL OPTIMIZATION
    while true do
        Wait(0)
        local _c = 0
        for veh in EnumerateVehicles() do
            if DecorExistOn(veh, "esc_siren_enabled") and DecorGetBool(veh, "esc_siren_enabled") then
                DisableVehicleImpactExplosionActivation(veh, false)
            else
                DisableVehicleImpactExplosionActivation(veh, true)
            end
            _c = (_c + 1) % 10
            if _c == 0 then
                Wait(0)
            end
        end
    end
end)
