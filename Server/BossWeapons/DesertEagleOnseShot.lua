function Weapon_DesertEagleOnseShot(player)
    if player:GetControlledCharacter() == nil then return end
    my_weap = NanosWorldWeapons.DesertEagle(Vector(), Rotator())
    my_weap:SetAmmoSettings(5, 0)
    my_weap:SetDamage(100)
    my_weap:Subscribe("Drop", function(pickable, character, was_triggered_by_player)
        if pickable ~= nil then
            pickable:Destroy()
        end
    end)
    my_weap:Subscribe("Fire", function(self, shooter)
        if self:GetAmmoClip() <= 0 then
            self:Destroy()
        end
    end)
    player:GetControlledCharacter():PickUp(my_weap)
end

Package:Export("Weapon_DesertEagleOnseShot", Weapon_DesertEagleOnseShot)