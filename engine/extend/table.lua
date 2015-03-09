------------------------
-- Extensions to the [table module](http://www.lua.org/manual/5.1/manual.html#5.5).
-- Credit to rxi's [lume](https://github.com/rxi/lume/) lib for some of these functions..
-- @extend table

--- Copies a table.
-- Only copies references to nested tables.
-- @tparam table t table to copy
-- @treturn table copied table
function table.copy(t)
	local clone = {}
	for k, v in pairs(t) do clone[k] = v end
	return clone
end

--- Fully copies table and nested tables.
-- [Credit](http://lua-users.org/wiki/PitLibTablestuff).
-- @tparam table t table to copy
-- @tparam[opt] table lookup_table used for avoiding infinite loops when recursively copying nested tables, just ignore.
-- @treturn table copied table
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

--- Checks if table has a certain value.
-- @tparam table t table to check
-- @param val value to find
-- @treturn bool
function table.hasValue( t, val )
	for k,v in pairs(t) do
		if (v == val ) then return true end
	end
	return false
end

--- Get first key containing the specified value in this table.
-- @tparam table t table to check
-- @param val value to find
-- @treturn ?number|string key
function table.keyFromValue( t, val )
	for key, value in pairs( t ) do
		if ( value == val ) then return key end
	end
	return nil
end

--- Get all keys that contain the specified value in this table.
-- @tparam table t table to check
-- @param val value to find
-- @treturn table table of keys
function table.keysFromValue( t, val )
	local res = {}
	for key, value in pairs( t ) do
		if ( value == val ) then table.insert( res, key ) end
	end
	return res
end

--- Remove all occurences of this value from this table.
-- Assumes the table is sequential unless otherwise specified.
-- @tparam table t table
-- @param val value to remove
-- @bool[opt=false] notSeq is table non-sequential
-- @treturn table table t
function table.removeByValue( t, val, notSeq )
	if (notSeq) then
		for k, v in pairs( t ) do
			if (v == val) then t[k] = nil end
		end
	else
		for i = #t, 1, -1 do
			if (t[i] == val) then
				table.remove(t, i)
			end
		end
	end
	return t
end

--- Removes values from the table based on a filter function.
-- Assumes the table is sequential unless otherwise specified.
-- @tparam table t table
-- @tparam function filter_func filter function in format *function( key, value )*. If this function returns true for a given table key->value pair, that pair is removed from the table.
-- @bool[opt=false] notSeq is table non-sequential
-- @treturn table table t
-- @usage local numbers = { "one", "two", "three" }
-- table.removeByFilter( numbers, function( k, v )
-- 	if (v == "two") return true end
-- end)
-- -- now table numbers = { "one", "three" }
function table.removeByFilter( t, filter_func, notSeq )
	if (notSeq) then
		for k, v in pairs( t ) do
			if (filter_func( k, v )) then t[k] = nil end
		end
	else
		for i = #t, 1, -1 do
			if (filter_func( i, t[i] )) then
				table.remove(t, i)
			end
		end
	end
	return t
end

--- Get a sequential table of all keys in the given table.
-- @tparam table t table
-- @treturn table table of keys in t
function table.getKeys( t )
	local keys = {}
	for k, v in pairs(t) do
		table.insert(keys, k)
	end
	return keys
end

--- Shuffle the table values around. Essentially randomizing the key->value pairs.
-- @tparam table t table
-- @treturn table table t, now shuffled
function table.shuffle( t )
	local keys = table.getKeys(t)
	for _, key in ipairs(keys) do
		local okey = keys[math.random(#keys)]
		t[okey], t[key] = t[key], t[okey]
	end
	return t
end

--- Switch the key->value pairs around. Turning them into value->key pairs.
-- @tparam table t table
-- @treturn table new inverted table
function table.invert( t )
	local rtn = {}
	for k, v in pairs(t) do rtn[v] = k end
	return rtn
end

--- Return a set of this table, removing all duplicate values.
-- @tparam table t table
-- @treturn table new set
-- @usage local numbers = { "one", "one", "two", "two", "three" }
-- local numberset = table.set( numbers )
-- -- numberset = { "one", "two", "three" }
function table.set( t )
	local rtn = {}
	for k, v in pairs(table.invert(t)) do
		rtn[#rtn + 1] = k
	end
	return rtn
end

--- Calls a function on every value in the table.
-- @tparam table t table
-- @tparam ?string|function func either a string or function in format *function( key, value, ... )*, which is called on every value in the table
-- @tparam mixed ... additional parameters to be passed to the function call
-- @treturn table table t
-- @usage local numbers = { "one", "two", "three" }
-- table.forEach( numbers, function( k, v ) numbers[k] = v.."s" end )
-- -- now table numbers = { "ones", "twos", "threes" }
-- local vectors = { Vector(1,1), Vector(2,1), Vector(3,1) }
-- table.forEach( vectors, "add", Vector(0,1) ) -- calls Vector:add(..) on every table entry
-- -- now table vectors = { Vector(1,2), Vector(2,2), Vector(3,2) }
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

--- Count number of entries in the table.
-- Can count only specific entries if specified.
-- @tparam table t table
-- @tparam[opt] function count_func function in format *function( key, value )*, only counts entries where this function returns true
-- @treturn number count
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

--- Get a random value from this table.
-- @tparam table t table
-- @return random value from the table
function table.random( t )
	local rk = math.random( 1, table.count( t ) )
	local i = 1
	for k, v in pairs(t) do 
		if ( i == rk ) then return v end
		i = i + 1 
	end
end

--- Filter a table using a given function.
-- @tparam table t table
-- @tparam function func function in format *function( key, value )*, table only retains entries where this functions returns true
-- @bool retainkeys whether to retain the keys of the original table, or create a new sequence
-- @treturn table new filtered table
function table.filter( t, func, retainkeys ) -- filter t where func(key, value) returns true
	local rtn = {}
	for k, v in pairs(t) do
		if func(k, v) then rtn[retainkeys and k or (#rtn + 1)] = v end
	end
	return rtn
end

--- Merge two tables.
-- @tparam table t1 first table
-- @tparam table t2 second table
-- @bool retainkeys whether to retain the keys of the second table (overriding those of the first table), or just to add behind the sequence of the first table
-- @treturn table table t1, with table t2 merged into it
function table.merge(t1, t2, retainkeys) -- merges t2 into t1
	for k, v in pairs(t2) do
		t1[retainkeys and k or (#t1 + 1)] = v
	end
	return t1
end

--- Returns whether table is sequential. Meaning only numerical indices are used without gaps.
-- @tparam table t table
-- @treturn bool is table sequential
function table.isSequential(t)
	local i = 1
	for key, value in pairs (t) do
		if not tonumber(i) or key ~= i then return false end
		i = i + 1
	end
	return true
end

--- Convert a table to a pretty string.
-- @tparam table t table
-- @string name name of the table to print
-- @bool nice whether to add line breaks and indents (bool)
-- @number[opt] maxdepth max depth to print table
-- @number[opt] maxseq summarizes sequential tables bigger than this number instead of printing them out completely
-- @treturn string readable string presentation of this table
function table.toString( t, name, nice, maxdepth, maxseq )
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
	if name then str = name..tab.."="..tab end
	str = str.."{".. nl..makeTable( t, nice).."}"
	return str
end