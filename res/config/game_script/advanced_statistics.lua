local avs = require "advanced_statistics/main"
local event = require "advanced_statistics/script/event"

local function reload()
	avs.log("Reload","Thread:",avs.thread.getCurrentThread())
	avs.package.unload()
	avs = require "advanced_statistics/main"
end

function data()
	return {
		--init = init,
		update = function()
			-- print("UPDATE",avs.thread.getCurrentThread())
			avs.script.update()
		end,
		handleEvent = function(src, id, name, param)
			if src=="advanced_statistics.lua" then
				if id=="avs_handleEvent" then
					avs.script.event(name, param)
				elseif id=="avs_reload" then
					local oldState = avs.script.state
					local status, ret = pcall(reload)  -- Reloads only Script Thread
					if not status then
						event.ScriptEvent("error", {msg=ret, loc="Reload", traceback=""})
						return  
					end
					avs.script.load(oldState)
					avs.script.update()  -- make sure script init before gui.init
					avs.script.state.reload=true
				elseif id=="avs_reloaded_gui" then
					avs.script.state.reload=false
				else
					print("handleEvent",src,id)
				end
			end
		end,
		save = function()
			-- print("SAVE",avs.thread.getCurrentThread())
			return avs.script.state
		end,
		load = function(state)
			-- print("LOAD",avs.thread.getCurrentThread(),state)
			if state then
				if state.reload then
					reload()  -- Reload in gui instance
					event.ScriptEventId("avs_reloaded_gui")
					avs.gui.load(state)
					avs.gui.init()
				end
				avs.script.load(state)  -- creating unneccessary traffic in Gui Thread Instance...
				avs.gui.load(state)
			end
		end,
		guiInit = function()
			avs.gui.init()
		end,
		guiUpdate = function()
			avs.gui.update()
		end,
		zguiHandleEvent = function(id, name, param)
			-- if name=="visibilityChange" then return end 
			-- print("guiHandleEvent:", id, name, param )
			if name=="idAdded" and id:starts("temp.view.entity_") then
				
			elseif name=="select" then
				
			end
			
			-- if id:match("vehicleWindow.entity%d+.enterCockpit") and name == "button.click" then
				-- taskutil:sendScriptFn("m2a", "enter", { })
				-- unsavedVariables.cockpitView = true
			-- end
			-- if unsavedVariables.cockpitView == true and id == "menu" and name == "visibilityChange" and param == true then
				-- taskutil:sendScriptFn("m2a", "leave", { })
				-- unsavedVariables.cockpitView = false
			-- end
		end,
	}
end