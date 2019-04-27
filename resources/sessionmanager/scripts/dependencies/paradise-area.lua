--[[
    PARADISE AREA
    BY DEMMYDEMON
    GITHUB https://github.com/DemmyDemon/paradise-area
]]

local defaults = {
    height = 2.0,
    color = {255,255,255,60},
    fade = 100,
    threshold = 3.25,
    wallFade = 0,
}

local DEBUGVALUE = nil

local function sanityCheck(area)
    --TODO actually sanity check
    return true
end

local function _dotProduct(A,B,C)
    local BAx = A.x - B.x
    local BAy = A.y - B.y
    local BCx = C.x - B.x
    local BCy = C.y - B.y
    return (BAx * BCx + BAy * BCy)
end
local function _crossProduct(A,B,C)
    local BAx = A.x - B.x
    local BAy = A.y - B.y
    local BCx = C.x - B.x
    local BCy = C.y - B.y
    return (BAx * BCy - BAy * BCx)
end
local function _lineDistanceSquared(A,B,C)
    local Dx = B.x - A.x
    local Dy = B.y - A.y
    local t = ((C.x - A.x) * Dx + (C.y - A.y) * Dy) / (Dx * Dx + Dy * Dy)

    if t < 0 then
        Dx = C.x - A.x
        Dy = C.y - A.y
    elseif t > 1 then
        Dx = C.x - B.x
        Dy = C.y - B.y
    else
        local closestX = A.x + t * Dx
        local closestY = A.y + t * Dy
        Dx = C.x - closestX
        Dy = C.y - closestY
    end
    return Dx*Dx + Dy*Dy
end

local function _wall(p1,p1a,p2,p2a,R,G,B,A,compare)
    if A > 0 then
        if not compare then
            DrawPoly(p1,p1a,p2,R,G,B,A)
            DrawPoly(p1a,p2a,p2,R,G,B,A)
            DrawPoly(p2,p2a,p1a,R,G,B,A)
            DrawPoly(p2,p1a,p1,R,G,B,A)
        else
            local outerProduct = (compare.x-p1.x)*(p2.y-p1.y) - (compare.y-p1.y)*(p2.x-p1.x)
            if outerProduct <= 0 then
                DrawPoly(p1,p1a,p2,R,G,B,A)
                DrawPoly(p1a,p2a,p2,R,G,B,A)
            else
                DrawPoly(p2,p2a,p1a,R,G,B,A)
                DrawPoly(p2,p1a,p1,R,G,B,A)
            end
        end
    end
end

local function _drawLabel(where,what,r,g,b,a)
    --SetDrawOrigin(where,0) -- Acts funny if set more than 32 times (?) in a frame
    local offScreen,x,y = GetScreenCoordFromWorldCoord(where.x,where.y,where.z)
    if not offScreen then
        SetTextColour(r,g,b,a)
        SetTextScale(0.5,0.5)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(what)
        DrawText(x,y)
    end
end

