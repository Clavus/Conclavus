
local start = os.clock()
local _curTime, _prntcnt = 0, 0
local _gameTitle = "LD engine"

nilfunction = function() end -- null function so you can do "(a or nilfunction)(...)"  instead of "if (a != nil) then a(...) end".
currentTime = function() return _curTime end

local oldprint = print
function print( str )

	oldprint("[".._prntcnt.."] "..str)
	_prntcnt = _prntcnt + 1
	
end

function dprint( str )
	
	-- only print if p key is held down. Useful for stopping printing output
	if not input:keyIsDown("p") then return end
	print( str )
	
end

game = {}
require("engine/engine_includes")
require("game/game_includes")

function love.load()
	
	local libdiff = os.clock() - start
	start = os.clock()
	-------------------------------------------------------
		
	input = InputController()
	
	screen.init( love.window.getMode() )
	lovebird.init()
	loveframes.load()
	game.load()
	
	-------------------------------------------------------
	print("-- Initializing ".._gameTitle.." --")
	print("Loaded libraries in "..math.round(libdiff*1000).."ms")
	
	local initdiff = os.clock() - start
	print("Initialized game in "..math.round(initdiff*1000).."ms")
	
end

function love.update( dt )
	
	_curTime = _curTime + dt
	love.window.setTitle(_gameTitle.."  ("..love.timer.getFPS().." fps)")
	
	lovebird.update()
	timer.update(dt)
	game.update( dt )
	loveframes.update( dt )
	input:clear()
	
	-- hotswap changed files
	package.updatePackages()
	
end

function love.draw()
	
	screen.preDraw()
	
	game.draw()
	loveframes.draw()
	
	screen.postDraw()
	
end

function love.mousepressed(x, y, button)
	
	x, y = screen.getMousePosition() -- correct coordinates
	input:handle_mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
	
end

function love.mousereleased(x, y, button)
	
	x, y = screen.getMousePosition()
	input:handle_mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
	
end

function love.keypressed(key, unicode)
	
	input:handle_keypressed(key, unicode)
	loveframes.keypressed(key, unicode)
	
end

function love.keyreleased(key, unicode)
	
	input:handle_keyreleased(key, unicode)
	loveframes.keyreleased(key)
	
end

function love.gamepadpressed( joystick, button )

end

function love.gamepadreleased( joystick, button )

end

function love.gamepadaxis( joystick, axis, value )

end

function love.resize( w, h )
	
	screen.resize( w, h )
	
end

function love.textinput(text)

    loveframes.textinput(text)
 
end

function love.focus( f )

end

function love.mousefocus( f )

end

function love.quit()

end

