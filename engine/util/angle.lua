------------------------
-- Angle functions
-- @util angle

local angle = {}

local normalizeAngle = math.normalizeAngle

--- Get forward vector of the given angle.
-- @number r angle (radians)
-- @treturn Vector forward vector
function angle.forward( r )
	return Vector( math.cos(r), math.sin(r) )
end

--- Rotates angle by given radians, normalizes angle after (crops between 0 and 2*pi).
-- @number r angle
-- @number rot radians to rotate by
-- @treturn Vector forward vector
function angle.rotate( r, rot )
	return normalizeAngle(r + rot)
end

return angle