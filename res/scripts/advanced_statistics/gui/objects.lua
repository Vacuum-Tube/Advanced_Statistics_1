--[[
Gui Objects
Version: 0.2.1

Copyright (c)  2021  "VacuumTube"  (https://www.transportfever.net/wsc/index.php?user/29264-vacuumtube/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including the right to distribute and without limitation the rights to use, copy and/or modify
the Software, and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.
--]]


local guibuilder = require "advanced_statistics/gui/guibuilder"
local bgui = require "advanced_statistics/gui/basic"
local format = require "advanced_statistics/gui/format"
local a = require "advanced_statistics/adv".sks()
local ScriptEvent = (require "advanced_statistics/script/event").ScriptEvent

local g = {}

function g.CheckHook(bool)
	return bgui.Icon(string.format("ui/checkbox%s.tga", bool and 1 or 0), "AVS-checkhook")
end

function g.Table(dataorder,coloumns,header,dataupdate,visupdate,type)
	local numcols = #coloumns
	local headerComps
	if header then
		headerComps = {}
		for _,elem in pairs(header) do
			local hcomp = guibuilder.buildComponent(elem, dataupdate)
			if hcomp then
				hcomp:addStyleClass("AVS-table-header")
			end
			table.insert(headerComps, hcomp )
		end
		numcols = #headerComps
	end
	assert(numcols>0)
	local comp = api.gui.comp.Table.new(numcols, type or "NONE")
	if headerComps then
		comp:setHeader(headerComps)
	end
	local rows = {}
	for idx,key in pairs(dataorder) do
		local rowComps = {}
		for _,colfunc in pairs(coloumns) do
			if colfunc then
				local elemcomp = guibuilder.buildComponent(colfunc(key), dataupdate)
				if elemcomp then
					elemcomp:addStyleClass("AVS-table-item")
				end
				table.insert(rowComps, elemcomp )  -- omits nil
			end
		end
		assert(#rowComps==numcols, string.format("Row count (%d) not matching #coloumns: %d",#rowComps,numcols))
		comp:addRow(rowComps)
		rows[key] = rowComps
	end
	if dataupdate and visupdate then
		comp:onStep(function()
			local data = dataupdate()
			for idx,key in pairs(dataorder) do
				local vis = data[key]~=nil
				for i,elem in pairs(rows[key]) do
					elem:setVisible(vis,true)
				end
			end
		end)
	end
	comp:setGravity(0,0)
	return comp
end


function g.Tabwidget(orientation,tabs,tabfunc,icons,updatedata,pretabs,default,translate)
	local tabwidget = api.gui.comp.TabWidget.new(orientation or "NORTH")
	local function addtab(name,content,icon,updatedata)
		if type(content)=="table" then
			content = guibuilder.buildScrollLayout("BoxV", content, updatedata, {v=777,h=1300}, {h=-1, v=-1}, "AVSTabContent" )
		else
			-- content = bgui.ScrollArea(content,{v=666})
		end
		tabwidget:addTab(
			guibuilder.buildCompLayout("BoxH", {
				icon,
				{ text = name, style = "AVS-tab-widget-indicator-text" },
			},nil,{h=-1,v=0}),
			content
		)
	end
	for i,tab in pairs(pretabs or {}) do
		addtab(tab.name, tab.content, tab.icon)
	end
	if tabs then
		for i,tabname in pairs(tabs) do
			addtab(translate~=false and _(tabname) or tabname, tabfunc(tabname), icons and bgui.Icon(type(icons)=="table" and icons[tabname] or icons(tabname)), updatedata and function() return updatedata()[tabname] end)
		end
		tabwidget:setCurrentTab(default or 0,false)
	end
	tabwidget:setDeselectAllowed(false)
	tabwidget:getLayout():getItem(0):setGravity(-1,0)  -- avoid centering of tab indicators
	tabwidget:getLayout():getItem(1):setGravity(-1,0)  -- tab contents
	return tabwidget
end


function g.NameValueList(dataupdate,formatname,formatvalue,sort)
	local namesText = bgui.Text()
	local valuesText = bgui.Text()
	namesText:onStep(function()
		local data = dataupdate()
		local datanames = {}
		for name,value in pairs(data) do
			table.insert(datanames, name)
		end
		if sort then
			table.sort(datanames)
		end
		local names = {}
		local values = {}
		for _,name in pairs(datanames) do
			table.insert(names, format.rmLineBreaks(formatname and formatname(name) or name) )
			table.insert(values, format.rmLineBreaks(formatvalue and formatvalue(data[name]) or data[name] ))
		end
		namesText:setText(format.lines(names))
		valuesText:setText(format.lines(values))
	end)
	return guibuilder.buildCompLayout("BoxV", {
		{ table = {
			{
				namesText,
				valuesText,
			}
		},
		maximumSize = {v=500},
		gravity = {h=0,v=-1},
		}
	})
end


function g.Extend(content,defaultvis)
	defaultvis = defaultvis or false
	local icons = {
		[false] = "ui/down15.tga",-- line-stop_terminal
		[true] = "ui/up15.tga",
	}
	local icon = bgui.Icon(icons[defaultvis])
	local tbutton = bgui.Togglebutton( icon, function(toggle)
		content:setVisible(toggle,true)
		icon:setImage(icons[toggle],true)
	end, defaultvis, "AVSToggleButtonExtend" )
	icon:setGravity(0.5,0)
	tbutton:setGravity(-1,0)
	tbutton:setMinimumSize(api.gui.util.Size.new(-1,20))
	content:setVisible(defaultvis, true)
	return guibuilder.buildComponent({
		layout = { type = "BoxV",  content = {
			tbutton,
			content
		}},
		gravity = {h=-1,v=0},
	})
end


function g.LoadDemand(contentfunc,defaultcontent,returnfunc)
	if returnfunc then
		return function()
			return g.LoadDemand(contentfunc)
		end
	end
	local layout = bgui.LayoutV()
	local loadbutton = bgui.Button(_("Load"),function() xpcall(function()
		-- layout:removeItem(loadbutton)
		for i=1,layout:getNumItems() do
			layout:removeItem(layout:getItem(0))
		end
		layout:addItem(contentfunc())
	end, g.errorHandler) end,
		nil, nil)--, "AVSLoadDemandButton")
	loadbutton:addStyleClass("AVSLoadDemandButton")
	layout:addItem(loadbutton)
	if defaultcontent then
		layout:addItem(defaultcontent)
	end
	local comp = bgui.Comp()
	comp:setLayout(layout)
	return comp
end

function g.errorHandler(msg)
	ScriptEvent("error", {msg=msg, loc="Gui Objects", traceback=debug.traceback()} )
end


function g.ResList(dataupdate,names,values,defaultvis)
	local showfilename = false
	return g.Extend(guibuilder.buildCompLayout("BoxV", {
		g.NameValueList(
			dataupdate,
			type(names)=="table" and (function(filename) return (not showfilename) and names[filename] end) or names,
			type(values)=="table" and (function(filename) return values[filename] end) or values,
			true
		),
		a(bgui.Checkbox(_("Filenames"),
			function(check)
				showfilename=check
			end
		))
	}), defaultvis)
end


local cargoRes = require "advanced_statistics/script/res/cargo"

function g.CargoTypesTable(dataupdate,formatvalue,formatcol2,valuecaption)
	return g.Table(cargoRes.all,{
			function(key)
				return bgui.Icon(cargoRes.icons[key])
			end,
			function(key)
				return cargoRes.names[key]
			end,
			function(key)
				return function(updatedata) return
					formatvalue and formatvalue(key,updatedata[key]) or updatedata[key]
				end
			end,
			formatcol2 and function(key)
				return function(updatedata) return
					formatcol2(key,updatedata[key])
				end
			end,
		},nil and {
			"",
			_("Cargotype"),
			valuecaption or _("Value"),
		}, dataupdate, true)
end



	-- local list = api.gui.comp.List.new(true,api.gui.util.Orientation.VERTICAL,true)
	--:setVerticalScrollBarPolicy(api.gui.comp.ScrollBarPolicy.SIMPLE)
	-- list:onStep(function()
		-- list:clear(true)
		-- for key,elem in pairs(dataupdate()) do
			-- list:addItem(bgui.Text(string.format("%s=%d", key, elem)))
		-- end
	-- end)
	-- return list

return g