local function _draw(area,comparePoint)
    if not comparePoint and area.fade ~= 0 then
        if IsGameplayCamRendering() or IsCinematicCamRendering() then
            comparePoint = GetGameplayCamCoord()
        else
            comparePoint = GetCamCoord(GetRenderingCam())
        end
    end


    if #area.points > 2 then
        local alphaFraction = 1.0
        local bR,bG,bB,bA = table.unpack(area.border)
        local wR,wG,wB,wA = table.unpack(area.color)
        local wallAlpha = wA
        local borderAlpha = bA

        if area.fade > 0 and area.wallFade <= 0 then
            local distance = #(area.center - comparePoint)
            alphaFraction = 1.0 - ((1 / area.fade) * distance)
            borderAlpha = math.ceil(bA * alphaFraction)
            borderAlpha = math.max(borderAlpha,0)
            borderAlpha = math.min(borderAlpha,255)

            wallAlpha = math.ceil(wA * alphaFraction)
            wallAlpha = math.max(wallAlpha,0)
            wallAlpha = math.min(wallAlpha,255)
        end

        if wallAlpha > 0 or borderAlpha > 0 or area.wallFade > 0 then
            if area.label then
                local labelAlpha = bA
                if area.fade > 0 then
                    local distance = #(area.center - comparePoint)
                    local alphaFraction = 1.0 - ((1 / area.fade) * distance)
                    labelAlpha = math.ceil(bA * alphaFraction)
                    labelAlpha = math.max(labelAlpha,0)
                    labelAlpha = math.min(labelAlpha,255)
                end
                _drawLabel(area.center,area.label,bR,bG,bB,labelAlpha)
            end
            local lastPoint = nil
            local lastAbove = nil
            local firstPoint = nil
            local firstAbove = nil
            for i,point in ipairs(area.points) do
                local above = point + area.aboveOffset
                if lastPoint then
                    if area.wallFade > 0 then
                        lineDistance = _lineDistanceSquared(point,lastPoint,comparePoint)
                        wallAlpha = (wA/area.wallFade) * (area.wallFade - lineDistance)
                        wallAlpha = math.ceil(wallAlpha)
                        wallAlpha = math.max(0,wallAlpha)
                        wallAlpha = math.min(255,wallAlpha)
                        borderAlpha = (bA/area.wallFade) * (area.wallFade - lineDistance)
                        borderAlpha = math.ceil(borderAlpha)
                        borderAlpha = math.max(0,borderAlpha)
                        borderAlpha = math.min(255,borderAlpha)
                    end
                    if wallAlpha > 0 then
                        _wall(point,above,lastPoint,lastAbove,wR,wG,wB,wallAlpha,comparePoint)
                    end
                    if borderAlpha > 0 then
                        DrawLine(lastPoint,point,bR,bG,bB,borderAlpha)
                        DrawLine(lastAbove,above,bR,bG,bB,borderAlpha)
                        DrawLine(point,above,bR,bG,bB,borderAlpha)
                    end
                else
                    firstAbove = above
                    firstPoint = point
                end
                lastAbove = above
                lastPoint = point
                if area.numbered then
                    local middle = point + (area.aboveOffset / 2)
                    local labelAlpha = bA
                    if area.fade > 0 and area.wallFade <= 0 then
                        local distance = #(area.center - comparePoint)
                        local alphaFraction = 1.0 - ((1 / area.fade) * distance)
                        labelAlpha = math.ceil(bA * alphaFraction)
                    elseif area.wallFade > 0 then
                        local distance = #(comparePoint - middle)
                        distance = distance * distance -- because area.wallFade is squared, remember?
                        local alphaFraction = 1.0 - ((1 / area.wallFade) * distance)
                        labelAlpha = math.ceil(bA * alphaFraction)
                    end
                    labelAlpha = math.max(labelAlpha,0)
                    labelAlpha = math.min(labelAlpha,255)
                    if labelAlpha > 0 then
                        _drawLabel(middle,i,bR,bG,bB,labelAlpha)
                    end
                end
            end
            if area.wallFade > 0 then
                lineDistance = _lineDistanceSquared(lastPoint,firstPoint,comparePoint)
                wallAlpha = (wA/area.wallFade) * (area.wallFade - lineDistance)
                wallAlpha = math.ceil(wallAlpha)
                wallAlpha = math.max(0,wallAlpha)
                wallAlpha = math.min(255,wallAlpha)
                borderAlpha = (bA/area.wallFade) * (area.wallFade - lineDistance)
                borderAlpha = math.ceil(borderAlpha)
                borderAlpha = math.max(0,borderAlpha)
                borderAlpha = math.min(255,borderAlpha)
            end
            if borderAlpha > 0 then
                DrawLine(lastPoint,firstPoint,bR,bG,bB,borderAlpha)
                DrawLine(lastAbove,firstAbove,bR,bG,bB,borderAlpha)
                DrawLine(point,above,bR,bG,bB,borderAlpha)
                DrawLine(firstPoint,firstAbove,bR,bG,bB,borderAlpha)
            end
            if wallAlpha > 0 then
                _wall(lastPoint,lastAbove,firstPoint,firstAbove,wR,wG,wB,wallAlpha,comparePoint)
            end
            return true
        end
    end
    return false
end

