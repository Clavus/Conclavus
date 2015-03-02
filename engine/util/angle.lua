------------------------
-- Angle functions.
-- @util angle

local angle = {}

-- local cache
local cos, sin, pi, min, clamp = math.cos, math.sin, math.pi, math.min, math.clamp
local Vector = Vector

--- Get forward vector of the given angle.
-- @number r angle (radians)
-- @treturn Vector forward vector
function angle.forward( r )
	return Vector( cos(r), sin(r) )
end

--- Normalizes the angle to between -pi and pi radians (-180 to 180 degrees).
-- @number r angle (radians)
-- @treturn number new angle (radians)
function angle.normalize( r )
	while (r <= -pi) do
		r = r + pi*2
	end
	while (r > pi) do
		r = r - pi*2
	end
	return r
end
local normalize = angle.normalize

--- Rotates angle by given radians, normalizes angle after (between -pi and pi).
-- @number r1 angle (radians)
-- @number r2 angle (radians) to rotate by
-- @treturn number new angle (radians)
function angle.rotate( r1, r2 )
	return normalize( r1 + r2 )
end

--- Rotates angle towards another angle with a given increment.
-- @number r1 angle (radians)
-- @number r2 angle (radians) to rotate towards
-- @number incr angle (radians) to increment from r1 to r2.
-- @treturn number new angle (radians)
function angle.rotateTo( r1, r2, incr )
	local nr =  normalize( r2 - r1 )
	if (nr < 0) then
		return r1 - min(incr, -nr)
	else
		return r1 + min(incr, nr)
	end
end

--- Lerps from one angle to another by the given fraction.
-- @number r1 angle (radians)
-- @number r2 angle (radians) to rotate towards
-- @number frac fraction (between 0 and 1) to go from r1 to r2.
-- @treturn number new angle (radians)
function angle.lerp( r1, r2, frac )
	local nr = normalize( r2 - r1 )
	if (nr < 0) then
		return r1 - nr * clamp(frac, 0, 1)
	else
		return r1 + nr * clamp(frac, 0, 1)
	end
end

return angle