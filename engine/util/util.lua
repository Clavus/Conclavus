
local util = {}

function util.getPathFromFilename( file_path, sep )

	sep = sep or '/'
    return file_path:match("(.*"..sep..")")
	
end

function util.choose( ... )
	
	local arg = {...}
	return arg[math.random(1,#arg)]
	
end

function util.weightedChoice( ... ) -- in format util.weightedChoice("duck", 20, "cat", 10). "duck" is twice as likely to be chosen

	local sum = 0
	local t = {...}
	local choices = {}
	local lastadded
	
	for k, v in pairs(t) do
		if (k % 2 == 1) then
			lastadded = { choice = v, weight = 0 }
			table.insert(choices, lastadded)
		else
			assert(type(v) == "number", "Weights need to be numbers")
			assert(v >= 0, "Weight values have to be larger than 0")
			lastadded.weight = v
			sum = sum + v
		end
	end
	
	if sum == 0 then return end
	
	local rnd = sum * math.random()
	for k, v in pairs(choices) do
		if rnd < v.weight then return v.choice end
		rnd = rnd - v.weight
	end
	
end

function util.array(...)

	local t = {}
	for x in unpack({...}) do t[#t + 1] = x end
	return t
	
end

function util.equalsAll(value, ...)

    for _, v in ipairs({...}) do
        if value ~= v then return false end
    end
	
    return true
	
end

function util.equalsAny(value, ...)

    for _, v in ipairs({...}) do
        if value == v then return true end
    end
	
    return false
	
end

function util.lua( str ) -- executes the string

	return assert((loadstring or load)(str))()
	
end

return util