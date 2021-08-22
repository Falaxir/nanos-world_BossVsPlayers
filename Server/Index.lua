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

BossSpawnLocationsTesting = {
	Vector(500, 0, 500)
}

TriggerRessuplyList = {
	Vector(8285, 4350, 353),
	Vector(2213, -5014, 961),
	Vector(522, -9044, 199),
	Vector(-7198, -9727, 185),
	Vector(-10833, -3741, 184),
	Vector(-7754, 3759, 462),
	Vector(-6207, 7624, 199),
	Vector(882, 8169, 227),
	Vector(-130, 470, 575),
	Vector(-373, -3234, 978),
	Vector(-5255, -4900, 863),
	Vector(-5083, 2173, 1339),
	Vector(-11878, 1186, 177)
}

BossSpawnLocations = {
	Vector(4084, 8175, 238)
}

--[[
IMPORTANT INFO
==============
Lang : 1: FR, 2: En ####
GameStates : 0: no game, 1: starting, 2: In game, 3: Ending
WinStates : 0: nil, 1: boss, 2: teammates
Teams : 0: nil, 1: boss, 2: teammates
--]]

Package.Require("Config.lua")
ConfigLoad()

Package.Require("Languages.lua")
LanguagesLoad()

Package.Subscribe("Load", function()
	Server.SetValue("BVP_ForceWait", false)
	Server.SetValue("BVP_GameState", 0)
	Events.BroadcastRemote("BVP_Client_ChangeGameState", 0)
	Server.SetValue("BVP_TimeLimit", 0)
	for i, v in pairs(BVP_CONFIG.ResupplyLocations) do
		SpawnNewAmmoRessuply(v)
	end
end)

Package.Require("Events.lua")
Package.Require("Timer.lua")
Package.Require("Boss.lua")
Package.Require("Abilities.lua")
Package.Require("BossModels.lua")
Package.Require("Commands.lua")
Package.Require("PlayerCustomisation.lua")
Package.Require("TriggerCreation.lua")
Package.Require("SpawningMaps/TestingMap.lua")
Package.RequirePackage("NanosWorldWeapons")

Server.SetValue("BVP_BossList", {})

BossLoad()
AbilityLoad()
BossModelLoad()

function reverseTable(t)
	local len = #t
	for i = len - 1, 1, -1 do
		t[len] = table.remove(t, i)
	end
end

function SpawnBossRandom(player)
	local bosses = Server.GetValue("BVP_BossList")
	local random = math.random(#bosses)

	for key,value in pairs(bosses)
	do
		if key == random then
			Package.Call("boss-vs-players", value.BossModelFunction, player, value)
			Server.SetValue("BVP_BossData", value)
			Server.SetValue("BVP_BossPlayer", player)
			return
		end
	end
end

function ChooseSpawnRandomBoss()
	local playerBossPoints = {}
	local PlayerNames = Player.GetAll()

	for key,value in pairs(PlayerNames)
	do
		local getPLYbossPoints = value:GetValue("BVP_BossPoints")
		if getPLYbossPoints == nil then
			getPLYbossPoints = 0
		end
		table.insert(playerBossPoints, getPLYbossPoints)
	end
	table.sort(playerBossPoints)
	local highest = playerBossPoints[#playerBossPoints]
	for key,value in pairs(PlayerNames)
	do
		local bossPoint = value:GetValue("BVP_BossPoints")
		if bossPoint == nil then
			value:SetValue("BVP_BossPoints", 0)
			bossPoint = 0
		end
		if bossPoint == highest then
			SpawnBossRandom(value)
			value:SetValue("BVP_BossPoints", 0)
			Server.SetValue("BVP_AliveBossPlayers", 1)
			return
		end
	end
end

Player.Subscribe("Spawn", function(player)
	Events.CallRemote("BVP_Client_GetLanguages", player, LANGUAGES_LIST)
	Events.CallRemote("BVP_Client_GetPermanentData", player)
end)

Player.Subscribe("Ready", function(player)
	local state = Server.GetValue("BVP_GameState")
	Events.CallRemote("BVP_Client_SendPrivateChatMessage", player, "CHAT_WelcomeMessage", nil)
	Server.BroadcastChatMessage("<cyan>" .. player:GetName() .. "</> has joined the server")
	if state ~= 2 then
		Events.CallRemote("BVP_Client_HUD_Advert_important", player, "HUD_Top_WaitBeginning", nil, nil)
		return true
	end
	if state == 2 then
		Events.Call("BVP_GoSpectator", player)
	end
end)

Player.Subscribe("Destroy", function(player)
	Server.BroadcastChatMessage("<cyan>" .. player:GetName() .. "</> has left the server")
end)

Player.Subscribe("UnPossess", function(player, character)
	if character ~= nil then
		Events.Call("CharacterCheckTeam", character)
	end
end)

function SpawnPlayers()
	for key,value in pairs(Player.GetAll())
	do
		if value:GetControlledCharacter() == nil then
			-- Test player location : Vector(0, 0, 100)
			local PlayerCharacters_local = SpawnPlayerCustomisation(value)
			local PlayerWeapon = NanosWorldWeapons.AR4(Vector(), Rotator())
			PlayerWeapon:SetAmmoSettings(30, 400)
			PlayerWeapon:SetDamage(5)
			PlayerWeapon:SetCadence(0.07)
			PlayerWeapon:Subscribe("Drop", function(pickable, character, was_triggered_by_player)
				if pickable ~= nil then
					pickable:Destroy()
				end
			end)
			PlayerCharacters_local:SetMovementEnabled(false)
			PlayerCharacters_local:SetTeam(2)
			PlayerCharacters_local:SetSpeedMultiplier(BVP_CONFIG.GlobalSpeedMultiplier)
			value:Possess(PlayerCharacters_local)
			PlayerCharacters_local:PickUp(PlayerWeapon)
			if value:GetValue("BVP_BossPoints") == nil then
				value:SetValue("BVP_BossPoints", 0)
			end
			local oldBossPoint = value:GetValue("BVP_BossPoints")
			value:SetValue("BVP_BossPoints", oldBossPoint + 1)
			PlayerCharacters_local:Subscribe("Death", function(character, last_damage_taken, last_bone_damaged, damage_type_reason, hit_from_direction, instigator)
				if player ~= nil then
					Server.BroadcastChatMessage("<cyan>" .. instigator:GetName() .. "</> killed <cyan>" .. value:GetName() .. "</>")
				else
					Server.BroadcastChatMessage("<cyan>" .. value:GetName() .. "</> died")
				end
				local PlayerControlled = character:GetPlayer()
				if PlayerControlled ~= nil then
					PlayerControlled:UnPossess()
				end
			end)
		end
	end
end