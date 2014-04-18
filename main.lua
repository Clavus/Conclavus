
local _curTime, _prntcnt = 0, 0
local _gameTitle = "LD engine"

assertDebug = function() end
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
	
	screen.init()
	lovebird.init()
	print("---- Initializing ".._gameTitle.." ----")
	
	input = InputController()
	game.load()
	
end

function love.update( dt )
	
	_curTime = _curTime + dt
	
	lovebird.update()
	timer.update(dt)
	game.update( dt )
	input:clear()
	
	-- hotswap changed files
	package.updatePackages()
	
end

function love.draw()
	
	screen.preDraw()
	
	love.graphics.setBackgroundColor( 30, 30, 40 )
	love.graphics.clear()
	game.draw()
	
	screen.postDraw()
	
	love.window.setTitle(_gameTitle.."  ("..love.timer.getFPS().." fps)")
	
end

function love.mousepressed(x, y, button)
	
	input:handle_mousepressed(x,y,button)
	
end

function love.mousereleased(x, y, button)
	
	input:handle_mousereleased(x,y,button)
	
end

function love.keypressed(key, unicode)
	
	input:handle_keypressed(key, unicode)
	
end

function love.keyreleased(key, unicode)
	
	input:handle_keyreleased(key, unicode)
	
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

function love.focus( f )

end

function love.mousefocus( f )

end

function love.quit()

end

