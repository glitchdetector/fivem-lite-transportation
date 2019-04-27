local fuels = {}

local wasEnabled = true
Citizen.CreateThread(function()
    local pois = GetPOIs("fuel")
    for _, poi in next, pois do
        poi.blip = AddBlipForCoord(poi.pos)
        SetBlipSprite(poi.blip, 361)
        SetBlipName(poi.blip, "Fuel Station")
        SetBlipAsShortRange(poi.blip, true)
        table.insert(fuels, poi)
    end

    local wasWithin = false
    while true do
        local isEnabled = not GetUserConfig("game_disable_fuel", false)
        if isEnabled then
            if not wasEnabled then
                for _, poi in next, pois do
                    if not poi.blip then
                        poi.blip = AddBlipForCoord(poi.pos)
                        SetBlipSprite(poi.blip, 361)
                        SetBlipName(poi.blip, "Fuel Station")
                        SetBlipAsShortRange(poi.blip, true)
                    end
                end
                wasEnabled = true
            end
            local within = false
            local pos = GetEntityCoords(PlayerPedId())
            for _, poi in next, fuels do
                if InZone(pos, poi.pos) then
                    within = "Re-fuel"
                    if IsControlPressed(0, 22) then
                        AddFuel(1)
                    end
                end
            end
            if within then
                if not wasWithin then
                    SetInstructions({{within, 22}})
                end
            else
                if wasWithin then
                    SetInstructions(false)
                end
            end
            wasWithin = within
        else
            if wasEnabled then
                for _, poi in next, pois do
                    if poi.blip then
                        RemoveBlip(poi.blip)
                        poi.blip = nil
                    end
                end
                wasEnabled = false
            end
        end
        Wait(0)
    end
end)
