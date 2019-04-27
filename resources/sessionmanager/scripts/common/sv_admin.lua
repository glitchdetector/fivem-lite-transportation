local adminCallbackCodes = {}

RegisterServerEvent("lite:admin:callbackCode")
AddEventHandler("lite:admin:callbackCode", function(code)
    local source = source
    local function fail() Server:KickPlayer(source, "Untrusted account") end
    local function success() end
    if adminCallbackCodes[code] and adminCallbackCodes[code] == source then
        adminCallbackCodes[code] = nil
        success()
        return true
    end
    fail()
    return false
end)

local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

local function randomString(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock()^5)
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

function _generateCode()
    local code = randomString(10)
    if adminCallbackCodes[code] then
        return _generateCode()
    end
    return code
end
function GenerateCode(source)
    local code = _generateCode()
    adminCallbackCodes[code] = source
    return code
end

RegisterServerEvent("lite:admin:request")
AddEventHandler("lite:admin:request", function(event, ...)
    local source = source
    if Server:IsAdmin(source) then
        local code = GenerateCode(source)
        TriggerClientEvent(event, source, code, ...)
    end
end)

RegisterServerEvent("lite:admin:kick")
AddEventHandler("lite:admin:kick", function(id)
    local source = source
    if Server:IsAdmin(source) then
        Server:KickPlayer(id, "Kicked by " .. GetPlayerName(source))
    end
end)

RegisterServerEvent("lite:admin:ban")
AddEventHandler("lite:admin:ban", function(id)
    local source = source
    if Server:IsAdmin(source) then
        Server:BanPlayer(id, "Banned by " .. GetPlayerName(source))
    end
end)

RegisterServerEvent("lite:admin:pos")
AddEventHandler("lite:admin:pos", function(pos)
    local source = source
    if Server:IsAdmin(source) then
        local fileName = "admin/coords.txt"
        local data = LoadResourceFile(GetCurrentResourceName(), fileName) or ""
        data = data .. ("{name = \"%s\", x = %f, y = %f, z = %f, h = %f}, -- %s\n"):format(pos.name, pos.x, pos.y, pos.z, pos.h, GetPlayerName(source))
        SaveResourceFile(GetCurrentResourceName(), fileName, data, -1)
    end
end)
