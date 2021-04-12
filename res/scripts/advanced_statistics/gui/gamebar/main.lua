local datalist = require "advanced_statistics/datalist"
local guidataall = require "advanced_statistics/gui/guidata"
local guibuilder = require "advanced_statistics/gui/guibuilder"
local bgui = require "advanced_statistics/gui/basic"
local format = require "advanced_statistics/gui/format"
local log = (require "advanced_statistics/log").logPrefix("gamebar")

local g = {}

local buttonAVS
local buttons = {}

function g.gameInfo()
	return api.gui.util.getById("gameInfo.layout")
end

function g.menuRight()
	return api.gui.util.getById("mainMenuRightLayout")
end

function g.init(state,window)
	local gameInfo = g.gameInfo()
	local gamebar_insert = state.settings.gamebar_insert
	local gameinfo_hide = state.settings.gameinfo_hide
	if gameinfo_hide then
		g.setGameInfoVisible(false)
	end
	
	if not state.error then
	for i,datastr in pairs(datalist) do
		local guidata = guidataall[datastr]
		local updatedata = function()
			return state.data[datastr]
		end
		local button = bgui.Togglebutton(guibuilder.buildComponent({
				layout = { type = "BoxH", content = {
					(not gamebar_insert) and bgui.LineV() or nil,
					bgui.Icon(guidata.icon),
					guidata.gamebartext,
					(gamebar_insert) and bgui.LineV() or nil, 
				} },
				tooltip = guidata.gamebartooltip,
			}, updatedata), 
			function(toggle)
				window.show(toggle,datastr)
			end
		)
		if gamebar_insert then
			gameInfo:insertItem(button,i-1)
		else
			gameInfo:addItem(button)
		end
		buttons[datastr] = button
		log(2,"Successfully created button",datastr)
	end
	end
	
	g.menuRight():addItem(g.AVSButtonInit(window))
	log(1, "Successfully created gamebar buttons", gamebar_insert and "(insert left)" or "(add right)" )
end

local hlTime = nil

function g.AVSButtonInit(window)
	buttonAVS = bgui.Togglebutton(guibuilder.buildComponent({
		layout = { type = "BoxH",
			content = {
				-- bgui.Icon("ui/small_button_info.tga"),
				bgui.Icon("ui/advanced_statistics/statistics.tga"),
				-- { text = "AVS", name = "AVSButtonText"},
			}
		}
	}), function(toggle)
		window.show(toggle)
	end, nil, "AVSButtonGamebar")
	buttonAVS:setTooltip(_("mod_name"))
	local hlEnd
	buttonAVS:onStep( function(totaltime, steptime)  -- Highlight deac 
		if hlEnd and totaltime>hlEnd then
			buttonAVS:setHighlighted(false)
			hlEnd = nil
		end
		if hlTime then
			hlEnd = totaltime + hlTime
			hlTime = nil
		end
	end)
	log(2,"Successfully created AVSButton")
	return buttonAVS
end

function g.setHighlighted(bool,time)
	buttonAVS:setHighlighted(bool)
	if bool and time then
		hlTime = time*1e6
	end
end

function g.selectAVS(bool)
	buttonAVS:setSelected(bool,false)
end

function g.select(which,bool)
	if not which then return end
	local b = buttons[which]
	if b then
		b:setSelected(bool,false)
	else
		bgui.showMessage("No button: "..tostring(which))
	end
end

function g.setVisible(which,bool)
	-- if not which then return end
	local b = buttons[which]
	if b then
		b:setVisible(bool,false)
	else
		bgui.showMessage("No button: "..tostring(which))
	end
end

function g.getButton()
	return buttonAVS
end

function g.destroy()
	log(1, "Destroy Gamebar Buttons")
	g.menuRight():removeItem(buttonAVS)
	buttonAVS:destroy()
	
	local gameInfo = g.gameInfo()
	for datastr,button in pairs(buttons) do
		gameInfo:removeItem(button)
		button:destroy()
	end
end

local gameInfoElements = {
	"gameInfo.earningsComp",
	"gameInfo.verticalLine1",
	"gameInfo.passengerComp",
	"gameInfo.verticalLine2",
	"gameInfo.cargoComp",
}

function g.setGameInfoVisible(bool)
	log(2,"setGameInfoVisible",bool)
	for i,id in pairs(gameInfoElements) do
		local elem = api.gui.util.getById(id)
		if elem then
			elem:setVisible(bool,false)
		else
			bgui.showMessage("No elem: "..id)
		end
	end
end

return g