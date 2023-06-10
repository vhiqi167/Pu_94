bot = Plutonium:GetBot()
function getBot()
    if bot.m_bot.State == "Connected" then
        Status = "online"
    elseif bot.m_bot.State ==  "Account is banned" then
        Status = "banned"
    elseif bot.m_bot.State == "Connecting" then
        Status = "login fail"
    else
        Status = "offline"
    end
    return {
        world = bot.World.Name,
        name = bot.m_bot.TankInfo.TankIDName,
        x = bot.NetAvatar.Pos.X,
        y = bot.NetAvatar.Pos.Y,
        level = bot.NetAvatar.Level,
        status = Status,
        gems = bot.NetAvatar.Inventory.Gems,
        slot = bot.NetAvatar.Inventory.BackPackSize,
    }
end
function findItem(id)
    if id == 112 then
        return bot.NetAvatar.Inventory.Gems
    end
    item = bot:FindItem(id)
    if item == nil then
        return 0
    else
        return item.Count
    end
end
function say(text)
    bot:Say(text)
end
function findPath(x,y)
    bot:FindPathAsync(x,y)
end
function move(p_x,p_y)
    local x = math.floor(bot.NetAvatar.Pos.X/32) + p_x
    local y = math.floor(bot.NetAvatar.Pos.Y/32) + p_y
    bot:FindPathAsync(x,y)
    Plutonium:Sleep(bot:GetCooldown())
end
function punch(p_x,p_y)
    local x = math.floor(bot.NetAvatar.Pos.X/32) + p_x
    local y = math.floor(bot.NetAvatar.Pos.Y/32) + p_y
    bot:PunchTile(x, y)
end
function place(id,p_x,p_y)
    local x = math.floor(bot.NetAvatar.Pos.X/32) + p_x
    local y = math.floor(bot.NetAvatar.Pos.Y/32) + p_y
    bot:PlaceTile(x, y, id)
end
function sleep(milliseconds)
    Plutonium:Sleep(milliseconds)
end
function drop(iditem,count)
    if count ~= nil then
        bot:Drop(iditem, count)
        sleep(200)
    else
        bot:Drop(iditem)
        sleep(200)
    end
end
function trash(iditem, count)
    if count ~= nil then
        bot:Trash(iditem, count)
        sleep(2000)
    else
        bot:Trash(iditem)
        sleep(2000)
    end
end
function collect(range, id)
    if id == nil then
        bot:Collect(range*32)
    else
        bot:Collect(range*32, id)
    end
end
function connect()
    bot:Connect()
end
function disconnect()
    bot:Disconnect()
end
function getTile(tilex,tiley)
    tilefg = 0
    tilebg = 0
    tileflags = 0
    tileready = false
    tilefg = bot:GetTile(tilex, tiley).Foreground
    tilebg = bot:GetTile(tilex, tiley).Background
    tileflags = bot:GetTile(tilex, tiley).Flags
    tileready = bot:GetTile(tilex, tiley).SeedData:IsReady()
    return {
        fg = tilefg,
        bg = tilebg,
        flags = tileflags,
        ready = tileready,
    }
end
function getTiles()
    local tiles = {}
    local bot = Plutonium:GetBot()
    for j = 0, bot.World.Height - 1 do
        for i = 0, bot.World.Width - 1 do
            table.insert(tiles, { x = i, y = j, fg = getTile(i,j).fg ,flags =  getTile(i,j).flags ,bg =  getTile(i,j).bg ,ready = getTile(i,j).ready})
        end
    end
    return tiles
end
function warp(world,iddoor)
    while bot.World.Name ~= world do
        bot:Warp(world)
        Plutonium:Sleep(5000)
    end
    while bot:GetTile(math.floor(bot.NetAvatar.Pos.X/32), math.floor(bot.NetAvatar.Pos.Y/32)).Foreground == 6 do
        bot:Warp(world.."|"..iddoor)
        Plutonium:Sleep(1000)
    end
end
function sendPacket(type, text)
    Plutonium:SendPacket(type, text)
end
function store_pack(namepack)
    Plutonium:Sleep(100)
    Plutonium:SendPacket(2,"action|buy\nitem|"..namepack)
    Plutonium:Sleep(400)
end
function upbagpack()
    Plutonium:Sleep(100)
    Plutonium:SendPacket(2,"action|buy\nitem|upgrade_backpack")
    Plutonium:Sleep(400)
end
