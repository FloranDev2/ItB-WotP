local this = {}
local path = mod_loader.mods[modApi.currentMod].scriptPath
local resources = mod_loader.mods[modApi.currentMod].resourcePath

local fmw = require(path .. "fmw/api") 

--Libs
local tips = require(path .. "libs/tutorialTips")

--Icons
modApi:appendAsset("img/shells/icon_standard_shell.png", resources .. "img/shells/icon_standard_shell.png")
modApi:appendAsset("img/shells/icon_smoke_shell.png",    resources .. "img/shells/icon_smoke_shell.png")

--Effects
modApi:appendAsset("img/effects/shot_m22_push_R.png",  resources .. "img/effects/shot_m22_push_R.png")
modApi:appendAsset("img/effects/shot_m22_push_U.png",  resources .. "img/effects/shot_m22_push_U.png")
modApi:appendAsset("img/effects/shot_m22_smoke_R.png", resources .. "img/effects/shot_m22_smoke_R.png")
modApi:appendAsset("img/effects/shot_m22_smoke_U.png", resources .. "img/effects/shot_m22_smoke_U.png")
	
truelch_ShellStd = {
	aFM_name = "Push Shell",							-- required
	aFM_desc = "Projectile that pushes its target.",	-- required
	aFM_icon = "img/shells/icon_standard_shell.png",	-- required (if you don't have an image an empty string will work)
	--Custom
	Push = 1,
	Smoke = 0,
	--Art
	impactsound = "/impact/generic/explosion_large",
	Explo = "explopush1_",
	ProjectileArt = "effects/shot_m22_push", --ProjectileArt = "effects/shot_mechtank",
}

CreateClass(truelch_ShellStd)

-- these functions, "targeting" and "fire," are arbitrary
function truelch_ShellStd:targeting(point)
	local points = {}
	
	for dir = 0, 3 do
		for i = 1, 8 do
			local curr = point + DIR_VECTORS[dir] * i

			if not Board:IsValid(curr) then --non valid points are point outside the map [0;7]
				break
			end

			points[#points+1] = curr

			if Board:IsBlocked(curr, PATH_PROJECTILE) then
				break
			end
		end
	end	

	return points
end

function truelch_ShellStd:fire(p1, p2, ret, dmg)
	local dir = GetDirection(p2 - p1)

	local target = GetProjectileEnd(p1, p2)

	if self.Push == 1 then
		local damage = SpaceDamage(target, dmg, dir)
		ret:AddProjectile(damage, self.ProjectileArt)
	else
		local damage = SpaceDamage(target, dmg)
		damage.iSmoke = 1
		ret:AddProjectile(damage, self.ProjectileArt)
	end
end

function truelch_ShellStd:GetProjectileEnd(p1, p2)
	profile = PATH_PROJECTILE
	local direction = GetDirection(p2 - p1)

	local target = p1 + DIR_VECTORS[direction]

	while not Board:IsBlocked(target, profile) do
		target = target + DIR_VECTORS[direction]
	end

	if not Board:IsValid(target) then
		target = target - DIR_VECTORS[direction]
	end
	
	return target
end

truelch_ShellSmoke = truelch_ShellStd:new{
	aFM_name = "Smoke Shell",
	aFM_desc = "Non-explosive shell that creates Smoke.",
	aFM_icon = "img/shells/icon_smoke_shell.png",	
	--Custom
	Push = 0,
	Smoke = 1,
	--Art
	impactsound = "/impact/generic/explosion_large",
	Explo = "explopush1_",
	ProjectileArt = "effects/shot_m22_smoke",
}

truelch_M6Gun = aFM_WeaponTemplate:new{
	Name = "M6 Gun",
	Description = "Versatile non-damaging gun that shoots either smoke or push shells.\nTo switch shell, arm the weapon and click on the shell icon on the right.",
	Class = "Science",
	Upgrades = 1,
	UpgradeCost = { 1 },
	Icon = "weapons/science_canisterround.png",
	--Icon = "science_canisterround.png", 	--Icon = "/weapons/science_canisterround.png",
	LaunchSound = "/weapons/back_shot",
	aFM_ModeList = {"truelch_ShellStd", "truelch_ShellSmoke"},
	aFM_ModeSwitchDesc = "Click to change shells.",

	--Custom!
	TipImage = StandardTips.Ranged,
	PowerCost = 0, --Setting it works (I set it to 0 because it's the value I want, but it works!)
	Damage = 0,
	Rarity = 1,
}
Weapon_Texts.truelch_M6Gun_Upgrade1 = "+1 Damage"

truelch_M6Gun_A = truelch_M6Gun:new{
	UpgradeDescription = "Both shells now deal 1 damage.",
	Damage = 1,
}

function truelch_M6Gun:GetTargetArea(point)
	--LOG("truelch_M6Gun:GetTargetArea")
	local pl = PointList()

	--Tutorial tip
	local mission = GetCurrentMission()
	if mission and not Board:IsTipImage() and not IsTestMechScenario() then
		tips:Trigger("M6GunFMW", point)
	end

	--LOG("A")
	local currentShell = _G[self:FM_GetMode(point)]
	--LOG("B")
	if self:FM_CurrentModeReady(point) then
		--LOG("C")
		local points = currentShell:targeting(point)
		--LOG("D")
		for _, p in ipairs(points) do
			--LOG("E: " .. p:GetString())
			pl:push_back(p)
		end
		--LOG("F")
	end
	--LOG("G") 
	return pl
end

function truelch_M6Gun:GetSkillEffect(p1, p2)
	local se = SkillEffect()
	local currentShell = self:FM_GetMode(p1)
	
	if self:FM_CurrentModeReady(p1) then 
		_G[currentShell]:fire(p1, p2, se, self.Damage)
	end

	return se
end

return this 