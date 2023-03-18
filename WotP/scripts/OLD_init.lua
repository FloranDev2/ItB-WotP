local description = "A squad of almost relic-worthy mechs, consisting of Old-Earth World War 2 technology. Even though their old age, they still pack quite a punch."
local icon = "squad_icon.png"

local function init(self)

    require(self.scriptPath .. "FURL")(self, {
	{
		Type = "mech",
		Name = "KV2",
		Filename = "kv2",
		Path = "img/mechs",
		ResourcePath = "units/player",		
		Default =           { PosX = -15, PosY = -9 },
		Animated =          { PosX = -15, PosY = -9, NumFrames = 4 },
		Submerged =         { PosX = -15, PosY =  7 }, -- x: normal, y: inverted
		Broken =            { PosX = -15, PosY = -9 },
		SubmergedBroken =   { PosX = -15, PosY =  7 },
		Icon =              {},
	},
	{
		Type = "mech",
		Name = "PE8",
		Filename = "pe8",
		Path = "img/mechs",
		ResourcePath = "units/player",		
		Default =           { PosX = -19, PosY = -7 },
		Animated =          { PosX = -19, PosY = -7, NumFrames = 4 },
		Submerged =         { PosX = -19, PosY = -7 },
		Broken =            { PosX = -19, PosY =  3 },
		SubmergedBroken =   { PosX = -19, PosY = -2 },
		Icon =              {},
	},
	{
		Type = "mech",
		Name = "M22",
		Filename = "m22",
		Path = "img/mechs",
		ResourcePath = "units/player",		
		Default =           { PosX = -13, PosY = 6 },
		Animated =          { PosX = -13, PosY = 6, NumFrames = 8, Lengths = { 0.1, 0.15, 0.3, 0.15, 0.1, 0.15, 0.3, 0.15 }, }, --good but causes bug
		Submerged =         { PosX = -13, PosY = 6 },
		Broken =            { PosX = -13, PosY = 6 },
		SubmergedBroken =   { PosX = -13, PosY = 6 },
		Icon =              {},
	},
	});

	--Palettes
	modApi:addPalette
	{
		ID = "RedAlert",
		Name = "Red Alert",
		Image = "img/units/player/kv2_ns.png", --WORKS! you need to put the path that's within the resource.dat, not from the original mod folder
		PlateHighlight =	{ 239, 203,  63 }, --lights
		PlateLight =		{ 173,  72,  62 }, --main highlight
		PlateMid =			{ 122,  25,  24 }, --main light
		PlateDark =			{  63,  23,  18 }, --main mid
		PlateOutline =		{  31,  11,  9 }, --main dark
		BodyHighlight =		{  72,  76,  73 }, --metal light
		BodyColor =			{  47,  51,  48 }, --metal mid
		PlateShadow =		{  24,  25,  24 }, --metal dark 
	}
	modApi:addPalette
	{
		ID = "SovietGreen",
		Name = "Soviet Green",			
		Image = "img/units/player/m22_ns.png", --WORKS! you need to put the path that's within the resource.dat, not from the original mod folder
		PlateHighlight =	{ 255, 161,  73 }, --lights
		PlateLight =		{ 107,  95,  65 }, --main highlight
		PlateMid =			{  71,  62,  41 }, --main light
		PlateDark =			{  43,  39,  20 }, --main mid
		PlateOutline =		{  21,  21,  10 }, --main dark
		BodyHighlight =		{ 143, 153, 151 }, --metal light
		BodyColor =			{  67,  72,  68 }, --metal mid
		PlateShadow =		{  34,  36,  34 }, --metal dark 
	}

    --modApiExt
	if modApiExt then
	    -- modApiExt already defined. This means that the user has the complete
	    -- ModUtils package installed. Use that instead of loading our own one.
	    truelch_ww2_ModApiExt = modApiExt
	else
	    -- modApiExt was not found. Load our inbuilt version
	    local extDir = self.scriptPath .. "modApiExt/"
	    truelch_ww2_ModApiExt = require(extDir .. "modApiExt")
	    truelch_ww2_ModApiExt:init(extDir)
	end

	--LApi!
	require(self.scriptPath .. "LApi/LApi")

	--new non massive deployment
	require(self.scriptPath .. "libs/detectDeployment")
	require(self.scriptPath .. "libs/blockDeathByDeployment")

	--Pawns
	require(self.scriptPath .. "pawns")

	-- FMW ----->
	--modapi already defined
	self.FMW_hotkeyConfigTitle = "Mode Selection Hotkey" -- title of hotkey config in mod config
	self.FMW_hotkeyConfigDesc = "Hotkey used to open and close firing mode selection." -- description of hotkey config in mod config

	--init FMW
	require(self.scriptPath .. "fmw/FMW"):init()
	-- <----- FMW

	--Weapons
	require(self.scriptPath .. "weapons/m10t")
	require(self.scriptPath .. "weapons/fab500")
	require(self.scriptPath .. "weapons/fab5000") --my old solution. Less elegant
	--require(self.scriptPath .. "weapons/Old/fab5000V3") --modified Lemonymous solution (uh oh, normal pilots are inactive with it!!)
	require(self.scriptPath .. "weapons/FMm6Gun") --FMW

	--Arc
	require(self.scriptPath .. "libs/artilleryArc")

	--Achievements
	require(self.scriptPath .. "achievements") --Squad achievements	
	require(self.scriptPath .. "globalAchievements") --Global achievements
	
	--Weapons' images
	modApi:appendAsset("img/weapons/prime_m10thowitzer.png",    self.resourcePath .. "img/weapons/prime_m10thowitzer.png")
	modApi:appendAsset("img/weapons/brute_fab500.png",          self.resourcePath .. "img/weapons/brute_fab500.png")
	modApi:appendAsset("img/weapons/brute_fab5000.png",         self.resourcePath .. "img/weapons/brute_fab5000.png")
	modApi:appendAsset("img/weapons/science_canisterround.png", self.resourcePath .. "img/weapons/science_canisterround.png")

	--Projectiles' effects
	modApi:appendAsset("img/effects/shotup_kv2_missile2.png", self.resourcePath .. "img/effects/shotup_kv2_missile2.png")
	
	--Weapons' texts
	modApi:addWeapon_Texts(require(self.scriptPath .. "text_weapons"))

	--New shop
	modApi:addWeaponDrop("Prime_M10THowitzerArtillery")
	modApi:addWeaponDrop("Brute_FAB500")
	modApi:addWeaponDrop("Brute_FAB5000")
	modApi:addWeaponDrop("Brute_FAB5000V3")
	modApi:addWeaponDrop("truelch_M6Gun")

	--Custom main menu config
	require(self.scriptPath .. "truelchSave/truelchSave"):init(self)
end


local function load(self, options, version)
	--Custom main menu config
	require(self.scriptPath .. "truelchSave/truelchSave"):load(self, options)

	--modApiExt
	truelch_ww2_ModApiExt:load(self, options, version)

	--FMW
	require(self.scriptPath .. "fmw/FMW"):load()

	--Add squad
	--The first info is about your squad. (Lemonymous)
	modApi:addSquadTrue(
		{
			id = "truelch_ww2", --to link with achievements!
			"Weapons of the Past",
			"KV2",
			"PE8",
			"M22"
		},
		"Weapons of the Past",
		description,
		self.resourcePath .. icon
	)
end

--The second info is about your mod. (Lemonymous)
return {
    id = "truelch_ww2",
    name = "Weapons of the Past",
    version = "2.0.0",
    init = init,
    load = load,

    --fmw
    requirements = { "kf_ModUtils" },
    icon = "mod_icon.png",
}

--Lemonymous explanations: A mod can have several squads, so they are separate entities.