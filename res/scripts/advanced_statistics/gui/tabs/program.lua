local guibuilder = require "advanced_statistics/gui/guibuilder"
local bgui = require "advanced_statistics/gui/basic"
local format = require "advanced_statistics/gui/format"
local a,v,s,o = require "advanced_statistics/adv".sks()

return function(state)
	local fps = bgui.Text()
	local lastupdate = 0
	local updatetime = 0.15e6
	fps:onStep( function (totaltime, steptime)
		if totaltime-lastupdate>updatetime then
			fps:setText(string.format("%.1f", 1e6/steptime))
			lastupdate = totaltime
		end
	end)
	return guibuilder.buildCompLayout("BoxV", {
		{ table = {
			{
				"Build Version",
				getBuildVersion(),
			},
			{
				"Build Prefix",
				getBuildPrefix(),
			},
		}},
		
		"<hline>",
		guibuilder.buildCompLayout("BoxV", {
			{ table = {
				{
					_("Program Startup"),
					{ 
						text = function(data) return
							data.programstart
						end,
						tooltip = _("programStartTT")
					}
				},{
					_("Game Load"),
					{
						text = function(data) return
							data.scriptinit.date
						end,
						tooltip = _("gameLoadTT")
					}
				},{
					_("Game Start"),
					{
						text = function(data) return
							data.guiinit.date
						end,
						tooltip = _("gameStartTT")
					}
				},{
					_("Now"),
					function(data) return
						-- data.now.date
						format.DateTimeStr()
					end
				}
			}},
			"<hline>",
			{ table = {
				{
					_("Program Time"),
					{
						text = function(data) return
							format.TimeHrs(data.now.clock).." / "..format.TimeMin(data.now.clock)
						end,
						tooltip = function(data) return
							"Clock: "..data.now.clock
						end,
					}
				},{
					_("Game Time"),
					{
						text = function(data) return
							format.TimeHrs(data.curgametime).." / "..format.TimeMin(data.curgametime)
						end,
					}
				},{
					_("Loading Time"),
					{
						text = function(data) return
							format.TimeMin(data.loadtime).." / "..format.TimeSec(data.loadtime)
						end,
						tooltip = _("loadingTimeTT")
					}
				}
			}},
		}, function()
			return state.time
		end),
		
		a("<hline>"),
		a{ layout = { type = "BoxH",
			content = {
				"FPS:", fps,
			}
		}},
		
		a("<hline>"),
		a(guibuilder.buildCompLayout("BoxV", {
			{ table = {
				{
					_("Lua Used Memory").." (Script Thread)",
					function(data) return
						format.Number(state.program.luamemoryscript).." B"
					end,
				},{
					_("Lua Used Memory").." (Gui Thread)",
					function(data) return
						format.Number(api.util.getLuaUsedMemory()).." B"
					end,
				},
			}},
		}, function()
			return
		end)),
		
		"<hline>",
		
		
		"Transport Fever 2",
		bgui.TextInput("https://www.transportfever2.com/"),
		
		"Wiki",
		bgui.TextInput("https://www.transportfever2.com/wiki/doku.php"),
		
		"",
		
		-- bgui.Icon("ui/savegame_screenshot_placeholder.tga"),
		bgui.Icon("ui/advanced_statistics/tf2logo.tga"),
		
		"",
		
		a("Reference"),
		a(bgui.TextInput("https://transportfever2.com/wiki/api/")),
		
		bgui.Button(guibuilder.buildCompLayout("BoxH", {
			-- string.format("Build Version:  %s %s", getBuildPrefix(), getBuildVersion()),
			_("Release Notes"),
			bgui.Icon("ui/external_link.tga"),
		}), function()
			bgui.Window(bgui.TextInput("https://www.transportfever2.com/wiki/doku.php?id=releasenotes"), _("Release Notes"))
		end),
		
		"<vfill>",
	})
end