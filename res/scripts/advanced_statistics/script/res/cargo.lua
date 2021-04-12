local r = {
	resname = "cargoTypeRep",
	names = {},
	icons = {},
	weight = {},
}

-- local CargoTypes = game.interface.getCargoTypes()

r.init = function()
	r.all = api.res.cargoTypeRep.getAll()
	for idx,id in pairs(r.all) do
		local cargoType = api.res.cargoTypeRep.get(idx)
		r.names[id] = cargoType.name
		r.icons[id] = cargoType.icon
		--iconSmall
		r.weight[id] = cargoType.weight  -- kg
	end
end
--  api.res.cargoTypeRep.getName(cargoID)

return r