local resourcePath = mod_loader.mods[modApi.currentMod].resourcePath
local mechPath = resourcePath .. "img/mechs/"

local scriptPath = mod_loader.mods[modApi.currentMod].scriptPath
local mod = modApi:getCurrentMod()
--local imageOffset = modApi:getPaletteImageOffset(mod.id)
local sovietGreen = modApi:getPaletteImageOffset("truelch_SovietGreen")
local sovietRed = modApi:getPaletteImageOffset("truelch_RedAlert")

local files = {
	"pe8.png",
	"pe8_a.png",
	"pe8_w.png",
	"pe8_w_broken.png",
	"pe8_broken.png",
	"pe8_ns.png",
	"pe8_h.png"
}

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/" .. file, mechPath .. file)
end

local a = ANIMS
a.pe8 =         a.MechUnit:new{Image = "units/player/pe8.png",          PosX = -15, PosY = -9 }
a.pe8a =        a.MechUnit:new{Image = "units/player/pe8_a.png",        PosX = -15, PosY = -9, NumFrames = 4 }
a.pe8w =        a.MechUnit:new{Image = "units/player/pe8_w.png",        PosX = -15, PosY =  7 }
a.pe8_broken =  a.MechUnit:new{Image = "units/player/pe8_broken.png",   PosX = -15, PosY = -9 }
a.pe8w_broken = a.MechUnit:new{Image = "units/player/pe8_w_broken.png", PosX = -15, PosY =  7 }
a.pe8_ns =      a.MechIcon:new{Image = "units/player/pe8_ns.png" }


truelch_HeavyBomberMech = {
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

AddPawn("truelch_HeavyBomberMech")