function BossModel_BionicCommando(player, BossData)
    -- Minimum Required
    local BossCharacter = BossCreateStartRound(BossData, "boss-vs-players-assets::BionicCommando")
    player:Possess(BossCharacter)
    -- End minimum required
end

Package.Export("BossModel_BionicCommando", BossModel_BionicCommando)