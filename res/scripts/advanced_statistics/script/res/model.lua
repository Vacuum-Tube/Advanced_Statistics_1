local list = require "advanced_statistics/script/listutil"

local mtypes = {
	"tree",
	"rock",
	"person",
	"car",
	"animal",
	"signal",
	"vehicleDepot",
	"transportVehicle",
	"roadVehicle",
	"railVehicle",
	"airVehicle",
	"waterVehicle",
	"emission",
	"particleSystem",
}
local r = {
	resname = "modelRep",
	names = {},
	icons = {},
	availability = {},
	data = {},
	
	types = mtypes,
	counts = list.CountList:new(mtypes),
	counts_vanilla = {
		tree = 28,
		rock = 11,
		person = 37,
		car = 34,
		animal = 8,
		signal = 31,
		vehicleDepot = 7,
		transportVehicle = 352,
		roadVehicle = 120,
		railVehicle = 208,
		airVehicle = 30,
		waterVehicle = 28,
		particleSystem = 575,
		emission = 386,
	}
}

r.init = function()
	r.all = api.res.modelRep.getAll()
	for idx,filename in pairs(r.all) do
		local model = api.res.modelRep.get(idx-1)  -- modelRep starts with 1 ???
		local name = model.metadata.description.name
		r.names[filename] = name=="" and "?"..filename or name
		r.icons[filename] = model.metadata.transportVehicle and model.metadata.description.icon20 or model.metadata.description.icon  -- not existent icon files create "Texture load error: file not found" warnings
		r.availability[filename] = model.metadata.availability and {
			yearFrom = model.metadata.availability.yearFrom,
			yearTo = model.metadata.availability.yearTo,
		} or {}
		r.data[filename] = {
			size = r.getSize(model.boundingInfo),
			volume = r.getVolume(model.boundingInfo),
			price = model.metadata.cost and model.metadata.cost.price~=-1 and model.metadata.cost.price or false,
		}
		for _,mtype in pairs(mtypes) do
			r.counts:count(mtype,nil,model.metadata[mtype]~=nil)
		end
	end
end

r.getSize = function(bb)
	return {
		x = (bb.bbMax.x-bb.bbMin.x),
		y = (bb.bbMax.y-bb.bbMin.y),
		z = (bb.bbMax.z-bb.bbMin.z),
	}
end
r.getVolume = function(bb)
	return (bb.bbMax.x-bb.bbMin.x)*(bb.bbMax.y-bb.bbMin.y)*(bb.bbMax.z-bb.bbMin.z)
end

return r