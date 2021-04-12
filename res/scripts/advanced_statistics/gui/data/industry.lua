local format = require "advanced_statistics/gui/format"
local guio = require "advanced_statistics/gui/objects"
local res = require "advanced_statistics/script/res/construction"
local a,v,s,o = require "advanced_statistics/adv".sks()

return {
	name = _("Industries"),
	icon = "ui/icons/warnings/industries_icon.tga",
	gamebartext = function(data) return
		tostring(data.Shipping.sum)
	end,
	gamebartooltip = function(data) return
		string.format("Production:  %d/%d\nShipping:  %d\nTransport:  %d", data.Production.sum, data.ProductionLimit.sum, data.Shipping.sum, data.TransportAbs.sum )
	end,
	windowlayout = function(updatedata) return {
		{ table = {
			{
				_("Count"),
				{ text = function(data) return
					format.Int(data.count)
				end},
			}, 
			{
				_("Auto Upgrade"),
				{ text = function(data) return
					format.Int(data.AutoUpgrade.count_ )
				end},
			}, 
			a{
				_("Upgrading"),
				{ text = function(data) return
					format.Int(data.Upgrade.count_ )
				end},
			}, 
			a{
				_("Downgrading"),
				{ text = function(data) return
					format.Int(data.Downgrade.count_ )
				end},
			}
		} },
		
		{ table = {
			{
				function(data) return
					format.linesDict(data.Levels, "Level %d", function(level,count)
						return level
					end)
				end,
				function(data) return
					format.linesDict(data.Levels, function(level,count)
						return count
					end)
				end,
			}, 
		}},
		
		"<hline>",
		{ table = {
			{
				_("Production"),
				function(data) return
					string.format("%d/%d", data.Production.sum, data.ProductionLimit.sum )
				end,
				function(data) return
					format.Percent(data.Production.rel)
				end,
			}, {
				_("Shipping"),
				function(data) return
					string.format("%d/%d", data.Shipping.sum, data.Production.sum )
				end,
				function(data) return
					format.Percent(data.Shipping.rel)
				end,
			}, {
				_("Transport"),
				function(data) return
					string.format("%.0f/%d", data.TransportAbs.sum, data.Shipping.sum)
				end,
				function(data) return
					format.Percent(data.TransportAbs.rel)
				end,
			},
		} },
		
		a{ table = {
			{
				_("Production")..format.str.min,
				{ text = function(data) return
					format.Value(data.Production.min, 0)
				end},
			}, {
				_("Production")..format.str.max,
				{ text = function(data) return
					format.Value(data.Production.max, 0)
				end},
			}, {
				_("Production")..format.str.av,
				{ text = function(data) return
					format.Value(data.Production.av, 0)
				end},
			}, {
				_("Shipping")..format.str.av,
				{ text = function(data) return
					format.Value(data.Shipping.av, 0)
				end},
			},  {
				_("Transport")..format.str.av,
				{ text = function(data) return
					format.Value(data.TransportAbs.av, 0)
				end},
			}, 
		} },
		
		"<hline>",
		{ table = {
			{
				_("Produced")..format.str.total,
				function(data) return
					format.Number(data.TotalProduced.sum)
				end
			}, 
			{
				_("Shipped")..format.str.total,
				function(data) return
					format.Number(data.TotalShipped.sum)
				end
			}, 
			{
				_("Consumed")..format.str.total,
				function(data) return
					format.Number(data.TotalConsumed.sum)
				end
			}
		} },
		
		"<hline>",
		{	text = _("List"),
			style = "AVSHeading2"
		},
		guio.ResList( 	function() return updatedata().Filename end, res.names),
		
	} end
}