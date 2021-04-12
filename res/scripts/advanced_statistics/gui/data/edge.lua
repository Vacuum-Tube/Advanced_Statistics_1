local format = require "advanced_statistics/gui/format"
local guio = require "advanced_statistics/gui/objects"
local guibuilder = require "advanced_statistics/gui/guibuilder"
local __ = require "advanced_statistics/strings"
local log = (require "advanced_statistics/log").logPrefix("window.edge-tab")
local a,v,s,o = require "advanced_statistics/adv".sks()
local res = {
	STREET = require "advanced_statistics/script/res/street",
	TRACK = require "advanced_statistics/script/res/track",
}
local resbridge = require "advanced_statistics/script/res/bridge"
local restunnel = require "advanced_statistics/script/res/tunnel"

local EdgeTypes = {"TRACK","STREET"}

return {
	-- icon = "ui/icons/construction-menu/filter_highway.tga",
	icon = "ui/advanced_statistics/street32.tga",
	gamebartext = function(data) return
		format.LengthKm(data.TRACK.Length.sum)
	end,
	gamebartooltip = function(data) return
		format.linesList(EdgeTypes, "%s: %s", function(edgeType)
			return __(edgeType), format.Length(data[edgeType].Length.sum)
		end)
	end,
	-- vfill = false,
	windowlayout = function(updatedata) return
		guio.Tabwidget("NORTH", EdgeTypes, function(edgeType)
			log(2,"Create edge tab",edgeType)
			return {
			
		
	-- {	text = _("Length").." ".._("Total"),
		-- style = "AVSHeading2"
	-- },
	{ tablecols = o(4,3),
		header = {
		-- "",
		{	text = _("Length").." ".._("Total"),
			style = "AVSHeading2"
		},
		a(_("Segments")),
		_("Length"),
		"%",
	}, table = {
		{
			{ text = _("Total"),
				tooltip = _("edgeLengthTT")
			},
			a(function(data) return
				data.Length.num
			end),
			{ text = function(data) return
				format.Length(data.Length.sum)
			end,
			tooltip = _("edgeLengthTT") },
			""
		},
		edgeType=="TRACK" and {
			{ text = _("Catenary"),
				tooltip = _("edgeLengthTT")
			},
			a(function(data) return
				data.Catenary.num
			end),
			{ text = function(data) return
				format.Length(data.Catenary.sum)
			end,
			tooltip = _("edgeLengthTT") },
			function(data) return
				format.Percent(data.Catenary.sum/data.Length.sum,1)
			end,
		},
		edgeType=="STREET" and {
			_("Bus Lane"),
			a(function(data) return
				data.BusLane.num
			end),
			function(data) return
				format.Length(data.BusLane.sum)
			end,
			function(data) return
				format.Percent(data.BusLane.sum/data.Length.sum,1)
			end,
		},
		edgeType=="STREET" and {
			_("Tram"),
			a(function(data) return
				data.Tram.num
			end),
			function(data) return
				format.Length(data.Tram.sum)
			end,
			function(data) return
				format.Percent(data.Tram.sum/data.Length.sum,1)
			end,
		},
		edgeType=="STREET" and {
			_("Tram Electric"),
			a(function(data) return
				data.TramElectric.num
			end),
			function(data) return
				format.Length(data.TramElectric.sum)
			end,
			function(data) return
				format.Percent(data.TramElectric.sum/data.Length.sum,1)
			end,
		},
		{
			_("Bridge"),
			a(function(data) return
				data.Bridge.num
			end),
			function(data) return
				format.Length(data.Bridge.sum)
			end,
			function(data) return
				format.Percent(data.Bridge.sum/data.Length.sum,1)
			end,
		},
		{
			_("Tunnel"),
			a(function(data) return
				data.Tunnel.num
			end),
			function(data) return
				format.Length(data.Tunnel.sum)
			end,
			function(data) return
				format.Percent(data.Tunnel.sum/data.Length.sum,1)
			end,
		},
		edgeType=="STREET" and {
			-- {	layout = { type = "BoxH", content = {
				{ text = _("Player Owned") },
				-- { icon = "ui/icons/game-menu/traffic_layer_player_owned.tga", }, 
			-- }}},
			a(function(data) return
				data.PlayerOwned.num
			end),
			function(data) return
				format.Length(data.PlayerOwned.sum)
			end,
			function(data) return
				format.Percent(data.PlayerOwned.sum/data.Length.sum,1)
			end,
		},
	}},
	
	"<hline>",
	{table = {
		{
			_("Speed Limit")..format.str.min,
			function(data) return
				format.Speed(data.speedLimit.min)
			end
		},
		a{
			_("Speed Limit")..format.str.av,
			function(data) return
				format.Speed(data.speedLimit.av)
			end
		},
		{
			_("Speed Limit")..format.str.max,
			function(data) return
				format.Speed(data.speedLimit.max)
			end
		},
		{
			_("Curve Speed Limit")..format.str.min,
			function(data) return
				format.Speed(data.curveSpeedLimit.min)
			end
		},
		a{
			_("Curve Speed Limit")..format.str.av,
			function(data) return
				format.Speed(data.curveSpeedLimit.av)
			end
		},
	}},
	{table = {
		{
			_("Curve Radius")..format.str.min,
			function(data) return
				format.Length(data.Radius.min)
			end
		},
		{
			_("Curve Radius")..format.str.av,
			function(data) return
				format.Length(data.Radius.av)
			end
		},
	}},
	{table = {
		{
			_("Segment").." ".._("Length")..format.str.min,
			function(data) return
				format.Length(data.Length.min)
			end
		},
		a{
			_("Segment").." ".._("Length")..format.str.max,
			function(data) return
				format.Length(data.Length.max)
			end
		},
	}},
	{table = {
		{
			_("Slope")..format.str.av,
			function(data) return
				format.Promille(data.Gradient.av)
			end
		},{
			_("Slope")..format.str.max,
			function(data) return
				format.Promille(data.Gradient.max)
			end
		},
	}},
	
	"<hline>",
	{	text = _(edgeType).." ".._("Types"),
		style = "AVSHeading2"
	},
	guio.ResList(
		function() return updatedata()[edgeType].LengthTypes end, 
		res[edgeType].names,
		function(length)
			return format.Length(length)
		end
	),
	
	"<hline>",
	{	text = _("Bridge").." ".._("Types"),
		style = "AVSHeading2"
	},
	guio.ResList(
		function() return updatedata()[edgeType].BridgeTypes end, 
		resbridge.names,
		function(length)
			return format.Length(length)
		end
	),
	
	"<hline>",
	{	text = _("Tunnel").." ".._("Types"),
		style = "AVSHeading2"
	},
	guio.ResList(
		function() return updatedata()[edgeType].TunnelTypes end, 
		restunnel.names,
		function(length)
			return format.Length(length)
		end
	),
			
			}
		end,
		function(edgeType)
			return "ui/advanced_statistics/"..string.lower(edgeType)..".tga"
		end,
		updatedata)
	 end
}