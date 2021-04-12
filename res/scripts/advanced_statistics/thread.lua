local t = {}

function t.hasRunModRunFn()
	return game.avs ~= nil
end

function t.isScriptThread()
	if game.interface then
		return game.interface.addPlayer ~= nil
	else
		return false
	end
end

function t.isGuiThread()
	--return game.gui ~= nil  -- gui not exist on load
	-- if game.gui and gui and 
	if game.interface then
		return game.interface.sendScriptEvent ~= nil
	else
		return false
	end
end

function t.isOtherGameThread()
	if game.config and game.res and (not game.gui) and (not game.interface) then
		return true
	else
		return false
	end
end

function t.isGameConsoleThread()
	if game.config and game.res and game.gui and game.interface and (not t.hasRunModRunFn()) then
		return true
	else
		return false
	end
end

function t.getCurrentThread()
	if not game then
		return "No game (CommonAPI Thread?)"
	elseif t.isOtherGameThread() then
		return "Other Game Thread"
	elseif t.isScriptThread() then
		return "Script Thread"
	elseif t.isGuiThread() then
		return "Gui Thread"
	elseif t.isGameConsoleThread() then
		return "Game Console Thread"
	end
	return "??? Thread"
end


return t