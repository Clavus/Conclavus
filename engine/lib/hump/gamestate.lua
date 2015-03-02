
local function __NULL__() end

 -- default gamestate produces error on every callback
local state_init = setmetatable({leave = __NULL__},
		{__index = function() error("Gamestate not initialized. Use Gamestate.switch()") end})
local stack = {state_init}

local GS = {}
function GS.new(t) return t or {} end -- constructor - deprecated!

function GS.switch(to, ...)
	assert(to, "Missing argument: Gamestate to switch to")
	assert(to ~= GS, "Can't call switch with colon operator")
	local pre = stack[#stack]
	;(pre.leave or __NULL__)(pre)
	;(to.init or __NULL__)(to)
	to.init = nil
	stack[#stack] = to
	return (to.enter or __NULL__)(to, pre, ...)
end

function GS.push(to, ...)
	assert(to, "Missing argument: Gamestate to switch to")
	assert(to ~= GS, "Can't call push with colon operator")
	local pre = stack[#stack]
	;(to.init or __NULL__)(to)
	to.init = nil
	stack[#stack+1] = to
	return (to.enter or __NULL__)(to, pre, ...)
end

function GS.pop(...)
	assert(#stack > 1, "No more states to pop!")
	local pre, to = stack[#stack], stack[#stack-1] 
	stack[#stack] = nil
	;(pre.leave or __NULL__)(pre)
	return (to.resume or __NULL__)(to, pre, ...)
end

function GS.current()
	return stack[#stack]
end

local all_callbacks = {
	'draw', 'errhand', 'focus', 'keypressed', 'keyreleased', 'mousefocus',
	'mousepressed', 'mousereleased', 'quit', 'resize', 'textinput',
	'threaderror', 'update', 'visible', 'gamepadaxis', 'gamepadpressed',
	'gamepadreleased', 'joystickadded', 'joystickaxis', 'joystickhat',
	'joystickpressed', 'joystickreleased', 'joystickremoved'
}

function GS.registerEvents(callbacks)
	local registry = {}
	callbacks = callbacks or all_callbacks
	for _, f in ipairs(callbacks) do
		registry[f] = love[f] or __NULL__
		love[f] = function(...)
			registry[f](...)
			return GS[f](...)
		end
	end
end

function GS.drawStack()
	for k=1, #stack do
		(stack[k].draw or __NULL__)()
	end
end

-- forward any undefined functions
setmetatable(GS, {__index = function(_, func)
	return function(...)
		return (stack[#stack][func] or __NULL__)(stack[#stack], ...)
	end
end})

return GS