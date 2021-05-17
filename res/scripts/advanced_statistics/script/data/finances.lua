local game = require "advanced_statistics/script/data/game"

local f = {}

function f.getInfo()
	return {
		account = game.getAccount(),
		journal = game.getJournalTotal(1,false),
	}
end

return f