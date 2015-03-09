------------------------
-- Input controller.
-- Enables you to check for various input, add callbacks to certain input, bind input to actions, etc.
-- 
-- Derived from @{Object}.
-- @cl InputController

--- @type InputController
local InputController = class("InputController")

-- cache functions
local pairs, currentTime = pairs, currentTime

--[[
Input controller

bool	InputController:keyIsPressed(key)
bool	InputController:keyIsReleased(key)
bool	InputController:keyIsDown(key)
bool	InputController:mouseIsPressed(button)				-- button = l, r, m, wd, wu, x1, x2
bool	InputController:mouseIsReleased(button)
bool	InputController:mouseIsDown(button)
bool	InputController:gamepadIsPressed(joystick, button)		-- joystick = Joystick object
bool	InputController:gamepadIsReleased(joystick, button)
bool	InputController:gamepadIsDown(joystick, button)
num		InputController:gamepadAxisValue(joystick, axis)

void	InputController:addKeyPressCallback(id, key, callback) 		-- callback = function(key)
void	InputController:addKeyReleaseCallback(id, key, callback) 	-- callback = function(key, timediff)
void	InputController:addMousePressCallback(id, button, callback) 	-- callback = function(button)
void	InputController:addMouseReleaseCallback(id, button, callback) 	-- callback = function(button, timediff)
void	InputController:addGamepadPressCallback(id, button, callback) 	-- callback = function(joystick, button)
void	InputController:addGamepadReleaseCallback(id, button, callback) -- callback = function(joystick, button, timediff)
void	InputController:addGamepadAxisCallback(id, axis, callback)	-- callback = function(joystick, axis, value)
void	InputController:removeKeyPressCallback(id)
void	InputController:removeKeyReleaseCallback(id)
void	InputController:removeMousePressCallback(id)
void	InputController:removeMouseReleaseCallback(id)
void	InputController:removeGamepadAxisCallback(id)

void	InputController:registerAction( action )			-- register an action for input binding
void	InputController:bindActionToKey( action, key )			-- bind specified keyboard key to action
void	InputController:bindActionToMouse( action, btn )		-- idem mouse buttons
void	InputController:bindActionToGamepad( action, btn)		-- idem gamepad buttons
void	InputController:unbindActionFromKey( action, [key] )		-- unbind specified key from action, or if left blank, unbind all keys that trigger action
void	InputController:unbindActionFromMouse( action, [btn] )		-- idem mouse buttons
void	InputController:unbindActionFromGamepad( action, [btn]) 	-- idem gamepad buttons

void	InputController:actionIsPressed(action)
void	InputController:actionIsReleased(action)
void	InputController:actionIsDown(action)

void	InputController:addActionPressCallback(id, action, callback) 	-- callback = function(input_type, input, joystick) 
									-- 	input_type = "key", "mouse" or "gamepad", input = key/button pressed
									-- joystick object passed if triggered by gamepad
void	InputController:addActionReleaseCallback(id, action, callback) 	-- callback = function(type, input, timediff, joystick)
void	InputController:removeActionPressCallback(id)
void	InputController:removeActionReleaseCallback(id)
]]--

function InputController:initialize()	
	self._keysdown = {}
	self._keyspressed = {}
	self._keysreleased = {}
	self._mousedown = {}
	self._mousepressed = {}
	self._mousereleased = {}
	self._gamepaddown = {}
	self._gamepadpressed = {}
	self._gamepadreleased = {}
	self._gamepadaxis = {}		
	self._keypresscalls = {}
	self._keyreleasecalls = {}
	self._mousepresscalls = {}
	self._mousereleasecalls = {}
	self._gamepadpresscalls = {}
	self._gamepadreleasecalls = {}
	self._gamepadaxiscalls = {}	
	self._actions = {}	
	self._actionbinds = { 
							actions = {},
							keys = {},
							mouse = {},
							gamepad = {}
						}
	self._actiondown = {}
	self._actionpressed = {}
	self._actionreleased = {}	
	self._actionpresscalls = {}
	self._actionreleasecalls = {}
	
end

function InputController:clear()
	self._keyspressed = {}
	self._keysreleased = {}
	self._mousepressed = {}
	self._mousereleased = {}
	self._gamepadpressed = {}
	self._gamepadreleased = {}
	self._actionpressed = {}
	self._actionreleased = {}
end

--------------------------------------------------
-------------- Handling actions ------------------
--------------------------------------------------

function InputController:registerAction( action )	
	assert(not table.hasValue( self._actions, action ), "Action '"..action.."' is already registered!")
	table.insert( self._actions, action )	
end

