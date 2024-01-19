local format = require "advanced_statistics/gui/format"
local guio = require "advanced_statistics/gui/objects"
local guibuilder = require "advanced_statistics/gui/guibuilder"
local a,v,s = require "advanced_statistics/adv".sks()

local nodesstr = {
	_("Dead Ends"),
	_("Connected"),
	"T-".._("Crossing"),
	_("Crossing"),
}
setmetatable(nodesstr, {__index=function() return nodesstr[4] end})
local nodesstr_track = table.copy(nodesstr)
nodesstr_track[3] = _("Switch")
setmetatable(nodesstr_track, {__index=function() return nodesstr_track[4] end})

return {
	icon = "ui/icons/game-menu/traffic_layer_traffic_light.tga",
	gamebartext = function(data) return
		data.TrafficLight.count_
	end,
	--gamebartooltip = function(data) return
	--end,
	windowlayout = function(updatedata) return {
		
		{table = {
			{
				_("Traffic Lights"),
				function(data) return
					data.TrafficLight.count_
				end
			},
			{
				_("Double Slip Switches"),
				function(data) return
					data.DoubleSlipSwitch.count_
				end
			},
		}},
		
		"<hline>",
		{table = {
			{
				_("Count").." ".._("Nodes").." ".._("STREET"),
				function(data) return
					data.NodeCountSTREET
				end
			},
			{
				_("Count").." ".._("Nodes").." ".._("TRACK"),
				function(data) return
					data.NodeCountTRACK
				end
			},
		}},
		
		{	text = _("Node Degree").." ".._("STREET"),
			style = "AVSHeading3",
			tooltip = _("NodeDegreeTT")
		},
		guio.NameValueList(
			function() return updatedata().NodeDegreeSTREET end,
			function(idx)
				return string.format("%d (%s)", idx, nodesstr[idx])
			end
		),
		
		{	text = _("Node Degree").." ".._("TRACK"),
			style = "AVSHeading3",
			tooltip = _("NodeDegreeTT")
		},
		guio.NameValueList(
			function() return updatedata().NodeDegreeTRACK end,
			function(idx)
				return string.format("%d (%s)", idx, nodesstr_track[idx])
			end
		),
		
		a("<hline>"),
		a{	text = _("Traffic Light Preference"),
			style = "AVSHeading3",
		},
		a(guio.NameValueList(
			function() return updatedata().TrafficLightPreference end, 
			function(idx)
				return string.format("%s %d", _("Preference"), idx)
			end,nil,true
		)),
		
		a("<hline>"),
		a{	text = _("Traffic Light State"),
			style = "AVSHeading3",
		},
		a(guio.NameValueList(
			function() return updatedata().TrafficLightState end, 
			function(idx)
				return string.format("%s %d", _("State"), idx)
			end,nil,true
		)),
	
	} end
}