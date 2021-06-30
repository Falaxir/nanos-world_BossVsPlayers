--[[

.______     ______        _______.     _______.   ____    ____   _______.   .______    __          ___   ____    ____  _______ .______          _______.
|   _  \   /  __  \      /       |    /       |   \   \  /   /  /       |   |   _  \  |  |        /   \  \   \  /   / |   ____||   _  \        /       |
|  |_)  | |  |  |  |    |   (----`   |   (----`    \   \/   /  |   (----`   |  |_)  | |  |       /  ^  \  \   \/   /  |  |__   |  |_)  |      |   (----`
|   _  <  |  |  |  |     \   \        \   \         \      /    \   \       |   ___/  |  |      /  /_\  \  \_    _/   |   __|  |      /        \   \
|  |_)  | |  `--'  | .----)   |   .----)   |         \    / .----)   |      |  |      |  `----./  _____  \   |  |     |  |____ |  |\  \----.----)   |
|______/   \______/  |_______/    |_______/           \__/  |_______/       | _|      |_______/__/     \__\  |__|     |_______|| _| `._____|_______/

.______   ____    ____     _______    ___       __          ___      ___   ___  __  .______
|   _  \  \   \  /   /    |   ____|  /   \     |  |        /   \     \  \ /  / |  | |   _  \
|  |_)  |  \   \/   /     |  |__    /  ^  \    |  |       /  ^  \     \  V  /  |  | |  |_)  |
|   _  <    \_    _/      |   __|  /  /_\  \   |  |      /  /_\  \     >   <   |  | |      /
|  |_)  |     |  |        |  |    /  _____  \  |  `----./  _____  \   /  .  \  |  | |  |\  \----.
|______/      |__|        |__|   /__/     \__\ |_______/__/     \__\ /__/ \__\ |__| | _| `._____|

--]]

-- Function to add a Nametag to a Player
function AddNametag(player, character)
    -- Try to get it's character
    if (character == nil) then
        character = player:GetControlledCharacter()
        if (character == nil) then return end
    end

    -- Spawns the Nametag (TextRender),
    local nametag = TextRender(
            Vector(),               -- Any Location
            Rotator(),              -- Any Rotation
            player:GetName(),       -- Player Name
            Vector(0.5, 0.5, 0.5),  -- 50% Scale
            Color(1, 1, 1),         -- White
            FontType.Roboto,        -- Roboto Font
            TextRenderAlignCamera.AlignCameraRotation -- Follow Camera Rotation
    )

    -- Attaches it to the character and saves it to the player's values
    nametag:AttachTo(character)
    nametag:SetRelativeLocation(Vector(0, 0, 250))

    player:SetValue("Nametag", nametag)
end

function AddBossNametag(player, character)
    -- Try to get it's character
    if (character == nil) then
        character = player:GetControlledCharacter()
        if (character == nil) then return end
    end

    -- Spawns the Nametag (TextRender),
    local nametag = TextRender(
            Vector(),               -- Any Location
            Rotator(),              -- Any Rotation
            "BOSS",       -- Player Name
            Vector(0.5, 0.5, 0.5),  -- 50% Scale
            Color(1, 0, 0),         -- White
            FontType.Roboto,        -- Roboto Font
            TextRenderAlignCamera.AlignCameraRotation -- Follow Camera Rotation
    )

    -- Attaches it to the character and saves it to the player's values
    nametag:AttachTo(character)
    nametag:SetRelativeLocation(Vector(0, 0, 250))

    player:SetValue("Nametag", nametag)
end

-- Function to remove a Nametag from  a Player
function RemoveNametag(player, character)
    -- Try to get it's character
    if (character == nil) then
        character = player:GetControlledCharacter()
        if (character == nil) then return end
    end

    -- Gets the Nametag from the player, if any, and destroys it
    local text_render = player:GetValue("Nametag")
    if (text_render and text_render:IsValid()) then
        text_render:Destroy()
    end
end

-- Adds a new Nametag to a character which was possessed
Character:Subscribe("Possessed", function(character, player)
    if NanosWorld:GetLocalPlayer():GetID() == player:GetID() then return end
    if character:GetTeam() == 1 then
        AddBossNametag(player, character)
    else
        AddNametag(player, character)
    end
end)

-- Removes the Nametag from a character which was unpossessed
Character:Subscribe("UnPossessed", function(character, player)
    RemoveNametag(player, character)
end)

-- When a Player is spawned - for when you connect and there is already Player's connected
Player:Subscribe("Spawn", function(player)
    RemoveNametag(player)
    AddNametag(player)
end)