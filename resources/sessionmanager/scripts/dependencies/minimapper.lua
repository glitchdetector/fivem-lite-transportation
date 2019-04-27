--[[
    MINIMAP ANCHOR
    BY GLITCHDETECTOR
    GITHUB https://github.com/glitchdetector/fivem-minimap-anchor
]]

--[[
    MINIMAP ANCHOR BY GLITCHDETECTOR (Feb 16 2018 version)
    Modify and redistribute as you please, just keep the original credits in.
    You're free to distribute this in any project where it's used.
]]
function GetMinimapAnchor()
    -- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
    -- 0.05 * ((safezone - 0.9) * 10)
    local isRadarExtended = IsBigmapActive()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local ultra_wide = (aspect_ratio > 2.3)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    if isRadarExtended then
        Minimap.width = xscale * (res_x / (2.52 * aspect_ratio))
        Minimap._height = yscale * (res_y / 2.438)
    else
        Minimap.width = xscale * (res_x / (4 * aspect_ratio))
        Minimap._height = yscale * (res_y / 5.674)
    end
    Minimap.height = yscale * (res_y / 5.674)
    if not ultra_wide then
        Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    else
        if aspect_ratio < 2.4 then
            Minimap.left_x = 0.1250 + (xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10))))
        elseif aspect_ratio < 5.4 then
            Minimap.left_x = 0.1250 + (xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10))))
        else
            Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
        end
    end
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    if GetUserConfig then
        Minimap.left_x = Minimap.left_x + GetUserConfig("minimap_x", 0.0)
        Minimap.bottom_y = Minimap.bottom_y + GetUserConfig("minimap_y", 0.0)

        Minimap.width = Minimap.width + GetUserConfig("minimap_xscale", 0.0)
        Minimap.height = Minimap.height + GetUserConfig("minimap_yscale", 0.0)
    end
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end
