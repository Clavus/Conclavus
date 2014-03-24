
mixin.PhysicsActor = {}
local PhysicsActor = mixin.PhysicsActor

function PhysicsActor:initializeBody()

end

function PhysicsActor:getBody()
	
	return self._body
	
end

function PhysicsActor:setPos( x, y )
	
	assertDebug(type(x) == "number", "Number expected, got "..type(x))
	assertDebug(type(y) == "number", "Number expected, got "..type(y))
	
	self._body:setPosition(x, y)

end

function PhysicsActor:getPos()

	return self._body:getPosition()
	
end

function PhysicsActor:setAngle( r )
	
	return self._body:setAngle( r )
	
end

function PhysicsActor:getAngle()
	
	return self._body:getAngle()
	
end

function PhysicsActor:onRemove()

	self._body:destroy()

end