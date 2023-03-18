----------------------------------------------- IMPORTS

local mod = mod_loader.mods[modApi.currentMod]
local scriptPath = mod.scriptPath

--Useless?
--local utils = require(scriptPath .. "libs/utils")

--Test
--local extDir = scriptPath .. "modApiExt/"
--local truelch_ww2_ModApiExt = require(extDir .. "modApiExt")

--LApi
--local testLapi = require(scriptPath .. "LApi/LApi")

----------------------------------------------- IMAGES



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

--Unnecessary?
local function IsTipImage()
    return Board:GetSize() == Point(6,6)
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
    "truelch_FAB5000",
    "truelch_FAB5000_A",
    "truelch_FAB5000_B", --doesn't exist yet, but we never now...
    "truelch_FAB5000_AB", --doesn't exist yet, but we never now...
}

local function isFAB5000(weapon)
    --LOG("isFAB5000(weapon: " .. tostring(weapon) .. ")")
    for _,v in pairs(fab5000Names) do
        if v == weapon then
            --LOG("is FAB-5000!")
            return true
        end
    end
    return false
end

local function computeFAB5000()
	--LOG("computeFAB5000()")

    gameData().currentMission = gameData().currentMission + 1
    local fab5000HasBeenUsedPreviousMission = gameData().currentMission - 1 == gameData().lastFab5000Use

    --LOG("fab5000HasBeenUsedPreviousMission: " .. tostring(fab5000HasBeenUsedPreviousMission))

    if fab5000HasBeenUsedPreviousMission then    
        --Disable the FAB-5000!
        for i = 0, 2 do
        	--LOG("i: " .. tostring(i))
            local pawn = Board:GetPawn(i)
            if pawn ~= nil then
                local weapons = pawn:GetPoweredWeapons()
                for j = 1, 2 do
                	--LOG("j: " .. tostring(j))
                    if isFAB5000(weapons[j]) then
                    	--LOG("is FAB-5000!")
                        local fab5000 = _G[weapons[j]]
                        ForceUseFab5000(pawn, pawn:GetSpace(), j)

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
	--LOG("HOOK_onNextTurnHook()")
	--LOG("Currently it is turn of team: " .. tostring(Game:GetTeamTurn()))
	--LOG("missionData().needToCheckFAB5000: " .. tostring(missionData().needToCheckFAB5000))

	if Game:GetTeamTurn() == TEAM_PLAYER and missionData().needToCheckFAB5000 == true then
		missionData().needToCheckFAB5000 = false --test
		for i = 0, 2 do			
			local pawn = Board:GetPawn(i)
			Board:GetPawn(i):SetPowered(true) --hope it won't interact badly with other stuff
			--LOG("pawn: " .. tostring(pawn:GetType()) .. " is powered!")
		end
	end

	if Game:GetTeamTurn() == TEAM_ENEMY and missionData().needToCheckFAB5000 == true then
		computeFAB5000()
	end 
end

local function HOOK_onMissionStart()
	--LOG("HOOK_onMissionStart()")
    missionData().needToCheckFAB5000 = true
end

local function HOOK_onMissionNextPhaseCreated()
	--LOG("HOOK_onMissionNextPhaseCreated()")
    missionData().needToCheckFAB5000 = true
end

local HOOK_onSkillEnd = function(mission, pawn, weaponId, p1, p2)
	--LOG("HOOK_onSkillEnd")
    local exit = false
        or not isGame()
        or mission == nil
        or mission == Mission_Test
        or Board == nil
        --or Board:IsTipImage() --always return true since AE
        or IsTipImage()

    if exit then
        return
    end

    --LOG("proceed!")

    if isFAB5000(weaponId) and not forceUse then
        --LOG("FAB-5000 has been used!")
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



--Custom
function ForceUseFab5000(pawn, target, weaponIndex)
    forceUse = true
    pawn:FireWeapon(target, weaponIndex)
    forceUse = false
end


--FAB-5000
truelch_FAB5000 = Skill:new{
	Name = "FAB-5000",
	Description = "Drops a bomb that deals 3 damage to everything in a cross-shaped area.\nSingle use.",
	Class = "Brute",
	Icon = "weapons/brute_fab5000.png",
	Rarity = 3,
	AttackAnimation = "explo_fire1", --"ExploRaining1"
	Sound = "/general/combat/stun_explode",
	MinMove = 4,
	Range = 4,
	Damage = 3, --DAMAGE_DEATH,
	AnimDelay = 0.2,
	PowerCost = 0, --was 1 before AE
	DoubleAttack = 0, --does it attack again after stopping moving
	Upgrades = 1,
	UpgradeCost = { 2 },
	LaunchSound = "/weapons/bomb_strafe",
	BombSound = "/impact/generic/explosion",
	Limited = 1,
	TipImage = {
		Unit   = Point(2,4),
		Enemy  = Point(2,3),
		Enemy2 = Point(1,2),
		Enemy3 = Point(2,1),
		Target = Point(2,0),
	}
}

Weapon_Texts.truelch_FAB5000_Upgrade1 = "+2 Damage"

truelch_FAB5000_A = Brute_FAB5000:new{
	UpgradeDescription = "Deals 2 additional damage."
	Damage = 5
}

function truelch_FAB5000:GetTargetArea(point)
	local ret = PointList()

	--Allow to target self for the forced use
	if forceUse == true then
		ret:push_back(point)
		return ret
	end

	--Normal behaviour
	for i = DIR_START, DIR_END do
		for k = self.MinMove, self.Range do
			if not Board:IsBlocked(DIR_VECTORS[i]*k + point, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + point)
			end
		end
	end
	
	return ret
end

function truelch_FAB5000:GetSkillEffect(p1, p2)
	local ret = SkillEffect()

	if forceUse then
		ret:AddDamage(SpaceDamage(p1, 0))
		local pawn = Board:GetPawn(p1)
		pawn:SetPowered(false)
		LOG("pawn: " .. tostring(pawn:GetType()) .. " is UNpowered!")
		return ret
	end

	--Normal use	
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