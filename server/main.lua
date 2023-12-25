-- FRAMEWORK DETECTION
if GetResourceState('qb-core') == 'started' then Framework = 'qb' elseif GetResourceState('es_extended') == 'started' then Framework = 'esx' end
if Framework == 'esx' then ESX = exports['es_extended']:getSharedObject() elseif Framework == 'qb' then QBCore = exports['qb-core']:GetCoreObject() end

local invState = GetResourceState('ox_inventory') -- Get the resource state of ox_inventory

local players = {} -- Table to store players

local dirtycash = false -- Set to false if you want to use regular cash instead of dirty cash
local metadata = false -- if dirtycash true and this true, then you'll be given 'markedbills' with 'worth' attached to them (works with qb-inventory and all of it's forks (eg. ps-inventory etc.))

-- RegisterCallback: Registers a callback function to be triggered later
local RegisterCallback = function(name, cb)
    if Framework == 'esx' then ESX.RegisterServerCallback(name, cb)
    elseif Framework == 'qb' then QBCore.Functions.CreateCallback(name, cb) end
end

-- GetPlayer: Returns the player object for a given player source
local GetPlayer = function(source)
    if Framework == 'esx' then return ESX.GetPlayerFromId(source)
    elseif Framework == 'qb' then return QBCore.Functions.GetPlayer(source) end
end

-- Define a function to get the (citizen) ID of a player
local GetIdentifier = function(source, identifierType)
    local player = GetPlayer(source)
    if player then
        if Framework == 'esx' then return player.identifier
        elseif Framework == 'qb' then return player.PlayerData.citizenid end
    end
end

-- ConvertMoneyType: convert MoneyType to framework specific variant if needed
ConvertMoneyType = function(moneyType)
    if moneyType == 'money' and Framework == 'qb' then
        moneyType = 'cash'
    elseif moneyType == 'cash' and Framework == 'esx' then
        moneyType = 'money'
    end

    return moneyType
end

-- AddMoney: Add Money to a player's account
local AddMoney = function(source, moneyType, amount)
    local player = GetPlayer(source)
    moneyType = ConvertMoneyType(moneyType)
    
    if player then
        if Framework == 'esx' then player.addAccountMoney(moneyType, amount)
        elseif Framework == 'qb' then player.Functions.AddMoney(moneyType, amount) end
    end
end

-- AddItem: Add Item to a player's account
local AddItem = function(source, item, count, slot, metadata)
    if count == nil then count = 1 end

    local player = GetPlayer(source)

    if invState == 'started' then return exports['ox_inventory']:AddItem(source, item, count, metadata, slot) else
        if Framework == 'esx' then return player.addInventoryItem(item, count, metadata, slot)
        elseif Framework == 'qb' then player.Functions.AddItem(item, count, slot, metadata) TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add', count) end
    end
end

-- isPlayer: Checks if a player is inside the players table
local IsPlayer = function(src)
    local retval = false
    for i=1, #players do
        if players[i].id == src then retval = true
            break
        end
    end
    return retval
end

-- RemovePlayer: Removes a player from the players table
local RemovePlayer = function(playerId)
    for i=1, #players do
        if players[i].id == playerId then
            table.remove(players, i)
            break
        end
    end
end

RegisterCallback('sd-minesweeper:server:addPlayerCallback', function(source, cb)
	local added = false local src = source local identifier = GetIdentifier(source)
    players[#players+1] = { id = src, citizenid = identifier } added = true
    cb(added)
end)

RegisterNetEvent('sd-minesweeper:server:removePlayer', function(source)
    RemovePlayer(source)
end)

RegisterNetEvent('sd-minesweeper:server:dostuff', function(data)
    local src = source
    if not IsPlayer(src) then return end

    if data.goldenBox then AddItem(src, data.specialItem, 1) end

    if dirtycash then
        if Framework == 'qb' then
            if metadata then 
                local info = { worth = data.cashAmount }
                AddItem(src, 'markedbills', 1, false, info)
            else 
                AddItem(src, 'markedbills', data.cashAmount)
            end
        elseif Framework == 'esx' then
            local Player = ESX.GetPlayerFromId(src)
            Player.addAccountMoney('black_money', data.cashAmount)
        end
    else
        AddMoney(src, 'cash', data.cashAmount)
    end

    RemovePlayer(src)
end)