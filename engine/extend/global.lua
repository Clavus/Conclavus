
-- http://love2d.org/forums/viewtopic.php?p=166821#p166821
function chars(text)
	local i=0
	local n = #text
	return function()
		i=i+1
		if i <= n then return i, string.sub(text,i,i) end
	end
end

function split(text,delim)
	local i=0
	local words = string.split(text,delim)
	return function()
		i = i + 1
		if i <= #words then return i, words[i] end
	end
end

function words(text)
	return split(text,' ')
end