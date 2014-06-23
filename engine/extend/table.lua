
-- copies base table, but not nested tables
function table.copy(t)

	local clone = {}
	for k, v in pairs(t) do clone[k] = v end
	return clone
	
end

-- Originally from: http://lua-users.org/wiki/PitLibTablestuff
-- fully copies table and nested tables
function table.deepCopy(t, lookup_table)
	
	local copy = {}
	setmetatable(copy, getmetatable(t))
	for i,v in pairs(t) do
		if ( type(v) ~= "table" ) then
			copy[i] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[t] = copy
			if lookup_table[v] then -- avoid duplicate / recursive references
				copy[i] = lookup_table[v]
			else
				copy[i] = table.deepCopy(v,lookup_table)
			end
		end
	end
	return copy
	
end

function table.hasValue( t, val )

	for k,v in pairs(t) do
		if (v == val ) then return true end
	end
	
	return false
	
end

function table.keyFromValue( tbl, val )

	for key, value in pairs( tbl ) do
		if ( value == val ) then return key end
	end
	return nil
	
end

function table.keysFromValue( tbl, val )

	local res = {}
	for key, value in pairs( tbl ) do
		if ( value == val ) then table.insert( res, key ) end
	end
	return res
	
end

function table.removeByValue( tbl, val )

	for i = #tbl, 1, -1 do
		if (tbl[i] == val) then
			table.remove(tbl, i)
		end
	end
	return tbl
	
end

function table.removeByFilter( tbl, filter_func )

	for i = #tbl, 1, -1 do
		if (filter_func( i, tbl[i] )) then
			table.remove(tbl, i)
		end
	end
	return tbl
	
end

function table.getKeys( t )

	local keys = {}
	for k, v in pairs(t) do
		table.insert(keys, k)
	end
	return keys
	
end

function table.shuffle(t)

	local keys = table.getKeys(t)
	for _, key in ipairs(keys) do
		local okey = keys[math.random(#keys)]
		t[okey], t[key] = t[key], t[okey]
	end
	return t
	
end

function table.forEach( t, func, ... )
	
	if (type(func) == "string") then
		for k, v in pairs( t ) do
			v[func](v, ... ) -- do v:func( ... ) for each
		end
	else
		for k, v in pairs( t ) do
			func( k, v, ... ) -- do func( key, value, ... ) for each
		end
	end
	return t
	
end

function table.count( t, count_func ) -- if count_func(key, value) is supplied, only count where it returns true

	local i = 0
	if count_func then
		for k, v in pairs(t) do 
			if count_func(k, v) then i = i + 1 end
		end
	else
		for k, v in pairs(t) do i = i + 1 end
	end
	return i
	
end

function table.random( t )
  
	local rk = math.random( 1, table.count( t ) )
	local i = 1
	for k, v in pairs(t) do 
		if ( i == rk ) then return v end
		i = i + 1 
	end

end

function table.filter( t, func, retainkeys ) -- filter t where func(key, value) returns true

	local rtn = {}
	for k, v in pairs(t) do
		if func(k, v) then rtn[retainkeys and k or (#rtn + 1)] = v end
	end
	return rtn
  
end

function table.merge(t1, t2, retainkeys) -- merges t2 into t1

	for k, v in pairs(t2) do
		t1[retainkeys and k or (#t1 + 1)] = v
	end
	return t1
	
end

function table.isSequential(t)

	local i = 1
	for key, value in pairs (t) do
		if not tonumber(i) or key ~= i then return false end
		i = i + 1
	end
	return true
	
end

--[[---------------------------------------------------------
   Name: table.toString( table,name,nice )
   Desc: Convert a simple table to a string
		table = the table you want to convert (table)
		name  = the name of the table (string)
		nice  = whether to add line breaks and indents (bool)
		maxdepth = (optional) max depth to print table
		maxseq = (optional) summarizes sequential tables bigger 
				 than this number instead of printing them out 
				 completely
-----------------------------------------------------------]]
function table.toString( t, n, nice, maxdepth, maxseq )

	local nl,tab  = "",  ""
	if nice then nl,tab = "\n", "\t" end

	local function makeTable ( t, nice, indent, done)
		local str = ""
		local done = done or {}
		local indent = indent or 0
		local idt = ""
		if maxdepth and maxdepth <= indent then return tostring(t) end
		if nice then idt = string.rep("\t", indent) end

		local sequential = table.isSequential(t)

		for key, value in pairs (t) do

			str = str..idt..tab..tab

			if not sequential then
				if type(key) == "number" or type(key) == "boolean" then 
					key ='['..tostring(key)..']'..tab..'='
				else
					key = tostring(key)..tab..'='
				end
			else
				key = ""
			end

			if type(value) == "table" and not done[value] then
			
				if (value.__tostring ~= nil) then
					str = str..key..tab..tostring(value)..","..nl
				elseif (table.isSequential(value) and maxseq and #value > maxseq) then
					str = str..key..tab.."{ [sequential table of size "..#value.."] },"..nl
				else
					done[value] = true
					local newtab = makeTable(value, nice, indent + 1, done)
					local _, cnewlines = string.gsub(newtab, " %-%-", "")
					
					if cnewlines > 0 then
						str = str..key..tab..'{'..nl..newtab
						str = str..idt..tab..tab..tab..tab.."},"..nl
					else
						str = str..key..tab..'{ '..newtab.." },"..nl
					end
				end

			else
				
				if 	type(value) == "string" then 
					value = '"'..tostring(value)..'"'
				else
					value = tostring(value)
				end
				
				str = str..key..tab..value..","..nl

			end

		end
		return str
	end
	
	local str = ""
	if n then str = n..tab.."="..tab end
	str = str.."{".. nl..makeTable( t, nice).."}"
	
	return str

end