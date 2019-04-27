UserConfig = {}
UserConfigMenu = {}

function GetUserConfig(field, default)
    if UserConfig[field] then
        return UserConfig[field]
    else
        return default
    end
end

function SetUserConfig(field, value)
    UserConfig[field] = value

    local typ = type(value)
    if typ == 'string' then
        log("String values are not supported for kvp storage")
    elseif typ == 'boolean' then
        setActualKvp(field, value)
    elseif typ == 'number' then
        setActualKvpFloat(field, value)
    elseif typ == 'table' then
        log("Table values are not supported for kvp storage")
    else
        log("Value not supported for kvp storage")
    end
end

function RegisterConfigOption(title, config, typ, step)
    table.insert(UserConfigMenu, {title = title, config = config, typ = typ, step = step})
    if typ == "number" then
        SetUserConfig(config, getActualKvpFloat(config))
    elseif typ == "boolean" then
        SetUserConfig(config, getActualKvp(config))
    end
end

Citizen.CreateThread(function()
    RegisterConfigOption("Disable HUD", "hud_disabled", "boolean")
    RegisterConfigOption("Disable Speedometer", "hud_disable_speedometer", "boolean")
    RegisterConfigOption("Disable Persistent Instructions", "hud_disable_instructions", "boolean")
    RegisterConfigOption("Disable Health & Fuel Bar", "hud_disable_healthbar", "boolean")
    RegisterConfigOption("Disable Fuel System", "game_disable_fuel", "boolean")

    RegisterConfigOption("Enable Traditional HUD", "hud_traditional", "boolean")

    RegisterConfigOption("HUD Anchor Hor. Offset", "minimap_x", "number", 0.005)
    RegisterConfigOption("HUD Anchor Vert. Offset", "minimap_y", "number", 0.005)

    RegisterConfigOption("HUD Anchor Hor. Scale", "minimap_xscale", "number", 0.005)
    RegisterConfigOption("HUD Anchor Vert. Scale", "minimap_yscale", "number", 0.005)

    RegisterConfigOption("HUD Text Scale", "hud_textscale", "number", 0.005)
end)
