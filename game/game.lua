
local player, world

function game.load()
	
	-- Create GUI
	gui = GUI()
	
	-- Create level with physics world
	level = Level(LevelData(), true)
	level:useDefaultCollisionCallbacks()
	
	world = level:getPhysicsWorld()
	world:setGravity(0, 300)
	
	-- Set up example
	player = level:createEntity("SpaceShip")
	player:setPos( 0, 0 )
	
end

function game.update( dt )
	
	if (input:keyIsPressed("escape")) then love.event.quit() return end
	
	level:update( dt )
	gui:update( dt )
	
end

function game.draw()
	
	level:draw()
	gui:draw()
	
end

function game.handleTrigger( trigger, other, contact, trigger_type, ...)
	
	-- function called by Trigger entities upon triggering. Return true to disable the trigger.
	return true
	
end