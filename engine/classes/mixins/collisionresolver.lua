------------------------
-- CollisionResolver [mixin](https://github.com/kikito/middleclass/wiki/Mixins). 
-- Apply to classes to give them callbacks for physics collisions.
-- See [World:setCallbacks](https://www.love2d.org/wiki/World:setCallbacks) for more info.
-- @mixin CollisionResolver
-- @usage local MyClass = class("MyClass")
-- MyClass:include(PhysicsBody)
-- MyClass:include(CollisionResolver)
-- 
-- ..... -- leaving out physics body creation and stuff
--
-- -- print "yay collision" if we collide with another instance of this class
-- function MyClass:beginContactWith( other, contact, myFixture, otherFixture, selfIsFirst )
-- 	if (other:isInstanceOf(MyClass)) then
-- 		print("yay collision!")
-- 	end
-- end

--- @type CollisionResolver
local CollisionResolver = {}

--- Gets called when two fixtures begin to overlap.
-- @tparam Object other object collided with
-- @tparam Contact contact the [Contact](https://www.love2d.org/wiki/Contact) object
-- @tparam Fixture myFixture the [Fixture](https://www.love2d.org/wiki/Fixture) of this object that collided
-- @tparam Fixture otherFixture the [Fixture](https://www.love2d.org/wiki/Fixture) of the other object that collided
-- @bool selfIsFirst whether this object was the first objected reported in the collision. Useful for processing collision logic only once in case both objects have a CollisionResolver that was called.
function CollisionResolver:beginContactWith( other, contact, myFixture, otherFixture, selfIsFirst )

end

--- Gets called when two fixtures cease to overlap. This will also be called outside of a world update, when colliding objects are destroyed.
-- @tparam Object other object collided with
-- @tparam Contact contact the [Contact](https://www.love2d.org/wiki/Contact) object
-- @tparam Fixture myFixture the [Fixture](https://www.love2d.org/wiki/Fixture) of this object that collided
-- @tparam Fixture otherFixture the [Fixture](https://www.love2d.org/wiki/Fixture) of the other object that collided
-- @bool selfIsFirst whether this object was the first objected reported in the collision. Useful for processing collision logic only once in case both objects have a CollisionResolver that was called.
function CollisionResolver:endContactWith( other, contact, myFixture, otherFixture, selfIsFirst )
	
end

--- Gets called before a collision gets resolved.
-- @tparam Object other object collided with
-- @tparam Contact contact the [Contact](https://www.love2d.org/wiki/Contact) object
-- @tparam Fixture myFixture the [Fixture](https://www.love2d.org/wiki/Fixture) of this object that collided
-- @tparam Fixture otherFixture the [Fixture](https://www.love2d.org/wiki/Fixture) of the other object that collided
-- @bool selfIsFirst whether this object was the first objected reported in the collision. Useful for processing collision logic only once in case both objects have a CollisionResolver that was called.
function CollisionResolver:preSolveWith( other, contact, myFixture, otherFixture, selfIsFirst )

end

--- Gets called after the collision has been resolved.
-- @tparam Object other object collided with
-- @tparam Contact contact the [Contact](https://www.love2d.org/wiki/Contact) object
-- @tparam Fixture myFixture the [Fixture](https://www.love2d.org/wiki/Fixture) of this object that collided
-- @tparam Fixture otherFixture the [Fixture](https://www.love2d.org/wiki/Fixture) of the other object that collided
-- @bool selfIsFirst whether this object was the first objected reported in the collision. Useful for processing collision logic only once in case both objects have a CollisionResolver that was called.
function CollisionResolver:postSolveWith( other, contact, myFixture, otherFixture, selfIsFirst )
	
end

return CollisionResolver