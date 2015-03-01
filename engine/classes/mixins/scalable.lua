------------------------
-- Scalable [mixin](https://github.com/kikito/middleclass/wiki/Mixins). 
-- Apply to classes that can be scaled.
-- @mixin Scalable

local Scalable = {}

function Scalable:initialize()
	self._scale = Vector(1,1)
end

function Scalable:setScale( x, y )
	y = y or x
	self._scale.x = x
	self._scale.y = y
	return self
end

function Scalable:getScale()
	return self._scale.x, self._scale.y
end

return Scalable