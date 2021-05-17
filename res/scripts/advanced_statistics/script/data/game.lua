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
		worldsize = g.getWorldSize(),
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
	local comp = api.engine.getComponent(g.getWorldID(), api.type.ComponentType.BOUNDING_VOLUME)
	local bbox = comp.bbox
	return {
		x = bbox.max.x-bbox.min.x,
		y = bbox.max.y-bbox.min.y,
	}
end

function g.getTerrainTileInfo()
	local terrain = api.engine.getComponent(g.getWorldID(), api.type.ComponentType.TERRAIN)
	return {
		size = {
			x = terrain.size.x,
			y = terrain.size.y,
		},
		resolution = terrain.baseResolution.x
	}
end

function g.getWaterTilesInfo()
	local watermeshentities = api.engine.system.riverSystem.getWaterMeshEntities(api.type.Vec2i.new(-4,-4),api.type.Vec2i.new(2,2))
	api.engine.getComponent(id, api.type.ComponentType.WATER_MESH)
	api.engine.getComponent(id, api.type.ComponentType.BOUNDING_VOLUME)
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
	return {
		balance = acc.balance,
		loan = acc.loan,
		maximumLoan = acc.maximumLoan,
		total = acc.balance - acc.loan,
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