local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath

--Goals
local IRON_HARVEST_TARGET = 6


local squad = "truelch_WotP"
local achievements = {
	wwv = modApi.achievements:add{
		id = "wwv",
		name = "World War Vek",
		tooltip = "Complete the game without losing grid",
		image = mod.resourcePath .. "img/achievements/wwv.png",
		squad = squad,
	},

	ironHarvest = modApi.achievements:add{
		id = "ironHarvest",
		name = "Iron Harvest",
		tooltip = "Kill " .. tostring(IRON_HARVEST_TARGET) .. " enemies in a single turn",
		image = mod.resourcePath .. "img/achievements/ironHarvest.png",
		squad = squad,
	},

	goodBoy = modApi.achievements:add{
		id = "goodBoy",
		name = "Who's a good boiii?",
		tooltip = "Complete a game where the Support Mech has the most kills",
		image = mod.resourcePath .. "img/achievements/goodBoy.png",
		squad = squad,
	},
}


local wotpAchvs =
{
	"wwv",
	"ironHarvest",
	"goodBoy",
	"tankYou",
	"vape",
	"bigShots",
	"groundZero",
	"museum"
}

local function checkCompletion()
	--LOG("TRUELCH ----------------- Check completion")
	local fullComplete = true

	for _,v in pairs(wotpAchvs) do
		--LOG("TRUELCH ----------------- achievement id: " .. v)
		progress = modApi.achievements:getProgress(squad, v)
		if progress == false then
			fullComplete = false
		end
		--LOG("TRUELCH ----------------- progress: " .. tostring(progress))
	end

	if fullComplete then
		--https://github.com/itb-community/ITB-ModLoader/wiki/toasts
		--LOG("TRUELCH ----------------- Completed!")
		modApi.toasts:add({
			id = "customBg", --"customBg"
			name = "Custom Background unlocked!", --"Custom Background unlocked!"
			tooltip = "You can enable the custom background in the mod configuration and restart the game!", --"You can enable the custom background in the mod configuration and restart the game!"
			image = mod.resourcePath .. "img/achievements/customBg.png"})
	end
end


local function isGame()
	return true
		and Game ~= nil
		and GAME ~= nil
end

local function isSquad()
	return true
		and isGame()
		and GAME.additionalSquadData.squad == squad
end

local function isMission()
	local mission = GetCurrentMission()

	return true
		and isGame()
		and mission ~= nil
		and mission ~= Mission_Test
end

local function isMissionBoard()
	return true
		and isMission()
		and Board ~= nil
		and Board:IsTipImage() == false
end

local function isGameData()
	return true
		and GAME ~= nil
		and GAME.truelch_WotP ~= nil
		and GAME.truelch_WotP.achievementData ~= nil
end

local function gameData()
	if GAME.truelch_WotP == nil then
		GAME.truelch_WotP = {}
	end

	if GAME.truelch_WotP.achievementData == nil then
		GAME.truelch_WotP.achievementData = {}
	end

	return GAME.truelch_WotP.achievementData
end

local function missionData()
	local mission = GetCurrentMission()

	if mission.truelch_WotP == nil then
		mission.truelch_WotP = {}
	end

	if mission.truelch_WotP.achievementData == nil then
		mission.truelch_WotP.achievementData = {}
	end

	return mission.truelch_WotP.achievementData
end


local COMPLETE = 1
local INCOMPLETE = 0


--World War Vek (wwv)
local EVENT_GRID_DAMAGED = 7

local getTooltip = achievements.wwv.getTooltip
achievements.wwv.getTooltip = function(self)
	local result = getTooltip(self)

	local status = ""

	--No need to check if we're in a mission
	if isGame() then
		status = "\n\nGrid damage: " .. tostring(gameData().wwvGridDmg)
	end

	result = result .. status 

	return result
end

modApi.events.onPostStartGame:subscribe(function()
	gameData().wwvFailed = false
	gameData().wwvGridDmg = 0
end)

