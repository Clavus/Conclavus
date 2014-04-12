
local play = gamestate.new("play")
local gui, level, player, world

function play:init()

	-- Create GUI
	gui = GUI()
	
	-- Create level with physics world
	level = Level(LevelData(), true)
	world = level:getPhysicsWorld()
	world:setGravity(0, 300)
	
	-- Set up example
	player = level:createEntity("SpaceShip")
	player:setPos( 0, 0 )
	
end

function play:enter()

end

function play:leave()

end

function play:update( dt )
	
	level:update( dt )
	gui:update( dt )
	
end

function play:draw()
	
	level:draw()
	gui:draw()
	
end

return play