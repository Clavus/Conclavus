------------------------
-- PhysicsSystem class.
-- Manages a physics Box2D physics [World](https://www.love2d.org/wiki/World). Automatically created if you set physics.active = true in the @{LevelData} passed to a @{Level}.
-- @cl PhysicsSystem

local PhysicsSystem = class("PhysicsSystem")

function PhysicsSystem:initialize( allowsleep )
	if (allowsleep == nil) then allowsleep = true end
	self._world = love.physics.newWorld(0, 0, allowsleep )
end

function PhysicsSystem:update( dt )
	self._world:update( dt )
end

function PhysicsSystem:getWorld()
	return self._world
end

function PhysicsSystem:setCallbacks( beginContact, endContact, preSolve, postSolve )
	self._world:setCallbacks( beginContact, endContact, preSolve, postSolve )
end

function PhysicsSystem:initDefaultCollisionCallbacks()
	local CollisionResolver = CollisionResolver
	local beginContact = function(a, b, contact)
		local ao = a:getUserData() or a:getBody():getUserData()
		local bo = b:getUserData() or b:getBody():getUserData()
		if (not ao or not bo or not ao.class or not bo.class) then return end
		if (ao.class:includes(CollisionResolver)) then
			ao:beginContactWith(bo, contact, a, b, true)
		end
		if (bo.class:includes(CollisionResolver)) then
			bo:beginContactWith(ao, contact, b, a, false)
		end
	end

	local endContact = function(a, b, contact)
		local ao = a:getUserData() or a:getBody():getUserData()
		local bo = b:getUserData() or b:getBody():getUserData()
		if (not ao or not bo or not ao.class or not bo.class) then return end
		if (ao.class:includes(CollisionResolver)) then
			ao:endContactWith(bo, contact, a, b, true)
		end
		if (bo.class:includes(CollisionResolver)) then
			bo:endContactWith(ao, contact, b, a, false)
		end
	end

	local preSolve = function(a, b, contact)
		local ao = a:getUserData() or a:getBody():getUserData()
		local bo = b:getUserData() or b:getBody():getUserData()
		if (not ao or not bo or not ao.class or not bo.class) then return end
		if (ao.class:includes(CollisionResolver)) then
			ao:preSolveWith(bo, contact, a, b, true)
		end
		if (bo.class:includes(CollisionResolver)) then
			bo:preSolveWith(ao, contact, b, a, false)
		end
	end

	local postSolve = function(a, b, contact)
		local ao = a:getUserData() or a:getBody():getUserData()
		local bo = b:getUserData() or b:getBody():getUserData()
		if (not ao or not bo or not ao.class or not bo.class) then return end
		if (ao.class:includes(CollisionResolver)) then
			ao:postSolveWith(bo, contact, a, b, true)
		end
		if (bo.class:includes(CollisionResolver)) then
			bo:postSolveWith(ao, contact, b, a, false)
		end
	end
	self._world:setCallbacks( beginContact, endContact, preSolve, postSolve )
end

return PhysicsSystem