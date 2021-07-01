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

function playMusic(name)
    --Replaced SoundType.Music by SoundType.SFX temporary because of a bug
    local volume = NanosWorld:GetLocalPlayer():GetValue("BVP_VolumeMusic")
    Sound(Vector(), name, true, true, SoundType.Music, volume / 100, 1)
end

function playEffect(name)
    local volume = NanosWorld:GetLocalPlayer():GetValue("BVP_VolumeEffects")
    Sound(Vector(), name, true, true, SoundType.SFX, volume / 100, 1)
end

function playEffect3D(name, location)
    local volume = NanosWorld:GetLocalPlayer():GetValue("BVP_VolumeEffects")
    Sound(location, name, false, true, SoundType.SFX, volume / 100, 1)
end

Events:Subscribe("BVP_Client_PlayMusic", function(music)
    if music == nil or music == "" then return end
    playMusic(music)
end)

Events:Subscribe("BVP_Client_PlayBGM", function(music)
    if music == nil or music == "" then return end
    local volume = NanosWorld:GetLocalPlayer():GetValue("BVP_VolumeMusic")
    --Replaced SoundType.Music by SoundType.SFX temporary because of a bug
    local newBGM = Sound(Vector(), music, true, false, SoundType.SFX, volume / 100, 1)
    Client:SetValue("BVP_Client_BGM", newBGM)
end)

Events:Subscribe("BVP_Client_PlayEffect", function(music)
    if music == nil or music == "" then return end
    playEffect(music)
end)

Events:Subscribe("BVP_Client_PlayEffect3D", function(music, location)
    if music == nil or location == nil or music == "" or location == "" then return end
    playEffect3D(music, location)
end)

Events:Subscribe("BVP_Client_PlayAnnouncementSound", function (state, time)
    if state == 2 then
        if time == 60 then
            playEffect("boss-vs-players-assets::announcer_ends_60sec")
        end
        if time == 30 then
            playEffect("boss-vs-players-assets::announcer_ends_30sec")
        end
        if time == 10 then
            playEffect("boss-vs-players-assets::announcer_ends_10sec")
        end
        if time == 5 then
            playEffect("boss-vs-players-assets::announcer_ends_5sec")
        end
        if time == 4 then
            playEffect("boss-vs-players-assets::announcer_ends_4sec")
        end
        if time == 3 then
            playEffect("boss-vs-players-assets::announcer_ends_3sec")
        end
        if time == 2 then
            playEffect("boss-vs-players-assets::announcer_ends_2sec")
        end
        if time == 1 then
            playEffect("boss-vs-players-assets::announcer_ends_1sec")
        end
    end
    if state == 1 then
        if time == 10 then
            playEffect("boss-vs-players-assets::announcer_begins_10sec")
        end
        if time == 5 then
            playEffect("boss-vs-players-assets::announcer_begins_5sec")
        end
        if time == 4 then
            playEffect("boss-vs-players-assets::announcer_begins_4sec")
        end
        if time == 3 then
            playEffect("boss-vs-players-assets::announcer_begins_3sec")
        end
        if time == 2 then
            playEffect("boss-vs-players-assets::announcer_begins_2sec")
        end
        if time == 1 then
            playEffect("boss-vs-players-assets::announcer_begins_1sec")
        end
    end
end)