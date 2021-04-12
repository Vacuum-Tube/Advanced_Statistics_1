local s = {}

-- Pre cache Translation cause its not working in onStep

local translate = {
	"RESIDENTIAL", "COMMERCIAL", "INDUSTRIAL",
	"ALL", "ROAD","RAIL","TRAM","AIR","WATER",
	"PERSON", "CARGO", "CAR", "BUS", "TRUCK", "TRAM", "ELECTRIC_TRAM", "TRAIN", "ELECTRIC_TRAIN",
	"AIRCRAFT", "SHIP", "SMALL_AIRCRAFT", "SMALL_SHIP",
	"TRACK","STREET",
	"welcome_text","Welcome back",
	"Capacities",
}

for i,str in pairs(translate) do
	s[str] = _(str)
end

local translate_mt = {
	__index = function(table,key)
		if key=="__metatag__" then return end
		error("key: "..key)
		-- return key
	end,
	__call = function(s,key)
		return s[key]
	end,
}
setmetatable(s, translate_mt)
-- s.__metatag__ = 0

s.header = {
	scriptde = "Script ".._("Deactivated"),
	alwaysac = _("Always").." ".._("Active"),
	nowac = _("Now").." ".._("Active"),
	notac = _("Not").." ".._("Active"),
}

-- print("Loaded Strings")
-- debugPrint(s)

return s