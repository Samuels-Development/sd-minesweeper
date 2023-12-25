-- FRAMEWORK DETECTION
if GetResourceState('qb-core') == 'started' then Framework = 'qb' elseif GetResourceState('es_extended') == 'started' then Framework = 'esx' end
if Framework == 'esx' then ESX = exports['es_extended']:getSharedObject() elseif Framework == 'qb' then QBCore = exports['qb-core']:GetCoreObject() end

-- Function to trigger a server-side callback
ServerCallback = function(name, cb, ...)
    if Framework == 'esx' then
        ESX.TriggerServerCallback(name, cb, ...)
    elseif Framework == 'qb' then
        QBCore.Functions.TriggerCallback(name, cb, ...)
    end
end

local function StartMineSweeper(title, iconClass, gridSize, startingBalance, multiplier, specialItem, timeoutDuration)
    TriggerEvent('sd-minesweeper:client:addPlayer')
    SendNUIMessage({
        action = 'open',
        title = title,
        iconClass = iconClass,
        gridSize = gridSize,
        startingBalance = startingBalance,
        multiplier = multiplier,
        specialItem = specialItem,
        timeoutDuration = timeoutDuration
    })
    SetNuiFocus(true, true)
end

-- Export the StartMineSweeper function
exports("StartMineSweeper", StartMineSweeper)

-- Create an event for use on server-side
RegisterNetEvent('sd-minesweeper:client:start', function(title, iconClass, gridSize, startingBalance, multiplier, specialItem)
    StartMineSweeper(title, iconClass, gridSize, startingBalance, multiplier, specialItem)
end)

-- Command for testing
RegisterCommand('minesweeper', function()
    StartMineSweeper('Register Balance', 'fa-solid fa-house', 5, 500, 1.20, 'laptop', 20000)
end)

-- NUI Callback when finishing the game
RegisterNUICallback('gameOver', function(data, cb)
    Wait(2000)
    SendNUIMessage({ action = 'fadeOut' })
    SetNuiFocus(false, false)

    TriggerServerEvent('sd-minesweeper:server:dostuff', data)
end)

RegisterNetEvent('sd-minesweeper:client:addPlayer', function(data)
    local p = promise.new() 
      ServerCallback("sd-minesweeper:server:addPlayerCallback", function(added) 
        p:resolve(added)
      end)
    return Citizen.Await(p)
end)
