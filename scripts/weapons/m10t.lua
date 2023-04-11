local mod = mod_loader.mods[modApi.currentMod]
local showIcon

modApi.events.onModLoaded:subscribe(function(id)
	if id ~= mod.id then return end
	local options = mod_loader.currentModContent[id].options
	showIcon = options["option_piercingIcon"].enabled
	--LOG("---------------- showIcon: " .. tostring(showIcon) .. ", type: " .. tostring(type(showIcon)))
end)


-- M10T Howitzer
truelch_M10THowitzerArtillery = LineArtillery:new{
	Name = "M-10T Howitzer",
	Description = "A powerful cannon that deals an amount of damage equals to half of target's remaining HP (rounded up) and ignore its armor.\nMax range: 3.",
	Class = "Prime",
	Icon = "weapons/prime_m10thowitzer.png",
	Rarity = 3,
	Damage = 2,
	PowerCost = 1,
	LaunchSound = "/weapons/modified_cannons",
	ImpactSound = "/impact/generic/explosion",	
	UpShot = "effects/shot_artimech.png",
	Explosion = "",
	BounceAmount = 2,
	Upgrades = 1,
	UpgradeCost = { 3 },
	--Custom
	BonusDamage = 0,
	MaxRange = 3,
	Push = 1,
	--Custom height
	ArtilleryHeight = 10,
	--TipImage
	TipImage = {
		Unit = Point(2, 3),
		Enemy = Point(2, 2),
		Target = Point(2,2),
		Second_Target = Point(2,1),
		Second_Origin = Point(2,3),
	}
}

Weapon_Texts.truelch_M10THowitzerArtillery_Upgrade1 = "+1 Damage"

truelch_M10THowitzerArtillery_A = truelch_M10THowitzerArtillery:new{
	BonusDamage = 1,
}

function truelch_M10THowitzerArtillery:GetTargetArea(point)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for i = 1, self.MaxRange do
			local curr = Point(point + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then
				break
			end
			
			if not self.OnlyEmpty or not Board:IsBlocked(curr,PATH_GROUND) then
				ret:push_back(curr)
			end

		end
	end
	
	return ret
end

function truelch_M10THowitzerArtillery:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	ret:AddBounce(p1, 1)

	local damage = SpaceDamage(p2)

	local totalDmg = self.Damage
	local targetPawn = Board:GetPawn(p2)

	if targetPawn ~= nil then
		--damage = 50% HP target
		local targetHp = targetPawn:GetHealth()
		totalDmg = math.ceil(0.5 * targetHp)

		--armor penetration
		if targetPawn:IsArmor() then
			totalDmg = totalDmg + 1

			if showIcon == true then
				damage.sImageMark = "combat/icons/icon_armor_piercing.png"
			end
		end
	end

	--Bonus damage (upgrade)
	totalDmg = totalDmg + self.BonusDamage

	damage.iDamage = totalDmg

	if (self.Push == 1) then
		damage.iPush = direction
		damage.sAnimation = "explopush2_" .. direction
	end

	ret:AddArtillery(p1, damage, "effects/shotup_kv2_missile2.png")

	--bounce
	ret:AddBounce(p2, self.BounceAmount)
	
	return ret
end

