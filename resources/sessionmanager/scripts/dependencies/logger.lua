--[[
    LOGGER FUNCTIONS
    BY GLITCHDETECTOR
    CUSTOM
]]

function log(text)
    -- print("[logger] " .. text)
end

function chat(text)
    log("[chat] " .. text)
    TriggerEvent("chatMessage", text)
end
