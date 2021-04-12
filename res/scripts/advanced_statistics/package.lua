local p = {}

function p.unload()
	for path,pack in pairs(package.loaded) do
		if path:starts("advanced_statistics/") then
			package.loaded[path]=nil
			print("Unloaded",path)
		end
	end
end

return p