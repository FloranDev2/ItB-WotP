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
a.pe8 =         a.MechUnit:new{Image = "units/player/pe8.png",          PosX = -19, PosY = -7 }
a.pe8a =        a.MechUnit:new{Image = "units/player/pe8_a.png",        PosX = -19, PosY = -7, NumFrames = 4 }
a.pe8w =        a.MechUnit:new{Image = "units/player/pe8_w.png",        PosX = -19, PosY = -7 }
a.pe8_broken =  a.MechUnit:new{Image = "units/player/pe8_broken.png",   PosX = -19, PosY =  3 }
a.pe8w_broken = a.MechUnit:new{Image = "units/player/pe8_w_broken.png", PosX = -19, PosY = 15 } --PosX = -19, PosY = -2
a.pe8_ns =      a.MechIcon:new{Image = "units/player/pe8_ns.png" }


truelch_HeavyBomberMech = {	
	Name = "Heavy Bomber Mech", --Name = "Pe-8",
	Class = "Brute",
	Health = 3,
	MoveSpeed = 3,
	Image = "pe8",
	ImageOffset = sovietGreen,
	SkillList = { "truelch_FAB500", "truelch_FAB5000" },
	SoundLocation = "/support/support_drone/", --/support/support_drone/ --/support/helicopter/
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Flying = true,
}

AddPawn("truelch_HeavyBomberMech")