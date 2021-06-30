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

Client:Subscribe("KeyUp", function(key_name)
    if (key_name == "E") then
        Client_Rage_Do()
    end
    if (key_name == "F") then
        Client_Jump_Do()
    end
    if (key_name == "G") then
        Client_Special_Do()
    end
    if (key_name == "F4") then
        Client_OpenOptions()
    end
end)

optionsOpen = false

function Client_OpenOptions()
    if not optionsOpen then
        local localPlayer = NanosWorld:GetLocalPlayer()
        local points = localPlayer:GetValue("BVP_BossPoints")
        local VolumeMusic = localPlayer:GetValue("BVP_VolumeMusic")
        local VolumeEffects = localPlayer:GetValue("BVP_VolumeEffects")
        OptionsHUD:CallEvent("BVP_OptionsDisplayLanguage", {JSON.stringify(LANGUAGES_LIST)})
        OptionsHUD:CallEvent("BVP_OptionsSetBossPoints", {points})
        OptionsHUD:CallEvent("BVP_OptionsSetVolumeMusic", {VolumeMusic})
        OptionsHUD:CallEvent("BVP_OptionsSetVolumeEffects", {VolumeEffects})
        Client:SetMouseEnabled(true)
        OptionsHUD:SetVisible(true)
        optionsOpen = true
    else
        OptionsHUD:SetVisible(false)
        Client:SetMouseEnabled(false)
        optionsOpen = false
    end
end

Events:Subscribe("BVP_Client_GetPermanentData", function()
    local player = NanosWorld:GetLocalPlayer()
    local persistentData = Package:GetPersistentData()
    local foundBVP_BossPoints = false
    local foundBVP_VolumeMusic = false
    local foundBVP_VolumeEffects = false
    local foundBVP_Language = false
    for key,value in pairs(persistentData)
    do
        if key == "BVP_BossPoints" then
            player:SetValue("BVP_BossPoints", value)
            foundBVP_BossPoints = true
            Events:CallRemote("BVP_UpdateThisPlayerBossPoints", {})
        end
        if key == "BVP_VolumeMusic" then
            player:SetValue("BVP_VolumeMusic", value)
            foundBVP_VolumeMusic = true
        end
        if key == "BVP_VolumeEffects" then
            player:SetValue("BVP_VolumeEffects", value)
            foundBVP_VolumeEffects = true
        end
        if key == "BVP_Language" then
            player:SetValue("BVP_Language", value)
            foundBVP_Language = true
        end
    end
    if not foundBVP_BossPoints or player:GetValue("BVP_BossPoints") == nil then
        player:SetValue("BVP_BossPoints", 0)
        Events:CallRemote("BVP_UpdateThisPlayerBossPoints", {})
    end
    if not foundBVP_VolumeMusic or player:GetValue("BVP_VolumeMusic") == nil  then
        player:SetValue("BVP_VolumeMusic", 40)
    end
    if not foundBVP_VolumeEffects or player:GetValue("BVP_VolumeEffects") == nil  then
        player:SetValue("BVP_VolumeEffects", 50)
    end
    if not foundBVP_Language or player:GetValue("BVP_Language") == nil  then
        for key,value in pairs(LANGUAGES_LIST)
        do
            if value.Language == "en" then
                player:SetValue("BVP_Language", value)
                break
            end
        end
    end
end)