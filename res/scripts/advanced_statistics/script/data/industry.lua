local list = require "advanced_statistics/script/listutil"

local industrydata = {}

function industrydata.getInfo(circle)
	local interface = game.interface
	local industries = interface.getEntities(circle, { type = "SIM_BUILDING", includeData = true })  --0.09
	local num0 = 0
	
	local d = {
		Upgrade = list.CountList:new(),
		Downgrade = list.CountList:new(),
		Levels = list.CountList:new(0, true),
		AutoUpgrade = list.CountList:new(),
		Filename = list.CountList:new({},true),
		Production = list.ValueList:new(),
		ProductionLimit = list.ValueList:new(),
		Shipping = list.ValueList:new(),
		-- Transport = list.ValueList:new(),
		TransportAbs = list.ValueList:new(),
		TotalProduced = list.ValueList:new(),
		TotalShipped = list.ValueList:new(),
		TotalConsumed = list.ValueList:new(),
		-- TotalConsumedVehicleUsed = list.ValueList:new(),
	}
	
	for id,simbuilding in pairs(industries) do
		num0 = num0 + 1
		--local simbuilding = api.engine.getComponent( , api.type.ComponentType.SIM_BUILDING)
		local level = simbuilding.level + 1  -- 1-4 -- or more...
		d.Levels:count(level)
		local upgradeProgress = simbuilding.upgradeProgress  --  -300 - 0 - 300 ?
		d.Upgrade:count(nil, 1, upgradeProgress>200 )
		d.Downgrade:count(nil, 1, upgradeProgress<-200 )
		
		d.TotalProduced:newVal(simbuilding.itemsProduced._sum)
		d.TotalShipped:newVal(simbuilding.itemsShipped._sum)
		d.TotalConsumed:newVal(simbuilding.itemsConsumed._sum)
		-- d.TotalConsumedVehicleUsed:newVal(simbuilding.itemsConsumedVehicleUsed._sum)  -- always 0 ?
		
		local cid = simbuilding.stockList
		-- local construction = interface.getEntity(cid)
		local construction = api.engine.getComponent(cid, api.type.ComponentType.CONSTRUCTION)
		d.Filename:count(construction.fileName)
		d.AutoUpgrade:count(nil, 1, construction.params.autoUpgrade~=0 )  -- autoUpgrade maybe nil
		d.Production:newVal(interface.getIndustryProduction(cid))
		d.ProductionLimit:newVal(interface.getIndustryProductionLimit(cid))
		d.Shipping:newVal(interface.getIndustryShipping(cid))
		-- d.Transport:newVal(interface.getIndustryTransportRating(cid))  -- %
		d.TransportAbs:newVal(interface.getIndustryTransportRating(cid)*interface.getIndustryShipping(cid))
	end
	
	d.count = num0
	d.Production:finish()
	d.Shipping:finish()
	-- d.Transport:finish()
	d.TransportAbs:finish()
	d.Production:setRel(d.ProductionLimit.sum)
	d.Shipping:setRel(d.Production.sum)
	d.TransportAbs:setRel(d.Shipping.sum)
	return d
end

return industrydata