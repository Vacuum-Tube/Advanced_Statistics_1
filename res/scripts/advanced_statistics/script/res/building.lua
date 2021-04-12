local list = require "advanced_statistics/script/listutil"

local landuseTypes = {"RESIDENTIAL","COMMERCIAL","INDUSTRIAL"}

local r = {
	resname = "buildingTypeRep",
	data = {},
	-- landUse = list.CountList:new(landuseTypes),
	-- levels = list.CountList:new(4,true),  -- some mods are not 1-4 ...
}

-- game.interface.getBuildingTypes()

r.init = function()
	r.all = api.res.buildingTypeRep.getAll()
	for idx,filename in pairs(r.all) do
		-- api.res.buildingTypeRep.get(idx)  -- userdata, not working?
		local building = game.interface.getBuildingType(filename)
		r.data[filename] = {
			landuse = building.landUseType,
			level = building.level,
		}
		-- r.landUse:count(building.landUseType)
		-- r.levels:count(building.level)
		--building.parcelSize
	end
end

return r