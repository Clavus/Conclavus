--[[
Copyright (c) 2010-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

--[[ 
Altered by Clavus to suit his needs

DIFFERENCES:
* No registering events. All undefined functions are forwarded. 
  So calling gamestate.update(dt) calls update(dt) on top gamestate.
* Added gamestate.set( to, ... ). Pops all gamestates on the stack and
  then switches to the given gamestate.
* Added gamestate.drawStack(). Calls the draw() function on all gamestates
  in the stack, in ascending order.
]]--

local function __NULL__() end

 -- default gamestate produces error on every callback
local state_init = setmetatable({leave = __NULL__},
		{__index = function() error("Gamestate not initialized. Use Gamestate.switch()") end})
local stack = {state_init}

local GS = {}
function GS.new(name) return { name = (name or "undefined") } end -- constructor

function GS.switch(to, ...)
	assert(to, "Missing argument: Gamestate to switch to")
	local pre = stack[#stack]
	;(pre.leave or __NULL__)(pre)
	;(to.init or __NULL__)(to)
	to.init = nil
	stack[#stack] = to
	
	print("Gamestate switched to "..to.name)
	
	return (to.enter or __NULL__)(to, pre, ...)
end

function GS.push(to, ...)
	assert(to, "Missing argument: Gamestate to switch to")
	local pre = stack[#stack]
	;(to.init or __NULL__)(to)
	to.init = nil
	stack[#stack+1] = to
	
	print("Gamestate pushed to "..to.name)
	
	return (to.enter or __NULL__)(to, pre, ...)
end

function GS.pop()
	assert(#stack > 1, "No more states to pop!")
	local pre = stack[#stack]
	stack[#stack] = nil
	
	print("Gamestate popped back to "..stack[#stack].name)
	
	return (pre.leave or __NULL__)(pre)
end

function GS.current()
	return stack[#stack]
end

--[[ Old system: registers all love callbacks

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
]]--

-- Clavus stuff start --

function GS.drawStack()

	for _, v in ipairs( stack ) do
		(v.draw or __NULL__)(v)
	end

end

function GS.set(to, ...)
	
	while(#stack > 1) do
		GS.pop()
	end
	
	GS.switch(to, ...)

end

function GS.printStack()
	
	local names = {}
	for _, v in ipairs( stack ) do
		table.insert(names, v.name)
	end
	
	print("Gamestate stack (ascending order): "..table.concat(names, ", "))

end

-- Clavus stuff end --

-- forward any undefined functions
setmetatable(GS, {__index = function(_, func)
	return function(...)
		return (stack[#stack][func] or __NULL__)(stack[#stack], ...)
	end
end})

return GS