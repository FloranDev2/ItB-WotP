local mod = mod_loader.mods[modApi.currentMod]
--local modApiExt = LApi.library:fetch("modApiExt/modApiExt", nil, "ITB-ModUtils") --Oh it worked apparently
--LOG("TRUELCH - modApiExt: " .. tostring("modApiExt"))
local path = mod.scriptPath
--local utils = require(path .."libs/utils")
--LOG("TRUELCH - utils: " .. tostring("utils"))

local this = {}

local read
local readEnabled

function this:changeMenuBackground(truelchMod)
	--LOG("---------------------- Changing menu background...")
	local rootPathOnDisc = truelchMod.resourcePath

	local function appendDir(path) 
		local dirs = mod_loader:enumerateDirectoriesIn(rootPathOnDisc..path) 
		local images = mod_loader:enumerateFilesIn(rootPathOnDisc..path) 

		for _, file in ipairs(images) do
			modApi:appendAsset( 
				path..file, 
				rootPathOnDisc..path..file 
			) 
		end 

		for _, dir in ipairs(dirs) do
			appendDir(path..dir.."/") 
		end 
	end 

	appendDir("img/")
end


local wotpAchvs =
{
	"wwv",
	"ironHarvest",
	"goodBoy",
	"tankYou",
	"vape",
	"bigShots",
	"groundZero",
	"museum"
}

function this:checkAchievements()
	--LOG("-------------------------------------------------------------------------- truelchSave.checkAchievements()")

	local mod_id = "truelch_WotP"

	local progress

	for _,v in pairs(wotpAchvs) do
		--LOG("-------------------------------------------------------------------------- achievement id: " .. v)
		progress = modApi.achievements:getProgress(mod_id, v)
		--LOG("-------------------------------------------------------------------------- progress: " .. tostring(progress))

		if progress == false then
			--LOG("-------------------------------------------------------------------------- FALSE")
			return false
		end
	end

	--LOG("-------------------------------------------------------------------------- TRUE")
	return true
end

function this:init(truelchMod)
	--LOG("-------------------------------------------------------------------------- truelchSave.init()")

	--- READ FILE ---
	--https://www.tutorialspoint.com/lua/lua_file_io.htm
	--opens a file in read
	file = io.open(truelchMod.scriptPath .. "/truelchSave/mySave.lua" , "r+")

	--sets the default input file as test.lua
	io.input(file)

	--prints the first line of the file
	read = io.read()
	--LOG("-------------------------------------------------------------------------- read: " .. tostring(read))

	--closes the open file
	io.close(file)

	readEnabled = read == "true"

	--LOG("-------------------------------------------------------------------------- readEnabled: " .. tostring(readEnabled))

	--- ACHV ---
	local achvOk = this:checkAchievements()
	--LOG("-------------------------------------------------------------------------- achvOk: " .. tostring(achvOk))

	--- MOD OPTION ---
	local titleTxt = "Complete achievements to unlock the custom background!"
	local tipTxt = "Complete all achievements (squad and global) of this squad to unlock a custom background!"

	if achvOk then
		titleTxt = "Display custom menu"
		tipTxt = "Replaces the Combat Mech with the KV-2."
	end

	modApi:addGenerationOption(
		"DisplayCustomWotPMenu",
		titleTxt,
		tipTxt,
		{
			enabled = false
		}
	)

	--- PLAY CUSTOM BACKGROUND ---
	if readEnabled and achvOk then
		this:changeMenuBackground(truelchMod)
	end
end

function this:load(truelchMod, options)
	--LOG("-------------------------------------------------------------------------- [LOAD] truelchSave.load(options: " .. tostring(options) .. ")")

	local enabled = false

	local achvOk = this:checkAchievements()
	if achvOk then
		enabled = options["DisplayCustomWotPMenu"].enabled
		--LOG("-------------------------------------------------------------------------- achvOk: true! :) -> enabled: " .. tostring(enabled))
	else
		--LOG("-------------------------------------------------------------------------- achvOk: false! :(")
	end
	--LOG("-------------------------------------------------------------------------- enabled: " .. tostring(enabled))

	--- WRITE FILE ---
	--https://www.tutorialspoint.com/lua/lua_file_io.htm
	--open
	file = io.open(truelchMod.scriptPath .. "/truelchSave/mySave.lua" , "w+")

	--LOG("-------------------------------------------------------------------------- file: " .. tostring(file))

	--sets the default output file as test.lua (I guess it's needed to write?)
	io.output(file)

	--write
	if enabled then
		--LOG("-------------------------------------------------------------------------- write true")
		io.write("true")
	else
		--LOG("-------------------------------------------------------------------------- write false")
		io.write("false")
	end

	--close
	io.close(file)
end

return this