
function game.load()
	
	-- Create GUI
	gui = GUI()
	
	-- Create level with physics world
	level = Level(LevelData(), true)
	level:setCollisionCallbacks(game.collisionBeginContact, game.collisionEndContact, game.collisionPreSolve, game.collisionPostSolve)
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
	
	gui:draw()
	level:draw()
	
end

-- Collision callbacks for physics world
function game.collisionBeginContact(a, b, contact)
	
	local ao, bo = a:getUserData(), b:getUserData()
	if (not ao or not bo) then return end
	
	if (ao and includes(mixin.CollisionResolver, ao.class)) then
		ao:beginContactWith(bo, contact, a, b, true)
	end

	if (bo and includes(mixin.CollisionResolver, bo.class)) then
		bo:beginContactWith(ao, contact, b, a, false)
	end
	
end

function game.collisionEndContact(a, b, contact)

	local ao, bo = a:getUserData(), b:getUserData()
	if (not ao or not bo) then return end
	
	if (ao and includes(mixin.CollisionResolver, ao.class)) then
		ao:endContactWith(bo, contact, a, b, true)
	end

	if (bo and includes(mixin.CollisionResolver, bo.class)) then
		bo:endContactWith(ao, contact, b, a, false)
	end
	
end

function game.collisionPreSolve(a, b, contact)

	local ao, bo = a:getUserData(), b:getUserData()
	if (not ao or not bo) then return end
	
	if (ao and includes(mixin.CollisionResolver, ao.class)) then
		ao:preSolveWith(bo, contact, a, b, true)
	end

	if (bo and includes(mixin.CollisionResolver, bo.class)) then
		bo:preSolveWith(ao, contact, b, a, false)
	end
	
end

function game.collisionPostSolve(a, b, contact)

	local ao, bo = a:getUserData(), b:getUserData()
	if (not ao or not bo) then return end
	
	if (ao and includes(mixin.CollisionResolver, ao.class)) then
		ao:postSolveWith(bo, contact, a, b, true)
	end

	if (bo and includes(mixin.CollisionResolver, bo.class)) then
		bo:postSolveWith(ao, contact, b, a, false)
	end
	
end
