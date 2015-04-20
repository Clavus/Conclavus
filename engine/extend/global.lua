------------------------
-- Additional global functions.
-- @other global

--- Print text only to debug only if key is being held down.
-- Useful for debugging parts of code that run every frame without drowning the console window.
-- @string str the string to print
-- @string key the key to press
function keyprint( str, key )
	-- only print if the key is held down. Useful for stopping printing output
	if not input:keyIsDown(key) then return end
	print( str )
end

--- Iterator for characters in a string. Credits to [Ranguna259](http://love2d.org/forums/viewtopic.php?p=166821#p166821).
-- @string text the string to split
-- @treturn number index
-- @treturn string character
-- @usage for k, c in chars('hello') do 
-- 	print(k..': '..p) 
-- end -- prints "1: h", "2: e", "3: l", "4: l", "5: 0" respectively.
function chars(text)
	local i=0
	local n = #text
	return function()
		i=i+1
		if i <= n then return i, string.sub(text,i,i) end
	end
end

--- Iterator for splitting a string using a specified delimiter.
-- @string text the string to split
-- @string delim delimiter
-- @treturn number index
-- @treturn string part of string
-- @usage for k, s in split('january-30-2015', '-') do 
-- 	print(s) 
-- end -- prints "january", then "30", then "2015"
function split(text,delim)
	local i=0
	local words = string.split(text,delim)
	return function()
		i = i + 1
		if i <= #words then return i, words[i] end
	end
end

--- Iterator for splitting a line of text into words. Same as using @{split} with a space as delimiter.
-- @string text the string to split
-- @treturn number index
-- @treturn string a word in the string
-- @usage for k, w in words('I love cats') do 
-- 	print(w) 
-- end -- prints "I", then "love", then "cats"
function words(text)
	return split(text,' ')
end

--- Get the global input controller.
-- @treturn InputController global input controller
-- @see InputController
function getInput()
	return _inputController()
end

local delays = {}
local cur = currentTime
--- Triggers only once every given interval
-- @string id delay trigger id
-- @number interval delay in seconds
-- @bool[opt] override whether to force triggering this delay
-- @treturn bool trigger state
-- @usage if (input:mouseIsDown("l") and delay("fire", 0.4)) then
--   fireBullet() -- fire every 0.4 seconds when holding down left mouse
-- end
function delay( id, interval, override )
	if (delays[id] == nil or override) then
		delays[id] = cur()
		return true
	else
		if (delays[id] + interval <= cur()) then
			delays[id] = cur()
			return true
		else
			return false
		end
	end
end

