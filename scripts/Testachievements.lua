--Mod
local mod = mod_loader.mods[modApi.currentMod]

--Paths
local scriptPath = mod.scriptPath
local resourcePath = mod.resourcePath

--Goals
local EVENT_GRID_DAMAGED = 7

squad = "truelch_WotP"

--Add achievements
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

--Remove?
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