local list = require "advanced_statistics/script/listutil"

local carriers = require "advanced_statistics/script/res/carriers"

local depotdata = {}

function depotdata.getInfo(circle)
	-- game.interface.getDepots()
	-- api.engine.system.vehicleDepotSystem.forEach(function(id,depot)
	-- end)
	local depots = game.interface.getEntities(circle, {type="VEHICLE_DEPOT" })
	
	local d = {
		count = #depots,
		CarriersCount = list.CountList:new(carriers.carriersAll),
		StTimes = list.ValueList:new(),
	}
	
	for _,id in pairs(depots) do 
		local depot = api.engine.getComponent(id,api.type.ComponentType.VEHICLE_DEPOT)
		d.CarriersCount:count(carriers.carriers[depot.carrier+1])  -- 0-4
		d.CarriersCount:count("ALL")
		d.StTimes:newVal(depot.stateTime, depot.stateTime>0) -- usec
		--for _,carrorall in pairs({"ALL",carriers.carriers[depot.carrier+1]}) do
		--	d[carrorall].Depots:count()
		--end
		--depot.state
		--depot.doors
	end
	
	d.StTimes:finish()
	
	return d
end

return depotdata