# sd-minesweeper

This minigame is a twist on the classic 'Minesweeper', where players start with a set balance. Each safe move increases this balance, while uncovering a mine ends the game and reset the balance back to the initial starting amount. The goal is to maximize gains without hitting any mines and cashing out. A golden crown can be hit to receive a special reward item. 

Feel free to star the repository and check out my store and discord @ Discord: https://discord.gg/samueldev & Store: https://fivem.samueldev.shop 
For support inquires please create a post in the support-forum channel on discord or create an issue here on Github.

## Preview
<img src="https://github.com/Samuels-Development/sd-minesweeper/assets/99494967/a4e9dc4b-a06e-4bf9-bd49-d10aaed867e3" alt="FiveM_b2944_GTAProcess_vF98r59f2y" style="margin-right: 30px;"/>
<img src="https://github.com/Samuels-Development/sd-minesweeper/assets/99494967/bcb95cde-fb75-4992-bea3-02368bdae5bf" alt="FiveM_b2944_GTAProcess_RzadbbyNcW"/>



### Video Preview

https://github.com/Samuels-Development/sd-minesweeper/assets/99494967/8da0801f-229f-4bd0-ae68-dfe43eafdc61





## Installation

1. Clone or download this resource.
2. Place it in the server's resource directory.
3. Add the resource to your server config, if needed.

### Configuration
There's a couple variables in the server/main.lua that can be easily adjusted and are neatly commented.

### Disclaimer
This minigame features it's own money handling and logic, distinct from other minigames. Therefore, remove any existing money management code from scripts where this minigame is integrated, as demonstrated in the contextual example below.

## Usage

You'll want to run the AddPlayer export and pass through source before running the minigame.

- `StartMineSweeper(title, iconClass, gridSize, startingBalance, multiplier, specialItem, timeoutDuration)`
   - `title`: Title of the minigame (e.g., "Minesweeper Challenge").
   - `iconClass`: CSS class for the icons used in the game grid (e.g., "fa-solid fa-gem").
   - `gridSize`: Size of the game grid (e.g., `5` for a 5x5 grid).
   - `startingBalance`: The initial balance or score at the start of the game.
   - `multiplier`: The multiplier applied to the balance upon uncovering a safe tile.
   - `specialItem`: The item rewarded upon revealing a golden tile.
   - `timeoutDuration`: Duration (in milliseconds) before the game automatically ends.

Both specialItem and timeoutDuration are optional parameters. If timeoutDuration is omitted, the game will not impose any time limit to complete the objective. On the other hand, if specialItem is not specified, the golden crown tile will function as a 1.5x multiplier instead.

## Exports 
Exclusively avaiable on the server.

 `AddPlayer`: A security function that registers a player in the Minesweeper game, safeguarding against exploiters. It links their server and in-game IDs for accurate activity tracking.

### Event Handlers
This event should only be used on the server.

 `sd-minesweeper:client:start`: Initiates the Minesweeper game with specified parameters (eg. `StartMineSweeper`).

### Example Usage
```lua
-- Add player to to server-side table.
exports['sd-minesweeper']:AddPlayer(source)

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
            exports['sd-minesweeper']:AddPlayer(source)
            TriggerClientEvent('sd-minesweeper:client:start', source, 'Register Balance', 'fas fa-shopping-cart', 6, quantity, 1.05, 'laptop', 20000)
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

