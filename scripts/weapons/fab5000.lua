----------------------------------------------- IMPORTS
local mod = mod_loader.mods[modApi.currentMod]
local scriptPath = mod.scriptPath

--Libs
local tips = require(scriptPath .. "libs/tutorialTips")

----------------------------------------------- MOD OPTION
local fab5000ReloadVersion --1: old / 2: new
modApi.events.onModLoaded:subscribe(function(id)
	if id ~= mod.id then return end
	local options = mod_loader.currentModContent[id].options
	fab5000ReloadVersion = options["option_fab5000Reload"].value
	--LOG("----- fab5000ReloadVersion: " .. tostring(fab5000ReloadVersion) .. ", type: " .. tostring(type(fab5000ReloadVersion)))
end)


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

local function isGameData()
    return true
        and GAME ~= nil
        and GAME.truelch_WotP ~= nil
end

local function gameData()
    if GAME.truelch_WotP == nil then
        GAME.truelch_WotP = {}
    end

    return GAME.truelch_WotP
end

local function missionData()
    local mission = GetCurrentMission()

    if mission.truelch_WotP == nil then
        mission.truelch_WotP = {}
    end

    return mission.truelch_WotP
end


----------------------------------------------- HOOKS & EVENTS

--123456789012345
--truelch_FAB5000
local function isFAB5000(weapon)
	if type(weapon) == 'table' then
    	weapon = weapon.__Id
	end
	if weapon == nil then
		return false
	end
    local sub = string.sub(weapon, 9, 15)
    if sub == "FAB5000" then
    	return true
    end
	return false
end

local function computeFAB5000()
	--LOG("Truelch - computeFAB5000()")

    --gameData().currentMission = gameData().currentMission + 1 --is incremented in testItem.lua at game start
    local fab5000HasBeenUsedPreviousMission = gameData().currentMission - 1 == gameData().lastFab5000Use

    --LOG("Truelch - fab5000HasBeenUsedPreviousMission: " .. tostring(fab5000HasBeenUsedPreviousMission))

    --I also need to max it to one if a pilot has conservative, so I do that all the time
    --I just check inside if remaining = 0 or 1
    for i = 0, 2 do
    	--LOG("i: " .. tostring(i))
        local pawn = Board:GetPawn(i)
        if pawn ~= nil then
            local weapons = pawn:GetPoweredWeapons()
            for j = 1, 2 do
            	--LOG("j: " .. tostring(j))
                if isFAB5000(weapons[j]) then
                	--LOG("is FAB-5000!")

					--LOG("TRUELCH - BEFORE charges: " .. tostring(pawn:GetWeaponLimitedRemaining(j)))

					local remaining = 1 --max!
					if fab5000HasBeenUsedPreviousMission then
						remaining = 0

						local mission = GetCurrentMission()
						if fab5000ReloadVersion == 1 then --old
		                    --Explanation bubble
		                    local pop = VoicePopup()
		                    --pop.text = "Pick-up that FAB-5000 before the enemy!"
		                    pop.text = "Another FAB-5000 is in production. We won't be able to use it in this mission."
		                    pop.pawn = pawn:GetId()
		                    Game:AddVoicePopup(pop)

		                    --Tutorial tip	                    
	                    	if mission and not Board:IsTipImage() and not IsTestMechScenario() then
								tips:Trigger("FAB5000OldReload", pawn:GetSpace())
							end
		                else
							--Tutorial tip	                    
	                    	if mission and not Board:IsTipImage() and not IsTestMechScenario() then
								tips:Trigger("FAB5000Item", pawn:GetSpace())
							end
	                	end

	                    
					end

					pawn:SetWeaponLimitedRemaining(j, remaining)

                    --LOG("TRUELCH - AFTER charges: " .. tostring(pawn:GetWeaponLimitedRemaining(j)))
                end
            end
        end
    end
end

local function HOOK_onNextTurnHook()
	if Game:GetTeamTurn() == TEAM_PLAYER and missionData().needToCheckFAB5000 == true then
		missionData().needToCheckFAB5000 = false --test
	end

	if Game:GetTeamTurn() == TEAM_ENEMY and missionData().needToCheckFAB5000 == true then
		computeFAB5000()
	end 
end

