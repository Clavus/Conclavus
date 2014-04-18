
local Entity = class("Entity")

-- Generate unique entity IDs
local entCounter = 0
local function getEntUID()
	entCounter = entCounter + 1
	return entCounter
end

function Entity:initialize()
	
	self._pos = Vector(0,0)
	self._angle = 0
	self._entIndex = getEntUID()
	
	self._depth = 0
	self._drawbox = { x1 = -32, y1 = -32, x2 = 32, y2 = 32 }
	
end

function Entity:setPos( x, y )
	
	assertDebug(type(x) == "number", "Number expected, got "..type(x))
	assertDebug(type(y) == "number", "Number expected, got "..type(y))
	
	self._pos.x = x
	self._pos.y = y
	return self
	
end

function Entity:getPos()

	return self._pos.x, self._pos.y

end

function Entity:move( x, y )
	
	self._pos.x = self._pos.x + x
	self._pos.y = self._pos.y + y
	return self
	
end

function Entity:setAngle( r )
	
	assertDebug(type(r) == "number", "Number expected, got "..type(r))
	self._angle = r
	return self
	
end

function Entity:getAngle()
	
	return self._angle
	
end

function Entity:rotate( r )

	self._angle = self._angle + r
	return self

end

function Entity:update( dt )

end

function Entity:draw()

end

function Entity:onRemove()

end

-- gets the layer name where this entity is drawn on
function Entity:getDrawLayer()

	return DRAW_LAYER.TOP
	
end

-- returns the entity's drawing bounds in world coordinates
function Entity:getDrawBoundingBox()
	
	-- always assumed this is axis-aligned
	return self._pos.x + self._drawbox.x1, self._pos.y + self._drawbox.y1, self._pos.x + self._drawbox.x2, self._pos.y + self._drawbox.y2
	
end

function Entity:setDrawDepth( d )
	
	self._depth = d
	return self
	
end

function Entity:getDrawDepth()
	
	return self._depth
	
end

function Entity:getEntIndex()
	
	return self._entIndex
	
end

function Entity:__eq( other )
	
	return self:isInstanceOf(other) and self:getEntIndex() == other:getEntIndex()
	
end

function Entity:__tostring()

	return tostring(self.class).." - Entity["..tostring(self._entIndex).."]"
	
end

return Entity