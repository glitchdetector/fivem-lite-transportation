local MENU = {}

function SetMenu(menu)
    MENU = menu
end

WarMenu.CreateMenu("dealership", "Vehicle Dealership")
WarMenu.SetSubTitle("dealership", "Choose a category and vehicle to buy")

WarMenu.CreateMenu("modshop", "Vehicle Spray Shop")
WarMenu.SetSubTitle("modshop", "Apply changs to your vehicle")

WarMenu.CreateMenu("admin", "Administrational Menu")
WarMenu.SetSubTitle("admin", "Choose a player and an action")

WarMenu.CreateMenu("noclip", "Noclip Menu")
WarMenu.SetSubTitle("noclip", "Move freely")

WarMenu.CreateMenu("f7", "Tips Menu")
WarMenu.SetSubTitle("f7", "View some tips")

WarMenu.CreateMenu("airport", "Quick Travel - Airport")
WarMenu.SetSubTitle("airport", "Select an Airport")

WarMenu.CreateMenu("seaport", "Quick Travel - Seaport")
WarMenu.SetSubTitle("seaport", "Select a Seaport")

WarMenu.CreateMenu("settings", "Game Settings")
WarMenu.SetSubTitle("settings", "Tweak how the game looks and functions")

Citizen.CreateThread(function()
    local wasQuickTravelOpen = false
    while true do
        local isQuickTravelOpen = false
        if WarMenu.IsMenuOpened("dealership") then
            local label = {"Van", "Truck", "Semi-Cab", "Trailer"}
            local order = {"van", "truck", "cab", "trailer"}
            WarMenu.ComboBox("Category", label, VehicleShop.selected, VehicleShop.selected, function(c,_)
                VehicleShop.selected = c
            end)
            local shopData = VehicleShop[order[VehicleShop.selected]]
            WarMenu.ComboBox("Vehicle", shopData.labels, shopData.selected, shopData.selected, function(c,_)
                shopData.selected = c
            end)
            local vehicle = shopData.vehicles[shopData.selected]
            local price = vehicle.price
            local ownsVehicle = PlayerHasBoughtVehicle(vehicle.model)

            if ownsVehicle then
                price = "Already owned"
            elseif price > 0 then
                price =  "~g~$" .. ReadableNumber(vehicle.price,2)
            elseif price <= 0 then
                price = "Free"
            end

            WarMenu.ComboBox("Price", { price }, 1, 1, function() end)

            local confirmLabelText = "~g~Purchase"

            if ownsVehicle then
                confirmLabelText = "~y~Spawn"
            end

            if not IsModelASemiCab(GetPlayerTruck()) and order[VehicleShop.selected] == "trailer" then
                WarMenu.ComboBox(confirmLabelText, {"~r~Requires Semi-Cab"}, 1, 1, function() end)
            elseif GetPlayerTruck() == vehicle.model or GetPlayerTrailer() == vehicle.model then
                WarMenu.ComboBox(confirmLabelText, {"~r~Current Vehicle"}, 1, 1, function() end)
            else
                if WarMenu.Button(confirmLabelText) then
                    WarMenu.CloseMenu()
                    SendEvent("dealership:purchase", vehicle)
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened("airport") then
            if not isQuickTravelOpen then
                isQuickTravelOpen = true
            end
            WarMenu.ComboBox("Airport", AirportMenu.labels, AirportMenu.selected, AirportMenu.selected, function(c,_)
                local blip = AirportMenu.selections[AirportMenu.selected].poi.blip
                SetBlipColour(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipPriority(blip, 2)
                AirportMenu.selected = c
            end)
            local selection = AirportMenu.selected
            local poi = AirportMenu.selections[selection].poi
            local price = AirportMenu.selections[AirportMenu.current].price[selection]
            local dist = AirportMenu.selections[AirportMenu.current].dist[selection]
            if AirportMenu.current == selection then
                WarMenu.ComboBox("Price", {"~r~Current location"}, 1, 1, function() end)
            else
                if IsOnJob() then
                    WarMenu.ComboBox("Price", {"~g~$" .. ReadableNumber(price,2)}, 1, 1, function() end)
                else
                    price = 0
                    WarMenu.ComboBox("Price", {"Free while not on job"}, 1, 1, function() end)
                end
            end
            SetBlipColour(poi.blip, 1)
            SetBlipScale(poi.blip, 1.5)
            SetBlipPriority(poi.blip, 1000)
            if WarMenu.Button("~g~Confirm") then
                if AirportMenu.current ~= selection then
                    SendEvent("quickwarp", poi.pos, price, poi.name)
                    WarMenu.CloseMenu()
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened("seaport") then
            if not isQuickTravelOpen then
                isQuickTravelOpen = true
            end
            WarMenu.ComboBox("Seaport", SeaportMenu.labels, SeaportMenu.selected, SeaportMenu.selected, function(c,_)
                local blip = SeaportMenu.selections[SeaportMenu.selected].poi.blip
                SetBlipColour(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipPriority(blip, 2)
                SeaportMenu.selected = c
            end)
            local selection = SeaportMenu.selected
            local poi = SeaportMenu.selections[selection].poi
            local price = SeaportMenu.selections[SeaportMenu.current].price[selection]
            local dist = SeaportMenu.selections[SeaportMenu.current].dist[selection]
            if SeaportMenu.current == selection then
                WarMenu.ComboBox("Price", {"~r~Current location"}, 1, 1, function() end)
            else
                if IsOnJob() then
                    WarMenu.ComboBox("Price", {"~g~$" .. ReadableNumber(price,2)}, 1, 1, function() end)
                else
                    price = 0
                    WarMenu.ComboBox("Price", {"Free while not on job"}, 1, 1, function() end)
                end
            end
            SetBlipColour(poi.blip, 1)
            SetBlipScale(poi.blip, 1.5)
            SetBlipPriority(poi.blip, 1000)
            if WarMenu.Button("~g~Confirm") then
                if SeaportMenu.current ~= selection then
                    SendEvent("quickwarp", poi.pos, price, poi.name)
                    WarMenu.CloseMenu()
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened("modshop") then
            local prim = GetColorMenuId(GetPlayerPrimary())
            local sec = GetColorMenuId(GetPlayerSecondary())
            WarMenu.ComboBox("Primary Color", VehicleColors.labels, prim, prim, function(c,_)
                if c ~= prim then
                    local col = GetColorFromMenuId(c)
                    TriggerEvent("lite:client:data:SetPrimary", col)
                    SetVehicleColours(GetVehicle(), col, GetPlayerSecondary())
                end
            end)
            WarMenu.ComboBox("Secondary Color", VehicleColors.labels, sec, sec, function(c,_)
                if c ~= sec then
                    local col = GetColorFromMenuId(c)
                    TriggerEvent("lite:client:data:SetSecondary", col)
                    SetVehicleColours(GetVehicle(), GetPlayerPrimary(), col)
                end
            end)
            if WarMenu.Button("~g~Confirm") then
                SendEvent("modshop:colors", GetPlayerPrimary(), GetPlayerSecondary())
                WarMenu.CloseMenu()
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened("f7") then
            local tips = Tips.TipTexts[Tips.selected]
            WarMenu.ComboBox("Tips", Tips.TipLabels, Tips.selected, Tips.selected, function(c,_)
                Tips.selected = c
            end)
            for n, tip in next, tips do
                if type(tip) == 'table' then
                    if WarMenu.ComboBox("#"..n, {tip[1]}, 1, 1, function() end) then
                        TriggerEvent(tip[2])
                    end
                else
                    WarMenu.ComboBox("#"..n, {tip}, 1, 1, function() end)
                end
            end
            if WarMenu.Button("~r~Close") then
                WarMenu.CloseMenu()
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened("settings") then

            for _, config in next, UserConfigMenu do
                if config.typ == "boolean" then
                    local bool = GetUserConfig(config.config, false)
                    if WarMenu.CheckBox(config.title, bool) then
                        SetUserConfig(config.config, not bool)
                    end
                elseif config.typ == "number" then
                    local num = GetUserConfig(config.config, 0.0)
                    WarMenu.ComboBox(config.title, {"", math.floor(num * 200) / 10 .. "", ""}, 2, 2, function(c,_)
                        local change = c - 2
                        if change ~= 0 then
                            SetUserConfig(config.config, num + (change * config.step))
                        end
                    end)
                end
            end
            if WarMenu.Button("~r~Close") then
                WarMenu.CloseMenu()
            end
            WarMenu.Display()

            -- Draw a visual representation of the minimapper
            local ui = GetMinimapAnchor()
            local thickness = 4 -- Defines how many pixels wide the border is
            drawRct(ui.x, ui.y, ui.width, thickness * ui.yunit, 0, 0, 0, 255)
            drawRct(ui.x, ui.y + ui.height, ui.width, -thickness * ui.yunit, 0, 0, 0, 255)
            drawRct(ui.x, ui.y, thickness * ui.xunit, ui.height, 0, 0, 0, 255)
            drawRct(ui.x + ui.width, ui.y, -thickness * ui.xunit, ui.height, 0, 0, 0, 255)

        elseif WarMenu.IsMenuOpened("noclip") then

        elseif WarMenu.IsMenuOpened("admin") then
            local player = players[AdminMenu.selected]
            if player then
                WarMenu.ComboBox("Player", PlayerLabels, AdminMenu.selected, AdminMenu.selected, function(c,_)
                    AdminMenu.selected = c
                end)
                if WarMenu.Button("Teleport to") then
                    TriggerServerEvent("lite:admin:request", "lite:admin:goto", player.id)
                end
                if WarMenu.Button("Kick") then
                    TriggerServerEvent("lite:admin:kick", GetPlayerServerId(player.id))
                end
                if WarMenu.Button("Ban") then
                    TriggerServerEvent("lite:admin:ban", GetPlayerServerId(player.id))
                end
            else
                WarMenu.ComboBox("Player", {"No Players Online"}, 1, 1, function() end)
            end
            if WarMenu.Button("~r~Close") then
                WarMenu.CloseMenu()
            end
            WarMenu.Display()
        else
            if IsBigmapActive() then
                SetRadarBigmapEnabled(false, false)
            end
            if IsControlJustPressed(0, 168) then
                WarMenu.OpenMenu("f7")
            elseif IsControlJustPressed(0, 167) then
                WarMenu.OpenMenu("settings")
            end
        end
        if isQuickTravelOpen and not wasQuickTravelOpen then
            -- Opened
            HideAllJobs()
            HideAllPOIs()
            SetRadarBigmapEnabled(true, true)
        elseif not isQuickTravelOpen and wasQuickTravelOpen then
            -- Closed
            -- Reset blip changes made by quick-teleport
            local function resetPOIblips(poiList)
                for _, item in next, poiList do
                    local poi = item.poi
                    if poi then
                        local blip = poi.blip
                        if blip then
                            SetBlipColour(blip, 4)
                            SetBlipScale(blip, 1.0)
                            SetBlipPriority(blip, 2)
                        end
                    end
                end
            end
            resetPOIblips(AirportMenu.selections)
            resetPOIblips(SeaportMenu.selections)
            ShowAllJobs()
            ShowAllPOIs()
            SetRadarBigmapEnabled(false, false)
        end
        wasQuickTravelOpen = isQuickTravelOpen
        Wait(0)
    end
end)
