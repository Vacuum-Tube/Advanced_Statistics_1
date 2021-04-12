local r = {
	resname = "railroadCrossingTypeRep",
	names = {},
	icons = {},
	availability = {},
}

r.init = function()
	r.all = api.res.railroadCrossingTypeRep.getAll()
	for idx,filename in pairs(r.all) do
		local rc = api.res.railroadCrossingTypeRep.get(idx)
		r.names[filename] = rc.name
		r.icons[filename] = rc.icon
		r.availability[filename] = {
			yearFrom = rc.yearFrom,
			yearTo = rc.yearTo,
		}
	end
end

return r