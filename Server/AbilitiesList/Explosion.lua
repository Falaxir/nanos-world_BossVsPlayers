function checkInsideCircle(cx, cy, cz, x, y, z)
    local x1 =((x - cx) * (x - cx))
    local y1 = ((y - cy) * (y - cy))
    local z1 = ((z - cz) * (z - cz))
    return (x1 + y1 + z1)
end

function Ability_Explosion(player)
    local chara = player:GetControlledCharacter()
    if chara ~= nil then
        chara:SetMovementEnabled(false)
        local sphere_trigger = Trigger(chara:GetLocation(), Rotator(), Vector(2000), TriggerType.Sphere, true, Color(1, 0, 0))
        Timer:SetTimeout(3000, function(charater, trigger)
            local bossLocation = charater:GetLocation()
            Events:BroadcastRemote("BVP_Client_PlayEffect3D", {"NanosWorld::A_Explosion_Large", bossLocation})
            trigger:Destroy()
            local PlayerNames = NanosWorld:GetPlayers()
            for key,value in pairs(PlayerNames)
            do
                local p_chara = value:GetControlledCharacter()
                if p_chara ~= nil then
                    if p_chara:GetTeam() ~= 1 then
                        local playerLocation = p_chara:GetLocation()
                        local result = checkInsideCircle(bossLocation.X, bossLocation.Y, bossLocation.Z, playerLocation.X, playerLocation.Y, playerLocation.Z)
                        if (result <= (2000 * 2000)) then
                            p_chara:SetHealth(0)
                            value:UnPossess()
                        end
                    end
                end
            end
            charater:SetMovementEnabled(true)
            return false
        end, {chara, sphere_trigger})
    end
end

Package:Export("Ability_Explosion", Ability_Explosion)