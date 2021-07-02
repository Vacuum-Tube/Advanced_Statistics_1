--[[
Logger
Version: 0.2

Copyright (c)  2021  "VacuumTube"  (https://www.transportfever.net/wsc/index.php?user/29264-vacuumtube/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including the right to distribute and without limitation the rights to use, copy and/or modify
the Software, and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.
--]]


local info = require "advanced_statistics/info"


local l = {}

local settingLogLevel=99
if game.avs then
	settingLogLevel = game.avs.loglevel
else
	print("No game.avs!")
end
assert(type(settingLogLevel)=="number", "LogLevel Setting not set")

-- toString and debugPrint only accepting 1. arg
function l.print(...)--arg1, arg2, arg3, ...)
	-- if toString then
		-- print(toString(arg1), toString(arg2), toString(arg3), ... )
		-- for i,arg in pairs(table.pack(...)) do -- omitting nil args
			-- if i~="n" then  -- resulting from table.pack
				-- print(toString(arg))
			-- end
		-- end
	-- else
		print(...)
	-- end
end

function l.logLevel(lvl, ...)
	if lvl<=settingLogLevel then
		l.print(...)
	end
end

local prefixdef = "Advanced_Statistics"

function l.logPrefix(prefix,single)
	local prefix = ((not single) and (prefixdef..".") or "")..prefix..":"
	return function(lvlorstringortab, ...)
		if lvlorstringortab then
			if type(lvlorstringortab)=="number" then
				l.logLevel(lvlorstringortab, prefix, ...)
			elseif type(lvlorstringortab)=="table" then
				l.print(prefix, "table:", toString(lvlorstringortab))
			else
				l.print(prefix, lvlorstringortab, ...)
			end
		end
	end
end

l.logDefPref = l.logPrefix(prefixdef,true)

function l.log(...)
	l.logDefPref(...)
end

function l.logTab(lvl,tab)
	if lvl and lvl<=settingLogLevel then
		debugPrint(tab)
	end
end

function l.logError(msg,loc,tb)
	print("===== Advanced Statistics - Error Handler")
	print("Location:",loc)
	print("Message:",msg)
	print(tb or debug.traceback())
	print("===== Advanced Statistics - Please submit this message to the mod author - "..info.modlink.steambugthread)
end

setmetatable(l, {
	__call = function(l,...)
		l.log(...)
	end,
})

l.log(1,"LogLevel:",settingLogLevel)

return l