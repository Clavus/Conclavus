------------------------
-- Entity class.
-- Should be the base class of pretty much all your game objects.
-- @cl Entity

local Entity = class("Entity")
Entity:include( Positional )

-- Generate unique entity IDs
local entCounter = 0
local function getEntUID()
	entCounter = entCounter + 1
	return entCounter
end

function Entity:initialize()
	Positional.initialize( self )
	self._entIndex = getEntUID()
	self._depth = 0
	self:setDrawBoundingBox()
	self._removeflag = false
end

function Entity.static.isValid( ent )
	return ent ~= nil and ent._removeflag == false
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

function Entity:setDrawBoundingBox( x1, y1, x2, y2 )
	self._drawbox = { x1 = x1 or -16, y1 = y1 or -16, x2 = x2 or 16, y2 = y2 or 16 }
end

-- returns the entity's drawing bounds in world coordinates
function Entity:getDrawBoundingBox()
	local px, py = self:getPos()
	-- always assumed this is axis-aligned
	return px + self._drawbox.x1, py + self._drawbox.y1, px + self._drawbox.x2, py + self._drawbox.y2
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

function Entity:remove()
	self._removeflag = true
end

function Entity:__eq( other )
	return self:isInstanceOf(other) and self:getEntIndex() == other:getEntIndex()
end

function Entity:__tostring()
	return tostring(self.class).." - Entity["..tostring(self._entIndex).."]"
end

return Entity