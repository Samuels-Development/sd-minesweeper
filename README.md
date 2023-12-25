# sd-objective

This minigame is a twist on the classic 'Minesweeper', where players start with a set balance. Each safe move increases this balance, while uncovering a mine ends the game. The goal is to maximize gains without hitting any mines. A golden crown can be hit to receive a special reward item. This minigame, unlike other minigames, has it's own money adding handling/logic.

Feel free to star the repository and check out my store and discord @ Discord: https://discord.gg/samueldev & Store: https://fivem.samueldev.shop 
For support inquires please create a post in the support-forum channel on discord or create an issue here on Github.

## Preview
![FiveM_b2944_GTAProcess_mPrXn4j0yL](https://github.com/Samuels-Development/sd-minesweeper/assets/99494967/6ff7425a-52ae-4c2c-90eb-6cca8dd407ab)

<br>

![FiveM_b2944_GTAProcess_uOCcKChvj9](https://github.com/Samuels-Development/sd-minesweeper/assets/99494967/372dbc8a-5fb4-49cb-b6b6-7640b687b2dd)


### Video Preview
https://github.com/Samuels-Development/sd-minesweeper/assets/99494967/868bc145-03d4-4c25-81e9-960cd025733e

## Installation

1. Clone or download this resource.
2. Place it in the server's resource directory.
3. Add the resource to your server config, if needed.

## Usage

### Exports
Exports are exclusively available on the client and can't be called from server-side files.

- `StartMineSweeper(title, iconClass, gridSize, startingBalance, multiplier, specialItem, timeoutDuration)`
   - `title`: Title of the minigame (e.g., "Minesweeper Challenge").
   - `iconClass`: CSS class for the icons used in the game grid (e.g., "fa-solid fa-gem").
   - `gridSize`: Size of the game grid (e.g., `5` for a 5x5 grid).
   - `startingBalance`: The initial balance or score at the start of the game.
   - `multiplier`: The multiplier applied to the balance upon uncovering a safe tile.
   - `specialItem`: The item rewarded upon revealing a golden tile.
   - `timeoutDuration`: Duration (in milliseconds) before the game automatically ends.

### Event Handlers
Events can be called from client & server-side.

 `sd-minesweeper:client:start`: Initiates the Minesweeper game with specified parameters (maps to `StartMineSweeper`).

### Example Usage

Utilizing Exports
```lua
-- Start the Minesweeper game
exports['sd-minesweeper']:StartMineSweeper('Minesweeper Challenge', 'fa-solid fa-gem', 5, 1000, 1.2, 'diamond', 20000)
```

Utilizing Events
```lua
-- Start the Minesweeper game
TriggerClientEvent('sd-minesweeper:client:start', source, 'Minesweeper Challenge', 'fa-solid fa-gem', 5, 1000, 1.2, 'diamond', 20000)
```

### Contextual Example
Straight from lation_247robbery <3
```lua
RegisterNetEvent('lation_247robbery:RewardRobbery', function(source, type)
    local source = source
    local player = GetPlayer(source)
    if not player then return end
    local playerName = GetName(source)
    local identifier = GetIdentifier(source)
    local distance = CheckPlayerDistance(source)
    local item, quantity, value
    if distance then
        if type == 'register' then
            item = Config.RegisterRewardItem
            quantity = Config.RegisterRewardQuantity
            if Config.RegisterRewardRandom then
                quantity = math.random(Config.RegisterRewardMinQuantity, Config.RegisterRewardMaxQuantity)
            end
            value = quantity
            TriggerClientEvent('sd-minesweeper:client:start', source, 'Register Balance', 'fas fa-shopping-cart', 6, quantity, 1.05, 'laptop')
            Wait(10000)
            RegisterCooldown()
        else
            item = Config.SafeRewardItem
            quantity = Config.SafeRewardQuantity
            if Config.SafeRewardRandom then
                quantity = math.random(Config.SafeRewardMinQuantity, Config.SafeRewardMaxQuantity)
            end
            value = quantity
            SafeCooldown()
        end
        if Framework == 'qb' then
            if Config.Metadata then
                quantity = {worth = quantity}
                value = quantity.worth
            end
        end
        -- AddItem(source, item, quantity)
        if Config.EnableLogs then
            local robType = type:gsub("^%l", string.upper) -- Capitalizing string for logs
            DiscordLogs(
                '💰 ' ..robType.. ' ' ..Strings.Logs.titles.robbery,
                Strings.Logs.labels.name ..playerName..
                Strings.Logs.labels.id ..tostring(source)..
                Strings.Logs.labels.identifier ..tostring(identifier)..
                Strings.Logs.labels.message ..Strings.Logs.messages.robbery.. '$' ..GroupDigits(value).. ' ' ..item,
                Strings.Logs.colors.green
            )
        end
    end
end)
```

