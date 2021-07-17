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

Events.Subscribe("BVP_Client_Special_Calculation", function(BossData)
    if Client.GetLocalPlayer():GetControlledCharacter() == nil then return end
    if Client.GetLocalPlayer():GetControlledCharacter():GetTeam() ~= 1 then return end
    local playerChara = Client.GetLocalPlayer():GetControlledCharacter()
    if (playerChara ~= nil) then
        local players = Player.GetAll()
        local result = math.ceil((#players * 0.25))
        if BossData.BossSpecialMultiplier ~= nil then
            result = result * BossData.BossSpecialMultiplier
        end
        Client_Special_Check(result)
    end
end)

function Client_Special_Check(inc)
    Client.SetValue("BVP_SpecialReady", 0)
    Timer.SetInterval(function(increm)
        if Client.GetValue("BVP_GameState") > 2 then return false end
        local old = Client.GetValue("BVP_SpecialReady")
        local newValue = old + increm
        if newValue > 100 then
            Client.SetValue("BVP_SpecialReady", 100)
        else
            Client.SetValue("BVP_SpecialReady", newValue)
        end
        if old + increm >= 100 then
            local ChoosenLanguage = Client.GetLocalPlayer():GetValue("BVP_Language")
            if ChoosenLanguage == nil then
                Events.CallRemote("BVP_GetLanguageOnNill")
                return
            end
            MainHUD:CallEvent("BVP_HUD_Boss_Special", ChoosenLanguage["HUD_Ability_Special_Ready"])
            return true
        end
        local ChoosenLanguage = Client.GetLocalPlayer():GetValue("BVP_Language")
        if ChoosenLanguage == nil then
            Events.CallRemote("BVP_GetLanguageOnNill")
            return
        end
        local text = ChoosenLanguage["HUD_Ability_Special_Loading"]
        text = string.gsub(text, "%__PERCENTAGE__", tostring(old + increm))
        MainHUD:CallEvent("BVP_HUD_Boss_Special", text)
    end, 1000, inc)
end

function Client_Special_Do()
    local SpecialLevel = Client.GetValue("BVP_SpecialReady")
    local playerChara = Client.GetLocalPlayer():GetControlledCharacter()
    if playerChara ~= nil then
        if playerChara:GetTeam() ~= 1 then
            return
        end
    else
        return
    end
    if SpecialLevel >= 100 then
        Client.SetValue("BVP_SpecialReady", 0)
        Events.CallRemote("BVP_BossAbilityExecute_Special", Client.GetLocalPlayer())
        local ChoosenLanguage = Client.GetLocalPlayer():GetValue("BVP_Language")
        if ChoosenLanguage == nil then
            Events.CallRemote("BVP_GetLanguageOnNill")
            return
        end
        local text = ChoosenLanguage["HUD_Ability_Special_Loading"]
        text = string.gsub(text, "%__PERCENTAGE__", "0")
        MainHUD:CallEvent("BVP_HUD_Boss_Special", text)
    end
end