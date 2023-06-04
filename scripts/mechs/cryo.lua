local resourcePath = mod_loader.mods[modApi.currentMod].resourcePath
local mechPath = resourcePath .. "img/mechs/"

local scriptPath = mod_loader.mods[modApi.currentMod].scriptPath
local mod = modApi:getCurrentMod()
--local imageOffset = modApi:getPaletteImageOffset(mod.id)
local sovietGreen = modApi:getPaletteImageOffset("truelch_SovietGreen")
local sovietRed = modApi:getPaletteImageOffset("truelch_RedAlert")

local files = {
	"kv2.png",
	"kv2_a.png",
	"kv2_w.png",
	"kv2_w_broken.png",
	"kv2_broken.png",
	"kv2_ns.png",
	"kv2_h.png"
}

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/" .. file, mechPath .. file)
end

local a = ANIMS
a.cryo_hulk =         a.MechUnit:new{Image = "units/player/kv2.png",          PosX = -15, PosY = -9 }
a.cryo_hulka =        a.MechUnit:new{Image = "units/player/kv2_a.png",        PosX = -15, PosY = -9, NumFrames = 4 }
a.cryo_hulkw =        a.MechUnit:new{Image = "units/player/kv2_w.png",        PosX = -15, PosY =  7 }
a.cryo_hulk_broken =  a.MechUnit:new{Image = "units/player/kv2_broken.png",   PosX = -15, PosY = -9 }
a.cryo_hulkw_broken = a.MechUnit:new{Image = "units/player/kv2_w_broken.png", PosX = -15, PosY =  7 }
a.cryo_hulk_ns =      a.MechIcon:new{Image = "units/player/kv2_ns.png" }

local files = {
	"cryo_hulk.png",
	"cryo_hulk_a.png",
	"cryo_hulk_w.png",
	"cryo_hulk_w_broken.png",
	"cryo_hulk_broken.png",
	"cryo_hulk_ns.png",
	"cryo_hulk_h.png"
}

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/" .. file, mechPath .. file)
end

local a = ANIMS
a.cryo_hulk =         a.MechUnit:new{Image = "units/player/cryo_hulk.png",          PosX = -20, PosY = -10 }
a.cryo_hulka =        a.MechUnit:new{Image = "units/player/cryo_hulk_a.png",        PosX = -20, PosY = -10, NumFrames = 4 }
a.cryo_hulkw =        a.MechUnit:new{Image = "units/player/cryo_hulk_w.png",        PosX = -20, PosY = 0 }
a.cryo_hulk_broken =  a.MechUnit:new{Image = "units/player/cryo_hulk_broken.png",   PosX = -20, PosY = -10 }
a.cryo_hulkw_broken = a.MechUnit:new{Image = "units/player/cryo_hulk_w_broken.png", PosX = -20, PosY = 0 }
a.cryo_hulk_ns =      a.MechIcon:new{Image = "units/player/cryo_hulk_ns.png" }


truelch_HowitzerMech = Pawn:new{	
	Name = "Howitzer Mech", --Name = "KV-2 'AT-ST'",
	Class = "Prime",
	Health = 4,
	MoveSpeed = 2,
	Image = "cryo_hulk", --"kv2"
	ImageOffset = sovietGreen,
	SkillList = { "truelch_M10THowitzerArtillery" },
	SoundLocation = "/mech/prime/smoke_mech/", --"mech/distance/artillery"
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
}