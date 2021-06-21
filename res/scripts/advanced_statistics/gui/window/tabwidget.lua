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
local log = _log.logPrefix("window.tabwidget")

local t = {
	tabwidgetId = "advanced_statistics.tabwidget",
	widgettabtext = {},
	datatabmap = {},
	datatabmapr = {},
	header = require "advanced_statistics/gui/window/header",
	footer = require "advanced_statistics/gui/window/footer",
	tablist = {
		"welcome",
		"program",
		"settings",
		"info",
	},
	tabs = {},
}

for i,tabstr in pairs(t.tablist) do
	t.tabs[tabstr] = require("advanced_statistics/gui/tabs/"..tabstr)
end


function t.init(state,window,gamebar)
	log(2,"Create tabwidget")
	local tabwidget = guio.Tabwidget("WEST")  -- "NORTH"
	t.tabwidget = tabwidget
	-- tabwidget:setId(t.tabwidgetId)  -- translation bug
	for i,tabstr in pairs(t.tablist) do
		-- tabwidget:addTabText(_(tabstr), t.tabs[tabstr](state,window,gamebar) )
		local content = t.tabs[tabstr](state,window,gamebar)
		content:addStyleClass("AVSTabContent")
		tabwidget:addTab(
			guibuilder.buildCompLayout("BoxH", {
				-- bgui.Icon(""),
				{	text = _(tabstr), style = "AVS-tab-widget-indicator-text", }
			},nil,{h=-1,v=0}),
			content
		)
	end
	tabwidget:setCurrentTab(0,false)
	tabwidget:getLayout():getItem(0):setGravity(0,0)
	tabwidget:getLayout():getItem(1):setGravity(0,-1)
	
	if not state.error then
	for i,datastr in pairs(datalist) do  -- all data tabs
		log(2,"Create tab",datastr)
		local num = tabwidget:getNumTabs()
		t.datatabmap[datastr] = num
		t.datatabmapr[num] = datastr
		local guidata = guidataall[datastr]
		local updatedata = function()  -- get always the current pointer
			return state.data[datastr]
		end
		local datacontent, status
		if type(guidata.windowlayout)=="function" then
			status, datacontent = xpcall(guidata.windowlayout, t.errorHandler, updatedata)
			if not status then
				datacontent = {bgui.Text(datacontent, "negative")}
			end
		else
			datacontent = guidata.windowlayout
		end
		if type(datacontent)=="table" then
			datacontent = guibuilder.buildScrollLayout("BoxV", datacontent, updatedata, {v=777,h=1300}, {h=-1, v=-1}, guidata.vfill~=false and "AVSTabContent" )
		end
		datacontent:setGravity(-1,0)  -- Scroll Bar always at right and prevent vertical centering
		local tabtext = bgui.Text(datastr)
		tabtext:addStyleClass("AVS-tab-widget-indicator-text")
		t.widgettabtext[datastr] = tabtext
		tabwidget:addTab(
			guibuilder.buildCompLayout("BoxH", {
				bgui.Icon(guidata.icon),
				tabtext,
			},nil,{h=-1,v=0}),
			guibuilder.buildCompLayout("BoxV", {
				guidata.header~=false and t.header.init(state,datastr),
				"<hline>",
				guidata.name and { text = guidata.name,  style = "AVSHeading1" },
				datacontent,
				"<vfill>",  -- fill bottom to prevent centering  -- guidata.vfill~=false and 
				"<hline>",
				guidata.footer~=false and t.footer.init(state,datastr),
			})
		)
		log(2,"Successfully created tab",datastr)
	end
	end
	
	tabwidget:onCurrentChanged(function (newtab,oldtab)
		log(2,"tabchange", newtab, oldtab)
		if newtab~=oldtab then
			local olddata = t.datatabmapr[oldtab]
			local newdata = t.datatabmapr[newtab]
			if olddata then
				gamebar.select(olddata,false)
				bgui.setNeutral(t.widgettabtext[olddata])
			end
			if newdata then
				gamebar.select(newdata,true)
				bgui.setPositive(t.widgettabtext[newdata])
				event.ScriptEvent("current_tab", newdata)
			else
				event.ScriptEvent("current_tab", nil)
			end
		end
		zone.remZone("avs_zone")
		event.ScriptEvent("zone_change", nil)
		-- RADIUS update trigger
		-- window:setSize(window:calcMinimumSize())  --nosense
	end)
	log(1,"Successfully created tabwidget")
	return tabwidget
end

function t.getCurrentDatastr()
	return t.datatabmapr[t.tabwidget:getCurrentTab()]
end

function t.settab(which)
	if type(which)=="number" then
		t.tabwidget:setCurrentTab(which,true)
	else
		t.tabwidget:setCurrentTab(t.datatabmap[which],true)
	end
end

function t.getTabwidget()
	return t.tabwidget
end

function t.destroy()
	log(1, "Destroy Tabwidget")
	t.tabwidget:setId("")
end

function t.errorHandler(msg)
	_log.logError(msg, "Gui WindowMain")
	bgui.showErrorMsg(msg, "Gui WindowMain", debug.traceback())
	return "Error: "..msg
end

return t