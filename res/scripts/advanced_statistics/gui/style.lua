local s = {
	positive = {
		add = {"positive"},
		rem = {"negative"},
	},
	negative = {
		add = {"negative"},
		rem = {"positive"},
	},
	neutral = {
		rem = {"positive","negative"},
	},
}

s.finance = function(v)
	if v and v>0 then
		return s.positive
	elseif v and v<0 then
		return s.negative
	else
		return s.neutral
	end
end

s.condition = function(v)
	if v and v>0.8 then
		return s.positive
	elseif v and v<0.4 then
		return s.negative
	else
		return s.neutral
	end
end

return s