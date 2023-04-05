local mod = {
	id = "truelch_WotP",
	name = "Weapons of the Past",
	icon = "img/mod_icon.png",
	version = "2.0.3",
	modApiVersion = "2.9.1",
	gameVersion = "1.2.88",
    dependencies = {
        modApiExt = "1.17",
		memedit = "1.0.1",
    }--,
    --metadata = metadata, --inspired from NamesAreHard's NN
}

function mod:init()	
	-- Assets
	require(self.scriptPath .. "images")
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

	-- Weapons
	require(self.scriptPath .. "weapons/fab500")
	require(self.scriptPath .. "weapons/fab5000")
	require(self.scriptPath .. "weapons/FMm6Gun")
	--require(self.scriptPath .. "weapons/m6gun")
	require(self.scriptPath .. "weapons/m10t")

	-- Pawns
	require(self.scriptPath .. "mechs/kv2")
	require(self.scriptPath .. "mechs/pe8")
	require(self.scriptPath .. "mechs/m22")

	-- Shop
	modApi:addWeaponDrop("truelch_M10THowitzerArtillery")
	modApi:addWeaponDrop("truelch_FAB500")
	modApi:addWeaponDrop("truelch_FAB5000")
	modApi:addWeaponDrop("truelch_M6Gun")
	--modApi:addWeaponDrop("truelch_TC_M6Gun")

	--Item
	require(self.scriptPath .. "itemFAB5000")
	TILE_TOOLTIPS.Item_FAB5000_Text = {"FAB-5000's ammunition", "Pick it up to recharge the FAB-5000 or secure it for the next mission."}

	--Tutorial tips
	require(self.scriptPath .. "tips")
	--Move it from metadata, it didn't work there
	modApi:addGenerationOption(
		"resetTutorials",
		"Reset Tutorial Tooltips",
		"Check to reset all tutorial tooltips for this profile.",
		{ enabled = false }
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

--Doesn't work...
function mod:metata()
	LOG("TRUELCH - metadata")
	--Moved that to init
	--I've let the debug in case I see it, but it doesn't seem to work
	--[[
	modApi:addGenerationOption(
		"resetTutorials",
		"Reset Tutorial Tooltips",
		"Check to reset all tutorial tooltips for this profile.",
		{ enabled = false }
	)
	]]
end

return mod