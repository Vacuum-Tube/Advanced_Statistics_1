local guibuilder = require "advanced_statistics/gui/guibuilder"
local bgui = require "advanced_statistics/gui/basic"
local format = require "advanced_statistics/gui/format"
local info = require "advanced_statistics/info"
local __ = require "advanced_statistics/strings"

return function()
	return guibuilder.buildScrollLayout("BoxV", {
		{	layout = {	type="BoxH", content = {
			{	layout = {	type="BoxV", content = {
				{
					text = _("mod_name"),
					style = "AVSHeading2",
				},
				bgui.Button(string.format("%s %d.%d", _("Version"), info.version.major, info.version.minor),
					function()
						bgui.Window(guibuilder.buildScrollLayout("BoxV", {
							{
								text = info.changelog,
								selectable = true,
							}
						}), _("Changelog")
						)
					end),
				{
					text = "© VacuumTube",
					style = "AVSVacuumTube",
				},
			}}},
			"",
			"",
			bgui.Icon("ui/advanced_statistics/image_00.tga"),
		}}},
		
		"<hline>",
		{
			text = info.desc,
			selectable = true,
		},
		
		"<hline>",
		{	layout = {	type="BoxH", content = {
			bgui.Icon("ui/steam_icon.tga"),
			"This Mod on Steam",
		}}},
		bgui.TextInput(info.modlink.steam),
		-- "",
		{	layout = {	type="BoxH", content = {
			bgui.Icon("ui/manaul_installed_mod_icon.tga"),
			"This Mod on transportfever.net",
		}}},
		bgui.TextInput(info.modlink.tfnet),
		
		"",
		
		{	layout = {	type="BoxH", content = {
			bgui.Icon("ui/steam_icon.tga"),
			"VacuumTube on Steam",
		}}},
		bgui.TextInput(info.VacuumTube.steam),
		-- "",
		{	layout = {	type="BoxH", content = {
			bgui.Icon("ui/manaul_installed_mod_icon.tga"),
			"VacuumTube on transportfever.net",
		}}},
		bgui.TextInput(info.VacuumTube.tfnet),
		
		_("Donate")..":",
		bgui.Button(bgui.Icon("ui/advanced_statistics/paypal.tga"),function()
			local w
			local b = bgui.Button(guibuilder.buildComponent({
				text = _("Thank You").."!",
				style = "AVSHeading2"
			}),function()
				game.gui.playSoundEffect("startGame")
				w:close()
			end)
			w = bgui.Window(guibuilder.buildCompLayout("BoxV", {
				bgui.TextInput(info.VacuumTube.donate),
				b,
			}), _("Donate"), "ui/button/small/sell.tga", {h=600,v=700})
		end),
		
		
		"<vfill>",  -- fill bottom to prevent centering
	}, nil, {v=850,h=1300}, {h=-1, v=-1}  )
end