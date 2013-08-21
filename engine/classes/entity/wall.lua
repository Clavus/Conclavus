
Wall = class("Wall", Entity)
Wall:include(mixin.PhysicsActor)

function Wall:initialize( world )
	
	Entity.initialize(self)
	
	self:initializeBody()

end

function Wall:initializeBody()
	
	self._body = love.physics.newBody(world, 0, 0, "static")
	
end

function Wall:buildFromSquare(w, h)
	
	self._shape = love.physics.newRectangleShape(w/2, h/2, w, h)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
			
end

function Wall:buildFromPolygon(pol)
	
	local mergedXY = {}
	local mergedCounter = 1
	for j, pos in ipairs(pol) do
		mergedXY[mergedCounter] = pos.x
		mergedXY[mergedCounter+1] = pos.y
		mergedCounter = mergedCounter + 2
	end
	self._shape = love.physics.newChainShape(true, unpack(mergedXY))
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
end

--[[
function Wall:draw()
	
	love.graphics.line(self._body:getWorldPoints(self._shape:getPoints()))
	
end
]]--

