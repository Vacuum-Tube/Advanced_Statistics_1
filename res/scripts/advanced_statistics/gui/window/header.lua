local guibuilder = require "advanced_statistics/gui/guibuilder"
local bgui = require "advanced_statistics/gui/basic"
local format = require "advanced_statistics/gui/format"
local event = require "advanced_statistics/script/event"
local zone = require "advanced_statistics/gui/zone"
local log = (require "advanced_statistics/log").logPrefix("window.header")

local h = {}

function h.init(state,datastr)
	log(2, "Create header",datastr)
	local pos, radius
	
	local radiusTextV = bgui.Text()  -- VIEW + RADIUS
	radiusTextV:setMinimumSize(api.gui.util.Size.new(50,0))
	-- radiusTextV:setHighlighted(true)
	-- radiusTextV:onStep(function()
	-- end)
	
	local radiusTextN = bgui.Text(_("Radius")..":")
	
	local slideronchanged = function(value)  -- RADIUS
		local view = game.gui.getCamera()
		pos = {view[1], view[2]}
		radius = value
		event.ScriptEvent("zone_change", {pos = pos, radius = radius })
		zone.setZoneCircle("avs_zone", pos, radius)
	end
	local slider, slidertriggerupdate = bgui.SliderVal(
		{10,20,50,100,200,500,1000,2000,5000,10000,20000, 50000}, 6,
		slideronchanged, 
		radiusTextV
	)
	-- slider:onStep(function()
	-- end)
	
	local positionTextN = bgui.Text(_("Position")..":")  -- VIEW
	local positionTextV = bgui.Text()
	positionTextV:setMinimumSize(api.gui.util.Size.new(140,0))
	-- positionTextV:setHighlighted(true)
	positionTextV:onStep(function()
		local view = game.gui.getCamera()
		pos, radius = {view[1], view[2]}, view[3]/1.8
		radiusTextV:setText(string.format("%.0f", radius))
		positionTextV:setText(string.format("X: %7.0f | Y: %7.0f", pos[1], pos[2]))
		event.ScriptEvent("zone_change", {pos = pos, radius = radius })
		zone.setZoneCircle("avs_zone", pos, radius)
	end)
	
	local viewradiusbar = guibuilder.buildCompLayout("BoxH", {
		radiusTextN,
		slider,
		radiusTextV,
		"",
		positionTextN,
		positionTextV,
	})
	viewradiusbar:setVisible(false,true)
	
	local ToggleButtonGroup = bgui.ToggleButtonGroup({_("Global"),_("View"),_("Radius")}, function(index)  --RadiusViewTT
		log(2, "ToggleButtonGroup IndexChanged",index,datastr)
		if index==0 then
			viewradiusbar:setVisible(false,true)
			zone.remZone("avs_zone")
			event.ScriptEvent("zone_change", nil)
		elseif index==1 then
			viewradiusbar:setVisible(true,true)
			slider:setVisible(false,true)
			positionTextN:setVisible(true,true)
			positionTextV:setVisible(true,true)
		elseif index==2 then
			viewradiusbar:setVisible(true,true)
			slider:setVisible(true,true)
			positionTextN:setVisible(false,true)
			positionTextV:setVisible(false,true)
			slidertriggerupdate()
		else 
			error("AVS ToggleButtonGroup Index: "..index)
		end
	end, 0)
	
	return guibuilder.buildComponent( {
		layout = { type = "BoxV", content = {
			ToggleButtonGroup,
			viewradiusbar,
		} }, 
		gravity = {h=0.5,v=0}
	})
end

return h