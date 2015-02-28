------------------------
-- Several steering functions to help with physics interactions.
-- Credit to [ivan](http://www.love2d.org/forums/viewtopic.php?f=5&t=78537#p175033)
-- @util steering
-- @usage
-- -- current linear velocity
-- local cvx, cvy = body:GetLinearVelocity()
--
-- -- target linear velocity required to counteract the effects of gravity and linear damping:
-- local lvx, lvy = steering.compensateGravity(0, 0, gx, gy, interval)
-- lvx, lvy = steering.compensateLinearDamping(lvx, lvy, damping, maxLV, interval)
--
-- -- force required to reach the target linear velocity
-- local fx, fy = steering.force(cvx, cvy, lvx, lvy, mass, interval)
--
-- -- keep the body aloft using only forces
-- body:ApplyForce(fx, fy)

local steering = {}

--- Returns the future position assuming no external forces are acting on the body
-- @number x x position at the beginning of the time step
-- @number y y position at the beginning of the time step
-- @number lvx linear velocity (x) at the beginning of the time step
-- @number lvy linear velocity (y) at the beginning of the time step
-- @number damping linear damping
-- @number gx gravity (x)
-- @number gy gravity (y)
-- @number dt time step
-- @treturn number x position at the end of the time step
-- @treturn number y position at the end of the time step
function steering.futurePosition(x, y, lvx, lvy, damping, gx, gy, dt)
	-- integrate gravity
	local fpx = lvx + gx*dt
	local fpy = lvy + gy*dt
	-- apply damping
	local d = 1 - dt*damping
	if d < 0 then
		d = 0
	elseif d > 1 then
		d = 1
	end
	return fpx*d + x, fpy*d + y
end

--- Returns the future angle assuming no external forces are acting on the body
-- @number a angle at the beginning of the time step
-- @number av angular velocity at the beginning of the time step
-- @number damping linear damping
-- @number dt time step
-- @treturn number future angle at the end of the time step
function steering.futureAngle(a, av, damping, dt)	
  -- apply damping
  local d = 1 - dt*damping	
  if d < 0 then
    d = 0
  elseif d > 1 then
    d = 1
  end	
  return av*d + a	
end

--- Compensates for the effects of gravity
-- @number lvx desired linear velocity (x) at the end of the time step
-- @number lvy desired linear velocity (y) at the end of the time step
-- @number gx gravity (x)
-- @number gy gravity (y)
-- @number dt time step
-- @treturn number target linear velocity (x) at the beginning of the time step
-- @treturn number target linear velocity (y) at the beginning of the time step
function steering.compensateGravity(lvx, lvy, gx, gy, dt)	
  return lvx - gx*dt, lvy - gy*dt	
end

--- Compensates for the effects of linear damping
-- @number lvx desired linear velocity (x) at the end of the time step
-- @number lvy desired linear velocity (y) at the end of the time step
-- @number damping linear damping
-- @number maxLV maximum linear velocity (length)
-- @number dt time step
-- @treturn number target linear velocity (x) at the beginning of the time step
-- @treturn number target linear velocity (y) at the beginning of the time step
function steering.compensateLinearDamping(lvx, lvy, damping, maxLV, dt)	
  local d = 1 - dt*damping	
  if d <= 0 then
    local lv = math.sqrt(lvx*lvx + lvy*lvy)
    local nx, ny = lvx/lv, lvy/lv
    return nx*maxLV, ny*maxLV
  elseif d > 1 then
    d = 1
  end	
  return lvx/d, lvy/d	
end

--- Compensates for the effects of angular damping
-- @number av desired angular velocity at the end of the time step
-- @number damping linear damping
-- @number maxAV Maximum angular velocity
-- @number dt time step
-- @treturn number target angular velocity at the beginning of the time step
function steering.compensateAngularDamping(av, damping, maxAV, dt)	
  local d = 1 - dt*damping	
  if d <= 0 then
    if av < 0 then
      return -maxAV
    else
      return maxAV
    end
  elseif d > 1 then
    d = 1
  end	
  return av/d	
end

--- Returns the force required to reach a given linear velocity.
-- Reminder: force = ( change in velocity / time ) * mass
-- @number ivx linear velocity (x) at the beginning of the time step
-- @number ivy linear velocity (y) at the beginning of the time step
-- @number fvx desired linear velocity (x) at the end of the time step
-- @number fvy desired linear velocity (y) at the end of the time step
-- @number mass mass
-- @number dt time step
-- @treturn number force to apply
function steering.force(ivx, ivy, fvx, fvy, mass, dt)	
  return (fvx - ivx)/dt*mass, (fvy - ivy)/dt*mass	
end

--- Returns the torque required to reach a given angular velocity.
-- Reminder: inertia = mass * initial velocity,
-- torque = ( change in velocity / time ) * inertia
-- @number iv angular velocity at the beginning of the time step
-- @number fv angular velocity at the end of the time step
-- @number mass mass
-- @number dt time step
-- @treturn number torque to apply
function steering.torque(iv, fv, mass, dt)
  local inertia = mass*iv
  return (fv - iv)/dt*inertia	
end

--- Returns the time required to accelerate to a given linear velocity.
-- Reminder: time = change in velocity * mass / force
-- @number ivx linear velocity (x) at the beginning of the time step
-- @number ivy linear velocity (y) at the beginning of the time step
-- @number fvx desired linear velocity (x) at the end of the time step
-- @number fvy desired linear velocity (y) at the end of the time step
-- @number mass mass
-- @number force force being applied
-- @treturn number time
function steering.accelerationTime(ivx, ivy, fvx, fvy, mass, force)	
  -- change in velocity
  local dx, dy = fvx - ivx, fvy - ivy
  local d = math.sqrt(dx*dx + dy*dy)
  return d*mass/force	
end

--- Returns the time required to accelerate to a given angular velocity.
-- Reminder: inertia = mass * initial velocity, 
-- time = change in velocity * inertia / torque
-- @number iv angular velocity at the beginning of the time step
-- @number fv desired angular velocity at the end of the time step
-- @number mass mass
-- @number torque torque being applied
-- @treturn number time
function steering.angularAccelerationTime(iv, fv, mass, torque)	
  local inertia = mass*iv
  return (fv - iv)*inertia/torque	
end

return steering
