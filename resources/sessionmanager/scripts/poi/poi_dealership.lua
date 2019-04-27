local dealerships = {}

Citizen.CreateThread(function()
    local pois = GetPOIs("dealership")
    for _, poi in next, pois do
        poi.blip = AddBlipForCoord(poi.pos)
        SetBlipSprite(poi.blip, 477)
        SetBlipName(poi.blip, "Vehicle Dealership")
        SetBlipAsShortRange(poi.blip, true)
        table.insert(dealerships, poi)
    end

    local wasWithin = false
    while true do
        local within = false
        local pos = GetEntityCoords(PlayerPedId())
        if not WarMenu.IsMenuOpened("dealership") then
            for _, poi in next, pois do
                if InZone(pos, poi.pos) then
                    within = "Open Dealership"
                    if IsControlJustPressed(0, 38) then
                        WarMenu.OpenMenu("dealership")
                    end
                end
            end
            if within then
                if not wasWithin then
                    SetInstructions({{within, 38}})
                end
            else
                if wasWithin then
                    SetInstructions(false)
                end
            end
            wasWithin = within
        end
        Wait(0)
    end
end)
