------------------------
-- Rotatable [mixin](https://github.com/kikito/middleclass/wiki/Mixins). 
-- Apply to classes that have a rotation.
-- @mixin rotational
-- @usage local MyClass = class("MyClass")
-- MyClass:include( Rotational )

local Rotatable = {}

function Rotatable:initialize()
	self._angle = 0
end

--- Set the object's angle.
-- @number r angle (radians)
-- @treturn Rotatable self
function Rotatable:setAngle( r )
	self._angle = r
	return self
end

--- Gets the object's angle.
-- @treturn number r angle
function Rotatable:getAngle()
	return self._angle
end

--- Rotate this object relatively to its current angle.
-- @number r angle (radians)
-- @treturn Rotatable self
function Rotatable:rotate( r )
	self._angle = self._angle + r
	return self
end

--- Move this object forward (according to its current angle) by a given distance.
-- Requires you to have a class:move( x, y ) function. For example, by including the Positional mixin.
-- @number d distance
-- @treturn Rotatable self
-- @see positional
function Rotatable:moveForward( d )
	assert(self.move ~= nil, "Function requires :move(x,y) function")
	local dx, dy = angle.forward( self._angle ):multiplyBy( d ):unpack()
	self:move( dx, dy )
	return self
end

--- Get the normal angle of the object's current angle.
-- @treturn Vector normal vector
function Rotatable:getDirection()
	return angle.forward( self:getAngle() )
end

return Rotatable