local list = require "advanced_statistics/script/listutil"
local res = {
	STREET = require "advanced_statistics/script/res/street",
	TRACK = require "advanced_statistics/script/res/track",
}
local EdgeTypes = {"TRACK","STREET"}

local nodedata = {}

function nodedata.getInfo(circle)
	local nodes = game.interface.getEntities(circle, { type = "BASE_NODE", includeData = truea })
	local d = {
		DoubleSlipSwitch = list.CountList:new(),
		TrafficLightPreference = list.CountList:new(0,true),
		TrafficLight = list.CountList:new(),
		TrafficLightState = list.CountList:new(0,true),
		NodeDegreeSTREET = list.CountList:new(4,true),
		NodeDegreeTRACK = list.CountList:new(4,true),
	}
	
	for _,id in pairs(nodes) do
		local basenode = api.engine.getComponent(id,api.type.ComponentType.BASE_NODE)
		d.DoubleSlipSwitch:count(nil,nil,basenode.doubleSlipSwitch)
		d.TrafficLightPreference:count(basenode.trafficLightPreference)
		
		local basenodeTl = api.engine.getComponent(id,api.type.ComponentType.BASE_NODE_TRAFFIC_LIGHT)
		if basenodeTl then
			d.TrafficLight:count()
			d.TrafficLightState:count(basenodeTl.state)
			-- basenodeTl.time
		end
	end
	
	-- local node2seg = api.engine.system.streetSystem.getNode2SegmentMap()  additionally includes crossings
	local node2street = api.engine.system.streetSystem.getNode2StreetEdgeMap()
	local node2track = api.engine.system.streetSystem.getNode2TrackEdgeMap()
	for node,segs in pairs(node2street) do
		local numsegs = #segs
		d.NodeDegreeSTREET:count(numsegs,nil,numsegs>0)
	end
	for node,segs in pairs(node2track) do
		local numsegs = #segs
		d.NodeDegreeTRACK:count(numsegs,nil,numsegs>0)
	end
	d.NodeCountSTREET = d.NodeDegreeSTREET:sumAll()
	d.NodeCountTRACK = d.NodeDegreeTRACK:sumAll()
	
	return d
end

return nodedata