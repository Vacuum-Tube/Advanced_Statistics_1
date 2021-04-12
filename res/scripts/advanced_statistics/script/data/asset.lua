local list = require "advanced_statistics/script/listutil"
local res = require "advanced_statistics/script/res/model"

local assetdata = {}

function assetdata.getInfo(circle)
	local assetgroups = game.interface.getEntities(circle, { type = "ASSET_GROUP", includeData = true })
	-- local num0 = 0
	local counts = list.ValueList:new()
	local notautoremove = list.CountList:new()
	-- local tmodels = list.CountList:new(0,true)
	local models = list.CountList:new(0,true)
	-- local models = {}
	local models_ = list.CountList:new{
		"tree",
		"rock",
		"cube",
		"fences",
	}
	
	
	for id,asset in pairs(assetgroups) do
		-- num0 = num0 + 1
		counts:newVal(asset.count)
		-- aremove:count(nil, nil, asset.autoRemove)
		notautoremove:count(nil, nil, asset.autoRemove==false)
		for filename,number in pairs(asset.models) do
			models:count(filename,number)
		end
	end
	
	--[[   forget it, the new api is waaay slower in total, in this case
	for _,id in pairs(assetgroups) do
		-- aid = id
		-- local 
		-- fatInstances = api.engine.getComponent(id, api.type.ComponentType.MODEL_INSTANCE_LIST).fatInstances  -- problematic, may contain garbage, leading to errors
		local mil = api.engine.getComponent(id, api.type.ComponentType.MODEL_INSTANCE_LIST)
		local fatInstances = mil.fatInstances
		local thinInstances = mil.thinInstances
		-- assert(#fatInstances>0)
		-- assert(#fatInstances<1000)
		for i,finst in pairs(fatInstances) do
			assert(finst.modelId>=0)
			tmodels:count(finst.modelId)
		end
		for i,tinst in pairs(thinInstances) do  -- very much
			assert(tinst.modelId>=0)
			tmodels:count(tinst.modelId)
		end
		notautoremove:count(nil, nil, api.engine.getComponent(id, api.type.ComponentType.ASSET_GROUP_AUTOREMOVE)==nil)
		counts:newVal(#fatInstances+#thinInstances)
	end
	
	for modelId,number in pairs(tmodels) do
		local filename = res.all[modelId+1]
		if filename then
			models[filename] = number
			
		-- else  -- happening only if model got removed from savegame
			-- print("model: "..modelId)
		end
	end
	]]
	
	for filename,number in pairs(models) do
			if filename:starts("tree") then
				models_:count("tree", number)
			elseif filename:starts("asset/rocks") then
				models_:count("rock", number)
			elseif filename=="placeholders/missing_generic.mdl" then
				models_:count("cube", number)
			elseif filename:starts("snowball/fences") then
				models_:count("fences", number)
			end
	end
	
	counts:finish()
	
	return {
		-- countgroups = num0, --#assetgroups,
		counts = counts,
		notautoremove = notautoremove.count_,
		models = models,
		models_ = models_,
	}
end

return assetdata