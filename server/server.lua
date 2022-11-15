local QBCore = exports[Config.Core]:GetCoreObject()

local function isVehicleOwned(plate)
    if Config.BrazzersFakePlate then
        local hasFakePlate = exports['brazzers-fakeplates']:getPlateFromFakePlate(plate)
        if hasFakePlate then plate = hasFakePlate end
        Wait(100)
    end
    
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return true
    end
end

local function hasHarness(plate)
    if Config.BrazzersFakePlate then
        local hasFakePlate = exports['brazzers-fakeplates']:getPlateFromFakePlate(plate)
        if hasFakePlate then plate = hasFakePlate end
        Wait(100)
    end

    local result = MySQL.scalar.await('SELECT harness FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return true
    end
end

RegisterNetEvent('brazzers-harness:server:attachHarness', function(plate, ItemData)
    local src = source
    if not src then return end
    if not isVehicleOwned(plate) then return TriggerClientEvent('seatbelt:client:UseHarness', src, ItemData, true) end
    if Config.UninstallHarnessWithItem and hasHarness(plate) then return TriggerClientEvent('brazzers-harness:client:installHarness', src, plate, 'uninstall') end

    TriggerClientEvent('brazzers-harness:client:installHarness', src, plate, 'install')
end)

RegisterNetEvent('brazzers-harness:server:installHarness', function(plate, action)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if not plate then return end
    if not action then return end

    if Config.BrazzersFakePlate then
        local hasFakePlate = exports['brazzers-fakeplates']:getPlateFromFakePlate(plate)
        if hasFakePlate then plate = hasFakePlate end
        Wait(100)
    end

    if action == 'install' then
        Player.Functions.RemoveItem(Config.Harness, 1)
        TriggerClientEvent('inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items[Config.Harness], 'remove')
        MySQL.update('UPDATE player_vehicles set harness = ? WHERE plate = ?',{true, plate})
    elseif action == 'uninstall' then
        Player.Functions.AddItem(Config.Harness, 1)
        TriggerClientEvent('inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items[Config.Harness], 'add')
        MySQL.update('UPDATE player_vehicles set harness = ? WHERE plate = ?',{NULL, plate})
    end
end)

RegisterNetEvent('brazzers-harness:server:uninstallHarness', function(plate)
    local src = source
    if not plate then return end

    if Config.BrazzersFakePlate then
        local hasFakePlate = exports['brazzers-fakeplates']:getPlateFromFakePlate(plate)
        if hasFakePlate then plate = hasFakePlate end
        Wait(100)
    end

    MySQL.update('UPDATE player_vehicles set harness = ? WHERE plate = ?',{NULL, plate})
end)

RegisterNetEvent('brazzers-harness:server:toggleBelt', function(plate, ItemData)
    local src = source
    if not src then return end
    if not hasHarness(plate) then return TriggerClientEvent('seatbelt:client:UseSeatbelt', src) end

    TriggerClientEvent('seatbelt:client:UseHarness', src, ItemData, false)
end)