
local util = {}

function util.getPathFromFilename( file_path, sep )

	sep = sep or '/'
    return file_path:match("(.*"..sep..")")
	
end

function util.round( value, decimals )

    local mul = 10^(decimals or 0)
    return math.floor(value * mul + 0.5) / mul
	
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

return util