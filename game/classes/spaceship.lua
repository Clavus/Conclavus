
local SpaceShip = class("SpaceShip", Entity)

function SpaceShip:initialize()

	Entity.initialize(self)
	
	self._img = Sprite({
		image = resource.getImage( FOLDER.ASSETS.."spaceship.png" ),
		origin_relative = Vector(0.5, 0.5)
	})
	
end

function SpaceShip:update( dt )
	
	self._pos.x = self._pos.x + 0.2*math.sin(engine.currentTime())
	
end

function SpaceShip:draw()
	
	local x, y = self:getPos()
	self._img:draw( x, y, 0 )
	
end

return SpaceShip