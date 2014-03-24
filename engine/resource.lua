
resource = {}

local loaded_images = {}
local loaded_sounds = {}

function resource.getImage( image_file, wrap )
	
	if (image_file == nil) then return end
	
	if (loaded_images[image_file] == nil) then
		loaded_images[image_file] = love.graphics.newImage(image_file)
		if (wrap) then
			loaded_images[image_file]:setWrap(wrap, wrap)
		end
	end
	
	return loaded_images[image_file]
	
end

function resource.getSound( sound_file, stype )
	
	if (sound_file == nil) then return end
	
	if (loaded_sounds[sound_file] == nil) then
		loaded_sounds[sound_file] = love.audio.newSource( sound_file, stype )
	end
	
	return loaded_sounds[sound_file]
	
end

function resource.getImageDimensions( image_file )
	
	local img = resource.getImage( image_file )
	return img:getWidth(), img:getHeight()
	
end
