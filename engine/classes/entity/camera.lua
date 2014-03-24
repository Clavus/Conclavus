
Camera = class("Camera", Entity)

function Camera:initialize()
	
	Entity.initialize(self)
	
	self._mode = "static"
	
	self._angle = 0
	self._scale = Vector(1,1)
	self._pos = Vector(0,0)
	
	self._refpos = Vector(0,0)
	self._targetpos = Vector(0,0)
	self._easingfunc = easing.inOutQuint
	self._easingstart = -100
	self._easingduration = 2
	self._easingamplitude = 10
	self._easingperiod = 1
	
	self._clamp_x1 = nil
	self._clamp_y1 = nil
	self._clamp_x2 = nil
	self._clamp_y2 = nil
	
	self._targetscale = Vector(1,1)
	self._scalespeed = 1
	
	self._diagonal = 0
	self:updateDiagonal()
	
end

function Camera:update(dt)
	
	if (self._mode == "static") then
	
		local t = engine.currentTime() - self._easingstart
		if (t <= self._easingduration) then
			self._pos.x = self._easingfunc(t, self._refpos.x, self._targetpos.x - self._refpos.x, self._easingduration, self._easingamplitude, self._easingperiod)
			self._pos.y = self._easingfunc(t, self._refpos.y, self._targetpos.y - self._refpos.y, self._easingduration, self._easingamplitude, self._easingperiod)
		else
			self._pos = self._targetpos
		end
		
	elseif (self._mode == "track") then
		
		local tx, ty = self:getTargetPos()
		tx = tx + self._track_rel_x
		ty = ty + self._track_rel_y
		self._pos.x = math.approach(self._pos.x, tx, math.abs(tx - self._pos.x)*20*dt)
		self._pos.y = math.approach(self._pos.y, ty, math.abs(ty - self._pos.y)*20*dt)
		
	end
	
	self._scale.x = math.approach(self._scale.x, self._targetscale.x, self._scalespeed*dt)
	self._scale.y = math.approach(self._scale.y, self._targetscale.y, self._scalespeed*dt)
	
	-- clamp
	if (self._clamp_x1) then
		self._pos.x = math.max( self._pos.x, self._clamp_x1 + self:getWidth() / 2 / self._scale.x )
	end
	
	if (self._clamp_x2) then
		self._pos.x = math.min( self._pos.x, self._clamp_x2 - self:getWidth() / 2 / self._scale.x )
	end
	
	if (self._clamp_y1) then
		self._pos.y = math.max( self._pos.y, self._clamp_y1 + self:getHeight() / 2 / self._scale.y )
	end
	
	if (self._clamp_y2) then
		self._pos.y = math.min( self._pos.y, self._clamp_y2 - self:getHeight() / 2 / self._scale.y )
	end
	
end

function Camera:getTargetPos()
	
	if (self._mode == "static") then
		return self._targetpos.x, self._targetpos.y
	else
		return self._trackent:getCameraTrackingPos()
	end
	
end

function Camera:setClampArea( x1, y1, x2, y2 )

	self._clamp_x1 = x1
	self._clamp_y1 = y1
	self._clamp_x2 = x2
	self._clamp_y2 = y2

end

function Camera:track( ent, rel_x, rel_y )
	
	self._mode = "track"
	self._trackent = ent
	self._track_rel_x = rel_x or 0
	self._track_rel_y = rel_y or 0
	
end

function Camera:moveTo( x, y, duration )
	
	self._mode = "static"
	
	self._targetpos.x = x
	self._targetpos.y = y
	self._refpos = self._pos:copy()
	self._easingstart = engine.currentTime()
	self._easingduration = duration
	
end

function Camera:getTargetScale()
	
	return self._targetscale.x, self._targetscale.y
	
end

function Camera:scaleTo( sx, sy )
	
	self._targetscale.x = sx
	self._targetscale.y = sy or sx
	
end

function Camera:preDraw()
	
	local tx, ty = self:getWidth()/2*self._scale.x, self:getHeight()/2*self._scale.y
	
	love.graphics.push()
	love.graphics.translate( tx, ty )
	love.graphics.scale( self._scale.x, self._scale.y )
	love.graphics.rotate( self._angle )
	love.graphics.translate( math.round(-self._pos.x), math.round(-self._pos.y) )
	
end

function Camera:postDraw()
	
	love.graphics.pop()
	
end

function Camera:getWidth()
	
	return love.graphics.getWidth() / self._scale.x
	
end

function Camera:getHeight()
	
	return love.graphics.getHeight() / self._scale.y
	
end

function Camera:getDiagonal()
	
	return self._diagonal
	
end

function Camera:updateDiagonal()
	
	local w, h = self:getWidth(), self:getHeight()
	self._diagonal = math.sqrt(w*w+h*h)
	
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

function Camera:isRectInView( x, y, w, h )
	
	w = w or 0
	h = h or 0
	
	return (x >= self._pos.x - w and x <= self._pos.x + self:getWidth() and
			y >= self._pos.y - h and y <= self._pos.y + self:getHeight())
	
end

function Camera:setScale( x, y )
	
	y = y or x
	self._scale.x = x
	self._scale.y = y
	self._targetscale.x = x
	self._targetscale.y = y
	self:updateDiagonal()
	
end

function Camera:getScale()

	return self._scale.x, self._scale.y

end

function Camera:setEasing( func, amp, period )
	
	self._easingfunc = func or self._easingfunc
	self._easingamplitude = amp or self._easingamplitude
	self._easingperiod = period or self._easingperiod
	
end

