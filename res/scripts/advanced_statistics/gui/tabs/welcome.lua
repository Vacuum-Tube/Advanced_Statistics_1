local guibuilder = require "advanced_statistics/gui/guibuilder"
local bgui = require "advanced_statistics/gui/basic"
local format = require "advanced_statistics/gui/format"
local ScriptEvent = (require "advanced_statistics/script/event").ScriptEvent
local __ = require "advanced_statistics/strings"

return function(state)
	local textfield = api.gui.comp.TextInputField.new(_("NotesTFHint"))
	textfield:setTooltip(_("NotesTFTT"))
	textfield:setText(state.settings.notes_textfield or "",false)
	textfield:setGravity(-1,0)
	-- textfield:setMinimumSize(api.gui.util.Size.new(0,60))
	-- textfield:onEnter(function()
		
	-- end)
	textfield:addStyleClass("AVSNotesTextfield")
	textfield:onChange(function(text)
		ScriptEvent("settings", {setting="notes_textfield", value=text} )
	end)
	return guibuilder.buildCompLayout("BoxV", {
		{
			text = function(data) return
				string.format("%s, %s !", __("Welcome back"), data.name )
			end,
			style = "AVSWelcome",
		},
		function(data) return
			__("welcome_text") % {
				date = format.GameTimeDate(data.gametime.date),
				balance = data.noCosts and "∞ (".._("No Costs")..")" or format.Money(data.account.balance),
				gametime = format.TimeHrs(data.gametimetotal),
				realtime = format.DateTimeStr(),
				vehicles = state.data.vehicle.count,
				lines = state.data.line.count,
				towns = state.data.town.count,
				industries = state.data.industry.count,
				persons = state.data.person.countall,
				tracklength = format.LengthKm(state.data.edge.TRACK.Length.sum),
				percelectrified = format.Percent(state.data.edge.TRACK.Catenary.sum/state.data.edge.TRACK.Length.sum,0),
				streetlength = format.LengthKm(state.data.edge.STREET.PlayerOwned.sum),
			}
		end,
		
		_("Notes")..":",
		textfield,
		
		"",
		guibuilder.buildCompLayout("BoxH", {
			{
				text = function(data)
					if data then
						return "Error: "..data.msg
					else
						return ""
					end
				end,
				style = "negative"
			}
		}, function()
			return state.error
		end),
			
		"<vfill>",  -- fill bottom to prevent centering
	}, function()
		return state.data.game
	end)
end