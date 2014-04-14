
local playState = require("game/gamestate_play")
local menuState = require("game/gamestate_menu")

function game.load()

	gamestate.set( playState )
	
end

function game.update( dt )
	
	if (input:keyIsPressed("escape")) then love.event.quit() return end
	if (input:keyIsPressed("r")) then 
		local res = package.hotswap("SpaceShip")
		print("Hotswapped "..tostring(res))
	end
	
	gamestate.update( dt )
	
end

function game.draw()
	
	gamestate.drawStack()
	
end

function game.handleTrigger( trigger, other, contact, trigger_type, ...)
	
	-- function called by Trigger entities upon triggering. Return true to disable the trigger.
	return gamestate.handleTrigger( trigger, other, contact, trigger_type, ...)
	
end