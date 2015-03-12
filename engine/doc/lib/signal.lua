------------------------
-- Signal library.
-- Based on [hump.signal](http://vrld.github.io/hump/#hump.signal).
-- @lib signal

-- THIS IS A FAKE IMPLEMENTATION JUST TO ASSIST DOCUMENTATION GENERATION. DO NOT INCLUDE IN THE FRAMEWORK.

--- Creates a new signal registry that is independent of the default registry.
-- @treturn table new signal registery
function signal.new()
end

--- Creates a new signal registry that is independent of the default registry.
-- @string signal signal identifier
-- @tparam function func function to register
-- @treturn function function handle
function signal.register(signal, func)
end

--- Calls all functions bound to the specified signal with the supplied arguments.
-- @string signal signal identifier
-- @tparam mixed ... function parameters
function signal.emit(signal, ...)
end

--- Unbinds (removes) functions from the specified signal.
-- @string signal signal identifier
-- @tparam functions ... list of function handles to remove
function signal.remove(signal)
end

--- Removes all functions from the specified signal.
-- @string signal signal identifier
function signal.clear(signal)
end

--- Calls all functions bound to the signals matching the [string pattern](http://www.lua.org/manual/5.1/manual.html#5.4.1).
-- @string pattern signal identifier pattern
-- @tparam mixed ... function parameters
function signal.emit_pattern(pattern, ...)
end

--- Unbinds (removes) functions from the signals matching the [string pattern](http://www.lua.org/manual/5.1/manual.html#5.4.1).
-- @string signal signal identifier pattern
-- @tparam functions ... list of function handles to remove
function signal.remove_pattern(pattern)
end

--- Removes all functions from the signals matching the [string pattern](http://www.lua.org/manual/5.1/manual.html#5.4.1).
-- @string signal signal identifier pattern
function signal.clear_pattern(pattern)
end