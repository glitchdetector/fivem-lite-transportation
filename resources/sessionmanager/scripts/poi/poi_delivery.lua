Event("setDeliveryJob", function(poi)
    local start = GetPOI(poi.id)
    if start then
        SetDeliveryJob(start, poi.job)
    end
end)

Event("removeDeliveryJob", function(poi)
    local start = GetPOI(poi.id)
    if start then
        ClearDelivery(start)
    end
end)

function ClearDeliveryBlip(poi)
    if poi.blip then
        log("clearing delivery blip")
        RemoveBlip(poi.blip)
        poi.blip = nil
    end
end

function ClearDeliveryJob(poi)
    if poi.job then
        log("clearing delivery job " .. poi.name)
        poi.job = nil
    end
end

function ClearDelivery(poi)
    log("clearing delivery")
    ClearDeliveryBlip(poi)
    ClearDeliveryJob(poi)
end

function SetDeliveryJob(poi, job)
    log("setting new delivery job " .. poi.name)
    ClearDelivery(poi)
    poi.job = job
    poi.job.pay = job.dist * (GetVehicleBonus() + job.modifiers.pay)
    local blip = AddBlipForCoord(poi.pos)
    poi.blip = blip
    SetBlipSprite(blip, 408)
    SetBlipName(blip, job.name)
    SetBlipAsShortRange(blip, true)
    SetBlipCategory(blip, 10)
    RefreshDeliveryJob(poi)
end

function RefreshDeliveryJob(poi)
    if poi.job then
        poi.job.pay = poi.job.dist * (GetVehicleBonus() + poi.job.modifiers.pay)
        local blip = poi.blip
        ResetBlipInfo(blip)
        SetBlipInfoTitle(blip, poi.job.name, false)
        SetBlipInfoEconomy(blip, "", ReadableNumber(poi.job.pay, 2))
        AddBlipInfoName(blip, "Distance", ("%.2f km"):format(poi.job.dist / 1000))
        AddBlipInfoName(blip, "Destination", ("%s"):format(poi.job.dest))

        local skills = GetPlayerSkills()

        local highValue = poi.job.modifiers.pay > 2.2
        local longDist = poi.job.dist > 4000
        local shortDist = poi.job.dist < 1500

        if skills.deliveries and skills.deliveries >= 15 then
            if shortDist then
                SetBlipSprite(blip, 430)
                SetBlipName(blip, "Short Distance Delivery")
                SetBlipInfoTitle(blip, "Short Distance Delivery", false)
            end
        end
        if skills.deliveries and skills.deliveries >= 25 then
            if longDist then
                SetBlipSprite(blip, 479)
                SetBlipName(blip, "Long Distance Delivery")
                SetBlipInfoTitle(blip, "Long Distance Delivery", false)
            end
        end
        if skills.deliveries and skills.deliveries >= 50 then
            if highValue then
                SetBlipSprite(blip, 500)
                SetBlipName(blip, "High Value Delivery")
                SetBlipInfoTitle(blip, "High Value Delivery", false)
            end
        end
        if skills.deliveries and skills.deliveries >= 100 then
            if highValue and longDist then
                SetBlipColour(blip, 5)
                SetBlipSprite(blip, 586)
                SetBlipName(blip, "Extremely Valuable Delivery")
                SetBlipInfoTitle(blip, "Extremely Valuable Delivery", false)
            end
        end
    end
end

function RefreshAllDeliveryJobs()
    local pois = GetPOIs("delivery")
    for _, poi in next, pois do
        RefreshDeliveryJob(poi)
    end
end
