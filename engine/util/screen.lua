
local screen = {}
screen.settings = {}
screen.modes = {}
screen.transform = {}
screen.displays = {}

local lg, lw = love.graphics, love.window

function screen.init()
	
	local w, h, flags = lw.getMode()
	
	screen.settings = flags
	screen.width = w
	screen.height = h
	
	screen.transform.scaleX = 1
	screen.transform.scaleY = 1
	screen.transform.renderWidth = w
	screen.transform.renderHeight = h
	
	screen.updateDisplays()
	
	screen.resize( w, h )
	
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
	lg.scale(screen.transform.scaleX, screen.transform.scaleY)
	
end

function screen.postDraw()
	
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
	return mx / screen.transform.scaleX, my / screen.transform.scaleY
	
end

function screen.resize( w, h )

	--print("resize "..w..", "..h)
	screen.transform.scaleX = w / screen.transform.renderWidth
	screen.transform.scaleY = h / screen.transform.renderHeight
	--print("scale "..screen.transform.scaleX..", "..screen.transform.scaleY)
	
end

return screen
