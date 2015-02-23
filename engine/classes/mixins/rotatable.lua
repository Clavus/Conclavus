
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
	
	assert(self._angle ~= nil, "Forgot to initialize Rotatable mixin")
	return self._angle
	
end

function Rotatable:rotate( r )

	assert(self._angle ~= nil, "Forgot to initialize Rotatable mixin ")
	self._angle = self._angle + r
	return self

end

function Rotatable:moveForward( d )

	assert(self.move ~= nil, "Function requires Positional mixin")
	local dx, dy = angle.forward( self._angle ):multiplyBy( d ):unpack()
	self:move( dx, dy )

end

function Rotatable:getDirection()

	return angle.forward( self:getAngle() )

end

return Rotatable