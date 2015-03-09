------------------------
-- Extensions to the [debug module](http://www.lua.org/manual/5.1/manual.html#5.9).
-- @extend debug

local clock = os.clock
local lg = love.graphics

--- Prints loaded modules to console.
function debug.printLoadedPackages()
	print(table.toString( package.loaded, "package.loaded", true, 1 ))
end

--- Executes a function and records the time it takes.
-- @tparam function func function to execute
-- @tparam mixed ... function parameters
-- @treturn number execution time (seconds)
-- @treturn ... function return result
function debug.time( func, ... )
	local start = clock()
	local rtn = { func(...) }
	return (clock() - start), unpack(rtn)
end

local benchmarks = {}

--- Starts a benchmark.
-- @string name benchmark identifier
function debug.benchmarkStart( name )
	assert(benchmarks[name] == nil, "Benchmark '"..name.."' has already started!")
	benchmarks[name] = clock()
end

--- Stops a benchmark and prints the execution time.
-- Mssage can use 
-- @string name benchmark identifier
-- @string[opt] message message to print. Use tokens {name} and {time} to print name and time.
-- @tparam[opt] function condition_func condition function, signature *function(benchmarktime)*. Only print message if it returns true. Useful for only printing messages if execution time exceeds a value.
function debug.benchmarkStop( name, message, condition_func )
	message = message or "Benchmark '{name}' time: {time}"
	assert(benchmarks[name] ~= nil, "Benchmark '"..name.."' is not active")
	local diff = clock() - benchmarks[name]
	if (condition_func == nil or condition_func(diff) == true) then
		print(string.simpleFormat(message, { name = name, time = diff }))
	end
	benchmarks[name] = nil
end

--- Draw the physics world.
-- Including bodies, fixtures, joints and contacts.
-- @tparam World world [physics world](https://www.love2d.org/wiki/World)
function debug.drawPhysicsWorld( world )
	collectgarbage()
	collectgarbage()
	local bodies = world:getBodyList()
	for b=#bodies,1,-1 do
		local body = bodies[b]
		local bx,by = body:getPosition()
		local bodyAngle = body:getAngle()
		lg.push()
		lg.translate(bx,by)
		lg.rotate(bodyAngle)
		math.randomseed(1) --for color generation

		local fixtures = body:getFixtureList()
		for i=1,#fixtures do
			local fixture = fixtures[i]
			local shape = fixture:getShape()
			local shapeType = shape:getType()
			local isSensor = fixture:isSensor()

			if (isSensor) then
				lg.setColor(0,0,255,96)
			else
				lg.setColor(math.random(32,200),math.random(32,200),math.random(32,200),96)
			end

			lg.setLineWidth(1)
			if (shapeType == "circle") then
				local x,y = fixture:getMassData() --0.9.0 missing circleshape:getPoint()
				--local x,y = shape:getPoint() --0.9.1
				local radius = shape:getRadius()
				lg.circle("fill",x,y,radius,15)
				lg.setColor(0,0,0,255)
				lg.circle("line",x,y,radius,15)
				local eyeRadius = radius/4
				lg.setColor(0,0,0,255)
				lg.circle("fill",x+radius-eyeRadius,y,eyeRadius,10)
			elseif (shapeType == "polygon") then
				local points = {shape:getPoints()}
				lg.polygon("fill",points)
				lg.setColor(0,0,0,255)
				lg.polygon("line",points)
			elseif (shapeType == "edge") then
				lg.setColor(0,0,0,255)
				lg.line(shape:getPoints())
			elseif (shapeType == "chain") then
				lg.setColor(0,0,0,255)
				lg.line(shape:getPoints())
			end
		end
		lg.pop()
	end

	local joints = world:getJointList()
	for index,joint in pairs(joints) do
		lg.setColor(0,255,0,255)
		local x1,y1,x2,y2 = joint:getAnchors()
		if (x1 and x2) then
			lg.setLineWidth(3)
			lg.line(x1,y1,x2,y2)
		else
			lg.setPointSize(3)
			if (x1) then
				lg.point(x1,y1)
			end
			if (x2) then
				lg.point(x2,y2)
			end
		end
	end

	local contacts = world:getContactList()
	for i=1,#contacts do
		lg.setColor(255,0,0,255)
		lg.setPointSize(3)
		local x1,y1,x2,y2 = contacts[i]:getPositions()
		if (x1) then
			lg.point(x1,y1)
		end
		if (x2) then
			lg.point(x2,y2)
		end
	end
end