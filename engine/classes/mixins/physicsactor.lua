
Mixin.PhysicsActor = {}
local PhysicsActor = Mixin.PhysicsActor

function PhysicsActor:initializeBody( world, btype )
	
	btype = btype or "dynamic"
	
	self._body = love.physics.newBody(world, 0, 0, btype)
	self._body:setUserData( self )
	
end

function PhysicsActor:getBody()
	
	return self._body
	
end

function PhysicsActor:setPos( x, y )
	
	assertDebug(type(x) == "number", "Number expected, got "..type(x))
	assertDebug(type(y) == "number", "Number expected, got "..type(y))
	
	self._body:setPosition(x, y)
	return self
	
end

function PhysicsActor:getPos()

	return self._body:getPosition()
	
end

function PhysicsActor:setAngle( r )
	
	self._body:setAngle( r )
	return self
	
end

function PhysicsActor:getAngle()
	
	return self._body:getAngle()
	
end

function PhysicsActor:onRemove()

	self._body:destroy()

end