
local _gameTitle = "Conclavus"
local _start = os.clock()
local _curTime, _prntcnt = 0, 0
local _input

local lw = love.window

nilfunction = function() end -- null function so you can do "(a or nilfunction)(...)"  instead of "if (a != nil) then a(...) end".
currentTime = function() return _curTime end

local oldprint = print
function print( ... )
	oldprint("[".._prntcnt.."]", ...)
	_prntcnt = _prntcnt + 1
end

function _inputController()
	return _input
end

game = {}
require("engine/engine_includes")
require("game/game_includes")

function love.load( arg )
	-- zerobrane studio support
	if arg[#arg] == "-debug" then require("mobdebug").start() end

	_curTime = 0
	local libdiff = os.clock() - _start
	_start = os.clock()
	math.randomseed(_start)
	-------------------------------------------------------
	love.joystick.loadGamepadMappings( "gamecontrollerdb.txt" )
	_input = InputController()
	
	screen.init( lw.getMode() )
	lovebird.init()
	game.load()
	-------------------------------------------------------
	print("-- Initializing ".._gameTitle.." --")
	print("Loaded libraries in "..math.round(libdiff*1000).."ms")
	local initdiff = os.clock() - _start
	print("Initialized game in "..math.round(initdiff*1000).."ms")
end

function love.update( dt )
	_curTime = _curTime + dt
	lw.setTitle(_gameTitle.."  ("..love.timer.getFPS().." fps)")
	lovebird.update()
	timer.update(dt)
	resource.update()
	game.update(dt)
	loveframes.update( dt )
	_input:clear()
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
	_input:handle_mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	x, y = screen.getMousePosition()
	_input:handle_mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end

function love.mousemoved( x, y, dx, dy )
	(game.mousemoved or nilfunction)(x, y, dx, dy)
end

function love.keypressed(key, unicode)
	_input:handle_keypressed(key, unicode)
	loveframes.keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
	_input:handle_keyreleased(key, unicode)
	loveframes.keyreleased(key)
end

function love.gamepadpressed( joystick, button )
	_input:handle_gamepadpressed(joystick, button)
end

function love.gamepadreleased( joystick, button )
	_input:handle_gamepadreleased(joystick, button)
end

function love.gamepadaxis( joystick, axis, value )
	_input:handle_gamepadaxis( joystick, axis, value )
end

function love.joystickadded( joystick )
	_input:handle_gamepadadded(joystick)

end

function love.joystickadded( joystick )
	_input:handle_gamepadremoved(joystick)
end

function love.resize( w, h )
	screen.resize( w, h )
end

function love.textinput(text)
  loveframes.textinput(text)
end

function love.focus( f )
	(game.focus or nilfunction)( f )
end

function love.mousefocus( f )
	(game.mousefocus or nilfunction)( f )
end

function love.visible( v )
	(game.visible or nilfunction)( v )
end

function love.quit()
	(game.quit or nilfunction)()
end

