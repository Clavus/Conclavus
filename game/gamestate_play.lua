
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
	
	level:getCamera():draw( function()
		
		love.graphics.setColor( Color.Red:unpack() )
		love.graphics.line( 0, 0, 10, 0 )
		love.graphics.line( 0, 0, 0, 10 )
		love.graphics.setColor( Color.White:unpack() )
		
	end)
	
	local mx, my = screen.getMousePosition()
	local mwx, mwy = level:getCamera():getMouseWorldPos()
	love.graphics.setColor( Color.White:unpack() )
	love.graphics.print( "["..math.round(mwx)..", "..math.round(mwy).."]", mx + 8, my )
	
end

return play