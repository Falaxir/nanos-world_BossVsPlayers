function Ability_Uber(player)
    local playersChar = player:GetControlledCharacter()
    if playersChar ~= nil then
        playersChar:SetInvulnerable(true)
        playersChar:SetDefaultMaterial(MaterialType.Masked)
        playersChar:SetMaterialColorParameter("Tint", Color(0, 0, 1))
        Timer:SetTimeout(6000, function(chara)
            if (chara:IsValid()) then
                chara:SetInvulnerable(false)
                chara:SetDefaultMaterial(MaterialType.None)
            end
            return false
        end, {playersChar})
    end
end

Package:Export("Ability_Uber", Ability_Uber)