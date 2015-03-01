------------------------
-- Positional [mixin](https://github.com/kikito/middleclass/wiki/Mixins). 
-- Apply to classes that have a x, y position in the world.
-- @mixin positional
-- @usage local MyClass = class("MyClass")
-- MyClass:include( Positional )

local Positional = {}

function Positional:initialize()
	self._pos = Vector( 0, 0 )
end

--- Set the object's position.
-- @number x x-coordinate.
-- @number y y-coordinate.
-- @treturn Positional self
function Positional:setPos( x, y )
	self._pos.x = x
	self._pos.y = y
	return self
end

--- Gets the object's position.
-- @treturn number x
-- @treturn number y
function Positional:getPos()
	return self._pos.x, self._pos.y
end

--- Move this object relative to its current position.
-- @number x relative x
-- @number y relative y
-- @treturn Positional self
function Positional:move( x, y )
	self._pos.x = self._pos.x + x
	self._pos.y = self._pos.y + y
	return self
end

return Positional