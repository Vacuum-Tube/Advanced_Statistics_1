local guibuilder = require "advanced_statistics/gui/guibuilder"
local guio = require "advanced_statistics/gui/objects"
local __ = require "advanced_statistics/strings"
local format = require "advanced_statistics/gui/format"
local a,v,s,o = require "advanced_statistics/adv".sks()

local carriers = require "advanced_statistics/script/res/carriers"

return {
	name = _("Depots"),
	icon = "ui/icons/construction-menu/filter_depots.tga",
	gamebartext = function(data) return
		data.count
	end,
	gamebartooltip = function(data) return
		format.linesList(carriers.carriersAll, "%s: %d", function(carr)
			return __(carr), data.CarriersCount[carr]
		end)
	end,
	windowlayout = function(updatedata) return {
	
		-- { table = {
			-- {
				-- _("Count"),
				-- function(data) return
					-- data.count
				-- end
			-- },
		-- }},
		
		guio.Table( carriers.carriersAll, {
			function(carr)
				return { text=_(carr), style="AVS-resource-name-text" }
			end,
			function(carr) return function(data) return
					data.CarriersCount[carr]
			end	end,
		},{
			"",-- _("Carrier"),
			_("Count"),
		},updatedata,false),
		
		"<hline>",
		{ table = {
			{
				_("Last Used")..(" (".._("Latest")..")"),
				function(data) return
					format.Age(data.StTimes.max/1e3)
				end
			},
			{
				_("Last Used").." (".._("Oldest")..")",
				function(data) return
					format.Age(data.StTimes.min/1e3)
				end
			},{
				-- _("Last Used")..format.str.av,
				-- function(data) return
					-- data.StTimes.av and format.Age(data.StTimes.av/1e3) or "-"
				-- end
			-- },{
				_("Never Used"),
				function(data) return
					(data.count - data.StTimes.num)
				end
			},
		}},
	
	} end
}