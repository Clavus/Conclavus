------------------------
-- Scalable [mixin](https://github.com/kikito/middleclass/wiki/Mixins). 
-- Apply to classes that can be scaled.
-- @mixin Scalable

--- @type Scalable
local Scalable = {}

function Scalable:initialize()
	self._scale = Vector(1,1)
end

--- Set the object's scale.
-- @number x x-scale (width)
-- @number[opt=x] y y-scale (height)
-- @treturn Scalable self
function Scalable:setScale( x, y )
	y = y or x
	self._scale.x = x
	self._scale.y = y
	return self
end

--- Gets the object's scale.
-- @treturn number x
-- @treturn number y
function Scalable:getScale()
	return self._scale.x, self._scale.y
end

--- Multiply the object's scale.
-- @number sx x-scale multiplier (width)
-- @number[opt=sx] sy y-scale multiplier (height)
-- @treturn Scalable self
function Scalable:scale( sx, sy )
	sy = sy or sx
	self._scale.x = self._scale.x * sx
	self._scale.y = self._scale.y * sy
	return self
end

return Scalable