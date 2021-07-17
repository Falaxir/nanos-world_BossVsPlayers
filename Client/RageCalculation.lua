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

Events.Subscribe("BVP_Client_Rage_Calculation", function(BossData)
    if Client.GetLocalPlayer():GetControlledCharacter() == nil then return end
    if Client.GetLocalPlayer():GetControlledCharacter():GetTeam() ~= 1 then return end
    local playerChara = Client.GetLocalPlayer():GetControlledCharacter()
    MainHUD:CallEvent("BVP_HUD_Boss_Container_Display", 0)
    if (playerChara ~= nil) then
        MainHUD:CallEvent("BVP_HUD_Boss_Container_Display", 1)
        local boss_health = playerChara:GetMaxHealth()
        local players = Player.GetAll()
        playerChara:Subscribe("TakeDamage", function(character, damage, bone, type, from_direction, player)
            local result = math.ceil((damage * 0.2) + (#players))
            if BossData.BossRageMultiplier ~= nil then
                result = result * BossData.BossRageMultiplier
            end
            Client_Rage_Check(result)
        end)
    end
end)

function Client_Rage_Check(result)
    local RageLevel = Client.GetValue("BVP_RageReady")
    local newRage = RageLevel + result
    if newRage > 100 then
        Client.SetValue("BVP_RageReady", 100)
    else
        Client.SetValue("BVP_RageReady", newRage)
    end
    if newRage >= 100 then
        local ChoosenLanguage = Client.GetLocalPlayer():GetValue("BVP_Language")
        if ChoosenLanguage == nil then
            Events.CallRemote("BVP_GetLanguageOnNill")
            return
        end
        MainHUD:CallEvent("BVP_HUD_Boss_Rage", ChoosenLanguage["HUD_Ability_Rage_Ready"])
        return
    end
    local ChoosenLanguage = Client.GetLocalPlayer():GetValue("BVP_Language")
    if ChoosenLanguage == nil then
        Events.CallRemote("BVP_GetLanguageOnNill")
        return
    end
    local text = ChoosenLanguage["HUD_Ability_Rage_Loading"]
    text = string.gsub(text, "%__PERCENTAGE__", tostring(newRage))
    MainHUD:CallEvent("BVP_HUD_Boss_Rage", text)
end

function Client_Rage_Do()
    local RageLevel = Client.GetValue("BVP_RageReady")
    local playerChara = Client.GetLocalPlayer():GetControlledCharacter()
    if playerChara ~= nil then
        if playerChara:GetTeam() ~= 1 then
            return
        end
    else
        return
    end
    if RageLevel == nil then return end
    if RageLevel >= 100 then
        Client.SetValue("BVP_RageReady", 0)
        Events.CallRemote("BVP_BossAbilityExecute_Rage", Client.GetLocalPlayer())
        local ChoosenLanguage = Client.GetLocalPlayer():GetValue("BVP_Language")
        if ChoosenLanguage == nil then
            Events.CallRemote("BVP_GetLanguageOnNill")
            return
        end
        local text = ChoosenLanguage["HUD_Ability_Rage_Loading"]
        text = string.gsub(text, "%__PERCENTAGE__", "0")
        MainHUD:CallEvent("BVP_HUD_Boss_Rage", text)
    end
end