local function _recalc(area)
    local totalX = 0.0
    local totalY = 0.0
    local totalZ = 0.0
    for i,p in ipairs(area.points) do
        totalX = totalX + p.x
        totalY = totalY + p.y
        totalZ = totalZ + p.z
        if p.z + area.height > area.maxZ then
            area.maxZ = p.z + area.height
        end
        if p.z < area.minZ then
            area.minZ = p.z
        end
    end

    area.center = vector3(totalX/#area.points,totalY/#area.points,(totalZ/#area.points)+(area.height/2))

    -- Yes, I realize this iterates the points list *twice*
    -- If you have suggestions on ways to avoid this, please make a pull request.
    for i,point in ipairs(area.points) do
        local pointDistance = #( area.center - point)
        if pointDistance > area.radius then
            area.radius = pointDistance
        end
    end
end

local function _add(area,point)
    if type(point) == 'vector3' then
        table.insert(area.points,point)
    end
end


local function _angle(A,B,C)
    local dotProduct = _dotProduct(A,B,C)
    local crossProduct = _crossProduct(A,B,C)
    return math.atan(crossProduct,dotProduct)
end

local function _isInside(area,candidate)

    if #area.points <= 2 then
        return false
    end

    if not candidate then
        candidate = GetEntityCoords(PlayerPedId())
    end

    if type(candidate) == 'vector3' then
        local centerDistance = #( candidate - area.center )
        if centerDistance <= area.radius then
            if candidate.z <= area.maxZ and candidate.z >= area.minZ then
                local first = area.points[1]
                local last = area.points[#area.points]
                local total = _angle(last,candidate,first)
                for i,point in ipairs(area.points) do
                    if i < #area.points then
                        total = total + _angle(point,candidate,area.points[i+1])
                    else
                        total = total + _angle(point,candidate,first)
                    end
                end
                total = math.abs(total)
                return total > area.threshold
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function pArea(spec)
    spec = spec or {}
    local area = {
        height = (spec.height or defaults.height) * 1.0,
        color = spec.color or defaults.color,
        border = spec.border or spec.color or defaults.color,
        fade = (spec.fade or defaults.fade) * 1.0,
        wallFade = (spec.wallFade or defaults.wallFade) * 1.0,
        threshold = spec.threshold or defaults.threshold,
        numbered = spec.numbered or defaults.numbered,
        label = spec.label, -- No default.
        points = {},
        maxZ = -math.huge,
        minZ = math.huge,
        radius = 0.0,
        center = vector3(0,0,0),
    }
    area.wallFade = area.wallFade * area.wallFade -- So we don't have to do a square root on the distance!
    area.aboveOffset = vector3(0.0,0.0,area.height)
    if sanityCheck(area) then
        function area.draw(comparePoint)
            return _draw(area,comparePoint)
        end
        function area.addPoint(point)
            _add(area,point)
            _recalc(area)
        end
        function area.addBulk(...)
            for i,point in ipairs({...}) do
                _add(area,point)
            end
            _recalc(area)
        end
        function area.isInside(candidate)
            return _isInside(area,candidate)
        end
    end
    return area
end

exports('create',pArea)

if false then -- Change to true for "demo mode"
    Citizen.CreateThread(function()

        local demoTextBeginY = 0.1
        local demoTextY = 0.3
        local demoTextX = 0.5
        local demoTextSpacing = 0.01

        local function demoText(text)
            SetTextEntry('STRING')
            SetTextCentre(true)
            SetTextOutline()
            SetTextScale(0.2,0.2)
            AddTextComponentString(text)
            DrawText(demoTextX,demoTextY)
            demoTextY = demoTextY + demoTextSpacing
        end

        local prison = pArea({
            fade = 400, -- The alpha value goes from the specified value to zero, where zero is reached when you are this many meters from the center point
            height = 20, -- Height of the area
            color = {255,10,10,128},
            border = {255,0,0,255},
            wallFade = 20, -- Overrides "fade" (except for the label) to draw the walls when within this number of meters from it. As the name implies, it fades in and out.
            numbered = true, -- Makes little numbers appear on the "fenceposts" to show which point that "fencepost" represents. Respects fade and wallFade
            label = 'Bolingbroke Penetentiary', -- Text shown at the center of the area. Respects fade.
        })
        prison.addBulk( -- You usually want to add points in bulk!
            -- These points define the inner fence of Bolingbroke Penitentiary
            vector3(1809.6550,2611.9644,44.0), -- These points all have the same Z, but they don't need to.
            vector3(1809.8136,2620.5571,44.0), -- Just keep in mind that the floor will always be the lowest Z
            vector3(1834.8809,2688.9844,44.0), -- and the ceiling will always be the highest Z+height.
            vector3(1829.8210,2703.4316,44.0),
            vector3(1776.4961,2746.9063,44.0), -- This is a counter-clockwise walk around the inner perimeter
            vector3(1762.2723,2752.1399,44.0), -- fence of Bolingbroke. Clockwise or counterclockwise makes no
            vector3(1662.0980,2748.4910,44.0), -- difference.
            vector3(1648.5455,2741.4304,44.0),
            vector3(1584.9486,2679.5676,44.0),
            vector3(1575.8102,2666.8384,44.0),
            vector3(1548.0370,2591.4705,44.0),
            vector3(1547.4382,2576.1729,44.0),
            vector3(1551.0304,2483.0166,44.0),
            vector3(1558.5922,2469.4287,44.0),
            vector3(1652.8062,2410.0327,44.0),
            vector3(1668.0634,2407.9949,44.0),
            vector3(1748.8489,2420.0686,44.0),
            vector3(1762.5363,2426.9331,44.0),
            vector3(1808.6689,2474.4841,44.0),
            vector3(1813.4258,2489.0496,44.0),
            vector3(1806.2424,2535.8501,44.0),
            vector3(1808.3218,2570.0037,44.0),
            vector3(1808.4086,2591.5320,44.0),
            vector3(1819.0066,2591.5283,44.0),
            vector3(1818.5493,2612.0737,44.0) -- Note:  No trailing comma here!
        )
        local parking = pArea() -- Meh, defaults are fine
        local points = {
            vector3(1866.7888,2616.8391,44.672),
            vector3(1873.2416,2616.8735,44.672),
            vector3(1873.2631,2613.3623,44.672),
            vector3(1866.8092,2613.3381,44.672),
        }
        for i,point in ipairs(points) do
            parking.addPoint(point) -- You can add points one by one if you want. It's slower.
        end

        local concave = pArea({
            color = {255,0,255,60},
        })
        concave.addBulk(
            vector3(1866.8142,2620.3181,44.6720),
            vector3(1879.6829,2620.4055,44.6720),
            vector3(1879.6213,2627.4163,44.6720),
            vector3(1874.1449,2627.3674,44.6720),
            vector3(1874.5432,2623.8694,44.6720),
            vector3(1871.7843,2623.8779,44.6720),
            vector3(1872.1609,2627.3757,44.6720),
            vector3(1866.7350,2627.3411,44.6720)
        )

        local oddShape = pArea({
            color = {255,255,0,60},
        })
        oddShape.addBulk(
            vector3(1866.7300,2630.8433,44.6720),
            vector3(1879.6132,2630.9250,44.6720),
            vector3(1866.6542,2641.3596,44.6720),
            vector3(1879.5546,2641.4207,44.6720)
        )

        local nonflat = pArea({
            color = {72,72,200,128},
            border = {255,255,255,128},
            height = 3.4,
        })
        nonflat.addBulk(
            vector3(1889.1487,2527.7349,44.7944),
            vector3(1889.0958,2523.4109,44.7735),
            vector3(1880.5088,2523.4016,44.7077),
            vector3(1881.7913,2511.3113,45.6596),
            vector3(1887.5636,2507.4001,48.0793),
            vector3(1894.6342,2509.0535,49.4092),
            vector3(1899.2479,2514.4243,49.1625),
            vector3(1901.3768,2520.9243,48.3769),
            vector3(1900.8844,2527.4045,47.0035),
            vector3(1896.6481,2534.1299,44.8804)
        )

        while true do
            demoTextY = demoTextBeginY
            prison.draw() -- The draw call is relatively heavy, and should only ever be used for debugging purposes!
            if prison.isInside() then
                demoText('Inside prison')
            else
                demoText('Outside prison')
            end

            parking.draw()
            if parking.isInside() then
                demoText('Inside the rectangle test')
            else
                demoText('Outside the rectangle test')
            end

            concave.draw()
            if concave.isInside() then
                demoText('Inside the concave test')
            else
                demoText('Outside the concave test')
            end

            oddShape.draw()
            if oddShape.isInside() then
                demoText('Inside the odd shape test')
            else
                demoText('Outside the odd shape test')
            end

            nonflat.draw()
            if nonflat.isInside() then
                demoText('Inside non-flat test')
            else
                demoText('Outside non-flat test')
            end

            Citizen.Wait(0)
        end
    end)
end
