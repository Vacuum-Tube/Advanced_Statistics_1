local guibuilder = require "advanced_statistics/gui/guibuilder"
local guio = require "advanced_statistics/gui/objects"
local __ = require "advanced_statistics/strings"
local format = require "advanced_statistics/gui/format"
local log = (require "advanced_statistics/log").logPrefix("window.station-tab")
local a,v,s,o = require "advanced_statistics/adv".sks()

local carriers = require "advanced_statistics/script/res/carriers"

return {
	name = _("Stations"),
	icon = "ui/icons/construction-menu/filter_station.tga",
	gamebartext = function(data) return
		tostring(data.countGroups)
		-- data.ALL.count
	end,
	gamebartooltip = function(data) return
		format.linesList(carriers.carriersAll, "%s: %d", function(carr)
			return __(carr), data.CarriersCount[carr] --data[carr].count
		end)
	end,
	windowlayout = function(updatedata) return 
		-- guio.Tabwidget("NORTH", carriers.carriersAll, function(carr)
			-- log(2,"Create station tab",carr)
			-- return 
			{
			
	{ table = {
		{
		-- (carr=="ALL") and {
			{	text = _("Count").." ".._("Groups"), },
			function(data) return
				data.countGroups
			end,
		},
		{
			_("Count").." ".._("Stations").."/".._("Stops"),
			function(data) return
				data.countStations.sum
			end,
		},
		-- {
			-- _("Count").." (".._("Passenger")..")",
			-- function(data) return
				-- data.count-data.Cargo
			-- end,
			-- function(data) return
				-- format.Percent((data.count-data.Cargo)/data.count)
			-- end,
		-- },{
			-- _("Count").." (".._("Cargo")..")",
			-- function(data) return
				-- data.Cargo
			-- end,
			-- function(data) return
				-- format.Percent(data.Cargo/data.count)
			-- end,
		-- },
	},
	tooltip = _("StationGroupTT"),
	},
	
	guio.Table( carriers.carriersAll, {
		function(carr)
			return { text=_(carr), style="AVS-resource-name-text" }
		end,
		function(carr) return function(data) return
				data.CarriersCount[carr]
		end	end,
		function(carr) return function(data) return
				(data.CarriersCount[carr] - data.Cargo[carr])
		end	end,
		function(carr) return function(data) return
				data.Cargo[carr]
		end end,
		a(function(carr) return function(data) return
			format.Percent( data.Cargo[carr]/data.CarriersCount[carr], 0 )
		end end), 
	},{
		"",-- _("Carrier"),
		_("Total"),
		_("Passenger"),
		_("Cargo"),
		a(_("Cargo").." %"),
	},updatedata,false),
	
	a("<hline>"),
	a{ table = {
		{
			_("Transport Samples")..format.str.total,  -- what is this exactly?
			function(data) return
				string.format("%d | %d", data.TransportSamples.sum[1], data.TransportSamples.sum[2] )
			end
		},
		{
			_("Transport Samples")..format.str.av,
			function(data) return
				data.TransportSamples.av and string.format("%d | %d", data.TransportSamples.av[1], data.TransportSamples.av[2] ) or "-"
			end
		}
	},
	tooltip = _("TransportSamplesTT")
	},
	
	"<hline>",
	{	text = _("Waiting Cargo"),
		style = "AVSHeading2"
	},
	-- (carr=="ALL") and 
	guio.CargoTypesTable(function()
		return updatedata().CargoWaiting
	end,
	function(key,value)
		return format.Number(value)
	end),
	
	"<hline>",
	{	text = _("Loaded")..format.str.total,
		style = "AVSHeading2"
	},
	guio.CargoTypesTable(function()
		return updatedata().Loaded
	end,
	function(key,value)
		return format.Number(value)
	end),
	
	"<hline>",
	{	text = _("Unloaded")..format.str.total,
		style = "AVSHeading2"
	},
	guio.CargoTypesTable(function()
		return updatedata().Unloaded
	end,
	function(key,value)
		return format.Number(value)
	end),
	
			}
		-- end, carriers.icons, updatedata)
	end
}