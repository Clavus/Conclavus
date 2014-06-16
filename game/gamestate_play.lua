
local play = gamestate.new("play")
local gui, level, player, world, physics

function play:init()

	-- Create GUI
	gui = GUI()
	
	-- Create level with physics world
	
	level = Level(LevelData())
	
	love.physics.setMeter(level:getPixelsPerMeter())
	
	physics = Box2DPhysicsSystem( true )
	physics:initDefaultCollisionCallbacks()
	level:addPhysicsSystem( physics )
	
	world = physics:getWorld()
	world:setGravity(0, 300)
	
	-- Set up example
	player = level:createEntity("SpaceShip")
	player:setPos( 0, 0 )
	
	input:addMousePressCallback( "zoomin", MOUSE.WHEELUP, function()
		local cam = level:getCamera()
		local sx, sy = cam:getScale()
		cam:setScale( sx + 0.1 )
	end)
	
	input:addMousePressCallback( "zoomout", MOUSE.WHEELDOWN, function()
		local cam = level:getCamera()
		local sx, sy = cam:getScale()
		cam:setScale( sx - 0.1 )
	end)
	
	input:addMousePressCallback( "turn", MOUSE.RIGHT, function()
		level:getCamera():rotate( math.pi / 10 )
	end)
	
	-- Particle system test
	level:createEntity("ParticleSystem", "Black Hole")
	
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