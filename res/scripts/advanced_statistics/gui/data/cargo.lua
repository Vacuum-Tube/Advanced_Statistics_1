local format = require "advanced_statistics/gui/format"
local guio = require "advanced_statistics/gui/objects"
local res = require "advanced_statistics/script/res/cargo"

return {
	name = _("Cargo Entities"),
	icon = "ui/icons/construction-menu/filter_cargo.tga",
	gamebartext = function(data) return
		tostring(data.count)
	end,
	-- gamebartooltip = function(data) return
	-- end,
	windowlayout = function(updatedata) return {
		{ table = {
			{
				string.format("%s (%s)", _("Count"), _("Visible")),
				function(data) return
					tostring(data.count)
				end
			},
			{
				string.format("%s (%s)", _("Count"), _("At terminal")),
				function(data) return
					tostring(data.EntAtTerminal.count_)
				end
			},
			{
				string.format("%s (%s)", _("Count"), _("At stock")),
				function(data) return
					tostring(data.EntAtStock.count_)
				end
			},
		},
		tooltip = _("CargoVisibleTT")
		},
		
		guio.CargoTypesTable(function()
			return updatedata().CargoTypeVisible
		end),
		
		"<hline>",
		{	text = _("Current Travel Time"),
			style = "AVSHeading2"
		},
		{ table = {
			{
				_("Travel Time").." (".._("Latest")..")",
				function(data) return
					format.Age(data.startTime.max)
				end
			},{
				_("Travel Time")..format.str.av,
				function(data) return
					format.Age(data.startTime.av)
				end
			},{
				_("Travel Time").." (".._("Oldest")..")",
				function(data) return
					format.Age(data.startTime.min)
				end
			}
		}},
		{ table = {
			-- {
				-- _("Waiting Time").." (".._("Min")..")",
				-- function(data) return
					-- format.Age(data.ArrivalTime.max)
				-- end
			-- },
			{
				_("Waiting Time").." ".._("Terminal")..format.str.av,
				function(data) return
					format.Age(data.ArrivalTime.av)
				end
			},
			{
				_("Waiting Time").." ".._("Terminal").." (".._("Max")..")",
				function(data) return
					format.Age(data.ArrivalTime.min)
				end
			},
		}},
		
		"<hline>",
		{	text = _("Vehicle Loading"),
			style = "AVSHeading2"
		},
		{ table = {
			{
				_("Vehicles with Cargo"),
				function(data) return
					tostring(data.vehicleswithcargo.count_)
				end
			}
		}},
		
		guio.CargoTypesTable(function()
			return updatedata().vehicle2Cargo
		end),
		
	} end
}