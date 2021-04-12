local r = {
	resname = "multipleUnitRep",
	names = {},
}

r.init = function()
	r.all = api.res.multipleUnitRep.getAll()
	for idx,filename in pairs(r.all) do
		local mu = api.res.multipleUnitRep.get(idx)
		r.names[filename] = mu.name
		--#mu.vehicles
	end
end

return r