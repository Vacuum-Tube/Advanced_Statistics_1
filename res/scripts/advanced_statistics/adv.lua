local a = {}

local advactive
local hide

function a.setadv(b)
	advactive=b
end

function a.sethide(b)
	hide=b
end

function a.adv(cont)
	if advactive then
		return cont
	else
		-- return false
		return nil
	end
end

function a.str(cont)
	if advactive then
		return cont
	else
		return ""
	end
end

function a.aor(a,b)
	if advactive then
		return a
	else
		return b
	end
end

function a.table(row)
	if hide then
		return {row[1], "<hidden> "}
	else
		return row
	end
end

function a.sks()
	return a.adv,a.table,a.str,a.aor
end

-- return function()
	-- return a.adv,a.table,a
-- end

return a