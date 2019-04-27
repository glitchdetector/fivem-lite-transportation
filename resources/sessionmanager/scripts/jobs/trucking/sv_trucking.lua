Thread(function(sv)
    RegisterNetEvent("lite:trucking:start")
    AddEventHandler("lite:trucking:start", function()
        local source = source
        local data = sv:GetPlayerData(source)
        if data.job == "Trucker" then
            print("is trucker!")
        else
            print("not a trucker!")
        end
    end)
    while true do
        Wait(0)
    end
end)
