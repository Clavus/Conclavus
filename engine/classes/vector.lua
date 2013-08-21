
Vector = class('Vector')

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

function Vector:distance( other )
	
	return (self - other):length()
	
end

function Vector:length()

	return math.sqrt(self.x*self.x+self.y*self.y)
	
end

function Vector:angle()

	return math.atan2(self.y, self.x)
	
end

function Vector:dot( other )

	local veca = self:getNormalized()
	local vecb = other:getNormalized()
	return veca.x * vecb.x + veca.y * vecb.y
	
end

function Vector:snap( gridsize )
	
	local sx, sy = math.round(self.x/gridsize.x), math.round(self.y/gridsize.y)
	self.x = sx * gridsize.x
	self.y = sy * gridsize.y
	
end

function Vector:normalize()

	return self:divideBy( self:length() )
	
end

function Vector:getNormalized()

	return self:copy():normalize()
	
end

Vector.getNormal = Vector.getNormalized

function Vector:rotate( r )
	
	local length = self:length()
	local ang = self:angle()
	
	ang = angle.rotate( ang, r )
	self.x = math.cos(ang) * length
	self.y = math.sin(ang) * length
	return self
	
end

function Vector:getRotated( r )
	
	local new = self:copy()
	new:rotate( r )
	return new
	
end

function Vector:approach( vec, step )

	self.x = math.approach(self.x, vec.x, step)
	self.y = math.approach(self.y, vec.y, step)
	
	return self
	
end

function Vector:copy()
	
	return Vector(self.x,self.y)
	
end

function Vector:multiplyBy( a )
	
	assert(type(a) == "number" or (a.class and a.class.name == "Vector"))
	if type(a) == "number" then
		self.x = self.x * a
		self.y = self.y * a
	elseif (a.class.name == "Vector") then
		self.x = self.x * (a.x or a[1])
		self.y = self.y * (a.y or a[2])
	end
	return self
	
end

function Vector:__mul( a )

	return self:copy():multiplyBy( a )
	
end

function Vector:divideBy( a )

	if (type(a) == "number") then
		self.x = self.x / a
		self.y = self.y / a	
	elseif (a.class and a.class.name == "Vector") then
		self.x = self.x / a.x
		self.y = self.y / a.y
	end

	return self
	
end

function Vector:__div( a )

	return self:copy():divideBy( a )
	
end

function Vector:add( other )

	self.x = self.x + other.x
	self.y = self.y + other.y
	return self
	
end

function Vector:__add( other )
	
	return self:copy():add( other )
	
end

function Vector:subtract( other )
	
	self.x = self.x - other.x
	self.y = self.y - other.y
	return self

end

function Vector:__sub( other )

	return self:copy():subtract( other )
	
end

function Vector:__eq( other )

	return (self.x == other.x and self.y == other.y)
	
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
