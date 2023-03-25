local resourcePath = mod_loader.mods[modApi.currentMod].resourcePath

--Weapons' images
modApi:appendAsset("img/weapons/prime_m10thowitzer.png",    resourcePath .. "img/weapons/prime_m10thowitzer.png")
modApi:appendAsset("img/weapons/brute_fab500.png",          resourcePath .. "img/weapons/brute_fab500.png")
modApi:appendAsset("img/weapons/brute_fab5000.png",         resourcePath .. "img/weapons/brute_fab5000.png")
modApi:appendAsset("img/weapons/science_canisterround.png", resourcePath .. "img/weapons/science_canisterround.png")

--Projectiles' effects
modApi:appendAsset("img/effects/shotup_kv2_missile2.png",   resourcePath .. "img/effects/shotup_kv2_missile2.png")