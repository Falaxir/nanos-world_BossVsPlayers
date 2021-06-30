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

function SpawnNewAmmoRessuply(location)
    local ressuplyTrigger = Trigger(location, Rotator(), Vector(200), TriggerType.Sphere, true, Color(0, 1, 0))
    ressuplyTrigger:SetValue("CanResupply", true, true)
    ressuplyTrigger:Subscribe("BeginOverlap", function(trigger, actor_triggering)
        if NanosWorld:IsA(actor_triggering, Character) then
            if actor_triggering:GetTeam() == 1 then return end
            if trigger:GetValue("CanResupply") then
                local entityChar = actor_triggering:GetPicked()
                if entityChar ~= nil then
                    if NanosWorld:IsA(entityChar, Weapon) then
                        if entityChar:GetAmmoBag() >= 400 then return end
                        entityChar:SetAmmoBag(400)
                        trigger:SetValue("CanResupply", false)
                        trigger:SetVisibility(false)
                        local playerChar = actor_triggering:GetPlayer()
                        if playerChar ~= nil then
                            Events:CallRemote("BVP_Client_SendPrivateChatMessage", playerChar, {"CHAT_AmmoResupplied", nil})
                        end
                        Timer:SetTimeout(30000, function(triggy)
                            triggy:SetValue("CanResupply", true)
                            triggy:SetVisibility(true)
                            return false
                        end, {trigger})
                    end
                end
            end
        end
    end)
end