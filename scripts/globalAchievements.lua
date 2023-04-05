local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local squad = "truelch_WotP"

-- Goals
local VAPE_TARGET = 50
local BIG_SHOTS_TARGET = 5
local GROUND_ZERO_TARGET = 5
local MUSEUM_TARGET = 2

local achievements = {
	tankYou = modApi.achievements:add{
		id = "tankYou",
		name = "Tank You!",
		tooltip = "Complete a game with a squad composed exclusively from tanks" ..
			"\n\nEligible tanks:" ..
			"\nWotP's Support Mech" ..
			"\nRift Walkers' Cannon Mech" ..
			"\nFrozen Titans' Mirror Mech" ..
			"\nHazardous Mechs' Unstable M." ..
			"\nArachnophiles' Bulk Mech" ..
			"\nRF1995's Light Tank" ..
			"\nArchive Armors' Devastator" ..
			"\nVek Stompers' Magnum Mech" ..
			"\nFire Storm's Spark Mech" ..
			"\nMagnetic G. Catapult Mech" ..
			"\nNuclear N. Overload Mech",
		image = mod.resourcePath.."img/achievements/tankYou.png",
		global = "Weapons of the Past",
	},
	vape = modApi.achievements:add{
		id = "vape",
		name = "Okay we get it, you vape",
		tooltip = "Cancel " .. tostring(VAPE_TARGET) .. " attacks with smoke in a single run",
		image = mod.resourcePath.."img/achievements/vape.png",
		global = "Weapons of the Past",
	},
	bigShots = modApi.achievements:add{
		id = "bigShots",
		name = "Big Shots", --"Bunker Buster"
		tooltip = "Kill an enemy with " .. tostring(BIG_SHOTS_TARGET) .. " HP or more in a single shot with the Howitzer Mech",
		image = mod.resourcePath.."img/achievements/bigShots.png",
		global = "Weapons of the Past",
	},
	groundZero = modApi.achievements:add{
		id = "groundZero",
		name = "Ground Zero",
		tooltip = "Kill " .. tostring(GROUND_ZERO_TARGET) .. " enemies in one attack with the Heavy Bomber Mech",
		image = mod.resourcePath.."img/achievements/groundZero.png",
		global = "Weapons of the Past",
	},
	museum = modApi.achievements:add{
		id = "museum",
		name = "That belongs in a museum!",
		tooltip = "Finish " .. tostring(MUSEUM_TARGET) .. " of these missions without losing Archive's ally unit:" ..
			"\nProtect Artillery Support" ..
			"\nProtect Tanks" ..
			"\nA mission with a bombing run" ..
			"\nDefend the Battleship (tosx mission pack)",
		image = mod.resourcePath.."img/achievements/museum.png",
		global = "Weapons of the Past",
	},
}

local function isGame()
	return true
		and Game ~= nil
		and GAME ~= nil
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


--Tank You! (tankYou)
--Complete a game with a squad composed exclusively from tanks
local tankYouEligibleMechs =
{
	"truelch_SupportMech", --Weapons of the Past
	"TankMech",            --Rift Walkers
	"MirrorMech",          --Frozen Titans
	"UnstableTank",        --Hazardous Mechs
	"BulkMech",            --Arachnophiles
	"lmn_TankMech",        --RF1995
	"lmn_DevastatorMech",  --Archive Armors
	"VS_MagnumMech",       --Vek Stompers
	"tatu_Spark_Mech",     --Fire Storm
	"tosx_CatapultMech",   --Magnetic Golems
	"NAH_OverloadMech"     --Nuclear Nightmares
}

--TODO: in addition to that, check Tank = true
function isEligibleMechForTankYouAchv(pawn)
	if _G[pawn:GetType()].Tank == true then	--thx Lemonymous!!!
		return true
	end

	for _,v in pairs(tankYouEligibleMechs) do
		if v == pawn:GetType() then
			return true
		end
	end
	--LOG("-> No! :(")
	return false
end

