
Sprite = class("Sprite")

function Sprite:initialize( sData )
	
	self._image = sData.image
	self._offset = sData.offset or Vector(0,0)
	self._size = sData.size or Vector(self._image:getWidth(), self._image:getHeight())
	self._origin_pos = sData.origin_pos or Vector(0,0)
	self._num_frames = sData.num_frames or 1
	self._fps = sData.fps or 0
	self._loops = sData.should_loop or false
	self._cur_frame = 1
	self._ended = false
	
	self._speed = 1
	
	self.visible = true
	
	local quads = {}
	local col = 0
	local row = 0
	local fw, fh = self._size.x, self._size.y
	local img = self._image
	local offset = self._offset
	local num_columns = sData.num_columns or 1
	
	for i = 1, self._num_frames do
		table.insert(quads, love.graphics.newQuad(offset.x + col*fw, offset.y + row*fh, fw, fh, img:getWidth(), img:getHeight()))
		col = col + 1
		if (col >= num_columns) then
			col = 0
			row = row + 1
		end
	end
	
	self._frames = quads
	
end

function Sprite:update( dt )

	if (not self._ended and self._num_frames > 1 and self._fps * self._speed ~= 0) then
		self._cur_frame = self._cur_frame + (dt * self._fps * self._speed)
		
		if (self._cur_frame >= self._num_frames + 1) then
			if (self._loops) then
				self._cur_frame = self._cur_frame - self._num_frames
			else
				self._cur_frame = self._num_frames
				self._ended = true
			end
		elseif (self._cur_frame < 1) then
			if (self._loops) then
				self._cur_frame = self._num_frames + 1 + self._cur_frame
			else
				self._cur_frame = self._num_frames
				self._ended = true
			end
		end
		
	end

end

function Sprite:setSpeed( scalar )
	self._speed = scalar
end

function Sprite:getSpeed( scalar )
	return self._speed
end

function Sprite:draw(x, y, r, sx, sy)
	
	if not self.visible then return end
	
	r = r or 0
	sx = sx or 1
	sy = sy or 1	
	local frame = self._frames[math.floor(self._cur_frame)]
	local origin = self._origin_pos
	love.graphics.draw(self._image, frame, x, y, r, sx, sy, origin.x, origin.y)

end

function Sprite:reset()
	
	self._cur_frame = 1
	self._speed = 1
	self._ended = false
	
end

function Sprite:setCurrentFrame( frame )
	
	self._cur_frame = frame
	
end

function Sprite:getCurrentFrame()
	
	return math.floor(self._cur_frame)
	
end

