local datalist = require "advanced_statistics/datalist"
local guidataall = require "advanced_statistics/gui/guidata"
local guibuilder = require "advanced_statistics/gui/guibuilder"
local bgui = require "advanced_statistics/gui/basic"
local guio = require "advanced_statistics/gui/objects"
local view = require "advanced_statistics/gui/view"
local zone = require "advanced_statistics/gui/zone"
local event = require "advanced_statistics/script/event"
local format = require "advanced_statistics/gui/format"
local _log = (require "advanced_statistics/log")
local log = _log.logPrefix("window")

local w = {
	windowId = "advanced_statistics.windowmain",
	tabwidget = require "advanced_statistics/gui/window/tabwidget",
}


function w.init(state,gamebar)
	log(2,"Create window")
	local window = api.gui.comp.Window.new("Advanced Statistics", w.tabwidget.init(state,w,gamebar))
	w.window = window
	window:setId(w.windowId)
	window:addHideOnCloseHandler()
	window:setPinButtonVisible(true)
	-- window:setResizable(true)
	window:setPosition(300,100)
	-- window:setMaximumSize(api.gui.util.Size.new(-1,777))  -- cutting ScrollArea
	window:setMinimumSize(api.gui.util.Size.new(350,-1))
	-- window:setIcon("ui/small_button_info.tga")
	window:setIcon("ui/advanced_statistics/statistics40.tga")
	window:onMove(function()
		window:setPinned(true)
	end)
	-- window:onClose(function()
	window:onVisibilityChange(function(visible)
		log(2,"Window VisibilityChange",visible)
		gamebar.selectAVS(visible)
		gamebar.setHighlighted(not visible, 1.5)
		local datastr = w.tabwidget.getCurrentDatastr()
		gamebar.select(datastr,visible)
		if visible then  -- not move when only changing tab
			window:setPosition(75,85)
			event.ScriptEvent("current_tab", datastr)
		else
			zone.remZone("avs_zone")
			event.ScriptEvent("zone_change", nil)
			event.ScriptEvent("current_tab", nil)
			window:setPinned(false)
		end
	end)
	log(1,"Successfully created main window")
	gamebar.selectAVS(true)
	w.show(state.settings.show_window~=false)
end

function w.show(bool,tab)
	log(2,"Show Window",bool,tab)
	if w.window then
		w.window:setVisible(bool,true)
		if tab then
			w.tabwidget.settab(tab)
		end
	else
		bgui.showMessage("No window !")
	end
end

function w.isVisible()
	return w.window:isVisible()
end

function w.getWindow2()
	return api.gui.util.getById(w.windowId)
end

function w.getWindow()
	return w.window
end

function w.destroy()
	log(1, "Destroy Window")
	w.window:remove()  -- cannot be executed in callback from any component belonging to the window, otherwise:  Warning: a UI element has destroyed itself during handling an event, this leads to undefined behaviour! C:\GitLab-Runner\builds\1BJoMpBZ\0\ug\urban_games\train_fever\src\Lib\UI\debug_util.cpp:417: class std::basic_ostream<char,struct std::char_traits<char> > &__cdecl UI::operator <<(class std::basic_ostream<char,struct std::char_traits<char> > &,const struct UI::DebugOutputLayoutItem &): Assertion `false' failed.
	w.window = nil
end

return w