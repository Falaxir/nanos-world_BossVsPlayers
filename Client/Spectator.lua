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

function SpectatorSwitch()
    local players = Player.GetAll()
    local lastSpectator = Client.GetValue("BVP_LastSpectator")
    if lastSpectator == nil then
        lastSpectator = 0
    end
    lastSpectator = lastSpectator + 1
    if lastSpectator > #players then
        Client.SetValue("BVP_LastSpectator", 0)
        Client.Unspectate()
        Events.Call("BVP_Client_HUD_Advert_important", "HUD_Top_Spectator", nil, nil)
        return
    end
    Client.SetValue("BVP_LastSpectator", lastSpectator)
    Client.Spectate(players[lastSpectator])
    --Events.Call("BVP_Client_HUD_Advert_important", "Tu regarde: " .. players[lastSpectator]:GetName(), "You are watching: " .. players[lastSpectator]:GetName(), nil)
    Events.Call("BVP_Client_HUD_Advert_important", "HUD_Top_SpectatorSpectate", {__PLAYERNAME__ = players[lastSpectator].GetName()}, nil)
end

Client.Subscribe("MouseUp", function(key_name, mouse_x, mouse_y)
    if (key_name == "RightMouseButton") then
        local player = Client.GetLocalPlayer()
        if player:GetControlledCharacter() == nil then
            SpectatorSwitch()
        end
    end
end)