-- add color palette
--local scriptPath = mod_loader.mods[modApi.currentMod].scriptPath

modApi:addPalette({
		ID = "truelch_RedAlert",
		Name = "Red Alert",
		Image = "img/units/player/kv2_ns.png",
		PlateHighlight = { 239, 203,  63 },	--lights
		PlateLight     = { 173,  72,  62 },	--main highlight
		PlateMid       = { 122,  25,  24 },	--main light
		PlateDark      = {  63,  23,  18 },	--main mid
		PlateOutline   = {  31,  11,   9 },	--main dark
		PlateShadow    = {  24,  25,  24 },	--metal dark
		BodyColor      = {  47,  51,  48 },	--metal mid
		BodyHighlight  = {  72,  76,  73 },	--metal light
})
modApi:getPaletteImageOffset("truelch_RedAlert")

modApi:addPalette({
		ID = "truelch_SovietGreen",
		Name = "Soviet Green",
		Image = "img/units/player/m22_ns.png",
		PlateHighlight = { 239, 203,  63 },	--lights
		PlateLight     = { 173,  72,  62 },	--main highlight
		PlateMid       = { 122,  25,  24 },	--main light
		PlateDark      = {  63,  23,  18 },	--main mid
		PlateOutline   = {  31,  11,   9 },	--main dark
		PlateShadow    = {  24,  25,  24 },	--metal dark
		BodyColor      = {  47,  51,  48 },	--metal mid
		BodyHighlight  = {  72,  76,  73 },	--metal light
})
modApi:getPaletteImageOffset("truelch_SovietGreen")