function InputController:bindActionToKey( action, key )	
	assert(table.hasValue( self._actions, action ), "Action '"..action.."' is unknown! Be sure to register actions first.")
	self._actionbinds.actions[action] = self._actionbinds.actions[action] or { mouse = {}, keys = {}, gamepad = {} }
	self._actionbinds.keys[key] = self._actionbinds.keys[key] or {}
	table.insert( self._actionbinds.actions[action].keys, key )
	table.insert( self._actionbinds.keys[key], action )
end

function InputController:bindActionToMouse( action, btn )	
	assert(table.hasValue( self._actions, action ), "Action '"..action.."' is unknown! Be sure to register actions first.")
	self._actionbinds.actions[action] = self._actionbinds.actions[action] or { mouse = {}, keys = {}, gamepad = {} }
	self._actionbinds.mouse[btn] = self._actionbinds.mouse[btn] or {}	
	table.insert( self._actionbinds.actions[action].mouse, btn )
	table.insert( self._actionbinds.mouse[btn], action )	
end

function InputController:bindActionToGamepad( action, btn )	
	assert(table.hasValue( self._actions, action ), "Action '"..action.."' is unknown! Be sure to register actions first.")
	self._actionbinds.actions[action] = self._actionbinds.actions[action] or { mouse = {}, keys = {}, gamepad = {} }
	self._actionbinds.gamepad[btn] = self._actionbinds.gamepad[btn] or {}	
	table.insert( self._actionbinds.actions[action].mouse, btn )
	table.insert( self._actionbinds.gamepad[btn], action )	
end

