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

Server:SetValue("BVP_TimeLimit", BVP_CONFIG.RoundTimeLimitSeconds)

Timer:SetTimeout(1000, function()
    local state = Server:GetValue("BVP_GameState")
    local playerNames = NanosWorld:GetPlayers()
    local timer_tick = Server:GetValue("BVP_TimeLimit")
    if timer_tick == 60 or timer_tick == 30 or timer_tick <= 10 then
        if state >= 1 then
            Events:BroadcastRemote("BVP_Client_PlayAnnouncementSound", {state, timer_tick})
        end
    end
    if state == 0 then
        if Server:GetValue("BVP_ForceWait") then
            Events:BroadcastRemote("BVP_Client_HUD_Advert_important", {"HUD_Top_WaitBeginning", nil, nil})
            Events:BroadcastRemote("BVP_Client_HUD_Advert_top_one", {"HUD_Top_ForceWait", nil, nil})
            return true
        end
        if #playerNames < 2 then
            Events:BroadcastRemote("BVP_Client_HUD_Advert_important", {"HUD_Top_WaitBeginning", nil, nil})
            Events:BroadcastRemote("BVP_Client_HUD_Advert_top_one", {"HUD_Top_WaitPlayers", nil, nil})
            return true
        end
        Events:Call("BVP_StartGame", {})
    end
    if state == 2 then
        if Server:GetValue("BVP_AliveBossPlayers") <= 0 then
            Events:Call("BVP_EndGame", {2})
            return true
        end
        if Server:GetValue("BVP_AliveTeammatesPlayers") <= 0 then
            Events:Call("BVP_EndGame", {1})
            return true
        end
    end
    if state > 0 then
        Events:BroadcastRemote("BVP_Client_HUD_Timer", {timer_tick})
        if timer_tick <= 0 and state == 2 then
            Events:Call("BVP_EndGame", {0})
            return true
        end
        if timer_tick <= 0 then return true end
        local boss = Server:GetValue("BVP_BossPlayer")
        if boss ~= nil then
            local chara = boss:GetControlledCharacter()
            if chara ~= nil then
                Events:BroadcastRemote("BVP_Client_HUD_Boss_Health", {chara})
            end
        end
        Events:BroadcastRemote("BVP_Client_HUD_Players", {"HUD_Status_PlayersLeft", {__PLAYERS__ = Server:GetValue("BVP_AliveTeammatesPlayers")}})
        Server:SetValue("BVP_TimeLimit", timer_tick - 1)
    end
    return true
end)