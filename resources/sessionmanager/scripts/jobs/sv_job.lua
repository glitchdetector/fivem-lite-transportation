Event("delivery", function(delivery)
    local source = source
    Server:GiveMoney(source, delivery.pay)
    Server:GiveExp(source, "deliveries", 1)
    RemoveDelivery(delivery.id, function(ok)
        if ok then
            GenerateNewDelivery()
        end
    end)
end)

function GenerateDelivery(poi)
    local destination = RandomPOI("delivery", poi.pos, 800.0)
    if destination then
        log("Generating new delivery job")
        local dist = #(poi.pos - destination.pos)
        local modifiers = {}
        modifiers.pay = math.random(90,250) / 100
        local totalPay = dist * modifiers.pay
        poi.job = {
            modifiers = modifiers,
            name = "Delivery",
            dist = dist,
            pay = totalPay,
            pos = destination.pos,
            id = poi.id,
            dest = destination.name,
        }
        SendEvent("setDeliveryJob", -1, poi)
    end
end

function GenerateNewDelivery()
    local poi = RandomPOI("delivery")
    while poi and poi.job do
        poi = RandomPOI("delivery")
        Wait(0)
    end
    if poi then
        GenerateDelivery(poi)
    end
end

function RemoveDelivery(poiId, cb)
    local poi = GetPOI(poiId)
    if poi.job then
        poi.job = nil
        SendEvent("removeDeliveryJob", -1, poi)
        if cb then cb(true) end
    else
        if cb then cb(false) end
    end
end

Event("getDeliveries", function()
    local source = source
    local pois = GetPOIs("delivery")
    for _, poi in next, pois do
        if poi.job then
            SendEvent("setDeliveryJob", source, poi)
        end
    end
end)
