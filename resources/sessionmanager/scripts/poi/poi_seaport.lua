local seaports = {}
SeaportMenu = {
    selected = 1,
    current = 1,
    labels = {},
    selections = {},
}

Citizen.CreateThread(function()
    local pois = GetPOIs("seaport")
    for _, poi in next, pois do
        poi.blip = AddBlipForCoord(poi.pos)
        SetBlipSprite(poi.blip, 356)
        SetBlipName(poi.blip, "Seaport")
        SetBlipAsShortRange(poi.blip, true)
        table.insert(seaports, poi)
    end

    for n, poi in next, pois do
        table.insert(SeaportMenu.labels, poi.name)
        table.insert(SeaportMenu.selections, {poi = poi, dist = {}, price = {}})
        for _, inner_poi in next, pois do
            local dist = #(poi.pos - inner_poi.pos)
            local price = math.floor((dist * 9) / 1000) * 1000
            table.insert(SeaportMenu.selections[n].dist, dist)
            table.insert(SeaportMenu.selections[n].price, price)
        end
    end

    local wasWithin = false
    while true do
        local within = false
        local pos = GetEntityCoords(PlayerPedId())
        for n, poi in next, pois do
            if InZone(pos, poi.pos) then
                within = "Quick Travel - Seaport"
                if IsControlJustPressed(0, 38) then
                    SeaportMenu.current = n
                    WarMenu.OpenMenu("seaport")
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
