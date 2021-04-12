local list = require "advanced_statistics/script/listutil"

local persondata = {}

function persondata.getInfo(circle)
	local persons = game.interface.getEntities(circle, { type = "SIM_PERSON", includeData = truee })
	local d = {
		count = #persons,
		curDestination = list.CountList:new(3),
		Destinations = list.CountList:new({"ALL","COM_ONLY","IND_ONLY","NONE"}),
		MoveModes = list.CountList:new(3),
		ReachableLines = list.ValueList:new(2),
		ReachableWalkDrive = list.ValueList:new(2),
		DifTownsCount = list.CountList:new(3),
		DestUpdate = list.ValueList:new(),
		EntAtTerminal = list.CountList:new(),
		EntMoving = list.CountList:new(),
		ArrivalTime = list.ValueList:new(),
		-- EntAtBuilding = list.CountList:new(),
		-- EntAtVehicle = list.CountList:new(),
		vehicleswithpass = list.CountList:new(),
		vehiclesPass = list.CountList:new(),
	}
	-- local towns_ = game.interface.getTowns()
	-- table.insert(towns_, -1)
	-- local towns = list.CountList:new(towns_)
	
	for _,id in pairs(persons) do
		local person = api.engine.getComponent(id, api.type.ComponentType.SIM_PERSON)
		d.curDestination:count(persondata.getDestType(person.destinations, person.targetOrAtEntity) )
		d.Destinations:count(persondata.getDests(person.destinations))
		d.MoveModes:count(person.lastMoveMode+1)  -- 0 walk, 1 car, 2 lines
		--person.moveModes
		-- list.add(towns, persondata.getTown(person.destinations[1]), 1)  -- Living place
		d.DifTownsCount:count(persondata.getDifTownsCount(person.destinations))
		d.ReachableLines:newVal(person.landUse2ReachableLines)
		d.ReachableWalkDrive:newVal(person.landUse2ReachableWalkDrive)
		--game.interface.getDestinationDataPerson(id, true)  -- bool?  only 0s ???
		d.DestUpdate:newVal(person.lastDestinationUpdate)
		
		local eaTerminal = api.engine.getComponent(id, api.type.ComponentType.SIM_ENTITY_AT_TERMINAL)
		if eaTerminal then
			d.EntAtTerminal:count()
			d.ArrivalTime:newVal(eaTerminal.arrivalTime, eaTerminal.arrivalTime>0)
		end
		d.EntMoving:count(nil,nil,api.engine.getComponent(id, api.type.ComponentType.SIM_ENTITY_MOVING)~=nil)  --lineStop1-lineStop0
		
		-- d.EntAtBuilding:count(nil,nil,api.engine.getComponent(id, api.type.ComponentType.SIM_ENTITY_AT_BUILDING)~=nil)  --not included with getEntities
		-- local eaVehicle = api.engine.getComponent(id, api.type.ComponentType.SIM_ENTITY_AT_VEHICLE) -- not included
	end
	
	d.ReachableLines:finish()
	d.ReachableWalkDrive:finish()
	d.DestUpdate:finish()
	d.ArrivalTime:finish()
	
	local vehicles = game.interface.getEntities(circle, {type="VEHICLE"})
	local vehicle2CargosMap = api.engine.system.simEntityAtVehicleSystem.getVehicle2Cargo2SimEntitesMap() --5ms
	for _,vid in pairs(vehicles) do
		local vehiclecargo = vehicle2CargosMap[vid]
		if vehiclecargo then
			d.vehicleswithpass:count(nil,nil,#vehiclecargo[1]>0)
			d.vehiclesPass:count(nil,#vehiclecargo[1])
		end
	end
	
	-- local Dest2SpMap = api.engine.system.simPersonSystem.getDestination2SpMap()  -- 10ms
	-- d.countdest = 0
	-- for dest,persons in pairs(Dest2SpMap) do  -- contains same persons up to 3 times
		-- d.countdest = d.countdest + #persons
	-- end
	
	--api.engine.system.simPersonSystem.getSimPersonsAtTerminalForTransportNetwork(0) tp id??
	
	d.countall = api.engine.system.simPersonSystem.getCount()
	-- d.count = d.DestUpdate.num--num0
	return d
end


function persondata.getDestType(destinations, target)
	for i,dest in pairs(destinations) do
		if target==dest then
			return i
		end
	end
	error("persondata.getDestType target not in destinations")
end

function persondata.getDests(destinations)
	assert(destinations[1]>0)
	if destinations[2]>0 and destinations[3]>0 then
		return "ALL"
	elseif destinations[2]>0 and destinations[3]==-1 then
		return "COM_ONLY"
	elseif destinations[2]==-1 and destinations[3]>0 then
		return "IND_ONLY"
	else
		return "NONE"
	end
end

function persondata.getTown(destID)
	if destID == -1 then
		return nil
	end
	-- local tbs = game.interface.getEntity(destID).townBuildings
	local comp = api.engine.getComponent(destID, api.type.ComponentType.CONSTRUCTION)  -- dont index directly!
	local tbs = comp.townBuildings
	if #tbs==0 then
		return destID
	else
		-- return game.interface.getEntity(tbs[1]).town
		assert(#tbs==1)
		local tb = tbs[1]  -- this assign really makes the errors disappear?
		if tb==nil then
			print("tbs")
			debugPrint(tbs)
			debugPrint(tbs[1])
			print(#tbs)
			assert("tb==nil")
			-- return -1
		end
		local comp = api.engine.getComponent(tb, api.type.ComponentType.TOWN_BUILDING)
		return comp.town
	end
end

function persondata.getDifTownsCount(destinations)
	local towns = {}
	for i,dest in pairs(destinations) do
		table.insert(towns, persondata.getTown(dest))  -- nil omitted
	end
	local te = {}
	local ret = 0
	for i,town in pairs(towns) do  --max 3
		local exist = false
		for i,t in pairs(te) do
			if town==t then
				exist = true
				break
			end
		end
		if not exist then
			table.insert(te, town)
			ret = ret + 1
		end
	end
	return ret
	-- if destnotdifferent(towns[1],towns[2]) and destnotdifferent(towns[1],towns[3]) then
		-- return 1
	-- elseif destnotdifferent(towns[1],towns[2]) or destnotdifferent(towns[2],towns[3]) or destnotdifferent(towns[3],towns[1]) then
		-- return 2
	-- else
		-- return 3
	-- end
	-- error("AVS persondata.getDifTownsCount")
end

-- function persondata.destnotdifferent(a,b)
	-- return a==b or a==nil or b==nil
-- end

return persondata