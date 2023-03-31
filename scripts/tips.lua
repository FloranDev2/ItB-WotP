local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local tips = require(path .. "libs/tutorialTips")

--https://github.com/Lemonymous/ITB-LemonymousMods/wiki/tutorialTips
--Example from nuclear nightmares
--tips:Trigger("Energy", point)

tips:Add{
	id = "FAB5000",
	title = "FAB-5000",
	text = "The FAB-5000 is a BIG BOMB."
}

tips:Add{
	id = "M10T",
	title = "M10T Howitzer",
	text = "This howitzer is able to ignore armor and deals damage equal to the half of the remaining HP of the target (rounded up)."
}

tips:Add{
	id = "M6GunFMW",
	title = "M6 Gun",
	text = "The M6 Gun can fire two types of shells: smoking and pushing shells. To change mode, click on the weapon and click on the shell buttons on the right of the weapon's panel."
}

tips:Add{
	id = "M6GunFMW",
	title = "M6 Gun",
	text = "The M6 Gun can fire two types of shells: smoking and pushing shells. Click on the target, and then click behind it to push, or click again on the target to smoke. (you'll need to move the cursor from the target tile first)"
}
