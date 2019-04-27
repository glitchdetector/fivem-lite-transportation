local wasWithin = false
Citizen.CreateThread(function()
    while true do
        local within = false
        local pos = GetEntityCoords(PlayerPedId())
        if IsOnJob("trucking") then
            local CURRENT_JOB = GetCurrentJob()
            for n, delivery in next, CURRENT_JOB.deliveries do
                if InZone(pos, delivery.pos) then
                    within = "Deliver ($" .. ReadableNumber(delivery.pay, 2) .. " profit)"
                    if IsControlJustPressed(0, 38) then
                        SendEvent("delivery", delivery)
                        ClearJob(delivery)
                        CURRENT_JOB.deliveries[n] = nil
                    end
                end
            end
            if #CURRENT_JOB.deliveries <= 0 then
                log("Deliveries complete")
                StopJob()
            end
        elseif IsOnJob() then
            -- Other job
        else
            for _, poi in next, POI do
                if poi.type == "delivery" then
                    if poi.job then
                        if InZone(pos, poi.pos) then
                            within = "Start Job ($" .. ReadableNumber(poi.job.pay, 2) .. " profit)"
                            if IsControlJustPressed(0, 38) then
                                StartJob("trucking", poi.job)
                            end
                        end
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
