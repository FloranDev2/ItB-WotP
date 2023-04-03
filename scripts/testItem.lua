-- Pickable item
--https://github.com/itb-community/ITB-ModLoader/wiki/%5BVanilla%5D-Board#SetDangerous


----------------------------------------------- FUNCTIONS

local function isGame()
    return true
        and Game ~= nil
        and GAME ~= nil
end

local function isMission()
    local mission = GetCurrentMission()

    return true
        and isGame()
        and mission ~= nil
        and mission ~= Mission_Test
end

local function isGameData()
    return true
        and GAME ~= nil
        and GAME.truelch_WotP ~= nil
end

local function gameData()
    if GAME.truelch_WotP == nil then
        GAME.truelch_WotP = {}
    end

    return GAME.truelch_WotP
end

local function missionData()
    local mission = GetCurrentMission()

    if mission.truelch_WotP == nil then
        mission.truelch_WotP = {}
    end

    return mission.truelch_WotP
end

--123456789012345
--truelch_FAB5000
local function isFAB5000(weapon)
	if type(weapon) == 'table' then
    	weapon = weapon.__Id
	end
	if weapon == nil then
		return false
	end
    local sub = string.sub(weapon, 9, 15)
    if sub == "FAB5000" then
    	return true
    end
	return false
end

----------------------------------------------- ITEM

truelch_Item_FAB5000 = {
	Image = "combat/item_fab5000.png",
	Damage = SpaceDamage(0),
	Tooltip = "Pick up that FAB-5000 your Mech using it!",
	Icon = "combat/icons/icon_mine_glow.png",
	UsedImage = ""
}

--TODO: check the terrain, like water


local function isValidPos(p)
	local isValid = true
		and Board:IsValid(p)
		and not Board:IsBlocked(p, PATH_PROJECTILE)
		and Board:GetTerrain(p) ~= TERRAIN_WATER
		and Board:GetTerrain(p) ~= TERRAIN_HOLE
		and Board:IsAcid(p) == false
	return isValid
end

local function findSpawnPos()
	--LOG("TRUELCH - FindSpawnPos()")

	local list = {}

	--Loop to find valid points
	--[[
	for index, point in ipairs(Board) do
		if isValidPos(point) then
	    	table.insert(list, point)
	    	--LOG(point:GetString() .. " is valid! YAY :)")
	    else
	    	--LOG(point:GetString() .. " is NOT valid! :(")
    	end
	end
	]]

	--We don't want edge tiles, so we exclude 0 and 7
	for j = 1, 6 do
		
	end

	local length = #(list)
	--LOG("length: " .. tostring(length))

	if length > 0 then
		local randIndex = math.random(1, length)
		return list[randIndex]
	else
		return nil
	end
end

local function attemptReloadFAB5000(pawn)
	LOG("attemptReloadFAB5000: " .. pawn:GetType())
	local weapons = pawn:GetPoweredWeapons()
	for j = 1, 2 do
	    if isFAB5000(weapons[j]) then
			LOG("TRUELCH - RELOAD BEFORE charges: " .. tostring(pawn:GetWeaponLimitedRemaining(j)))
			pawn:SetWeaponLimitedRemaining(j, 1)
	        LOG("TRUELCH - RELOAD AFTER charges: " .. tostring(pawn:GetWeaponLimitedRemaining(j)))
	    end
	end
end

----------------------------------------------- HOOKS & EVENTS
modApi.events.onMissionStart:subscribe(function()
	
	--test to see if it inits
	--LOG("TRUELCH - onMissionStart - Spawn Item")
	--LOG("TRUELCH - TERRAIN_WATER: " .. tostring(TERRAIN_WATER) .. ", TERRAIN_HOLE: " .. tostring(TERRAIN_HOLE))
	local p = findSpawnPos()

	if p ~= nil then
		local spawnItem = SpaceDamage(p)
		spawnItem.sItem = "truelch_Item_FAB5000"
		Board:DamageSpace(spawnItem)
		--LOG("TRUELCH - Yay")
		LOG("TRUELCH - p: " .. p:GetString())
		--Board:AddAlert(p, "Here") --doesn't work (oh maybe because p was nil)
	else
		--LOG("TRUELCH - Nope")
	end
	
end)

BoardEvents.onTerrainChanged:subscribe(function(p, terrain, terrain_prev)
	local item = Board:GetItem(p)
	--LOG("TRUELCH - onTerrainChanged(p: " .. p:GetString())
	--LOG("item: " .. item)
	if item == "truelch_Item_FAB5000" then
		if terrain == TERRAIN_HOLE or terrain == TERRAIN_WATER then
			Board:RemoveItem(p)
		end
	end
end)

BoardEvents.onItemRemoved:subscribe(function(loc, removed_item)
	--LOG("TRUELCH - onItemRemoved")
	--LOG("TRUELCH - loc: " .. loc:GetString() .. ")")
	--LOG("TRUELCH - removed_item: " .. removed_item)
	if removed_item == "truelch_Item_FAB5000"  then

		local pawn = Board:GetPawn(loc)

		if pawn then
			--[[
			if pawn:GetId() == undoPawnId_thisFrame then
				-- do nothing
			elseif not HasMinesweeper(pawn) then
				local mine_damage = SpaceDamage(loc, 3)
				mine_damage.sSound = "/impact/generic/explosion"
				mine_damage.sAnimation = "ExploAir1"

				Board:DamageSpace(mine_damage)
			end
			]]

			attemptReloadFAB5000(pawn)
		end
	end
end)

local HOOK_PawnUndoMove = function(mission, pawn, undonePosition)
	--LOG(pawn:GetMechName() .. " move was undone! Was at: " .. undonePosition:GetString() .. ", returned to: " .. pawn:GetSpace():GetString())

	--TODO: check if it's the mech that picked up the item
	--If it's the case, undo the effect
end


local function EVENT_onModsLoaded()
	modapiext:addPawnUndoMoveHook(HOOK_PawnUndoMove)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)