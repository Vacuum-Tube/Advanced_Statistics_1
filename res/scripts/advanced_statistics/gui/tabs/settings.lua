local datalist = require "advanced_statistics/datalist"
local guibuilder = require "advanced_statistics/gui/guibuilder"
local bgui = require "advanced_statistics/gui/basic"
local format = require "advanced_statistics/gui/format"
local event = require "advanced_statistics/script/event"
local ScriptEvent = (require "advanced_statistics/script/event").ScriptEvent
local log = (require "advanced_statistics/log").logPrefix("settings")

return function(state,window,gamebar)
	local tabl = api.gui.comp.Table.new(4,"")
	tabl:setHeader(guibuilder.buildComponents{
		{	text = _("Datatype"),
			tooltip = _("SetDatatypeTT")
		},
		{	text = _("Runtime"),
			tooltip = _("SetRuntimeTT")
		},
		{	text = _("Run").." (".._("Always")..")",
			tooltip = _("SetRunTT")
		},
		{	text = _("Game bar"),
			tooltip = _("SetGamebarTT")
		},
	})
	for _,datastr in pairs(datalist) do
		local datalabel = bgui.Text(string.upper(datastr))
		local calctime = bgui.Text()
		-- calctime:addStyleClass("AVS-text-noto")
		calctime:onStep( function()
			local ctime = state.calctime[datastr]
			calctime:setText(ctime and format.TimeMilSec(ctime, 3) or "-")
			if state.settings.calcactive[datastr] and ctime and ctime>0.025 then
				bgui.setNegative(calctime)
			else
				bgui.setNeutral(calctime)
			end
		end)
		
		local checkActive = bgui.Checkbox("", function(check)
			--game.interface.sendScriptEvent("avs", "calc_active", {data=datastr, active=check} )  --c:\build\tpf2_steam\src\game\scripting\legacy\cmd_interface.cpp:45: auto __cdecl scripting::SetupLegacyCommandInterface::<lambda_124f208fdf551961689cb30c65e05b30>::operator ()(class lua::State &) const: Assertion `!gameState.GetGameScriptFileNameStack().empty()' failed.
			ScriptEvent("calc_active", {data=datastr, active=check} )
			if check then 
				bgui.setPositive(datalabel)
			else
				bgui.setNeutral(datalabel)
			end
		end)
		if state.settings.calcactive[datastr] then
			checkActive:setSelected(true,false)
			bgui.setPositive(datalabel)
		else
			bgui.setNeutral(datalabel)
		end
		
		local checkGbar = bgui.Checkbox("", function(check)
			ScriptEvent("gamebar_data_visible", {data=datastr, visible=check} )
			gamebar.setVisible(datastr, check)
		end, nil )
		if state.settings.gamebar[datastr] then
			checkGbar:setSelected(true,false)
		else
			if not state.error then
				gamebar.setVisible(datastr, false)
			end
		end
		
		tabl:addRow{
			datalabel,
			calctime,
			checkActive,
			checkGbar,
		}
	end
	
	local calctotalTime = bgui.Text()
	calctotalTime:onStep( function()
		local ctime = state.calctime.total
		calctotalTime:setText(ctime and format.TimeMilSec(ctime,3) or "-")
		if ctime and ctime>0.05 then
			bgui.setNegative(calctotalTime)
		else
			bgui.setNeutral(calctotalTime)
		end
	end)
	tabl:addRow(guibuilder.buildComponents{
		_("Total"),
		calctotalTime,
		bgui.Nothing(),
		bgui.Nothing(),
	})
	
	
	local freedatabutton = bgui.Button(_("Free Data"), function()
		ScriptEvent("free_data")
	end)
	freedatabutton:setTooltip(_("freedataTT"))
	
	local toggleactive = true
	local scripttext = bgui.Text("Script")
	local scriptbutton = bgui.Button(scripttext, function()
		ScriptEvent("script_active", not toggleactive)
	end, false, nil, "AVSScriptButton")
	scriptbutton:onStep( function()
		if state.active then
			toggleactive = true
			bgui.setPositive(scripttext)
			scripttext:setText("Script - ".._("Active"))
			freedatabutton:setEnabled(false)
		else
			toggleactive = false
			bgui.setNegative(scripttext)
			scripttext:setText("Script - ".._("Deactivated"))
			freedatabutton:setEnabled(true)
		end
	end)
	
	
	return guibuilder.buildComponent({ layout = { type = "BoxV", 
		content = {
			tabl,
			guibuilder.buildCompLayout("BoxH",{
				_("Last Update")..":",
				function(time) return
					time.now.date
				end
			},function()
				return state.time
			end),
			guibuilder.buildCompLayout("BoxH",{
				scriptbutton,
				freedatabutton,
			}),
			
			"<hline>",
			bgui.Checkbox(_("showWindowSet"),
				function(check)
					ScriptEvent("settings", {setting="show_window", value=check} )
				end,
				nil,
				state.settings.show_window
			),
			bgui.Checkbox(_("gamebarInsertSet"), 
				function(check)
					ScriptEvent("settings", {setting="gamebar_insert", value=check} )
					bgui.Window("Changes will apply after restart",nil,nil,{h=800,v=400})
				end, 
				_("gamebarInsertSetTT"),
				state.settings.gamebar_insert
			),
			bgui.Checkbox(_("hideGameInfoSet"), 
				function(check)
					ScriptEvent("settings", {setting="gameinfo_hide", value=check} )
					gamebar.setGameInfoVisible(not check)
				end, 
				_("hideGameInfoSetTT"),
				state.settings.gameinfo_hide
			),
			bgui.Checkbox("Advanced Advanced Statistics",
				function(check)
					ScriptEvent("settings", {setting="advadv", value=check} )
					bgui.Window("Changes will apply after restart",nil,nil,{h=800,v=400})
				end, 
				_("advadvTT"),
				state.settings.advadv
			),
			bgui.Checkbox(_("startSoundSet"),
				function(check)
					ScriptEvent("settings", {setting="start_sound", value=check} )
				end, 
				_("startSoundSetTT"),
				state.settings.start_sound
			),
			
			"<hline>",
			bgui.Button(_("Reload"),function()
				gamebar.destroy()
				window.destroy()
				event.ScriptEventId("avs_reload")
			end),
		}
	}})
end