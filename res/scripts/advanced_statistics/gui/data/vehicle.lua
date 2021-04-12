local guibuilder = require "advanced_statistics/gui/guibuilder"
local guio = require "advanced_statistics/gui/objects"
local __ = require "advanced_statistics/strings"
local format = require "advanced_statistics/gui/format"
local style = require "advanced_statistics/gui/style"
local log = (require "advanced_statistics/log").logPrefix("window.vehicle-tab")
local a,v,s,o = require "advanced_statistics/adv".sks()
local res = require "advanced_statistics/script/res/model"

local carriers = require "advanced_statistics/script/res/carriers"
local states = {"EN_ROUTE","AT_TERMINAL","GOING_TO_DEPOT","IN_DEPOT"}

return {
	-- icon = "ui/button/medium/vehicles.tga",
	-- icon = "ui/icons/construction-menu/filter_bus.tga",
	gamebartext = function(data) return
		tostring(data.count)
	end,
	gamebartooltip = function(data) return
		format.linesList(carriers.carriersAll, "%s: %d", function(carr)
			return __(carr), data[carr].count
		end)
	end,
	windowlayout = function(updatedata) return 
		guio.Tabwidget("NORTH", carriers.carriersAll, function(carr)
			log(2,"Create vehicle tab",carr)
			return {
	{	text = _("Vehicles"),
		style = "AVSHeading1"
	},
	{ table = {
		{
			_("Count"),
			function(data) return
				tostring(data.count)
			end
		},
	}},
	{	text = _("Status"),
		style = "AVSHeading2"
	},
	{ table = {
		{
			_(states[1]),
			function(data) return
				string.format("%d", data.State[states[1]] )
			end
		}, {
			_(states[2]),
			function(data) return
				string.format("%d", data.State[states[2]] )
			end
		}, {
			_(states[3]),
			function(data) return
				string.format("%d", data.State[states[3]] )
			end
		},
		-- {  -- IN_DEPOT not included anyway (no BBox)
			-- _(states[4]),
			-- function(data) return
				-- string.format("%d", data.State[states[4]] )
			-- end
		-- },
	}},
	{ table = {
		{
			_("Stopped"),
			function(data) return
				format.Int(data.Stopped.count_ )
			end
		},
		{
			{ text = _("Waiting"),
				tooltip = _("VehicleWaitingTT")
			},
			function(data) return
				format.Int(data.Waiting.count_ )
			end
		},
		a{
			_("Doors Open"),
			function(data) return
				format.Int(data.DoorsOpen.count_ )
			end
		},
		a{
			_("Never Doors Opened"),
			function(data) return
				format.Int(data.count - data.DoorsTime.num )
			end
		},
	}},
	"<hline>",
	{ table = {
		{
			_("Current Speed")..format.str.min,
			function(data) return
				format.Speed(data.Speed.min)
			end
		}, {
			_("Current Speed")..format.str.av,
			function(data) return
				format.Speed(data.Speed.av)
			end
		}, {
			_("Current Speed")..format.str.max,
			function(data) return
				format.Speed(data.Speed.max)
			end
		},
	}},
	{ table = {
		{
			_("Condition")..format.str.min,
			{ text = function(data) return
				format.Percent(data.Condition.av and data.Condition.min,1)
			end,
			style = function(data) return
				style.condition(data.Condition.av and data.Condition.min)
			end }
		}, {
			_("Condition")..format.str.av,
			{ text = function(data) return
				format.Percent(data.Condition.av,1)
			end,
			style = function(data) return
				style.condition(data.Condition.av)
			end }
		}, {
			_("Condition")..format.str.max,
			{ text = function(data) return
				format.Percent(data.Condition.av and data.Condition.max, 1)
			end,
			style = function(data) return
				style.condition(data.Condition.av and data.Condition.max)
			end }
		}, 
	}},
	{ table = {
		{
			_("Age")..format.str.min,
			function(data) return
				data.Purchase.max>0 and format.Age(data.Purchase.max) or "-"
			end
		},{
			_("Age")..format.str.av,
			function(data) return
				format.Age(data.Purchase.av)
			end
		}, {
			_("Age")..format.str.max,
			function(data) return
				data.Purchase.min>0 and format.Age(data.Purchase.min) or "-"
			end
		},
	}},
	a{ table = {
		{
			_("Last Doors Open")..(" (".._("Latest")..")"),
			function(data) return
				data.DoorsTime.max>0 and format.Age(data.DoorsTime.max/1e3) or "-"
			end
		},{
			_("Last Doors Open")..format.str.av,
			function(data) return
				format.Age(data.DoorsTime.av and data.DoorsTime.av/1e3)
			end
		}, {
			_("Last Doors Open").." (".._("Oldest")..")",
			function(data) return
				data.DoorsTime.min>0 and format.Age(data.DoorsTime.min/1e3) or "-"
			end
		},
	}},
	(carr=="RAIL") and { table = {
		{
			_("Vehicle Parts")..format.str.av,
			function(data) return
				format.Value(data.Parts.av, 1)
			end
		},  {
			_("Vehicle Parts")..format.str.max,
			function(data) return
				format.Int(data.Parts.max )
			end
		}, {
			_("Vehicle Parts")..format.str.total,
			function(data) return
				format.Int(data.Parts.sum )
			end
		}
	}},
	
	
	"<hline>",
	{	text = _("Models"),
		style = "AVSHeading2"
	},
	guio.ResList( 	function() return updatedata()[carr].Models end, res.names),
	
			}
		end, carriers.icons, updatedata)
	end
}