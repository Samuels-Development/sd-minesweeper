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