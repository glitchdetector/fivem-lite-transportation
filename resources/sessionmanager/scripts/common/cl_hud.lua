HUD = {}
HUD["minimap"] = {}
HUD["economy"] = {
    "~g~$#money#",
    "#deliveries# deliveries",
    "#job#",
}
HUD["bottom"] = {
    "#cruise#",
}
HUD["chatter"] = {
    "#time#",
    "Players: #players#/#maxclients#",
    "~g~#nearby#",
}
HUD["traditional"] = {
    "#nocol#",
    "Money: ~g~$#money# ~w~Deliveries: ~y~#deliveries#",
    "#time# ~g~#nearby#",
    "#job#",
    "#cruise#",
}
HUD["on_minimap"] = {
    "#veh_speed#"
}

local DayName = {}
DayName[0] = "Monday"
DayName[1] = "Tuesday"
DayName[2] = "Wednesday"
DayName[3] = "Thursday"
DayName[4] = "Friday"
DayName[5] = "Saturday"
DayName[6] = "Sunday"


local visualMoney = 0

local DataResolver = {
    ["#cruise#"] = function()
        if CruiseControl.enabled then
            return "Cruise Control " .. math.floor(CruiseControl.target * 3.6) .. " km/h"
        end
        return ""
    end,
    ["#money#"] = function() return format_num(visualMoney, 0, "", "-") end,
    ["#deliveries#"] = function() return (GetPlayerSkills()["deliveries"] or 0) end,
    ["#time#"] = function() return ("%s %02d:%02d"):format(DayName[GetClockDayOfWeek()], GetClockHours(), GetClockMinutes()) end,
    ["#nearby#"] = function()
        local nearby = GetNearbyPlayers()
        if #nearby > 0 then
            return ("%d player%s nearby"):format(#nearby, #nearby > 1 and "s" or "")
        end
        return ""
    end,
    ["#job#"] = function()
        if IsOnJob() then
            local job = GetCurrentJob()
            return ("~y~%s ~w~(~g~$%s~w~)"):format(job.name, ReadableNumber(job.totalPay))
        end
        return ""
    end,
    ["#maxclients#"] = function()
        return tostring(GetConvarInt("sv_maxclients", 32))
    end,
    ["#players#"] = function()
        return ("% 2d"):format(GetPlayerCount())
    end,
    ["#nocol#"] = function()
        if NocolState then
            return "~b~Service Zone"
        end
        return ""
    end,
    ["#veh_speed#"] = function()
        if not GetUserConfig("hud_disable_speedometer", false) then
            if IsInVehicle() then
                return GetUnitForVehicleSpeed(GetVehicleSpeed())
            end
        end
        return ""
    end,
}

local function ensureData(data)
    local b = data
    if type(b) == 'string' then
        for look, func in next, DataResolver do
            local s = func()
            b = b:gsub(look, s)
        end
    end
    return b
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        SetHealthArmorType(3) -- Hide Health & Armor from minimap

        if GetUserConfig("hud_disabled", false) then
            Wait(1000)
        else
            visualMoney = lerp(visualMoney, GetPlayerMoney(), 0.1)
            if math.abs(visualMoney - GetPlayerMoney()) < 100 then
                visualMoney = GetPlayerMoney()
            end
            Minimap = GetMinimapAnchor()

            local vert_dist_title = 40 + GetUserConfig("hud_textscale", 0.0) * 500
            local vert_dist = 30 + GetUserConfig("hud_textscale", 0.0) * 500
            local xoff = Minimap.xunit * (25)
            local y_off = 0.0 + (Minimap.yunit * vert_dist_title)


            if not GetUserConfig("hud_disable_healthbar", false) then -- draw fuel
                if IsInVehicle() then
                    local hpw = 1.0
                    local fuelw = 0.25
                    local thpw = 0.5
                    if not GetUserConfig("game_disable_fuel", false) then -- draw fuel
                        hpw = 0.75
                        thpw = 0.25
                        local r, g, b = GetFuelColor()
                        DrawRectCenter(Minimap.left_x + Minimap.width * 0.75, Minimap.bottom_y, Minimap.width * fuelw, Minimap.yunit * -15.0, 0, 0, 0, 200)
                        DrawRectCenter(Minimap.left_x + Minimap.width * 0.75, Minimap.bottom_y - Minimap.yunit * 4, (Minimap.width * fuelw) * ((1 / 100) * (GetFuel())), Minimap.yunit * -7.0, r, g, b, 200)
                    end
                    DrawRectCenter(Minimap.left_x, Minimap.bottom_y, Minimap.width * hpw, Minimap.yunit * -15.0, 0, 50, 0, 200)
                    DrawRectCenter(Minimap.left_x, Minimap.bottom_y - Minimap.yunit * 4, (Minimap.width * hpw) * ((1 / 2000) * GetVehicleHealth()), Minimap.yunit * -7.0, 0, 200, 0, 200)
                end
            end

            if CruiseControl.enabled and CruiseControl.bar then
                DrawRectCenter(Minimap.left_x, Minimap.top_y, Minimap.width * 1.0, Minimap.yunit * -15.0, 50, 50, 50, 200)
                DrawRectCenter(Minimap.left_x, Minimap.top_y - Minimap.yunit * 4, (Minimap.width * 1.0) * ((1 / CruiseControl.target) * GetVehicleSpeed()), Minimap.yunit * -7.0, 200, 200, 200, 200)
            end

            local hud_traditional = GetUserConfig("hud_traditional", false)

            -- Stuff next to minimap
            local mmhud = HUD["minimap"]
            if hud_traditional then
                mmhud = HUD["traditional"]
            end
            for n, data in pairs(mmhud) do
                local data = ensureData(data)
                local _x = Minimap.right_x + xoff
                local _y = Minimap.top_y + y_off + (Minimap.yunit * (vert_dist * (n == 1 and 1.5 or 1.0))) * (n-2)
                if type(data) == 'table' then
                    local len = Minimap.width
                    DrawScreenText(_x, _y, 0.35 * (n == 1 and 1.5 or 1.0), data[1], 255, 255, 255, 255)
                    DrawRect(_x + len/2, _y + y_off/2, len, y_off * 0.6, math.floor(data[4] * 0.25), math.floor(data[5] * 0.25), math.floor(data[6] * 0.25), data[7])
                    len =  len * math.max(0.0,math.min(1.0, (1 / data[3]) * data[2]))
                    DrawRect(_x + len/2, _y + y_off/2, len, y_off * 0.4, data[4], data[5], data[6], data[7])
                else
                    DrawScreenText(_x, _y, 0.45 * (n == 1 and 1.5 or 1.0), data, 255, 255, 255, 255)
                end
            end

            -- Stuff in top right
            local echud = HUD["economy"]
            if hud_traditional then
                echud = {}
            end
            for n, data in pairs(echud) do
                local data = ensureData(data)
                local _x = (1.0 - Minimap.left_x)
                local _y = math.max(0.05, 1.0 - Minimap.bottom_y) + y_off + (Minimap.yunit * (vert_dist * (n == 1 and 1.5 or 1.0))) * (n-2)
                if type(data) == 'table' then
                    local len = -Minimap.width
                    DrawScreenTextRight(_x, _y, 0.35 * (n == 1 and 1.5 or 1.0), data[1], 255, 255, 255, 255)
                    DrawRect(_x + len/2, _y + y_off/2, -len, y_off * 0.6, math.floor(data[4] * 0.25), math.floor(data[5] * 0.25), math.floor(data[6] * 0.25), data[7])
                    len =  len * math.max(0.0,math.min(1.0, (1 / data[3]) * data[2]))
                    DrawRect(_x + len/2, _y + y_off/2, -len, y_off * 0.4, data[4], data[5], data[6], data[7])
                else
                    DrawScreenTextRight(_x, _y, 0.45 * (n == 1 and 1.5 or 1.0), data, 255, 255, 255, 255)
                end
            end

            -- Stuff in top left
            local chhud = HUD["chatter"]
            if hud_traditional then
                chhud = {}
            end
            for n, data in pairs(chhud) do
                local data = ensureData(data)
                local _x = Minimap.left_x
                local _y = math.max(0.05, 1.0 - Minimap.bottom_y) + y_off + (Minimap.yunit * (vert_dist * (n == 1 and 1.5 or 1.0))) * (n-2)
                if type(data) == 'table' then
                    local len = Minimap.width
                    DrawScreenText(_x, _y, 0.35 * (n == 1 and 1.5 or 1.0), data[1], 255, 255, 255, 255)
                    DrawRect(_x + len/2, _y + y_off/2, len, y_off * 0.6, math.floor(data[4] * 0.25), math.floor(data[5] * 0.25), math.floor(data[6] * 0.25), data[7])
                    len =  len * math.max(0.0,math.min(1.0, (1 / data[3]) * data[2]))
                    DrawRect(_x + len/2, _y + y_off/2, len, y_off * 0.4, data[4], data[5], data[6], data[7])
                else
                    DrawScreenText(_x, _y, 0.45 * (n == 1 and 1.5 or 1.0), data, 255, 255, 255, 255)
                end
            end

            -- Stuff in bottom right
            local bthud = HUD["bottom"]
            if hud_traditional then
                bthud = {}
            end
            for n, data in pairs(bthud) do
                local data = ensureData(data)
                local _x = (1.0 - Minimap.left_x)
                local _y = Minimap.top_y + y_off + (Minimap.yunit * (vert_dist * (n == 1 and 1.5 or 1.0))) * (n-2)
                if type(data) == 'table' then
                    local len = -Minimap.width
                    DrawScreenTextRight(_x, _y, 0.35 * (n == 1 and 1.5 or 1.0), data[1], 255, 255, 255, 255)
                    DrawRect(_x + len/2, _y + y_off/2, len, y_off * 0.6, math.floor(data[4] * 0.25), math.floor(data[5] * 0.25), math.floor(data[6] * 0.25), data[7])
                    len = len * math.max(0.0,math.min(1.0, (1 / data[3]) * data[2]))
                    DrawRect(_x + len/2, _y + y_off/2, len, y_off * 0.4, data[4], data[5], data[6], data[7])
                else
                    DrawScreenTextRight(_x, _y, 0.45 * (n == 1 and 1.5 or 1.0), data, 255, 255, 255, 255)
                end
            end

            -- Stuff on the minimap
            local omhud = HUD["on_minimap"]
            if hud_traditional then
                omhud = {}
            end
            for n, data in pairs(HUD["on_minimap"]) do
                local data = ensureData(data)
                local _x = Minimap.left_x
                local _y = Minimap.top_y + y_off + (Minimap.yunit * (vert_dist * (n == 1 and 1.5 or 1.0))) * (n-2)
                if type(data) == 'table' then
                    local len = Minimap.width
                    DrawScreenText(_x, _y, 0.33 * (n == 1 and 1.5 or 1.0), data[1], 255, 255, 255, 255)
                    DrawRect(_x + len/2, _y + y_off/2, len, y_off * 0.6, math.floor(data[4] * 0.25), math.floor(data[5] * 0.25), math.floor(data[6] * 0.25), data[7])
                    len =  len * math.max(0.0,math.min(1.0, (1 / data[3]) * data[2]))
                    DrawRect(_x + len/2, _y + y_off/2, len, y_off * 0.4, data[4], data[5], data[6], data[7])
                else
                    DrawScreenTextCenter(_x, _y, Minimap.width, Minimap.yunit * 16.0, 0.33 * (n == 1 and 1.5 or 1.0), data, 255, 255, 255, 255)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for _, player in next, players do
            if player.dist < 45.0 then
                local pos = GetEntityCoords(GetPlayerPed(player.id))
                local off = 2.75
                if player.info.admin then
                    DrawText3D("~r~Administrator", pos.x, pos.y, pos.z + off, 2.0)
                    off = off + 0.35
                end
                if player.info.title then
                    DrawText3D(player.info.title, pos.x, pos.y, pos.z + off, 2.0)
                end
                DrawText3D(GetPlayerName(player.id), pos.x, pos.y, pos.z + 2.25, 2.6)
            end
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    local n = 1
    local fake_interiors = {
        {"V_FakeMilitaryBase", -2250.0, 3100.0},
    }
    while true do
        Wait(2)
        SetRadarAsInteriorThisFrame(fake_interiors[1][1], fake_interiors[1][2], fake_interiors[1][3], 0.0, 0)
        SetRadarAsExteriorThisFrame()
    end
end)
