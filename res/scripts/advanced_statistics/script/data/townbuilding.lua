local list = require "advanced_statistics/script/listutil"

local landuseTypes = {"RESIDENTIAL","COMMERCIAL","INDUSTRIAL"}

local townbuildingdata = {}

function townbuildingdata.getInfo(circle)
	local townbuildings = game.interface.getEntities(circle, { type = "TOWN_BUILDING", includeData = truee })
	
	local d = {
		Depth = list.ValueList:new(),
		Height = list.ValueList:new(),
		Parcels = list.ValueList:new(),
		Builttimes = list.ValueList:new(),
		Capacities = {
			[landuseTypes[1]] = list.ValueList:new(),
			[landuseTypes[2]] = list.ValueList:new(),
			[landuseTypes[3]] = list.ValueList:new(),
		},
		Employed = {
			[landuseTypes[1]] = list.ValueList:new(),
			[landuseTypes[2]] = list.ValueList:new(),
			[landuseTypes[3]] = list.ValueList:new(),
		},
	}
	
	--api.engine.system.townBuildingSystem.getTown2BuildingMap()
	-- local con2townb = api.engine.system.townBuildingSystem.getPersonCapacity2townBuildingMap()
	local Dest2SpMap = api.engine.system.simPersonSystem.getDestination2SpMap()  -- 10ms
	-- d.countDestinations = #Dest2SpMap  --  Buildings w. person Destination>0
	
	for _,id in pairs(townbuildings) do
		local townbuilding = api.engine.getComponent(id, api.type.ComponentType.TOWN_BUILDING)
		d.Depth:newVal(townbuilding.depth)  -- ??
		d.Height:newVal(townbuilding.height)
		d.Parcels:newVal(#townbuilding.parcels)
		d.Builttimes:newVal(townbuilding.timeBuilt)--, townbuilding.timeBuilt>0)  --ms
		
		local personCapacity = api.engine.getComponent(townbuilding.personCapacity, api.type.ComponentType.PERSON_CAPACITY)
		local landuse = landuseTypes[personCapacity.type+1]
		d.Capacities[landuse]:newVal(personCapacity.capacity)
		
		local destPersons = Dest2SpMap[townbuilding.personCapacity]
		if destPersons then
			d.Employed[landuse]:newVal(#destPersons)
			-- d.Vacant[landuse]:newVal(personCapacity.capacity-#destPersons)  -- unemployed
		end
	end
	
	d.Depth:finish()
	d.Height:finish()
	d.Parcels:finish()
	d.Builttimes:finish()
	for landuse,list in pairs(d.Capacities) do
		list:finish()
		d.Employed[landuse]:finish()
	end
	
	d.count = d.Height.num
	return d
end

return townbuildingdata