local r = {
	resname = "tunnelTypeRep",
	names = {},
	icons = {},
	availability = {},
}

r.init = function()
	r.all = api.res[r.resname].getAll()
	for idx,filename in pairs(r.all) do
		local tunnel = api.res[r.resname].get(idx)
		r.names[filename] = tunnel.name
		r.icons[filename] = tunnel.icon
		r.availability[filename] = {
			yearFrom = tunnel.yearFrom,
			yearTo = tunnel.yearTo,
		}
	end
end

return r