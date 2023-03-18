-- M10T Howitzer
Prime_M10THowitzerArtillery = LineArtillery:new{
	--New! (for the shop)
	Name = "M-10T Howitzer",
	Description = "A powerful cannon that deals an amount of damage equals to half of target's remaining HP (rounded up) and ignore its armor.\nMax range: 3.",
	--
	Class = "Prime",
	Damage = 2,
	PowerCost = 1, --was 2 before AE
	LaunchSound = "/weapons/modified_cannons",
	ImpactSound = "/impact/generic/explosion",
	Icon = "weapons/prime_m10thowitzer.png",
	UpShot = "effects/shot_artimech.png",
	Explosion = "",
	BounceAmount = 2,
	Upgrades = 1,
	UpgradeCost = { 3 },
	--Custom
	BonusDamage = 0,
	MaxRange = 3,
	Push = 1,
	Rarity = 3,
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

function Prime_M10THowitzerArtillery:GetTargetArea(point)
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

function Prime_M10THowitzerArtillery:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	ret:AddBounce(p1, 1)

	local totalDmg = self.Damage
	local targetPawn = Board:GetPawn(p2)

	if targetPawn ~= nil then
		--damage = 50% HP target
		local targetHp = targetPawn:GetHealth()
		totalDmg = math.ceil(0.5 * targetHp)

		--armor penetration
		if targetPawn:IsArmor() then
			totalDmg = totalDmg + 1
		end
	end

	--Bonus damage (2nd upgrade)
	totalDmg = totalDmg + self.BonusDamage

	local damage = SpaceDamage(p2, totalDmg)

	if (self.Push == 1) then
		damage.iPush = direction
		damage.sAnimation = "explopush2_" .. direction
	end

	ret:AddArtillery(p1, damage, "effects/shotup_kv2_missile2.png")

	--bounce
	ret:AddBounce(p2, self.BounceAmount)
	
	return ret
end



Prime_M10THowitzerArtillery_A = Prime_M10THowitzerArtillery:new{
	BonusDamage = 1,
}