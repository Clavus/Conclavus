------------------------
-- PhysicsSystem class.
-- Manages a physics Box2D physics [World](https://www.love2d.org/wiki/World). Automatically created if you set physics.active = true in the @{LevelData} passed to a @{Level}.
-- 
-- Derived from @{Object}.
-- @cl PhysicsSystem

local PhysicsSystem = class("PhysicsSystem")
local beginContact, endContact, preSolve, postSolve

function PhysicsSystem:initialize( allowsleep )
	if (allowsleep == nil) then allowsleep = true end
	self._world = love.physics.newWorld(0, 0, allowsleep )
	self._world:setCallbacks( beginContact, endContact, preSolve, postSolve )
end

--- Update physics system. The @{Level} object handles this itself.
-- @number dt delta time
function PhysicsSystem:update( dt )
	self._world:update( dt )
end

--- Get physics world object. Use @{Level.getPhysicsWorld} when using a @{Level} object.
-- @treturn World [physics world](https://www.love2d.org/wiki/World)
function PhysicsSystem:getWorld()
	return self._world
end

--- Set your own callbacks for collision solvers.
-- See [World:setCallbacks](https://www.love2d.org/wiki/World:setCallbacks) for more info. Note that setting these yourself overrides the functionality of the @{CollisionResolver} mixin.
-- @tparam function beginContact
-- @tparam function endContact
-- @tparam function preSolve
-- @tparam function postSolve
function PhysicsSystem:setCallbacks( beginContact, endContact, preSolve, postSolve )
	self._world:setCallbacks( beginContact, endContact, preSolve, postSolve )
end

-- Default collision callbacks
beginContact = function(a, b, contact)
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

endContact = function(a, b, contact)
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

preSolve = function(a, b, contact)
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

postSolve = function(a, b, contact)
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
	
	
return PhysicsSystem