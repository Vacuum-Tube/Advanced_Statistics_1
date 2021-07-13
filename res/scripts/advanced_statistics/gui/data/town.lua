local format = require "advanced_statistics/gui/format"
local guio = require "advanced_statistics/gui/objects"
local a,v,s,o = require "advanced_statistics/adv".sks()

return {
	name = _("Towns"),
	icon = "ui/icons/warnings/towns_icon.tga",
	gamebartext = function(data) return
		-- tostring(data.Capacities.Res)
		format.Value(data.Size.sum,0)
	end,
	-- gamebartooltip = function(data) return
		-- string.format("Residential:  %d\nCommercial:  %d\nIndustrial:  %d", data.Capacities.Res, data.Capacities.Com, data.Capacities.Ind )
	-- end,
	windowlayout = function(updatedata) return {
		{ table = {
			{
				_("Count"),
				function(data) return
					string.format("%d", data.count )
				end
			}, 
			a{
				_("Development").." ".._("Active"),
				function(data) return
					string.format("%d", data.developmentActive.count_ )
				end
			},
		}},
		-- {	text = _("Size"),
			-- tooltip = _("TownSizeTT"),
			-- style = "AVSHeading2"
		-- },
		{ table = {
			{
				_("Size")..format.str.min,
				function(data) return
					format.Value( data.Size.min , 0)
				end
			}, 
			{
				_("Size")..format.str.av,
				function(data) return
					format.Value( data.Size.av , 0)
				end
			}, 
			{
				_("Size")..format.str.max,
				function(data) return
					format.Value( data.Size.max , 0)
				end
			}, 
			{
				_("Size")..format.str.total,
				function(data) return
					format.Value( data.Size.sum , 0)
				end
			}, 
		},
		tooltip = _("TownSizeTT"),
		},
		
		-- {	text = _("Capacities"),
			-- style = "AVSHeading2"
		-- },
		-- { table = {
			-- {
				-- {
					-- text = _("RESIDENTIAL"),
					-- style = "AVS-RESIDENTIAL"
				-- }, {
					-- text = function(data) return
						-- string.format("%d", data.Capacities.Res )
					-- end,
					-- style = "AVS-RESIDENTIAL" 
				-- }
			-- }, {
				-- {
					-- text = _("COMMERCIAL"),
					-- style = "AVS-COMMERCIAL",
				-- }, {
					-- text = function(data) return
						-- string.format("%d", data.Capacities.Com )
					-- end,
					-- style = "AVS-COMMERCIAL",
				-- }
			-- }, {
				-- {
					-- text = _("INDUSTRIAL"),
					-- style = "AVS-INDUSTRIAL",
				-- }, {
					-- text = function(data) return
						-- string.format("%d", data.Capacities.Ind )
					-- end,
					-- style = "AVS-INDUSTRIAL",
				-- }
			-- }
		-- } },
		
		"<hline>",
		-- {	text = _("Growth"),
			-- style = "AVSHeading2"
		-- },
		{ table = {
			{
				{	text = _("Growth Factor")..format.str.av, tooltip = _("GrowthFactorTT") },
				{	text = function(data) return
					data.Growth.av and format.Percent( (data.Growth.av[1] + data.Growth.av[2] + data.Growth.av[3] ) /3 , 2) or "-"
				end, 
				tooltip = _("GrowthFactorTT") },
			},
			a{
				_("Growth Tendency")..format.str.min,
				function(data) return
					format.Value( data.growthTendency.min , 2)
				end
			},
			a{
				_("Growth Tendency")..format.str.max,
				function(data) return
					format.Value( data.growthTendency.max , 2)
				end
			},
			a{
				_("Size Factor")..format.str.av,
				function(data) return
					format.Value( data.sizeFactor.av , 2)
				end
			},
		}},
		
		"<hline>",
		{	text = _("Reachability"),
			style = "AVSHeading2",
			tooltip = _("ReachabilityTT"),
		},
		{ table = {
			{
				{	layout = { type = "BoxH", content = {
					{ icon = "ui/icons/game-menu/town_window_privat-transport.tga" },  _("Car")..format.str.min
				}}},
				function(data) return
					format.Int(data.Reachability.min[1])
				end,
				function(data) return
					format.Percent(data.Reachability.min[1]/data.Capacities.totDest, 2)
				end,
			},
			{
				{	layout = { type = "BoxH", content = {
					{ icon = "ui/icons/game-menu/town_window_privat-transport.tga" },  _("Car")..format.str.av
				}}},
				function(data) return
					format.Int(data.Reachability.av and data.Reachability.av[1])
				end,
				function(data) return
					format.Percent(data.Reachability.av and (data.Reachability.av[1]/data.Capacities.totDest), 2)
				end,
			},
			{
				{	layout = { type = "BoxH", content = {
					{ icon = "ui/icons/game-menu/town_window_privat-transport.tga" },  _("Car")..format.str.max
				}}},
				function(data) return
					format.Int(data.Reachability.max[1])
				end,
				function(data) return
					format.Percent(data.Reachability.max[1]/data.Capacities.totDest, 2)
				end,
			},
			{
				{	layout = { type = "BoxH", content = {
					{	icon = "ui/icons/game-menu/town_window_lines.tga"}, _("Line")..format.str.min
				}}},
				function(data) return
					format.Int(data.Reachability.min[2])
				end,
				function(data) return
					format.Percent(data.Reachability.min[2]/data.Capacities.totDest, 2)
				end,
			}, 
			{
				{	layout = { type = "BoxH", content = {
					{	icon = "ui/icons/game-menu/town_window_lines.tga"}, _("Line")..format.str.av
				}}},
				function(data) return
					format.Int(data.Reachability.av and data.Reachability.av[2])
				end,
				function(data) return
					format.Percent(data.Reachability.av and (data.Reachability.av[2]/data.Capacities.totDest), 2)
				end,
			}, 
			{
				{	layout = { type = "BoxH", content = {
					{	icon = "ui/icons/game-menu/town_window_lines.tga"}, _("Line")..format.str.max
				}}},
				function(data) return
					format.Int(data.Reachability.max[2])
				end,
				function(data) return
					format.Percent(data.Reachability.max[2]/data.Capacities.totDest, 2)
				end,
			}, 
		},
		tooltip = _("ReachabilityTT")
		},
		
		"<hline>",
		{	text = _("Cargo Supply"),
			style = "AVSHeading2"
		},
		{ table = {
			{
				{	text = _("Towns").." ".._("supplied").." (".._("partially")..")",
					tooltip = "> 0 %"
				},
				function(data) return
					string.format("%d/%d", data.townSuppliedPart.count_, data.townswCargo.count_)
				end
			},
			{
				{	text = _("Towns").." ".._("supplied").." (".._("completely")..")",
					tooltip = "> 75 % (because game values fluctuate)"
				},
				function(data) return
					string.format("%d/%d", data.townSuppliedFull.count_, data.townswCargo.count_)
				end
			},
		}},
		{ table = {
			{
				_("Total"),
				function(data) return
					string.format("%d/%d", data.SupplyAndLimit.sum[1], data.SupplyAndLimit.sum[2] )
				end,
				function(data) return
					format.Percent(data.SupplyAndLimit.rel)
				end,
			}, {
				_("Average"),
				function(data) return
					data.SupplyAndLimit.av and string.format("%.0f/%.0f", data.SupplyAndLimit.av[1], data.SupplyAndLimit.av[2] ) or "-"
				end,
				false,
			}
		}},
		guio.CargoTypesTable(function()
			return updatedata().CargoTypesLimit
		end,
		function(key,value)
			local d = updatedata()
			return string.format("%d/%d", d.CargoTypesSupply[key], value)
		end,
		function(key,value)
			local d = updatedata()
			return format.Percent(d.CargoTypesSupply[key]/value)
		end),
		
		"<hline>",
		{ table = {
			{
				{	layout = { type = "BoxH", content = {
					{
						icon = "ui/icons/game-menu/town_window_traffic.tga",
					},{
						text = _("Traffic Rating")..format.str.av,
					}
				}}},
				{ text = function(data) return
					format.Percent(data.TrafficRatings.av, 2)
				end}
			}, 
			a{
				{	layout = { type = "BoxH", content = {
					{
						icon = "ui/icons/game-menu/town_window_emission.tga",
					},{
						text = _("Emission")..format.str.av
					}
				}}},
				{ text = function(data) return
					data.Emissions.av and string.format("%.0f", data.Emissions.av*1e9 ).."  x10^-9" or "-"
				end}
			}, 
			a{
				{	layout = { type = "BoxH", content = {
					{
						icon = "ui/icons/game-menu/town_window_emission.tga",
					},{
						text = _("Emission")..format.str.max,
					}
				}}},
				{ text = function(data) return
					string.format("%.0f", data.Emissions.max*1e9 ).."  x10^-9"
				end}
			}
		} },
	} end
}