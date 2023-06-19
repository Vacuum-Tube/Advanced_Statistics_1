--[[
Format
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


local mu = require "advanced_statistics/script/miscutil"
local game = require "advanced_statistics/script/data/game"

local f = {}


function f.Str(s)
	return tostring(s)
end

function f.Int(v)
	return v and v==v and v<math.huge and v>-math.huge and string.format("%d", v) or "-"
end

function f.Value(v,n)
	return v and v==v and v<math.huge and v>-math.huge and string.format("%."..(n or 2).."f", v ) or "-"  -- == nan check
end

function f.Percent(p,n)
	return p and p==p and p<math.huge and p>-math.huge and string.format("%."..(n or 1).."f%%", p*100 ) or "-"
end

function f.Promille(p,n)
	return p and p==p and p<math.huge and p>-math.huge and string.format("%."..(n or 0).."f‰", p*1000 ) or "-"
end

function f.Number(n)
	return n and n<math.huge and api.util.formatNumber(math.round(n)) or "-"
end

function f.Length(l)
	return l and api.util.formatLength(l) or "-"
end

function f.LengthKm(l)
	return l and f.Value(l/1000, 0).." km" or "-"
end

function f.Speed(s)
	return s and api.util.formatSpeed(s) or "-"
end

function f.Money(m)
	return m and api.util.formatMoney(math.round(m)) or "-"
end

function f.Weight(m)
	return api.util.formatWeight(m)  -- t
end

function f.Force(m)
	return api.util.formatForce(m)  -- kN
end

function f.Power(m)
	return api.util.formatPower(m)  --kW
end


function f.lines(tab)
	return table.concat(tab, "\n")
end

-- function f.linesFix(tab)  --  concat not so flexible with nil...
	-- local text = ""
	-- for _,str in pairs(tab) do
		-- if str then
			-- text = text .. str .. "\n"
		-- end
	-- end
	-- text = text:gsub("^%s*(.-)%s*$", "%1")  -- trim
	-- return text
-- end

function f.linesList(tab,str,args)
	local t = {}
	for _,elem in pairs(tab) do
		table.insert(t, args and string.format(str, args(elem)) or str(elem) )
	end
	return f.lines(t)
end

function f.linesDict(tab,str,args,sort)
	local t = {}
	for key,elem in pairs(tab) do
		table.insert(t, args and string.format(str, args(key,elem)) or str(key,elem) )
	end
	if sort then
		table.sort(t)
	end
	return f.lines(t)
end

function f.rmLineBreaks(s)
	return s and string.gsub(s, "\n", " ")
end


f.str = {
	av = " (".._("Average")..")",
	min = " (".._("Min")..")",
	max = " (".._("Max")..")",
	sum = " (".._("Sum")..")",
	total = " (".._("Total")..")",
}


function f.DateTimeStr()
	return os.date("%Y-%m-%d  %H:%M:%S")  -- .."\t".. string.format("(%s)", os.clock() )
end

function f.TimeMilSec(t,s)
	return string.format("%"..(s or "")..".0f ms", t*1000 )
end

function f.TimeSec(t)
	return string.format("%.0f s", t )
end

function f.TimeMin(t)
	return string.format("%.0f min", t/60 )
end

function f.TimeHrs(t)
	return string.format("%.1f h", t/3600 )
end

function f.TimeYears(y)
	return string.format("%.0f y", y )
end


function f.GameTimeDate(gamedate)
	if gamedate==nil then
		gamedate = game.getGameTimeDate()
	else
		if gamedate.day==nil then
			gamedate.day = gamedate[1]
			gamedate.month = gamedate[2]
			gamedate.year = gamedate[3]
		end
	end
	return string.format("%.2d.%.2d.%d", gamedate.day, gamedate.month, gamedate.year )  --string.format("%.2d.%.2d.%d\t(%s)", day, month, year, ttime )
end

function f.TimeAgo(agotime)  -- in sec
	local timediff = game.getGameTimeSec() - agotime
	if game.isdatepaused() then
		return f.TimeHrs(timediff)
	else
		return f.TimeYears(mu.convertDays2Years(mu.convertGameSec2Days(timediff)))
	end
end


function f.Age(time0,time1)  -- in ms
	if time1 then
		return api.engine.util.formatAge(math.floor(time0), math.floor(time1))
	else
		if time0 and time0~=0 and time0<math.huge then  -- and time0>0 
			-- return api.engine.util.formatAge(time0, math.floor(game.getGameTimeSec()*1e3) ) -- ensure int
			return api.engine.util.formatAge(math.floor(time0), game.getGameTimeMilSec() ) -- ensure int
		else
			return "-"
		end
	end
end




return f