------------------------
-- Object class
-- The parent class from which all other classes are derived. See the [middleclass documentation](https://github.com/kikito/middleclass/wiki) for more information.
-- @cl Object

-- THIS IS A FAKE IMPLEMENTATION JUST TO ASSIST DOCUMENTATION GENERATION. DO NOT INCLUDE IN THE FRAMEWORK.

--- @type Object
local Object = class("Object")

--- Returns if object is an instance of the specified class.
-- @tparam class class
-- @treturn bool
function Object:isInstanceOf( class )
	
end

--- Returns if object is in a subclass of the specified class.
-- @tparam class class
-- @treturn bool
function Object:isSubclassOf( class )
	
end

--- Returns true if this object uses this mixin.
-- @tparam Mixin mixin
-- @treturn bool
function Object:includes( mixin )
	
end