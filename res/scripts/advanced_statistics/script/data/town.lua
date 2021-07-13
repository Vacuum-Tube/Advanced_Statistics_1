local list = require "advanced_statistics/script/listutil"

local towndata = {}

function towndata.getInfo(circle)
	local interface = game.interface
	-- local towns = interface.getTowns()
	local towns = game.interface.getEntities(circle, {type = "TOWN" })  --0.09
	local num0 = #towns
	local num = (num0==0) and -1 or num0  -- avoid 0/0 = -nan(ind) because this leads to .sav.lua not readable
	
	local Capacities = list.ValueList:new(3)
	local Reachability = list.ValueList:new(2)
	local TransportSamples = list.ValueList:new(2)
	local SupplyAndLimit = list.ValueList:new(2)
	local d = {
		count = num0,
		Size = list.ValueList:new(),
		TrafficRatings = list.ValueList:new(),
		Emissions = list.ValueList:new(),
		developmentActive = list.CountList:new(),
		sizeFactor = list.ValueList:new(),
		growthTendency = list.ValueList:new(),
		Growth = list.ValueList:new(3),
		CargoTypesSupply = list.CountList:new({},true),
		CargoTypesLimit = list.CountList:new({},true),
		townSuppliedPart = list.CountList:new(),
		townSuppliedFull = list.CountList:new(),
		townswCargo = list.CountList:new(),
	}
	
	--api.engine.system.townBuildingSystem.getTown2personCapacitiesMap()
	for _,id in pairs(towns) do
		--local town = interface.getEntity(id)  -- nothing interesting here
		local comp = api.engine.getComponent(id, api.type.ComponentType.TOWN)
		
		local caps = api.engine.system.townBuildingSystem.getLandUsePersonCapacities(id)
		Capacities:newVal(caps) --interface.getTownCapacities(id))
		d.Size:newVal((caps[1]+caps[2]+caps[3])/3)  -- "Town Size"
		local initCaps = comp.initialLandUseCapacities
		local growth = {}
		for i=1,3 do
			growth[i] = caps[i]/( initCaps[i]>0 and initCaps[i] or math.huge )  -- avoid nan ind
		end
		d.Growth:newVal(growth)
		
		Reachability:newVal(interface.getTownReachability(id))  -- [1]: Car, [2]: Line
		TransportSamples:newVal(interface.getTownTransportSamples(id))
		d.TrafficRatings:newVal(comp.trafficSpeed) -- interface.getTownTrafficRating(id))
		d.Emissions:newVal(comp.emission, comp.emission==comp.emission) --interface.getTownEmission(id))  -- can be nan ind
		d.developmentActive:count(nil,nil,comp.developmentActive)
		d.sizeFactor:newVal(comp.sizeFactor)
		d.growthTendency:newVal(comp.growthTendency)
		
		local tSupplyAndLimit = list.ValueList:new(2)
	-- api.engine.system.townBuildingSystem.getCargoSupplyAndLimit(id)  -- no limit here??
		for cargo,CargoSupplyAndLimit in pairs(interface.getTownCargoSupplyAndLimit(id)) do -- [1]: Supply, [2]: Limit
			tSupplyAndLimit:newVal(CargoSupplyAndLimit)
			SupplyAndLimit:newVal(CargoSupplyAndLimit)
			d.CargoTypesSupply:count(cargo,CargoSupplyAndLimit[1])
			d.CargoTypesLimit:count(cargo,CargoSupplyAndLimit[2])
		end
		local townSupply = tSupplyAndLimit.sum[1]/tSupplyAndLimit.sum[2]
		if townSupply>0 then
			d.townSuppliedPart:count()
		end
		if townSupply>=0.75 then
			d.townSuppliedFull:count()
		end
		if tSupplyAndLimit.sum[2]>0 then
			d.townswCargo:count()
		end
	end
	
	Capacities.Res, Capacities.Com, Capacities.Ind = table.unpack(Capacities.sum)
	-- Capacities.totSize = (Capacities.Res + Capacities.Com + Capacities.Ind) / 3
	Capacities.totDest = (Capacities.Com + Capacities.Ind) / 2
	-- Capacities.avSize = (num>0) and Capacities.totSize/num
	
	Reachability:finish()
	
	-- TransportSamples.s1tot, TransportSamples.s2tot = table.unpack(TransportSamples.sum)
	TransportSamples:finish()
	
	SupplyAndLimit:finish()
	-- SupplyAndLimit.suptot, SupplyAndLimit.limtot = table.unpack(SupplyAndLimit.sum)
	-- SupplyAndLimit.supav, SupplyAndLimit.limav = table.unpack(SupplyAndLimit.av)
	-- SupplyAndLimit.supav = SupplyAndLimit.suptot/num
	-- SupplyAndLimit.limav = SupplyAndLimit.limtot/num
	SupplyAndLimit.rel = (SupplyAndLimit.sum[2]>0) and SupplyAndLimit.sum[1]/SupplyAndLimit.sum[2]
	
	d.Size:finish()
	d.TrafficRatings:finish()
	d.Emissions:finish()
	d.Growth:finish()
	d.sizeFactor:finish()
	d.growthTendency:finish()
	
	d.Capacities = Capacities
	d.Reachability = Reachability
	d.TransportSamples = TransportSamples
	d.SupplyAndLimit = SupplyAndLimit
	return d
end

return towndata