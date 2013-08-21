
Player = class("Player", Entity)
Player:include(mixin.PhysicsActor)

function Player:initialize( world )
	
	Entity.initialize(self)
	
	self:initializeBody( world )
	
end

function Player:initializeBody( world )
	
	self._body = love.physics.newBody(world, 0, 0, "dynamic")
	self._body:setMass(1)
	self._shape = love.physics.newCircleShape(16)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
end

function Player:draw()
	
	love.graphics.setLineWidth( 2 )
	love.graphics.setColor(255,255,255,255)
	love.graphics.circle("line", 
			self._body:getX(), 
			self._body:getY(), 
			self._shape:getRadius(), 20)
	
end