--I took inspiration from Support_Repair to iterate through Mechs
--I'm surprised there's not a more efficient way to do this...
function isWholeSquadIsEligibleForTankYouAchv()
	for i = 0, 7 do
		for j = 0, 7  do
			if Board:IsPawnTeam(Point(i, j), TEAM_PLAYER) then
				local pawn = Board:GetPawn(Point(i, j))
				if pawn:IsMech() and not isEligibleMechForTankYouAchv(pawn) then
					return false
				end
			end
		end
	end
	return true
end


--This should be more efficient
--For some reason, we have nil pawn here
--[[
function isWholeSquadIsEligibleForTankYouAchv()
	for i = 0, 2 do
		local mech = Board:GetPawn(i)
		if not isEligibleMechForTankYouAchv(pawn) then
			return false
		end
	end
	return true
end
]]

--Note: no need to check isSquad, it's a global achievement
modApi.events.onGameVictory:subscribe(function(difficulty, islandsSecured, squad_id)
	if isWholeSquadIsEligibleForTankYouAchv() == true then
		achievements.tankYou:addProgress{ complete = true }
	end
end)



--Okay we get it, you vape (vape)
--Cancel 50 attacks with smoke in a single run
local EVENT_CANCEL_ATTACK_WITH_SMOKE = 42

local getTooltip = achievements.vape.getTooltip
achievements.vape.getTooltip = function(self)
	local result = getTooltip(self)

	local status = ""

	if isMission() then
		status = "\nVaped Vek: " .. tostring(gameData().vapeCount)
	end

	result = result .. status 

	return result
end

modApi.events.onPostStartGame:subscribe(function()
	gameData().vapeCount = 0
end)

modApi.events.onMissionUpdate:subscribe(function(mission)
	local exit = false
		or isMission() == false

	if exit then
		return
	end

	if Game:GetEventCount(EVENT_CANCEL_ATTACK_WITH_SMOKE) > 0 then
		gameData().vapeCount = gameData().vapeCount + 1
		if gameData().vapeCount >= VAPE_TARGET then
			achievements.vape:addProgress{ complete = true }
		end
	end
end)



--Big Shots / Bunker Buster (bigShots)
--Kill an enemy with 5 HP or more in a single shot with the KV-2
local KV2_TYPE = "truelch_HowitzerMech"

function refreshBigShotsTable()
	missionData().bsCurrHpTable = {}
	missionData().bsMaxHpTable = {}

	local count = 0
	for i = 0, 7 do
		for j = 0, 7  do
			local pawn = Board:GetPawn(Point(i, j))
			if pawn ~= nil then
				local pawnId = pawn:GetId()
				local currHp = pawn:GetHealth()
				local maxHp = pawn:GetMaxHealth()
				
				--[[
				LOG("TRUELCH --------------------------------------------- pawn: " .. pawn:GetMechName() .. ", type: " .. pawn:GetType() ..
					 ", pawnId: " .. tostring(pawnId) .. ", currHp: " .. tostring(currHp) .. ", maxHp: " .. tostring(maxHp))
				]]
				
				missionData().bsCurrHpTable[pawnId] = currHp
				missionData().bsMaxHpTable[pawnId]  = maxHp
				
				--[[
				LOG("TRUELCH --------------------------------------------- After -> curr hp: " .. tostring(missionData().bsCurrHpTable[pawnId]) .. 
					", maxHp: " .. tostring(maxHp))
				]]
				
			end
		end
	end
end

function getRemainingHpBeforeAttack(pawn)
	local pawnId = pawn:GetId()
	if missionData().bsCurrHpTable ~= nil and missionData().bsCurrHpTable[pawnId] ~= nil then
		return missionData().bsCurrHpTable[pawnId]
	else
		return -1
	end
end

function getMaxHpBeforeAttack(pawn)
	local pawnId = pawn:GetId()
	if missionData().bsMaxHpTable ~= nil and missionData().bsMaxHpTable[pawnId] ~= nil then
		return missionData().bsMaxHpTable[pawnId]
	else
		return -1
	end
