local minigameOpen = false

local function StartMineSweeper(title, iconClass, gridSize, startingBalance, multiplier, specialItem, timeoutDuration)
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

-- NUI Callback when finishing the game
RegisterNUICallback('gameOver', function(data, cb)
    if not minigameOpen then return else minigameOpen = false end
    Wait(2000)
    SendNUIMessage({ action = 'fadeOut' })
    SetNuiFocus(false, false)

    TriggerServerEvent('sd-minesweeper:server:dostuff', data)
end)