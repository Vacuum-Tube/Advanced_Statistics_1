local u = {}


function u.getDateTimeStr()
	return os.date("%Y-%m-%d  %H:%M:%S")
end

function u.getCpuSec()
	return os.clock()
end


function u.convertGameSec2Days(gtime)
	local mils = u.getMillis()
	if mils then
		return gtime*1000/mils
	else
		return 0
	end
end

function u.getPastDate(days)
	return game.interface.getDateFromNowPlusOffsetDays(-days)
end

function u.getDateAgo(agotime)
	return u.getPastDate(u.convertGameSec2Days(agotime))
end

function u.getEstimatedStartdate()
	return u.getDateAgo(u.getGameTimeSec())
end

function u.convertDays2Years(days)
	local now = u.getGameTimeDate().year
	local before = u.getPastDate(days)[3]
	return now - before
end


return u