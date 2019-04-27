Event("quickwarp", function(pos, price, name)
    local source = source
    if Server:TryPayment(source, price) then
        SendEvent("quickwarp", source, pos, name)
    end
end)

Event("modshop:colors", function(primary, secondary)
    local source = source
    Server:SetPlayerData(source, "primary", primary)
    Server:SetPlayerData(source, "secondary", secondary)
end)
