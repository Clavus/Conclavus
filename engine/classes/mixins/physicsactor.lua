
local PhysicsActor = {}

function PhysicsActor:initialize( world, btype )
	btype = btype or "dynamic"
	self._body = love.physics.newBody(world, 0, 0, btype)
	self._body:setUserData( self )
end

function PhysicsActor:getBody()
	return self._body
end

function PhysicsActor:setPos( x, y )
	assert(type(x) == "number", "Number expected, got "..type(x))
	assert(type(y) == "number", "Number expected, got "..type(y))
	self:getBody():setPosition(x, y)
	return self
end

function PhysicsActor:getPos()
	return self:getBody():getPosition()
end

function PhysicsActor:setAngle( r )
	self:getBody():setAngle( r )
	return self
end

function PhysicsActor:getAngle()
	return self:getBody():getAngle()
end

function PhysicsActor:rotate( r )
	self:getBody():setAngle( self._body:getAngle() + r )
	return self
end

function PhysicsActor:moveForward( d )
	local px, py = self:getPos()
	local dx, dy = angle.forward( self:getAngle() ):multiplyBy( d ):unpack()
	self:setPos( px + dx, py + dy )
end

function PhysicsActor:getDirection()
	return angle.forward( self:getAngle() )
end

function PhysicsActor:onRemove()
	self:getBody():destroy()
end

return PhysicsActor