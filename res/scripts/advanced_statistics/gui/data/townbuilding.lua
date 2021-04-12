local format = require "advanced_statistics/gui/format"
local __ = require "advanced_statistics/strings"
local a,v,s = require "advanced_statistics/adv".sks()

local landuseTypes = {"RESIDENTIAL","COMMERCIAL","INDUSTRIAL"}

return {
	name = _("Town Buildings"),
	-- icon = "ui/icons/construction-menu/filter_urban.tga",
	gamebartext = function(data) return
		tostring(data.count)
	end,
	gamebartooltip = function(data) return
		__("Capacities").."\n"..format.linesList(landuseTypes, "%s: %d", function(lu)
			return __(lu), data.Capacities[lu].sum
		end)
	end,
	windowlayout = function(updatedata) return {
		{ table = {
			{
				_("Count"),
				function(data) return
					data.count
				end
			},
			a{
				_("Count").." (".._("Destinations")..")",
				function(data) return
					-- data.countDestinations
					data.Employed.RESIDENTIAL.num+data.Employed.COMMERCIAL.num+data.Employed.INDUSTRIAL.num
				end
			},
		}},
		
		{	text = _("Capacities"),
			style = "AVSHeading2-table-header"
		},
		{ header = {
			false,
			_("Total"),
			_("Average"),
			_("Max"),
			_("Buildings"),
		}, 
			table = (function()
				local t = {}
				for i,landuse in pairs(landuseTypes) do
					table.insert(t, {
						{
							text = _(landuse),
							style = "AVS-"..landuse,
						}, {
							text = function(data) return
								format.Int(data.Capacities[landuse].sum )
							end,
							style = "AVS-"..landuse,
						}, {
							text = function(data) return
								format.Value(data.Capacities[landuse].av, 2 )
							end,
							style = "AVS-"..landuse,
						}, {
							text = function(data) return
								format.Int(data.Capacities[landuse].max )
							end,
							style = "AVS-"..landuse,
						}, {
							text = function(data) return
								format.Int(data.Capacities[landuse].num )
							end,
							style = "AVS-"..landuse,
						}
					})
				end
				return t
			end)()
		},
		
		{	text = _("Employed"),
			style = "AVSHeading2-table-header"
		},
		{ header = {
			false,
			_("Total"),
			"%",
			_("Vacant"),
			_("Average"),
			a(_("Buildings")),
		}, 
			table = (function()
				local t = {}
				for i,landuse in pairs({landuseTypes[2],landuseTypes[3]}) do
					table.insert(t, {
						{
							text = _(landuse),
							style = "AVS-"..landuse,
						}, {
							text = function(data) return
								format.Int(data.Employed[landuse].sum )
							end,
							style = "AVS-"..landuse,
						}, {
							text = function(data) return
								format.Percent(data.Employed[landuse].sum/data.Capacities[landuse].sum )
							end,
							style = "AVS-"..landuse,
						}, {
							text = function(data) return
								format.Int(data.Capacities[landuse].sum - data.Employed[landuse].sum )
							end,
							style = "AVS-"..landuse,
						}, {
							text = function(data) return
								format.Value((data.Capacities[landuse].sum - data.Employed[landuse].sum)/data.Capacities[landuse].num, 2 )
							end,
							style = "AVS-"..landuse,
						}, 
						a{
							text = function(data) return
								format.Int(data.Employed[landuse].num )  -- Number of Buildings Employed>0
							end,
							style = "AVS-"..landuse,
						}, 
					})
				end
				return t
			end)()
		},
		
		"<hline>",
		{	text = _("Buildings"),
			style = "AVSHeading2"
		},
		{table = {
			{
				_("Height")..format.str.av,
				function(data) return
					format.Length(data.Height.av)
				end,
			},{
				_("Height")..format.str.max,
				function(data) return
					format.Length(data.Height.max)
				end,
			},
			a{
				_("Depth")..format.str.av,
				function(data) return
					format.Value(data.Depth.av)
				end,
			},
			a{
				_("Depth")..format.str.max,
				function(data) return
					format.Int(data.Depth.max)
				end,
			},
			a{
				_("Parcels")..format.str.av,
				function(data) return
					format.Value(data.Parcels.av)
				end,
			},
			a{
				_("Parcels")..format.str.total,
				function(data) return
					format.Int(data.Parcels.sum)
				end,
			},
		}},
		
		{ table = {
			{
				_("Age").." (".._("Latest")..")",
				function(data) return
					format.Age(data.Builttimes.max)
				end
			},
			{
				_("Age")..format.str.av,
				function(data) return
					format.Age(data.Builttimes.av)
				end
			},
			{
				_("Age").." (".._("Oldest")..")",
				function(data) return
					format.Age(data.Builttimes.min)
				end
			},
		}},
		
	} end
}