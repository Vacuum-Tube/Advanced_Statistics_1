local r = {
	resname = "bridgeTypeRep",
	names = {},
	icons = {},
	availability = {},
	speed = {},
}

r.init = function()
	r.all = api.res[r.resname].getAll()
	for idx,filename in pairs(r.all) do
		local bridge = api.res[r.resname].get(idx)
		r.names[filename] = bridge.name
		r.icons[filename] = bridge.icon
		r.availability[filename] = {
			yearFrom = bridge.yearFrom,
			yearTo = bridge.yearTo,
		}
		r.speed[filename] = bridge.speedLimit
	end
end

return r