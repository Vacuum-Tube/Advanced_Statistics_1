local list = require "advanced_statistics/script/listutil"

local r = {
	resname = "constructionRep",
	names = {},
	icons = {},
	availability = {},
	type = {},
	
	contypes_ = false,
	types = {},
	counts_vanilla = {
		STREET_STATION = 2,
		RAIL_STATION = 1,
		AIRPORT = 2,
		HARBOR = 1,
		STREET_STATION_CARGO = 0,
		RAIL_STATION_CARGO = 0,
		HARBOR_CARGO = 0,
		STREET_DEPOT = 2,
		RAIL_DEPOT = 1,
		WATER_DEPOT = 1,
		INDUSTRY = 16,
		ASSET_DEFAULT = 8,
		ASSET_TRACK = 9,
		TOWN_BUILDING = 486,
		STREET_CONSTRUCTION = 3,
		NONE = 1,
		AIRPORT_CARGO = 0,
		TRACK_CONSTRUCTION = 0,
	}
}

r.init = function()
	r.contypes_ = getmetatable(api.type.enum.ConstructionType).__index;
	for typ,idx in pairs(r.contypes_) do
		r.types[idx] = typ
	end
	r.counts = list.CountList:new(r.types)
	
	r.all = api.res.constructionRep.getAll()
	for idx,filename in pairs(r.all) do
		local con = api.res.constructionRep.get(idx)
		local name = con.description.name
		r.names[filename] = name=="" and "?"..filename or name
		r.icons[filename] = con.description.icon  -- not existent icon files create "Texture load error: file not found" warnings
		--smallIcon
		-- r.availability[filename] = con.availability  -- creating garbage
		r.availability[filename] = {
			yearFrom = con.availability.yearFrom,
			yearTo = con.availability.yearTo,
		}
		r.type[filename] = r.types[con.type]
		r.counts:count(r.types[con.type])
	end
end

return r

-- {
  -- AIRPORT = 2,
  -- AIRPORT_CARGO = 16,
  -- ASSET_DEFAULT = 11,
  -- ASSET_TRACK = 12,
  -- HARBOR = 3,
  -- HARBOR_CARGO = 6,
  -- INDUSTRY = 10,
  -- NONE = 15,
  -- RAIL_DEPOT = 8,
  -- RAIL_STATION = 1,
  -- RAIL_STATION_CARGO = 5,
  -- STREET_CONSTRUCTION = 14,
  -- STREET_DEPOT = 7,
  -- STREET_STATION = 0,
  -- STREET_STATION_CARGO = 4,
  -- TOWN_BUILDING = 13,
  -- WATER_DEPOT = 9,
-- }