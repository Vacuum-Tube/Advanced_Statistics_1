local s = {}

function s.replacebrackets(str,cont,repl)
	cont = cont or "(.-)"  -- any
	return str:gsub("%["..cont.."%]", repl or "")
end


function s.replacedesc(str)
	str = s.replacebrackets(str,"%*","-")  -- list elements
	str = s.replacebrackets(str)
	return str
end

return s