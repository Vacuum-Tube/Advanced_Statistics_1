--[[
Guibuilder
Version: 0.2

Copyright (c)  2021  "VacuumTube"  (https://www.transportfever.net/wsc/index.php?user/29264-vacuumtube/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including the right to distribute and without limitation the rights to use, copy and/or modify
the Software, and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.
--]]


local log = require "advanced_statistics/log"
local ScriptEvent = (require "advanced_statistics/script/event").ScriptEvent

  -- This saves us a lot of gui scripting...
local g = {}

function g.buildLayout(layout,content,updatedata)
	if type(layout)=="string" then
		local layoutfunc = g.layouts[layout]
		if layoutfunc then
			layout = layoutfunc()
		else
			error("Unknown Layout Type", 2)
		end
	end
	assert(type(content)=="table" or debugPrint(content), "Layout not type table")
	for _,element in pairs(content) do
		local comp = g.buildComponent(element,updatedata)
		if comp then
			layout:addItem(comp)
		end
	end
	return layout
end

function g.buildCompLayout(layouttype,content,updatedata,gravity,style)
	return g.buildComponent({
		layout = {
			type = layouttype,
			content = content,
		},
		gravity = gravity,
		style = style,
	}, updatedata)
end

function g.buildScrollLayout(layouttype,content,updatedata,maxsize,gravity,style)
	return g.buildComponent({
		scrollarea = { content = g.buildCompLayout(layouttype,content,updatedata,gravity,style)	},
		-- gravity = gravity,
		-- style = style,
		maximumSize = maxsize,
	}, updatedata)
end
	

function g.buildComponent(element,updatedata)
	if type(element)=="string" then
		if element:starts("<") and element:ends(">") then
			local word = element:sub(2,-2)
			local wordfunc = g.keywords[word]
			if wordfunc then
				return wordfunc()
			else
				error("Unknown <keyword> "..word, 2)
			end
		else
			return api.gui.comp.TextView.new(element)
		end
	elseif type(element)=="number" then
		return g.buildComponent(tostring(element))
	elseif type(element)=="function" then
		return g.buildComponent( {text=element} , updatedata)
	elseif type(element)=="table" then
		local comp
		for elemtype,elemfunc in pairs(g.elements) do
			if element[elemtype] then
				assert(comp==nil or debugPrint(element), "Not unique element type")
				comp = elemfunc(element[elemtype], updatedata, element)
			end
		end
		assert(comp or debugPrint(element), "Unknown element type")
		for prop,propfunc in pairs(g.properties) do
			if element[prop] then
				propfunc(comp, element[prop], updatedata)
			end
		end
		return comp
	elseif type(element)=="userdata" then  -- element already built
		return element
	elseif element==nil then
		return g.buildComponent("<empty>")
	elseif element==false then
		return nil
	else
		debugPrint(element)
		error("Unhandeled Datatype: "..type(element), 2)
	end
end

function g.buildComponents(content,updatedata)
	local comps = {}
	for _,element in pairs(content) do
		table.insert(comps, g.buildComponent(element,updatedata))
	end
	return comps
end


g.layouts = {
	BoxH = function()
		return api.gui.layout.BoxLayout.new("HORIZONTAL")
	end,
	BoxV = function()
		return api.gui.layout.BoxLayout.new("VERTICAL")
	end,
	-- Abs = function()
		-- return api.gui.layout.AbsoluteLayout.new()
	-- end,
	-- Float = function()
		-- return api.gui.layout.FloatingLayout.new(0,0)
	-- end,
}

g.keywords = {
	hline = function()
		return api.gui.comp.Component.new("HorizontalLine")
	end,
	vline = function()
		return api.gui.comp.Component.new("VerticalLine")
	end,
	empty = function()
		return api.gui.comp.Component.new("empty")
	end,
	hfill = function()
		return g.buildComponent({ comp="", gravity = {h=-1, v=0.5} })
	end,
	vfill = function()
		return g.buildComponent({ comp="", gravity = {h=0.5, v=-1} })
	end,
	fill = function()
		return g.buildComponent({ comp="", gravity = {h=-1, v=-1} })
	end,
}

g.elements = {
	comp = function(name)
		return api.gui.comp.Component.new(name)
	end,
	text = function(text, updatedata)
		if type(text)=="string" then
			return api.gui.comp.TextView.new(text)
		elseif type(text)=="function" then
			local comp = api.gui.comp.TextView.new("<dynamic>")
			comp:onStep( g.errorHandler2(function() 
				comp:setText(tostring(g.getUpdateVal(text, updatedata)))  -- text update function
			end))
			return comp
		else
			error("TypeError element.text", 2)
		end
	end,
	icon = function(path, updatedata)
		if type(path)=="string" then
			return api.gui.comp.ImageView.new(path)
		elseif type(path)=="function" then
			local comp = api.gui.comp.ImageView.new("ui/icons/windows/attention.tga")  -- prevent notfound warning
			comp:onStep( g.errorHandler2(function() 
				comp:setImage( g.getUpdateVal(path, updatedata), true)
			end))
			return comp
		else
			error("TypeError element.icon", 2)
		end
	end,
	table = function(tab, updatedata, element)
		local numcols
		if element.tablecols then  -- auto recognition with table not always reliable
			numcols = element.tablecols
		else
			assert(tab[1] or debugPrint(tab), "tab[1]")
			numcols = #tab[1]
		end
		assert(numcols>0)
		local comp = api.gui.comp.Table.new(numcols,"NONE")  --selectable string one of "NONE", ""SINGLE"" or "MULTI".
		if element.header then
			local headerComps = {}
			for _,elem in pairs(element.header) do
				local comp = g.buildComponent(elem or nil, updatedata)
				comp:addStyleClass("AVS-table-header")
				table.insert(headerComps, comp )
			end
			assert(#headerComps==numcols or debugPrint(element), string.format("Header count (%d) not matching #coloumns: %d",#headerComps,numcols))
			comp:setHeader(headerComps)
		end
		for _,row in pairs(tab) do
			if row then
				local rowComps = {}
				for _,elem in pairs(row) do
					local comp = g.buildComponent(elem or nil, updatedata)
					comp:addStyleClass("AVS-table-item")
					table.insert(rowComps, comp)
				end
				assert(#rowComps==numcols or debugPrint(element), string.format("Row count (%d) not matching #coloumns: %d",#rowComps,numcols))
				comp:addRow(rowComps)
			end
		end
		-- comp:setMaximumSize(comp:calcMinimumSize())  -- not adapting to later changes
		-- comp:setGravity(-1,0)   -- otherwise filling unnecessary space?
		comp:setGravity(0,0)   -- otherwise filling unnecessary space?
		return comp
	end,
	layout = function()
		return api.gui.comp.Component.new("")
	end,
	scrollarea = function(scrollelem, updatedata)
		local content = g.buildComponent(scrollelem.content, updatedata)
		local comp = api.gui.comp.ScrollArea.new(content,"")
		return comp
	end,
}

g.properties = {
	tooltip = function(comp, tooltip, updatedata)
		assert(comp.setTooltip, "Element has not setTooltip!")
		if type(tooltip)=="string" then
			comp:setTooltip(tooltip)
		elseif type(tooltip)=="function" then
			comp:onStep( g.errorHandler2(function()
				comp:setTooltip(tostring(g.getUpdateVal(tooltip, updatedata)))
			end))
		else
			error("TypeError element.tooltip", 2)
		end
	end,
	name = function(comp, name)
		comp:setName(name)
	end,
	style = function(comp, style, updatedata)
		if type(style)=="table" then
			comp:setStyleClassList(style)
		elseif type(style)=="string" then
			comp:setStyleClassList({style})
		elseif type(style)=="function" then
			comp:onStep( g.errorHandler2(function()
				local styles = g.getUpdateVal(style, updatedata)
				for _,style in pairs(styles.add or {}) do
					comp:addStyleClass(style)
				end
				for _,style in pairs(styles.rem or {}) do
					comp:removeStyleClass(style)
				end
			end))
		else
			error("TypeError element.style", 2)
		end
	end,
	gravity = function(comp, gravity)
		comp:setGravity(gravity.h or -1, gravity.v or -1)  -- (horizontal, vertical)
	end,
	maximumSize = function(comp, size)
		comp:setMaximumSize(api.gui.util.Size.new(size.h or -1, size.v or -1))
	end,
	minimumSize = function(comp, size)
		comp:setMinimumSize(api.gui.util.Size.new(size.h or 0, size.v or 0))
	end,
	layout = function(comp, layoutelem, updatedata)
		local layout = g.buildLayout(layoutelem.type, layoutelem.content, updatedata)
		if layoutelem.gravity then
			layout:setGravity(layoutelem.gravity.h or -1, layoutelem.gravity.v or -1)
		end
		comp:setLayout(layout)
	end,
	selectable = function(comp, bool)
		comp:setSelectable(bool)
	end,
}

function g.getUpdateVal(elemfunc,updatedata)
	local status,str = xpcall(elemfunc, g.errorHandler, updatedata and updatedata() )
	return str
end

function g.errorHandler2(func)
	return function(...)
		local status,ret = pcall(func, ...)
		if status then
			return ret
		else
			g.errorHandler("errorHandler2 "..ret)
		end
	end
end

function g.errorHandler(msg)
	-- log.logError(msg, "Gui OnStep")  -- stdout flooding
	ScriptEvent("error", {msg=msg, loc="Guibuilder OnStep", traceback=debug.traceback()} )
	return "<error> "..msg
end

return g