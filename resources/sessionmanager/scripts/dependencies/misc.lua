--[[
    MISC HANDLERS
    BY GLITCHDETECTOR
    CUSTOM
]]

function Event(event, func)
    event = "lite:client:" .. event
    log("registered event " .. event)
    RegisterNetEvent(event)
    AddEventHandler(event, function(...)
        log("triggered event " .. event)
        func(...)
    end)
end

function SendEvent(event, ...)
    event = "lite:server:" .. event
    log("sending event " .. event)
    TriggerServerEvent(event, ...)
end

function TeleportToCoords(x, y, z, nofade)
	log(("teleporting to %s %s %s"):format(x, y, z))
	local targetPed = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(targetPed))then
		targetPed = GetVehiclePedIsUsing(targetPed)
	end
    if not nofade then
        DoScreenFadeOut(500)
        while IsScreenFadingOut() do
            Wait(0)
        end
    end
    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(targetPed) do
        Wait(0)
    end
	SetEntityCoords(targetPed, x, y, z, 0, 0, 1, false)
    if not nofade then
        Wait(500)
        DoScreenFadeIn(1500)
        while IsScreenFadingIn() do
            Wait(0)
        end
    end
end

function comma_value(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

function round(val, decimal)
    if (decimal) then
        return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
    else
        return math.floor(val + 0.5)
    end
end

function format_num(amount, decimal, prefix, neg_prefix)
    local str_amount, formatted, famount, remain

    decimal = decimal or 2 -- default 2 decimal places
    neg_prefix = neg_prefix or "-" -- default negative sign

    famount = math.abs(round(amount, decimal))
    famount = math.floor(famount)

    remain = round(math.abs(amount) - famount, decimal)

    -- comma to separate the thousands
    formatted = comma_value(famount)

    -- attach the decimal portion
    if (decimal > 0) then
        remain = string.sub(tostring(remain), 3)
        formatted = formatted .. "." .. remain ..
        string.rep("0", decimal - string.len(remain))
    end

    -- attach prefix string e.g '
    formatted = (prefix or "") .. formatted

    -- if value is negative then format accordingly
    if (amount < 0) then
        if (neg_prefix == "()") then
            formatted = "("..formatted ..")"
        else
            formatted = neg_prefix .. formatted
        end
    end

    return formatted
end

function StartLoadingText(text)
    BeginTextCommandBusyString("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandBusyString()
end

function StopLoadingText()
    RemoveLoadingPrompt()
end

Citizen.CreateThread(function()
    AddTextEntry("BLIP_PROPCAT", "~y~Job~s~")
    AddTextEntry("BLIP_APARTCAT", "~y~Service Station~s~")
end)

Tips = {
    TipLabels = {"How to play", "Progression", "Unlocks", "Service Stations", "Commands", "Quick Travel", "Customization", "Fuel", "Credits"},
    TipTexts = {
        {
            "Pick up jobs from Job markers",
            "Deliver the Job for money",
            "Purchase new vehicles money",
            "Make more money",
        },
        {
            "Purchase a better vehicle",
            "Make more money per job",
            "Get the best equipment",
            "Be the very best"
        },
        {
            "Delivery count unlocks features",
            "At 15, you can see specifics on deliveries",
            "Again at 25, 50 and 100",
            "Use this knowledge to better gain money",
        },
        {
            "Service Stations are re-spawn points",
            "Collisions are disabled in the area",
        },
        {
            {"/respawn", "lite:client:preSpawn"},
            "Warps you to the closest Service Station",
            "Re-spawning will cancel your current job",
        },
        {
            "Allows you to quickly move across the map",
            "Can be done between Airports and Seaports",
            "Quick Travel is free when not on a job",
        },
        {
            "Your equipment color can be changed",
            "Go to any Service Station to get started",
            "All your equipment shares the same colors",
            "Color customization is free of charge",
        },
        {
            "All vehicles use fuel over time",
            "Fuel is automatically replenished at Service Stations",
            "Fuel Stations around the map offers re-fills",
            "Fuel is free of charge",
        },
        {
            "main developer, ~g~glitchdetector",
            "misc development, ~g~Syntasu",
            "instruction buttons, ~g~IllusiveTea",
            "menu system, ~g~WarXander",
            "paradise area checker, ~g~DemmyDemon",
            "server base, ~g~CitizenFX",
            "intro video, ~g~Alan W",
        }
    },
    selected = 1,
}

for n, tip in next, Tips.TipLabels do
    Tips.TipLabels[n] = tip .. (" (%s/%s)"):format(n, #Tips.TipLabels)
end

players = {}
local playerInfo = {}
PlayerLabels = {}
AdminMenu = {
    selected = 1,
}

Event("playerInfo", function(player, field, info)
    local id = GetPlayerFromServerId(player)
    if not playerInfo[id] then playerInfo[id] = {} end
    playerInfo[id][field] = info
end)

function GetPlayerInfo(id)
    if not playerInfo[id] then playerInfo[id] = {} end
    return playerInfo[id]
end

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(PlayerPedId())
        players = {}
        PlayerLabels = {}
        for player = 0, 256 do
            if NetworkIsPlayerActive(player) and player ~= PlayerId() then
                if GetPlayerName(player) ~= "**INVALID**" then
                    local dist = #(pos - GetEntityCoords(GetPlayerPed(player)))
                    table.insert(players, {id = player, dist = dist, info = GetPlayerInfo(player)})
                    table.insert(PlayerLabels, GetPlayerName(player))
                end
            end
        end
        AdminMenu.selected = math.min(math.max(AdminMenu.selected, 1), #PlayerLabels)
        Wait(50)
    end
end)

function GetNearbyPlayers()
    local nearby = {}
    for _, player in next, players do
        if player.dist < 350.0 then
            table.insert(nearby, player)
        end
    end
    return nearby
end

function GetPlayerCount()
    -- Start at one, if you see this, you are probably online yourself.
    --  As the other loops avoids adding the player (player ~= PlayerId
    local n = 1
    for _, player in next, players do
        n = n + 1
    end
    return n
end
