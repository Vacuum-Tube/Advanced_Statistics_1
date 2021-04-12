local list = require "advanced_statistics/script/listutil"
local res = require "advanced_statistics/script/res/model"

local animaldata = {}

function animaldata.getInfo(circle)
	local animals = game.interface.getEntities(circle, { type = "ANIMAL", includeData = false })
	
	local d = {
		-- count = #animals,
		counts = list.ValueList:new(),
		-- movementType = list.CountList:new(3,true),
		invalidTile = list.CountList:new(),
		models = {},
	}
	local tmodels = list.CountList:new({},true)
	
	-- api.engine.system.animalMoveSystem.forEach(function(id,animal)
	-- for id,animal in pairs(animals) do
	for _,id in pairs(animals) do
		-- d.models:count(animal.modelName)
		local animal = api.engine.getComponent(id, api.type.ComponentType.ANIMAL)
		-- d.movementType:count(animal.movementType+1)
		d.invalidTile:count(nil,nil,animal.invalidTileElapsed~=0)
		local mil = api.engine.getComponent(id, api.type.ComponentType.MODEL_INSTANCE_LIST)
		local fatInstances = mil.fatInstances
		tmodels:count(fatInstances[1].modelId)
		-- for i,finst in pairs(fatInstances) do  -- all animals of a group (salmon, cranes)
			-- assert(finst.modelId>=0)
			-- tmodels:count(finst.modelId)
		-- end
		d.counts:newVal(#fatInstances)
	end
	
	for modelId,count in pairs(tmodels) do -- writing in the same table that is iterated, this value is also getting called
		d.models[res.all[modelId+1]] = count
		-- d.models[modelId] = nil
	end
	
	d.counts:finish()
	return d
end

return animaldata