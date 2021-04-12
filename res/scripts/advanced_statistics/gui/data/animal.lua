local format = require "advanced_statistics/gui/format"
local guio = require "advanced_statistics/gui/objects"
local res = require "advanced_statistics/script/res/model"

return {
	name = _("Animals"),
	gamebartext = function(data) return
		tostring(data.counts.num)
	end,
	-- gamebartooltip = function(data) return
	-- end,
	windowlayout = function(updatedata) return {
		{ table = {
			{
				string.format("%s (%s)", _("Count"), _("Groups") ),
				function(data) return
					format.Number(data.counts.num)
				end
			},
			{
				string.format("%s (%s)", _("Count"), _("Models") ),
				function(data) return
					format.Number(data.counts.sum)
				end
			},
			-- {
				-- _("Invalid Tile"),
				-- function(data) return
					-- tostring(data.invalidTile.count_)
				-- end
			-- },
		}},
		
		"<hline>",
		{	text = _("List"),
			style = "AVSHeading2"
		},
		guio.ResList( function() return updatedata().models end, res.names, nil, true ),
		
	} end
}