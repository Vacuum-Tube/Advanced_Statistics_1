local zoneutil = require "mission.zone"

local z = {}

function z.setMarker(id,pos)
	game.interface.setMarker(id, {
		pos={2132,2222,10},
		type = n,
		entity = n,
	})
end

function z.setZone(id,polygon)
	game.interface.setZone(id, {
		polygon=polygon,
		draw=true,
		drawColor = {1,1,1,1},
	})
end

function z.setZoneCircle(id,pos,radius)
	assert(pos or debugPrint("Assert Pos"))
	assert(radius<math.huge or debugPrint("Assert Radius: "..radius))
	local num = 32
	if radius<20 then
		num = 8
	elseif radius<40 then
		num = 12
	elseif radius<80 then
		num = 18
	elseif radius<200 then
		num = 24
	end
	z.setZone(id, zoneutil.makeCircleZone(pos, radius, num))
end

function z.remZone(id)
	game.interface.setZone(id)
end

return z