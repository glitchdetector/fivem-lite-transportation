local playerCount = 0
local list = {}

RegisterServerEvent('hardcap:playerActivated')

AddEventHandler('hardcap:playerActivated', function()
  if not list[source] then
    playerCount = playerCount + 1
    list[source] = true
  end
end)

AddEventHandler('playerDropped', function()
  if list[source] then
    playerCount = playerCount - 1
    list[source] = nil
  end
end)

-- AddEventHandler('playerConnecting', function(name, setReason, deferrals)
--     local cv = math.min(63, GetConvarInt('sv_maxclients', 64))
--
--     print('Connecting: ' .. name .. "^7")
--     if playerCount >= cv then
--         local wait_time = 0
--         deferrals.defer()
--         while playerCount >= cv do
--             deferrals.update("[Tycoon] Server is full, waiting for available slot" .. string.rep(".", wait_time % 4) .. "")
--             wait_time = wait_time + 1
--             Wait(1000)
--             if wait_time > 60 then
--                 deferrals.done("[Tycoon] Could not find available slot, please try any of our other servers")
--                 break
--             end
--         end
--         deferrals.done()
--     end
-- end)
