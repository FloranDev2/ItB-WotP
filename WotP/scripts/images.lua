local resourcePath = mod_loader.mods[modApi.currentMod].resourcePath

--Weapons' images
modApi:appendAsset("img/weapons/prime_m10thowitzer.png",    self.resourcePath .. "img/weapons/prime_m10thowitzer.png")
modApi:appendAsset("img/weapons/brute_fab500.png",          self.resourcePath .. "img/weapons/brute_fab500.png")
modApi:appendAsset("img/weapons/brute_fab5000.png",         self.resourcePath .. "img/weapons/brute_fab5000.png")
modApi:appendAsset("img/weapons/science_canisterround.png", self.resourcePath .. "img/weapons/science_canisterround.png")

--Projectiles' effects
modApi:appendAsset("img/effects/shotup_kv2_missile2.png", self.resourcePath .. "img/effects/shotup_kv2_missile2.png")

