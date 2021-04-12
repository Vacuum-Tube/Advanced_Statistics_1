local list = require "advanced_statistics/script/listutil"
local res = require "advanced_statistics/script/res/cargo"

local cargodata = {}

function cargodata.getInfo(circle)
	local cargos = game.interface.getEntities(circle, { type = "SIM_CARGO", includeData = truee })
	
	local d = {
		count = #cargos,
		startTime = list.ValueList:new(),
		vehicleUsed = list.CountList:new(),
		EntAtTerminal = list.CountList:new(),
		EntAtStock = list.CountList:new(),
		ArrivalTime = list.ValueList:new(),
		CargoTypeVisible = {},
		vehicle2Cargo = {},
		vehicleswithcargo = list.CountList:new(),
	}
	local tCargoType = list.CountList:new({},true)
	local tvehicle2Cargo = list.CountList:new({},true)
	
	for _,id in pairs(cargos) do
		local simcargo = api.engine.getComponent(id, api.type.ComponentType.SIM_CARGO)
		tCargoType:count(simcargo.cargoType)
		d.vehicleUsed:count(nil,nil,simcargo.vehicleUsed)  -- ?
		d.startTime:newVal(simcargo.startTime, simcargo.startTime>0)  -- ms
		local eaTerminal = api.engine.getComponent(id, api.type.ComponentType.SIM_ENTITY_AT_TERMINAL)
		if eaTerminal then
			d.EntAtTerminal:count()
			d.ArrivalTime:newVal(eaTerminal.arrivalTime, eaTerminal.arrivalTime>0)
		end
		d.EntAtStock:count(nil,nil, api.engine.getComponent(id, api.type.ComponentType.SIM_ENTITY_AT_STOCK)~=nil)
	end
	
	d.startTime:finish()
	d.ArrivalTime:finish()
	
	--api.engine.system.stockListSystem.getCargoType2stockList2sourceAndCount()
	--api.engine.system.simCargoSystem.
	
	local vehicles = game.interface.getEntities(circle, {type="VEHICLE"})
	local vehicle2CargosMap = api.engine.system.simEntityAtVehicleSystem.getVehicle2Cargo2SimEntitesMap() --5ms
	-- for vehicle,cargos in pairs(vehicle2CargosMap) do
	for _,vid in pairs(vehicles) do
		local vehiclecargo = vehicle2CargosMap[vid]
		if vehiclecargo then
			d.vehicleswithcargo:count()
			for cargoId,cargoentities in pairs(vehiclecargo) do  -- 1-17
				tvehicle2Cargo:count(cargoId, #cargoentities)
			end
		end
	end
	
	for cargoId,count in pairs(tvehicle2Cargo) do
		if count>0 then
			d.vehicle2Cargo[res.all[cargoId-1]] = count  -- why you always switch between 0 and 1 ...
		end
	end
	for cargoId,count in pairs(tCargoType) do
		d.CargoTypeVisible[res.all[cargoId]] = count
	end
	
	return d
end

return cargodata