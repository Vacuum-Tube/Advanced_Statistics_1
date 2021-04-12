local format = require "advanced_statistics/gui/format"
local __ = require "advanced_statistics/strings"
local guio = require "advanced_statistics/gui/objects"
local res = require "advanced_statistics/script/res/construction"
local a,v,s,o = require "advanced_statistics/adv".sks()

local landuseTypes = {"RESIDENTIAL","COMMERCIAL","INDUSTRIAL"}

return {
	name = _("Constructions"),
	icon = "ui/icons/construction-menu/filter_misc.tga",  --filter_all
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
			},{
				_("Count").." ".._("Person Capacity"),
				function(data) return
					tostring(data.Capacities.RESIDENTIAL.num+data.Capacities.COMMERCIAL.num+data.Capacities.INDUSTRIAL.num)
				end
			},{
				_("Count").." ".._("Town Buildings"),
				function(data) return
					tostring(data.Types.townBuildings)
				end
			},{
				_("Count").." ".._("Industries"),
				function(data) return
					tostring(data.Types.simBuildings)
				end
			},{
				_("Count").." ".._("Stations"),
				function(data) return
					tostring(data.Types.stations)
				end
			},{
				_("Count").." ".._("Depots"),
				function(data) return
					tostring(data.Types.depots)
				end
			},
			{
				_("Count").." ".._("Other"),
				function(data) return
					tostring(data.Types.other)
				end
			},
		}},
		
		"<hline>",
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
		
		"<hline>",
		{table = {
			{
				_("Age").." (".._("Latest")..")",
				function(data) return
					format.Age(data.Builttimes.max)
				end
			},
			a{
				_("Age")..format.str.av,
				function(data) return
					format.Age(data.Builttimes.av)
				end
			},{
				_("Age").." (".._("Oldest")..")",
				function(data) return
					format.Age(data.Builttimes.min)
				end
			},
			a{
				_("Particle Emitters"),--..format.str.total,
				function(data) return
					format.Int(data.ParticleCount.sum)
				end
			},
		}},
		
		a("<hline>"),
		a{	text = _("Build Cost"),
			style = "AVSHeading2"
		},
		a{table = {
			{
				_("Count"),
				function(data) return
					data.BuildCost.num
				end
			},
			{
				_("Average"),
				function(data) return
					format.Money(data.BuildCost.av)
				end
			},
			{
				_("Max"),
				function(data) return
					format.Money(data.BuildCost.max)
				end
			},
			{
				_("Sum"),
				function(data) return
					format.Money(data.BuildCost.sum)
				end
			},
		}},
		
		a("<hline>"),
		a{	text = _("Maintenance Cost"),
			style = "AVSHeading2"
		},
		a{table = {
			{
				_("Count"),
				function(data) return
					data.MaintenanceCost.num
				end
			},
			{
				_("Average"),
				function(data) return
					format.Money(data.MaintenanceCost.av)
				end
			},
			{
				_("Max"),
				function(data) return
					format.Money(data.MaintenanceCost.max)
				end
			},
			{
				_("Sum"),
				function(data) return
					format.Money(data.MaintenanceCost.sum)
				end
			},
		}},
		
		"<hline>",
		{	text = _("List"),
			style = "AVSHeading2"
		},
		guio.ResList( 	function() return updatedata().Filename end, res.names),
		
	} end
}