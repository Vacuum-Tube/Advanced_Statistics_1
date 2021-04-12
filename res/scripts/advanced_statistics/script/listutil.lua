--[[
Listutil
Version: 0.1

Copyright (c)  2021  "VacuumTube"  (https://www.transportfever.net/wsc/index.php?user/29264-vacuumtube/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including the right to distribute and without limitation the rights to use, copy and/or modify
the Software, and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.
--]]


local u = {}

function u.tableadd(tab,add)
	if #tab==#add then
		for i = 1,#add do
			tab[i] = tab[i] + add[i]
		end
	else
		error("table size dont match: "..tostring(#tab).."/"..tostring(#add))
	end
end

function u.add(tab, field, val)  -- not kidding, why dont you have += or ++ , LUA?
	-- tab[field] = tab[field] + val
	tab[field] = assert(tab[field], "Field nil: "..tostring(field)) + val
end


function u.range(start,enD)
	if enD==nil then
		enD = start
		start = 1
	end
	local r = {}
	for i = start,enD do
		table.insert(r, i)
	end
	return r
end

function u.zeros(count,what)
	local z = {}
	for i = 1,count do
		table.insert(z, what)
	end
	return z
end

function u.newList(dim)
	local list
	if dim then
		list = {
			dim = dim,
			num = 0,
			sum = u.zeros(dim,0),
			max = u.zeros(dim,0),
			min = u.zeros(dim,math.huge),
		}
		setmetatable(list.sum, u.mtList)
	else
		list = {
			num = 0,
			sum = 0,
			max = 0,  --  -math.huge  also causing to .sav.lua not readable
			min = math.huge,
		}
	end
	return list
end

function u.newVal(List, val)
	u.addsum(List, val)
	u.setmax(List, val)
	u.setmin(List, val)
	u.count(List)
end

function u.newValT(List, val)
	u.addsumT(List, val)
	if List.max then
		u.setmaxT(List, val)
	end
	if List.min then
		u.setminT(List, val)
	end
	u.count(List)
end

function u.count(List)
	List.num = List.num + 1
end

function u.addsum(List,add)
	List.sum = List.sum + add  
end

function u.addsumT(List,add)
	local _ = List.sum + add  -- meta __add writes sum
end

function u.setmax(List,val)
	if val>List.max then
		List.max = val
	end
end

function u.setmin(List,val)
	if val<List.min then
		List.min = val
	end
end

function u.setmaxT(List,val)
	for i=1,List.dim do
		if val[i]>List.max[i] then
			List.max[i] = val[i]
		end
	end
end

function u.setminT(List,val)
	for i=1,List.dim do
		if val[i]<List.min[i] then
			List.min[i] = val[i]
		end
	end
end

u.mtList = {
	-- __tostring = function()
		-- return "List"
	-- end,
	-- __len = function(List)
		-- return "x"
	-- end,
	__add = function(sum,val)
		-- if type(val)=="table" then
			u.tableadd(sum,val)  -- WARNING tableadd writes sum
		-- else
			-- return List.sum + val
		-- end
	end,
	__div = function(sum,val)
		local div = {}
		for i,s in pairs(sum) do
			div[i] = s/val
		end
		return div
	end,
	-- __call = function(List,args)
		-- return
	-- end,
}

local ValueList = {}
u.ValueList = ValueList
ValueList.__index = ValueList
function ValueList:new(dim)
	--self.__index = self
	local o = u.newList(dim)
	setmetatable(o, self)
	return o
end
function ValueList:newVal(val,bool)
	if bool~=false then
		if self.dim then
			u.newValT(self, val)
		else
			u.newVal(self, val)
		end
	end
end
function ValueList:finish()
	self.av = (self.num>0) and self.sum/self.num --or -1  -- prevent -nan(ind)
end
function ValueList:setRel(relVal)
	self.rel = (relVal>0) and self.sum/relVal
end



function u.newCountList(list)
	local clist = {}
	if type(list)=="number" then
		list = u.range(list)
	end
	for _,val in pairs(list) do
		clist[val] = 0
	end
	return clist
end

local CountList = {}
u.CountList = CountList
CountList.__index = CountList
CountList.__mt_dynamic = {
	__index = function (table, key)
		if key=="count" then
			return CountList.count
		elseif key=="sumAll" then
			return CountList.sumAll
		elseif type(key)=="string" and key:starts("__") then  -- avoid _(0) from __metatag__ (see serialize)
			return 
		else
			return 0  -- dynamic new count field 
		end
	end
}
function CountList:new(fields,dynamic)
	local o = u.newCountList(fields or {"count_"})
	if dynamic then
		setmetatable(o, CountList.__mt_dynamic)
	else
		setmetatable(o, CountList)
	end
	return o
end
function CountList:count(field,number,bool)
	if bool~=false then
		u.add(self, field or "count_", number or 1 )
	end
end
function CountList:sumAll()
	local sum = 0
	for key,count in pairs(self) do
		sum = sum + count
	end
	return sum
end


return u