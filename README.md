![Brazzers Development Discord](https://i.imgur.com/nXhPxIO.png)

<details>
    <summary><b>Important Links</b></summary>
        <p>
            <a href="https://discord.gg/J7EH9f9Bp3">
                <img alt="GitHub" src="https://logos-download.com/wp-content/uploads/2021/01/Discord_Logo_full.png"
                width="150" height="55">
            </a>
        </p>
        <p>
            <a href="https://ko-fi.com/mannyonbrazzers">
                <img alt="GitHub" src="https://uploads-ssl.webflow.com/5c14e387dab576fe667689cf/61e11149b3af2ee970bb8ead_Ko-fi_logo.png"
                width="150" height="55">
            </a>
        </p>
</details>

# Installation steps

## General Setup
Harness system allowing you to save harnesses per vehicle (persistent) on owned vehicles. This allows you to simply use your seatbelt hotkey to attach your racing harness instead of having to carry it all the time.

Preview: https://www.youtube.com/watch?v=IsdJzm9LnIg

## Installation
If you're to lazy to do this, I included the drag and drop of qb-smallresources seatbelt.lua in the files lazy fuck

Locate your seatbelt:client:UseHarness event in your qb-smallresources > client > seatbelt.lua and replace with the one below:
```lua
RegisterNetEvent('seatbelt:client:UseHarness', function(ItemData, updateInfo) -- On Item Use (registered server side)
    local ped = PlayerPedId()
    local inveh = IsPedInAnyVehicle(ped, false)
    local class = GetVehicleClass(GetVehiclePedIsUsing(ped))
    if inveh and class ~= 8 and class ~= 13 and class ~= 14 then
        if not harnessOn then
            LocalPlayer.state:set("inv_busy", true, true)
            QBCore.Functions.Progressbar("harness_equip", "Attaching Race Harness", 5000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                LocalPlayer.state:set("inv_busy", false, true)
                ToggleHarness()
                if updateInfo then TriggerServerEvent('equip:harness', ItemData) end
            end)
            if updateInfo then
                harnessHp = ItemData.info.uses
                harnessData = ItemData
                TriggerEvent('hud:client:UpdateHarness', harnessHp)
            end
        else
            harnessOn = false
            ToggleSeatbelt()
        end
    else
        QBCore.Functions.Notify('You\'re not in a car.', 'error')
    end
end)
```
Locate your toggleseatbelt command in your qb-smallresources > client > seatbelt.lua and replace with the one below:
```lua
RegisterCommand('toggleseatbelt', function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) or IsPauseMenuActive() then return end
    local class = GetVehicleClass(GetVehiclePedIsUsing(PlayerPedId()))
    if class == 8 or class == 13 or class == 14 then return end
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local plate = QBCore.Functions.GetPlate(vehicle)

    TriggerServerEvent('brazzers-harness:server:toggleBelt', plate)
end, false)

RegisterKeyMapping('toggleseatbelt', 'Toggle Seatbelt', 'keyboard', 'B')
```
Locate your harness useable item in your qb-smallresources > server > main.lua and replace with the one below:
```lua
QBCore.Functions.CreateUseableItem("harness", function(source, item)
    TriggerClientEvent('brazzers-harness:client:attachHarness', source, item)
end)
```

## Optional

If you want the ability to exit the vehicle without having to take your harness or seatbelt, here you go: 

Locate the main thread in qb-smallresources > client > seatbelt.lua and replace with the one below:
```lua
CreateThread(function()
    while true do
        sleep = 1000
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            sleep = 0
            if seatbeltOn or harnessOn then
                if IsControlJustPressed(0, 75) then
                    seatbeltOn = false
                    harnessOn = false
                end
            end
        else
            seatbeltOn = false
            harnessOn = false
        end
        Wait(sleep)
    end
end)
```

## Features
1. Persistent Harnesses For Vehicles
2. Synced With All Passengers In The Vehicle 
4. Multi-Language Support using QBCore Locales
5.  24/7 Support in discord

## Dependencies
1. oxmysql
2. qb-smallresources
