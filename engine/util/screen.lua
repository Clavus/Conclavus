------------------------
-- Screen functions.
-- @util screen

local screen = {}
screen.settings = {}
screen.modes = {}
screen.transform = {}
screen.displays = {}

local lg, lw, lm = love.graphics, love.window, love.mouse
local force_aspect_ratio = true
local SCREEN_SCALE = SCREEN_SCALE

--- INTERNAL - Initializes screen parameters.
-- Is called when the framework loads.
function screen.init( w, h, flags )
	screen.settings = flags
	screen.width = w
	screen.height = h
	screen.transform.translateX = 0
	screen.transform.translateY = 0
	screen.transform.scaleX = 1
	screen.transform.scaleY = 1
	screen.transform.defaultRenderWidth = w
	screen.transform.defaultRenderHeight = h
	screen.transform.renderWidth = w
	screen.transform.renderHeight = h
	screen.transform.defaultAspectRatio = w / h
	screen.transform.aspectRatio = w / h
	screen.scaleType = SCREEN_SCALE.FIT_CLIPEDGES
	screen.transform.screenWidth = w
	screen.transform.screenHeight = h
	screen.updateDisplays()
	screen.resize( w, h )
end

--- Set the default render dimensions of your game.
-- Independent of window size.
-- @number w render width
-- @number h render height
function screen.setDefaultRenderDimensions( w, h )
	screen.transform.defaultRenderWidth = w
	screen.transform.defaultRenderHeight = h
	screen.transform.defaultAspectRatio = w / h
	screen.resize( lw.getMode() )
end

--- Set the scaling type. See @{constants.SCREEN_SCALE|SCREEN_SCALE constants}.
-- @tparam SCREEN_SCALE stype scaling type
-- @usage screen.setScaleType( SCREEN_SCALE.FIT_LETTERBOX )
function screen.setScaleType( stype )
	local exists = false
	for k, v in pairs( SCREEN_SCALE ) do
		if (stype == v) then
			print("Setting scale type to SCREEN_SCALE."..k)
			exists = true
		end
	end
	assert(exists, "This screen scale type does not exists!")
	screen.scaleType = stype
	screen.resize( lw.getMode() )
end

--- INTERNAL - Update display information. Stores display count and width, height and available fullscreen modes per display.
function screen.updateDisplays()
	screen.displays = {}
	screen.displayCount = lw.getDisplayCount()
	for i = 1, screen.displayCount do
		local fmodes = lw.getFullscreenModes(i)
		table.sort(fmodes, function(a, b) return a.width*a.height < b.width*b.height end)
		local dw, dh = lw.getDesktopDimensions( i )
		screen.displays[i] = { desktop = { width = dw, height = dh }, modes = fmodes }
	end
end

