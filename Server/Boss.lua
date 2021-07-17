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

function BossCreateStartRound(bossData, BossAsset)
    local PlayerNames = Player.GetAll()
    local health_calc = ((100 * 2) * #PlayerNames) * bossData.BossHealthMultiplier
    local BossCharacters_local = Character(BVP_CONFIG.BossSpawnLocations[math.random(#BVP_CONFIG.BossSpawnLocations)], Rotator(), BossAsset)
    BossCharacters_local:SetMovementEnabled(false)
    BossCharacters_local:SetTeam(1)
    BossCharacters_local:SetFallDamageTaken(0)
    BossCharacters_local:SetPunchDamage(999)
    BossCharacters_local:SetSpeedMultiplier(BVP_CONFIG.GlobalSpeedMultiplier * bossData.BossSpeedMultiplier)
    BossCharacters_local:SetMaxHealth(health_calc)
    BossCharacters_local:SetCanPickupPickables(false)
    BossCharacters_local:SetHealth(health_calc)
    BossCharacters_local:Subscribe("Death", function(character, last_damage_taken, last_bone_damaged, damage_type_reason, hit_from_direction, player)
        if player ~= nil then
            player:UnPossess()
        end
    end)
    return BossCharacters_local
end

-- Load all JSON Bosses inside BossList folder
function BossLoad()
    Package.Log("Loading Bosses...")
    local BossList = Package.GetFiles("Server/BossList", ".json")
    local Bosses = {}
    for key,value in pairs(BossList)
    do
        local cfgFile = File("Packages/" .. Package.GetPath() .. "/" .. value)
        local cfgJson = JSON.parse(cfgFile:Read(cfgFile:Size()))
        table.insert(Bosses, cfgJson)
    end
    if #Bosses <= 0 then
        Package.Error("There is no boss! please check your BossList folder")
    end
    Server.SetValue("BVP_BossList", Bosses)
    Package.Log("Loading Bosses COMPLETE!")
end

Events.Subscribe("BVP_BossAbilityExecute_Jump", function(player)
    local bossJson = Server.GetValue("BVP_BossData")
    local abilityImage = bossJson.BossImages["AbilityJumpImage"]
    if abilityImage["Image"] ~= "" and abilityImage["Image"] ~= nil and abilityImage["Time"] > 0 then
        Events.BroadcastRemote("BVP_Client_HUD_Image", abilityImage["Image"], abilityImage["Time"])
    end
    if #bossJson.BossSoundAbilities["Jump"] > 0 then
        Events.BroadcastRemote("BVP_Client_PlayEffect", bossJson.BossSoundAbilities["Jump"][math.random(#bossJson.BossSoundAbilities["Jump"])])
    end
    Package.Call("boss-vs-players", bossJson.BossAbilities["JumpFunction"], player)
end)

Events.Subscribe("BVP_BossAbilityExecute_Rage", function(player)
    local bossJson = Server.GetValue("BVP_BossData")
    local abilityImage = bossJson.BossImages["AbilityRageImage"]
    if abilityImage["Image"] ~= "" and abilityImage["Image"] ~= nil and abilityImage["Time"] > 0 then
        Events.BroadcastRemote("BVP_Client_HUD_Image", abilityImage["Image"], abilityImage["Time"])
    end
    if #bossJson.BossSoundAbilities["Rage"] > 0 then
        Events.BroadcastRemote("BVP_Client_PlayEffect", bossJson.BossSoundAbilities["Rage"][math.random(#bossJson.BossSoundAbilities["Rage"])])
    end
    Package.Call("boss-vs-players", bossJson.BossAbilities["RageFunction"], player)
end)

Events.Subscribe("BVP_BossAbilityExecute_Special", function(player)
    local bossJson = Server.GetValue("BVP_BossData")
    local abilityImage = bossJson.BossImages["AbilitySpecialImage"]
    if abilityImage["Image"] ~= "" and abilityImage["Image"] ~= nil and abilityImage["Time"] > 0 then
        Events.BroadcastRemote("BVP_Client_HUD_Image", abilityImage["Image"], abilityImage["Time"])
    end
    if #bossJson.BossSoundAbilities["Special"] > 0 then
        Events.BroadcastRemote("BVP_Client_PlayEffect", bossJson.BossSoundAbilities["Special"][math.random(#bossJson.BossSoundAbilities["Special"])])
    end
    Package.Call("boss-vs-players", bossJson.BossAbilities["SpecialFunction"], player)
end)