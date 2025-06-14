local QBCore = exports['qb-core']:GetCoreObject()

-- Give package
RegisterNetEvent('sam-drugrun:givepackage', function()
local Player = QBCore.Functions.GetPlayer(source)
	if not Player then return end
    local deliveryItem = Config.DeliveryItem
	Player.Functions.AddItem(deliveryItem, 1)
    TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items[deliveryItem], 'add')
end)

-- Remove Package
RegisterNetEvent('sam-drugrun:removepackage', function()
    local Player = QBCore.Functions.GetPlayer(source)
	exports['qb-inventory']:RemoveItem(source, Config.DeliveryItem, 1, false, 'qb-inventory:testRemove')
end)

-- Reward
RegisterNetEvent("sam-drugrun:rewardLow", function()
    local Player = QBCore.Functions.GetPlayer(source)
    local paymentLow = Config.LowRepReward
    Player.Functions.AddMoney('cash', paymentLow, 'Drug Run')

end)

RegisterNetEvent("sam-drugrun:rewardHigh", function()
    local Player = QBCore.Functions.GetPlayer(source)
    local paymentHigh = Config.HighRepReward
    Player.Functions.AddMoney('cash', paymentHigh, 'Drug Run')

end)


-- Rep System
local function GetPlayerCid(source)
    local cid = nil
    
    local player = QBCore.Functions.GetPlayer(source)
    cid = player.PlayerData.citizenid 
    return cid
end

lib.callback.register("sam-drugrun:server:getrep", function (source)
    
    local repRow = MySQL.single.await('SELECT `rep` FROM `drugrun_rep` WHERE `citizen_id` = ?', { GetPlayerCid(source) })

    if repRow then
        return repRow.rep
    else
        TriggerEvent("sam-drugrun:server:createRepEntry", source)
        return 0
    end
end)

RegisterNetEvent("sam-drugrun:server:setRep", function(rep)
    local src = source

    local repRow = MySQL.single.await('SELECT `rep` FROM `drugrun_rep` WHERE `citizen_id` = ?', { GetPlayerCid(source) })

    if repRow then
       MySQL.update.await("UPDATE `drugrun_rep` SET `rep` = ? WHERE `citizen_id` = ?", { rep, GetPlayerCid(src)})
    else
        TriggerEvent("sam-drugrun:server:createRepEntry", src)
        
    end
    
end)

RegisterNetEvent("sam-drugrun:server:createRepEntry", function(source)
    MySQL.insert.await('INSERT INTO `drugrun_rep` (citizen_id) VALUES (?)', {GetPlayerCid(source) })
    
end)
