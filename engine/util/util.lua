
util = {}

function util.getPathFromFilename( file_path, sep )

	sep = sep or '/'
    return file_path:match("(.*"..sep..")")
	
end
