local info = require "advanced_statistics/info"
function data()
	return {
		info = {
			name = "Advanced Statistics",--info.name,
			description = info.desc_steam,
			minorVersion = info.version.minor,
			severityAdd = "NONE",
			severityRemove = "NONE",
			tags = {"Script Mod"},
			authors = {
				{
					name = "VacuumTube",
					role = "CREATOR",
					tfnetId = 29264,
				},
			},
			url = "https://www.transportfever.net/filebase/index.php?entry/6204-advanced-statistics/",
			params = {
				{	key = "avslog",
					name = "Log Level",
					values = {
						"0 ".._("Off"),
						"1 ".._("Default"),
						"2 ".._("More"),
						"3 ".._("All"),
					},
					defaultIndex = 1,  -- forgot, this is still not working...
				}
			}
		},
		runFn = function (settings, modParams)
			--print("runfn",os.date(),os.clock())
			--runFcnt = runFcnt + 1
			--print(string.format("AVS runFn (%d)", runFcnt) , os.date() )  -- always (1)
			--print("avs",game.avs)  -- always nil
			
			local params = modParams[getCurrentModId()]
			-- print("params")
			-- debugPrint(params)
			
			assert(not game.avs, info.name.." loaded twice!")
			
			game.avs = {
				runfn = {
					clock = os.clock(),
					date = os.date(),
				},
				loglevel = params and params.avslog or 1  -- default
			}
		end
	}
end