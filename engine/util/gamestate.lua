------------------------
-- Gamestate management functions.
-- Based on [hump.gamestate](http://vrld.github.io/hump/#hump.gamestate).
-- @util gamestate

local gamestate = {}

local __NULL__ = __NULL__
 -- default gamestate produces error on every callback
local state_init = setmetatable({leave = __NULL__},
		{__index = function() error("Gamestate not initialized. Use Gamestate.switch()") end})
local stack = {state_init}

--- Create new gamestate.
-- @tparam[opt] table parent gamestate
-- @treturn table gamestate table
function gamestate.new(t)
	local base = table.copy(t) or {}
	base.init = base.init or __NULL__
	base.enter = base.enter or __NULL__
	base.leave = base.leave or __NULL__
	base.resume = base.resume or __NULL__
	return base
end

--- Switch to a gamestate.
-- Switching a gamestate will call the leave() callback on the current gamestate, replace the current gamestate with to, call the init() function if the state was not yet inialized and finally call enter(old_state, ...) on the new gamestate.
-- @tparam table to target gamestate
-- @tparam mixed ... parameters to pass to to:enter(current,...)
-- @treturn results of to:enter(current, ...)
function gamestate.switch(to, ...)
	assert(to, "Missing argument: Gamestate to switch to")
	assert(to ~= gamestate, "Can't call switch with colon operator")
	local pre = stack[#stack]
	pre.leave(pre)
	to.init(to)
	to.init = nil
	stack[#stack] = to
	return (to.enter or __NULL__)(to, pre, ...)
end

--- Push a new gamestate on the stack.
-- Pushes the to on top of the state stack, i.e. makes it the active state. Semantics are the same as switch(to, ...), except that leave() is not called on the previously active state.
-- Useful for pause screens, menus, etc.
-- @tparam table to target gamestate
-- @tparam mixed ... parameters to pass to to:enter(current,...)
-- @treturn results of to:enter(current, ...)
function gamestate.push(to, ...)
	assert(to, "Missing argument: Gamestate to switch to")
	assert(to ~= gamestate, "Can't call push with colon operator")
	local pre = stack[#stack]
	to.init(to)
	to.init = nil
	stack[#stack+1] = to
	return to.enter(to, pre, ...)
end

--- Pops the current state, switching back to the one below.
-- Calls leave() on the current state and then removes it from the stack, making the state below the current state and calls resume(...) on the activated state. Does not call enter() on the activated state.
-- @tparam mixed ... parameters to pass to the new state
-- @treturn mixed results of new_state:resume(...)
function gamestate.pop(...)
	assert(#stack > 1, "No more states to pop!")
	local pre, to = stack[#stack], stack[#stack-1] 
	stack[#stack] = nil
	pre.leave(pre)
	return to.resume(to, pre, ...)
end

--- Get current gamestate.
-- @treturn table current gamestate
function gamestate.current()
	return stack[#stack]
end

--- Draw all gamestates on the stack.
-- Calls the .draw() function of all gamestates on the stack, from bottom to top.
function gamestate.drawStack()
	for k=1, #stack do
		(stack[k].draw or __NULL__)()
	end
end

-- forward any undefined functions
setmetatable(gamestate, {__index = function(_, func)
	return function(...)
		return (stack[#stack][func] or __NULL__)(stack[#stack], ...)
	end
end})

return gamestate