local function tablecopy(obj)
	if type(obj) == 'table' or type(obj) == 'userdata' then
		local res = { }
		for k, v in pairs(obj) do
			res[table.copy(k)] = table.copy(v)
		end
		return res
	else
		return obj
	end
end

local c = {}

function c.getInfo()
	-- local d = api.res.getBaseConfig()  -- userdata
	
	-- return toString(d)
	-- return tablecopy(d)  -- error: sol: cannot call '__pairs/pairs' on type 'sol::as_container_t<BaseConfig>': it is not recognized as a container
	return game.config
end

return c