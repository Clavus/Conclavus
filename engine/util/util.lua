
util = {}

function util.getPathFromFilename( file_path, sep )

	sep = sep or '/'
    return file_path:match("(.*"..sep..")")
	
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