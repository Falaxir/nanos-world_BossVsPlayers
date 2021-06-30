function Ability_NukeRocketLauncher(player)
    if player:GetControlledCharacter() == nil then return end
    my_weap = NanosWorldWeapons.DesertEagle(Vector(), Rotator())
    my_weap:SetAmmoSettings(1, 0)
    my_weap:SetDamage(0)
    my_weap:Subscribe("Drop", function(pickable, character, was_triggered_by_player)
        if pickable ~= nil then
            pickable:Destroy()
        end
    end)
    my_weap:Subscribe("Fire", function(self, shooter)
        if self:GetAmmoClip() <= 0 then
            self:Destroy()
        end
        local control_rotation = shooter:GetControlRotation()
        local forward_vector = control_rotation:GetForwardVector()
        local spawn_location = shooter:GetLocation() + Vector(0, 0, 40) + forward_vector * Vector(200)
        local prop = Prop(spawn_location, control_rotation, "BossVsPlayers::bread", 1)
        local sphere_trigger = Trigger(prop:GetLocation(), Rotator(), Vector(1300), TriggerType.Sphere, true, Color(1, 0, 0))
        sphere_trigger:AttachTo(prop)
        prop:SetValue("TriggerAttached", sphere_trigger)
        prop:SetCollision(0)
        prop:SetScale(Vector(3, 3, 3))
        prop:AddImpulse(forward_vector * Vector(5000))
        prop:Subscribe("Hit", function(self, intensity)
            if (self ~= nil) then
                local propLocation = self:GetLocation()
                Events:BroadcastRemote("BVP_Client_PlayEffect3D", {"NanosWorld::A_Explosion_Large", bossLocation})
                local theTrigger = self:GetValue("TriggerAttached")
                if theTrigger ~= nil then
                    theTrigger:Destroy()
                end
                local PlayerNames = NanosWorld:GetPlayers()
                for key,value in pairs(PlayerNames)
                do
                    local p_chara = value:GetControlledCharacter()
                    if p_chara ~= nil then
                        if p_chara:GetTeam() ~= 1 then
                            local playerLocation = p_chara:GetLocation()
                            local result = checkInsideCircle(propLocation.X, propLocation.Y, propLocation.Z, playerLocation.X, playerLocation.Y, playerLocation.Z)
                            if (result <= (1300 * 1300)) then
                                p_chara:SetHealth(0)
                                value:UnPossess()
                            end
                        end
                    end
                end
                if self:IsValid() then
                    self:Destroy()
                end
            end
        end)
    end)
    my_weap:SetScale(Vector(2, 2, 2))
    player:GetControlledCharacter():PickUp(my_weap)
end

Package:Export("Ability_NukeRocketLauncher", Ability_NukeRocketLauncher)