Citizen.CreateThread(function()
    math.randomseed( os.time() )
    Wait(100)
    PostLoad()
end)

function PostLoad()
    local deliveries = GetPOIs("delivery")
    local _t = {}
    for _, poi in pairs(deliveries) do
        table.insert(_t, poi)
    end
    local _d = {}
    for i = 0, 24 do
        table.insert(_d, table.remove(_t, math.random(#_t)))
    end
    for _, poi in pairs(_d) do
        GenerateDelivery(poi)
    end
end