modApi.events.onMissionUpdate:subscribe(function(mission)
	local exit = false
		or isSquad() == false
		or isMission() == false
		--or gameData().wwvFailed --to know how much grid damage the player took

	if exit then
		return
	end

	if Game:GetEventCount(EVENT_GRID_DAMAGED) > 0 then
		--TODO: find how to display this achievement is failed for this run
		gameData().wwvGridDmg = gameData().wwvGridDmg + 1
		gameData().wwvFailed = true
	end
end)

modApi.events.onGameVictory:subscribe(function(difficulty, islandsSecured, squad_id)
	local exit = false
		or isSquad() == false
		or gameData().wwvFailed

	if exit then
		return
	end
	
	achievements.wwv:addProgress{ complete = true }
	checkCompletion()
end)


--Iron Harvest (ironHarvest)
--Kill 6 enemies in a single turn
local EVENT_TURN_START = 14

local getTooltip = achievements.ironHarvest.getTooltip
achievements.ironHarvest.getTooltip = function(self)
	local result = getTooltip(self)

	local status = ""

	if isMission() then
		status = "\n\nKills this turn: " .. tostring(missionData().ironHarvestKills) .. " / " .. tostring(IRON_HARVEST_TARGET)
	end

	result = result .. status 

	return result
end

--Call this when every new turn
local function resetIronHarvestKillCount()
	local exit = false
		or isSquad() == false
		or isMission() == false

	if exit then
		return
	end

	--LOG("TRUELCH - resetIronHarvestKillCount()")
	--LOG("TRUELCH - kills (before): " .. tostring(missionData().ironHarvestKills))
	missionData().ironHarvestKills = 0
	--LOG("TRUELCH - kills (after): " .. tostring(missionData().ironHarvestKills))
end

modApi.events.onMissionStart:subscribe(function()
	local exit = false
		or isSquad() == false
		or isMission() == false

	if exit then
		return
	end

	--test to see if it inits
	--LOG("TRUELCH - onMissionStart")

	resetIronHarvestKillCount()
end)

modApi.events.onMissionUpdate:subscribe(function()
	local exit = false
		or isSquad() == false
		or isMission() == false

	if exit then
		return
	end

	local missionData = missionData()

	if Game:GetEventCount(EVENT_TURN_START) > 0 then
		--LOG("TRUELCH - Game:GetEventCount(EVENT_TURN_START)")
		resetIronHarvestKillCount()
	end
end)

local function incrementIronHarvestKillCount()
	local exit = false
		or isSquad() == false
		or isMission() == false

	if exit then
		return
	end

	local missionData = missionData()

	if missionData.ironHarvestKills == nil then
		--LOG("TRUELCH - Avoided mission missionData.ironHarvestKills initialization error!")
		missionData.ironHarvestKills = 0
	end

	--LOG("TRUELCH - incrementIronHarvestKillCount()")
	--LOG("TRUELCH - kills (before): " .. tostring(missionData.ironHarvestKills))
	missionData.ironHarvestKills = missionData.ironHarvestKills + 1
	--LOG("TRUELCH - kills (after): " .. tostring(missionData.ironHarvestKills))
	if missionData.ironHarvestKills >= IRON_HARVEST_TARGET then
		achievements.ironHarvest:addProgress{ complete = true }
		checkCompletion()
	end
end

modApi.events.onModsLoaded:subscribe(function()
	modapiext:addPawnKilledHook(function(mission, pawn)
		--LOG("------ Achievements - Pawn Killed")
		local exit = false
			or isSquad() == false
			or isMission() == false

		if exit then
			return
		end

		--LOG("TRUELCH - Mission: " .. save_table(mission))

		if pawn:IsEnemy() then
			incrementIronHarvestKillCount()
		end
	end)
end)



--Who's a good boiii? (goodBoy)
--Complete a game where you Support Mech (M22) gets more kills than the other Mechs.
local KV2_TYPE = "truelch_HowitzerMech"
local PE8_TYPE = "truelch_HeavyBomberMech"
local M22_TYPE = "truelch_SupportMech"

local EVENT_PLAYER_TURN = 5

