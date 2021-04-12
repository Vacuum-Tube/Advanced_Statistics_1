local e = {}

function e.getAllEntities()
	local t = {}
	local comp = api.engine.getComponent(0, api.type.ComponentType.BOUNDING_VOLUME)
	local worldbox = comp.bbox
	api.engine.system.octreeSystem.findIntersectingEntities(worldbox, function(id, bounding)
		table.insert(t, id)
	end)
	return t
end

function e.forAllEntities(comptype,fn)
	local comp = api.engine.getComponent(0, api.type.ComponentType.BOUNDING_VOLUME)
	local worldbox = comp.bbox
	api.engine.system.octreeSystem.findIntersectingEntities(worldbox, function(id, bounding)
		local comp = api.engine.getComponent(id, comptype)
		if comp then
			fn(id, comp, bounding)
		end
	end)
	return t
end

return e