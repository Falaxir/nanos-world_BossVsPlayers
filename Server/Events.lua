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

-- Check the character who has been unpossed, is it the boss or a player ? Play a sound in function of the result and update HUD
Events.Subscribe("CharacterCheckTeam", function(character)
    if character == nil then return end
    local player = character:GetPlayer()
    if character:GetTeam() == 2 then
        local BossData = Server.GetValue("BVP_BossData")
        local teammates = Server.GetValue("BVP_AliveTeammatesPlayers")
        Server.SetValue("BVP_AliveTeammatesPlayers", teammates - 1)
        if BossData ~= nil and Server.GetValue("BVP_GameState") == 2 then
            if teammates - 1 == 1 and #BossData.BossSoundLastMan > 0 then
                Events.BroadcastRemote("BVP_Client_PlayEffect", BossData.BossSoundLastMan[math.random(#BossData.BossSoundLastMan)])
            else
                if #BossData.BossSoundPlayerDeath > 0 then
                    Events.BroadcastRemote("BVP_Client_PlayEffect", BossData.BossSoundPlayerDeath[math.random(#BossData.BossSoundPlayerDeath)])
                end
            end
        end
    end
    if character:GetTeam() == 1 then
        local BossData = Server.GetValue("BVP_BossData")
        Server.SetValue("BVP_AliveBossPlayers", 0)
        if Server.GetValue("BVP_GameState") == 2 then
            if BossData ~= nil and #BossData.BossSoundDeath > 0 and Server.GetValue("BVP_GameState") == 2 then
                Events.BroadcastRemote("BVP_Client_PlayEffect", BossData.BossSoundDeath[math.random(#BossData.BossSoundDeath)])
            end
        end
    end
    if player ~= nil then
        Events.Call("BVP_GoSpectator", player)
        player:UnPossess()
    end
    Timer.SetTimeout(function(chara)
        if (chara:IsValid()) then
            chara:Destroy()
        end
        return false
    end, 4000, character)
end)

-- Called when for some reason, the language has not been defined and get from server
Events.Subscribe("BVP_GetLanguageOnNill", function(player)
    Events.CallRemote("BVP_Client_GetLanguages", player, LANGUAGES_LIST)
end)

-- Update this player boss point
Events.Subscribe("BVP_UpdateThisPlayerBossPoints", function(player)
    local playerId = player:GetID()
    for key,value in pairs(Player.GetAll())
    do
        if value:GetID() == playerId then
            value:SetValue("BVP_BossPoints", player:GetValue("BVP_BossPoints"))
        end
    end
end)

-- Called when player goes in spectator mode
Events.Subscribe("BVP_GoSpectator", function(player)
    Events.CallRemote("BVP_Client_HUD_Advert_important", player, "HUD_Top_Spectator", nil, nil)
    Events.CallRemote("BVP_Client_HUD_Advert_top_one", player, "HUD_Top_SpectatorChange", nil, nil)
end)

-- Called when game is ending
Events.Subscribe("BVP_EndGame", function(case)
    Server.SetValue("BVP_GameState", 3)
    Events.BroadcastRemote("BVP_Client_ChangeGameState", 3)
    Events.BroadcastRemote("BVP_Client_EndGame", case)
    for key,value in pairs(Player.GetAll())
    do
        local charaTest = value:GetControlledCharacter()
        local bossPoints = value:GetValue("BVP_BossPoints")
        if charaTest ~= nil and bossPoints == nil then
            bossPoints = 0
        end
        if charaTest ~= nil then
            if charaTest:GetTeam() ~= 1 then
                value:SetValue("BVP_BossPoints", bossPoints + 1)
            else
                value:SetValue("BVP_BossPoints", 0)
            end
        end
    end
    local BossData = Server.GetValue("BVP_BossData")
    if BossData ~= nil then
        if case == 1 and #BossData.BossSoundWin > 0 then
            Events.BroadcastRemote("BVP_Client_PlayEffect", BossData.BossSoundWin[math.random(#BossData.BossSoundWin)])
        end
        if case == 2 and #BossData.BossSoundDeath > 0 then
            Events.BroadcastRemote("BVP_Client_PlayEffect", BossData.BossSoundDeath[math.random(#BossData.BossSoundDeath)])
        end
    end
    Server.SetValue("BVP_AliveTeammatesPlayers", 0)
    Server.SetValue("BVP_AliveBossPlayers", 0)
    Server.SetValue("BVP_BossData", nil)
    Server.SetValue("BVP_BossPlayer", nil)
    Server.SetValue("BVP_TimeLimit", BVP_CONFIG.RoundPrepareTimeSeconds)
    Timer.SetTimeout(function()
        for key,value in pairs(Player.GetAll())
        do
            local chara = value:GetControlledCharacter()
            if chara ~= nil then
                value:UnPossess()
                chara:Destroy()
            end
        end
        Server.SetValue("BVP_GameState", 0)
        Events.BroadcastRemote("BVP_Client_ChangeGameState", 0)
        Server.SetValue("BVP_TimeLimit", 0)
        return false
    end, (1 + BVP_CONFIG.RoundPrepareTimeSeconds) * 1000)
end)

-- Called when game is starting
Events.Subscribe("BVP_StartGame", function()
    if BVP_CONFIG.TimeModulePackageEnabled == "true" then
        Events.Call("TimeSetToNoon")
    end
    Server.SetValue("BVP_GameState", 1)
    Events.BroadcastRemote("BVP_Client_ChangeGameState", 1)
    local PlayerNames = Player.GetAll()
    Server.SetValue("BVP_AliveTeammatesPlayers", #PlayerNames - 1)
    ChooseSpawnRandomBoss()
    SpawnPlayers()
    Events.BroadcastRemote("BVP_Client_StartGame", Server.GetValue("BVP_BossData"), Server.GetValue("BVP_BossPlayer"))
    Server.SetValue("BVP_TimeLimit", BVP_CONFIG.RoundPrepareTimeSeconds)
    Timer.SetTimeout(function()
        for key,value in pairs(Player.GetAll())
        do
            if value:GetControlledCharacter() ~= nil then
                value:GetControlledCharacter():SetMovementEnabled(true)
            end
        end
        Server.SetValue("BVP_TimeLimit", BVP_CONFIG.RoundTimeLimitSeconds)
        Server.SetValue("BVP_GameState", 2)
        Events.BroadcastRemote("BVP_Client_ChangeGameState", 2)
        return false
    end, (1 + BVP_CONFIG.RoundPrepareTimeSeconds) * 1000)
end)