------------------------
-- Extensions to the string module.
-- @extend string

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

-- http://love2d.org/forums/viewtopic.php?f=4&t=77599
-- Example: string.fill(12, 5, "before", "0") returns "00012".
function string.fill(str, sz, pos, ch)
	local n = tostring(str)
	local ch = ch or "0"
	local pos = pos or "start"
	if string.len(n) >= sz then
		return n
	else
		if pos == "before" then
			while string.len(n) < sz do
				n = ch .. n
			end
		elseif pos == "after" then
			while string.len(n) < sz do
				n = n .. ch
			end
		end
	end
	return n
end