end

modApi.events.onMissionStart:subscribe(function()
	local exit = false
		or isMission() == false

	if exit then
		return
	end

	missionData().isKV2Attacking = false
end)

modApi.events.onModsLoaded:subscribe(function()	
	modapiext:addSkillStartHook(function(mission, pawn, weaponId, p1, p2)
		local exit = false
			or isMission() == false

		if exit then
			return
		end

		--
		if (pawn:GetType() == KV2_TYPE) then
			missionData().isKV2Attacking = true
			refreshBigShotsTable() --here, to avoid refreshing too often
		else
			missionData().isKV2Attacking = false
		end

	end)
end)

modApi.events.onModsLoaded:subscribe(function()
	modapiext:addPawnKilledHook(function(mission, pawn)
		local exit = false
			or isMission() == false
			--or pawn:IsEnemy() == false --I commented this before, but I can't remember why -> pawn can be nil for some reason
			or missionData().isKV2Attacking == false

		if exit then
			return
		end

		if pawn == nil then
			return
		end

		local hpBeforeDeath = getRemainingHpBeforeAttack(pawn)
		local hpMax = getMaxHpBeforeAttack(pawn)

		if hpBeforeDeath < 0 or hpMax < 0 then
			--LOG("TRUELCH --------------------------------------------- Prevented error! (addPawnKilledHook for KV-2)")
			return
		end

		--LOG("TRUELCH --------------------------------------------- Remaining HP (before death): " .. tostring(hpBeforeDeath))
		--LOG("TRUELCH --------------------------------------------- Max HP: " .. tostring(hpMax))

		if hpBeforeDeath >= BIG_SHOTS_TARGET and hpBeforeDeath == hpMax then
			achievements.bigShots:addProgress{ complete = true }
		end
		
	end)
end)



--Ground Zero (groundZero)
--Kill 5 enemies in one attack with the Pe-8
local PE8_TYPE = "truelch_HeavyBomberMech"

modApi.events.onMissionStart:subscribe(function()
	local exit = false
		or isMission() == false

	if exit then
		return
	end

	missionData().isPe8Attacking = false
	missionData().groundZeroPe8Kills = 0
	--LOG("TRUELCH - Mission start -> Reset!")
end)

modApi.events.onModsLoaded:subscribe(function()
	modapiext:addSkillStartHook(function(mission, pawn, weaponId, p1, p2)
		--LOG("TRUELCH - SKILL START HOOK")

		local exit = false
			or isMission() == false

		if exit then
			return
		end

		if type(weaponId) == 'table' then
    		weaponId = weaponId.__Id
		end

		--LOG("TRUELCH - SKILL START HOOK - pawn:GetType(): " .. pawn:GetType() .. ", weaponId: " .. weaponId)

		if pawn:GetType() == PE8_TYPE then
			--Init
			missionData().isPe8Attacking = true
			missionData().groundZeroPe8Kills = 0
			--LOG("TRUELCH - Skill started -> Pe8 attacking!")
		else
			--Reset
			missionData().isPe8Attacking = false
			missionData().groundZeroPe8Kills = 0
			--LOG("TRUELCH - Skill started -> Reset! (not Pe8 attacking)")
		end

	end)
end)

modApi.events.onModsLoaded:subscribe(function()
	modapiext:addSkillEndHook(function(mission, pawn, weaponId, p1, p2)
		--LOG("TRUELCH - Skill End")
		local exit = false
			or isMission() == false

		if exit then
			return
		end

		if type(weaponId) == 'table' then
    		weaponId = weaponId.__Id
		end

		--LOG(" ---> Skill end OK")
		--LOG("TRUELCH - SKILL END HOOK - pawn:GetType(): " .. pawn:GetType() .. ", weaponId: " .. weaponId)

		if pawn:GetType() == PE8_TYPE then
			--Init
			missionData().isPe8Attacking = true
			--LOG("TRUELCH - Skill ended -> Pe8 attacking!")
		else
			--Reset
			missionData().isPe8Attacking = false
			missionData().groundZeroPe8Kills = 0
			--LOG("TRUELCH - Skill ended -> Reset! (not Pe8 attacking)")
		end
	end)
end)