local getTooltip = achievements.goodBoy.getTooltip
achievements.goodBoy.getTooltip = function(self)
	local result = getTooltip(self)

	local status = ""

	if isMission() then
		status = "\n\nKills:\nSupport Mech: " .. tostring(gameData().m22Kills) .. "\nHowitzer Mech: " .. tostring(gameData().kv2Kills) .. "\nHeavy Bomber Mech: " .. tostring(gameData().pe8Kills)
	end

	result = result .. status 

	return result
end

local function isPlayerTurn()
	return Game:GetEventCount(EVENT_PLAYER_TURN) > 0
end

modApi.events.onPostStartGame:subscribe(function()
	gameData().kv2Kills = 0
	gameData().pe8Kills = 0
	gameData().m22Kills = 0	
end)

modApi.events.onMissionStart:subscribe(function()
	local exit = false
		or isSquad() == false
		or isMission() == false

	if exit then
		return
	end

	missionData().lastAttPawnType = ""
end)

--This doesn't work
--[[
modApi.events.onModsLoaded:subscribe(function()
	modapiext:addSkillEndHook(function(mission, pawn, weaponId, p1, p2)
		local exit = false
			or isSquad() == false
			or isMission() == false

		if exit then
			return
		end

		if type(weaponId) == 'table' then
    		weaponId = weaponId.__Id
		end

		LOG("------ SkillEndHook -> pawn: " .. tostring(pawn:GetType()) .. ", weaponId: " .. tostring(weaponId))
		missionData().lastAttPawnType = pawn:GetType()
	end)
end)
]]

modApi.events.onModsLoaded:subscribe(function()
	modapiext:addSkillStartHook(function(mission, pawn, weaponId, p1, p2)
		local exit = false
			or isSquad() == false
			or isMission() == false

		if exit then
			return
		end

		if type(weaponId) == 'table' then
    		weaponId = weaponId.__Id
		end

		--LOG("------ SkillStartHook -> pawn: " .. tostring(pawn:GetType()) .. ", weaponId: " .. tostring(weaponId))
		if weaponId ~= "Move" and weaponId ~= nil then
			missionData().lastAttPawnType = pawn:GetType()
		else
			--LOG("--------- Not a weapon!")
		end
	end)
end)

modApi.events.onModsLoaded:subscribe(function()
	modapiext:addPawnKilledHook(function(mission, pawn)
		local exit = false
			or isSquad() == false
			or isMission() == false
			or isPlayerTurn() == false
			or missionData().lastAttPawnType == nil			
			or not pawn:IsEnemy()

		if exit then
			return
		end

		if missionData().lastAttPawnType == KV2_TYPE then
			gameData().kv2Kills = gameData().kv2Kills + 1
			--LOG("TRUELCH ----------------- PawnKilledHook KV-2 kills: " .. tostring(gameData().kv2Kills))
		elseif missionData().lastAttPawnType == PE8_TYPE then
			gameData().pe8Kills = gameData().pe8Kills + 1
			--LOG("TRUELCH ----------------- PawnKilledHook Pe-8 kills: " .. tostring(gameData().pe8Kills))
		elseif missionData().lastAttPawnType == M22_TYPE then
			gameData().m22Kills = gameData().m22Kills + 1
			--LOG("TRUELCH ----------------- PawnKilledHook M22 kills: " .. tostring(gameData().m22Kills))
		end
	end)
end)

modApi.events.onGameVictory:subscribe(function(difficulty, islandsSecured, squad_id)
	local exit = false
		or isSquad() == false

	if exit then
		return
	end

	if gameData().m22Kills > gameData().kv2Kills and gameData().m22Kills > gameData().pe8Kills then
		achievements.goodBoy:addProgress{ complete = true }
		checkCompletion()
	end
end)

function debugKills()
	LOG("m22Kills: " .. tostring(gameData().m22Kills) ..
		"\nkv2Kills: " .. tostring(gameData().kv2Kills) ..
		"\npe8Kills: " .. tostring(gameData().pe8Kills))
end

function testMessage(p1, msg)
	local pop = VoicePopup()
	pop.text = msg
	pop.pawn = Board:GetPawn(p1):GetId()
	Game:AddVoicePopup(pop)
end