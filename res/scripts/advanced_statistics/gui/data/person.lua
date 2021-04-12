local format = require "advanced_statistics/gui/format"
local a,v,s,o = require "advanced_statistics/adv".sks()

return {
	name = _("Persons"),
	-- icon = "ui/icons/construction-menu/filter_passengers.tga",
	gamebartext = function(data) return
		tostring(data.countall)
	end,
	-- gamebartooltip = function(data) return
		-- string.format(" ",  )
	-- end,
	windowlayout = function(updatedata) return {
		{ table = {
			{
				{	text = _("Count").." (".._("All")..")",
					tooltip = _("PersonCountAllTT")
				},
				{	text = function(data) return
						tostring(data.countall)
					end,
					tooltip = _("PersonCountAllTT")
				},
				{ tooltip = _("PersonCountAllTT"), comp="" }
			},{
				{	text = string.format("%s (%s)", _("Count"), _("Visible") ),
					tooltip = _("PersonCountVisTT")
				},
				{	text = function(data) return
						tostring(data.count)
					end,
					tooltip = _("PersonCountVisTT")
				},
				{	text = function(data) return
						format.Percent(data.count/data.countall)
					end,
					tooltip = _("PersonCountVisTT")
				},
			},
			{
				string.format("%s (%s)", _("Count"), _("Moving") ),
				function(data) return
					tostring(data.EntMoving.count_)
				end,
				function(data) return
					format.Percent(data.EntMoving.count_/data.countall)
				end,
			},
			{
				string.format("%s (%s)", _("Count"), _("At terminal") ),
				function(data) return
					tostring(data.EntAtTerminal.count_)
				end,
				function(data) return
					format.Percent(data.EntAtTerminal.count_/data.countall)
				end,
			},
			{
				string.format("%s (%s (%s))", _("Count"), _("in Vehicles"), _("Lines") ),
				function(data) return
					tostring(data.vehiclesPass.count_)
				end,
				function(data) return
					format.Percent(data.vehiclesPass.count_/data.countall)
				end,
			},
		}},
		
		"<hline>",
		{	text = _("Move Mode"),
			style = "AVSHeading2"
		},
		{ table = {
			{
				{	layout = { type = "BoxH", content = {
					{ icon = "ui/icons/game-menu/user.tga" }, _("Walk") --ui/icons/construction-menu/filter_passengers.tga
				}}},
				function(data) return
					format.Int(data.MoveModes[1])
				end,
				function(data) return
					format.Percent(data.MoveModes[1]/data.count)
				end,
			},{
				{	layout = { type = "BoxH", content = {
					{ icon = "ui/icons/game-menu/town_window_privat-transport.tga" }, _("Car")
				}}},
				function(data) return
					format.Int(data.MoveModes[2])
				end,
				function(data) return
					format.Percent(data.MoveModes[2]/data.count)
				end,
			},{
				{	layout = { type = "BoxH", content = {
					{ icon = "ui/icons/game-menu/town_window_lines.tga" }, _("Line")
				}}},
				function(data) return
					format.Int(data.MoveModes[3])
				end,
				function(data) return
					format.Percent(data.MoveModes[3]/data.count)
				end,
			}
		}},
		
		"<hline>",
		{	text = _("Destinations"),
			style = "AVSHeading2"
		},
		{ table = {
			{
				_("COMMERCIAL").." ".._("and").." ".._("INDUSTRIAL"),--_("Both"),
				function(data) return
					format.Int(data.Destinations.ALL)
				end,
				function(data) return
					format.Percent(data.Destinations.ALL/data.count)
				end,
			},
			{
				_("Only").." ".._("COMMERCIAL"),
				function(data) return
					format.Int(data.Destinations.COM_ONLY)
				end,
				function(data) return
					format.Percent(data.Destinations.COM_ONLY/data.count)
				end,
			},
			{
				_("Only").." ".._("INDUSTRIAL"),
				function(data) return
					format.Int(data.Destinations.IND_ONLY)
				end,
				function(data) return
					format.Percent(data.Destinations.IND_ONLY/data.count)
				end,
			},
			{
				_("None"),
				function(data) return
					format.Int(data.Destinations.NONE)
				end,
				function(data) return
					format.Percent(data.Destinations.NONE/data.count)
				end,
			},
		}},
		
		"<hline>",
		{	text = _("Current Destination"),
			style = "AVSHeading2"
		},
		{ table = {
			{
				{	text = _("RESIDENTIAL"),
					style = "AVS-RESIDENTIAL",
				},
				function(data) return
					format.Int(data.curDestination[1] )
				end,
				function(data) return
					format.Percent(data.curDestination[1]/data.count)
				end,
			},{
				{	text = _("COMMERCIAL"),
					style = "AVS-COMMERCIAL",
				},
				function(data) return
					format.Int(data.curDestination[2] )
				end,
				function(data) return
					format.Percent(data.curDestination[2]/data.count)
				end,
			},{
				{	text = _("INDUSTRIAL"),
					style = "AVS-INDUSTRIAL",
				},
				function(data) return
					format.Int(data.curDestination[3] )
				end,
				function(data) return
					format.Percent(data.curDestination[3]/data.count)
				end,
			}
		}},
		
		"<hline>",
		{	text = _("Number of different Towns"),
			tooltip = _("DifTownsCountTT"),
			style = "AVSHeading2"
		},
		{ table = {
			{
				string.format("%d %s (%s)", 1, _("Town"), _("all same")),
				function(data) return
					format.Int(data.DifTownsCount[1] )
				end,
				function(data) return
					format.Percent(data.DifTownsCount[1]/data.count)
				end,
			},{
				string.format("%d %s (%s)", 2, _("Towns"), _("two equal")),
				function(data) return
					format.Int( data.DifTownsCount[2] )
				end,
				function(data) return
					format.Percent(data.DifTownsCount[2]/data.count)
				end,
			},{
				string.format("%d %s (%s)", 3, _("Towns"), _("all different")),
				function(data) return
					format.Int( data.DifTownsCount[3] )
				end,
				function(data) return
					format.Percent(data.DifTownsCount[3]/data.count)
				end,
			}
		},
		tooltip = _("DifTownsCountTT"),
		},
		
		"<hline>",
		{	text = _("Reachability"),
			style = "AVSHeading2",
			tooltip = _("ReachabilityTT"),
		},
		{ header = {
			false,
			false,
			_("Min"),
			_("Average"),
			_("Max"),
		},table = {
			{
				{ icon = "ui/icons/game-menu/user.tga" },
				_("Walk"),
				function(data) return
					format.Int(data.ReachableWalkDrive.min[1])
				end,
				function(data) return
					data.ReachableWalkDrive.av and format.Int(data.ReachableWalkDrive.av[1]) or "-"
				end,
				function(data) return
					format.Int(data.ReachableWalkDrive.max[1])
				end,
			},
			{
				{ icon = "ui/icons/game-menu/town_window_privat-transport.tga" },
				_("Car"),
				function(data) return
					format.Int(data.ReachableWalkDrive.min[2])
				end,
				function(data) return
					data.ReachableWalkDrive.av and format.Int(data.ReachableWalkDrive.av[2]) or "-"
				end,
				function(data) return
					format.Int(data.ReachableWalkDrive.max[2])
				end,
			},
			{
				{ icon = "ui/icons/game-menu/town_window_lines.tga" }, 
				_("Line"),
				function(data) return
					string.format("%.0f", data.ReachableLines.min[1])..s(string.format(" | %.0f", data.ReachableLines.min[2] ))
				end,
				function(data) return
					data.ReachableLines.av and string.format("%.0f", data.ReachableLines.av[1])..s(string.format(" | %.0f", data.ReachableLines.av[2] )) or "-"
				end,
				function(data) return
					string.format("%.0f", data.ReachableLines.max[1])..s(string.format(" | %.0f", data.ReachableLines.max[2] ))
				end,
			},
		},
		tooltip = _("ReachabilityTT"),
		},
		
		("<hline>"),
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
		
		a("<hline>"),
		a{ table = {
			{
				_("Last Destination Update").." (".._("Latest")..")",
				function(data) return
					format.Age(data.DestUpdate.max)
				end
			},
			{
				_("Last Destination Update")..format.str.av,
				function(data) return
					format.Age(data.DestUpdate.av)
				end
			},
			{
				_("Last Destination Update").." (".._("Oldest")..")",
				function(data) return
					format.Age(data.DestUpdate.min)
				end
			},
		}},
		
	} end
}