
local Positional = {}

function Positional:initialize()

	self._pos = Vector( 0, 0 )

end

function Positional:setPos( x, y )
	
	assert(type(x) == "number", "Number expected, got "..type(x))
	assert(type(y) == "number", "Number expected, got "..type(y))
	
	self._pos.x = x
	self._pos.y = y
	return self
	
end

function Positional:getPos()

	assert(self._pos ~= nil, "Forgot to initialize Positional mixin")
	return self._pos.x, self._pos.y

end

function Positional:move( x, y )
	
	assert(type(x) == "number", "Number expected, got "..type(x))
	assert(type(y) == "number", "Number expected, got "..type(y))
	
	self._pos.x = self._pos.x + x
	self._pos.y = self._pos.y + y
	return self
	
end

return Positional