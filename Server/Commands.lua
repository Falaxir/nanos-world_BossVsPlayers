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

function PlayerIsAdmin(sender)
    for key,value in pairs(BVP_CONFIG.AdministratorsId)
    do
        if value == sender:GetAccountID() then
            return true
        end
    end
    return false
end

Server:Subscribe("Chat", function(text, sender)
    if text == "/kill" then
        local playerChar = sender:GetControlledCharacter()
        if playerChar ~= nil then
            if playerChar:IsValid() then
                playerChar:SetHealth(0)
                sender:UnPossess()
            end
        end
    end
    if text == "/forceWait" then
        if PlayerIsAdmin(sender) then
            local waiting = Server:GetValue("BVP_ForceWait")
            if waiting then
                Events:CallRemote("BVP_Client_SendPrivateChatMessage", sender, {"CHAT_CMD_ForceWaitDisable", nil})
                Server:SetValue("BVP_ForceWait", false)
            else
                Events:CallRemote("BVP_Client_SendPrivateChatMessage", sender, {"CHAT_CMD_ForceWaitEnable", nil})
                Server:SetValue("BVP_ForceWait", true)
            end
        else
            Events:CallRemote("BVP_Client_SendPrivateChatMessage", sender, {"CHAT_PermissionDenied", nil})
        end
    end
    if text == "/forceBoss" then
        if PlayerIsAdmin(sender) then
            Events:CallRemote("BVP_Client_SendPrivateChatMessage", sender, {"CHAT_CMD_ForceBoss", nil})
            sender:SetValue("BVP_BossPoints", 99)
            Package:SetPersistentData("BVP_BossPoints", 99)
        else
            Events:CallRemote("BVP_Client_SendPrivateChatMessage", sender, {"CHAT_PermissionDenied", nil})
        end
    end
    if text == "/forceEnd" then
        if PlayerIsAdmin(sender) then
            Events:CallRemote("BVP_Client_SendPrivateChatMessage", sender, {"CHAT_CMD_ForceEnd", nil})
            Server:SetValue("BVP_AliveTeammatesPlayers", 0)
        else
            Events:CallRemote("BVP_Client_SendPrivateChatMessage", sender, {"CHAT_PermissionDenied", nil})
        end
    end
end)