--- Set screen mode.
-- Replaces [love.window.setMode](https://www.love2d.org/wiki/love.window.setMode). Same parameters.
-- @number w screen width
-- @number h screen height
-- @tparam table flags screen settings
function screen.set( w, h, flags )
	screen.width = w or screen.width
	screen.height = h or screen.height
	screen.settings.display = flags.display or screen.settings.display
	screen.settings.fsaa = flags.fsaa or screen.settings.fsaa
	screen.settings.fullscreentype = flags.fullscreentype or screen.settings.fullscreentype
	if (flags.vsync ~= nil) then screen.settings.vsync = flags.vsync end
	if (flags.borderless ~= nil) then screen.settings.borderless = flags.borderless end
	if (flags.fullscreen ~= nil) then screen.settings.fullscreen = flags.borderless end
	--print(table.toString(screen.settings, "screen.settings", false))
	local res = lw.setMode( screen.width, screen.height, screen.settings )
	if (res) then
		local w, h = lw.getMode()
		screen.resize( w, h )
	end
	return res
end

--- INTERNAL - Is called before everything draws.
function screen.preDraw()
	lg.push()
	lg.setBackgroundColor( 0, 0, 0, 0 )
	lg.clear()
	lg.translate(screen.transform.translateX, screen.transform.translateY)
	lg.scale(screen.transform.scaleX, screen.transform.scaleY)
	if (force_aspect_ratio) then
		lg.setScissor(screen.transform.translateX, screen.transform.translateY, screen.transform.screenWidth, screen.transform.screenHeight)
	end
end

--- INTERNAL - Is called after everything draws.
function screen.postDraw()
	lg.setScissor()
	lg.pop()
end

--- Get screen render width.
-- @treturn number render width
function screen.getRenderWidth()
	return screen.transform.renderWidth	
end

--- Get screen render height.
-- @treturn number render width
function screen.getRenderHeight()	
	return screen.transform.renderHeight	
end

--- Get screen aspect ratio.
-- @treturn number aspect ratio ( width / height )
function screen.getAspectRatio()	
	return screen.transform.aspectRatio	
end

--- Get the mouse position.
-- Replaces [love.mouse.getPosition](https://www.love2d.org/wiki/love.mouse.getPosition).
-- @treturn number x
-- @treturn number y
function screen.getMousePosition()
	local mx, my = lm.getPosition()
	return (mx - screen.transform.translateX) / screen.transform.scaleX, (my - screen.transform.translateY) / screen.transform.scaleY	
end

--- INTERNAL -  Called when the screen size changes.
-- @number w new width
-- @number h new height
function screen.resize( w, h )
	local sst = screen.scaleType
	local ratio = w / h
	--print("resize "..w..", "..h)
	screen.transform.screenWidth = w
	screen.transform.screenHeight = h	
	if (sst == SCREEN_SCALE.CENTER) then
		screen.transform.screenWidth = math.min( w, screen.transform.renderWidth )
		screen.transform.screenHeight = math.min( h, screen.transform.renderHeight)
	end	
	-- reset render dimensions to their defaults
	screen.transform.renderWidth = screen.transform.defaultRenderWidth
	screen.transform.renderHeight = screen.transform.defaultRenderHeight
	screen.transform.aspectRatio = screen.transform.defaultAspectRatio
	screen.transform.scaleX = screen.transform.screenWidth / screen.transform.renderWidth
	screen.transform.scaleY = screen.transform.screenHeight / screen.transform.renderHeight
	
	local function cropHeight() 
		screen.transform.scaleY = screen.transform.scaleX
		screen.transform.screenHeight = (screen.transform.renderHeight * screen.transform.scaleY)
	end
	
	local function cropWidth()
		screen.transform.scaleX = screen.transform.scaleY
		screen.transform.screenWidth = (screen.transform.renderWidth * screen.transform.scaleX)
	end
	
	local function fitHeight()
		screen.transform.renderWidth = screen.transform.renderHeight * ratio
		screen.transform.scaleX = screen.transform.scaleY
		screen.transform.screenWidth = w
	end
	
	local function fitWidth()
		screen.transform.renderHeight = screen.transform.renderWidth / ratio
		screen.transform.scaleY = screen.transform.scaleX
		screen.transform.screenHeight = h
	end
	
	if (sst == SCREEN_SCALE.FIT_LETTERBOX or sst == SCREEN_SCALE.CENTER) then
		if (ratio < screen.transform.aspectRatio) then
			cropHeight()
		elseif (ratio > screen.transform.aspectRatio) then
			cropWidth()
		end
	elseif (sst == SCREEN_SCALE.FIT_CLIPEDGES) then	
		if (ratio < screen.transform.aspectRatio) then
			fitHeight()
		elseif (ratio > screen.transform.aspectRatio) then
			fitWidth()
		end
	elseif (sst == SCREEN_SCALE.FIT_WIDTH) then
		if (ratio < screen.transform.aspectRatio) then
			cropHeight()
		elseif (ratio > screen.transform.aspectRatio) then
			fitWidth()
		end	
	elseif (sst == SCREEN_SCALE.FIT_HEIGHT) then	
		if (ratio < screen.transform.aspectRatio) then
			fitHeight()
		elseif (ratio > screen.transform.aspectRatio) then
			cropWidth()
		end
	end
	screen.transform.aspectRatio = screen.transform.screenWidth / screen.transform.screenHeight
	screen.transform.translateX = (w - screen.transform.screenWidth) / 2
	screen.transform.translateY = (h - screen.transform.screenHeight) / 2
	--print(table.toString( screen.transform, "screen.transform", true ))
end

return screen
