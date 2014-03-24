
Entity = class("Entity")

local entCounter = 0

function Entity:initialize()
	
	self._pos = Vector(0,0)
	self._angle = 0
	self._index = _entIndex
	self._relative_depth = 0
	self._updaterate_mul = 1
	
	entCounter = entCounter + 1
	self._entIndex = entCounter
	
end

function Entity:setPos( x, y )
	
	assertDebug(type(x) == "number", "Number expected, got "..type(x))
	assertDebug(type(y) == "number", "Number expected, got "..type(y))
	
	self._pos.x = x
	self._pos.y = y

end

function Entity:getPos()

	return self._pos.x, self._pos.y

end

function Entity:setAngle( r )
	
	assertDebug(type(r) == "number", "Number expected, got "..type(r))
	self._angle = r
	
end

function Entity:getAngle()
	
	return self._angle
	
end

function Entity:getCameraTrackingPos()
	
	return self:getPos()
	
end

function Entity:update( dt )

end

function Entity:draw()

end

function Entity:onRemove()

end

-- gets the layer name where this entity is drawn on
function Entity:getDrawLayer()

	return DRAW_LAYER_TOP
	
end

function Entity:getDrawBoundingBox()
	
	return self._pos.x - 32, self._pos.y - 32, 64, 64
	
end

function Entity:getDepth()
	
	return -self._pos.y + self._relative_depth
	
end

function Entity:setUpdateRateMultiplier( mul )
	
	self._updaterate_mul = mul
	
end

function Entity:getUpdateRateMultiplier()
	
	return self._updaterate_mul
	
end

function Entity:getEntIndex()
	
	return self._entIndex
	
end

function Entity:__eq( other )
	
	return instanceOf(self.class, other) and self:getEntIndex() == other:getEntIndex()
	
end