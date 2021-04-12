local tt = {}

local ttContainterID = "toolTipContainer"

tt.createText = function(text,tooltip)
	local containerComp = api.gui.util.getById(ttContainterID)  -- where is this created??
	local containerLayout = containerComp:getLayout()
	containerLayout:deleteAll()
	
	local textView = api.gui.comp.TextView.new(text)
	local layout = api.gui.layout.BoxLayout.new("VERTICAL")
	layout:addItem(textView)
	
	local toolTipComp = api.gui.comp.Component.new("ToolTip")
	toolTipComp:setId("avs.toolTipContainer.toolTip")
	toolTipComp:setLayout(layout)
	-- toolTipComp:setTransparent(true)  no effect?
	if tooltip then
		toolTipComp:setTooltip(tooltip)
	end
	containerLayout:addItem(toolTipComp, api.gui.util.Rect.new())
	
	local mousePosition = game.gui.getMousePos()
	containerLayout:setPosition(0, mousePosition[1], mousePosition[2])
end

tt.destroy = function()
	if api.gui then
		local containerComp = api.gui.util.getById(ttContainterID)
		local containerLayout = containerComp:getLayout()
		containerLayout:deleteAll()
	end
end

return tt