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

-- Spawns a WebUI with the HTML file you just created
MainHUD = WebUI("Main HUD", "file:///hud/Hud.html")
OptionsHUD = WebUI("Options HUD", "file:///options/Options.html", false)

-- REQUIREMENTS
Package.Require("TriggerEvent.lua")
Package.Require("CommunicationToClients.lua")
Package.Require("RageCalculation.lua")
Package.Require("JumpCalculation.lua")
Package.Require("SpecialCalculation.lua")
Package.Require("PlaySound.lua")
Package.Require("KeyEvent.lua")
Package.Require("Spectator.lua")
Package.Require("OptionsEvents.lua")
Package.Require("LocalTimer.lua")
Package.Require("AddNametags.lua")

-- When LocalPlayer spawns, sets an event on it to trigger when we possesses a new character, to store the local controlled character locally. This event is only called once, see Package:Subscribe("Load") to load it when reloading a package
Client.Subscribe("SpawnLocalPlayer", function(local_player)
    local_player:Subscribe("Possess", function(player, character)
        UpdateLocalCharacter(character)
    end)
end)

-- When package loads, verify if LocalPlayer already exists (eg. when reloading the package), then try to get and store it's controlled character
Package.Subscribe("Load", function()
    Client.SetDiscordActivity("Waiting Round Start", "Boss VS Players Gamemode", "screenshot_173", "by Falaxir")
    if (Client.GetLocalPlayer() ~= nil) then
        UpdateLocalCharacter(Client.GetLocalPlayer():GetControlledCharacter())
    end
end)

-- Function to set all needed events on local character (to update the UI when it takes damage or dies)
function UpdateLocalCharacter(character)
    -- Verifies if character is not nil (eg. when GetControllerCharacter() doesn't return a character)
    if (character == nil) then return end

    -- Updates the UI with the current character's health
    UpdateHealth(character:GetHealth())

    -- Sets on character an event to update the health's UI after it takes damage
    character:Subscribe("TakeDamage", function(charac, damage, type, bone, from_direction, instigator)
        -- Plays a Hit Taken sound effect
        Sound(Vector(), "nanos-world::A_HitTaken_Feedback", true)

        -- Updates the Health UI
        UpdateHealth(charac:GetHealth())
    end)

    -- Sets on character an event to update the health's UI after it dies
    character:Subscribe("Death", function(charac)
        UpdateHealth(0)
    end)

    -- Sets on character an event to update the health's UI after it respawns
    character:Subscribe("Respawn", function(charac)
        UpdateHealth(charac:GetMaxHealth())
    end)

    -- Try to get if the character is holding any weapon
    local current_picked_item = character:GetPicked()

    -- If so, update the UI
    if (current_picked_item and current_picked_item:GetType() == "Weapon" and not current_picked_item:GetValue("ToolGun")) then
        UpdateAmmo(true, current_picked_item:GetAmmoClip(), current_picked_item:GetAmmoBag())
    end

    -- Sets on character an event to update his grabbing weapon (to show ammo on UI)
    character:Subscribe("PickUp", function(charac, object)
        if (object:GetType() == "Weapon" and not object:GetValue("ToolGun")) then
            UpdateAmmo(true, object:GetAmmoClip(), object:GetAmmoBag())

            -- Sets on character an event to update the UI when he fires
            charac:Subscribe("Fire", function(charac, weapon)
                UpdateAmmo(true, weapon:GetAmmoClip(), weapon:GetAmmoBag())
            end)

            -- Sets on character an event to update the UI when he reloads the weapon
            charac:Subscribe("Reload", function(charac, weapon, ammo_to_reload)
                UpdateAmmo(true, weapon:GetAmmoClip(), weapon:GetAmmoBag())
            end)
        end
    end)

    -- Sets on character an event to remove the ammo ui when he drops it's weapon
    character:Subscribe("Drop", function(charac, object)
        UpdateAmmo(false)
        charac:Unsubscribe("Fire")
        charac:Unsubscribe("Reload")
    end)
end

-- Function to update the Ammo's UI
function UpdateAmmo(enable_ui, ammo, ammo_bag)
    MainHUD:CallEvent("UpdateWeaponAmmo", enable_ui, ammo, ammo_bag)
end

-- Function to update the Health's UI
function UpdateHealth(health)
    MainHUD:CallEvent("UpdateHealth", health)
end

-- VOIP UI
Player.Subscribe("VOIP", function(player, is_talking)
    MainHUD:CallEvent("ToggleVoice", player:GetName(), is_talking)
end)

Player.Subscribe("Destroy", function(player)
    MainHUD:CallEvent("ToggleVoice", player:GetName(), false)
    MainHUD:CallEvent("UpdatePlayer", player:GetID(), false)
end)