function InputController:unbindActionFromKey( action, key  )
	assert(table.hasValue( self._actions, action ), "Action '"..action.."' is unknown!")
	if (self._actionbinds.actions[action] == nil or #self._actionbinds.actions[action].keys == 0) then return end	
	if (key ~= nil) then
		table.removeByValue( self._actionbinds.actions[action].keys, key )
		table.removeByValue( self._actionbinds.keys[key], action )
	else
		-- remove all keys bound to action
		self._actionbinds.actions[action].keys = {}
		for k, v in ipairs( self._actionbinds.keys ) do
			table.removeByValue( self._actionbinds.keys[k], action )
		end
	end
end

function InputController:unbindActionFromMouse( action, btn )	
	assert(table.hasValue( self._actions, action ), "Action '"..action.."' is unknown!")
	if (self._actionbinds.actions[action] == nil or #self._actionbinds.actions[action].mouse == 0) then return end	
	if (btn ~= nil) then
		table.removeByValue( self._actionbinds.actions[action].mouse, btn )
		table.removeByValue( self._actionbinds.mouse[btn], action )
	else
		-- remove all mouse buttons bound to action
		self._actionbinds.actions[action].mouse = {}
		for k, v in ipairs( self._actionbinds.mouse ) do
			table.removeByValue( self._actionbinds.mouse[k], action )
		end
	end	
end

function InputController:unbindActionFromGamepad(  action, btn )	
	assert(table.hasValue( self._actions, action ), "Action '"..action.."' is unknown!")
	if (self._actionbinds.actions[action] == nil or #self._actionbinds.actions[action].gamepad == 0) then return end
	if (btn ~= nil) then
		table.removeByValue( self._actionbinds.actions[action].gamepad, btn )
		table.removeByValue( self._actionbinds.gamepad[btn], action )
	else
		-- remove all gamepad buttons bound to action
		self._actionbinds.actions[action].gamepad = {}
		for k, v in ipairs( self._actionbinds.gamepad ) do
			table.removeByValue( self._actionbinds.gamepad[k], action )
		end
	end
end

----------------------------------------------------
-------------- Handling raw input ------------------
----------------------------------------------------

local function inputPressed(input_object, input_type, input, tab_press, tab_down, tab_calls, tab_binds, joystick)	
	tab_press[input] = true
	tab_down[input] = { time = currentTime() }	
	if (tab_calls[input]) then
		for k, v in pairs(tab_calls[input]) do
			if (input_type == "gamepad") then v(joystick, input)
			else v(input) end
		end
	end	
	-- handle actions
	local actions = tab_binds[input]
	if (actions == nil) then return end
	--print("Pressed "..input..", actions: "..table.toString(actions, "actions", false))
	
	for k, action in ipairs( actions ) do
		input_object._actionpressed[action] = true
		input_object._actiondown[action] = { time = currentTime() }
		if (input_object._actionpresscalls[action]) then
			for k, v in pairs(input_object._actionpresscalls[action]) do
				if (input_type == "gamepad") then v(input_type, input, joystick)
				else v(input_type, input) end
			end
		end
	end
end

local function inputReleased(input_object, input_type, input, tab_released, tab_down, tab_calls, tab_binds, joystick)
	tab_released[input] = true
	if (tab_calls[input] and tab_down[input]) then
		for k, v in pairs(tab_calls[input]) do
			if (input_type == "gamepad") then v(joystick, input, currentTime() - tab_down[input].time)
			else v(input, currentTime() - tab_down[input].time) end
		end
	end
	tab_down[input] = nil
	-- handle actions
	local actions = tab_binds[input]
	if (actions == nil) then return end
	
	for k, action in ipairs( actions ) do
		input_object._actionreleased[action] = true
		input_object._actiondown[action] = nil
		if (input_object._actionreleasecalls[action] and input_object._actiondown[action]) then
			for k, v in pairs(input_object._actionreleasecalls[action]) do
				if (input_type == "gamepad") then v(input_type, input, currentTime() - input_object._actiondown[input].time, joystick)
				else v(input_type, input, currentTime() - self._actiondown[input].time) end
				
			end
		end
		input_object._actiondown[action] = nil
	end
end


function InputController:handle_keypressed(key, unicode)
	inputPressed(self, "key", key, self._keyspressed, self._keysdown, self._keypresscalls, self._actionbinds.keys )
end

function InputController:handle_keyreleased(key, unicode)
	inputReleased(self, "key", key, self._keysreleased, self._keysdown, self._keyreleasecalls, self._actionbinds.keys)
end

function InputController:handle_mousepressed(x, y, button)
	inputPressed(self, "mouse", button, self._mousepressed, self._mousedown, self._mousepresscalls, self._actionbinds.mouse )
end

function InputController:handle_mousereleased(x, y, button)
	inputReleased(self, "mouse", button, self._mousereleased, self._mousedown, self._mousereleasecalls, self._actionbinds.mouse )
end

function InputController:handle_gamepadpressed(joystick, button)
	local id = joystick:getID()
	self._gamepadpressed[id] = self._gamepadpressed[id] or {}
	self._gamepaddown[id] = self._gamepaddown[id] or {}
	inputPressed(self, "gamepad", button, self._gamepadpressed[id], self._gamepaddown[id], self._gamepadpresscalls, self._actionbinds.gamepad, joystick )
end

function InputController:handle_gamepadreleased(joystick, button)
	local id = joystick:getID()
	self._gamepadreleased[id] = self._gamepadreleased[id] or {}
	self._gamepaddown[id] = self._gamepaddown[id] or {}
	inputReleased(self, "gamepad", button, self._gamepadreleased[id], self._gamepaddown[id], self._gamepadreleasecalls, self._actionbinds.gamepad, joystick )
end

function InputController:handle_gamepadaxis( joystick, axis, value )
	local id = joystick:getID()
	self._gamepadaxis[id] = self._gamepadaxis[id] or {}
	self._gamepadaxis[id][axis] = value
	if (self._gamepadaxiscalls[axis]) then
		for k, v in pairs(self._gamepadaxiscalls[axis]) do
			v(joystick, axis, value)
		end
	end
end

function InputController:handle_gamepadadded(joystick)
	local id = joystick:getID()
	self._gamepadpressed[id] = {}
	self._gamepadreleased[id] = {}
	self._gamepaddown[id] = {}
	self._gamepadaxis[id] = {}
end

function InputController:handle_gamepadremoved(joystick)
	local id = joystick:getID()
	self._gamepadpressed[id] = nil
	self._gamepadreleased[id] = nil
	self._gamepaddown[id] = nil
	self._gamepadaxis[id] = nil
end

-------------------------------------------------
-------------- Input checking -------------------
-------------------------------------------------

local function inputCheck(tab, inp)
	if (tab == nil) then return false end
	if (tab[inp]) then return true
	else return false end
end

function InputController:keyIsPressed(key)
	return inputCheck(self._keyspressed, key)
end

function InputController:keyIsReleased(key)
	return inputCheck(self._keysreleased, key)
end

function InputController:keyIsDown(key)
	return (self._keysdown[key] ~= nil)
end

function InputController:mouseIsPressed(button)
	return inputCheck(self._mousepressed, button)
end

function InputController:mouseIsReleased(button)
	return inputCheck(self._mousereleased, button)
end

function InputController:mouseIsDown(button)
	return (self._mousedown[button] ~= nil)
end

function InputController:gamepadIsPressed(joystick, button)
	local id = joystick:getID()
	return inputCheck(self._gamepadpressed[id], button)
end

function InputController:gamepadIsReleased(joystick, button)
	local id = joystick:getID()
	return inputCheck(self._gamepadreleased[id], button)
end

function InputController:gamepadIsDown(joystick, button)
	local id = joystick:getID()
	if (self._gamepaddown[id] == nil) then return false end
	return (self._gamepaddown[id][button] ~= nil)
end

function InputController:gamepadAxisValue(joystick, axis)
	local id = joystick:getID()
	if (self._gamepadaxis[id] == nil) then return false end
	return self._gamepadaxis[id][axis] or 0
end

function InputController:actionIsPressed(action)
	return inputCheck(self._actionpressed, action)
end

function InputController:actionIsReleased(action)
	return inputCheck(self._actionreleased, action)
end

function InputController:actionIsDown(action)
	return (self._actiondown[action] ~= nil)
end

-------------------------------------------------
-------------- Input callbacks ------------------
-------------------------------------------------

-- keys

function InputController:addKeyPressCallback(id, key, func)
	if not self._keypresscalls[key] then
		self._keypresscalls[key] = {}
	end
	self._keypresscalls[key][id] = func
end

function InputController:removeKeyPressCallback(id)
	for k, v in pairs(self._keypresscalls) do
		if (v[id]) then
			self._keypresscalls[k][id] = nil
		end
	end
end

function InputController:addKeyReleaseCallback(id, key, func)
	if not self._keyreleasecalls[key] then
		self._keyreleasecalls[key] = {}
	end
	self._keyreleasecalls[key][id] = func
end

function InputController:removeKeyReleaseCallback(id)
	for k, v in pairs(self._keyreleasecalls) do
		if (v[id]) then
			self._keyreleasecalls[k][id] = nil
		end
	end
end

-- mouse

function InputController:addMousePressCallback(id, button, func)
	if not self._mousepresscalls[button] then
		self._mousepresscalls[button] = {}
	end
	self._mousepresscalls[button][id] = func
end

function InputController:removeMousePressCallback(id)
	for k, v in pairs(self._mousepresscalls) do
		if (v[id]) then
			self._mousepresscalls[k][id] = nil
		end
	end
end

function InputController:addMouseReleaseCallback(id, button, func)
	if not self._mousereleasecalls[button] then
		self._mousereleasecalls[button] = {}
	end
	self._mousereleasecalls[button][id] = func
end

function InputController:removeMouseReleaseCallback(id)
	for k, v in pairs(self._mousereleasecalls) do
		if (v[id]) then
			self._mousereleasecalls[k][id] = nil
		end
	end
end

-- gamepad

function InputController:addGamepadPressCallback(id, button, func)
	if not self._gamepadpresscalls[button] then
		self._gamepadpresscalls[button] = {}
	end
	self._gamepadpresscalls[button][id] = func
end

function InputController:removeGamepadPressCallback(id)
	for k, v in pairs(self._gamepadpresscalls) do
		if (v[id]) then
			self._gamepadpresscalls[k][id] = nil
		end
	end
end

function InputController:addGamepadReleaseCallback(id, button, func)
	if not self._gamepadreleasecalls[button] then
		self._gamepadreleasecalls[button] = {}
	end
	self._gamepadreleasecalls[button][id] = func
end

function InputController:removeGamepadReleaseCallback(id)
	for k, v in pairs(self._gamepadreleasecalls) do
		if (v[id]) then
			self._gamepadreleasecalls[k][id] = nil
		end
	end
end

function InputController:addGamepadAxisCallback(id, axis, func)
	if not self._gamepadaxiscalls[axis] then
		self._gamepadaxiscalls[axis] = {}
	end
	self._gamepadaxiscalls[axis][id] = func
end

function InputController:removeGamepadAxisCallback(id)
	for ax, v in pairs(self._gamepadaxiscalls) do
		if (v[id]) then
			self._gamepadaxiscalls[ax][id] = nil
		end
	end
end

-- bound actions

function InputController:addActionPressCallback(id, action, func)
	if not self._actionpresscalls[action] then
		self._actionpresscalls[action] = {}
	end
	self._actionpresscalls[action][id] = func
end

function InputController:removeActionPressCallback(id)
	for k, v in pairs(self._actionpresscalls) do
		if (v[id]) then
			self._actionpresscalls[k][id] = nil
		end
	end
end

function InputController:addActionReleaseCallback(id, action, func)
	if not self._actionreleasecalls[action] then
		self._actionreleasecalls[action] = {}
	end
	self._keyreleasecalls[action][id] = func
end

function InputController:removeActionReleaseCallback(id)
	for k, v in pairs(self._actionreleasecalls) do
		if (v[id]) then
			self._actionreleasecalls[k][id] = nil
		end
	end
end

return InputController