local QBCore = exports[Config.Core]:GetCoreObject()

local function isVehicleOwned(plate)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return true
    end
end

local function hasHarness(plate)
    local result = MySQL.scalar.await('SELECT harness FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return true
    end
end

RegisterNetEvent('brazzers-harness:server:attachHarness', function(plate, ItemData)
    local src = source
    if not src then return end
    if not isVehicleOwned(plate) then return TriggerClientEvent('seatbelt:client:UseHarness', src, ItemData, true) end

    TriggerClientEvent('brazzers-harness:client:installHarness', src, plate)
end)

RegisterNetEvent('brazzers-harness:server:installHarness', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if hasHarness(plate) then return TriggerClientEvent('QBCore:Notify', src, Lang:t("error.already_installed"), 'error') end
    -- Remove Item
    Player.Functions.RemoveItem(Config.Harness, 1)
    TriggerClientEvent('inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items[Config.Harness], 'remove')
    MySQL.update('UPDATE player_vehicles set harness = ? WHERE plate = ?',{true, plate})
end)

RegisterNetEvent('brazzers-harness:server:toggleBelt', function(plate, ItemData)
    local src = source
    if not src then return end
    if not hasHarness(plate) then return TriggerClientEvent('seatbelt:client:UseSeatbelt', src) end

    TriggerClientEvent('seatbelt:client:UseHarness', src, ItemData, false)
end)