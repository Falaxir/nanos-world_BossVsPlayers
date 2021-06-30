function Weapon_BaguettePewPew(player)
    if player:GetControlledCharacter() == nil then return end
    my_weap = NanosWorldWeapons.AR4(Vector(-2250, 9153, 192), Rotator(0, 90, 90))
    my_weap.BaseDamage = 0
    my_weap:SetAmmoClip(100)
    my_weap:SetAmmoBag(0)

    my_weap:Subscribe("Fire", function(self, shooter)
        if self:GetAmmoClip() <= 0 then
            self:Destroy()
        end
        local control_rotation = shooter:GetControlRotation()
        local forward_vector = control_rotation:GetForwardVector()
        local spawn_location = shooter:GetLocation() + Vector(0, 0, 40) + forward_vector * Vector(200)

        local prop = Prop(spawn_location, control_rotation, "BossVsPlayers::bread", 1)
        prop:SetCollision(0)
        prop:SetScale(Vector(3, 3, 3))
        prop:AddImpulse(forward_vector * Vector(3000))
        Timer:SetTimeout(4000, function(propy)
            if (propy ~= nil) then
                propy:Destroy()
            end
            return false
        end, {prop})
    end)
    player:GetControlledCharacter():PickUp(my_weap)
end

Package:Export("Weapon_BaguettePewPew", Weapon_BaguettePewPew)