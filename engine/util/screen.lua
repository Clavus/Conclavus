
local screen = {}
screen.settings = {}
screen.modes = {}
screen.transform = {}
screen.displays = {}

local lg, lw = love.graphics, love.window
local force_aspect_ratio = true

function screen.init()
	
	local w, h, flags = lw.getMode()
	
	screen.settings = flags
	screen.width = w
	screen.height = h
	
	screen.transform.translateX = 0
	screen.transform.translateY = 0
	screen.transform.scaleX = 1
	screen.transform.scaleY = 1
	screen.transform.renderWidth = w
	screen.transform.renderHeight = h
	screen.transform.screenWidth = w
	screen.transform.screenHeight = h
	screen.transform.aspectRatio = w / h
	
	screen.updateDisplays()
	
	screen.resize( w, h )
	
end

function screen.setForceAspectRatio( b )
	
	force_aspect_ratio = b
	screen.resize( lw.getMode() )
	
end

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

function screen.preDraw()
	
	lg.push()
	love.graphics.setBackgroundColor( Color.Black:unpack() )
	love.graphics.clear()
	lg.translate(screen.transform.translateX, screen.transform.translateY)
	lg.scale(screen.transform.scaleX, screen.transform.scaleY)
	
	if (force_aspect_ratio) then
	
		lg.setScissor(screen.transform.translateX, screen.transform.translateY, screen.transform.screenWidth, screen.transform.screenHeight)
		
	end
	
end

function screen.postDraw()
	
	love.graphics.setScissor()
	lg.pop()
	
end

function screen.getRenderWidth()
	
	return screen.transform.renderWidth
	
end

function screen.getRenderHeight()
	
	return screen.transform.renderHeight
	
end

function screen.getMousePosition()

	local mx, my = love.mouse.getPosition()
	return (mx - screen.transform.translateX) / screen.transform.scaleX, (my - screen.transform.translateY) / screen.transform.scaleY
	
end

function screen.resize( w, h )

	--print("resize "..w..", "..h)
	screen.transform.screenWidth = w
	screen.transform.screenHeight = h
	
	screen.transform.scaleX = screen.transform.screenWidth / screen.transform.renderWidth
	screen.transform.scaleY = screen.transform.screenHeight / screen.transform.renderHeight
	
	if (force_aspect_ratio) then
	
		local ratio = w / h
		if (ratio < screen.transform.aspectRatio) then
		
			screen.transform.scaleY = screen.transform.scaleX
			screen.transform.screenHeight = (screen.transform.renderHeight * screen.transform.scaleY)
			
		elseif (ratio > screen.transform.aspectRatio) then
		
			screen.transform.scaleX = screen.transform.scaleY
			screen.transform.screenWidth = (screen.transform.renderWidth * screen.transform.scaleX)
			
		end
		
	end
	
	screen.transform.translateX = (w - screen.transform.screenWidth) / 2
	screen.transform.translateY = (h - screen.transform.screenHeight) / 2

	--print(table.toString( screen.transform, "screen.transform", true ))
	
end

return screen
