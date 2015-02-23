
local SpaceShip = class("SpaceShip", Entity)
SpaceShip:include( Rotatable )

function SpaceShip:initialize()

	Entity.initialize( self )
	Rotatable.initialize( self )
	
	local imgpath = FOLDER.ASSETS.."spaceship.png"
	
	-- resource batch loading test
	local b = resource.beginBatch()
	resource.addImageToBatch(b, imgpath)
	resource.loadBatch(b, function()
		self._img = Sprite({
			image = resource.getImage(imgpath),
			origin_relative = Vector(0.5, 0.5)
		})
	end)
	
end

function SpaceShip:update( dt )
	
	self._pos.x = 200*math.sin(currentTime())
	
end

function SpaceShip:draw()
	
	if (self._img) then
		local x, y = self:getPos()
		self._img:draw( x, y, 0 )
	end
	
end

return SpaceShip