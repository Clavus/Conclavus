
local Rotatable = {}

function Rotatable:initialize()
	
	self._angle = 0
	
end

function Rotatable:setAngle( r )
	
	assertDebug(type(r) == "number", "Number expected, got "..type(r))
	self._angle = r
	return self
	
end

function Rotatable:getAngle()
	
	return self._angle
	
end

function Rotatable:rotate( r )

	self._angle = self._angle + r
	return self

end

return Rotatable