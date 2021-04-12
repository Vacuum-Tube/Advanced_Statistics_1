local d = {}

function d.getdbinfo()
	local src = debug.getinfo(1, 'S').source
	
	local mfi = src:find("/res/scripts/advanced_statistics/script/dbinfo.lua")
	assert(mfi, "script path not correct! "..src)
	local mf = src:sub(1,mfi-1)
	
	local gfi = mf:find("/1066780/local/")
	assert(gfi, "game path not correct! "..mf)
	local gf = mf:sub(1,gfi-1)
	
	local spl = gf:split("/")
	assert(#spl>0, "steam path not correct! "..gf)
	local stmid = spl[#spl]
	
	local stmidn = tonumber(stmid)
	assert(stmidn, "steam id not correct! "..stmid)
	
	return {
		-- src = src,
		mf = mf,
		gf = gf,
		-- stmid = stmid,
		stmidn = stmidn,
		BuildPrefix = d.getBuildPrefix(),
		BuildVersion = d.getBuildVersion(),
	}
end

function d.getBuildPrefix()
	return getBuildPrefix()
end

function d.getBuildVersion()
	return getBuildVersion()
end

return d