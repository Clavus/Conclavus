-- Large parts of this code are from Garry's Mod Lua codebase, I'm sure Garry won't mind.

-- Originally from: http://lua-users.org/wiki/PitLibTablestuff
function table.copy(t, lookup_table)

	if (t == nil) then return nil end
	
	local copy = {}
	setmetatable(copy, getmetatable(t))
	for i,v in pairs(t) do
		if ( type(v) ~= "table" ) then
			copy[i] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[t] = copy
			if lookup_table[v] then
				copy[i] = lookup_table[v]
			else
				copy[i] = table.copy(v,lookup_table)
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
	
end

function table.removeByValue( tbl, val )

	local key = table.keyFromValue( tbl, val )
	if ( key == nil ) then return false end
	
	table.remove( tbl, key )
	return key
	
end

--[[---------------------------------------------------------
   Name: table.forEach( table, function )
   Desc: Executes the function on every key -> value pair
		 in this table
-----------------------------------------------------------]]
function table.forEach( tab, func )

	for k, v in pairs( tab ) do
		func( k, v )
	end

end

--[[---------------------------------------------------------
   Name: table.count( table )
   Desc: Returns the number of keys in a table
		 works in cases where #table fails.
-----------------------------------------------------------]]
function table.count(t)

	local i = 0
	for k in pairs(t) do i = i + 1 end
	return i
	
end

--[[---------------------------------------------------------
   Name: table.random( table )
   Desc: Return a random value
-----------------------------------------------------------]]
function table.random (t)
  
	local rk = math.random( 1, table.count( t ) )
	local i = 1
	for k, v in pairs(t) do 
		if ( i == rk ) then return v end
		i = i + 1 
	end

end

--[[----------------------------------------------------------------------
   Name: table.isSequential( table )
   Desc: Returns true if the tables 
	 keys are sequential
-------------------------------------------------------------------------]]
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
		maxseq = if defined as a number, summarizes 
		         sequential tables bigger than this number
				 instead of printing them out completely
-----------------------------------------------------------]]
function table.toString( t, n, nice, maxseq )

	local nl,tab  = "",  ""
	if nice then nl,tab = "\n", "\t" end

	local function makeTable ( t, nice, indent, done)
		local str = ""
		local done = done or {}
		local indent = indent or 0
		local idt = ""
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
					str = str..key..tab..'{'..nl..makeTable(value, nice, indent + 1, done)
					str = str..idt..tab..tab..tab..tab.."},"..nl
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