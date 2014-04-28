
local Rotatable = {}

function Rotatable:initialize()
	
	self._angle = 0
	
end

function Rotatable:setAngle( r )
	
	assert(type(r) == "number", "Number expected, got "..type(r))
	self._angle = r
	return self
	
end

function Rotatable:getAngle()
	
	assert(self._angle ~= nil, "Forgot to initialize Rotatable mixin ;)")
	return self._angle
	
end

function Rotatable:rotate( r )

	assert(self._angle ~= nil, "Forgot to initialize Rotatable mixin ;)")
	self._angle = self._angle + r
	return self

end

function Rotatable:moveForward( d )

	assert(self.getPos ~= nil, "Can't move forward, no getPos function")
	local px, py = self:getPos()
	local dx, dy = angle.forward( self._angle ):multiplyBy( d ):unpack()
	self:setPos( px + dx, py + dy )

end

function Rotatable:getDirection()

	return angle.forward( self:getAngle() )

end

return Rotatable