------------------------
-- Extensions to the [string module](http://www.lua.org/manual/5.1/manual.html#5.4). 
-- Credit to rxi's [lume](https://github.com/rxi/lume/) lib for some of these functions.
-- @extend string

--- Split a string using a given seperator.
-- If seperator is not provided, it will split the string into seperate words.
-- Consecutive delimiters are not grouped together and will delimit empty strings.
-- @string str input string
-- @string sep seperator
-- @treturn table table of strings
-- @usage string.split("One two three") -- Returns {"One", "two", "three"}
--string.split("a,b,,c", ",") -- Returns {"a", "b", "", "c"}
function string.split(str, sep)
	if not sep then
		return util.array(str:gmatch("([%S]+)"))
	else
		assert(sep ~= "", "empty separator")
		local psep = sep:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
		return util.array((str..sep):gmatch("(.-)("..psep..")"))
	end
end

--- Trims the whitespace from the start and end of the string.
-- If specific string is provided, the characters in that string are trimmed from the string instead of whitespace.
-- @string str input string
-- @string[opt] chars string containing characters to be trimmed
-- @treturn string trimmed string
function string.trim(str, chars)
	if not chars then return str:match("^[%s]*(.-)[%s]*$") end
	chars = chars:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
	return str:match("^[" .. chars .. "]*(.-)[" .. chars .. "]*$")
end

--- Returns a formatted string.
-- Alternative to Lua's string.format. The values of the keys in the provided table can be inserted into the string
-- using the form '{key}' in the input string. Numerical keys can also be used.
-- @string str input string
-- @tparam ?table|string ... elements to format into the input string
-- @usage string.simpleFormat("{b} hi {a}", {a = "mark", b = "Oh"}) -- Returns "Oh hi mark"
--string.simpleFormat("Hello {1}!", "world") -- Returns "Hello world!"
function string.simpleFormat(str, ...)
	local vars = {...}
	if #vars == 0 then return str end
	if type(vars[1]) == "table" then vars = vars[1] end
	local f = function(x) 
		return tostring(vars[x] or vars[tonumber(x)] or "{" .. x .. "}")
	end
	return (str:gsub("{(.-)}", f))
end

--- Append or prepend characters to fill up a string to a specified length.
-- @string str input string
-- @number size desired length of resulting string
-- @string pos either "before" or "after"
-- @string[opt="0"] ch character to append or prepend
-- @treturn string resulting string
-- @usage string.fill("12", 5, "before", "0") -- Returns "00012"
--string.fill("BLAM", 10, "after", "O") -- Returns "BLAMOOOOOO"
function string.fill(str, size, pos, ch)
	local n = tostring(str)
	ch = ch or "0"
	pos = pos or "before"
	if string.len(n) >= size then
		return n
	else
		if pos == "before" then
			while string.len(n) < size do
				n = ch .. n
			end
		elseif pos == "after" then
			while string.len(n) < size do
				n = n .. ch
			end
		end
	end
	return n
end
