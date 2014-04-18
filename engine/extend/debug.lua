
local clock = os.clock

function debug.printLoadedPackages()
	
	print(table.toString( package.loaded, "package.loaded", true, 1 ))

end

function debug.time( func, ... )

	local start = clock()
	local rtn = { fn(...) }
	return (clock() - start), unpack(rtn)
	
end

local benchmarks = {}

function debug.benchmarkStart( name )
	
	assert(benchmarks[name] == nil, "Benchmark '"..name.."' has already started!")
	benchmarks[name] = clock()
	
end

-- message can use tokens {name} and {time} to print name and time
function debug.benchmarkStop( name, message, condition_func )
	
	message = message or "Benchmark '{name}' time: {time}"
	assert(benchmarks[name] ~= nil, "Benchmark '"..name.."' is not active")
	
	local diff = clock() - benchmarks[name]
	
	if (condition_func == nil or condition_func(diff) == true) then
		print(string.simpleFormat(message, { name = name, time = diff }))
	end
	
	benchmarks[name] = nil
	
end
