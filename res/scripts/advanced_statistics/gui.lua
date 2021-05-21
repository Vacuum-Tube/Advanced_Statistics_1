local log = require "advanced_statistics/log"
local timer = require "advanced_statistics/script/timer"
local basic = require "advanced_statistics/gui/basic"
local guidata = require "advanced_statistics/gui/guidata"
local resdata = require "advanced_statistics/script/resdata"
local ScriptEvent = require "advanced_statistics/script/event".ScriptEvent
local adv = require "advanced_statistics/adv"

local state = {  -- constant pointer
	state = {hereitisorwillbe}
}
setmetatable(state, {
	__index = function (table, key)
		return state.state[key]
	end,
})

local gu = {
	view = require "advanced_statistics/gui/view",
	window = require "advanced_statistics/gui/window/main",
	gamebar = require "advanced_statistics/gui/gamebar/main",
	state = state,
	initbool = false,
	active = true,
	error = false,
	data = guidata,
}

function gu.load(loadState)
	if not loadState.data.game then
		loadState.data = state.data  -- rescue data
	end
	state.state = loadState  -- dealing with pointers... (loadState is a new pointer every update)
end


function gu.init()  -- guiInit
	log(1,"GuiInit")
	log.logTab(3,state)  -- not init here
	if state.settings and state.settings.start_sound then
		game.gui.playSoundEffect("industryUpgrade")
	end
	game.avs.guiinit = timer.timestamp()
	log.logTab(2,game.avs.guiinit)
	ScriptEvent("guiInit", game.avs.guiinit)
	resdata.init()
end

function gu.creategui()  -- not working in guiInit
	adv.setadv(state.settings.advadv)
	xpcall(gu.gamebar.init, gu.errorHandler, state, gu.window)  -- "Gui main gamebar.init"
	xpcall(gu.window.init, gu.errorHandler, state, gu.gamebar)  --"Gui main window.init"
	if state.settings.start_sound then
		game.gui.playSoundEffect("addWaypoint")
	end
end

function gu.update()  -- guiUpdate
	if gu.active then
		if gu.initbool == false then
			if state.init then
				if state.time.guiinit then
					log(2,"State init, create Gui")
					log.logTab(3,state)
					-- if not state.error then
						gu.creategui()
					-- end
					gu.initbool = true
				else
					log(2,"Waiting for guiinit")
				end
			else
				log(2,"Waiting for state.init")
			end
		end
		if state.init == true then
			if state.error then
				if gu.error==false then
					basic.showErrorMsg(state.error.msg, state.error.loc, state.error.traceback)
					gu.error=true
				end
			else
				gu.error=false
			end
		end
		-- gu.view.checkInvalidPos()
	end
end

function gu.errorHandler(msg)
	log.logError(msg, "Gui Main")
	basic.showErrorMsg(msg, "Gui Main", debug.traceback())
end

return gu