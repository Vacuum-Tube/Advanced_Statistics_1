--[[
Gui Basic
Version: 0.1

Copyright (c)  2021  "VacuumTube"  (https://www.transportfever.net/wsc/index.php?user/29264-vacuumtube/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including the right to distribute and without limitation the rights to use, copy and/or modify
the Software, and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.
--]]


local b = {}


function b.LayoutH()
	return api.gui.layout.BoxLayout.new("HORIZONTAL")
end

function b.LayoutV()
	return api.gui.layout.BoxLayout.new("VERTICAL")
end

function b.LineV()
	return api.gui.comp.Component.new("VerticalLine")
end

function b.LineH()
	return api.gui.comp.Component.new("HorizontalLine")
end


function b.Comp(name)
	return api.gui.comp.Component.new(name or "")
end

function b.Nothing()
	return b.Comp()
end

function b.Text(text,style)
	local comp = api.gui.comp.TextView.new(tostring(text or ""))
	if style then
		comp:addStyleClass(style)
	end
	return comp
end

function b.TextInput(text,hint,readonly)
	local textfield = api.gui.comp.TextInputField.new(hint or "")
	textfield:setText(text or "",false)
	if readonly then
		textfield:setEnabled(false)
	end
	return textfield
end

function b.Icon(path,style)
	local comp = api.gui.comp.ImageView.new(path or "")
	if style then
		comp:addStyleClass(style)
	end
	return comp
end

function b.Button(comportext,onClick,toggle,selected,style)
	if type(comportext)=="userdata" then
		local button
		if toggle then
			button = api.gui.comp.ToggleButton.new(comportext)
			if onClick then
				button:onToggle(onClick)  -- function(toggle)
			end
			if selected then
				button:setSelected(true,true)
			end
		else
			button = api.gui.comp.Button.new(comportext, true)
			if onClick then
				button:onClick(onClick)  -- function()
			end
		end
		button:addStyleClass(style or (toggle and "AVSToggleButton" or "AVSButton"))
		return button
	else
		return b.Button(b.Text(comportext),onClick,toggle,selected,style)
	end
end

function b.Togglebutton(comportext,onToggle,selected,...)
	return b.Button(comportext,onToggle,true,selected,...)
end

function b.ToggleButtonGroup(names,onChanged,default)
	local TButtonGroup = api.gui.comp.ToggleButtonGroup.new(api.gui.util.Alignment.HORIZONTAL, 0, false)
	TButtonGroup:setOneButtonMustAlwaysBeSelected(true)
	TButtonGroup:onCurrentIndexChanged(onChanged)
	--:setEmitSignal(false)
	for i,name in pairs(names) do
		local text = b.Text(name)
		text:addStyleClass("AVS-toggle-button-group-text")
		TButtonGroup:add(b.Togglebutton(text,nil,default==i-1))
	end
	-- onChanged(default)
	TButtonGroup:setGravity(0.5,0)
	return TButtonGroup
end

function b.Checkbox(text,onToggle,tooltip,default)
	local check = api.gui.comp.CheckBox.new(text or "")
	if tooltip then
		check:setTooltip(tooltip)
	end
	if onToggle then
		check:onToggle(onToggle)  -- function(check)
	end
	if default then  --default unchecked
		check:setSelected(true, false)
	end
	return check
end

function b.Slider(settings,onChanged)
	local slider = api.gui.comp.Slider.new(true)  -- horizontal
	slider:setGravity(-1,0.5)  -- horizontal fill, vertical center
	slider:setMinimumSize(api.gui.util.Size.new(200,0))
	slider:setMinimum(settings.min or 0)
	slider:setMaximum(settings.max or 10)
	slider:setStep(settings.step or 1)
	if onChanged then
		slider:onValueChanged(onChanged)
	end
	local default = settings.default or 0
	slider:setDefaultValue(default)
	slider:setValue(default, false)  --better call it index; true triggers onchanged (if default not 0)
	return slider
end

function b.SliderVal(values,default,onChanged,textvalue)
	local updatetext = function(value)
		if textvalue then
			textvalue:setText(tostring(value))
		end
	end
	local onIndexChanged = function(index)
		local value = values[index]
		onChanged(value)
		updatetext(value)
	end
	local defaultIndex = (default==-1 and #values) or default or 1
	local defaultValue = values[defaultIndex]
	updatetext(defaultValue)
	local slider = b.Slider( {
		min = 1,  -- we do this lua style
		max = #values,
		step = 1,
		default = defaultIndex,
	}, onIndexChanged)
	local triggerupdate = function()
		onIndexChanged(slider:getValue())
	end
	return slider, triggerupdate
end


function b.ScrollArea(content,maxSize)
	local comp = api.gui.comp.ScrollArea.new(content,"") --??
	if maxSize then
		comp:setMaximumSize(api.gui.util.Size.new(maxSize.h or -1, maxSize.v or -1))
	end
	return comp
end


function b.Window(comportext,title,icon,pos)
	if type(comportext)=="userdata" then
		local window = api.gui.comp.Window.new(title or "Window", comportext)
		window:addHideOnCloseHandler()
		window:setIcon(icon or "ui/small_button_info.tga")
		window:setPosition(pos and pos.h or 200, pos and pos.v or 200)
		return window
	else
		return b.Window(b.Text(comportext), title, icon, pos)
	end
end
b.showMessage = b.Window

function b.showErrorMsg(msg,loc,tb)
	b.Window(table.concat({
		"An Error was catched!",
		"See stdout log and contact the mod author",
		"",
		string.format("Location: %s", loc or ""),
		string.format("Message: %s", msg),
		tb,
	},"\n"),
	"Advanced Statistics - Error",
	"ui/icons/windows/attention.tga"
	)
end


function b.setPositive(comp)
	comp:addStyleClass("positive")
	comp:removeStyleClass("negative")
end

function b.setNegative(comp)
	comp:addStyleClass("negative")
	comp:removeStyleClass("positive")
end

function b.setNeutral(comp)
	comp:removeStyleClass("positive")
	comp:removeStyleClass("negative")
end

function b.resetStyle(comp)
	comp:setStyleClassList({})
end


return b