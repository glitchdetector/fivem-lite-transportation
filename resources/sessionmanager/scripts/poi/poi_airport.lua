local airports = {}
AirportMenu = {
    selected = 1,
    current = 1,
    labels = {},
    selections = {},
}

Citizen.CreateThread(function()
    local pois = GetPOIs("airport")
    for _, poi in next, pois do
        poi.blip = AddBlipForCoord(poi.pos)
        SetBlipSprite(poi.blip, 359)
        SetBlipName(poi.blip, "Airport")
        SetBlipAsShortRange(poi.blip, true)
        table.insert(airports, poi)
    end

    for n, poi in next, pois do
        table.insert(AirportMenu.labels, poi.name)
        table.insert(AirportMenu.selections, {poi = poi, dist = {}, price = {}})
        for _, inner_poi in next, pois do
            local dist = #(poi.pos - inner_poi.pos)
            local price = math.floor((dist * 12) / 500) * 500
            table.insert(AirportMenu.selections[n].dist, dist)
            table.insert(AirportMenu.selections[n].price, price)
        end
    end

    local wasWithin = false
    while true do
        local within = false
        local pos = GetEntityCoords(PlayerPedId())
        for n, poi in next, pois do
            if InZone(pos, poi.pos) then
                within = "Quick Travel - Airport"
                if IsControlJustPressed(0, 38) then
                    AirportMenu.current = n
                    WarMenu.OpenMenu("airport")
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
        Wait(0)
    end
end)
