local list = require "advanced_statistics/script/listutil"
local res = require "advanced_statistics/script/res/model"

local signaldata = {}

-- local states_ = {0,1} --{"off", "on" }
local sigtypes_ = {
	"SIGNAL",
	"ONE_WAY_SIGNAL",
	"WAYPOINT",
}

function signaldata.getInfo(circle)
	local signals = game.interface.getEntities(circle, { type = "SIGNAL", includeData = true })
	
	local num = 0
	local d = {
		Sigtypes = list.CountList:new(sigtypes_),
		States = list.CountList:new(2),
		StTimes = list.ValueList:new(),
		models = {},
	}
	local tmodels = list.CountList:new({},true)
	
	for id,signal in pairs(signals) do
		num = num + 1
		d.Sigtypes:count(signal.signalType)
		d.States:count(signal.state+1) -- 0 off, 1 on
		d.StTimes:newVal(signal.stateTime, signal.stateTime>0) -- usec  lastActivationTimes
		local mil = api.engine.getComponent(id, api.type.ComponentType.MODEL_INSTANCE_LIST)
		local fatInstances = mil.fatInstances
		tmodels:count(fatInstances[1].modelId)
	end
	
	for modelId,count in pairs(tmodels) do
		d.models[res.all[modelId+1]] = count
	end
	
	d.StTimes:finish()
	d.count = num
	return d
end

return signaldata