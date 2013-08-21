
SpriteData = class("SpriteData")

function SpriteData:initialize( image_file, offset, imgsize, origin, numcolums, numframes, frames_per_sec, should_loop )

	self._file = image_file
	self.image = resource.getImage(image_file)
	self.offset = offset or Vector(0,0)
	self.size = imgsize or Vector(32,32)
	self.origin_pos = origin or Vector(0,0)
	self.num_columns = numcolums or 1
	self.num_frames = numframes or 1
	self.fps = frames_per_sec or 0
	self.should_loop = should_loop or false
	
end