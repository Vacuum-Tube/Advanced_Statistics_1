local steamdesc = require "advanced_statistics/steamdesc"
local changelog = require "advanced_statistics/changelog"

return {
	name = _("mod_name"),
	desc = steamdesc.replacedesc(_("mod_desc")),
	desc_steam = table.concat({  -- complete description for steam
		_("mod_desc"),
		string.format("[h3]%s:[/h3]\n%s   [b]%s![/b]\n", 
			_("mod_desc_paypal"),
			"[url=https://paypal.me/VacuumTubeTPF ][img] https://raw.githubusercontent.com/Vacuum-Tube/Advanced_Statistics_1/main/pictures/paypal.png [/img][/url]",
			_("Thank You") 
		), --https://i.imgur.com/cYGJEcZ.jpg
		_("mod_desc_discussion"),
	},"\n"),
	version = {
		major = 1,
		minor = 16,
	},
	modlink = {
		steam = "https://steamcommunity.com/sharedfiles/filedetails/?id=2454731512",
		tfnet = "https://www.transportfever.net/filebase/index.php?entry/6204-advanced-statistics/",
		github = "https://github.com/Vacuum-Tube/Advanced_Statistics_1",
		steambugthread = "https://steamcommunity.com/workshop/filedetails/discussion/2454731512/3167694551641497821/",
	},
	VacuumTube = {
		steam = "https://steamcommunity.com/profiles/76561198342751450/myworkshopfiles/?appid=1066780",
		tfnet = "https://www.transportfever.net/filebase/index.php?entry-list/&userID=29264", --"https://www.transportfever.net/wsc/index.php?user/29264-vacuumtube/"
		donate = "https://paypal.me/VacuumTubeTPF",
	},
	changelog = changelog,
}