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
        lastSpectator = -1
    end
    lastSpectator = lastSpectator + 1
    for i = lastSpectator, #players do
        if players[i] ~= nil then
            if players[i]:GetControlledCharacter() ~= nil then
                lastSpectator = i
                Client.Unspectate()
                Client.SetValue("BVP_LastSpectator", lastSpectator)
                Client.Spectate(players[lastSpectator])
                Events.Call("BVP_Client_HUD_Advert_important", "HUD_Top_SpectatorSpectate", {__PLAYERNAME__ = players[lastSpectator]:GetName()}, nil)
                return
            end
        end
    end
    Client.SetValue("BVP_LastSpectator", -1)
    Client.Unspectate()
    Events.Call("BVP_Client_HUD_Advert_important", "HUD_Top_Spectator", nil, nil)
end

Client.Subscribe("MouseUp", function(key_name, mouse_x, mouse_y)
    if (key_name == "RightMouseButton") then
        local player = Client.GetLocalPlayer()
        if player:GetControlledCharacter() == nil then
            SpectatorSwitch()
        end
    end
end)