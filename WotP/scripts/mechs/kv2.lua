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
a.kv2 =         a.MechUnit:new{Image = "units/player/kv2.png",          PosX = -15, PosY = -9 }
a.kv2a =        a.MechUnit:new{Image = "units/player/kv2_a.png",        PosX = -15, PosY = -9, NumFrames = 4 }
a.kv2w =        a.MechUnit:new{Image = "units/player/kv2_w.png",        PosX = -15, PosY =  7 }
a.kv2_broken =  a.MechUnit:new{Image = "units/player/kv2_broken.png",   PosX = -15, PosY = -9 }
a.kv2w_broken = a.MechUnit:new{Image = "units/player/kv2_w_broken.png", PosX = -15, PosY =  7 }
a.kv2_ns =      a.MechIcon:new{Image = "units/player/kv2_ns.png" }


truelch_HowitzerMech = Pawn:new{
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