local guibuilder = require "advanced_statistics/gui/guibuilder"
local guio = require "advanced_statistics/gui/objects"
local format = require "advanced_statistics/gui/format"
local log = (require "advanced_statistics/log").logPrefix("window.line-tab")
local a,v,s,o = require "advanced_statistics/adv".sks()

local carriers = require "advanced_statistics/script/res/carriers"

return {
	-- name = _("Lines"),
	-- icon = "ui/button/medium/lines.tga",
	-- icon = "ui/icons/game-menu/town_window_lines.tga",
	gamebartext = function(data) return
		tostring(data.count)
	end,
	gamebartooltip = function(data) return
		format.linesList(carriers.transportModesLine, "%s: %d", function(tpmode)
			return _(tpmode), data[tpmode].count
		end)
	end,
	header = false,
	windowlayout = function(updatedata) return 
		guio.Tabwidget("WEST", carriers.transportModesLine, function(tpmode)
			log(2,"Create line tab",tpmode)
			return {
	{	text = _("Lines"),
		style = "AVSHeading1"
	},
	{ table = {
		{
			_("Count"),
			function(data) return
				tostring(data.count)
			end
		},{
			_("Count").." ".._("Inactive"),
			function(data) return
				tostring(data.count-data.Time.num)
			end
		},
		a(tpmode=="ALL") and {
			{ 	text = _("Fare").." ".."(".._("General")..")",
				tooltip = _("FareTT")
			},
			function(data) return
				format.Value(updatedata().Fare,2)
			end
		}
	}},
	"<hline>",
	{ table = {
		{
			_("Frequency")..format.str.min,
			function(data) return
				format.TimeSec(data.Time.min)
			end
		}, {
			_("Frequency")..format.str.av,
			function(data) return
				format.TimeMin(data.Time.av or 0)
			end
		}, {
			_("Frequency")..format.str.max,
			function(data) return
				format.TimeMin(data.Time.max)
			end
		},
	}},
	{ table = {
		{
			_("Rate")..format.str.av,
			function(data) return
				string.format("%.0f", data.Rate.av or 0)
			end
		}, {
			_("Rate")..format.str.max,
			function(data) return
				string.format("%.0f", data.Rate.max)
			end
		},
	}}, 
	{ table = {
		{
			_("Stops")..format.str.av,
			function(data) return
				string.format("%.1f", data.Stops.av or 0)
			end
		}, {
			_("Stops")..format.str.max,
			function(data) return
				string.format("%d", data.Stops.max)
			end
		}, 
	}},
	a{ table = {
		{
			_("Ticket Price")..format.str.min,
			function(data) return
				string.format("%.2f", data.Price.min)
			end
		}, {
			_("Ticket Price")..format.str.av,
			function(data) return
				string.format("%.2f", data.Price.av or 0)
			end
		}, {
			_("Ticket Price")..format.str.max,
			function(data) return
				string.format("%.2f", data.Price.max)
			end
		},
	}}, 
	
	
	"<hline>",
	{	text = _("Transported")..format.str.total,
		style = "AVSHeading2"
	},
	{ table = {
		{
			_("All"),
			function(data) return
				format.Number(data.Transported.sum)
			end
		},
		a{
			_("Average"),
			function(data) return
				format.Number(data.Transported.av)
			end
		}, 
	}},
	
	guio.CargoTypesTable(function()
		return updatedata()[tpmode].TransportedCargoTypes
	end,
	function(key,value)
		return format.Number(value)
	end),
	
	(tpmode=="ALL") and {
		text = _("Transport Modes"),
		style = "AVSHeading2"
	},
	(tpmode=="ALL") and { table = {
		{
			-- format.linesList(carriers.transportModes, function(mode)
				-- return _(mode)
			-- end),
			-- function(data) return
				-- format.linesList(carriers.transportModes, function(mode)
					-- return data.TransportModes[mode]
				-- end)
			-- end,
			guio.NameValueList(
				function() return carriers.transportModesLine end,
				function(idx) return carriers.transportModesLine[idx] end,
				function(tpmode) return updatedata().ALL.TransportModes[tpmode] end
			),
		}
	}},
	
			}
		end, nil, updatedata )
	end
}