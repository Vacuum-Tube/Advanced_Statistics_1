local list = require "advanced_statistics/script/listutil"

local carriers = require "advanced_statistics/script/res/carriers"

local stationdata = {}

function stationdata.getInfo(circle)
	-- print("start station")
	--local stations = game.interface.getStations{carrier=carr, town=}
	local stationGroups = game.interface.getEntities(circle, { type = "STATION_GROUP", includeData = true })  -- ~0.1 include not relevant
	local num = 0
	
	local d = {
		countStations = list.ValueList:new(),
		CarriersCount = list.CountList:new(carriers.carriersAll),
		Cargo = list.CountList:new(carriers.carriersAll),
		TransportSamples = list.ValueList:new(2),
		CargoWaiting = list.CountList:new({},true),
		Loaded = list.CountList:new({},true),
		Unloaded = list.CountList:new({},true),
	}
	-- for _,carr in pairs(carriers.carriersAll) do
		-- d[carr] = {
			-- count = list.CountList:new(),
		-- }
	-- end
	
	for id,stationGroup in pairs(stationGroups) do
		-- print(id,stationGroup.name)
		num = num + 1
		for cargo,waiting in pairs(stationGroup.cargoWaiting) do
			d.CargoWaiting:count(cargo,waiting)
		end
		for cargo,items in pairs(stationGroup.itemsLoaded) do
			if cargo:sub(0,1)~="_" then
				d.Loaded:count(cargo,items)
			end
		end
		for cargo,items in pairs(stationGroup.itemsUnloaded) do
			if cargo:sub(0,1)~="_" then
				d.Unloaded:count(cargo,items)
			end
		end
		
		if stationGroup.name~="" then
		for _,id in pairs(stationGroup.stations) do
			if api.engine.getComponent(id,api.type.ComponentType.NAME)==nil then	goto continue end  -- ugly workaround, combined Freestyle station that create crash seem to be distinguishable by this
			local station = game.interface.getEntity(id)  -- CRASHES if station is strange, sometimes name = "" , or lollus Freestyle if combined station
			-- local a=api.engine.getComponent(id,api.type.ComponentType.STATION)  -- component no carrier info?
			-- if a and a.terminals and a.terminals[1] and a.terminals[1].personNodes and a.terminals[1].personNodes[1] then 
				-- print(a.terminals[1].personNodes[1].entity)
				-- local c = api.engine.getComponent(a.terminals[1].personNodes[1].entity,api.type.ComponentType.CONSTRUCTION)
				-- if c then
					-- print( c.fileName)
					-- else
					-- print("no con")
				-- end
			-- end
			-- local test = 0
			for carr,bool in pairs(station.carriers) do
				-- test = test + 1
				-- if type(bool)~="boolean" or bool==false then
					-- error("TPF - WTF?  STATION carrier Value: "..tostring(bool))
				-- end
				-- stationdata.setStationSingleInfo(d[carr], id, station)
				d.CarriersCount:count(carr)
				d.Cargo:count(carr, nil, station.cargo)
			end
			d.CarriersCount:count("ALL")
			d.Cargo:count("ALL", nil, station.cargo)
			-- stationdata.setStationSingleInfo(d["ALL"], id, station)
			-- if test~=1 then  -- happening only for Road+Tram?
				-- print("STATION carrier  Sum:",test,id)
				-- debugPrint(station.carriers)
			-- end
			local Samples = game.interface.getStationTransportSamples(id)  -- sum is ~equal as in town
			d.TransportSamples:newVal(Samples, Samples[1]>=0 and Samples[2]>=0)  -- apparently only for passenger
			
			 ::continue::
		end
		end
		d.countStations:newVal(#stationGroup.stations)
	end
	
	
	-- api.engine.system.catchmentAreaSystem.getStation2stationsAndDistancesMap()  -station single
	--api.engine.system.stationSystem.forEach(function(a,b) debugPrint(b) end)
	--api.engine.system.streetConnectorSystem.getStation2ConstructionMap()
	
	-- for _,carr in pairs(carriers.carriersAll) do
		-- local c = d[carr]
		-- c.count = c.count.count_
		-- c.Cargo = c.Cargo.count_
	-- end
	
	d.TransportSamples:finish()
	d.countGroups = num
	return d
end

-- function stationdata.setStationSingleInfo(c, id, station)
	-- c.count:count()
-- end

return stationdata