local e = {}

function e.ScriptEvent(name,param)
	e.ScriptEventId("avs_handleEvent", name, param)
end

function e.ScriptEventId(id,name,param)
	api.cmd.sendCommand(api.cmd.make.sendScriptEvent("advanced_statistics.lua", id, name or "", param))
end

return e