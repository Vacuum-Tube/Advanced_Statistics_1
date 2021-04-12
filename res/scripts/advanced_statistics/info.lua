local steamdesc = require "advanced_statistics/steamdesc"

return {
	name = _("mod_name"),
	desc = steamdesc.replacedesc(_("mod_desc")),
	desc_steam = table.concat({  -- complete description for steam
		_("mod_desc"),
		string.format("%s:\n%s  %s!\n", _("mod_desc_paypal"), "[url=https://paypal.me/VacuumTubeTPF ][img]https://i.imgur.com/cYGJEcZ.jpg [/img][/url]", _("Thank You") ), --https://i.imgur.com/GpY6AzF.png  https://i.imgur.com/02auDOA.png
		_("mod_desc_discussion"),
	},"\n"),
	version = {
		major = 1,
		minor = 1,
	},
	modlink = {
		steam = "https://steamcommunity.com/sharedfiles/filedetails/?id=2454731512",
		tfnet = "<coming soon>",
	},
	VacuumTube = {
		steam = "https://steamcommunity.com/profiles/76561198342751450/myworkshopfiles/?appid=1066780",
		tfnet = "https://www.transportfever.net/filebase/index.php?entry-list/&userID=29264", --"https://www.transportfever.net/wsc/index.php?user/29264-vacuumtube/"
		donate = "https://paypal.me/VacuumTubeTPF",
	},
	changelog = [[

1.0  2021-04-12
Release
]],
}