--[[
    MISC HUD STUFF
    NO IDEA WHAT ORIGINAL SOURCES ARE
    FETCHED FROM THE INTERNAL TRANSPORT TYCOON CODE
    PROBABLY MODIFIED
    WHO KNOWS LOL
]]

local function f(n)
    return math.floor(n)
end

function DrawScreenTextRight(x, y, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    if GetUserConfig then
        scale = scale + GetUserConfig("hud_textscale", 0.0) * 20.0
    end
    SetTextScale(scale, scale)
    SetTextColour(f(r), f(g), f(b), f(a))
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandWidth("STRING")
    AddTextComponentString(text)
    local w = EndTextCommandGetWidth(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - w, y)
end

function DrawScreenText(x, y, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    if GetUserConfig then
        scale = scale + GetUserConfig("hud_textscale", 0.0) * 20.0
    end
    SetTextScale(scale, scale)
    SetTextColour(f(r), f(g), f(b), f(a))
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function DrawScreenTextCenter(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    if GetUserConfig then
        scale = scale + GetUserConfig("hud_textscale", 0.0) * 20.0
    end
    SetTextScale(scale, scale)
    SetTextColour(f(r), f(g), f(b), f(a))
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x + width / 2, y + height / 2)
end

function DrawRectCenter(x, y, width, height, r, g, b, a)
    DrawRect(x + width / 2, y + height / 2, width, height, f(r), f(g), f(b), f(a))
end

function drawRct(x, y, width, height, r, g, b, a)
    DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

local function useOrigin()
    return true
end

function DrawText3D(text, x, y, z, s, font, a)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    if s == nil then s = 1.0 end
    if font == nil then font = 4 end
    if a == nil then a = 255 end
    local scale = ((1 / dist) * 2) * s
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        if useOrigin() then SetDrawOrigin(x, y, z, 0) end
        SetTextScale(0.0 * scale, 1.1 * scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, f(a))
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        if useOrigin() then
            DrawText(0.0, 0.0)
            ClearDrawOrigin()
        else
            DrawText(_x, _y)
        end
    end
end
