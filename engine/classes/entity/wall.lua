------------------------
-- Wall class.
-- A static wall in your environment.
-- 
-- Derived from @{Entity}.
-- @cl Wall

--- @type Wall
local Wall = class("Wall", Entity)
Wall:include(PhysicsBody)

function Wall:initialize( world )
	Entity.initialize(self)
	PhysicsBody.initialize(self, world, "static" )
end

function Wall:buildFromSquare(w, h)
	self._shape = love.physics.newRectangleShape(w/2, h/2, w, h)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	self:setDrawBoundingBox( -w/2, -h/2, w/2, h/2 )
end

function Wall:buildFromPolygon(pol)
	local mergedXY = {}
	local mergedCounter = 1
	local min_x, min_y, max_x, max_y = -16,-16,16,16
	
	for j, pos in ipairs(pol) do
		mergedXY[mergedCounter] = pos.x
		mergedXY[mergedCounter+1] = pos.y
		mergedCounter = mergedCounter + 2
		
		if (pos.x < min_x) then min_x = pos.x end
		if (pos.x > max_x) then max_x = pos.x end
		if (pos.y < min_y) then min_y = pos.y end
		if (pos.y > max_y) then max_y = pos.y end
	end
	self._shape = love.physics.newChainShape(true, unpack(mergedXY))
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	self:setDrawBoundingBox( min_x, min_y, max_x, max_y )
end

function Wall:draw()
	local oldcol = { love.graphics.getColor() }
	love.graphics.setColor( Color.White:unpack() )
	if (self.points == nil) then
		self.points = { self._body:getWorldPoints(self._shape:getPoints()) }
		if (self._shape:getType() == "polygon") then
			table.insert( self.points, self.points[1] )
			table.insert( self.points, self.points[2] ) -- make sure the line drawing loops all the way around
		end
	end
	love.graphics.line(unpack(self.points))
	love.graphics.setColor( unpack( oldcol ) )
end

return Wall