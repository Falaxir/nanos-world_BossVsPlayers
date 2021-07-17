function BossModel_AgentSmith(player, BossData)
    -- Minimum Required
    local BossCharacter = BossCreateStartRound(BossData, "boss-vs-players-assets::AgentSmith")
    player:Possess(BossCharacter)
    -- End minimum required
end

Package.Export("BossModel_AgentSmith", BossModel_AgentSmith)