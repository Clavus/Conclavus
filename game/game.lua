
local playState = require("game/gamestate_play")
local menuState = require("game/gamestate_menu")

function game.load()
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

function game.handleTrigger( trigger, other, contact, trigger_type, ...)
	-- function called by Trigger entities upon triggering. Return true to disable the trigger.
	return (gamestate.handleTrigger or nilfunction)( trigger, other, contact, trigger_type, ...)
end


function game.createLevelEntity( level, entData )
	return (gamestate.createLevelEntity or nilfunction)( level, entData )
end

function game.openMenu()
	gamestate.push( menuState )
end

function game.closeMenu()
	gamestate.pop()
end