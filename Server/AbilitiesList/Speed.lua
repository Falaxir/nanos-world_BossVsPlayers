function Ability_Speed(player)
    local character = player:GetControlledCharacter()
    if character ~= nil then
        local old_speed = character:GetSpeedMultiplier()
        character:SetSpeedMultiplier(old_speed * 1.5)
        Timer:SetTimeout(6000, function(chara, ospeed)
            if (chara:IsValid()) then
                chara:SetSpeedMultiplier(ospeed)
            end
            return false
        end, {character, old_speed})
    end
end

Package:Export("Ability_Speed", Ability_Speed)