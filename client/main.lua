local player = nil
local IsAnimated = false


AddEventHandler('ox:playerLoaded', function()
    TriggerEvent('desync:statusLoaded')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerEvent('desync:statusLoaded') -- Trigger the event when the resource starts
    end
end)

AddEventHandler('ox:playerDeath', function()
	print('desync:playerDied')
    TriggerEvent('desync:healPlayerStatuses')
end)

AddEventHandler("desync:setStatus", function(status, value)
    TriggerServerEvent('desync:setPlayerStatus', status, value)
end)

RegisterNetEvent('desync:healPlayerStatuses')
AddEventHandler('desync:healPlayerStatuses', function()
	-- restore hunger & thirst
	TriggerEvent('desync:setStatus', 'hunger', 0)
	TriggerEvent('desync:setStatus', 'thirst', 0)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

RegisterCommand('sethealth', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local health = tonumber(args[1])
    if health then
        SetEntityHealth(playerPed, health)
    end
end)



AddEventHandler("desync:statusLoaded", function()
    if not player then
        player = Ox.GetPlayer()
        decreaseHealth()
    end
end)


RegisterCommand('kill', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 0)
end)

RegisterCommand('heal', function(source, args, rawCommand)
    TriggerEvent('desync:healPlayerStatuses')
    SetEntityHealth(PlayerPedId(), 200)
end)

RegisterCommand('setstatus', function(source, args, rawCommand)
    local status = args[1]
    local value = tonumber(args[2])

    if not status or not value then
        print('Usage: /setstatus <status> <value>')
        return
    end

    TriggerEvent('desync:setStatus', status, value)
end)



RegisterCommand('printstatuses', function(source, args, rawCommand)

    local statuses = player.getStatuses()
    print(json.encode(statuses))
    print("player health: " .. GetEntityHealth(cache.ped))
end)


-- Decrease health if low on hunger and thirst
function decreaseHealth()

    if not player then
        TriggerEvent('desync:statusLoaded')
        return
    end

    Citizen.CreateThread(function()
        while true do
            Wait(2000)
            local statuses = player.getStatuses()
            local prevHealth = GetEntityHealth(cache.ped)--    GetEntityHealth(PlayerPedId())
            -- print("prevHealth: " .. prevHealth)
            local health = prevHealth
            
            hunger = statuses['hunger']
            thirst = statuses['thirst']

            if hunger >= 100 then
                -- if prevHealth <= Config.LowHealthThreshold then
                --     health = health - (Config.HungerRateOfChange * Config.LowHealthMultiplier)
                -- else
                    health = health - 1
                -- end
            end

            if thirst >= 100 then
                -- if prevHealth <= Config.LowHealthThreshold then
                --     health = health - (Config.ThirstRateOfChange * Config.LowHealthMultiplier)
                -- else
                    health = health - 1
                -- end
            end
            -- print("health: " .. health)

            
            

            -- Original code, calls  3 times (for each status obviously), only need to call once so reformatting above 
            -- for k, v in pairs(statuses) do
            --     -- print(k .. ": " .. v)
            --     -- Ox Core is weird and the health is not 0-100, it's 100-200 so the low health threshold doesnt kick in, I know
            --     -- It also will not allow me to subtract health by any non-integer value, maybe because it's by percentage
            --     -- Will change later maybe
            --     if k == 'hunger' and v >= 100 then
            --         if prevHealth <= Config.LowHealthThreshold then
            --             -- health = health - (Config.HungerRateOfChange * Config.LowHealthMultiplier)
            --             health = health - 2
            --         else
            --             -- print(Config.HungerRateOfChange)
            --             -- health = health - Config.HungerRateOfChange
            --             health = health - 1
            --         end
            --     elseif k == 'thirst' and v >= 100 then
            --         if prevHealth <= Config.LowHealthThreshold then
            --             -- health = health - (Config.ThirstRateOfChange * Config.LowHealthMultiplier)
            --             health = health - 2
            --         else
            --             -- print(Config.ThirstRateOfChange)
            --             -- health = health - Config.ThirstRateOfChange
            --             health = health - 1
            --         end
            --     end
            --     print(health)
            -- end

            -- if health ~= prevHealth then
                SetEntityHealth(cache.ped, health)
            -- end
        end
    end)
end

AddEventHandler('desync:isEating', function(cb)
    cb(IsAnimated)
end)