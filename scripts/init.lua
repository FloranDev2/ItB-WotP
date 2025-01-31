local mod = {
	id = "truelch_WotP",
	name = "Weapons of the Past",
	icon = "img/mod_icon.png",
	version = "2.1.4",
	modApiVersion = "2.9.1",
	gameVersion = "1.2.88",
	--submodFolders = {"itb_truelch_mark/"},
    dependencies = {
        modApiExt = "1.17",
		memedit = "1.0.1",
    }
}

--Doesn't work...
function mod:metadata()
	--Move it from metadata, it didn't work there
	modApi:addGenerationOption(
		"resetTutorials",
		"Reset Tutorial Tooltips",
		"Check to reset all tutorial tooltips for this profile.",
		{ enabled = false }
	)
end

function mod:init()	
	-- Assets
	require(self.scriptPath .. "assets")
	require(self.scriptPath .. "palettes")

	-- Achievements
	require(self.scriptPath .. "achievements")
	require(self.scriptPath .. "globalAchievements")

	-- Libs
	require(self.scriptPath .. "libs/artilleryArc")
	require(self.scriptPath .. "libs/blockDeathByDeployment")
	require(self.scriptPath .. "libs/boardEvents")

	-- FMW ----->
	--modapi already defined
	self.FMW_hotkeyConfigTitle = "Mode Selection Hotkey" -- title of hotkey config in mod config
	self.FMW_hotkeyConfigDesc = "Hotkey used to open and close firing mode selection." -- description of hotkey config in mod config

	--init FMW
	require(self.scriptPath .. "fmw/FMW"):init()
	-- <----- FMW

	-- Pawns (moved them before weapon so that M6 Gun can be injected)
	require(self.scriptPath .. "mechs/kv2")
	require(self.scriptPath .. "mechs/pe8")
	require(self.scriptPath .. "mechs/m22")

	-- Weapons
	require(self.scriptPath .. "weapons/fab500")
	require(self.scriptPath .. "weapons/fab5000")
	require(self.scriptPath .. "weapons/m6gun")
	require(self.scriptPath .. "weapons/m10t")

	-- Shop
	modApi:addWeaponDrop("truelch_M10THowitzerArtillery")
	modApi:addWeaponDrop("truelch_FAB500")
	modApi:addWeaponDrop("truelch_FAB5000")
	modApi:addWeaponDrop("truelch_FMW_M6Gun") --modApi:addWeaponDrop("truelch_M6Gun")

	--Item
	require(self.scriptPath .. "itemFAB5000")
	TILE_TOOLTIPS.Item_FAB5000_Text = {"FAB-5000's ammunition", "Pick it up to recharge the FAB-5000 or secure it for the next mission."}

	--Tutorial tips
	require(self.scriptPath .. "tips")

	-- --- MOD OPTIONS ---
	--KV-2's Howitzer option (also putting it here so it got reloaded once changed)
	modApi:addGenerationOption("option_piercingIcon",
		"Show armor piercing icon?",
		"Enable to see the armor piercing icon for the Howitzer.",
		{enabled = true}
	)

	--FAB-5000 reload mechanic
	modApi:addGenerationOption("option_fab5000Reload",
		"FAB-5000 reload version",
		"Mission cooldown: you need to wait a mission to be able to use the FAB-5000 again.\n\nPick-up item: you can retrieve the FAB-5000 to use it, but enemies can also destroy it!",
		{
			values = {1,2},
			value = 2,
			strings = { "Mission cooldown", "Pick-up item" }
		}
	)

	-- Custom main menu config
	require(self.scriptPath .. "truelchSave/truelchSave"):init(self)
end

function mod:load(options, version)
	-- Custom main menu config
	require(self.scriptPath .. "truelchSave/truelchSave"):load(self, options)

	-- FMW
	require(self.scriptPath .. "fmw/FMW"):load()

	modApi:addSquad(
		{
			id = "truelch_WotP",
			"Weapons of the Past",
			"truelch_HowitzerMech", -- KV2
			"truelch_HeavyBomberMech", -- Pe8
			"truelch_SupportMech", -- M22
		},
		"Weapons of the Past",
		"A squad of almost relic-worthy mechs, consisting of Old-Earth World War 2 technology. Even though their old age, they still pack quite a punch.",
		self.resourcePath .. "img/squad_icon.png"
	)

	--Test reset tutorials
	if options.resetTutorials and options.resetTutorials.enabled then
		require(self.scriptPath .."libs/tutorialTips"):ResetAll()
		options.resetTutorials.enabled = false
	end
end

return mod