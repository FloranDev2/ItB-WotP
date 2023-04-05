local this = {}
local path = mod_loader.mods[modApi.currentMod].scriptPath
local resources = mod_loader.mods[modApi.currentMod].resourcePath

--Icons
modApi:appendAsset("img/shells/icon_standard_shell.png", resources .. "img/shells/icon_standard_shell.png")
modApi:appendAsset("img/shells/icon_smoke_shell.png",    resources .. "img/shells/icon_smoke_shell.png")

--Effects
modApi:appendAsset("img/effects/shot_m22_push_R.png",  resources .. "img/effects/shot_m22_push_R.png")
modApi:appendAsset("img/effects/shot_m22_push_U.png",  resources .. "img/effects/shot_m22_push_U.png")
modApi:appendAsset("img/effects/shot_m22_smoke_R.png", resources .. "img/effects/shot_m22_smoke_R.png")
modApi:appendAsset("img/effects/shot_m22_smoke_U.png", resources .. "img/effects/shot_m22_smoke_U.png")

truelch_TC_M6Gun = TankDefault:new{
	Name = "M6 Gun",
	Class = "Science",
	Description = "Versatile non-damaging gun that shoots either smoke or push shells.\nSecond click behind the target pushes it, otherwise, smokes it.",
	Icon = "weapons/science_canisterround.png",
	Rarity = 1,

	LaunchSound = "/weapons/back_shot",
	ImpactSound = "/impact/generic/explosion_large",
	ProjectileArtSmoke = "effects/shot_m22_smoke",
	ProjectileArtPush = "effects/shot_m22_push",
	Explo = "explopush1_",

	PowerCost = 0,
	Damage = 0,

	TwoClick = true,
	ZoneTargeting = DIR,

	Upgrades = 1,
	UpgradeCost = { 1 },

	TipImage = {
		Unit = Point(2, 3),
		Enemy = Point(2, 1),
		Target = Point(2, 1),
		Second_Click = Point(2, 0),
	}
}

Weapon_Texts.truelch_TC_M6Gun_Upgrade1 = "+1 Damage"

truelch_TC_M6Gun_A = truelch_TC_M6Gun:new{
	UpgradeDescription = "Both shells now deal 1 damage.",
	Damage = 1,
}

function truelch_TC_M6Gun:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p2, 0)
	local direction = GetDirection(p2 - p1)
	ret:AddDamage(damage)
	return ret
end

function truelch_TC_M6Gun:GetSecondTargetArea(p1, p2)
	local ret = PointList()
	local direction = GetDirection(p2 - p1)

	ret:push_back(p2)
	if Board:IsValid(p2 + DIR_VECTORS[direction]) then
		ret:push_back(p2 + DIR_VECTORS[direction])
	end
	
	return ret
end

function truelch_TC_M6Gun:GetFinalEffect(p1, p2, p3)
	local ret = SkillEffect()
	local target = GetProjectileEnd(p1, p2, PATH_PROJECTILE)
	local damage = SpaceDamage(target, self.Damage)

	if p3 == p2 then
		damage.iSmoke = 1
		ret:AddProjectile(damage, self.ProjectileArtSmoke)
	else
		local dir = GetDirection(p2 - p1)
		damage.iPush = dir
		damage.sAnimation = self.Explo .. dir
		ret:AddProjectile(damage, self.ProjectileArtPush)
	end

	return ret	
end