
RegisterNetEvent('desync:setPlayerStatus')
AddEventHandler('desync:setPlayerStatus', function(status, value)
    local player = Ox.GetPlayer(source)
    player.setStatus(status, value)
end)