local function HOOK_onMissionStart()
    missionData().needToCheckFAB5000 = true
end

local function HOOK_onMissionNextPhaseCreated()
    missionData().needToCheckFAB5000 = true
end

local HOOK_onSkillEnd = function(mission, pawn, weaponId, p1, p2)
	--LOG("Truelch - HOOK_onSkillEnd")
    local exit = false
        or not isGame()
        or mission == nil
        or mission == Mission_Test
        or Board == nil
        or Board:IsTipImage()

    if exit then
        return
    end

    if isFAB5000(weaponId) then
        --LOG("Truelch - FAB-5000 has been used!")
        gameData().lastFab5000Use = gameData().currentMission
    end
end

modApi.events.onPostStartGame:subscribe(function()
	--LOG("TRUELCH - onPostStartGame")
    gameData().lastFab5000Use = -10
    gameData().currentMission = 0
end)

local function EVENT_onModsLoaded()
    modApi:addMissionStartHook(HOOK_onMissionStart)
    modApi:addMissionNextPhaseCreatedHook(HOOK_onMissionNextPhaseCreated)
    modApi:addNextTurnHook(HOOK_onNextTurnHook)
    modapiext:addSkillEndHook(HOOK_onSkillEnd) --I hope that'll work
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)


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
		Friendly1 = Point(2,2),
		Building = Point(3,2),
		Target = Point(2,0),
	}
}

Weapon_Texts.truelch_FAB5000_Upgrade1 = "+2 Damage"

truelch_FAB5000_A = truelch_FAB5000:new{
	UpgradeDescription = "Deals 2 additional damage.",
	Damage = 5,
}

function truelch_FAB5000:GetTargetArea(point)
	local ret = PointList()	

	--Tips
	--[[
	local mission = GetCurrentMission()
	if mission and not Board:IsTipImage() and not IsTestMechScenario() then
		tips:Trigger("FAB5000", point)
	end
	]]

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

	--Normal use	
	local dir = GetDirection(p2 - p1)
	
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)
	
	local distance = p1:Manhattan(p2)
	
	ret:AddBounce(p1,2)

	ret:AddLeap(move, 0.25)

	ret:AddDelay(0.25)

	--FAB-5000 bomb anim
	local bombSD = SpaceDamage(p1 + DIR_VECTORS[dir]*2, 0) --mid
	bombSD.sAnimation = "truelch_fab5000"
	ret:AddDamage(bombSD)

	ret:AddDelay(0.5)
		
	--Damage was here

	--Nuke effect
	local nukeEffectSD = SpaceDamage(Point(4,4), 0)
	--nukeEffectSD.sAnimation = "truelch_nuke_fade_effect"
	nukeEffectSD.sSound = self.BombSound --test
	ret:AddDamage(nukeEffectSD)

	ret:AddBoardShake(1) --thx Hedera!

	--Blast effect
	for i = 0, 3 do
		local point = p1 + DIR_VECTORS[dir]*2 + DIR_VECTORS[i]
		local blast = SpaceDamage(point, 0)
		blast.sAnimation = "explopush2_" .. i
		ret:AddDamage(blast)
	end

	ret:AddDelay(0.25)

	--Real damage
	for k = 1, (self.Range-1) do
		if p1 + DIR_VECTORS[dir]*k == p2 then
			break
		end

		local damage = SpaceDamage(p1 + DIR_VECTORS[dir]*k, self.Damage)
		ret:AddDamage(damage)		
		ret:AddBounce(p1 + DIR_VECTORS[dir]*k,3)

		if k == 2 then --cross shape
			local damage2 = SpaceDamage(p1 + DIR_VECTORS[dir]*k + DIR_VECTORS[(dir - 1)%4], self.Damage)
			ret:AddDamage(damage2)
			ret:AddBounce(p1 + DIR_VECTORS[dir]*k + DIR_VECTORS[(dir - 1)%4],3)
			local damage3 = SpaceDamage(p1 + DIR_VECTORS[dir]*k + DIR_VECTORS[(dir + 1)%4], self.Damage)
			ret:AddDamage(damage3)
			ret:AddBounce(p1 + DIR_VECTORS[dir]*k + DIR_VECTORS[(dir + 1)%4],3)
		end
	end
	
	return ret
end