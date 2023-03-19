local resourcePath = mod_loader.mods[modApi.currentMod].resourcePath
local mechPath = resourcePath .. "img/mechs/"

local scriptPath = mod_loader.mods[modApi.currentMod].scriptPath
local mod = modApi:getCurrentMod()
--local imageOffset = modApi:getPaletteImageOffset(mod.id)
local sovietGreen = modApi:getPaletteImageOffset("truelch_SovietGreen")
local sovietRed = modApi:getPaletteImageOffset("truelch_RedAlert")

local files = {
	"m22.png",
	"m22_a.png",
	"m22_w.png",
	"m22_w_broken.png",
	"m22_broken.png",
	"m22_ns.png",
	"m22_h.png"
}

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/" .. file, mechPath .. file)
end

local a = ANIMS
a.m22 =         a.MechUnit:new{Image = "units/player/m22.png",          PosX = -13, PosY = 6 }
a.m22a =        a.MechUnit:new{Image = "units/player/m22_a.png",        PosX = -13, PosY = 6, NumFrames = 8, Lengths = { 0.1, 0.15, 0.3, 0.15, 0.1, 0.15, 0.3, 0.15 }, }
a.m22w =        a.MechUnit:new{Image = "units/player/m22_w.png",        PosX = -13, PosY = 6 }
a.m22_broken =  a.MechUnit:new{Image = "units/player/m22_broken.png",   PosX = -13, PosY = 6 }
a.m22w_broken = a.MechUnit:new{Image = "units/player/m22_w_broken.png", PosX = -13, PosY = 6 }
a.m22_ns =      a.MechIcon:new{Image = "units/player/m22_ns.png" }


truelch_SupportMech = Pawn:new{
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