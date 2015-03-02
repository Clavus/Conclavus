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

--- Rotates angle by given radians, normalizes angle after (between -pi and pi).
-- @number r1 angle (radians)
-- @number r2 angle (radians) to rotate by
-- @treturn number new angle (radians)
function angle.rotate( r1, r2 )
	return angle.normalize( r1 + r2 )
end

--- Rotates angle towards another angle by the given step.
-- @number r1 angle (radians)
-- @number r2 angle (radians) to rotate towards
-- @number rstep angle (radians) to step from r1 to r2.
-- @treturn number new angle (radians)
function angle.rotateTo( r1, r2, rstep )
	local nr =  angle.normalize( r2 - r1 )
	if (nr < 0) then
		return r1 - min(rstep, -nr)
	else
		return r1 + min(rstep, nr)
	end
end

--- Lerps from one angle to another by the given fraction.
-- @number r1 angle (radians)
-- @number r2 angle (radians) to rotate towards
-- @number frac fraction (between 0 and 1) to go from r1 to r2.
-- @treturn number new angle (radians)
function angle.lerp( r1, r2, frac )
	local nr =  angle.normalize( r2 - r1 )
	frac = math.clamp(frac, 0, 1)
	if (nr < 0) then
		return r1 - nr * frac
	else
		return r1 + nr * frac
	end
end

return angle