local steamdesc = require "advanced_statistics/steamdesc"

return {
	name = _("mod_name"),
	desc = steamdesc.replacedesc(_("mod_desc")),
	desc_steam = table.concat({  -- complete description for steam
		_("mod_desc"),
		string.format("[h3]%s:[/h3]\n%s  %s!\n", _("mod_desc_paypal"), "[url=https://paypal.me/VacuumTubeTPF ][img] https://raw.githubusercontent.com/Vacuum-Tube/Advanced_Statistics_1/main/pictures/paypal.png [/img][/url]", _("Thank You") ), --https://i.imgur.com/cYGJEcZ.jpg
		_("mod_desc_discussion"),
	},"\n"),
	version = {
		major = 1,
		minor = 10,
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
	changelog = [[
1.10  2021-09-17
-Stabilized, workarounds for some of the errors (not 100% resolved)

1.9  2021-07-13
-Improve fallback for mysterious errors
-Supplied towns: consider towns without cargo needs; redefine completely to 75%
-Add sound effect to donate button

1.8  2021-07-02
-Minor changes

1.7  2021-06-21
-Adjust to new con. type TRACK_CONSTRUCTION (resources)
-Adjust to new railroad crossing state
-Add more logs and error handling

1.6  2021-05-27
-Transportfever.net Release

1.5  2021-05-21
-Add total carrier values to finances tab
-Add free data button, to reduce state size

1.4  2021-05-17
-New finances tab
-Warning message for placeholder cubes
-Set default Log Level back to 1

1.3  2021-04-18
-Add russian translation
-Improve error logs

1.2  2021-04-13
-Extend Log messages

1.1  2021-04-12
-Add steam mod link
-Fix api.engine.util.getTransportedData not available (old game version)
-Set up GitHub repository
-Add changelog view

1.0  2021-04-12
Release
]],
}