local list = require "advanced_statistics/script/listutil"

local carriers = require "advanced_statistics/script/res/carriers"
local states = {"EN_ROUTE","AT_TERMINAL","GOING_TO_DEPOT","IN_DEPOT"}

local vehicledata = {}


function vehicledata.getInfo(circle)
	--global game.interface.getVehicles()
	local vehicles = game.interface.getEntities(circle, {type="VEHICLE", includeData = truee })
	-- local vehicles = game.interface.getVehicles{carrier=carr} -- line= , depot= , 
	local num = #vehicles
	-- local num = (num0==0) and -1 or num0  -- avoid 0/0 = -nan(ind) because this leads to .sav.lua not readable
	
	local d = {
		count = num
	}
	for _,carr in pairs(carriers.carriersAll) do
		-- d[carr] = vehicledata.getCarrierInfo(carr)
		d[carr] = {
			-- count = num0,
			Speed = list.ValueList:new(),
			Waiting = list.CountList:new(),
			Parts = list.ValueList:new(),
			Purchase = list.ValueList:new(),
			Condition = list.ValueList:new(),
			State = list.CountList:new(states),
			Stopped = list.CountList:new(),
			DoorsOpen = list.CountList:new(),
			DoorsTime = list.ValueList:new(),
			Models = list.CountList:new(0,true),
		}
	end
	-- d["ALL"] = vehicledata.getCarrierInfo(nil)
	-- return d
-- end

-- function vehicledata.getCarrierInfo(carr)
	-- local d = 
	
	for _,id in pairs(vehicles) do
		local vehicle = game.interface.getEntity(id)
		local carr = vehicle.carrier
		local comp = api.engine.getComponent(id, api.type.ComponentType.TRANSPORT_VEHICLE)
		vehicledata.setVehicleCarrierInfo(d[carr], vehicle, comp)
		vehicledata.setVehicleCarrierInfo(d["ALL"], vehicle, comp)
	end
	
	for _,carr in pairs(carriers.carriersAll) do
		local c = d[carr]
		c.Condition:finish()
		c.Purchase:finish()
		c.Parts:finish()
		c.Speed:finish()
		c.DoorsTime:finish()
		c.count = c.Speed.num
	end
	
	return d
end

function vehicledata.setVehicleCarrierInfo(c, vehicle, comp)
	c.State:count(vehicle.state)
	c.Speed:newVal(vehicle.speed)
	--vehicle.capacities[cargo]
	--vehicle.cargoLoad
	local parts = vehicledata.getPartsInfo(vehicle.vehicles)
	c.Parts:newVal(parts.num)
	c.Condition:newVal(parts.condition)
	c.Purchase:newVal(parts.purchase)
	for i,mdl in pairs(parts.models) do
		c.Models:count(mdl)
	end
	c.Stopped:count(nil,nil,comp.userStopped)
	c.Waiting:count(nil,nil,vehicle.speed==0 and comp.userStopped==false and vehicle.state~="AT_TERMINAL" )
	c.DoorsOpen:count(nil,nil,comp.doorsOpen)
	c.DoorsTime:newVal(comp.doorsTime, comp.doorsTime>0)  -- usec
	-- comp.noPath
	-- comp.sectionTimes  -- [1], [2]
	
	-- api.engine.getComponent(1823,api.type.ComponentType.TRAIN)
end

function vehicledata.getPartsInfo(vehicles)
	local condition = list.newList()
	local purchase = list.newList()
	local models = {}
	for _,part in pairs(vehicles) do
		list.addsum(condition, part.condition)
		list.setmin(purchase, part.purchaseTime)  --ms
		table.insert(models, part.fileName)
	end
	return {
		num = #vehicles,
		condition = condition.sum/#vehicles,
		purchase = purchase.min,
		--lastedit = purchase.max,
		models = models,
	}
end

return vehicledata