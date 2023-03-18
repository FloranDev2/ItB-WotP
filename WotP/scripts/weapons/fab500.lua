--FAB-500
truelch_FAB500 = Skill:new{
	Name = "FAB-500",
	Description = "Fly over a target, dropping a powerful bomb that damages and pulls it.",
	Class = "Brute",
	Icon = "weapons/brute_fab500.png",
	Rarity = 2,
	AttackAnimation = "ExploRaining1",
	Sound = "/general/combat/stun_explode",
	MinMove = 2,
	Range = 2,
	Damage = 2,
	Damage2 = 2,
	AnimDelay = 0.2,
	PowerCost = 0,
	DoubleAttack = 0, --does it attack again after stopping moving
	Upgrades = 2,
	UpgradeCost = { 2, 2 },
	LaunchSound = "/weapons/bomb_strafe",
	BombSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Target = Point(2,1)
	}
}

Weapon_Texts.truelch_FAB500_Upgrade1 = "+1 Range"
Weapon_Texts.truelch_FAB500_Upgrade2 = "+1 Range"

truelch_FAB500_A = truelch_FAB500:new{
	UpgradeDescription = "Allows dropping payload on 1 more tile per strike. (Powering both upgrades add incendiary effect to the attack)"
	Range = 3, 
	TipImage = {
		Unit   = Point(2,3),
		Enemy  = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,0)
	}
}

truelch_FAB500_B = truelch_FAB500:new{
	UpgradeDescription = "Allows dropping payload on 1 more tile per strike. (Powering both upgrades add incendiary effect to the attack)"
	Range = 3, 
	TipImage = {
		Unit   = Point(2,3),
		Enemy  = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,0)
	}
}

truelch_FAB500_AB = truelch_FAB500:new{
	Range = 4, 
	Fire = 1,
	AttackAnimation = "ExploRaining2",
	TipImage = {
		Unit   = Point(2,4),
		Enemy  = Point(2,3),
		Enemy2 = Point(2,2),
		Enemy3 = Point(2,1),
		Target = Point(2,0)
	}
}

function truelch_FAB500:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		for k = self.MinMove, self.Range do
			if not Board:IsBlocked(DIR_VECTORS[i]*k + point, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + point)
			end
		end
	end
	
	return ret
end

function truelch_FAB500:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)
	
	local distance = p1:Manhattan(p2)
	
	ret:AddBounce(p1,2)
	if distance == 1 then
		ret:AddLeap(move, 0.5)--small delay between move and the damage, attempting to make the damage appear when jet is overhead
	else
		ret:AddLeap(move, 0.25)
	end
		
	--LOG("self.Range: " .. self.Range)
	for k = 1, (self.Range-1) do

		--LOG("k: " .. k)
		
		if p1 + DIR_VECTORS[dir]*k == p2 then
			break
		end

		--damage
		local pullDir = GetDirection(p1 - p2)
		local damage = SpaceDamage(p1 + DIR_VECTORS[dir]*k, self.Damage, pullDir) --has pull directly in the main damage
		damage.iFire = self.Fire --new!		
		damage.sAnimation = self.AttackAnimation
		damage.sSound = self.BombSound
		ret:AddDamage(damage)

		--bounce
		ret:AddBounce(p1 + DIR_VECTORS[dir]*k,3)

		ret:AddDelay(0.2)
	end
	
	if self.DoubleAttack == 1 then
		ret:AddDamage(SpaceDamage(p1 + DIR_VECTORS[dir]*(self.Range+1), self.Damage2))
	end
	
	
	return ret
end