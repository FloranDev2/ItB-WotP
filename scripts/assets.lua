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

--FAB-500 anim
--[[
modApi:appendAsset("img/combat/icons/truelch_anim_fab500.png", resourcePath.."img/combat/icons/truelch_anim_fab500.png")
	Location["combat/icons/truelch_anim_fab500.png"] = Point(-20, -40)
]]

for i = 1, 2 do
modApi:appendAsset("img/combat/icons/truelch_anim_fab500_"..tostring(i)..".png", resourcePath.."img/combat/icons/truelch_anim_fab500_"..tostring(i)..".png")
	Location["combat/icons/truelch_anim_fab500_"..tostring(i)..".png"] = Point(-20, -40)
end

ANIMS.truelch_anim_fab500_0 = Animation:new{
	Image = "combat/icons/truelch_anim_fab500_1.png",
	PosX = -20,
	PosY = -40,
	Time = 0.04,
	NumFrames = 16,
}

ANIMS.truelch_anim_fab500_1 = Animation:new{
	Image = "combat/icons/truelch_anim_fab500_1.png",
	PosX = -20,
	PosY = -40,
	Time = 0.04,
	NumFrames = 16,
}

ANIMS.truelch_anim_fab500_2 = Animation:new{
	Image = "combat/icons/truelch_anim_fab500_2.png",
	PosX = -20,
	PosY = -40,
	Time = 0.04,
	NumFrames = 16,
}

ANIMS.truelch_anim_fab500_3 = Animation:new{
	Image = "combat/icons/truelch_anim_fab500_2.png",
	PosX = -20,
	PosY = -40,
	Time = 0.04,
	NumFrames = 16,
}

--Nuke fade effect
modApi:appendAsset("img/combat/icons/truelch_nuke_fade_effect.png", resourcePath.."img/combat/icons/truelch_nuke_fade_effect.png")
	Location["combat/icons/truelch_nuke_fade_effect.png"] = Point(-320, -180)

ANIMS.truelch_nuke_fade_effect = Animation:new{
	Image = "combat/icons/truelch_nuke_fade_effect.png",
	PosX = -320,
	PosY = -180,
	Time = 0.08, --0.36
	NumFrames = 6,
}

--FAB-5000
modApi:appendAsset("img/combat/icons/truelch_fab5000.png", resourcePath.."img/combat/icons/truelch_fab5000.png")
	Location["combat/icons/truelch_fab5000.png"] = Point(-25, -70)

ANIMS.truelch_fab5000 = Animation:new{
	Image = "combat/icons/truelch_fab5000.png",
	PosX = -25,
	PosY = -70,
	Time = 0.08,
	NumFrames = 14,
}