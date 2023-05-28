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
	UpShot = "effects/shotup_kv2_missile2.png",
	Explosion = "explopush2_", --""
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
	UpgradeDescription = "Deals 1 additional damage.",
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

	LOG("A")
	
	ret:AddBounce(p1, 1)

	LOG("B")

	local damage = SpaceDamage(p2)

	LOG("C")

	local totalDmg = self.Damage
	local targetPawn = Board:GetPawn(p2)

	LOG("D")

	if targetPawn ~= nil then
		--damage = 50% HP target
		local targetHp = targetPawn:GetHealth()

		LOG("D1")

		totalDmg = math.ceil(0.5 * targetHp)

		LOG("D2")

		--armor penetration
		if targetPawn:IsArmor() then
			LOG("D2A")
			totalDmg = totalDmg + 1

			LOG("D2B")

			if showIcon == true then
				damage.sImageMark = "combat/icons/icon_armor_piercing.png"
			end
			LOG("D2C")
		end
	end

	LOG("E")

	--Bonus damage (upgrade)
	totalDmg = totalDmg + self.BonusDamage

	LOG("F")

	damage.iDamage = totalDmg

	LOG("G")

	if (self.Push == 1) then
		LOG("G1")
		damage.iPush = direction
		LOG("G2")
		--damage.sAnimation = "explopush2_" .. direction
		damage.sAnimation = self.Explosion .. direction
		LOG("G3")
	end

	LOG("H")

	--local damage = SpaceDamage(p2, self.Damage)
	--ret:AddArtillery(damage,"effects/shotdown_rock.png")

	--ret:AddArtillery(p1, damage, "effects/shotup_kv2_missile2.png")
	--ret:AddArtillery(p1, damage, self.UpShot)
	ret:AddArtillery(damage, self.UpShot)

	LOG("I")

	--bounce
	ret:AddBounce(p2, self.BounceAmount)

	LOG("J")
	
	return ret
end

