local _LOADED_PLAYER_DATA = {}
local _CACHED_HASHES = {}
local _CACHED_FILENAMES = {}

local function log(text)
    print("^2[player] ^6" .. text .. "^7")
end

function generatePlayerHash(source)
    if _CACHED_HASHES[source] then return _CACHED_HASHES[source] end
    local hash = GetPlayerIdentifier(source, 0)
    log("generated hash for " .. source .. ": " .. hash)
    _CACHED_HASHES[source] = hash
    return hash
end

function generatePlayerFileName(source)
    if _CACHED_FILENAMES[source] then return _CACHED_FILENAMES[source] end
    local filename = "data/players/" .. generatePlayerHash(source) .. ".json"
    filename = filename:gsub(":", "_")
    log("generated filename for " .. source .. ": " .. filename)
    _CACHED_FILENAMES[source] = filename
    return filename
end

local function generateStringNumber(format)
  local abyte = string.byte("A")
  local zbyte = string.byte("0")

  local number = ""
  for i=1,#format do
    local char = string.sub(format, i,i)
    if char == "D" then number = number..string.char(zbyte+math.random(0,9))
    elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
    else number = number..char end
  end

  return number
end

function VerifyPlayerData(data)
    if not data.money then data.money = 6000 end
    if not data.job then data.job = "Trucker" end
    if not data.title then data.title = "" end
    if not data.skills then data.skills = {} end
    if not data.skills.trucking then data.skills.trucking = 0 end
    if not data.skills.piloting then data.skills.piloting = 0 end
    if not data.skills.security then data.skills.security = 0 end
    if not data.skills.hazard then data.skills.hazard = 0 end
    if not data.skills.heavy then data.skills.heavy = 0 end
    if not data.skills.packages then data.skills.packages = 0 end
    if not data.skills.deliveries then data.skills.deliveries = 0 end
    if not data.vehicles then data.vehicles = {} end
    if not data.faction then data.faction = "default" end
    if not data.diamonds then data.diamonds = 0 end
    if not data.inventory then data.inventory = {} end
    if not data.position then data.position = {x = 0, y = 0, z = 0} end
    if not data.truck then data.truck = "BURRITO" end
    if not data.trailer then data.trailer = "DOCKTRAILER" end

    if not data.plate then data.plate = generateStringNumber("LDDD LLL") end

    if not data.skin then
        local skins = {
            "g_m_y_mexgoon_01",
            "g_m_y_mexgoon_02",
            "g_m_y_mexgoon_03",
            "g_m_y_pologoon_01",
            "g_m_y_pologoon_02",
            "g_m_y_salvaboss_01",
            "g_m_y_salvagoon_01",
            "g_m_y_salvagoon_02",
            "g_m_y_salvagoon_03",
            "g_m_y_strpunk_01",
            "g_m_y_strpunk_02",
        }
        data.skin = skins[math.random(#skins)]
    end

    if not data.admin then data.admin = false end

    if not data.banned then data.banned = false end
    if not data.bantime then data.bantime = 0 end
    if not data.reason then data.reason = "" end

    if not data.paid then data.paid = 0 end
    if not data.earned then data.earned = 0 end
    if not data.quicktravel then data.quicktravel = 0 end

    if not data.primary then data.primary = math.random(0, 159) end
    if not data.secondary then data.secondary = math.random(0, 159) end

    return data
end

function SetPlayerData(source, index, data)
    log("setting data index " .. index .. " for " .. source)
    GetPlayerData(source, function(plydata)
        plydata[index] = data
    end)
end

RegisterCommand("op", function(source, args, _)
    SetPlayerData(tonumber(args[1]), "admin", true)
end, true)

RegisterCommand("title", function(source, args, _)
    SetPlayerData(table.remove(args, 1), "title", table.concat(args, ""))
end, true)

RegisterCommand("status", function(source, _, _)
    for _, source in next, GetPlayers() do
        print(("%s - %s"):format(source, GetPlayerName(source)))
    end
end, true)

RegisterCommand("deop", function(source, args, _)
    SetPlayerData(tonumber(args[1]), "admin", false)
end, true)

function LoadPlayerData(source, cb)
    local player = generatePlayerHash(source)
    local filename = generatePlayerFileName(source)
    local dataRaw = LoadResourceFile(GetCurrentResourceName(), filename)
    local data = {}
    if dataRaw then
        -- Returning account
        data = json.decode(dataRaw)
    else
        -- New account
    end
    data = VerifyPlayerData(data)
    if _LOADED_PLAYER_DATA[player] then
        if cb then cb(false) end
        return false
    else
        log("loading player data for " .. source .. " (" .. player .. ")")
        _LOADED_PLAYER_DATA[player] = data
        if cb then cb(true) end
        log("loaded player data for " .. source .. " (" .. player .. ")")
        return true
    end
end

function SavePlayerData(source, cb)
    local player = generatePlayerHash(source)
    if _LOADED_PLAYER_DATA[player] then
        log("saving player data for " .. source .. " (" .. player .. ")")
        local filename = generatePlayerFileName(source)
        SaveResourceFile(GetCurrentResourceName(), filename, json.encode(_LOADED_PLAYER_DATA[player]), -1)
        if cb then cb(true) end
        log("saved player data for " .. source .. " (" .. player .. ")")
        return true
    else
        if cb then cb(false) end
        return false
    end
end

function ClearPlayerData(source, cb)
    local player = generatePlayerHash(source)
    if _LOADED_PLAYER_DATA[player] then
        log("clearing player data for " .. source .. " (" .. player .. ")")
        SavePlayerData(source)
        _LOADED_PLAYER_DATA[player] = nil
        if cb then cb(true) end
        log("cleared player data for " .. source .. " (" .. player .. ")")
        return true
    else
        if cb then cb(false) end
        return false
    end
end

function GetPlayerData(source, cb)
    local player = generatePlayerHash(source)
    if _LOADED_PLAYER_DATA[player] then
        log("getting player data for " .. source .. " (" .. player .. ")")
        _LOADED_PLAYER_DATA[player].id = player
        if cb then cb(_LOADED_PLAYER_DATA[player]) end
        log("got player data for " .. source .. " (" .. player .. ")")
        return _LOADED_PLAYER_DATA[player]
    else
        LoadPlayerData(source)
        return GetPlayerData(source, cb)
    end
end

local function checkPlayerBool(source, entry, cb)
    local data = GetPlayerData(source)
    if data[entry] then
        if cb then cb(true) end
        return true
    end
    if cb then cb(false) end
    return false
end

function IsAdmin(source, cb)
    return checkPlayerBool(source, "admin", cb)
end
