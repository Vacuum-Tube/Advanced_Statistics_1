local list = require "advanced_statistics/script/listutil"

local landuseTypes = {"RESIDENTIAL","COMMERCIAL","INDUSTRIAL"}

local constructiondata = {}

function constructiondata.getInfo(circle)
	local constructions = game.interface.getEntities(circle, { type = "CONSTRUCTION", includeData = truee })  -- ~0.1
	
	local d = {
		Capacities = {
			[landuseTypes[1]] = list.ValueList:new(),
			[landuseTypes[2]] = list.ValueList:new(),
			[landuseTypes[3]] = list.ValueList:new(),
		},
		Filename = list.CountList:new({},true),
		Builttimes = list.ValueList:new(),
		ParticleCount = list.ValueList:new(),
		Types = list.CountList:new({"depots","stations","townBuildings","simBuildings","other"}),
		BuildCost = list.ValueList:new(),
		MaintenanceCost = list.ValueList:new(),
	}
	
	 for _,id in pairs(constructions) do
		local comp = api.engine.getComponent(id, api.type.ComponentType.CONSTRUCTION)
		d.Filename:count(comp.fileName)
		d.Builttimes:newVal(comp.timeBuilt)--, comp.timeBuilt>0)  --ms
		--game.interface.getEntity( ).dateBuilt
		d.ParticleCount:newVal(#comp.particleSystems)
		d.Types:count("depots", #comp.depots)
		d.Types:count("stations", #comp.stations)
		d.Types:count("townBuildings", #comp.townBuildings)
		d.Types:count("simBuildings", #comp.simBuildings)
		if #comp.townBuildings==0 and #comp.simBuildings==0 and #comp.stations==0 and #comp.depots==0 then  -- ~=1
			d.Types:count("other")
		end
		
		local personCapacity = api.engine.getComponent(id, api.type.ComponentType.PERSON_CAPACITY)
		if personCapacity then
			local landuse = landuseTypes[personCapacity.type+1]
			d.Capacities[landuse]:newVal(personCapacity.capacity)
		end
		
		local buildCost = api.engine.getComponent(id, api.type.ComponentType.BUILD_COST)
		if buildCost then
			d.BuildCost:newVal(buildCost.buildCost, buildCost.buildCost>0)
		end
		local maintenanceCost = api.engine.getComponent(id, api.type.ComponentType.MAINTENANCE_COST)
		if maintenanceCost then
			d.MaintenanceCost:newVal(maintenanceCost.maintenanceCost)--, maintenanceCost.maintenanceCost>0)
		end
		-- api.engine.getComponent( , api.type.ComponentType.STOCK_LIST)  userdata
	end
	
	d.Builttimes:finish()
	d.ParticleCount:finish()
	d.BuildCost:finish()
	d.MaintenanceCost:finish()
	for landuse,list in pairs(d.Capacities) do
		list:finish()
	end
	
	d.count = d.ParticleCount.num
	return d
end

return constructiondata