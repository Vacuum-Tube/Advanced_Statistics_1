local list = require "advanced_statistics/script/listutil"
local Polygon = require "advanced_statistics/script/polygon"

local g = {}

function g.getInfo()
	return {
		gametime = g.getGameTime(),
		updateCount = g.getGameTimeUpdateCount(),
		tickCount = g.getGameTimeTickCount(),
		gametimetotal = g.getGameTimeTickCount()/5,  --200ms
		name = g.getPlayerName(),
		score = g.getCompanyScore(),
		difficulty = g.getGameDifficulty(),
		speed = g.getGameSpeed(),
		millis = g.getMillis(),
		-- account = g.getAccount(),
		-- journal = g.getJournalTotal(),
		transported = g.getTransportedData(),
		isSandbox = g.isSandbox(),
		noCosts = g.noCosts(),
	}
end


function g.isSandbox()
	return game.config.sandboxButton
end

function g.noCosts()
	return game.config.noCosts
end

function g.industryButton()
	return game.config.industryButton
end


function g.getPlayerID()
	return api.engine.util.getPlayer()
end

function g.getWorldID()
	return api.engine.util.getWorld()
end


function g.getGameTime()
	return game.interface.getGameTime()
end

function g.getGameTimeSec()
	return game.interface.getGameTime().time
end

function g.getGameTimeDate()
	return game.interface.getGameTime().date
end

function g.getGameTimeMilSec()
	local comp = api.engine.getComponent(g.getWorldID(),api.type.ComponentType.GAME_TIME)  -- dont index directly!
	return comp.gameTime
end

function g.getGameTimeComp()  -- userdata
	return api.engine.getComponent(g.getWorldID(),api.type.ComponentType.GAME_TIME)  -- gameTime, gameTime0 (same?), updateCount: gametime ticks (=gameTime/200) , tickCount: continous ticks (also paused)
end

function g.getGameTimeUpdateCount()
	local comp = api.engine.getComponent(g.getWorldID(),api.type.ComponentType.GAME_TIME)
	return comp.updateCount
end

function g.getGameTimeTickCount()
	local comp = api.engine.getComponent(g.getWorldID(),api.type.ComponentType.GAME_TIME)
	return comp.tickCount
end


function g.getWorldSize()
	local bv = api.engine.getComponent(g.getWorldID(), api.type.ComponentType.BOUNDING_VOLUME)
	local bbox = bv.bbox
	return {
		x = bbox.max.x-bbox.min.x,
		y = bbox.max.y-bbox.min.y,
	}
end

function g.getWaterLevel()
	local terrain = api.engine.getComponent(g.getWorldID(), api.type.ComponentType.TERRAIN)
	return terrain.waterLevel
end

function g.getTerrainInfo()
	local terrain = api.engine.getComponent(g.getWorldID(), api.type.ComponentType.TERRAIN)
	local size = {
		x = terrain.size.x,
		y = terrain.size.y,
	}
	local resolutionZ = terrain.baseResolution.z
	local heights = list.ValueList:new()
	for id=1,size.x*size.y do
		local comp = api.engine.getComponent(id, api.type.ComponentType.TERRAIN_TILE_HEIGHTMAP)
		for i,h in pairs(comp.vertices) do
			heights:newVal(h)
		end
	end
	heights:finish()
	return {
		size = size,
		resolution = terrain.baseResolution.x,
		resolutionZ = terrain.baseResolution.z,
		waterLevel = terrain.waterLevel,
		offsetZ = terrain.offsetZ,
		heightMin = heights.min*resolutionZ + terrain.offsetZ,
		heightMax = heights.max*resolutionZ + terrain.offsetZ,
		heightAv = heights.av*resolutionZ + terrain.offsetZ,
	}
end

function g.getWaterTilesInfo()
	local watermeshentities = api.engine.system.riverSystem.getWaterMeshEntities(api.type.Vec2i.new(-50,-50),api.type.Vec2i.new(50,50))  -- tile i , megl map has 96 tiles
	local areas = list.ValueList:new()
	for i,id in pairs(watermeshentities) do
		local wmesh = api.engine.getComponent(id, api.type.ComponentType.WATER_MESH)  -- what size is this / how does it look like?
		-- local bv = api.engine.getComponent(id, api.type.ComponentType.BOUNDING_VOLUME)
		-- local bbox = bv.bbox
		-- areas:newVal((bbox.max.x-bbox.min.x)*(bbox.max.y-bbox.min.y))  -- bigger than geometry
		local points = {}
		for i,v in pairs(wmesh.vertices) do
			table.insert(points, {v.x, v.y})
		end
		if #points>0 then
			local polygon = Polygon:Create(points)
			-- assert(polygon:IsSelfIntersecting()==false)  -- in general self intersecting
			areas:newVal(polygon:GetArea())  -- therefore this is smaller than the actual area
		end
	end
	return {
		numWaterMeshes = #watermeshentities,
		waterArea = areas.sum,
	}
end


function g.getPlayerName()
	-- return game.interface.getName(g.getPlayerID())
	local comp = api.engine.getComponent(g.getPlayerID(),api.type.ComponentType.NAME)
	return comp.name
end

function g.getCompanyScore()
	return game.interface.getCompanyScore(g.getPlayerID())
end

-- function g.getBalance()
	-- return game.interface.getEntity(g.getPlayerID()).balance
-- end

-- function g.getLoan()
	-- return game.interface.getEntity(g.getPlayerID()).loan
-- end

function g.getAccount()
	local acc = api.engine.getComponent(g.getPlayerID(),api.type.ComponentType.ACCOUNT)
	local player = game.interface.getEntity(g.getPlayerID())
	return {
		-- balance = acc.balance,  behaves weird if balance=-9.2233720276152e+18
		balance = player.balance,
		loan = acc.loan,
		maximumLoan = acc.maximumLoan,
		total = player.balance - acc.loan,
	}
end

function g.getJournalTotal(scale,short)
	local journal = game.interface.getPlayerJournal(0, g.getGameTimeMilSec()*(scale or 1), short and true or false) -- _sum, acquisition,construction,income,maintenance, interest,loan,other   -- true: short format
	return journal
end

function g.getGameDifficulty()  -- 0/1/2
	return game.interface.getGameDifficulty()
end

function g.getGameSpeed()
	return game.interface.getGameSpeed()  -- 0/1/2/4
end

function g.getMillis()
	local mils = game.interface.getMillisPerDay()
	if mils==0 then -- date paused
		return false
	else
		return mils
	end
end

function g.isdatepaused()
	return g.getMillis()==false
end

-- >> api.engine.getComponent(u.getWorldID(),api.type.ComponentType.GAME_SPEED)
-- {
  -- millisPerDay = 2000,
  -- speedup = 4,
-- }


function g.getTransportedData()
	--tricky problem: cant return this directly, error when userdata is contained in state: Error message: value must be of type nil, boolean, number, string or table  Key: game/res/gameScript/advanced_statistics.lua_save
	local t = api.engine.util.getTransportedData and api.engine.util.getTransportedData() or {}  -- compatibility with b29596
	return {
		passengers = t.passengersTransported or -1,
		cargo = t.cargoTransported or -1,
	}
end


return g