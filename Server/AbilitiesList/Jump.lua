function Ability_Jump(player)
    local chara = player:GetControlledCharacter()
    if chara ~= nil then
        local control_rotation = chara:GetControlRotation()
        local forward_vector = control_rotation:GetForwardVector()

        chara:AddImpulse(forward_vector * Vector(219999))
    end
end

Package:Export("Ability_Jump", Ability_Jump)