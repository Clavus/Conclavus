------------------------
-- 2D vector class.
-- More managable than the @{vector2d} utility library in some cases.
-- @cl vector
-- @usage local vec1 = Vector(1, 3)
-- local vec2 = Vector({ 1, 3 })
-- local vec3 = Vector({ x = 1, y = 3 })
-- -- All of these create the same vector with x = 1 and y = 3.
-- -- Advantage over util library: easy to chain and use operators with!
-- local newVec = Vector(1,2):rotateBy( math.pi ):snap( 0.5, 0.5 ) + Vector( 1, 1 )
-- -- Also supports unary operations, equality checks, and string concatenation
-- local minVec = -Vector(1,1)
-- local isTrue = Vector(1,1) == Vector(1,1)
-- local isFalse = Vector(1,1) == Vector(1,2)
-- local str = "Zero vector: "..Vector(0,0)

--- @type Vector
local Vector = class('Vector')

-- cache functions
local type, tostring, sqrt, atan2, round = type, tostring, math.sqrt, math.atan2, math.round
local distance, distance2, length, length2, angle, snap =  vector2d.distance, vector2d.distance2, vector2d.length, vector2d.length2, vector2d.angle, vector2d.snap
local approach, perpendicular, dot, cross, projectOn, mirrorOn = vector2d.approach, vector2d.perpendicular, vector2d.dot, vector2d.cross, vector2d.projectOn, vector2d.mirrorOn
local normal, trim, rotate = vector2d.normal, vector2d.trim, vector2d.rotate

function Vector:initialize( value, value2 )
	self.x = 0
	self.y = 0
	if (type(value) == "number" and type(value2) == "number") then
		self.x = value
		self.y = value2
	elseif (type(value) == "table") then
		self.x = value.x or value[1]
		self.y = value.y or value[2]
	end
end

local function isVector( v )
	return v.class ~= nil and v:isInstanceOf( Vector )
end

local msgExpectedVec = "Wrong argument type, expected Vector"

--- Unpacks vector, returns x and y.
-- @treturn number x
-- @treturn number y
function Vector:unpack()
	return self.x, self.y
end

--- Copies this vector.
-- @treturn Vector vector
function Vector:copy()
	return Vector(self.x,self.y)
end

--- Get distance to other vector.
-- @tparam Vector vec other vector
-- @treturn number distance
-- @see vector2d.distance
function Vector:distance( vec )
	return distance( self.x, self.y, vec.x, vec.y )
end

--- Get distance^2 to other vector.
-- @tparam Vector vec other vector
-- @treturn number distance squared
-- @see vector2d.distance2
function Vector:distance2( vec )
	return distance2( self.x, self.y, vec.x, vec.y )
end

--- Get the length of this vector.
-- @treturn number length
-- @see vector2d.length
function Vector:length()
	return sqrt( self.x * self.x + self.y * self.y )
end

--- Get the length^2 of this vector.
-- @treturn number length squared
-- @see vector2d.length2
function Vector:length2()
	return self.x*self.x + self.y*self.y
end

--- Get the angle (in radians) of the vector.
-- @treturn number angle
-- @see vector2d.angle
function Vector:angle()
	return atan2(self.y, self.x)
end

--- Snap this vector to the given grid.
-- @number gx grid size x
-- @number gy grid size y
-- @treturn Vector self
-- @see vector2d.snap
function Vector:snap( gx, gy )
	self.x, self.y = snap( self.x, self.y, gx, gy )
	return self
end

--- Approach another vector at the given step.
-- @tparam Vector vector other vector
-- @number step step size (distance to cover towards other vector)
-- @treturn Vector self
-- @see vector2d.approach
function Vector:approach( vec, step )
	self.x, self.y = approach( self.x, self.y, vec.x, vec.y, step )
	return self
end

--- Rounds this vector off.
-- @number[opt=0] decimals number of decimals to round to
-- @treturn Vector self
function Vector:round( d )
	self.x = round( self.x, d )
	self.y = round( self.y, d )
	return self	
end

--- Gets perpendicular vector respective to this vector.
-- @treturn Vector vector new perpendicular vector
-- @see vector2d.perpendicular
function Vector:perpendicular()
	return Vector( -self.y, self.x )
end

--- Get dot product of this vector with the other vector.
-- @tparam Vector vector other vector
-- @see vector2d.dot
function Vector:dot( vec )
	return dot(self.x, self.y, vec.x, vec.y)
end

--- Get cross product of this vector with the other vector.
-- @tparam Vector vector other vector
-- @see vector2d.cross
function Vector:cross( vec )
	return self.x * vec.y - self.y * vec.x
end

