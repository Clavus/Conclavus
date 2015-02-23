
local resource = {}

local loaded_images = {}
local loaded_imageData = {}
local loaded_sounds = {}
local loaded_soundData = {}

local batches = {}
local loader_path = "engine/lib/loveloader/love-loader"

function resource.getImage( image_file, force_new )
	
	assert(type(image_file) == "string", "Image file path is not a string!")
	
	if (loaded_images[image_file] == nil or force_new) then
		loaded_images[image_file] = love.graphics.newImage( image_file )
	end
	
	return loaded_images[image_file]
	
end

function resource.getImageData( image_file, force_new )
	
	assert(type(image_file) == "string", "Image file path is not a string!")
	
	if (loaded_imageData[image_file] == nil or force_new) then
		loaded_imageData[image_file] = love.graphics.newImageData( image_file )
	end
	
	return loaded_imageData[image_file]
	
end

function resource.getSound( sound_file, stype, force_new )
	
	assert(type(sound_file) == "string", "Sound file path is not a string!")
	
	if (loaded_sounds[sound_file] == nil or force_new) then
		loaded_sounds[sound_file] = love.audio.newSource( sound_file, stype )
	end
	
	return loaded_sounds[sound_file]
	
end


function resource.getSoundData( sound_file, force_new )
	
	assert(type(sound_file) == "string", "Sound file path is not a string!")
	
	if (loaded_soundData[sound_file] == nil or force_new) then
		loaded_soundData[sound_file] = love.audio.newSoundData( sound_file )
	end
	
	return loaded_soundData[sound_file]
	
end

function resource.getImageDimensions( image_file )
	
	local img = resource.getImage( image_file )
	return img:getWidth(), img:getHeight()
	
end

-- resource.beginBatch()
-- Set up a batch for loading resources
-- Returns: batch handle number
function resource.beginBatch()
	
	local newloader = require(loader_path)
	local batch = { loader = newloader, isLoading = false, isDone = false, 
			images = {}, imageData = {}, sounds = {}, soundData = {} }
	table.insert( batches, batch )
	return #batches
	
end

local function getBatchAndLoader( handle )
	
	assert(type(handle) == "number" and batches[handle] ~= nil, "Batch handle does not exist!")
	local batch = batches[handle]
	local loader = batch.loader
	
	assert(batch.isDone == false, "Batch has already been loaded!")
	assert(batch.isLoading == false, "Batch is already loading!")
	return batch, loader
	
end

function resource.addImageToBatch( handle, image_file )
	
	assert(type(image_file) == "string", "Image file path is not a string!")
	local batch, loader = getBatchAndLoader( handle )
	loader.newImage( batch.images, image_file, image_file )
	
end

function resource.addImageDataToBatch( handle, image_file )
	
	assert(type(image_file) == "string", "Image file path is not a string!")
	local batch, loader = getBatchAndLoader( handle )
	loader.newImageData( batch.imageData, image_file, image_file )
	
end

function resource.addSoundToBatch( handle, sound_file, stype )
	
	assert(type(sound_file) == "string", "Sound file path is not a string!")
	local batch, loader = getBatchAndLoader( handle )
	loader.newSource( batch.sounds, sound_file, sound_file, stype )

end

function resource.addSoundDataToBatch( handle, sound_file )
	
	assert(type(sound_file) == "string", "Sound file path is not a string!")
	local batch, loader = getBatchAndLoader( handle )
	loader.newSoundData( batch.soundData, sound_file, sound_file, stype )

end

function resource.loadBatch( handle, onFinishCallback, onLoadCallback )
	
	assert(type(handle) == "number" and batches[handle] ~= nil, "Batch handle does not exist!")
	local batch = batches[handle]
	local loader = batch.loader
	
	assert(batch.isDone == false, "Batch has already been loaded!")
	assert(batch.isLoading == false, "Batch is already loading!")
	
	batch.isLoading = true
	
	loader.start(function()
		batch.isDone = true
		batch.isLoading = false
		batch.numLoaded = #batch.images + #batch.sounds
		batch.loader = nil -- drop loader reference so it can be cleaned up by the GC
		
		if (onFinishCallback) then
			onFinishCallback()	
		end
  end, function(kind, holder, key)
		
		local res
		
		if (kind == "image") then
			res = batch.images[key]
			loaded_images[key] = res
		elseif (kind == "source" or kind == "stream") then
			res = batch.sounds[key]
			loaded_sounds[key] = res
		elseif (kind == "imageData") then
			res = batch.imageData[key]
			loaded_imageData[key] = res
		elseif (kind == "soundData") then
			res = batch.soundData[key]
			loaded_soundData[key] = res
		end
		
		if (onLoadCallback) then
			onLoadCallback( key, res )
		end
	end)
	
end

function resource.isBatchDone( handle )
	
	assert(type(handle) == "number" and batches[handle] ~= nil, "Batch handle does not exist!")
	return batches[handle].isDone
	
end

-- resource.getBatchProgress( handle )
-- Params: batch handle,
-- Returns: resource amount, resource loaded
function resource.getBatchProgress( handle )
	
	assert(type(handle) == "number" and batches[handle] ~= nil, "Batch handle does not exist!")
	local batch = batches[handle]
	local loader = batches[handle].loader
	if (batch.isDone) then
		return batch.numLoaded, batch.numLoaded
	else
		return loader.resourceCount, loader.loadedCount
	end
	
end

function resource.update()
	
	local batch
	for k = 1, #batches do
		batch = batches[k]
		if (batch.isLoading) then
			batch.loader.update()
		end
	end

end

return resource