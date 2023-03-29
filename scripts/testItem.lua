-- Pickable item
--https://github.com/itb-community/ITB-ModLoader/wiki/%5BVanilla%5D-Board#SetDangerous
truelch_Item_FAB5000 = {
	Image = "combat/rf_mine_small.png",
	Damage = SpaceDamage(0),
	Tooltip = "old_earth_mine",
	Icon = "combat/icons/icon_mine_glow.png",
	UsedImage = ""
}



--[[
BoardEvents.onTerrainChanged:subscribe(function(p, terrain, terrain_prev)
	local item = Board:GetItem(p)
	if item == "truelch_Item_FAB5000" then
		if terrain == TERRAIN_HOLE or terrain == TERRAIN_WATER then
			Board:RemoveItem(p)
		end
	end
end)
]]

local function isValidPos(p)
	local isValid = true
		and Board:IsValid(p)
		and not Board:IsBlocked(p, PATH_PROJECTILE)
	return isValid
end

local function FindSpawnPos()
	LOG("TRUELCH - FindSpawnPos()")

	--local ret = PointList()
	local list = {}

	--Loop to find valid points
	for index, point in ipairs(Board) do
		if isValidPos(point) then
	    	--ret:push_back(point)
	    	table.insert(list, point)
	    	LOG(point:GetString() .. " is valid! YAY :)")
	    else
	    	LOG(point:GetString() .. " is NOT valid! :(")
    	end
	end

	local length = #(list)
	LOG("length: " .. tostring(length))

	if length > 0 then
		local randIndex = math.random(1, length)
		return list[randIndex]
	else
		return nil
	end
end

modApi.events.onMissionStart:subscribe(function()
	--[[
	local exit = false
		or isSquad() == false
		or isMission() == false

	if exit then
		return
	end
	]]

	--test to see if it inits
	LOG("TRUELCH - onMissionStart - Spawn Item")
	local p = FindSpawnPos()

	if p ~= nil then
		local spawnItem = SpaceDamage(p)
		spawnItem.sItem = "truelch_Item_FAB5000"
		Board:DamageSpace(spawnItem)
		LOG("TRUELCH - Yay")
		LOG("TRUELCH - p: " .. p:GetString())
		--Board:AddAlert(p, "Here") --doesn't work (oh maybe because p was nil)
	else
		LOG("TRUELCH - Nope")
	end
end)