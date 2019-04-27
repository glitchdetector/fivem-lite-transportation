local services = {}

Citizen.CreateThread(function()
    local pois = GetPOIs("service")
    for _, poi in next, pois do
        poi.blip = AddBlipForCoord(poi.pos)
        SetBlipSprite(poi.blip, 446)
        SetBlipName(poi.blip, poi.name)
        SetBlipAsShortRange(poi.blip, true)
        SetBlipCategory(poi.blip, 11)
        table.insert(services, poi)
    end

    local wasWithin = false
    while true do
        local within = false
        local pos = GetEntityCoords(PlayerPedId())
        for n, poi in next, pois do
            if InZone(pos, poi.pos) then
                if not WarMenu.IsAnyMenuOpened() then
                    within = "Open Mod Shop"
                    if IsControlJustPressed(0, 38) then
                        WarMenu.OpenMenu("modshop")
                    end
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
