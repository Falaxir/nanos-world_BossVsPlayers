function Ability_Bonk(player)
    local playersList = NanosWorld:GetPlayers()
    for key,value in pairs(playersList)
    do
        local chara = value:GetControlledCharacter()
        if chara ~= nil then
            if chara:GetTeam() ~= 1 then
                chara:SetMovementEnabled(false)
            end
        end
    end
    Timer:SetTimeout(8000, function()
        local playersList = NanosWorld:GetPlayers()
        for key,value in pairs(playersList)
        do
            local chara = value:GetControlledCharacter()
            if chara ~= nil then
                if chara:GetTeam() ~= 1 then
                    chara:SetMovementEnabled(true)
                end
            end
        end
    end)
end

Package:Export("Ability_Bonk", Ability_Bonk)