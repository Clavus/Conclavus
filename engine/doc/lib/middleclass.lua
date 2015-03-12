------------------------
-- Class library.
-- @lib middleclass

-- THIS IS A FAKE IMPLEMENTATION JUST TO ASSIST DOCUMENTATION GENERATION. DO NOT INCLUDE IN THE FRAMEWORK.

--- Create a new class.
-- @string class name
-- @tparam[opt=Object] class parent parent class
-- @treturn class new class
-- @usage local MyParent = class("MyParent")
-- function MyParent:shout() 
-- 	print("hello!")
-- end
-- 
-- local MyClass = class("MyClass", MyParent)
-- local obj = MyClass() -- create an instance of MyClass
-- obj:shout() -- prints "hello!"
function class( name, parent )
end