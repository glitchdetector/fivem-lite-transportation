local function hasVehicle(vehicles, model)
    for i = 1, #vehicles do
        if vehicles[i] == model then
            return true
        end
    end
    return false
end

Event("dealership:purchase", function(vehicle)
    local source = source

    if not vehicle then
        return
    end

    GetPlayerData(source, function(data)
        local ownsVehicle = hasVehicle(data.vehicles, vehicle.model)
        local isTruck = (vehicle.category == "truck" or vehicle.category == "cab" or vehicle.category == "van")
        local isTrailer = (vehicle.category == "trailer")
        
        -- Prevent buying th same vehicles/trailers.
        if isTruck and data.truck == vehicle.model then return end
        if isTrailer and data.trailer == vehicle.model then return end

        if not ownsVehicle then
            --Try paying, if succeeded, spawn the truck/trailer.
            local didPay = false
            if TryPayment(source, vehicle.price) then
                didPay = true
            end
            
            -- We did not pay, nothing left to do!
            if not didPay then
                SendEvent("notify", source, "You cannot afford this truck, you need ~r~$" .. ReadableNumber(vehicle.price, 2))
                return
            end
        end
            
        --Update the model
        if isTruck then
            data.truck = vehicle.model
        elseif isTrailer then
            data.trailer = vehicle.model
        end

        --Spawn the new stuff.
        SendEvent("preSpawn", source)

        if not ownsVehicle then
            -- Add to the array of owned vehicles of this player
            if vehicle.price > 0 then
                table.insert(data.vehicles, vehicle.model)
                SendEvent("data:SetVehicles", source, data.vehicles)
            end
        end
    end)
end)
