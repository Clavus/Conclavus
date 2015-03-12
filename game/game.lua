------------------------
-- The main file of your game.
-- Receives a few callbacks forwarded by the [LÖVE callbacks](https://www.love2d.org/wiki/love#Callbacks).
-- These include:
--
-- * game.load() (REQUIRED)
-- * game.update( dt ) (REQUIRED)
-- * game.draw() (REQUIRED)
-- * game.focus( f )
-- * game.mousefocus( f )
-- * game.visible( v )
-- * game.quit()
-- @other game

-- two test gamestates
local playState = require("game/gamestate_play")
local menuState = require("game/gamestate_menu")
local input

function game.load()
	input = getInput()
	
	signal.register( "SpawnLevelObject", function( level, object )
		-- spawn level objects
	end)

	signal.register( "Trigger", function( trigger, other, contact )
		-- handles triggers
	end)

	gamestate.switch( playState )
end

function game.update( dt )
	if (input:keyIsPressed("escape")) then 
		love.event.quit() 
		return 
	end
	
	gamestate.update(dt)
end

function game.draw()
	love.graphics.setBackgroundColor( 30, 30, 40 )
	love.graphics.clear()
	gamestate.drawStack()
end

function game.openMenu()
	gamestate.push( menuState )
end

function game.closeMenu()
	gamestate.pop()
end