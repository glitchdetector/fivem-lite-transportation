
Citizen.CreateThread(function()
    local smallText = ""
    local smallIcon = ""
    local bigText = ""
    local bigIcon = "logo"
    local text = "Roaming"
    while true do
        if GetPlayerAdmin() then
            smallIcon = "dragon"
            smallText = "Administrator"
        else

        end

        local veh = GetVehicleByModel(GetPlayerTruck())
        if veh then
            if IsOnJob() then
                local job = GetCurrentJob()
                text = "En-route: " .. job.deliveries[1].dest
            else
                text = "Roaming in their " .. veh.name
            end
        end

        local skills = GetPlayerSkills()
        if skills.deliveries then
            bigText = ("%s successful deliver%s"):format(skills.deliveries, skills.deliveries ~= 1 and "ies" or "y")
        end

        SetRichPresence(text)
        SetDiscordRichPresenceAsset(bigIcon)
        SetDiscordRichPresenceAssetText(bigText)
        SetDiscordRichPresenceAssetSmall(smallIcon)
        SetDiscordRichPresenceAssetSmallText(smallText)
        Wait(1000)
    end
end)