--- Project this vector onto the other.
-- @tparam Vector vector other vector
-- @treturn Vector projected vector
-- @see vector2d.projectOn
function Vector:projectOn( vec )
	return Vector(projectOn(self.x, self.y, vec.x, vec.y))
end

--- Mirror this vector respective to the other.
-- @tparam Vector vector other vector
-- @treturn Vector mirrored vector
-- @see vector2d.mirrorOn
function Vector:mirrorOn( vec )
	return Vector(mirrorOn( self.x, self.y, vec.x, vec.y ))
end

--- Normalize this vector.
-- @treturn Vector self
-- @see vector2d.normal
function Vector:normalize()
	self.x, self.y = normal( self.x, self.y )
	return self
end

--- Get normal vector of this vector.
-- @treturn Vector normalized vector
-- @see vector2d.normal
function Vector:getNormal()
	return Vector(normal( self.x, self.y ))
end

--- Trim this vector to the given length.
-- @number maxLength trim length
-- @treturn Vector self
-- @see vector2d.trim
function Vector:trim( maxLength )
	self.x, self.y = trim( self.x, self.y, maxLength )
	return self
end

--- Get trimmed vector of this vector.
-- @number maxLength trim length
-- @treturn Vector trimmed vector
-- @see vector2d.trim
function Vector:getTrimmed( maxLength )
	return Vector(trim( self.x, self.y, maxLength ))
end

--- Rotate vector by the given angle.
-- @number r angle (radians) to rotate by
-- @treturn Vector self
-- @see vector2d.rotate
function Vector:rotate( r )
	self.x, self.y = rotate( self.x, self.y, r )
	return self
end

--- Get rotated vector of this vector.
-- @number r angle (radians) to rotate by
-- @treturn Vector rotated vector
-- @see vector2d.rotate
function Vector:getRotated( r )
	return Vector(rotate( self.x, self.y, r ))
end

--- Multiply this vector by a scalar or other vector. Used by the * operator.
-- @tparam ?number|Vector|table s scalar or vector or table in format { [x], [y] } or { x = [x], y = [y] }
-- @treturn Vector self
-- @usage local mulVec = Vector(1,3) * Vector(2,1) * 3 
-- -- mulVec is Vector(6, 9)
function Vector:multiplyBy( s )
	if type(s) == "number" then
		self.x = self.x * s
		self.y = self.y * s
	else
		self.x = self.x * (s.x or s[1])
		self.y = self.y * (s.y or s[2])
	end
	return self
end

function Vector:__mul( s )
	return self:copy():multiplyBy( s )
end

--- Divide this vector by a scalar or other vector. Used by the / operator.
-- @tparam ?number|Vector|table s scalar or vector or table in format { [x], [y] } or { x = [x], y = [y] }
-- @treturn Vector self
-- @usage local divVec = Vector(6,9) / Vector(2,1) / 3 
-- -- divVec is Vector(1, 3)
function Vector:divideBy( s )
	if (type(s) == "number") then
		self.x = self.x / s
		self.y = self.y / s	
	else
		self.x = self.x / (s.x or s[1])
		self.y = self.y / (s.x or s[1])
	end
	return self
end

function Vector:__div( s )
	return self:copy():divideBy( s )
end

--- Add this vector to another vector. Used by the + operator.
-- @tparam ?Vector|table v vector or table in format { [x], [y] } or { x = [x], y = [y] }
-- @treturn Vector self
-- @usage local addVec = Vector(12, 1) + Vector(3, 2) 
-- -- addVec is Vector(15, 3)
function Vector:add( v )
	self.x = self.x + (v.x or v[1])
	self.y = self.y + (v.y or v[2])
	return self
end

function Vector:__add( v )
	return self:copy():add( v )
end

--- Subtract another vector from this vector. Used by the - operator.
-- @tparam ?Vector|table v vector or table in format { [x], [y] } or { x = [x], y = [y] }
-- @treturn Vector self
-- @usage local subVec = Vector(15, 3) - Vector(3, 2) 
-- -- subVec is Vector(12, 1)
function Vector:subtract( v )
	self.x = self.x - (v.x or v[1])
	self.y = self.y - (v.y or v[2])
	return self
end

function Vector:__sub( v )
	return self:copy():subtract( v )
end

function Vector:__eq( vec )
	assert(isVector( vec ), msgExpectedVec)
	return (self.x == vec.x and self.y == vec.y)
end

function Vector:__unm()
	return self:copy() * -1
end

function Vector:__concat( v )
	return tostring(self)..tostring(v)
end

function Vector:__tostring()
	return "Vector( "..tostring(self.x).." , "..tostring(self.y).." )"
end

return Vector
