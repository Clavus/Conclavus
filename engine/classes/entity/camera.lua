
local Camera = class("Camera", Entity)

local cos, sin = math.cos, math.sin
local getWindowWidth, getWindowHeight = love.graphics.getWidth, love.graphics.getHeight

function Camera:initialize()
	
	Entity.initialize( self )
	
	self._scale = Vector(1,1)
	self._diagonal2 = 0
	self._diagonal = 0
	
	self:_updateDiagonal()
	
end

function Camera:setScale( x, y )
	
	y = y or x
	self._scale.x = x
	self._scale.y = y
	self:_updateDiagonal()
	return self
	
end

function Camera:getScale()

	return self._scale.x, self._scale.y

end

function Camera:attach()
	
	local px, py = self:getPos()
	local ang = self:getAngle()
	local sx, sy = self:getScale()
	local cx,cy = getWindowWidth()/(2*sx), getWindowHeight()/(2*sy)
	
	love.graphics.push()
	love.graphics.scale( sx, sy )
	love.graphics.translate( cx, cy )
	love.graphics.rotate( ang )
	love.graphics.translate( -px, -py )
	
end

function Camera:detach()

	love.graphics.pop()
	
end

function Camera:draw( func )

	self:attach()
	func()
	self:detach()
	
end

function Camera:cameraCoords( x, y )

	local px, py = self:getPos()
	local ang = self:getAngle()
	local sx, sy = self:getScale()
	local w, h = getWindowWidth(), getWindowHeight()
	local cx, cy = w / (2*sx), h / (2*sy)
	
	local c, s = cos(ang), sin(ang)
	x, y = x - px, y - py
	x, y = c*x - s*y, s*x + c*y
	
	return x*sx + w/2, y*sy + h/2
	
end

function Camera:worldCoords( x, y )

	local px, py = self:getPos()
	local ang = self:getAngle()
	local sx, sy = self:getScale()
	local w, h = getWindowWidth(), getWindowHeight()
	local cx, cy = w / (2*sx), h / (2*sy)
	
	local c, s = cos(-ang), sin(-ang)
	x, y = (x - w/2) / sx, (y - h/2) / sy
	x, y = c*x - s*y, s*x + c*y
	
	return x+px, y+py
	
end

function Camera:getMouseWorldPos()

	return self:worldCoords(love.mouse.getPosition())
	
end

function Camera:getWidth()
	
	return getWindowWidth() / self._scale.x
	
end

function Camera:getHeight()
	
	return getWindowHeight() / self._scale.y
	
end

function Camera:getDiagonal()
	
	return self._diagonal
	
end

function Camera:getDiagonal2()
	
	return self._diagonal2
	
end

function Camera:_updateDiagonal()
	
	local w, h = self:getWidth(), self:getHeight()
	self._diagonal2 = w*w+h*h
	self._diagonal = math.sqrt(self._diagonal2)
	
end

function Camera:getBackgroundQuadWidth()
	
	local w, h = self:getWidth(), self:getHeight()
	if (w > h) then
		return w/h*self:getDiagonal()
	else
		return self:getDiagonal()
	end
	
end

function Camera:getBackgroundQuadHeight()
	
	local w, h = self:getWidth(), self:getHeight()
	if (w > h) then
		return self:getDiagonal()
	else
		return h/w*self:getDiagonal()
	end
	
end

function Camera:isEntityVisible( ent )
	
	assert(ent:isInstanceOf( Entity ), "Entity expected, got "..type(ent))
	
	-- we compare the entity's (axis-aligned) bounding box against the camera's bounding circle
	local x1, y1, x2, y2 = ent:getDrawBoundingBox()
	local cx, cy = self:getPos()
	
	--print("x1, y1, x2, y2 = "..x1..", "..y1..", "..x2..", "..y2)
	--print("cx, cy = "..cx..", "..cy)
	
	local dx = cx - math.clamp( cx, x1, x2 )
	local dy = cy - math.clamp( cy, y1, y2 )
	
	--print("dx, dy = "..dx..", "..dy)
	
	return (dx * dx + dy * dy) < self._diagonal2
	
end

return Camera
