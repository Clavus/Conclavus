
local playState = require("game/gamestate_play")
local menuState = require("game/gamestate_menu")

function game.load()

	gamestate.set( playState )
	
end

function game.update( dt )
	
	if (input:keyIsPressed("escape")) then love.event.quit() return end
	
	if (input:keyIsPressed("t")) then
		local parentframe = loveframes.Create("frame")
 
		-- method 1 using loveframes.Create
		local button1 = loveframes.Create("button", parentframe)
		button1:SetPos(5, 35)
		
	end
	
	gamestate.update( dt )
	
end

function game.draw()
		
	love.graphics.setBackgroundColor( 30, 30, 40 )
	love.graphics.clear()
	gamestate.drawStack()
	
end

function game.handleTrigger( trigger, other, contact, trigger_type, ...)
	
	-- function called by Trigger entities upon triggering. Return true to disable the trigger.
	return gamestate.handleTrigger( trigger, other, contact, trigger_type, ...)
	
end