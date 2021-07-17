--[[

.______     ______        _______.     _______.   ____    ____   _______.   .______    __          ___   ____    ____  _______ .______          _______.
|   _  \   /  __  \      /       |    /       |   \   \  /   /  /       |   |   _  \  |  |        /   \  \   \  /   / |   ____||   _  \        /       |
|  |_)  | |  |  |  |    |   (----`   |   (----`    \   \/   /  |   (----`   |  |_)  | |  |       /  ^  \  \   \/   /  |  |__   |  |_)  |      |   (----`
|   _  <  |  |  |  |     \   \        \   \         \      /    \   \       |   ___/  |  |      /  /_\  \  \_    _/   |   __|  |      /        \   \
|  |_)  | |  `--'  | .----)   |   .----)   |         \    / .----)   |      |  |      |  `----./  _____  \   |  |     |  |____ |  |\  \----.----)   |
|______/   \______/  |_______/    |_______/           \__/  |_______/       | _|      |_______/__/     \__\  |__|     |_______|| _| `._____|_______/

.______   ____    ____     _______    ___       __          ___      ___   ___  __  .______
|   _  \  \   \  /   /    |   ____|  /   \     |  |        /   \     \  \ /  / |  | |   _  \
|  |_)  |  \   \/   /     |  |__    /  ^  \    |  |       /  ^  \     \  V  /  |  | |  |_)  |
|   _  <    \_    _/      |   __|  /  /_\  \   |  |      /  /_\  \     >   <   |  | |      /
|  |_)  |     |  |        |  |    /  _____  \  |  `----./  _____  \   /  .  \  |  | |  |\  \----.
|______/      |__|        |__|   /__/     \__\ |_______/__/     \__\ /__/ \__\ |__| | _| `._____|

--]]

BVP_CONFIG = {}
-- Do not touch
function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function ConfigLoad()
    Package.Log("Loading Config...")
    local cfgFile = File("Packages/" .. Package.GetPath() .. "/Server/Config.json")
    local cfgJson = JSON.parse(cfgFile:Read(cfgFile:Size()))
    BVP_CONFIG = cfgJson
    NewPlayerSpawnLocations = {}
    for key,value in pairs(BVP_CONFIG.PlayerSpawnLocations)
    do
        local newVectorTXT = string.gsub(value, "% ", "")
        newVectorTXT = Split(newVectorTXT, ",")
        local newVector = Vector(tonumber(newVectorTXT[1]), tonumber(newVectorTXT[2]), tonumber(newVectorTXT[3]))
        table.insert(NewPlayerSpawnLocations, newVector)
    end
    BVP_CONFIG.PlayerSpawnLocations = NewPlayerSpawnLocations
    NewBossSpawnLocations = {}
    for key,value in pairs(BVP_CONFIG.BossSpawnLocations)
    do
        local newVectorTXT = string.gsub(value, "% ", "")
        newVectorTXT = Split(newVectorTXT, ",")
        local newVector = Vector(tonumber(newVectorTXT[1]), tonumber(newVectorTXT[2]), tonumber(newVectorTXT[3]))
        table.insert(NewBossSpawnLocations, newVector)
    end
    BVP_CONFIG.BossSpawnLocations = NewBossSpawnLocations
    NewResupplyLocations = {}
    for key,value in pairs(BVP_CONFIG.ResupplyLocations)
    do
        local newVectorTXT = string.gsub(value, "% ", "")
        newVectorTXT = Split(newVectorTXT, ",")
        local newVector = Vector(tonumber(newVectorTXT[1]), tonumber(newVectorTXT[2]), tonumber(newVectorTXT[3]))
        table.insert(NewResupplyLocations, newVector)
    end
    BVP_CONFIG.ResupplyLocations = NewResupplyLocations
    Package.Log("Loading Config COMPLETE!")
end