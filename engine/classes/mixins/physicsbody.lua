------------------------
-- PhysicsBody [mixin](https://github.com/kikito/middleclass/wiki/Mixins). 
-- Apply to classes to give them physics body, along with relevant positional and rotational functions.
-- @mixin PhysicsBody
-- @usage local MyClass = class("MyClass")
-- MyClass:include( PhysicsBody )

--- @type PhysicsBody
local PhysicsBody = {}
local lp = love.physics

function PhysicsBody:initialize( world, btype )
	btype = btype or "dynamic"
	self._body = lp.newBody(world, 0, 0, btype)
	self._body:setUserData( self )
end

--- Get the [LÖVE physics body](https://www.love2d.org/wiki/Body).
-- @treturn Body body
function PhysicsBody:getBody()
	return self._body
end

--- Set the body's position.
-- @number x x-coordinate.
-- @number y y-coordinate.
-- @treturn PhysicsBody self
function PhysicsBody:setPos( x, y )
	self:getBody():setPosition(x, y)
	return self
end

--- Gets the body's position.
-- @treturn number x
-- @treturn number y
function PhysicsBody:getPos()
	return self:getBody():getPosition()
end

--- Move this body relative to its current position.
-- @number x relative x
-- @number y relative y
-- @treturn PhysicsBody self
function PhysicsBody:move( x, y )
	self._pos.x = self._pos.x + x
	self._pos.y = self._pos.y + y
	return self
end

--- Set the body's angle.
-- @number r angle (radians)
-- @treturn PhysicsBody self
function PhysicsBody:setAngle( r )
	self:getBody():setAngle( r )
	return self
end

--- Gets the body's angle.
-- @treturn number r angle
function PhysicsBody:getAngle()
	return self:getBody():getAngle()
end

--- Rotate this body relatively to its current angle.
-- @number r angle (radians)
-- @treturn PhysicsBody self
function PhysicsBody:rotate( r )
	self:getBody():setAngle( self._body:getAngle() + r )
	return self
end

--- Move this body forward (according to its current angle) by a given distance.
-- @number d distance
-- @treturn PhysicsBody self
function PhysicsBody:moveForward( d )
	local px, py = self:getPos()
	local dx, dy = angle.forward( self:getAngle() ):multiply( d ):unpack()
	self:setPos( px + dx, py + dy )
	return self
end

--- Get the normal angle of the body's current angle.
-- @treturn Vector normal vector
function PhysicsBody:getDirection()
	return angle.forward( self:getAngle() )
end

--- Called when the actor is removed.
function PhysicsBody:onRemove()
	self:getBody():destroy()
end

return PhysicsBody