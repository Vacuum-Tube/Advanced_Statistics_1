local v = {}

function v.reset(rot)
	--game.gui.playSoundEffect("res/audio/effects/add_waypoint.wav")  --not working
	game.gui.playSoundEffect("addWaypoint")
	game.gui.setCamera( {0, 0, 8000, rot and math.rad(rot) or 0, 1} )
	--game.gui.setCamera(game.interface.getWorld())
end

function v.set(x, y, height, rot, pitch)
	if type(x)~="number" or type(y)~="number" then
		print("SYNTAX:","set(X, Y, *height, *rotation (grad), *pitch (0-1) )  (*optional)")
	end
	game.gui.setCamera( {x, y, height or 0, rot and math.rad(rot) or 0, pitch or 1 } )
end

function v.get(prin)
	local view = game.gui.getCamera()  -- position (looking at)
	if prin~=false then
		print("Current Camera Position:")
		commonapi.dmp(view)
	end
	return view
end

function v.getTerrain(prin)
	local pos = game.gui.getTerrainPos()  -- mouse
	if prin~=false then
		if pos then
			print("Current Terrain Position:")
			commonapi.dmp(pos)
		else
			print("terrain nil")
		end
	end
	return pos
end

function v.checkInvalidPos()
	local pos = game.gui.getTerrainPos()  -- game.gui.getCamera() not working in vehicle cam
	if pos~=nil and pos[1]~=pos[1] then  --  -nan(ind)
		local cam = game.gui.getCamera()
		v.reset()  -- but this is not working in vehicle
		print("Warning! Position == NaN")
		if commonapi then
			commonapi.dmp(pos)
			commonapi.dmp(cam)
		end
	end
end

return v