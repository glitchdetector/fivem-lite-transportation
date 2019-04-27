Server = nil

local Threads = {}
function Thread(func)
    table.insert(Threads, func)
end

Citizen.CreateThread(function()
    Wait(1000)
    while not Server do
        Server = exports['hardcap']
    end
    while true do
        for n, threadFunc in pairs(Threads) do
            threadFunc(Server)
            table.remove(n)
        end
        Wait(0)
    end
end)
