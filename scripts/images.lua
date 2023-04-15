local resourcePath = mod_loader.mods[modApi.currentMod].resourcePath

--Weapons' images
modApi:appendAsset("img/weapons/prime_m10thowitzer.png",    resourcePath .. "img/weapons/prime_m10thowitzer.png")
modApi:appendAsset("img/weapons/brute_fab500.png",          resourcePath .. "img/weapons/brute_fab500.png")
modApi:appendAsset("img/weapons/brute_fab5000.png",         resourcePath .. "img/weapons/brute_fab5000.png")
modApi:appendAsset("img/weapons/science_canisterround.png", resourcePath .. "img/weapons/science_canisterround.png")

--Projectiles' effects
modApi:appendAsset("img/effects/shotup_kv2_missile2.png",   resourcePath .. "img/effects/shotup_kv2_missile2.png")

--Items
modApi:appendAsset("img/combat/item_fab5000.png", resourcePath .. "img/combat/item_fab5000.png")
	Location["combat/item_fab5000.png"] = Point(-15, 10)

--Image Mark
modApi:appendAsset("img/combat/icons/icon_armor_piercing.png", resourcePath .. "img/combat/icons/icon_armor_piercing.png")
	Location["combat/icons/icon_armor_piercing.png"] = Point(6, 10)

--[[
modApi:createAnimations{
	aa_bombdrop = {
		Image = "effects/aa_explo_bomb.png",
		NumFrames = 10,
		Time = 0.032, --multiple of 0.008
		PosX = -18,
		PosY = -12
	},
}
]]