------------------------
-- CollisionResolver [mixin](https://github.com/kikito/middleclass/wiki/Mixins). 
-- Apply to classes to give them callbacks for physics collisions.
-- @mixin CollisionResolver

local CollisionResolver = {}

function CollisionResolver:beginContactWith( other, contact, myFixture, otherFixture, selfIsFirst )

end

function CollisionResolver:endContactWith( other, contact, myFixture, otherFixture, selfIsFirst )
	
end

function CollisionResolver:preSolveWith( other, contact, myFixture, otherFixture, selfIsFirst )

end

function CollisionResolver:postSolveWith( other, contact, myFixture, otherFixture, selfIsFirst )
	
end

return CollisionResolver