----------------------------------------------- IMPORTS

local mod = mod_loader.mods[modApi.currentMod]
local scriptPath = mod.scriptPath
local utils = require(scriptPath .."libs/utils")

--Test
local extDir = scriptPath .. "modApiExt/"
local truelch_ww2_ModApiExt = require(extDir .. "modApiExt")

--LApi
local testLapi = require(scriptPath .. "LApi/LApi")

----------------------------------------------- FUNCTIONS

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
        and GAME.truelch_ww2 ~= nil
end

local function gameData()
    if GAME.truelch_ww2 == nil then
        GAME.truelch_ww2 = {}
    end

    return GAME.truelch_ww2
end

local function missionData()
    local mission = GetCurrentMission()

    if mission.truelch_ww2 == nil then
        mission.truelch_ww2 = {}
    end

    return mission.truelch_ww2
end


----------------------------------------------- HOOKS & EVENTS

local forceUse = false --maybe I can access it if I put it here...

local fab5000Names =
{
    "Brute_FAB5000",
    "Brute_FAB5000_A",
    "Brute_FAB5000_B", --doesn't exist yet, but we never now...
    "Brute_FAB5000_AB", --doesn't exist yet, but we never now...
}

local function isFAB5000(weapon)
    --LOG("--------------- isFAB5000(weapon: " .. tostring(weapon) .. ")")
    for _,v in pairs(fab5000Names) do
        if v == weapon then
            --LOG("--------------- is FAB-5000!")
            return true
        end
    end
    return false
end

local function getPawnPos(pawn)
	--LOG("--------------- getPawnPos(pawn: " .. pawn:GetType() .. "pawn:GetId(): " .. tostring(pawn:GetId()) .. ")")
	for y = 0, 7 do
		for x = 0, 7 do
			--LOG("--------------- x: " .. tostring(x) .. ", y: " .. tostring(y))
			local pos = Point(x, y)
			--LOG("--------------- pos: " .. pos:GetString())
			local pickedPawn = Board:GetPawn(pos)
			if pickedPawn ~= nil and pawn:GetId() == pickedPawn:GetId() then
				--LOG("--------------- found it -> pos: " .. pos:GetString())
				return pos
			end
		end
	end
	LOG("--------------- Did not find the pawn position :(")
	return nil
end

local function computeFAB5000()
    --LOG("--------------- [WEAPONS.LUA] computeFAB5000()")

    gameData().currentMission = gameData().currentMission + 1

    LOG("--------------- gameData().currentMission: " .. tostring(gameData().currentMission))
    LOG("--------------- gameData().lastFab5000Use: " .. tostring(gameData().lastFab5000Use))

    local fab5000HasBeenUsedPreviousMission = gameData().currentMission - 1 == gameData().lastFab5000Use

    --if true then --tmp!
    if fab5000HasBeenUsedPreviousMission then    
        --Disable the FAB-5000!
        --LOG("--------------- Disabling the FAB-5000...")
        for i = 0, 2 do            
            local pawn = Board:GetPawn(i)
            if pawn ~= nil then
                local weapons = pawn:GetPoweredWeapons()
                for j = 1, 2 do
                    if isFAB5000(weapons[j]) then
                    	--LOG("--------------- Attempting to force use FAB-5000...") --ok
                        local fab5000 = _G[weapons[j]]
                        ForceUseFab5000(pawn, getPawnPos(pawn), j) --almost working
                        --LOG("--------------- After force use attempt") --ok

                        --Explanation bubble
                        local pop = VoicePopup()
                        pop.text = "Another FAB-5000 is under production, we won't be able to use it in this mission."
                        pop.pawn = pawn:GetId()
                        Game:AddVoicePopup(pop)
                    end
                end
            end
        end
    end
end

local function HOOK_onNextTurnHook()
	--LOG("--------------- Currently it is turn of team: " .. tostring(Game:GetTeamTurn()))
	--LOG("--------------- missionData().needToCheckFAB5000: " .. tostring(missionData().needToCheckFAB5000))

	--if Game:GetTeamTurn() == TEAM_PLAYER and missionData().needToCheckFAB5000 == true then
	if Game:GetTeamTurn() == TEAM_ENEMY and missionData().needToCheckFAB5000 == true then
		--LOG("--------------- -> Conditions are ok, calling compute FAB-5000")
		missionData().needToCheckFAB5000 = false
		computeFAB5000()
	end 
end

local function HOOK_onMissionStart()
    missionData().needToCheckFAB5000 = true
end

local function HOOK_onMissionNextPhaseCreated()
    missionData().needToCheckFAB5000 = true
end

--Dont use it on test mission!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--And not tip image LOL
local HOOK_onSkillEnd = function(mission, pawn, weaponId, p1, p2)
    local exit = false
        or not isGame()
        or mission == nil
        or mission == Mission_Test
        or Board == nil
        or Board:IsTipImage()

    if exit then
        --LOG("--------------- Conditions NOT ok! -> EXIT!")
        return
    end

    --LOG("--------------- Conditions ok! -> CONTINUE")

    LOG("--------------- forceUse: " .. tostring(forceUse))

    --Wups need to check if it's a forced use!!!
    if isFAB5000(weaponId) and not forceUse then

        LOG("--------------- FAB-5000 has been used!")
        
        gameData().lastFab5000Use = gameData().currentMission
    end
end

modApi.events.onPostStartGame:subscribe(function()
    gameData().lastFab5000Use = -10
    gameData().currentMission = 0
end)

local function EVENT_onModsLoaded()
    modApi:addMissionStartHook(HOOK_onMissionStart)
    modApi:addMissionNextPhaseCreatedHook(HOOK_onMissionNextPhaseCreated)
    modApi:addNextTurnHook(HOOK_onNextTurnHook)
    truelch_ww2_ModApiExt:addSkillEndHook(HOOK_onSkillEnd)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)



