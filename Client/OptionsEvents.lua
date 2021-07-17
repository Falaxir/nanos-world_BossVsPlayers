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

OptionsHUD.Subscribe(OptionsHUD, "BVP_Client_ResetBossPoints", function(newValue)
    Client.GetLocalPlayer():SetValue("BVP_BossPoints", newValue)
    Package.SetPersistentData("BVP_BossPoints", newValue)
    Events.CallRemote("BVP_UpdateThisPlayerBossPoints")
    Client.SendChatMessage("[BVP] BossPoints have been reset!")
end)

OptionsHUD.Subscribe(OptionsHUD, "BVP_Client_ChangeVolumeMusic", function(newValue)
    Client.GetLocalPlayer():SetValue("BVP_VolumeMusic", newValue)
    Package.SetPersistentData("BVP_VolumeMusic", newValue)
end)

OptionsHUD.Subscribe(OptionsHUD, "BVP_Client_ChangeVolumeEffects", function(newValue)
    Client.GetLocalPlayer():SetValue("BVP_VolumeEffects", newValue)
    Package.SetPersistentData("BVP_VolumeEffects", newValue)
end)

OptionsHUD.Subscribe(OptionsHUD, "BVP_Client_ChangeLanguage", function(newValue)
    for key,value in pairs(LANGUAGES_LIST)
    do
        if value.Language == newValue then
            Events.Call("BVP_Client_SendPrivateChatMessage", "CHAT_LanguageChanged", {__LANGUAGE__ = value.Language})
            Client.GetLocalPlayer():SetValue("BVP_Language", value)
            Package.SetPersistentData("BVP_Language", value)
            return
        end
    end
    Package.Log("Lang unknow")
end)