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

local BVP_BGM_isPlaying = false

Timer.SetInterval(function()
    local state = Client.GetValue("BVP_GameState")
    local musicPlaying = Client.GetValue("BVP_Client_BGM")
    local volume = Client.GetLocalPlayer():GetValue("BVP_VolumeMusic")
    if state == 2 then
        if musicPlaying ~= nil then
            if musicPlaying:IsValid() then
                musicPlaying:SetVolume(volume / 100)
                if not musicPlaying:IsPlaying() then
                    musicPlaying:Play()
                end
            end
        end
    end
    if state == 3 then
        if musicPlaying ~= nil then
            if musicPlaying:IsValid() then
                musicPlaying:Stop()
                musicPlaying:Destroy()
                Client.SetValue("BVP_Client_BGM", nil)
            end
        end
    end
    return true
end, 1000)