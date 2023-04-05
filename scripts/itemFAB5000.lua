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

--Test Tooltip:
--"FAB-5000's ammunition",
--TILE_TOOLTIPS.Item_FAB5000_Text
--{"FAB-5000's ammunition", "Pick it up to recharge the FAB-5000 or secure it for the next mission."},
--"Item_FAB5000_Text" --> between "" even if it's defined like this: TILE_TOOLTIPS.Item_FAB5000_Text
truelch_Item_FAB5000 = {
	Image = "combat/item_fab5000.png",
	Damage = SpaceDamage(0),
	Tooltip = "Item_FAB5000_Text",
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
		and Board:IsFire(p) == false
	return isValid
end

local function findSpawnPos()
	local list = {}

	--We don't want edge tiles, so we exclude 0 and 7
	for j = 1, 6 do
		for i = 1, 6 do
			local point = Point(i, j)
			if isValidPos(point) then
				table.insert(list, point)
			end
		end
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
	--LOG("attemptReloadFAB5000: " .. pawn:GetType())
	local weapons = pawn:GetPoweredWeapons()
	local hasReloaded = false
	for j = 1, 2 do
	    if isFAB5000(weapons[j]) then
			--LOG("TRUELCH - RELOAD BEFORE charges: " .. tostring(pawn:GetWeaponLimitedRemaining(j)))
			pawn:SetWeaponLimitedRemaining(j, 1)
			Board:AddAlert(pawn:GetSpace(), "FAB-5000 Reloaded")
	        --LOG("TRUELCH - RELOAD AFTER charges: " .. tostring(pawn:GetWeaponLimitedRemaining(j)))
	        hasReloaded = true
	    end
	end
	if hasReloaded == false then
		Board:AddAlert(pawn:GetSpace(), "FAB-5000 Secured")
	end
end

local function fab5000Destroyed(point)
	Board:AddAlert(point, "FAB-5000 destroyed!")
	gameData().lastFab5000Use = gameData().currentMission --same as if it has been used
end

----------------------------------------------- HOOKS & EVENTS

modApi.events.onMissionStart:subscribe(function()
	gameData().currentMission = gameData().currentMission + 1
    local fab5000HasBeenUsedPreviousMission = gameData().currentMission - 1 == gameData().lastFab5000Use

    if fab5000HasBeenUsedPreviousMission then
    	--(Try to) create a FAB-5000 item!
		local p = findSpawnPos()
		if p ~= nil then
			local spawnItem = SpaceDamage(p)
			spawnItem.sItem = "truelch_Item_FAB5000"
			Board:DamageSpace(spawnItem)
			Board:SetDangerous(p) --test
			Board:AddAlert(p, "FAB-5000")
			fabPos = p
		else
			--LOG("TRUELCH - Nope")
		end
	end
	
end)

BoardEvents.onTerrainChanged:subscribe(function(p, terrain, terrain_prev)
	local item = Board:GetItem(p)
	if item == "truelch_Item_FAB5000" then
		if terrain == TERRAIN_HOLE or terrain == TERRAIN_WATER then
			Board:RemoveItem(p)
		end
	end
end)

BoardEvents.onItemRemoved:subscribe(function(loc, removed_item)
	if removed_item == "truelch_Item_FAB5000"  then
		local pawn = Board:GetPawn(loc)
		if pawn then
			if not pawn:IsEnemy() then
				attemptReloadFAB5000(pawn)
			else
				fab5000Destroyed(pawn:GetSpace())
			end
		end
	end
end)

--I need to do that only when starting from FAB-5000 item pos!!!
local HOOK_PawnUndoMove = function(mission, pawn, undonePosition)
	--LOG(pawn:GetMechName() .. " move was undone! Was at: " .. undonePosition:GetString() .. ", returned to: " .. pawn:GetSpace():GetString())

	local item = Board:GetItem(undonePosition)
	if item == "truelch_Item_FAB5000" then
		local weapons = pawn:GetPoweredWeapons()
		--LOG("Undone FAB-5000 retrieve")
		for j = 1, 2 do
		    if isFAB5000(weapons[j]) then
				--LOG("TRUELCH - RELOAD BEFORE charges: " .. tostring(pawn:GetWeaponLimitedRemaining(j)))
				pawn:SetWeaponLimitedRemaining(j, 0)
		        --LOG("TRUELCH - RELOAD AFTER charges: " .. tostring(pawn:GetWeaponLimitedRemaining(j)))
		    end
		end
	end
end


local function EVENT_onModsLoaded()
	modapiext:addPawnUndoMoveHook(HOOK_PawnUndoMove)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)