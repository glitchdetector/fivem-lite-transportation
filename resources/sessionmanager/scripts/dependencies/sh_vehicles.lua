--[[
    VEHICLE DEFINITIONS
    BY GLITCHDETECTOR
    CUSTOM
]]

local VEHICLES = {
    {
        model = "BISON3",
        name = "Bison",
        category = "van",
        price = 0,
        bonus = 0.0,
        discord = "BISON3",
    },
    {
        model = "BURRITO",
        name = "Burrito",
        category = "van",
        price = 25000,
        bonus = 0.15,
        discord = "BURRITO",
    },
    {
        model = "PONY",
        name = "Pony",
        category = "van",
        price = 45000,
        bonus = 0.30,
        discord = "PONY",
    },
    {
        model = "MULE",
        name = "Mule",
        category = "van",
        price = 65000,
        bonus = 0.5,
        discord = "MULE",
    },
    {
        model = "BENSON",
        name = "Benson",
        category = "truck",
        price = 120000,
        bonus = 1.0,
        discord = "BENSON",
    },
    {
        model = "POUNDER",
        name = "Pounder",
        category = "truck",
        price = 198000,
        bonus = 2.2,
        discord = "POUNDER",
    },
    {
        model = "DOCKTRAILER",
        name = "Trailer MK1",
        category = "trailer",
        price = 0,
        bonus = 2.5,
        discord = "DOCKTRAILER",
    },
    {
        model = "TRAILERS",
        name = "Trailer MK2",
        category = "trailer",
        price = 450000,
        bonus = 5.5,
        discord = "TRAILERS",
    },
    {
        model = "TRAILERS2",
        name = "Trailer MK3",
        category = "trailer",
        price = 850000,
        bonus = 12.25,
        discord = "TRAILERS2",
    },
    {
        model = "TRAILERS3",
        name = "Trailer MK4",
        category = "trailer",
        price = 1250000,
        bonus = 16.25,
        discord = "TRAILERS3",
    },
    {
        model = "TVTRAILER",
        name = "Trailer MK5",
        category = "trailer",
        price = 2400000,
        bonus = 20.25,
        discord = "TVTRAILER",
    },
    {
        model = "DOCKTUG",
        name = "Dock Tug",
        category = "cab",
        price = 350000,
        bonus = 1.5,
        discord = "DOCKTUG",
    },
    {
        model = "HAULER",
        name = "Hauler",
        category = "cab",
        price = 600000,
        bonus = 3.5,
        discord = "HAULER",
    },
    {
        model = "PHANTOM",
        name = "Phantom",
        category = "cab",
        price = 1250000,
        bonus = 6.5,
        discord = "PHANTOM",
    },
    {
        model = "HAULER2",
        name = "Hauler Custom",
        category = "cab",
        price = 1800000,
        bonus = 11.5,
        discord = "HAULER2",
    },
    {
        model = "PHANTOM3",
        name = "Phantom Custom",
        category = "cab",
        price = 2250000,
        bonus = 14.5,
        discord = "PHANTOM3",
    }
}

local VehicleCategories = {
    ["cab"] = "Semi-Cab",
    ["van"] = "Van",
    ["truck"] = "Truck",
    ["trailer"] = "Trailer",
}

VehicleShop = {
    selected = 1,
}

for _, vehicle in next, VEHICLES do
    if not VehicleShop[vehicle.category] then
        VehicleShop[vehicle.category] = {
            name = VehicleCategories[vehicle.category],
            vehicles = {},
            labels = {},
            selected = 1,
            totals = 0,
        }
    end
    VehicleShop[vehicle.category].totals = VehicleShop[vehicle.category].totals + 1
end

for _, vehicle in next, VEHICLES do
    table.insert(VehicleShop[vehicle.category].labels, ("%s (%s/%s)"):format(vehicle.name, #VehicleShop[vehicle.category].labels + 1, VehicleShop[vehicle.category].totals))
    table.insert(VehicleShop[vehicle.category].vehicles, vehicle)
end

local VEHICLE_BONUSES = {}
for _, vehicle in next, VEHICLES do
    VEHICLE_BONUSES[vehicle.model] = vehicle.bonus
end

function GetVehicleByModel(model)
    for _, vehicle in next, VEHICLES do
        if vehicle.model == model then
            return vehicle
        end
    end
    return nil
end

function GetVehicleBonusData(vehicle)
    return VEHICLE_BONUSES[vehicle] or 0.0
end