modApi.events.onModsLoaded:subscribe(function()
	modapiext:addPawnKilledHook(function(mission, pawn)
		--LOG("TRUELCH - PAWN KILLED HOOK")
		local exit = false
			or isMission() == false

		if exit then
			return
		end

		if missionData().isPe8Attacking == nil then
			--LOG(" ---> Return")
			return
		end

		if pawn:IsEnemy() and missionData().isPe8Attacking then
			missionData().groundZeroPe8Kills = missionData().groundZeroPe8Kills + 1
			--LOG("TRUELCH - Pawn killed -> Pe8 kills: " .. tostring(missionData().groundZeroPe8Kills))
			if missionData().groundZeroPe8Kills >= GROUND_ZERO_TARGET then
				achievements.groundZero:addProgress{ complete = true } --TODO
				--Board:AddAlert(pawn:GetSpace(), "Ground Zero!")
			end
		end
	end)
end)



--That belongs in a museum (museum)
--Finish these 3 missions without losing Archive's ally unit
local AIRSTRIKE_MISSION_ID  = "Mission_Airstrike"
local TANKS_MISSION_ID      = "Mission_Tanks"
local ARTILLERY_MISSION_ID  = "Mission_Artillery"
local BATTLESHIP_MISSION_ID = "Mission_tosx_Shipping"

local museumAllies =
{
	"ArchiveArtillery",
	"Archive_Tank",
	"tosx_mission_battleship", --tosx' battleship
}

function isMuseumPawn(pawn)
	for _,v in pairs(museumAllies) do
		if v == pawn:GetType() then
			return true
		end
	end
end

modApi.events.onPostStartGame:subscribe(function()
	gameData().museumAirstrike   = false
	gameData().museumArtillery   = false
	gameData().museumTanks       = false
	gameData().museumBattleship  = false
	gameData().allAlliesSurvived = true
end)

modApi.events.onModsLoaded:subscribe(function()
	modapiext:addPawnKilledHook(function(mission, pawn)
		local exit = false
			or isMission() == false

		if exit then
			return
		end

		if isMuseumPawn(pawn) then
			--LOG("TRUELCH --------------------------------------------- It's a museum unit. Mission failed.")
			gameData().allAlliesSurvived = false
		end
	end)
end)

modApi.events.onMissionEnd:subscribe(function()
	local exit = false
		or isMission() == false

	if exit then
		return
	end

	local mission = GetCurrentMission()

	if mission["ID"] == AIRSTRIKE_MISSION_ID then
		--LOG("TRUELCH --------------------------------------------- Airstrike ok")
		gameData().museumAirstrike = true
	elseif mission["ID"] == TANKS_MISSION_ID then
		--LOG("TRUELCH --------------------------------------------- Tanks ok")
		gameData().museumTanks = true
	elseif mission["ID"] == ARTILLERY_MISSION_ID then
		--LOG("TRUELCH --------------------------------------------- Artillery ok")
		gameData().museumArtillery = true
	elseif mission["ID"] == BATTLESHIP_MISSION_ID then
		--LOG("TRUELCH --------------------------------------------- Battleship ok")
		gameData().museumBattleship = true
	end

	local amount = 0

	if gameData().museumAirstrike == true then
		amount = amount + 1
	end

	if gameData().museumArtillery == true then
		amount = amount + 1
	end

	if gameData().museumTanks == true then
		amount = amount + 1
	end

	if gameData().museumBattleship == true then
		amount = amount + 1
	end 

	--if gameData().museumAirstrike == true and gameData().museumArtillery == true and gameData().museumTanks == true and gameData().allAlliesSurvived then
	if amount >= MUSEUM_TARGET and gameData().allAlliesSurvived then
		achievements.museum:addProgress{ complete = true }
	end
end)