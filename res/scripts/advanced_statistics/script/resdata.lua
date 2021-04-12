local reslist = require "advanced_statistics/script/reslist"
local format = require "advanced_statistics/gui/format"
local timer = require "advanced_statistics/script/timer"
local logg = require "advanced_statistics/log"
local log = (require "advanced_statistics/log").logPrefix("res")

local r = {
	calctime = {},
}

for _,resstr in pairs(reslist) do
	r[resstr] = require("advanced_statistics/script/res/"..resstr)
end

r.init = function(prin)
	for _,resstr in pairs(reslist) do
		log(prin and 2,"Calc res",resstr)
		timer.start()
		local res = r[resstr]
		res.init()
		res.num = #res.all
		res.index = {}
		local apires = api.res[res.resname]
		if apires.isVisible then
			res.visible = {}
		end
		for idx,filename in pairs(res.all) do
			log(prin and 3, idx, filename)
			res.index[filename] = idx
			if res.visible then
				res.visible[filename] = apires.isVisible(idx)
			end
		end
		r.calctime[resstr] = timer.round()
		log(prin and 2,"Time:",format.TimeMilSec(r.calctime[resstr]))
		logg.logTab(prin and 4, res)  -- blocks simulation very long time after start
	end
end

r.counts_vanilla = {
	cargo = 17,
	construction = 533,
	model = 3712,
	track = 2,
	street = 34,
	bridge = 5,
	tunnel = 2,
	building = 486,
	railroadcrossing = 11,
	multipleunit = 5,
}

return r