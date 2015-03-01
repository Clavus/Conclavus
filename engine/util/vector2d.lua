------------------------
-- Vector functions.
-- @util vector2d

local vector2d = {}

-- cache functions
local sqrt, cos, sin, atan2, round = math.sqrt, math.cos, math.sin, math.atan2, math.round

-- cache vector functions for quick access within this context
local normal, length, length2, angle

--- Get distance from one vector(x1, y1) to other vector(x2, y2).
-- @number x1
-- @number y1
-- @number x2
-- @number y2
-- @treturn number distance
function vector2d.distance( x1, y1, x2, y2 )
	local dx = x1 - x2
	local dy = y1 - y2
	return sqrt(dx*dx + dy*dy)
end

--- Get distance^2 from one vector(x1, y1) to other vector(x2, y2).
-- @number x1
-- @number y1
-- @number x2
-- @number y2
-- @treturn number distance squared
function vector2d.distance2( x1, y1, x2, y2 )
	local dx = x1 - x2
	local dy = y1 - y2
	return dx*dx + dy*dy
end

--- Get the length of this vector.
-- @number x
-- @number y
-- @treturn number length
function vector2d.length( x, y )
	return sqrt(x*x + y*y)
end
length = vector2d.length

--- Get the length^2 of this vector.
-- @number x
-- @number y
-- @treturn number length squared
function vector2d.length2( x, y )
	return x*x + y*y
end
length2 = vector2d.length2

--- Get the angle (in radians) of the vector.
-- @number x
-- @number y
-- @treturn number angle
function vector2d.angle( x, y )
	return atan2(y1, x1)
end
angle = vector2d.angle

--- Snap this vector to the given grid.
-- @number x
-- @number y
-- @number gx grid size x
-- @number gy grid size y
-- @treturn number x snapped x coordinate
-- @treturn number y snapped y coordinate
function vector2d.snap( x, y, gx, gy )
	local sx, sy = round(x / gx), round(y / gy)
	return sx * gx, sy * gy
end

--- Step from one vector towards another vector with the given step.
-- @number x1
-- @number y1
-- @number x2
-- @number y2
-- @number step size (distance to cover towards other vector)
-- @treturn number x new x coordinate
-- @treturn number y new y coordinate
function vector2d.approach( x1, y1, x2, y2, step )
	local dx = x2 - x1
	local dy = y2 - y1
	local l = sqrt(dx*dx + dy*dy)
	if (l < step) then
		return x1 + (dx / l * step), y1 + (dy / l * step)
	else
		return x2, y2
	end
end

--- Returns a vector perpendicular to this one.
-- @number x
-- @number y
-- @treturn number x perpendicular x coordinate
-- @treturn number y perpendicular y coordinate
function vector2d.perpendicular(x, y)
	return -y, x
end

--- Returns dot product of the two vectors.
-- @number x1
-- @number y1
-- @number x2
-- @number y2
-- @treturn number dot dot product
function vector2d.dot( x1, y1, x2, y2 )
	local ax, ay = normal(x1, y1)
	local bx, by = normal(x2, y2)
	return ax * bx + ay * by
end

--- Returns cross product of the two vectors.
-- @number x1
-- @number y1
-- @number x2
-- @number y2
-- @treturn number cross cross product
function vector2d.cross( x1, y1, x2, y2 )
	return x1 * y2 - y1 * x2
end

--- Project first vector onto the other.
-- @number x1
-- @number y1
-- @number x2
-- @number y2
-- @treturn number x projected vector x coordinate
-- @treturn number y projected vector y coordinate
function vector2d.projectOn( x1, y1, x2, y2 )
	local s = (x1 * x2 + y1 * y2) / (x2 * x2 + y2 * y2)
	return s * x2, s * y2
end

--- Mirror first vector respective to the other.
-- @number x1
-- @number y1
-- @number x2
-- @number y2
-- @treturn number x mirrored vector x coordinate
-- @treturn number y mirrored vector y coordinate
function vector2d.mirrorOn( x1, y1, x2, y2 )
	-- 2 * self:projectOn(v) - self
	local s = 2 * (x1 * x2 + y1 * y2) / (x2 * x2 + y2 * y2)
	return s * x2 - x1, s * y2 - y1
end

--- Get normalized vector.
-- @number x
-- @number y
-- @treturn number x normalized vector x coordinate
-- @treturn number y normalized vector y coordinate
function vector2d.normal( x, y )
	local l = length( x, y )
	if (l == 0) then
		return x, y
	else
		return x / l, y / l
	end
end
normal = vector2d.normal

--- Trim vector length.
-- @number x
-- @number y
-- @number maxLength trim length
-- @treturn number x trimmed vector x coordinate
-- @treturn number y trimmed vector y coordinate
function vector2d.trim( x, y, maxLength )
	local s = maxLength * maxLength / length2(x, y)
	s = (s > 1 and 1) or sqrt(s)
	return x * s, y * s
end

--- Rotate vector by the given angle.
-- @number x
-- @number y
-- @number r angle (radians) to rotate by
-- @treturn number x rotated vector x coordinate
-- @treturn number y rotated vector y coordinate
function vector2d.rotate( x, y, r )
	local l = length( x, y )
	local a = angle( x, y ) + r
	return cos(a) * l, sin(a) * l
end


return vector2d
	
