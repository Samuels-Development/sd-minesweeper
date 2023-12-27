Config = {}

Config.DirtyCash = false -- false = you want to use regular cash instead of dirty cash, true = you want to use dirty_money (markedbills)
Config.MetaData = false -- if dirtycash true and this true, then you'll be given 'markedbills' with 'worth' attached to them (works with qb-inventory and all of it's forks (eg. ps-inventory etc.))

Config.Items = { 'laptop', 'security_card_01', 'security_card_02' } -- Items that are allowed to to be given in the AddItem event (if the goldenbox was uncovered)
Config.MaxMoney = { Enable = false, Amount = 10000 } -- Max amount of money that can be given to a player from completing the minigame if Config.MaxMoney.Enable is true.
