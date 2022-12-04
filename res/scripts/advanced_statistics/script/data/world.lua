local game = require "advanced_statistics/script/data/game"

local w = {}

function w.getInfo()
	return {
		worldSize = game.getWorldSize(),
		terrainInfo = game.getTerrainInfo(),
		waterInfo = game.getWaterTilesInfo(),
	}
end

return w