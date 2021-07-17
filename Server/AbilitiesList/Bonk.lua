function Ability_Bonk(player)
    local playersList = Player.GetAll()
    for key,value in pairs(playersList)
    do
        local chara = value:GetControlledCharacter()
        if chara ~= nil then
            if chara:GetTeam() ~= 1 then
                chara:SetMovementEnabled(false)
            end
        end
    end
    Timer.SetTimeout(function()
        local playersList = Player.GetAll()
        for key,value in pairs(playersList)
        do
            local chara = value:GetControlledCharacter()
            if chara ~= nil then
                if chara:GetTeam() ~= 1 then
                    chara:SetMovementEnabled(true)
                end
            end
        end
    end, 8000)
end

Package.Export("Ability_Bonk", Ability_Bonk)