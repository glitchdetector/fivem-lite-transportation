function TeleportToWaypoint()
	if(not IsWaypointActive())then
		log("no waypoint")
		return
	end
	local targetPed = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(targetPed))then
		targetPed = GetVehiclePedIsUsing(targetPed)
	end
	local waypointBlip = GetFirstBlipInfoId(8) -- 8 = Waypoint ID
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()))
	local ground
	local groundFound = false
	local groundCheckHeights = {0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}
	for i,height in ipairs(groundCheckHeights) do
		log("check " .. height)
		RequestCollisionAtCoord(x, y, height)
		while not HasCollisionLoadedAroundEntity(targetPed) do
			Wait(0)
		end
		SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if(ground) then
			z = z + 3
			groundFound = true
			break;
		end
	end
	log("teleporting to waypoint")
	TeleportToCoords(x, y, z, true)
end

function TeleportToPlayer(player)
	if NetworkIsPlayerActive(player) then
		log("teleporting to player " .. GetPlayerName(player))
		local ped = GetPlayerPed(player)
		local pos = GetEntityCoords(ped)
		TeleportToCoords(pos.x, pos.y, pos.z, true)
	end
end

local function AdminEvent(event, func)
	RegisterNetEvent("lite:admin:" .. event)
	AddEventHandler("lite:admin:" .. event, function(code, ...)
		TriggerServerEvent("lite:admin:callbackCode", code)
		log("admin event " .. event .. " callback")
		func(...)
	end)
end

AdminEvent("marker", function()
	TeleportToWaypoint()
end)

AdminEvent("menu", function()
	WarMenu.OpenMenu("admin")
end)

AdminEvent("goto", function(player)
	TeleportToPlayer(player)
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 170) then
            TriggerServerEvent("lite:admin:request", "lite:admin:marker")
        end
        if IsControlJustPressed(0, 288) then
            TriggerServerEvent("lite:admin:request", "lite:admin:menu")
        end
        if IsControlJustPressed(0, 327) then
            local pos = GetEntityCoords(PlayerPedId(), false)
            local heading = GetEntityHeading(PlayerPedId())
            local zoneName = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
            local str, cross = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
            local areaName = GetStreetNameFromHashKey(str)
            local name = zoneName .. " - " .. areaName
            TriggerServerEvent("lite:admin:pos", {name = name, x = pos.x, y = pos.y, z = pos.z, h = heading})
        end
    end
end)
