--Still works?
local sovietGreen = modApi:getPaletteImageOffset("SovietGreen")
local sovietRed = modApi:getPaletteImageOffset("RedAlert")

-- KV2 = {
truelch_HowitzerMech = {
	--Name = "KV-2 'AT-ST'",
	Name = "Howitzer Mech",
	Class = "Prime",
	Health = 4,
	MoveSpeed = 2,
	Image = "KV2",
	ImageOffset = sovietGreen,
	SkillList = { "Prime_M10THowitzerArtillery" },
	SoundLocation = "mech/distance/artillery",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}

AddPawn("truelch_HowitzerMech")

--PE8 = {
truelch_HeavyBomber = {
	--Name = "Pe-8",
	Name = "Heavy Bomber Mech",
	Class = "Brute",
	Health = 3,
	MoveSpeed = 3,
	Image = "PE8",
	ImageOffset = sovietGreen,
	--SkillList = { "Brute_FAB500", "Brute_FAB5000" },
	SkillList = { "Brute_FAB500" },
	SoundLocation = "mech/distance/artillery", --TODO
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Flying = true,	
}

AddPawn("truelch_HeavyBomber")

truelch_SupportMech = {
	--Name = "M22 Locust",
	Name = "Support Mech",
	Class = "Science",
	Health = 2,
	MoveSpeed = 4,
	Image = "M22",
	ImageOffset = sovietGreen,
	--SkillList = { "truelch_M6Gun" },
	SkillList = { },
	SoundLocation = "mech/distance/artillery", --TODO
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	IgnoreSmoke = true,
	--
	Tank = true, --test
}

AddPawn("truelch_SupportMech")