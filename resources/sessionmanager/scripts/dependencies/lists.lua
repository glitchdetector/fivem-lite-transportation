--[[
    MISC LISTS
    BY GLITCHDETECTOR
    MADE FOR TRANSPORT TYCOON
    NO SOURCE, INTERNAL CODE
]]

local TRAILER_LIST = {
    "docktrailer", "trailers", "trailers2", "trailers3",
    "tanker", "trailerlogs", "tr2", "trflat",
    "armytrailer", "armytanker", "tr4", "tvtrailer", "tvtrailer2",
    "freighttrailer", "armytrailer2", "trailerlarge",
    "boxlongtr", "botdumptr",
    "docktrailer2", "dolly", "drybulktr", "dumptr", "fueltr", "gastr",
    "trailerlogs2", "trailerswb", "trailerswb2", "trflat2",
}

local CAB_LIST = {
    "phantom", "phantom2", "phantom3",
    "packer", "hauler", "hauler2",
    "longpath", "roadkiller", "urnext", "heavy_phantom",
    "docktug", "barracks4",
    "cerberusc", "cerberusc2",
}

local VEHICLE_LOOKUP = {}
Citizen.CreateThread(function()
    local function MarkModelListAs(list, type)
        for _, vehicle_name in next, list do
            VEHICLE_LOOKUP[GetHashKey(vehicle_name)] = type
            VEHICLE_LOOKUP[vehicle_name] = type
        end
    end
    MarkModelListAs(TRAILER_LIST, "trailer")
    MarkModelListAs(CAB_LIST, "cab")
end)

function IsModelATrailer(model)
    if type(model) == 'string' then
        model = model:lower()
    end
    return (VEHICLE_LOOKUP[model] == "trailer")
end

function IsModelASemiCab(model)
    if type(model) == 'string' then
        model = model:lower()
    end
    return (VEHICLE_LOOKUP[model] == "cab")
end
