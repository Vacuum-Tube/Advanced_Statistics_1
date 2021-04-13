local thread = require "advanced_statistics/thread"
local log = require "advanced_statistics/log"
local timer = require "advanced_statistics/script/timer"
local datalist = require "advanced_statistics/datalist"
-- assert(#datalist==19, "#datalist: "..#datalist)
local resdata = require "advanced_statistics/script/resdata"
local event = require "advanced_statistics/script/event"

local state = {
	init = false,
	active = true,
	program = {},
	time = {},
	data = {},
	calctime = {},
	timestamp = {},
	-- currentzones = {},
	error = false,
	settings = require "advanced_statistics/settings",  -- default
}

local script = {
	state = state,
	-- active = true,
	datalist = datalist,
	data = {},
	res = resdata,
}

for _,datastr in pairs(datalist) do
	script.data[datastr] = require("advanced_statistics/script/data/"..datastr)
end

if game.avs then
	game.avs.scriptinit = timer.timestamp()
else
	print("No game.avs!")
	print("Thread:",thread.getCurrentThread())
end


function script.load(loadState)
	if thread.isScriptThread() then  -- how else to ensure this is not gui thread?  -- leading to crash: ..\..\src\Game\Game.cpp:349: void __cdecl CGame::StartGameSim(void): Assertion `m_data->gameStates[1]->ScriptSave() == m_data->gameStates[0]->ScriptSave()' failed.
		if loadState.init then
			log(1, "State found",loadState.time.now.date)
		else
			log(1, "LoadState not init")
		end
		log(1, "Load Settings")
		log.logTab(2,loadState.settings)
		assert(loadState.settings, "Settings empty")
	end
	state.settings = loadState.settings  -- executed in all threads (to avoid assertion)
end

function script.event(name, param)
	local event = script.events[name]
	if event then
		log(3, "scriptEvent", name, param)
		event(param)
	else
		log("handleEvent:", name, param)
		debugPrint(param)
		error("AVS Unhandeled Event")
	end
end

script.events = {
	guiInit = function(param)
		log(2, "scriptevent guiInit")
		state.time.guiinit = param
		state.time.loadtime = state.time.guiinit.clock - state.time.scriptinit.clock
	end,
	calc_active = function(param)
		state.settings.calcactive[param.data] = param.active
	end,
	gamebar_data_visible = function(param)
		state.settings.gamebar[param.data] = param.visible
	end,
	settings = function(param)
		state.settings[param.setting] = param.value
	end,
	script_active = function(param)
		log(2, "script_active event", param)
		state.active = param
		state.error = false
	end,
	zone_change = function(param)
		state.currentzone = param
	end,
	current_tab = function(param)
		state.currenttab = param
	end,
	error = function(param)
		if (not state.error) or param.loc=="Reload" then
			script.errorHandler(param.msg, param.loc, param.traceback)
		end
	end,
}

function script.init()
	log(2,"ScriptInit")
	local ts = timer.timestamp()
	game.avs.scriptstart = ts
	state.time.scriptstart = ts
	state.time.scriptinit = game.avs.scriptinit
	state.time.programstart = timer.timestamp(0).date
	resdata.init(true)
end

function script.update()  -- gamescript update
	if not state.init then
		script.init()
		state.init = true
		log(2,"Calc all data")
		xpcall(script.calc, script.errorHandler, true)
		log(2,"State:",state)
		log.logTab(2,state)
	else
		if state.active then
			if not xpcall(script.calc, script.errorHandler, false) then
				state.active = false
			end
		end
	end
end

function script.calc(all)
	timer.start()
	state.time.now = timer.timestamp()
	state.time.curgametime = state.time.now.clock - (state.time.guiinit and state.time.guiinit.clock or 0 )
	state.program.luamemoryscript = api.util.getLuaUsedMemory()
	local circle = state.currentzone or {radius = math.huge}
	for _,datastr in pairs(datalist) do
		if all or state.settings.calcactive[datastr] or datastr==state.currenttab then
			log(all and 1 or 3,"Calc Data",datastr)
			state.data[datastr] = script.data[datastr].getInfo(circle)
			state.calctime[datastr] = timer.round()
			state.timestamp[datastr] = os.clock()
			-- state.currentzones[datastr] = circle
			log(all and 1 or 3,"Runtime:",state.calctime[datastr])
		end
	end
	state.calctime.total = timer.stop()
end

function script.reload()
	event.ScriptEventId("avs_reload")
end

function script.errorHandler(msg,loc,tb)
	loc = loc or "Script"
	tb = tb or debug.traceback()
	log.logError(msg, loc, tb)
	state.error = {msg=msg, loc=loc, traceback=tb}
end

return script