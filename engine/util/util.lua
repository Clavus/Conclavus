------------------------
-- General utility functions.
-- @util util

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

function util.toggle( x )	
	return 1 - math_abs(1 - x % 2)
end

function util.lua( str ) -- executes the string
	return assert((loadstring or load)(str))()	
end

local memoize_fnkey = {}
local memoize_nil = {}

function util.memoize( fn )
	local cache = {}
	return function(...)
		local c = cache
		for i = 1, select("#", ...) do
			local a = select(i, ...) or memoize_nil
			c[a] = c[a] or {}
			c = c[a]
		end
		c[memoize_fnkey] = c[memoize_fnkey] or {fn(...)}
		return unpack(c[memoize_fnkey])
	end
end

function util.readParticleSystem( name )
	local ps_data = require(name)
	local particle_settings = {}
	particle_settings["colors"] = {}
	particle_settings["sizes"] = {}
	for k, v in pairs(ps_data) do
		if k == "colors" then
			local j = 1
			for i = 1, #v , 4 do
				local color = {v[i], v[i+1], v[i+2], v[i+3]}
				particle_settings["colors"][j] = color
				j = j + 1
			end
		elseif k == "sizes" then
			for i = 1, #v do particle_settings["sizes"][i] = v[i] end
		else particle_settings[k] = v end
	end
	local ps = love.graphics.newParticleSystem(resource.getImage(FOLDER.PARTICLESYSTEMS..particle_settings["image"]), particle_settings["buffer_size"])
	ps:setAreaSpread(string.lower(particle_settings["area_spread_distribution"]), particle_settings["area_spread_dx"] or 0 , particle_settings["area_spread_dy"] or 0)
	ps:setBufferSize(particle_settings["buffer_size"] or 1)
	local colors = {}
	for i = 1, 8 do 
		if particle_settings["colors"][i][1] ~= 0 or particle_settings["colors"][i][2] ~= 0 or particle_settings["colors"][i][3] ~= 0 or particle_settings["colors"][i][4] ~= 0 then
			table.insert(colors, particle_settings["colors"][i][1] or 0)
			table.insert(colors, particle_settings["colors"][i][2] or 0)
			table.insert(colors, particle_settings["colors"][i][3] or 0)
			table.insert(colors, particle_settings["colors"][i][4] or 0)
		end
	end
	ps:setColors(unpack(colors))
	ps:setColors(unpack(colors))
	ps:setDirection(math.rad(particle_settings["direction"] or 0))
	ps:setEmissionRate(particle_settings["emission_rate"] or 0)
	ps:setEmitterLifetime(particle_settings["emitter_lifetime"] or 0)
	ps:setInsertMode(string.lower(particle_settings["insert_mode"]))
	ps:setLinearAcceleration(particle_settings["linear_acceleration_xmin"] or 0, particle_settings["linear_acceleration_ymin"] or 0, 
													 particle_settings["linear_acceleration_xmax"] or 0, particle_settings["linear_acceleration_ymax"] or 0)
	if particle_settings["offsetx"] ~= 0 or particle_settings["offsety"] ~= 0 then
			ps:setOffset(particle_settings["offsetx"], particle_settings["offsety"])
	end
	ps:setParticleLifetime(particle_settings["plifetime_min"] or 0, particle_settings["plifetime_max"] or 0)
	ps:setRadialAcceleration(particle_settings["radialacc_min"] or 0, particle_settings["radialacc_max"] or 0)
	ps:setRotation(math.rad(particle_settings["rotation_min"] or 0), math.rad(particle_settings["rotation_max"] or 0))
	ps:setSizeVariation(particle_settings["size_variation"] or 0)
	local sizes = {}
	local sizes_i = 1 
	for i = 1, 8 do 
		if particle_settings["sizes"][i] == 0 then
			if i < 8 and particle_settings["sizes"][i+1] == 0 then
				sizes_i = i
				break
			end
		end
	end
	if sizes_i > 1 then
		for i = 1, sizes_i do table.insert(sizes, particle_settings["sizes"][i] or 0) end
		ps:setSizes(unpack(sizes))
	end
	ps:setSpeed(particle_settings["speed_min"] or 0, particle_settings["speed_max"] or 0)
	ps:setSpin(math.rad(particle_settings["spin_min"] or 0), math.rad(particle_settings["spin_max"] or 0))
	ps:setSpinVariation(particle_settings["spin_variation"] or 0)
	ps:setSpread(math.rad(particle_settings["spread"] or 0))
	ps:setTangentialAcceleration(particle_settings["tangential_acceleration_min"] or 0, particle_settings["tangential_acceleration_max"] or 0)
	return ps
end

function util.openSaveDirectory()
	love.system.openURL("file://"..love.filesystem.getSaveDirectory())
end

return util