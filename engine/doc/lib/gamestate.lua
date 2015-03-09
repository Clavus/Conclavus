------------------------
-- Gamestate lib.
-- Based on [hump.gamestate](http://vrld.github.io/hump/#hump.gamestate).
-- @lib gamestate

local gamestate = {}

--- Create a new gamestate.
-- @tparam[opt] table t parent gamestate table
-- @treturn table new gamestate
function gamestate.new(t)
end

--- Switch to a gamestate.
-- Switching a gamestate will call the leave() callback on the current gamestate, replace the current gamestate with to, call the init() function if the state was not yet inialized and finally call enter(old_state, ...) on the new gamestate.
-- @tparam gamestate to target gamestate
-- @tparam mixed ... parameters to pass to to:enter(current,...)
-- @treturn results of to:enter(current, ...)
function gamestate.switch(to, ...)
end

--- Push a new gamestate on the stack.
-- Pushes the to on top of the state stack, i.e. makes it the active state. Semantics are the same as switch(to, ...), except that leave() is not called on the previously active state.
-- Useful for pause screens, menus, etc.
-- @tparam gamestate to target gamestate
-- @tparam mixed ... parameters to pass to to:enter(current,...)
-- @treturn results of to:enter(current, ...)
function gamestate.push(to, ...)
end

--- Pops the current state, switching back to the one below.
-- Calls leave() on the current state and then removes it from the stack, making the state below the current state and calls resume(...) on the activated state. Does not call enter() on the activated state.
-- @tparam mixed ... parameters to pass to the new state
-- @treturn mixed results of new_state:resume(...)
function gamestate.pop(...)
end

--- Get current gamestate.
-- @treturn gamestate current gamestate
function gamestate.current()
end

-- Not used in this framework. Callbacks are done manually.
function gamestate.registerEvents(callbacks)
end

--- Additional draw function not in the hump.gamestate lib.
-- Calls the draw function of all gamestates on the stack, from bottom to top.
function gamestate.drawStack()
end