
game = {}
engine = {}

require("engine/engine_includes")
require("game/game_includes")

local _curTime, _prntcnt = 0, 0
local _gameTitle = "LD engine"

assertDebug = function() end
nilfunction = function() end -- null function so you can do "(a or nilfunction)(...)"  instead of "if (a != nil) then a(...) end".

function love.load()
	
	-- Disable this on release, removes unnecessary asserts
	assertDebug = assert
	
	_curTime = 0
	
	input = InputController()
	game.load()
	
end

function love.update( dt )
	
	_curTime = _curTime + dt
	timer.update(dt)
	game.update( dt )
	input:clear()
	
end

function love.draw()
	
	love.graphics.setBackgroundColor( 30, 30, 40 )
	love.graphics.clear()
	game.draw()
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

function love.focus(f)

end

function love.quit()

end

function engine.currentTime()
	
	return _curTime
	
end

local oldprint = print
function print( str )
	oldprint("[".._prntcnt.."] "..str)
	_prntcnt = _prntcnt + 1
end
