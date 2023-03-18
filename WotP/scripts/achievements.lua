local mod = mod_loader.mods[modApi.currentMod]
local modApiExt = LApi.library:fetch("modApiExt/modApiExt", nil, "ITB-ModUtils") --Oh it worked apparently
--LOG("TRUELCH - modApiExt: " .. tostring("modApiExt"))
local path = mod.scriptPath
local utils = require(path .."libs/utils")
--LOG("TRUELCH - utils: " .. tostring("utils"))

local squad = "truelch_ww2"
local achievements = {
	wwv = modApi.achievements:add{
		id = "wwv",
		name = "World War Vek",
		tooltip = "Complete the game without losing grid",
		image = mod.resourcePath.."img/achievements/wwv.png",
		squad = squad,
	},

	ironHarvest = modApi.achievements:add{
		id = "ironHarvest",
		name = "Iron Harvest",
		tooltip = "Kill 6 enemies in a single turn",
		image = mod.resourcePath.."img/achievements/ironHarvest.png",
		squad = squad,
	},

	goodBoy = modApi.achievements:add{
		id = "goodBoy",
		name = "Who's a good boiii?",
		tooltip = "Complete a game where the M22 has the most kills",
		image = mod.resourcePath.."img/achievements/goodBoy.png",
		squad = squad,
	},
}

local function IsTipImage()
	local isTipImage = (Board:GetSize() == Point(6,6))
	return Board:GetSize() == Point(6,6)
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
		--and Board:IsTipImage() == false
		and IsTipImage() == false
end

local function isGameData()
	return true
		and GAME ~= nil
		and GAME.truelch_ww2 ~= nil
		and GAME.truelch_ww2.achievementData ~= nil
end

local function gameData()
	if GAME.truelch_ww2 == nil then
		GAME.truelch_ww2 = {}
	end

	if GAME.truelch_ww2.achievementData == nil then
		GAME.truelch_ww2.achievementData = {}
	end

	return GAME.truelch_ww2.achievementData
end

local function missionData()
	local mission = GetCurrentMission()

	if mission.truelch_ww2 == nil then
		mission.truelch_ww2 = {}
	end

	if mission.truelch_ww2.achievementData == nil then
		mission.truelch_ww2.achievementData = {}
	end

	return mission.truelch_ww2.achievementData
end

local function isEnemyPawn(pawn)
	if pawn:GetTeam() == TEAM_ENEMY then --should be enough to cover every enemy. I guess
		return true
	elseif pawn:GetTeam() == TEAM_BOTS then
		LOG("TRUELCH - WTF")
		return true
	elseif pawn:GetTeam() == TEAM_ENEMY_MAJOR then
		LOG("TRUELCH - WTF")
		return true
	else
		return false
	end
end


--Some constant variables
local difficultyIndices = {
	[DIFF_EASY] = "easy",
	[DIFF_NORMAL] = "normal",
	[DIFF_HARD] = "hard",
	default = "hard",
}

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
	
end)


--Iron Harvest (ironHarvest)
--Kill 6 enemies in a single turn

local EVENT_TURN_START = 14
local IRON_HARVEST_TARGET = 6

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
	end
end

modApi.events.onModsLoaded:subscribe(function()
	modApiExt:addPawnKilledHook(function(mission, pawn)
		local exit = false
			or isSquad() == false
			or isMission() == false

		if exit then
			return
		end

		--LOG(save_table(mission))

		if isEnemyPawn(pawn) then
			incrementIronHarvestKillCount()
		end
	end)
end)



--Who's a good boiii? (goodBoy)
--Complete a game where you M22 gets more kills than the KV-2.

--new, using GetType() (man, I feel SO dumb to have missed that...)
local KV2_TYPE = "KV2"
local PE8_TYPE = "PE8"
local M22_TYPE = "M22"

local EVENT_PLAYER_TURN = 5

local getTooltip = achievements.goodBoy.getTooltip
achievements.goodBoy.getTooltip = function(self)
	local result = getTooltip(self)

	local status = ""

	if isMission() then
		status = "\n\nKills:\nM22: " .. tostring(gameData().m22Kills) .. "\nKV-2: " .. tostring(gameData().kv2Kills) .. "\nPe-8: " .. tostring(gameData().pe8Kills)
	end

	result = result .. status 

	return result
end

local function isPlayerTurn()
	return Game:GetEventCount(EVENT_PLAYER_TURN) > 0
end

modApi.events.onPostStartGame:subscribe(function()
	gameData().kv2Kills = 0
	gameData().pe8Kills = 0 --Perhaps
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

modApi.events.onModsLoaded:subscribe(function()
	modApiExt:addSkillEndHook(function(mission, pawn, weaponId, p1, p2)
		local exit = false
			or isSquad() == false
			or isMission() == false

		if exit then
			return
		end

		missionData().lastAttPawnType = pawn:GetType()
	end)
end)

modApi.events.onModsLoaded:subscribe(function()
	modApiExt:addPawnKilledHook(function(mission, pawn)
		local exit = false
			or isSquad() == false
			or isMission() == false
			or isPlayerTurn() == false
			or missionData().lastAttPawnType == nil			
			or not isEnemyPawn(pawn)

		if exit then
			return
		end

		--LOG("TRUELCH --------------------------------------------- [SQUAD] addPawnKilledHook type(pawn): " .. type(pawn) .. ")")

		if isEnemyPawn(pawn) then
			if missionData().lastAttPawnType == KV2_TYPE then
				gameData().kv2Kills = gameData().kv2Kills + 1
			elseif missionData().lastAttPawnType == PE8_TYPE then
				gameData().pe8Kills = gameData().pe8Kills + 1
			elseif missionData().lastAttPawnType == M22_TYPE then
				gameData().m22Kills = gameData().m22Kills + 1
			end
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