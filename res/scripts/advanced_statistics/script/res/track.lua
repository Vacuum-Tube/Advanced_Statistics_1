local r = {
	resname = "trackTypeRep",
	names = {},
	icons = {},
	availability = {},
	speed = {},
	data = {},
}

r.init = function()
	r.all = api.res.trackTypeRep.getAll()
	for idx,filename in pairs(r.all) do
		local track = api.res.trackTypeRep.get(idx)
		local name = track.name
		r.names[filename] = name=="" and "?"..filename or name
		r.icons[filename] = track.icon
		r.availability[filename] = {
			yearFrom = track.yearFrom,
			yearTo = track.yearTo,
		}
		r.speed[filename] = track.speedLimit
		-- r.data[filename] = {
			
		-- }
	end
end

return r