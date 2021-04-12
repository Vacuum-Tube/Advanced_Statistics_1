local r = {
	resname = "streetTypeRep",
	names = {},
	icons = {},
	availability = {},
	speed = {},
	data = {},
}

r.init = function()
	r.all = api.res.streetTypeRep.getAll()
	for idx,filename in pairs(r.all) do
		local street = api.res.streetTypeRep.get(idx)
		local name = street.name
		r.names[filename] = name=="" and "?"..filename or name
		r.icons[filename] = street.icon
		r.availability[filename] = {
			yearFrom = street.yearFrom,
			yearTo = street.yearTo,
		}
		r.speed[filename] = street.speed
		r.data[filename] = {
			visible = not street.upgrade,
			country = street.country,
		}
	end
end

return r