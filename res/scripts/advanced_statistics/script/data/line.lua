local list = require "advanced_statistics/script/listutil"

local carriers = require "advanced_statistics/script/res/carriers"

local linedata = {}

function linedata.getInfo()
	-- local lines = game.interface.getLines()--{stationGroup= }
	local lines = api.engine.system.lineSystem.getLines()
	-- local lines = game.interface.getEntities({radius=math.huge},{type="LINE"})  -- not working
	-- local num0 = #lines
	-- local num = (num0==0) and -1 or num0  -- avoid 0/0 = -nan(ind) because this leads to .sav.lua not readable
	
	local d = {
		count = #lines,
		Fare = api.engine.system.simEntityAtVehicleSystem.getFare(),
	}
	for _,mode in pairs(carriers.transportModesLine) do
		d[mode] = {
			count = list.CountList:new(),
			Time = list.ValueList:new(),
			Rate = list.ValueList:new(),
			Stops = list.ValueList:new(),
			Transported = list.ValueList:new(),
			TransportedCargoTypes = list.CountList:new({},true),
			Price = list.ValueList:new(),
		}
	end
	local tTransportModes = list.CountList:new(#carriers.transportModes)
	
	for _,id in pairs(lines) do
		local line = game.interface.getEntity(id)
		local comp = api.engine.getComponent(id, api.type.ComponentType.LINE)
		local transportModes = comp.vehicleInfo.transportModes  -- this really makes the errors disappear?
		local test = 0
		for mode,bool in pairs(transportModes) do
			if mode<=13 and (bool==0 or bool==1)==false then
				print("TPF - WTF?","LINE transportMode","mode:",mode, "Value:",bool)
			end
			if mode>13 and bool~=0 then
				print("TPF - WTF?","LINE transportMode ","mode>13",mode,"id",id)
				debugPrint(transportModes)
			end
			assert(bool==0 or (mode>=4 and mode<=13))
			test = test + bool
			if bool==1 then
				tTransportModes:count(mode)
				linedata.setLineTpmodeInfo(d[carriers.transportModes[mode]], line, comp)
			end
		end
		linedata.setLineTpmodeInfo(d["ALL"], line, comp)
		if test>1 then
			print("LINE transportMode Sum:",test,id)
			debugPrint(transportModes)
			assert(false)
		end
	end
	
	d.ALL.TransportModes = {}
	for mode,count in pairs(tTransportModes) do
		-- if mode>3 then  -- omit person, cargo, car
			d.ALL.TransportModes[carriers.transportModes[mode]] = count
		-- end
	end
	d.ALL.TransportModes.ALL = d.count
	
	for _,mode in pairs(carriers.transportModesLine) do
		local c = d[mode]	
		c.Time:finish()
		c.Rate:finish()
		c.Stops:finish()
		c.Transported:finish()
		c.Price:finish()
		c.count = c.count.count_
	end
	
	return d
end

function linedata.setLineTpmodeInfo(c, line, comp)
	c.count:count()
	if line.frequency~=0 then
		c.Time:newVal(1/line.frequency)
		c.Rate:newVal(line.rate)
		c.Transported:newVal(line.itemsTransported._sum)
		for cargo,transported in pairs(line.itemsTransported) do
			if cargo:sub(0,1)~="_" then
				c.TransportedCargoTypes:count(cargo,transported)
			end
		end
		c.Stops:newVal(#comp.stops)
		c.Price:newVal(comp.vehicleInfo.defaultPrice)
	end
end

return linedata