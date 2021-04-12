local datalist = require "advanced_statistics/datalist"

local g = {}

for _,datastr in pairs(datalist) do
	local guidata = require("advanced_statistics/gui/data/"..datastr)
	g[datastr] = guidata
	guidata.icon = guidata.icon or string.format("ui/advanced_statistics/%s.tga", datastr)
end

return g