--FAB-5000
Brute_FAB5000 = Skill:new{
	--New! (for the shop)
	Name = "FAB-5000",
	Description = "Drops a bombs that deals 3 damage to everything in a cross-shaped area.\nSingle use.",
	--
	Class = "Brute",
	Icon = "weapons/brute_fab5000.png",
	Rarity = 3,
	AttackAnimation = "explo_fire1", --"ExploRaining1"
	Sound = "/general/combat/stun_explode",
	MinMove = 4,
	Range = 4,
	--Damage = DAMAGE_DEATH,
	Damage = 3,
	AnimDelay = 0.2,
	PowerCost = 1,
	DoubleAttack = 0, --does it attack again after stopping moving
	Upgrades = 1,
	UpgradeCost = { 2 },
	LaunchSound = "/weapons/bomb_strafe",
	BombSound = "/impact/generic/explosion",
	Limited = 1, --!!!
	TipImage = {
		Unit   = Point(2,4),
		Enemy  = Point(2,3),
		Enemy2 = Point(1,2),
		Enemy3 = Point(2,1),
		Target = Point(2,0),
	}
}

function ForceUseFab5000(pawn, target, weaponIndex)
	LOG("ForceUseFab5000(pawn: " .. pawn:GetType() .. ", target: " .. target:GetString() .. ", weaponIndex: " .. tostring(weaponIndex) .. ")") --ok
    forceUse = true
    pawn:FireWeapon(target, weaponIndex)
    forceUse = false
end


function Brute_FAB5000:GetTargetArea(point)
	local ret = PointList()

	--Solution 1 --->
	--[[
	if isMission() then
	    --LOG("--------------- Brute_FAB5000 -> gameData().currentMission: " .. tostring(gameData().currentMission))
	    --LOG("--------------- Brute_FAB5000 -> gameData().lastFab5000Use: " .. tostring(gameData().lastFab5000Use))

	    local fab5000HasBeenUsedPreviousMission = gameData().currentMission - 1 == gameData().lastFab5000Use

		if fab5000HasBeenUsedPreviousMission then
			--LOG("----------------------- Cannot use the FAB-5000!")
			return ret
		end
	end
	]]
	-- <--- Solution 1


	--Solution 2--->
	--Allow to target self for the forced use
	if forceUse == true then
		--LOG("--------------- Forced used targetting!")
		ret:push_back(point)
		return ret
	end
	-- <--- Solution 2

	--Normal behaviour:	
	for i = DIR_START, DIR_END do
		for k = self.MinMove, self.Range do
			if not Board:IsBlocked(DIR_VECTORS[i]*k + point, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + point)
			end
		end
	end
	
	return ret
end

function Brute_FAB5000:GetSkillEffect(p1, p2)
	local ret = SkillEffect()

	--LOG("--------------- Brute_FAB5000:GetSkillEffect(p1: " .. p1:GetString() .. ", p2: " .. p2:GetString() .. ") -> forceUse: " .. tostring(forceUse))

	if forceUse then
		LOG("--------------- Forced use!") --reached here, but the uses is still 1 and not 0... -> fixed when adding damage

		--Maybe I need to add a damage to be counted as a real action?
		ret:AddDamage(SpaceDamage(p1, 0)) --test... IT WORKS!

		--TODO: re-activate pawn? -> not needed apparently
		--I need it for Archimedes, he'd just have his bonus move otherwise!
		--Board:GetPawn(p1):SetActive(true) --hope it'll work without causing weird issues...
		--I do the forced use during the first enemy turn now. Activating the Mech allowed the enemy to use it I think. (got a weird bug)
		--Ok, set active wasn't the problem

		--Maybe I should try to reduce move speed
		--Board:GetPawn(p1):AddMoveBonus(-11)
		Board:GetPawn(p1):SetPowered(false)

		--Let's try that
		--Board:GetPawn(p1):SetMovementAvailable(false)
		--Board:GetPawn(p1):SetActive(false) --because why not

		return ret --don't continue the rest
	end

	--LOG("--------------- Proceed to use the FAB-5000 normally")
	
	local dir = GetDirection(p2 - p1)
	
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)
	
	local distance = p1:Manhattan(p2)
	
	ret:AddBounce(p1,2)

	ret:AddLeap(move, 0.25)

	ret:AddDelay(0.25)
		
	for k = 1, (self.Range-1) do
		if p1 + DIR_VECTORS[dir]*k == p2 then
			break
		end
		
		local damage = SpaceDamage(p1 + DIR_VECTORS[dir]*k, self.Damage)

		damage.sAnimation = self.AttackAnimation
		damage.sSound = self.BombSound

		ret:AddDamage(damage)		
		ret:AddBounce(p1 + DIR_VECTORS[dir]*k,3)

		if k == 2 then --cross shape
			local damage2 = SpaceDamage(p1 + DIR_VECTORS[dir]*k + DIR_VECTORS[(dir - 1)%4], self.Damage)
			damage2.sAnimation = self.AttackAnimation
			ret:AddDamage(damage2)
			ret:AddBounce(p1 + DIR_VECTORS[dir]*k + DIR_VECTORS[(dir - 1)%4],3)

			local damage3 = SpaceDamage(p1 + DIR_VECTORS[dir]*k + DIR_VECTORS[(dir + 1)%4], self.Damage)
			damage3.sAnimation = self.AttackAnimation
			ret:AddDamage(damage3)
			ret:AddBounce(p1 + DIR_VECTORS[dir]*k + DIR_VECTORS[(dir + 1)%4],3)
		end
	end	
	
	return ret
end

Brute_FAB5000_A = Brute_FAB5000:new{
	Damage = 5
}