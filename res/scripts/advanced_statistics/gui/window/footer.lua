local guibuilder = require "advanced_statistics/gui/guibuilder"
local bgui = require "advanced_statistics/gui/basic"
local format = require "advanced_statistics/gui/format"
local log = (require "advanced_statistics/log").logPrefix("window.footer")
local _s = require "advanced_statistics/strings"

local f = {}

function f.init(state,datastr)
	log(2, "Create footer", datastr)
	
	local calctime = bgui.Text()
	-- calctime:addStyleClass("AVS-text-info")
	-- calctime:addStyleClass("AVS-text-noto")
	calctime:setMinimumSize(api.gui.util.Size.new(50,0))
	-- calctime:setHighlighted(true)
	calctime:onStep( function()
		local ctime = state.calctime[datastr]
		calctime:setText(ctime and format.TimeMilSec(ctime, 2) or "-")  -- space not working
		if ctime and ctime>0.05 then
			calctime:addStyleClass("negative")
			calctime:removeStyleClass("AVS-text-info")
		else
			calctime:removeStyleClass("negative")
			calctime:addStyleClass("AVS-text-info")
		end
	end)
	
	return guibuilder.buildCompLayout("BoxH", {
		{	text = _("Status")..":",
			style = "AVS-text-info",
		},
		{	text = function()
			if not state.active then
				return _s.header.scriptde
			elseif state.settings.calcactive[datastr] then
				return _s.header.alwaysac
			elseif state.currenttab==datastr then
				return _s.header.nowac
			else
				return _s.header.notac
			end
			end,
			style = "AVS-text-info",
		},
		"<hfill>",
		{	text = _("Runtime")..":",
			style  = "AVS-text-info",
		},
		calctime,
	})
end

return f