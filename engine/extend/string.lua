
function string.split(str, sep)

	if not sep then
		return util.array(str:gmatch("([%S]+)"))
	else
		assert(sep ~= "", "empty separator")
		local psep = sep:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
		return util.array((str..sep):gmatch("(.-)("..psep..")"))
	end
	
end

function string.trim(str, chars)

	if not chars then return str:match("^[%s]*(.-)[%s]*$") end
	chars = chars:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
	return str:match("^[" .. chars .. "]*(.-)[" .. chars .. "]*$")
	
end

-- string.simpleFormat("{b} hi {a}", {a = "mark", b = "Oh"}) -- Returns "Oh hi mark"
-- string.simpleFormat("Hello {1}!", "world") -- Returns "Hello world!"
function string.simpleFormat(str, ...)
	
	local vars = {...}
	if #vars == 0 then return str end
	if type(vars[1]) == "table" then vars = vars[1] end
	
	local f = function(x) 
		return tostring(vars[x] or vars[tonumber(x)] or "{" .. x .. "}")
	end
	return (str:gsub("{(.-)}", f))
	
end