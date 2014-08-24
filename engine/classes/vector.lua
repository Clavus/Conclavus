
local Vector = class('Vector')

-- cache functions
local type, sqrt, cos, sin, atan2 = type, math.sqrt, math.cos, math.sin, math.atan2 

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

function Vector:unpack()

	return self.x, self.y

end

function Vector:copy()
	
	return Vector(self.x,self.y)
	
end

function Vector:distance( vec )
	
	return sqrt(self:distance2(vec)) -- same as: (self - vec):length()
	
end

function Vector:distance2( vec )
	
	assert(isVector( vec ), msgExpectedVec)
	
	local dx = self.x - vec.x
	local dy = self.y - vec.y
	return dx*dx + dy*dy

end

function Vector:length()

	return sqrt(self.x*self.x+self.y*self.y)
	
end

function Vector:length2()

	return self.x*self.x  + self.y*self.y
	
end

function Vector:angle()

	return atan2(self.y, self.x)
	
end

function Vector:snap( gridsize )
	
	local sx, sy = math.round(self.x/gridsize.x), math.round(self.y/gridsize.y)
	self.x = sx * gridsize.x
	self.y = sy * gridsize.y
	
end

function Vector:approach( vec, step )
	
	assert(isVector( vec ), msgExpectedVec)
	
	self.x = math.approach(self.x, vec.x, step)
	self.y = math.approach(self.y, vec.y, step)
	
	return self
	
end

function Vector:round( d )
	
	assert(isVector( vec ), msgExpectedVec)
	
	self.x = math.round( self.x, d )
	self.y = math.round( self.y, d )
	
	return self	
	
end

function Vector:perpendicular()

	return Vector( -self.y, self.x )

end

function Vector:dot( vec )

	assert(isVector( vec ), msgExpectedVec)
	
	local la =  self:length()
	local lb =  vec:length()
	
	local ax, ay = self.x / la, self.y / la
	local bx, by = vec.x / lb, vec.y / lb
	return ax * bx + ay * by
	
end

function Vector:cross( vec )

	assert(isVector( vec ), msgExpectedVec)
	
	return self.x * vec.y - self.y * vec.x
	
end

function Vector:projectOn( vec )
	
	assert(isVector( vec ), msgExpectedVec)
	local s = (self.x * vec.x + self.y * vec.y) / (vec.x * vec.x + vec.y * vec.y)
	return Vector(s * vec.x, s * vec.y)
	
end

function Vector:mirrorOn( vec )
	
	assert(isVector( vec ), msgExpectedVec)
	-- 2 * self:projectOn(v) - self
	local s = 2 * (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return new(s * v.x - self.x, s * v.y - self.y)
	
end

function Vector:normalize()
	
	if (self:length() == 0) then
		return self
	else
		return self:divideBy( self:length() )
	end
	
end

function Vector:getNormalized()

	return self:copy():normalize()
	
end

Vector.getNormal = Vector.getNormalized

function Vector:trim( maxLength )
	
	local s = maxLength * maxLength / self:length2()
	s = (s > 1 and 1) or sqrt(s)
	self.x = self.x * s
	self.y = self.y * s
	return self
	
end

function Vector:getTrimmed( maxLength )
	
	return self:copy():trim( maxLength )
	
end

function Vector:rotate( r )
	
	local length = self:length()
	local ang = self:angle()
	
	ang = angle.rotate( ang, r )
	self.x = cos(ang) * length
	self.y = sin(ang) * length
	return self
	
end

function Vector:getRotated( r )
	
	local new = self:copy()
	new:rotate( r )
	return new
	
end

function Vector:multiplyBy( a )
	
	assert(type(a) == "number" or isVector(a), msgExpectedVec)
	
	if type(a) == "number" then
		self.x = self.x * a
		self.y = self.y * a
	else
		self.x = self.x * (a.x or a[1])
		self.y = self.y * (a.y or a[2])
	end
	return self
	
end

function Vector:__mul( a )

	return self:copy():multiplyBy( a )
	
end

function Vector:divideBy( a )

	assert(type(a) == "number" or isVector(a), msgExpectedVec)
	
	if (type(a) == "number") then
		self.x = self.x / a
		self.y = self.y / a	
	else
		self.x = self.x / a.x
		self.y = self.y / a.y
	end

	return self
	
end

function Vector:__div( a )

	return self:copy():divideBy( a )
	
end

function Vector:add( vec )

	assert(isVector( vec ), msgExpectedVec)
	
	self.x = self.x + vec.x
	self.y = self.y + vec.y
	return self
	
end

function Vector:__add( vec )
	
	return self:copy():add( vec )
	
end

function Vector:subtract( vec )
	
	assert(isVector( vec ), msgExpectedVec)
		
	self.x = self.x - vec.x
	self.y = self.y - vec.y
	return self

end

function Vector:__sub( vec )

	return self:copy():subtract( vec )
	
end

function Vector:__eq( vec )
	
	assert(isVector( vec ), msgExpectedVec)
	return (self.x == vec.x and self.y == vec.y)
	
end

function Vector:__unm()

	return self:copy() * -1

end

function Vector:__concat( a )
	
	return tostring(self)..tostring(a)
	
end

function Vector:__tostring()

	return "Vector( "..tostring(self.x).." , "..tostring(self.y).." )"
	
end

return Vector
