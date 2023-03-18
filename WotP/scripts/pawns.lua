local sovietGreen = modApi:getPaletteImageOffset("SovietGreen")
local sovietRed = modApi:getPaletteImageOffset("RedAlert")

KV2 = {
	Name = "KV-2 'AT-ST'",
	Class = "Prime",
	Health = 4, --Intended to reduce to 3, but the Pe-8 nerfs are maybe enough
	MoveSpeed = 2,
	Image = "KV2",
	ImageOffset = sovietGreen,
	SkillList = { "Prime_M10THowitzerArtillery" },
	SoundLocation = "mech/distance/artillery",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}

AddPawn("KV2")

PE8 = {
	Name = "Pe-8",
	Class = "Brute",
	Health = 3,
	MoveSpeed = 3,
	Image = "PE8",
	ImageOffset = sovietGreen,
	SkillList = { "Brute_FAB500", "Brute_FAB5000" },
	SoundLocation = "mech/distance/artillery",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Flying = true,	
}

AddPawn("PE8")

M22 = {
	Name = "M22 Locust",
	Class = "Science",
	Health = 2,
	MoveSpeed = 4,
	Image = "M22",
	ImageOffset = sovietGreen,
	SkillList = { "truelch_M6Gun" },
	SoundLocation = "mech/distance/artillery",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	IgnoreSmoke = true,
	--
	Tank = true, --test
}

AddPawn("M22")