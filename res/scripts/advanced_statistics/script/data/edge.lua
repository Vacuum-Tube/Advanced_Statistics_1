local list = require "advanced_statistics/script/listutil"
local vec3 = require "vec3"
local res = {
	STREET = require "advanced_statistics/script/res/street",
	TRACK = require "advanced_statistics/script/res/track",
}
local resbridge = require "advanced_statistics/script/res/bridge"
local restunnel = require "advanced_statistics/script/res/tunnel"
local EdgeTypes = {"TRACK","STREET"}

local edgedata = {}

function edgedata.getInfo(circle)
	local edges = game.interface.getEntities(circle, { type = "BASE_EDGE", includeData = truea })
	local d = {}
	local t = {}
	for _,edgeType in pairs(EdgeTypes) do
		d[edgeType] = {
			-- Types = {},
			Length = list.ValueList:new(),
			LengthTypes = {},
			Bridge = list.ValueList:new(),
			Tunnel = list.ValueList:new(),
			BridgeTypes = list.CountList:new(0,true),
			TunnelTypes = list.CountList:new(0,true),
			Gradient = list.ValueList:new(),
			Radius = list.ValueList:new(),
			speedLimit = list.ValueList:new(),
			curveSpeedLimit = list.ValueList:new(),
		}
		t[edgeType] = {
			-- Types = list.CountList:new(0,true),
			LengthTypes = list.CountList:new(0,true),
		}
	end
	local TRACK = d.TRACK
	TRACK.Catenary = list.ValueList:new()
	local STREET = d.STREET
	STREET.BusLane = list.ValueList:new()
	STREET.Tram = list.ValueList:new()
	STREET.TramElectric = list.ValueList:new()
	STREET.PlayerOwned = list.ValueList:new()
	
	for _,id in pairs(edges) do
		
		local baseedge = api.engine.getComponent(id,api.type.ComponentType.BASE_EDGE)
		local pos0 = edgedata.getNodePos(baseedge.node0)
		local pos1 = edgedata.getNodePos(baseedge.node1)
		local tang0 = math.abs(edgedata.getVecZTangent(baseedge.tangent0))
		local tang1 = math.abs(edgedata.getVecZTangent(baseedge.tangent1))
		
		local tn = api.engine.getComponent(id,api.type.ComponentType.TRANSPORT_NETWORK)
		local EdgeLanesData = edgedata.getEdgeLanesData(tn.edges)
		
		-- None of these is exact, the direct distance is most close to the real value
		-- local length = EdgeLanesData.length
		local length = edgedata.getLength(pos0, pos1)
		-- length of baseedge.tangent0?
		
		local track = api.engine.getComponent(id,api.type.ComponentType.BASE_EDGE_TRACK)
		local street = api.engine.getComponent(id,api.type.ComponentType.BASE_EDGE_STREET)
		local EdgeType
		local edgeType
		
		if track then
			EdgeType = TRACK
			edgeType = "TRACK"
			-- t.TRACK.Types:count(track.trackType)
			t.TRACK.LengthTypes:count(track.trackType, length)
			TRACK.Catenary:newVal(length, track.catenary==true)
		end
		if street then
			EdgeType = STREET
			edgeType = "STREET"
			-- t.STREET.Types:count(street.streetType)
			t.STREET.LengthTypes:count(street.streetType, length)
			STREET.BusLane:newVal(length, street.hasBus==true)
			STREET.Tram:newVal(length, street.tramTrackType==1)
			STREET.TramElectric:newVal(length, street.tramTrackType==2)
			STREET.PlayerOwned:newVal(length, api.engine.getComponent(id,api.type.ComponentType.PLAYER_OWNED)~=nil)
		end
		
		EdgeType.Length:newVal(length)
		EdgeType.speedLimit:newVal(EdgeLanesData.speedLimit)
		EdgeType.curveSpeedLimit:newVal(EdgeLanesData.curveSpeedLimit)
		
		EdgeType.Gradient:newVal(tang0)
		EdgeType.Gradient:newVal(tang1)
		if baseedge.tangent0~=baseedge.tangent1 then
			local radius = edgedata.calcRadius(pos0, pos1, baseedge.tangent0, baseedge.tangent1)
			EdgeType.Radius:newVal(radius, radius<100000)
		end
		
		if baseedge.type==1 then -- bridge==1, tunnel==2
			EdgeType.Bridge:newVal(length)
			EdgeType.BridgeTypes:count(resbridge.all[baseedge.typeIndex],length)  -- bridgeType
		elseif  baseedge.type==2 then
			EdgeType.Tunnel:newVal(length)
			EdgeType.TunnelTypes:count(restunnel.all[baseedge.typeIndex],length)
		end
		
		-- baseedge.objects
	end
	
	for _,edgeType in pairs(EdgeTypes) do
		d[edgeType].Gradient:finish()
		d[edgeType].Length:finish()
		d[edgeType].Radius:finish()
		d[edgeType].speedLimit:finish()
		d[edgeType].curveSpeedLimit:finish()
		for trackId,length in pairs(t[edgeType].LengthTypes) do
			local filename = res[edgeType].all[trackId]
			-- d[edgeType].Types[filename] = count
			d[edgeType].LengthTypes[filename] = length --t[edgeType].LengthTypes[trackId]
		end
	end
	
	-- local obj2edge = api.engine.system.streetSystem.getEdgeObject2EdgeMap()
	-- d.countedgeobjects = #obj2edge
	
	return d
end


function edgedata.getEdgeLanesData(tnedges)
	local speedLimitLanes = list.ValueList:new()
	local curveSpeedLimitLanes = list.ValueList:new()
	for i,edge in pairs(tnedges) do  -- streets: >1 "edge"/lane in 1 segment
		speedLimitLanes:newVal(edge.speedLimit)
		curveSpeedLimitLanes:newVal(edge.curveSpeedLimit)
	end
	return {
		speedLimit = speedLimitLanes.max,  -- max because sidewalks have 0
		curveSpeedLimit = curveSpeedLimitLanes.max,
		length = tnedges[1].geometry.length,  -- not the whole length at switches, only to intermediate node
	}
end

edgedata.getVecZTangent = function(v)
	return v.z / math.sqrt(v.x^2 + v.y^2 + v.z^2)
end

edgedata.calcRadius = function(p0,p1,t0,t1)
	local r = math.abs( ( t1.x*(p0.x-p1.x) + t1.y*(p0.y-p1.y) ) / (t0.y*t1.x-t0.x*t1.y) ) * math.sqrt(t0.x^2 + t0.y^2) --
	-- local a = math.acos( (t0.x*t1.x+t0.y*t1.y) / math.sqrt( (t0.x^2 + t0.y^2) * (t1.x^2 + t1.y^2) ) )
	-- if r<0 then a = -a end  -- negative angles can compensate positives
	return r
end

function edgedata.getNodePos(id)
	local comp = api.engine.getComponent(id, api.type.ComponentType.BASE_NODE)
	return comp.position  -- Vec3f
end

function edgedata.getLength(v1,v2)  -- approx (direct)
	local a = vec3.new(v1[1], v1[2], v1[3] )
	local b = vec3.new(v2[1], v2[2], v2[3] )
	return vec3.distance(a, b)
end

return edgedata