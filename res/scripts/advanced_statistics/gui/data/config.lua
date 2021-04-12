local format = require "advanced_statistics/gui/format"
local guio = require "advanced_statistics/gui/objects"
local guibuilder = require "advanced_statistics/gui/guibuilder"
require "serialize"

return {
	-- icon = "ui/system_mod_icon.tga",
	name = _("Base Config"),
	--gamebartext = function(data) return
	--end,
	--gamebartooltip = function(data) return
	--end,
	header = false,
	footer = false,
	windowlayout = function(updatedata) return {
		function(data)
			return toString and toString(data) or tostring(data)
		end,
	} end
}