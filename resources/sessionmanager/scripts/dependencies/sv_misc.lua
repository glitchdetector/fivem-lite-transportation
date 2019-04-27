--[[
    SERVER EVENT HANDLERS
    CUSTOM
]]

function Event(event, func)
    event = "lite:server:" .. event
    log("registered event " .. event)
    RegisterServerEvent(event)
    AddEventHandler(event, function(...)
        log("triggered event " .. event)
        func(...)
    end)
end

function SendEvent(event, source, ...)
    event = "lite:client:" .. event
    log("sending event " .. event .. " to " .. source)
    TriggerClientEvent(event, source, ...)
end
