local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local tips = require(path .. "libs/tutorialTips")

--https://github.com/Lemonymous/ITB-LemonymousMods/wiki/tutorialTips
--Example from nuclear nightmares
--tips:Trigger("Energy", point)

--[[
--Libs
local tips = require(scriptPath .. "libs/tutorialTips")

local mission = GetCurrentMission()
if mission and not Board:IsTipImage() and not IsTestMechScenario() then
	tips:Trigger("FAB5000Item", point)
end
]]

--TODO (useless maybe?)
--[[
tips:Add{
	id = "M10T",
	title = "M10T Howitzer",
	text = "This howitzer is able to ignore armor and deals damage equal to the half of the remaining HP of the target (rounded up)."
}
]]

--[[
tips:Add{
	id = "FAB5000",
	title = "FAB-5000",
	text = "The bomber is equipped with 2 bombs. The big one, the FAB-5000, needs to be reloaded during the next mission to be used again."
}
]]

--Works
--Is used in fab5000, not in itemFAB5000.lua
tips:Add{
	id = "FAB5000Item",
	title = "FAB-5000",
	text = "Your Bomber can pick up the FAB-5000 to use it or any ally can retrieve it so it can be used in the next mission. If an enemy steps on it, it'll destroy it."
}

tips:Add{
	id = "FAB5000OldReload",
	title = "FAB-5000",
	text = "When you use the FAB-5000 in a mission, you can't use it in the following one."
}

--Works
tips:Add{
	id = "M6GunFMW",
	title = "M6 Gun",
	text = "The M6 Gun can fire two types of shells: smoking and pushing shells. To change mode, click on the weapon and click on the shell buttons on the right of the weapon's panel."
}