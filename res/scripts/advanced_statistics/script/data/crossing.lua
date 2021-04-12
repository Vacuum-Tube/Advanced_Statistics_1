local list = require "advanced_statistics/script/listutil"
local res = require "advanced_statistics/script/res/railroadcrossing"

local crossingdata = {}

-- local states_ = {"open", "closed" }

function crossingdata.getInfo(circle)
	local crossings = game.interface.getEntities(circle, { type = "RAILROAD_CROSSING", includeData = trueaa })  -- include not relevant
	
	local num = 0
	local d = {
		States = list.CountList:new(2),
		StTimes = list.ValueList:new(),
		types = list.CountList:new({},true),
	}
	
	for _,id in pairs(crossings) do
		local crossing = api.engine.getComponent(id, api.type.ComponentType.RAILROAD_CROSSING)
		num = num + 1
		d.States:count(crossing.state+1) -- 0 open, 1 closed
		d.StTimes:newVal(crossing.stateTime, crossing.stateTime>0) -- usec
		d.types:count(res.all[crossing.typeIndex])
	end
	
	d.StTimes:finish()
	d.count = num
	return d
end

return crossingdata